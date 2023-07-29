Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DC07C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:43 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d063bd0bae8so2505730276.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591062; x=1691195862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uqgzEcKwgDl6AmVuFP39+si1T3Ya5yGv/aLgXdHyXDE=;
        b=fvI3egsPRdl7x5TIjH2EOrD2f/T/HclIL2aPO34GGiSzGBfdKdwjZp9XOdOAfFV8De
         GaIg88nJGpbUijVUqQfVh711UtHGpq+25x5CvLvNnNO3IoPjD9jcqBPgKr2KOMAHNnur
         sd5TKdQxtbsVsfSJGVH+CfR8faEfr/z3bWeqvcqfnC8AtS4FqO2XnqnvANwkVYlTPXaK
         tqt1jtFPvLLM7FXra00twXW1xp6756sf8zJNZuMVsgXomcI0pvusFdGrQ4cq54QQn85s
         YcZ0QQ4IH7klbQ/xFgqvH//siGtJktYv2CFC7ukfKe6FPmsnWvYDyMp3atHnSZ/wqL4V
         BRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591062; x=1691195862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uqgzEcKwgDl6AmVuFP39+si1T3Ya5yGv/aLgXdHyXDE=;
        b=PJicuwpITFaxvzXkE/bZT272u2eTEqHLwYsFrvFEKrDop36nvYGX1Ohf6fYleQwbl1
         teEpWx18bKg5j2vycwS6It67sF6Y7TEEq/ymmt0Wxv1miosFOosZdPehyml+Az3gq781
         wEcY34saNk59f8BN2cMhcbQFw/ZXbBkBJEIRROsRlR6hayjl8VCMIBTVsIIaGQVyucnc
         oHbVhgN+yqwahkro8gWgvaGgR8yunLwrTYKSZ2cQW0V6hi0eg1HBrNPcqatveb5Zax+7
         wyptxoOLs/dBt7QPYYrrCatQ0gwVKSEKDB17vYOuSFXE62uy/MFghJZlZZUsZrQn1XNL
         wOqg==
X-Gm-Message-State: ABy/qLa3tekCswzIqMr4ysRqZDxd/jWJVQpuIvLXRtII6oOHEtrKFFMI
	OeXVdunaf03W7wCXJJL/4lo+z0Cwvko=
X-Google-Smtp-Source: APBJJlFp9nYWKpggRzizNGYb14R0ndrG6M0izrvCDXNzuc4knf79MqpcnRtOW+PdyQ9R6qKjQkDx4s+6iCg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dc94:0:b0:c10:8d28:d3ae with SMTP id
 y142-20020a25dc94000000b00c108d28d3aemr17101ybe.8.1690591062181; Fri, 28 Jul
 2023 17:37:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:38 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-30-seanjc@google.com>
Subject: [PATCH v4 29/34] KVM: selftests: Convert the x86 userspace I/O test
 to printf guest assert
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert x86's userspace I/O test to use printf-based guest asserts.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/userspace_io_test.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
index 0cb51fa42773..2c5d2a18d184 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -20,8 +22,8 @@ static void guest_ins_port80(uint8_t *buffer, unsigned int count)
 		end = (unsigned long)buffer + 8192;
 
 	asm volatile("cld; rep; insb" : "+D"(buffer), "+c"(count) : "d"(0x80) : "memory");
-	GUEST_ASSERT_1(count == 0, count);
-	GUEST_ASSERT_2((unsigned long)buffer == end, buffer, end);
+	GUEST_ASSERT_EQ(count, 0);
+	GUEST_ASSERT_EQ((unsigned long)buffer, end);
 }
 
 static void guest_code(void)
@@ -43,7 +45,9 @@ static void guest_code(void)
 	memset(buffer, 0, sizeof(buffer));
 	guest_ins_port80(buffer, 8192);
 	for (i = 0; i < 8192; i++)
-		GUEST_ASSERT_2(buffer[i] == 0xaa, i, buffer[i]);
+		__GUEST_ASSERT(buffer[i] == 0xaa,
+			       "Expected '0xaa', got '0x%x' at buffer[%u]",
+			       buffer[i], i);
 
 	GUEST_DONE();
 }
@@ -91,7 +95,7 @@ int main(int argc, char *argv[])
 	case UCALL_DONE:
 		break;
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "argN+1 = 0x%lx, argN+2 = 0x%lx");
+		REPORT_GUEST_ASSERT(uc);
 	default:
 		TEST_FAIL("Unknown ucall %lu", uc.cmd);
 	}
-- 
2.41.0.487.g6d72f3e995-goog

