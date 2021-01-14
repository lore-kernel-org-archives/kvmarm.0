Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9CAC433E6
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B06ED23B44
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B06ED23B44
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D35B4B252;
	Thu, 14 Jan 2021 12:44:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lWsFw6M5f8yE; Thu, 14 Jan 2021 12:44:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6D324B292;
	Thu, 14 Jan 2021 12:44:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 923034B1F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lbBPMakfY+kl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 12:24:55 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 524E44B223
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:55 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id f18so2139641wmq.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 09:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=mBnNW8oub18hKhhe8yHqfoSEZU2iRCB395w7gjgwxWc=;
 b=YyThgL189juUYY1QafUrt/nr4mL1Dlewr+4os9Exz6q+m6zwQXnoNIhxbHXPalrLo3
 rT8BweykI8RXTWknugQU6KAjnTbwTL5UC5KFh1fQWQXdH41NrYXFexJt5/aptCnupsFC
 0d1H6PKi/v1QEYbt0efPZVVZD5cgvjLF83q3cN7iaf2PLa7zmhtCGfTdNqioLq6dWhRd
 DPThFVt8UzRBUnyK/afuRop1dx5ZpmVKxLe29q8bs4SAmFaQR5aNAdvHzAeCXBAWn1d4
 pqMd0rSFv2FKBgy8quIF4elmlwiDGceTp7vVFHE3FNNBk8B0YjV19JXoNZ096PTB1a18
 UH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mBnNW8oub18hKhhe8yHqfoSEZU2iRCB395w7gjgwxWc=;
 b=p5wV0e0Ag+1qA2rvEQIJV7A35n+lwbX55QeGXkZu0Vk2E2mTH91iSIH3RZTuNSlDGI
 mh9KZ52ksjT2SQhBRHZRjPT8mEQS/SHNgfbYwwuj3f8CP+Et2f0E+gc9hD8OGIrV5x4a
 Nqme4wy9UCTpDfigOlCUttjZxrfjlXg6p8pLq/CvpyYb/D06LpDENsoj1Cqk2IJYuQ7r
 hqW5jUOOP9QomKnm0/uGFQbeLkrjimopFNBcoSrgBC29z3sBf3zgNdxTeTSRPAHFjsAl
 q6kof4XQ5BVojk3CtoEpKBkpIJO2CBbxMJ2QgUkOaBSWfsyncVXBAA2Ic5e2UOZ1yfpM
 Gc2A==
X-Gm-Message-State: AOAM533zV1DLNEXOsrMXqsoXbTCdoRqNfS3ilx3GXVutQbbD1SP8xh9H
 DcgtJCXudEPkRLFnJpIjh5ovVOOCgQ0uXdFgxWqBsfJHFltyUJqZl5L+9mRwgNTQFc3IFhjrY1v
 1hxi/Tt2U+d9JcNeqeHnFRExkJa2WOdppp36akIaQua0qYP8UEQzL3sHEG5yCEJMiVGfdJww5
X-Google-Smtp-Source: ABdhPJwgNb+fXta79qoc3ofmUnstDxPUmBtXRsFXZPs561fwW9D9l7EWAZMF5Ae/x9bNaAM6+JkZbZCSBJbJ
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a1c:2c89:: with SMTP id
 s131mr533256wms.0.1610645093881; Thu, 14 Jan 2021 09:24:53 -0800 (PST)
Date: Thu, 14 Jan 2021 17:23:36 +0000
In-Reply-To: <20210114172338.2798389-1-lenaptr@google.com>
Message-Id: <20210114172338.2798389-7-lenaptr@google.com>
Mime-Version: 1.0
References: <20210114172338.2798389-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 6/9] KVM: arm64: __ubsan_handle_load_invalid_value EL2
 implementation.
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

The handler for the load invalid value undefined behaviour is
implemented at EL2. The EL2 handler's parameters are stored inside the buffer.
They are used by the symetric handler from EL1.

Signed-off-by: George Popescu <georgepope@google.com>
Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 14 +++++++++++++-
 arch/arm64/kvm/kvm_ubsan_buffer.c  |  6 +++++-
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index 0eef0e11a93b..95ac6728ffd1 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -20,12 +20,14 @@ struct kvm_ubsan_info {
 	enum {
 		UBSAN_OUT_OF_BOUNDS,
 		UBSAN_UNREACHABLE_DATA,
-		UBSAN_SHIFT_OUT_OF_BOUNDS
+		UBSAN_SHIFT_OUT_OF_BOUNDS,
+		UBSAN_INVALID_DATA
 	} type;
 	union {
 		struct out_of_bounds_data out_of_bounds_data;
 		struct unreachable_data unreachable_data;
 		struct shift_out_of_bounds_data shift_out_of_bounds_data;
+		struct invalid_value_data invalid_value_data;
 	};
 	union {
 		struct ubsan_values u_val;
@@ -35,3 +37,4 @@ struct kvm_ubsan_info {
 void __ubsan_handle_out_of_bounds(void *_data, void *index);
 void __ubsan_handle_builtin_unreachable(void *_data);
 void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs);
+void __ubsan_handle_load_invalid_value(void *_data, void *val);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index 1069ed5036d5..3143f7722be2 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -82,4 +82,16 @@ void __ubsan_handle_builtin_unreachable(void *_data)
 	}
 }
 
-void __ubsan_handle_load_invalid_value(void *_data, void *val) {}
+void __ubsan_handle_load_invalid_value(void *_data, void *val)
+{
+	struct kvm_ubsan_info *slot;
+	struct invalid_value_data *data = _data;
+
+	slot = kvm_ubsan_buffer_next_slot();
+	if (slot) {
+		slot->type = UBSAN_INVALID_DATA;
+		slot->invalid_value_data = *data;
+		slot->u_val.lval = val;
+	}
+
+}
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index b80045883047..5439f7a91636 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -31,7 +31,11 @@ void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
         	__ubsan_handle_shift_out_of_bounds(&slot->shift_out_of_bounds_data,
 				slot->u_val.lval, slot->u_val.rval);
 		break;
-	}
+	case UBSAN_INVALID_DATA:
+		__ubsan_handle_load_invalid_value(&slot->invalid_value_data,
+				slot->u_val.lval);
+		break;
+    	}
 }
 
 void iterate_kvm_ubsan_buffer(unsigned long left, unsigned long right)
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
