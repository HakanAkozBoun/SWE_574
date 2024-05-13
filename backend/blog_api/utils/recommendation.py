from django.contrib.auth.models import User
from ..models import UserBookmark, blog, Follower
'''
# USER_DIET_INFO = {
#     1: {
#         'diet_type': 'vegan',
#     },
#     2: {
#         'diet_type': 'omnivore',
#     },
#     3: {
#         'diet_type': 'omnivore',
#     },
# }

# USER_ALLERGIES_INFO = {
#     1: {
#         'allergies': ['peanuts', 'shellfish'],
#     },
#     2: {
#         'allergies': ['peanuts'],
#     },
#     3: {
#         'allergies': ['shellfish'],
#     },
# }


# def get_diet_goals(user_id):
#     return USER_DIET_INFO.get(user_id, {})

# def get_allergies(user_id):
#     return USER_ALLERGIES_INFO.get(user_id, {})

def get_recommendations(user):
    # Get diet goals for the current user
    # user_diet_goals = get_diet_goals(user.id)

    # Get all recipes liked by the user
    currentUser_bookmarks = UserBookmark.objects.filter(user=user) 
    currentUser_bookmark_ids = set(user_bookmark.blog_id for user_bookmark in currentUser_bookmarks) 

    similar_users = User.objects.exclude(id=user.id)  # queries all users except the current user (excluding the current user's ID)
    recommendations = []

    for other_user in similar_users:
        # Get diet goals for the other user
        other_user_diet_goals = get_diet_goals(other_user.id)

        # Compare diet goals of current user and other user
        if user_diet_goals.get('diet_type') == other_user_diet_goals.get('diet_type'):
            # Get bookmarks of other user
            other_user_bookmarks = UserBookmark.objects.filter(user=other_user)
            other_user_bookmark_ids = set(user_bookmark.blog_id for user_bookmark in other_user_bookmarks)
            
            # Checks if the other user has any bookmarks in common with the current user
            have_same_blog_bookmarks = blog.objects.filter(id__in=other_user_bookmark_ids).filter(id__in=currentUser_bookmark_ids)

            # If the other user has any bookmarks in common with the current user, recommend the other user's bookmarks that the current user has not bookmarked
            if len(have_same_blog_bookmarks) > 0:
                recommended_items = blog.objects.filter(id__in=other_user_bookmark_ids - currentUser_bookmark_ids)
                recommendations.extend(recommended_items)

    return recommendations
'''

def get_recommendations(user):
    recommendations = []
    currentUser_bookmarks = UserBookmark.objects.filter(user=user) 
    currentUser_bookmark_ids = set(user_bookmark.blog_id for user_bookmark in currentUser_bookmarks)
    similar_users = User.objects.exclude(id=user.id)
    for other_user in similar_users:
        other_user_bookmarks = UserBookmark.objects.filter(user=other_user)
        other_user_bookmark_ids = set(user_bookmark.blog_id for user_bookmark in other_user_bookmarks)
        have_same_blog_bookmarks = blog.objects.filter(id__in=other_user_bookmark_ids).filter(id__in=currentUser_bookmark_ids)
        if len(have_same_blog_bookmarks) > 0:
            recommended_items = blog.objects.filter(id__in=other_user_bookmark_ids - currentUser_bookmark_ids)
            recommendations.extend(recommended_items)

    followed_authors = Follower.objects.filter(follower_user=user).values_list('following_user', flat=True)
    recommended_posts = blog.objects.filter(userid__in=followed_authors)
    recommendations.extend(recommended_posts)
    return recommendations