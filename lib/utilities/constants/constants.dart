import 'package:trim_time/views/faq/faq.dart';

const CLIENT_ID =
    '132866959008-ivs96rvps42v8s1dgo9bsbvecnuj01a1.apps.googleusercontent.com';

List<String> genders = ['male', 'female'];

List<int> openingTimes = [11, 12, 13, 14, 15, 16];
List<int> closingTimes = [17, 18, 19, 20, 21, 22, 23];

const DEFAULT_PROFILE_IMAGE =
    'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?size=338&ext=jpg&ga=GA1.1.2116175301.1717804800&semt=ais_user';

num GST_PERCENTAGE = (18 / 100);

final List<FAQ> faqItems = [
  FAQ(
    question: "How long does it take for the barber to approve a booking?",
    answer:
        "It typically takes approximately 10 minutes for the barber to approve a booking.",
  ),
  FAQ(
    question:
        "How much is the advance payment required for booking an appointment?",
    answer:
        "A user has to pay 60% of the total amount in advance to successfully book an appointment.",
  ),
  FAQ(
    question:
        "How much time does a user have to make the payment after booking?",
    answer:
        "A user must pay within 5 minutes once the barber has approved the booking; otherwise, the booking will be cancelled.",
  ),
  FAQ(
    question: "What happens if a user does not pay within the allotted time?",
    answer:
        "If a user does not pay within the allotted time, the booking for that time slot will be cancelled.",
  ),
  FAQ(
    question: "Is there any customer support option available?",
    answer:
        "Yes, there is a 'Customer Support' section in our app, or you can directly send your queries to our contact +92(307)0075922",
  ),
];
