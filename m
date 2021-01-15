Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18ECC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7CA06238EE
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CA06238EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D78B4B26A;
	Fri, 15 Jan 2021 12:19:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IzM4MwDzm1Ip; Fri, 15 Jan 2021 12:19:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2FE04B253;
	Fri, 15 Jan 2021 12:19:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAAC34B17A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eCduCWPLZMfd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 12:19:12 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4979F4B251
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:12 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id u3so4381720wri.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=ac9iKnNyoG+yHGcTDAMRhMwUzeXQu2/WPJbZdHzHiDM=;
 b=OAyogaLZUq5MdAiMQ7o6yYDrA4xFWT3n//pON1UcS/hSVpv0bPZGVr5NBg7ZTb4yO6
 Q80Ta+Re6sKynisYOvneXafA6KmueojgT1HmipWZVI/xy5JrRkwc6vI/K2bNA4fGsXzQ
 WLdpwCeoopBmdpGI5TAMS0hrNbHej7j7SweB583NzaooMOTNOWURPog3cFUxUztdNS1f
 gkjb9dYC85KgoaxaumXHIi1kzeGf98swUpoTsXI656EhGUHLtSnpbBgCNdXSHv3o1Jnk
 kIWddWa7f7LK4G00om+EmIdTn2mV3xrf9FpR4lvhLfiOM5kpNLhmIEkegfvDPX06Y13k
 L8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ac9iKnNyoG+yHGcTDAMRhMwUzeXQu2/WPJbZdHzHiDM=;
 b=CkuYdkTjt14LyQ2O7u9vZviB/3jQA/v1Y0AElxykuEKVHXFg5Hn/wY96O6boRtvDnx
 CFab499XAmNneIj3JatjHCoK4HmNkkahOGxdVV+thhmr1+TjOijUveIzbShzJwCGzQIT
 c8wKqz/VI4D3e+0GKDhDigxaVUJ6WnNgya5FOnp+jRZURWNShJZSWuQ0i/AYNZHoMu9S
 TfcWcI+/qypW4AnU7oGz95XhCcjpmlA1oD2SOlh1AoEtZUwUYBd0AFTa2f2aATPzW67G
 nMw4mIjH2VQoTQXgmLw4G3qMJE+bIVPirGSLUULKZ9BNoZdwtjc1Nn8IqPL4u3dZmQ7Y
 7jbw==
X-Gm-Message-State: AOAM530yrZl+TdKYC/acj+ReSS/5DzFXDdTZto3RtYgBiivJdyZ7RQO+
 fg1SvFEQfmV8+6IQ05EFcILSFJ0L2vlhsdn9m8fbnLQDVC6yUqDbarYc5xSAs9M9r68HyImRsQq
 rrk3zb52P35YsyP99aIPD4PqDdAK6jwzWE3xWG4enR2Q0udeenP8UOrhLo/BrcXv0cyPnW2Mw
X-Google-Smtp-Source: ABdhPJx8CnxfxMc88an10BfA7jJXL8kT9++eM18I3b0opJbatRfb/r4GrAI2JcUfytJA5JKRYuFonjSWiQc5
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a7b:c395:: with SMTP id
 s21mr7798201wmj.97.1610731151420; Fri, 15 Jan 2021 09:19:11 -0800 (PST)
Date: Fri, 15 Jan 2021 17:18:28 +0000
In-Reply-To: <20210115171830.3602110-1-lenaptr@google.com>
Message-Id: <20210115171830.3602110-8-lenaptr@google.com>
Mime-Version: 1.0
References: <20210115171830.3602110-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
Subject: [PATCH v3 7/9] KVM: arm64: Detect type mismatch undefined behaviour
 from hyp/nVHE code
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

Type mismatch undefiend behaviour handler provides two handlers with two
data structures type_mismatch_data and type_mismatch_data_v1. Both can be
stored inside a common data structure: type_mismatch_data_common, which
differs of type_mismatch_data only by keeping a pointer to a
struct source_location.
In this way, the buffer keeps the data encapsulated inside of a struct
type_mismatch_data, because pointers from nVHE can not be passed to the
kernel.

Inside the kernel call the __ubsan_handle_type_mismatch_data with the
data from the buffer.

Signed-off-by: George Popescu <georgepope@google.com>
Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h |  6 ++++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 41 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/kvm_ubsan_buffer.c  |  5 +++-
 3 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index 95ac6728ffd1..93c1b695097a 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -21,13 +21,15 @@ struct kvm_ubsan_info {
 		UBSAN_OUT_OF_BOUNDS,
 		UBSAN_UNREACHABLE_DATA,
 		UBSAN_SHIFT_OUT_OF_BOUNDS,
-		UBSAN_INVALID_DATA
+		UBSAN_INVALID_DATA,
+		UBSAN_TYPE_MISMATCH
 	} type;
 	union {
 		struct out_of_bounds_data out_of_bounds_data;
 		struct unreachable_data unreachable_data;
 		struct shift_out_of_bounds_data shift_out_of_bounds_data;
 		struct invalid_value_data invalid_value_data;
+		struct type_mismatch_data type_mismatch_data;
 	};
 	union {
 		struct ubsan_values u_val;
@@ -38,3 +40,5 @@ void __ubsan_handle_out_of_bounds(void *_data, void *index);
 void __ubsan_handle_builtin_unreachable(void *_data);
 void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs);
 void __ubsan_handle_load_invalid_value(void *_data, void *val);
+void __ubsan_handle_type_mismatch(struct type_mismatch_data  *_data, void *ptr);
+
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index 3143f7722be2..a9f72d4bcab7 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -29,6 +29,24 @@ static inline struct kvm_ubsan_info *kvm_ubsan_buffer_next_slot(void)
 	return res;
 }
 
+static void write_type_mismatch_data(struct type_mismatch_data_common *data, void *lval)
+{
+	struct kvm_ubsan_info *slot;
+	struct type_mismatch_data *aux_cont;
+
+	slot = kvm_ubsan_buffer_next_slot();
+	if (slot) {
+		slot->type = UBSAN_TYPE_MISMATCH;
+		aux_cont = &slot->type_mismatch_data;
+		aux_cont->location.file_name = data->location->file_name;
+		aux_cont->location.reported = data->location->reported;
+		aux_cont->type = data->type;
+		aux_cont->alignment = data->alignment;
+		aux_cont->type_check_kind = data->type_check_kind;
+		slot->u_val.lval = lval;
+	}
+}
+
 void __ubsan_handle_add_overflow(void *_data, void *lhs, void *rhs) {}
 
 void __ubsan_handle_sub_overflow(void *_data, void *lhs, void *rhs) {}
@@ -39,9 +57,28 @@ void __ubsan_handle_negate_overflow(void *_data, void *old_val) {}
 
 void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs) {}
 
-void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr) {}
+void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr)
+{
+	struct type_mismatch_data_common common_data = {
+		.location = &data->location,
+		.type = data->type,
+		.alignment = data->alignment,
+		.type_check_kind = data->type_check_kind
+	};
+	write_type_mismatch_data(&common_data, ptr);
+}
 
-void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr) {}
+void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr)
+{
+	struct type_mismatch_data_v1 *data = _data;
+	struct type_mismatch_data_common common_data = {
+		.location = &data->location,
+		.type = data->type,
+		.alignment = 1UL << data->log_alignment,
+		.type_check_kind = data->type_check_kind
+	};
+	write_type_mismatch_data(&common_data, ptr);
+}
 
 void __ubsan_handle_out_of_bounds(void *_data, void *index)
 {
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index 5439f7a91636..b7823dedf8b1 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -35,6 +35,10 @@ void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
 		__ubsan_handle_load_invalid_value(&slot->invalid_value_data,
 				slot->u_val.lval);
 		break;
+	case UBSAN_TYPE_MISMATCH:
+		__ubsan_handle_type_mismatch(&slot->type_mismatch_data,
+				slot->u_val.lval);
+		break;
     	}
 }
 
@@ -58,4 +62,3 @@ void __kvm_check_ubsan_buffer(void)
 	write_ind = (unsigned long *) this_cpu_ptr_nvhe_sym(kvm_ubsan_buff_wr_ind);
 	iterate_kvm_ubsan_buffer(0, *write_ind);
 }
-
-- 
2.30.0.296.g2bfb1c46d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
