Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DE1C433E6
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B6774238EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6774238EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 658FC4B240;
	Fri, 15 Jan 2021 12:19:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ph5LFGWD2PRz; Fri, 15 Jan 2021 12:19:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A29D4B266;
	Fri, 15 Jan 2021 12:19:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10F564B228
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UUWv0wqc5H0l for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 12:19:13 -0500 (EST)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5DE74B1B1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:13 -0500 (EST)
Received: by mail-qv1-f74.google.com with SMTP id x19so8274434qvv.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=dbukutgYzHT9MiWfvULK4mqHhSiWytSaif6tz/CiEZM=;
 b=o5x+TKeEjPaVlxVW2WwM7smd2sabHdLTnC8LFV1VrZQ/GGd4Bgqar1ue6KnB83naGM
 MJT/HcEcZkF+D0O1RZQx8Y1GwomJ6XnuSWTYL0NEttffqFoWwA+fVJhe+Y2sP/jwHFXK
 LM3I0Iasp3fRNiQMEpuS/VH3E8cWKObdLfSP4yNdHw1DzrecpCrtArsNMvVchBJqI8SF
 mWo6vbOqPdhLmriUmNoOOUNjqLKR6SmKIirmIAnCV2/PvV+vpiAFpTYjRByIy3cSPSLK
 /d3ZiripFD1TXXle8YUHzFq0zkpAbs4aGPx+spj4dKEkZ8zz4Pp0TzP4ASQz1o5xy8XX
 0fwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=dbukutgYzHT9MiWfvULK4mqHhSiWytSaif6tz/CiEZM=;
 b=GcxN6hi7529lCHyBXsglVqWqXtoURgbkWFfLSuPnIMfZEVR4T5j/U4dIdd9QADmhGW
 WKcxZqvE9qXI9fbkmJLe0/nZGcmNcISBzhq5LICBNS0NtW//QmuBPFbBbCrYThLXcBMu
 GTdEJti1g9o5zs9253tYjnRkCPBOOj94muQez6SZmrtRulvOITBu4riu5GN+vaxj/eAg
 cIfhXQAjtMRKm+v7WUpDm1GKm2cHoRhvRKpfvwh//Q5V68H9p//c4AeUcvBcKO/FT+N1
 xl9w5Un73qmyTmUtL6rf16etqpArm07tpS8rMEHfT63+31fQlaXTyKl6Pm6UdwS5dtBz
 HLcA==
X-Gm-Message-State: AOAM530THHKSpPRftOASIpVkFMs5IDjsP22gwooH/A3IPigwIgvJ35/0
 Z+O/5ga+F4110Z2Np7PPnW1vcPuLRiQR4dL50+HUscPejwJoSLucVzmf53AFdKtk7VCxtkn+2+V
 ChpkgZmm9oIxjftjJVN6YC4nJZyQXb+laY3sV6LsgQdQFFeVk7yY0YrO6mCp/AIAtL9yzokvF
X-Google-Smtp-Source: ABdhPJyQcMFM2gScJdAyiUCENJPpKRcOpuNpdPzq/hrwPtvifyN9mwpzU1Ikbkzr28w4TO2zS8LDW0ssH6cR
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:ad4:5901:: with SMTP id
 ez1mr13147103qvb.6.1610731153435; Fri, 15 Jan 2021 09:19:13 -0800 (PST)
Date: Fri, 15 Jan 2021 17:18:29 +0000
In-Reply-To: <20210115171830.3602110-1-lenaptr@google.com>
Message-Id: <20210115171830.3602110-9-lenaptr@google.com>
Mime-Version: 1.0
References: <20210115171830.3602110-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
Subject: [PATCH v3 8/9] KVM: arm64: Detect arithmetic overflow is inside
 hyp/nVHE.
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

Whenever an arithmetic overflow: addition, substraction, multiplication,
division or negating happens inside the hyp/nVHE code,
an __ubsan_handle_*_overflow is called.

All the overflow handlers are sharing the same structure called
overflow_data.

Signed-off-by: George Popescu <georgepope@google.com>
Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h | 10 ++++++--
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 40 ++++++++++++++++++++++++++----
 arch/arm64/kvm/kvm_ubsan_buffer.c  | 20 ++++++++++++++-
 3 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index 93c1b695097a..da4a3b4e28e0 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -22,7 +22,8 @@ struct kvm_ubsan_info {
 		UBSAN_UNREACHABLE_DATA,
 		UBSAN_SHIFT_OUT_OF_BOUNDS,
 		UBSAN_INVALID_DATA,
-		UBSAN_TYPE_MISMATCH
+		UBSAN_TYPE_MISMATCH,
+		UBSAN_OVERFLOW_DATA
 	} type;
 	union {
 		struct out_of_bounds_data out_of_bounds_data;
@@ -30,6 +31,7 @@ struct kvm_ubsan_info {
 		struct shift_out_of_bounds_data shift_out_of_bounds_data;
 		struct invalid_value_data invalid_value_data;
 		struct type_mismatch_data type_mismatch_data;
+		struct overflow_data overflow_data;
 	};
 	union {
 		struct ubsan_values u_val;
@@ -41,4 +43,8 @@ void __ubsan_handle_builtin_unreachable(void *_data);
 void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs);
 void __ubsan_handle_load_invalid_value(void *_data, void *val);
 void __ubsan_handle_type_mismatch(struct type_mismatch_data  *_data, void *ptr);
-
+void __ubsan_handle_add_overflow(void *data, void *lhs, void *rhs);
+void __ubsan_handle_sub_overflow(void *data, void *lhs, void *rhs);
+void __ubsan_handle_mul_overflow(void *data, void *lhs, void *rhs);
+void __ubsan_handle_negate_overflow(void *_data, void *old_val);
+void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index a9f72d4bcab7..f16842ff7316 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -47,15 +47,45 @@ static void write_type_mismatch_data(struct type_mismatch_data_common *data, voi
 	}
 }
 
-void __ubsan_handle_add_overflow(void *_data, void *lhs, void *rhs) {}
+static void write_overflow_data(struct overflow_data *data, void *lval, void *rval, char op)
+{
+	struct kvm_ubsan_info *slot = kvm_ubsan_buffer_next_slot();
+
+	if (slot) {
+		slot->type = UBSAN_OVERFLOW_DATA;
+		slot->overflow_data = *data;
+		slot->u_val.op = op;
+		slot->u_val.lval = lval;
+		if (op != '!')
+			slot->u_val.rval = rval;
+	}
+}
+
+void __ubsan_handle_add_overflow(void *_data, void *lhs, void *rhs)
+{
+	write_overflow_data(_data, lhs, rhs, '+');
+}
 
-void __ubsan_handle_sub_overflow(void *_data, void *lhs, void *rhs) {}
+void __ubsan_handle_sub_overflow(void *_data, void *lhs, void *rhs)
+{
+	write_overflow_data(_data, lhs, rhs, '-');
+}
 
-void __ubsan_handle_mul_overflow(void *_data, void *lhs, void *rhs) {}
+void __ubsan_handle_mul_overflow(void *_data, void *lhs, void *rhs)
+{
+	write_overflow_data(_data, lhs, rhs, '*');
+}
 
-void __ubsan_handle_negate_overflow(void *_data, void *old_val) {}
+void __ubsan_handle_negate_overflow(void *_data, void *old_val)
+{
+	write_overflow_data(_data, old_val, NULL, '!');
+}
+
+void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs)
+{
+	write_overflow_data(_data, lhs, rhs, '/');
+}
 
-void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs) {}
 
 void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr)
 {
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index b7823dedf8b1..2c7060cbb48b 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -39,7 +39,25 @@ void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
 		__ubsan_handle_type_mismatch(&slot->type_mismatch_data,
 				slot->u_val.lval);
 		break;
-    	}
+	case UBSAN_OVERFLOW_DATA:
+		if (slot->u_val.op == '/') {
+			__ubsan_handle_divrem_overflow(&slot->overflow_data,
+					slot->u_val.lval, slot->u_val.rval);
+		} else if (slot->u_val.op == '!') {
+			__ubsan_handle_negate_overflow(&slot->overflow_data,
+					slot->u_val.lval);
+		} else if (slot->u_val.op == '+') {
+			__ubsan_handle_add_overflow(&slot->overflow_data,
+					slot->u_val.lval, slot->u_val.rval);
+		} else if (slot->u_val.op == '-') {
+			__ubsan_handle_sub_overflow(&slot->overflow_data,
+					slot->u_val.lval, slot->u_val.rval);
+		} else if (slot->u_val.op == '*') {
+			__ubsan_handle_mul_overflow(&slot->overflow_data,
+					slot->u_val.lval, slot->u_val.rval);
+		}
+		break;
+    }
 }
 
 void iterate_kvm_ubsan_buffer(unsigned long left, unsigned long right)
-- 
2.30.0.296.g2bfb1c46d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
