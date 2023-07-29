Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F0D38E
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:36:51 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-583a89cccf6so26730637b3.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591010; x=1691195810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PdMhF3+dbu8TQ3iqZdPs1TdexnvVx+yUupHryp41YZs=;
        b=g48/ENXsZE3ltSl/IkRKy7TA29P1cX8hWNyuXQnOISi+o77fY0rzEcEpSaUCGzHtbC
         PhFE3nvUYKdM+6pL08G0PIiG/YDC0ZfEhHxCv90zQYJNzPUm015+GM8Ijwd4pGJIOXH3
         yTpeOeHTHgFfv3+kFWRtYrvW4JAD+m3tSo+Pxr/TbHE8msuKXqOmrPh8c4IM0wy/t+uw
         mx1NhRmD4Yg573qf2o0VyjOuMvUaDiRQsccLWxEQqeHf98TR2+Q5dM0FleJ1LtBbFwYD
         745nuvDW6t0CkMPbv9trtc4Ozl5io5Xc1LwmNLArSe2A/F0whCXtl59d8/f6Aot9QnOI
         5ahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591010; x=1691195810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PdMhF3+dbu8TQ3iqZdPs1TdexnvVx+yUupHryp41YZs=;
        b=FQzc9U573c4E9yVooxKAwwH8m4lI3LaxgdOyOVwQprhgbbs3hK12bVKIweuVpCicOO
         ezRWAXpEvF5snlNTXjHQkqeZ7JkiFSRKb3BIawkAxZJPNsowwBXRNn5/kDdsvvMMzM4r
         emydhHaN2MJmHChVdBYTdDcm9hUKWYIPgsga4qE60L+EGmeu7gRyGXA5b1mbSwtzK8Fj
         O+ljx4baWXg8Iu7Dw3XI8Sfdn1OSip5M1drX8O0DtB7StzlMzz63qf697KoeL8Fplnhx
         tWdkFGsgGIcunOcamNRu9HavyfBJZrYiuhFrIkF7UYN2SzjQNeqgDub9t0TYzm4bDigS
         UERg==
X-Gm-Message-State: ABy/qLYi2rEYTAh1I0q7C/6sIkkndAQ9qA9XYS2JHRQ6jzQQN3cK5S2s
	jttwtVUWsy/hpgRWchxsrDhFj+qbK2g=
X-Google-Smtp-Source: APBJJlGuzgz3q+P1cDjpB54/biLUxD1UZvVtGqhl9fq0g3fJKAZGyLsES9Mt8giS31GV85E5u4iJ8Uv2pTE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2083:0:b0:d0d:4910:cf0b with SMTP id
 g125-20020a252083000000b00d0d4910cf0bmr18518ybg.10.1690591010455; Fri, 28 Jul
 2023 17:36:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:11 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-3-seanjc@google.com>
Subject: [PATCH v4 02/34] KVM: selftests: Make TEST_ASSERT_EQ() output look
 like normal TEST_ASSERT()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Clean up TEST_ASSERT_EQ() so that the (mostly) raw code is captured in the
main assert message, not the helper macro's code.  E.g. make this:

  x86_64/tsc_msrs_test.c:106: __a == __b
  pid=40470 tid=40470 errno=0 - Success
     1	0x000000000040170e: main at tsc_msrs_test.c:106
     2	0x0000000000416f23: __libc_start_call_main at libc-start.o:?
     3	0x000000000041856f: __libc_start_main_impl at ??:?
     4	0x0000000000401ef0: _start at ??:?
  TEST_ASSERT_EQ(rounded_host_rdmsr(MSR_IA32_TSC), val + 1) failed.
	rounded_host_rdmsr(MSR_IA32_TSC) is 0
	val + 1 is 0x1

look like this:

  x86_64/tsc_msrs_test.c:106: rounded_host_rdmsr(MSR_IA32_TSC) == val + 1
  pid=5737 tid=5737 errno=0 - Success
     1	0x0000000000401714: main at tsc_msrs_test.c:106
     2	0x0000000000415c23: __libc_start_call_main at libc-start.o:?
     3	0x000000000041726f: __libc_start_main_impl at ??:?
     4	0x0000000000401e60: _start at ??:?
  0 != 0x1 (rounded_host_rdmsr(MSR_IA32_TSC) != val + 1)

Opportunstically clean up the formatting of the entire macro.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index e734e52d8a3a..a4bea44f990c 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -53,14 +53,13 @@ void test_assert(bool exp, const char *exp_str,
 #define TEST_ASSERT(e, fmt, ...) \
 	test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
 
-#define TEST_ASSERT_EQ(a, b) do { \
-	typeof(a) __a = (a); \
-	typeof(b) __b = (b); \
-	TEST_ASSERT(__a == __b, \
-		    "TEST_ASSERT_EQ(%s, %s) failed.\n" \
-		    "\t%s is %#lx\n" \
-		    "\t%s is %#lx", \
-		    #a, #b, #a, (unsigned long) __a, #b, (unsigned long) __b); \
+#define TEST_ASSERT_EQ(a, b)						\
+do {									\
+	typeof(a) __a = (a);						\
+	typeof(b) __b = (b);						\
+	test_assert(__a == __b, #a " == " #b, __FILE__, __LINE__,	\
+		    "%#lx != %#lx (%s != %s)",				\
+		    (unsigned long)(__a), (unsigned long)(__b), #a, #b);\
 } while (0)
 
 #define TEST_ASSERT_KVM_EXIT_REASON(vcpu, expected) do {		\
-- 
2.41.0.487.g6d72f3e995-goog

