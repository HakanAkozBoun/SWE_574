from django.contrib.auth.models import User
from ..models import UserBookmark, blog

def get_recommendations(user):
    # Get all recipes liked by the user
    currentUser_bookmarks = UserBookmark.objects.filter(user=user) 
    currentUser_bookmark_ids = set(user_bookmark.blog_id for user_bookmark in currentUser_bookmarks) 

    similar_users = User.objects.exclude(id=user.id)  # queries all users except the current user (excluding the current user's ID)
    recommendations = []

    for other_user in similar_users:
        other_user_bookmarks = UserBookmark.objects.filter(user=other_user) # get all the bookmarks of the other user
        other_user_bookmark_ids = set(user_bookmark.blog_id for user_bookmark in other_user_bookmarks) # get the IDs of the bookmarks of the other user and store them in a set

        # Checks if the other user has any bookmarks in common with the current user
        have_same_blog_bookmarks = blog.objects.filter(id__in=other_user_bookmark_ids).filter(id__in=currentUser_bookmark_ids)
        
        # If the other user has any bookmarks in common with the current user, recommend the other user's bookmarks that the current user has not bookmarked
        if (len(have_same_blog_bookmarks) > 0):
            recommended_items = blog.objects.filter(id__in=other_user_bookmark_ids - currentUser_bookmark_ids)
            recommendations.extend(recommended_items)

    return recommendations