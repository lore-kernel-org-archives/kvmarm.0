Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7B3C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 226962399A
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 226962399A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB76C4B243;
	Fri, 15 Jan 2021 12:19:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bquix2W+IYVP; Fri, 15 Jan 2021 12:19:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C17BA4B229;
	Fri, 15 Jan 2021 12:19:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5B364B229
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jQrNrxVTkxOh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 12:19:09 -0500 (EST)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8A8B4B17A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:09 -0500 (EST)
Received: by mail-qv1-f73.google.com with SMTP id c17so8294213qvv.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=wIND0+cbxytiLi3TnPdU2y1dHj/fBtnQl0WZoWO1f3g=;
 b=iHwsC+akDTq/2izyfNfOh1mU4qeWdID+7XlRvI35seFl8BcVTWfx/aYX6KGgmYx4gm
 nemwGN0YAtiLxNca5Pah/pRIobzlTYHohJdqOHFZSuDTAN0HlibzCwDjaeY5UaVR3wKD
 yYQVD1ZTbEEsZVfEFwQfUqlIPV8RSbFp3u+G3YHrrOUXDmlbhMZPXGM/WPvJ70UPskaz
 OC1lWKa0J5wDu5N9gpIf1qGsJnTNl+AbVHva8vHJynBcAQPu6YDKyeOsdLyBa1n+GY4D
 t2uagGsIxrG+2prq9ENs/kMJ2pMUBIFg3hBWWQTd2h/3hHInUH30Y2BxUxo+//q9w44h
 MD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wIND0+cbxytiLi3TnPdU2y1dHj/fBtnQl0WZoWO1f3g=;
 b=N3KdBZA4/BCafiZ/TIaoSkMyPngTn6rwKXGuH39Ytx/8aCtOaYXHCvpYbW/1Pqx7Zd
 xBw+N8Sn3NUN3lVyepscH4532hrgQhMxF0pBaCPQNPDHIwVIzuvQXLZq9aT4jkMjm+t7
 cGg/59J03ms+V+PLRkstOKnISfUew2fYgHMynpSy6I4+3zE06uxXc6t8bT1cGf5kAiAc
 z6Z83HlYVT9XH+eAnQsef3cmveVxhwMG73+px41lbUX7FHwHh8NqxIgp0wAFP5Rwm1rP
 GXbiYgWsg0rK/WQztSN6msV3Qw2MA/uKDuLGhGnbDkdSU7LKdX5Kv3mo234zgIuAq3So
 7wLA==
X-Gm-Message-State: AOAM531Rnx21BWK1Rj1XQs0zQUUqWuHVpPfRS2JAZPNkQ1/aKSGB2FDz
 THQHLW4+0uOp9AGncN/0YG93gSVIOFuYeABRqe7V8mAafm1h4vyEw7Pl9lvJjH1QCGUXRYccRcC
 ZebAkFmG2go2kRkEnN4DKpqEdXmlt0x/ATeOQGqeZiuKtcrbhi4jLMhUNo2aYxyCW8A2Th3vw
X-Google-Smtp-Source: ABdhPJwoIqBmsZNjVlpKeTgLS1FR734TbBWA8MBe6gEFE2giI4dUNxyRBYn+N6v78Z3Uq8/6D05NfIKeh490
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a0c:f185:: with SMTP id
 m5mr13304807qvl.19.1610731149343; Fri, 15 Jan 2021 09:19:09 -0800 (PST)
Date: Fri, 15 Jan 2021 17:18:27 +0000
In-Reply-To: <20210115171830.3602110-1-lenaptr@google.com>
Message-Id: <20210115171830.3602110-7-lenaptr@google.com>
Mime-Version: 1.0
References: <20210115171830.3602110-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
Subject: [PATCH v3 6/9] KVM: arm64: __ubsan_handle_load_invalid_value EL2
 implementation.
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
2.30.0.296.g2bfb1c46d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
