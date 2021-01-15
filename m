Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350B5C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C995A238EE
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C995A238EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 634F34B171;
	Fri, 15 Jan 2021 12:19:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uqWe+cjh4vmT; Fri, 15 Jan 2021 12:19:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4948F4B24B;
	Fri, 15 Jan 2021 12:19:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 969AE4B171
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:18:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gc6+rHy-gYKJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 12:18:58 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA0144B228
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:18:57 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id w8so4426886wrv.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=/8un1Ary21jdPLd+LUk6zbXqqm3VArAc3S7FbSuGJ7M=;
 b=JA9FdkQhxjQG1gw49w0maesw4+ti5fXadr2Pq9t0aXEEkIUFnr+mtX+ZPRryioLTTQ
 ufXKI35Qv4143oJiZ03pZOiJW4C0nD+T2UJHD21bTz/ZqBncZvuqw7RywHlbplN8ubdi
 OPjwcRTE2z0HAJ+M6IAN3c0CzTqyW5Nr9KH5cVTk7RTx4vuxLt8Ip4BYBsSqaOIJaVi+
 DQ/6wlQYfRRGd4+ZEFFmmmPHJjGH4cOU18Jm855txWLIALUp9WPAC9FJUqpExi9dVCY/
 09iJS+eDvTjNHk5QYRigUeLosU5F+HefFR41guZQzpb4hpVI+RxEOrAf4yoR12BrZVbF
 7gfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/8un1Ary21jdPLd+LUk6zbXqqm3VArAc3S7FbSuGJ7M=;
 b=qWzZKuBNrAP7tHJmsURs/KG9i3T2VC9AGy445rNOKlOUTZK+jlJpCa9uKZWx8iNz/B
 qlj7Gtl4NN5w2GeE4FAtu+BLt3htvPhO3VD2abEUKGiTHZjkt01f00vUkSUvtJpP+h9X
 IVJ66aaDzkg2pyC6Un2uP0n6VIKqTkh0O+Uqig1aeEC+eZN+PIvXGquCsxB+9STrccJc
 H9sTs7eDZq5WUYvPFHpW/lhLU5NtJNNnTi21SQHm0qoouMnhbpgoOAFwzHL7Ei1Xtoq/
 BSMW8MMqSTjYjaow3XTYg59J4bKe35/O4jMFUvhA2X9cKZr3bt9oVnSlZsF9YwWy4jaA
 kl1w==
X-Gm-Message-State: AOAM533/s+m5wWP2C+lzHJHSwdn8JE05b+SiHTSlQ+UFOCgyTfIqes2S
 OO2AtE3hWJphvbj2uE4tpVkOWGtpWsAx07t2yPbw8BI+wqsBGGm0Fa4/e6N/PFbF1qorhNREo/M
 XZxRHGcoBprafuxbYMuRFJjyO7XSS0ss3c8XiQxIPIvAMqilCvJDAr0D0WnAaDg4rXe0fTmHT
X-Google-Smtp-Source: ABdhPJzLy46RtKRhJlfnQR0PbFbCxme0w7jH3ufnM4lCPC+V5c3Y6pJYMT8Sxhrrv3zXM6c86O3sE5a05K3D
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a1c:9dcb:: with SMTP id
 g194mr9789599wme.59.1610731135867; Fri, 15 Jan 2021 09:18:55 -0800 (PST)
Date: Fri, 15 Jan 2021 17:18:24 +0000
In-Reply-To: <20210115171830.3602110-1-lenaptr@google.com>
Message-Id: <20210115171830.3602110-4-lenaptr@google.com>
Mime-Version: 1.0
References: <20210115171830.3602110-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
Subject: [PATCH v3 3/9] KVM: arm64: Enable UBSAN_BOUNDS for the both the
 kernel and hyp/nVHE
From: Elena Petrova <lenaptr@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: George Popescu <georgepope@google.com>, Elena Petrova <lenaptr@google.com>,
 Marc Zyngier <maz@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org,
 George Popescu <george.apopescu97@gmail.com>
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

If an out of bounds happens inside the hyp/nVHE code, the ubsan_out_of_bounds
handler stores the logging data inside the kvm_ubsan_buffer. The one responsible
for printing is the kernel ubsan_out_of_bounds handler. The process of
decapsulating the data from the buffer is straightforward.

Signed-off-by: George Popescu <georgepope@google.com>
Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h | 19 ++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 14 ++++++++++++--
 arch/arm64/kvm/kvm_ubsan_buffer.c  | 10 ++++++++++
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index fb32c7fd65d4..4f471acb88b0 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -9,6 +9,23 @@
 #define UBSAN_MAX_TYPE 6
 #define KVM_UBSAN_BUFFER_SIZE 1000
 
+
+struct ubsan_values {
+	void *lval;
+	void *rval;
+	char op;
+};
+
 struct kvm_ubsan_info {
-	int type;
+	enum {
+		UBSAN_OUT_OF_BOUNDS,
+	} type;
+	union {
+		struct out_of_bounds_data out_of_bounds_data;
+	};
+	union {
+		struct ubsan_values u_val;
+	};
 };
+
+void __ubsan_handle_out_of_bounds(void *_data, void *index);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index 8a194fb1f6cf..55a8f6db8555 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -13,7 +13,6 @@
 #include <asm/kvm_ubsan.h>
 #include <asm/kvm_debug_buffer.h>
 #include <kvm/arm_pmu.h>
-#include <ubsan.h>
 
 DEFINE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buffer,
                 kvm_ubsan_buff_wr_ind, KVM_UBSAN_BUFFER_SIZE);
@@ -44,7 +43,18 @@ void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr) {}
 
 void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr) {}
 
-void __ubsan_handle_out_of_bounds(void *_data, void *index) {}
+void __ubsan_handle_out_of_bounds(void *_data, void *index)
+{
+	struct kvm_ubsan_info *slot;
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
index 4a1959ba9f68..a1523f86be3c 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -17,6 +17,15 @@
 DECLARE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buffer,
 		kvm_ubsan_buff_wr_ind, KVM_UBSAN_BUFFER_SIZE);
 
+void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
+{
+	switch (slot->type) {
+	case UBSAN_OUT_OF_BOUNDS:
+		__ubsan_handle_out_of_bounds(&slot->out_of_bounds_data,
+				slot->u_val.lval);
+		break;
+	}
+}
 
 void iterate_kvm_ubsan_buffer(unsigned long left, unsigned long right)
 {
@@ -26,6 +35,7 @@ void iterate_kvm_ubsan_buffer(unsigned long left, unsigned long right)
 	slot = (struct kvm_ubsan_info *) this_cpu_ptr_nvhe_sym(kvm_ubsan_buffer);
 	for (i = left; i < right; ++i) {
 		/* check ubsan data */
+		__kvm_check_ubsan_data(slot + i);
 		slot[i].type = 0;
 	}
 }
-- 
2.30.0.296.g2bfb1c46d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
