Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F04C43461
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14D7D21D1A
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="tSsBMUWs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14D7D21D1A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5B9D4B5A5;
	Mon, 14 Sep 2020 13:28:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NQ7GMroNVfEB; Mon, 14 Sep 2020 13:28:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B7A84B5B0;
	Mon, 14 Sep 2020 13:28:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7435B4B565
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EYfZt4VhJ3Zh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:16 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6425E4B5A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:16 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id a17so506489wrn.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=VE4tiaYIO2WH178ygWtKyTutOHC4+8KlDDbyhHM4F14=;
 b=tSsBMUWsMvg8+rPbGLC3iYKX0M9xTuJCgz8t9VzFY/lPy2b722XAFrOELq7cSNpIxk
 N9S5vrz2VcmU/j3WqAfHtIo7s+KuY8ak7B/tAU5NAvf54fH1rh0GHPJ6ElKhZGk3Mdw2
 ZyUng2UvYJ18NYurvGMI2vrPFIihzVaGyJOS8jOH2ePwigt8T84XvtwVOp5ByrQLnaXd
 SxgwfYEnrlmxDAAm/fq1xJgaWOPKHUMNCKDRSG5G7oYbjiJGUMoAY65TE+vuPGm9bag9
 Lh14EdLD9IpUB/n0nxNhI+Mj+Hx5DMLpZMQ3zlrmushDlXv2bFwUMuUlbzXDmKDYSRNl
 l23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=VE4tiaYIO2WH178ygWtKyTutOHC4+8KlDDbyhHM4F14=;
 b=D6m9ClOamtstm8Pa3Bl7jpoSxS+HF/CSgXRRHl+k9vdHRJNNCD3W+gV++/1eFOVsgB
 9jscdN9dF8hg0N3ylwscb488JCBKQs5/EOA7pKUY7SMJMIwGcyPEaKZUwtZ3KR/L8AUt
 S5iXkKN3HOUk0yDtqP7EdZShRCr9deRniZAyXUptCTKGBUXfhj9iJVc6iDdoaeKvywp2
 W9ze+7YLjoVVLMYB8UfNNNl28s5z3K9QvCWNk5RsC6pUqQT/iyXkyGXOa9YbEnRUIGNl
 iVNeJGDg5rSTqsqQTqxx4UxNtL2IvAujNcYR9sWfwXrlhAVEkR+3HGCLU5eCF3QtIBXh
 0kJQ==
X-Gm-Message-State: AOAM530ritqnAEFG2VF/UZp09kE0mIQUTp5usoGWyWZ3IPZi4nROXzq2
 QwPedv3IgNA3eDFjA4ZrA3M7Lg==
X-Google-Smtp-Source: ABdhPJwDp0qDmVhRrvPNjBrZkX56Whr339QzJq0eZ5FLOChOIB1ToFOdRxzoHsQ+yPW+W6ciFtGbiw==
X-Received: by 2002:a5d:50c3:: with SMTP id f3mr16765517wrt.125.1600104495500; 
 Mon, 14 Sep 2020 10:28:15 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id e1sm15404359wrp.49.2020.09.14.10.28.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:28:14 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 07/14] KVM: arm64: Enable UBSAN_BOUNDS for the both the kernel
 and hyp/nVHE
Date: Mon, 14 Sep 2020 17:27:43 +0000
Message-Id: <20200914172750.852684-8-georgepope@google.com>
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

If an out of bounds happens inside the hyp/nVHE code, the
ubsan_out_of_bounds handler stores the logging data inside the
kvm_ubsan_buffer. The one responsible for printing is the kernel
ubsan_out_of_bounds handler. The process of decapsulating the data happens
in kvm_ubsan_buffer.c.

The struct kvm_ubsan_info contains three main components:
-enum type, which is used to identify which handler to call from the
kernel.
-struct ubsan_values, which stores the operands involved during the
undefined behaviours, which can be one, two or zero, depending on what
undefiend behaviour is reported. As an example for: out_of_bounds there
is only one operand (the index).

Accessing a slot with no type should do nothing. Each slot is marked
with the UBSAN_NONE tag after it's first usage.

Signed-off-by: George Popescu <georgepope@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h | 19 ++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 13 ++++++++++++-
 arch/arm64/kvm/kvm_ubsan_buffer.c  | 13 ++++++++++++-
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index af607a796376..575881e0bd5f 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -11,7 +11,24 @@
 #define UBSAN_MAX_TYPE 6
 #define KVM_UBSAN_BUFFER_SIZE 1000
 
+struct ubsan_values {
+	void *lval;
+	void *rval;
+	char op;
+};
+
 struct kvm_ubsan_info {
-	int type;
+	enum {
+		UBSAN_NONE,
+		UBSAN_OUT_OF_BOUNDS
+	} type;
+	union {
+		struct out_of_bounds_data out_of_bounds_data;
+	};
+	union {
+		struct ubsan_values u_val;
+	};
 };
 #endif
+
+void __ubsan_handle_out_of_bounds(void *_data, void *index);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index a43c9646e1e8..b2d3404f6215 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -43,7 +43,18 @@ void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr) {}
 
 void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr) {}
 
-void __ubsan_handle_out_of_bounds(void *_data, void *index) {}
+void __ubsan_handle_out_of_bounds(void *_data, void *index)
+{
+	struct kvm_ubsan_info *slot = NULL;
+	struct out_of_bounds_data *data = _data;
+
+	slot = kvm_ubsan_buffer_next_slot();
+	if (slot) {
+		slot->type = UBSAN_OUT_OF_BOUNDS;
+		slot->out_of_bounds_data = *data;
+		slot->u_val.lval = index;
+	}
+}
 
 void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs) {}
 
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index 28dcf19b5706..ce796bdd027e 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -16,6 +16,17 @@
 
 DECLARE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buff, KVM_UBSAN_BUFFER_SIZE);
 
+void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
+{
+	switch (slot->type) {
+	case UBSAN_NONE:
+		break;
+	case UBSAN_OUT_OF_BOUNDS:
+		__ubsan_handle_out_of_bounds(&slot->out_of_bounds_data,
+				slot->u_val.lval);
+		break;
+	}
+}
 
 void __kvm_check_ubsan_buffer(void)
 {
@@ -25,7 +36,7 @@ void __kvm_check_ubsan_buffer(void)
 
 	init_kvm_debug_buffer(kvm_ubsan_buff, struct kvm_ubsan_info, slot, write_ind);
 	for_each_kvm_debug_buffer_slot(slot, write_ind, it) {
-		/* check ubsan data */
+		__kvm_check_ubsan_data(slot);
 		slot->type = 0;
 	}
 }
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
