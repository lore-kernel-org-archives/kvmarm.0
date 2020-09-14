Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1371BC43461
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8DF1621D41
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="FSOe1Y/p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DF1621D41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A7C14B59B;
	Mon, 14 Sep 2020 13:28:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vz3x9a596rNY; Mon, 14 Sep 2020 13:28:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F27954B5A3;
	Mon, 14 Sep 2020 13:28:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C710D4B571
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TU0MHDLbp5WJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:08 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 722584B578
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:08 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id g4so515474wrs.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=I6yqR/klZ/NDqjAIsRW35d99E4ctp6zjUJ0+p6Qp1zk=;
 b=FSOe1Y/pA7hRXZNY72c3hBMe/ljMhIxE66K1pTUUVfwNFBvaQYXA0ufNm+qIClk/O+
 vSZsvcN95MRwsi4JST1sCCLEHKfM6IxEY+MgDFP6z9uKuUgcIvWt5hwCegR+9a1Jcv+m
 gH8n0l5ZthmU1P5z+mETgJcgbXbDYJRY1i+0IQl2VaY5ngsnCmqitgyxHOxZkLnS/B7t
 UXFp+ntUx01PcgEYtHtyrccldppKaZ9Ry1m3p4Dc7kdsdGGPgDEoyTew8juouV20fTWo
 Q1wv6gsGClBEW0C3ySzRBVme5tXhbZYou1yowCKvdKf4SFhFjQehcpiWYtQM5a8kPB4j
 BwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=I6yqR/klZ/NDqjAIsRW35d99E4ctp6zjUJ0+p6Qp1zk=;
 b=pWcL99EZFyKweCrEkO9c5/N4MyOjnFiTijI5CRW3a4Y1yVK8a7AqWt8vYeTYiHg883
 n6d024lhauCbxD5OtJPTXOGvtvzZKep2bf5WmdlRpDZ/FCJ6tzoKu/2R29a4S7UrvQG0
 seuLiP1jd8Oe7+0e/usJgOQKoxpMJGckwE9JH2mBTg9OXolqI1BU3LiRmp92Ux7hwrRi
 eFI1O9DVG+QvjdSMKPZwJhT53Wzzlg3iz7WGJkmJYDIZhEropJC5SXt5wplvIFrcTTNW
 8/TJQj+hvzQ6RsSAgEEjOTol5NgsDcFTNImX/Z6uPO3ofziIWNdi0RII1OtA7MM1Ileb
 rNIw==
X-Gm-Message-State: AOAM531d5v5rJr3VqTS+2ZlRTN0pI/YKZmZ1rzB5S0oqhIs7N1USzTkY
 ErQl9cjswAl1u13HuTKFFdQ11Q==
X-Google-Smtp-Source: ABdhPJwcqjA/RfbM7RQw4khYb1A0QPdinAlS/u4JKeOCntEaITKsGnzpJGBE/zpzmvvaUWtI9yB3Ig==
X-Received: by 2002:adf:f586:: with SMTP id f6mr16953275wro.299.1600104487527; 
 Mon, 14 Sep 2020 10:28:07 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id h2sm22418218wrp.69.2020.09.14.10.28.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:28:06 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 03/14] KVM: arm64: Add support for creating and checking a
 logging buffer inside hyp/nVHE
Date: Mon, 14 Sep 2020 17:27:39 +0000
Message-Id: <20200914172750.852684-4-georgepope@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200914172750.852684-1-georgepope@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
MIME-Version: 1.0
Cc: arnd@arndb.de, elver@google.com, tglx@linutronix.de, keescook@chromium.org,
 maskray@google.com, linux-kbuild@vger.kernel.org, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 clang-built-linux@googlegroups.com, broonie@kernel.org, dvyukov@google.com,
 natechancellor@gmail.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: George Popescu <georgepope@google.com>

Share a buffer between the kernel and the hyp/nVHE code by using the
macros from kvm_debug_buffer.h.

The buffer is composed of a writing index and a statically allocated
array. The writing index counts how many elements have been written inside
the buffer and should be set to zero whenever the code goes back to
EL2 with the clear_kvm_debug_buffer macro.

To avoid consistency problems the buffer is defined per_cpu and is designed
to be read-only from the kernel perspective.

Check if there is any logging data from hyp/nVHE code.

Every time when the state returns back to the kernel after an hvc call,
the __kvm_arm_check_debug_buffer macro checks if there is any data inside
one of the predefined buffers.

Signed-off-by: George Popescu <georgepope@google.com>
---
 arch/arm64/include/asm/kvm_debug_buffer.h | 34 +++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h         |  6 ++++
 arch/arm64/kvm/hyp/hyp-entry.S            |  2 +-
 3 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/kvm_debug_buffer.h

diff --git a/arch/arm64/include/asm/kvm_debug_buffer.h b/arch/arm64/include/asm/kvm_debug_buffer.h
new file mode 100644
index 000000000000..30c9b0b1a7bf
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_debug_buffer.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2020 Google LLC
+ * Author: George Popescu <georgepope@google.com>
+ */
+#ifndef __ASSEMBLY__
+
+#include <linux/percpu-defs.h>
+#include <asm/kvm_asm.h>
+
+#ifdef __KVM_NVHE_HYPERVISOR__
+#define DEFINE_KVM_DEBUG_BUFFER(type_name, buff_name, size)             \
+	DEFINE_PER_CPU(type_name, buff_name)[(size)];	                \
+	DEFINE_PER_CPU(unsigned long, buff_name##_wr_ind) = 0
+
+#define DECLARE_KVM_DEBUG_BUFFER(type_name, buff_name, size)            \
+	DECLARE_PER_CPU(type_name, buff_name)[(size)];                  \
+	DECLARE_PER_CPU(unsigned long, buff_name##_wr_ind)
+
+#else
+
+#define DECLARE_KVM_DEBUG_BUFFER(type_name, buff_name, size)            \
+	DECLARE_PER_CPU(type_name, kvm_nvhe_sym(buff_name))[(size)];    \
+	DECLARE_PER_CPU(unsigned long, kvm_nvhe_sym(buff_name##_wr_ind))
+#endif //__KVM_NVHE_HYPERVISOR__
+
+#else
+
+.macro clear_kvm_debug_buffer sym tmp1, tmp2, tmp3
+	mov \tmp1, 0
+	hyp_str_this_cpu \sym, \tmp1, \tmp2, \tmp3
+.endm
+
+#endif // __ASSEMBLY__
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 905c2b87e05a..adc8957e9321 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -494,6 +494,10 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 		__kvm_call_hyp(kvm_ksym_ref_nvhe(f), ##__VA_ARGS__);	\
 	})
 
+#define __kvm_arm_check_debug_buffer()					\
+{									\
+}
+
 /*
  * The couple of isb() below are there to guarantee the same behaviour
  * on VHE as on !VHE, where the eret to EL1 acts as a context
@@ -506,6 +510,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 			isb();						\
 		} else {						\
 			kvm_call_hyp_nvhe(f, ##__VA_ARGS__);		\
+			__kvm_arm_check_debug_buffer();			\
 		}							\
 	} while(0)
 
@@ -518,6 +523,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 			isb();						\
 		} else {						\
 			ret = kvm_call_hyp_nvhe_ret(f, ##__VA_ARGS__);	\
+			__kvm_arm_check_debug_buffer();			\
 		}							\
 									\
 		ret;							\
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 46b4dab933d0..8df0082b9ccf 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -68,7 +68,7 @@ el1_sync:				// Guest trapped into EL2
 	cbnz	x1, el1_hvc_guest	// called HVC
 
 	/* Here, we're pretty sure the host called HVC. */
-	ldp	x0, x1, [sp], #16
+	ldp	x0, x1,	[sp], #16
 
 	/* Check for a stub HVC call */
 	cmp	x0, #HVC_STUB_HCALL_NR
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
