Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA6B1C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7582523B4B
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7582523B4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F31E4B263;
	Thu, 14 Jan 2021 12:44:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nc0LAL2rodDs; Thu, 14 Jan 2021 12:44:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B122A4B28F;
	Thu, 14 Jan 2021 12:44:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB514B1F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hnmJqlCV54cv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 12:24:50 -0500 (EST)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF4824B187
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:50 -0500 (EST)
Received: by mail-qv1-f74.google.com with SMTP id i20so5109646qvk.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 09:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=g4KIFCTj4cFhEnW/O46us+TReSaxYy0f2hLe/I7ffcA=;
 b=Hhr7KAKs8kOi8WVwQmidsIWDfqEk25rtQyJk/MDOmviLPuxOOzJXYdh3f3lkDblIxi
 bkOl0KJfgrERFCfypVjkChfLf+YPjTJ2R6MoqdE8g3xwuh+pQXXK3sHhXvwsKekmTuQr
 QQZ4C8ABTaOUX/c4/fxJ2IPw96KQYShHaP4aBligI7fm0lZfPVmDgpSb+bb/A9vzI0uT
 05p9H0NYCR5SOIC0wIYgnUW2Vp5y9e+ep8LU3dqPpAd0MTpr4eJacqrwxYq+CNdewQnp
 iAKYH+6BEWrpZfWVGQL8yXKYA9g/L++6zE4c2taW502LbXImxUOSySltAIpQbEX82Xxe
 KNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=g4KIFCTj4cFhEnW/O46us+TReSaxYy0f2hLe/I7ffcA=;
 b=T98djsp/qANG6Jmt0rzdTDEkF+OSj8eIl0ClOdjZ/ghLwqWj7e7VSVv6dwBJnoS8bL
 TUOCXInbhZKFSpuhxW1Kk+gkCE/LjNg/iQ3GFELJDPls5358BbzzzCCqDwEvrWu9P1t7
 zvOcp6C0FCjHPFxDAP17wA2pPe62QgCYT5O1exSjr4pxJB7TB+MctrrxX/nUkWLdrWSX
 hqpHYzIx/gmhCXaZcdbRgwY4NRHIWqV2CxQPWXNzQ8U9sT+RtWoFOTTxFywHK32z3/Us
 prmahT/j3Uj09UxKLxmeykPj8b4psXbuDRyyRjalD5g2M3+YwuXdocfgdYIJqKEaZDWv
 WD6Q==
X-Gm-Message-State: AOAM530YCxdeheIDvoZwCZGd0l4FoW5TWbWZo1QM+YXS54HvMzdViz2r
 ujvoAV5Eoj58XQdvlO1tUuiFKnvqETIGAs1ECN0c0EWDWNY21V4fO2YzmH1hc+r8nQVl40jcPXY
 w/94qstBbNfdZ6mT7Xrzn2ZByVfvkG0DNeyTs1IC1Xirp6ReZvcv+RCSVDLyQriuuYShslirL
X-Google-Smtp-Source: ABdhPJygeOs4qkIrlkzeio5jc/x8qxwkfpCDIRzqWD6MrXutel9ZiEnpHM1XoAxYJ1uynxI++vLlmJLX5+SR
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:ad4:5188:: with SMTP id
 b8mr8125977qvp.55.1610645090361; Thu, 14 Jan 2021 09:24:50 -0800 (PST)
Date: Thu, 14 Jan 2021 17:23:35 +0000
In-Reply-To: <20210114172338.2798389-1-lenaptr@google.com>
Message-Id: <20210114172338.2798389-6-lenaptr@google.com>
Mime-Version: 1.0
References: <20210114172338.2798389-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 5/9] KVM: arm64: Enable shift out of bounds undefined
 behaviour check for hyp/nVHE
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

__ubsan_handle_shift_out_of_bounds data is passed to the buffer inside
hyp/nVHE. This data is passed to the original handler from kernel.

The 64bit values of the shift expression operands are stored as the lhs
and rhs pointers, so there is no need to dereference them.

Signed-off-by: George Popescu <georgepope@google.com>
Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 14 +++++++++++++-
 arch/arm64/kvm/kvm_ubsan_buffer.c  |  4 ++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index 70c6f2541d07..0eef0e11a93b 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -19,11 +19,13 @@ struct ubsan_values {
 struct kvm_ubsan_info {
 	enum {
 		UBSAN_OUT_OF_BOUNDS,
-		UBSAN_UNREACHABLE_DATA
+		UBSAN_UNREACHABLE_DATA,
+		UBSAN_SHIFT_OUT_OF_BOUNDS
 	} type;
 	union {
 		struct out_of_bounds_data out_of_bounds_data;
 		struct unreachable_data unreachable_data;
+		struct shift_out_of_bounds_data shift_out_of_bounds_data;
 	};
 	union {
 		struct ubsan_values u_val;
@@ -32,3 +34,4 @@ struct kvm_ubsan_info {
 
 void __ubsan_handle_out_of_bounds(void *_data, void *index);
 void __ubsan_handle_builtin_unreachable(void *_data);
+void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index 5e55897b2d72..1069ed5036d5 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -56,7 +56,19 @@ void __ubsan_handle_out_of_bounds(void *_data, void *index)
 	}
 }
 
-void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs) {}
+void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs)
+{
+	struct kvm_ubsan_info *slot;
+	struct shift_out_of_bounds_data *data = _data;
+
+	slot = kvm_ubsan_buffer_next_slot();
+	if (slot) {
+		slot->type = UBSAN_SHIFT_OUT_OF_BOUNDS;
+		slot->shift_out_of_bounds_data = *data;
+		slot->u_val.lval = lhs;
+		slot->u_val.rval = rhs;
+	}
+}
 
 void __ubsan_handle_builtin_unreachable(void *_data)
 {
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index e51949c275aa..b80045883047 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -27,6 +27,10 @@ void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
 	case UBSAN_UNREACHABLE_DATA:
 		__ubsan_handle_builtin_unreachable(&slot->unreachable_data);
 		break;
+	case UBSAN_SHIFT_OUT_OF_BOUNDS:
+        	__ubsan_handle_shift_out_of_bounds(&slot->shift_out_of_bounds_data,
+				slot->u_val.lval, slot->u_val.rval);
+		break;
 	}
 }
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
