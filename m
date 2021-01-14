Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759F3C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 159EA23B44
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 159EA23B44
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B21E34B22F;
	Thu, 14 Jan 2021 12:44:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bPNufDv5kgR4; Thu, 14 Jan 2021 12:44:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E475D4B295;
	Thu, 14 Jan 2021 12:44:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B18794B226
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:25:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4wbVUl2LAf9P for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 12:24:59 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 470EA4B223
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:59 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id u18so2118508wmu.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 09:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=XOmV9rOXqPPVqcegQZNJofTEyx38uhN2nVbmi9afywU=;
 b=wW2e4FyZwiW4L+MD2pK71yjkUENfnlHKSdcjj5VQOEWjRQ/VMENAXofc/SBW/q3NqS
 As+WKNmk0v1a694hte5GMuu6L+ztFtEvy75X7u0teBJIkZrfu6w32KTxJvFl1zSXiiSs
 uh1waDR/zSMV8uINsy01PGok3/BSAn2BV/wG/RZPY9vbH5/bbWboCppBOonmCqz3a+IX
 20gSuBJCAHT7XR8fGEnqlywuv05Z0b0k9Quho4eon4sbGa9nTUyGJhZzWp7FgN4E2wsz
 oNpYilKZdIn+H7Zmr4oEKebRiDVH0ovn0+TMHilpMqs053xwXZ6NuWFhU+Z3UaPs5seU
 KH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XOmV9rOXqPPVqcegQZNJofTEyx38uhN2nVbmi9afywU=;
 b=Ptvx6nN0LzTS8eIQNnfdtcn/mUj27TFnV+SRnDeM3IpuiR2Q6QWrWdqjUgFD1X8sxm
 nRk2cYtMydEmPlzDsMX2yRpNy2a0BemJYDqRKnbsJ7AtkEJrbjY/R7upTXuR57tmQG35
 dfwayB2EM2QVIb8dXJ2GK1PjzlCtcuyhoEvET7pCDHr5D9EqGEzcPIbQBAspLnxE3uWk
 rfsKXtWXKJea2//JOMcXJ/UGJ9M7PA9lIezac3kretyxGfElDw6yz0Act7v+OI3ihCo8
 EK5qbENE7NFv+3UwbMj10lnw9/ePwtkAbQdpi5kicj/L9R1AVBLW6mMfEkDwTOUDlQhF
 ykmw==
X-Gm-Message-State: AOAM533KAskN8BlWmCiWeSsyJtYSoiE0+z9jEK3a9j+ZsCJLcEPR+uwa
 L9ckzh6XGGwIOIsxoyD4pi/uZW0pEagB5HJFZ/n/DJP6c4WSewQd8i+lTQYbXVHehsxAW8KXy/k
 IWYTZsoQ4nRjDj+Wo4qNeDshcPNwo4Jwd/JzEdX6zGtq0+sxYsnFuhDzFinitFWesJeNqNUJA
X-Google-Smtp-Source: ABdhPJxxZEBrrEl+PdqZxakS3Rf9SE4hlhTxKmLtFWnPFUshOyr5z5v7DthBWnq6r+pf53pcmG79PYu4vZOu
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a1c:c204:: with SMTP id
 s4mr4820767wmf.73.1610645098345; Thu, 14 Jan 2021 09:24:58 -0800 (PST)
Date: Thu, 14 Jan 2021 17:23:37 +0000
In-Reply-To: <20210114172338.2798389-1-lenaptr@google.com>
Message-Id: <20210114172338.2798389-8-lenaptr@google.com>
Mime-Version: 1.0
References: <20210114172338.2798389-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 7/9] KVM: arm64: Detect type mismatch undefined behaviour
 from hyp/nVHE code
From: Elena Petrova <lenaptr@google.com>
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Thu, 14 Jan 2021 12:44:06 -0500
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
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
