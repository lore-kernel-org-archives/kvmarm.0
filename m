Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E57D7C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:19 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bbb34b091dso18318095ad.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591038; x=1691195838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ghJjf9GWvVyaghDwZhaADSILeZ7gBWODtxQxln/4ffA=;
        b=maWgMmnqFc3YTeKLPqw/lKtakn7FujXRZY95A1ym2PEZu5CChu6IlGjqWTu+fUFqQL
         zoq+6BxgefpGqPBhkpIA9667dZ0ojf+J1Z9g8FjcKPSeSiiOHzLvbec20n5BES71Jtqb
         wvnrEEbr8yJ15dxZILbTZTDn8ql6qUrqqLdFw8ll+n3b3Jqa/MAZ4S8/1ADT3yR/WcD5
         Re4shMEJP08YXyczC/fKfFNAX1MK2uXOch7buigRGpuf+xzqNSnAndSw7DaifRC0T11w
         VSr3iLrJ71YH0QgsEEPIwCl3Lj/e6No/OylV6asvhU1jsps/crBGU7IBVbllYILPlaFg
         1NNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591038; x=1691195838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ghJjf9GWvVyaghDwZhaADSILeZ7gBWODtxQxln/4ffA=;
        b=UUAcuDtwUTfBFdUqezW3sG876REdYEYqXK0r7HEZxUozZ+DlKXVKcbm2TNdd6wVMMo
         hfoXKF3ImZlLUo0UMV4xtYfbueHoZCrlhBGjZtxoeRoHZbuO+9ccSmkG7FQPEGezey9R
         vHoquF6sXGyscRnBNizEPEeAABo9RpbLVgZl7oK9MUlv94ypEsuCXqnrcFmbZOqTe4Fs
         ytwFLb8F8RNoaPdZVrVlKDiNEq/BMJbWaWFqgm6ICC9GAeYTDwcQFb3gcqynys1EDUcA
         lVS+SpG4PW/6AkwYz3duDBBhD2sZWsRbsN83+YpXFDE4s3eunu4jPokpzXlwvA3fAHcb
         AJ1w==
X-Gm-Message-State: ABy/qLaI0er3eXIgT0KWn6fqAdUrrz7E9v69Qv0BLx39ylV98AfJuC/6
	N3FzP7+Bu1XLtUb9tqoF/2TTlCi/8dU=
X-Google-Smtp-Source: APBJJlG3mjhlyW9oaUgafKLtMp/fHKFVRqq4KJoWCUgnjv0myRLm2RNB2iWek9EwOxdFWO2/8Lf46iw8sZg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f683:b0:1b8:a54c:61ef with SMTP id
 l3-20020a170902f68300b001b8a54c61efmr12911plg.9.1690591038706; Fri, 28 Jul
 2023 17:37:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:26 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-18-seanjc@google.com>
Subject: [PATCH v4 17/34] KVM: selftests: Convert s390's tprot test to printf
 style GUEST_ASSERT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert s390's tprot test to printf-based GUEST_ASSERT.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/s390x/tprot.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/tprot.c b/tools/testing/selftests/kvm/s390x/tprot.c
index 40d3ea16c052..c12c6824d963 100644
--- a/tools/testing/selftests/kvm/s390x/tprot.c
+++ b/tools/testing/selftests/kvm/s390x/tprot.c
@@ -4,6 +4,7 @@
  *
  * Copyright IBM Corp. 2021
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #include <sys/mman.h>
 #include "test_util.h"
@@ -156,7 +157,9 @@ static enum stage perform_next_stage(int *i, bool mapped_0)
 		       !mapped_0;
 		if (!skip) {
 			result = test_protection(tests[*i].addr, tests[*i].key);
-			GUEST_ASSERT_2(result == tests[*i].expected, *i, result);
+			__GUEST_ASSERT(result == tests[*i].expected,
+				       "Wanted %u, got %u, for i = %u",
+				       tests[*i].expected, result, *i);
 		}
 	}
 	return stage;
@@ -190,7 +193,7 @@ static void guest_code(void)
 	vcpu_run(__vcpu);					\
 	get_ucall(__vcpu, &uc);					\
 	if (uc.cmd == UCALL_ABORT)				\
-		REPORT_GUEST_ASSERT_2(uc, "hints: %lu, %lu");	\
+		REPORT_GUEST_ASSERT(uc);			\
 	TEST_ASSERT_EQ(uc.cmd, UCALL_SYNC);			\
 	TEST_ASSERT_EQ(uc.args[1], __stage);			\
 })
-- 
2.41.0.487.g6d72f3e995-goog

