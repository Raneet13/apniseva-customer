# Razorpay fix
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Kotlin metadata fixes
-keep class kotlin.Metadata { *; }

# Annotation issues fix
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

# Desugaring compatibility
-dontwarn java.time.**
