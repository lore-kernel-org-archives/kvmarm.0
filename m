Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5230C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5732223B44
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5732223B44
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E25114B230;
	Thu, 14 Jan 2021 12:44:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LrEdmPCQj4V5; Thu, 14 Jan 2021 12:44:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CFD94B28A;
	Thu, 14 Jan 2021 12:44:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B942C4B223
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s6dYnOanj0Sm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 12:24:47 -0500 (EST)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A43074B1F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:47 -0500 (EST)
Received: by mail-qv1-f74.google.com with SMTP id m8so5113806qvt.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 09:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=1t4C6hJFamqbU7IDZaNfsvQVRkq+UVj+9twweJKBJmo=;
 b=bgfP8TgGrR3VBTfxn+pa3clqnf63XhBOsKIAki5GvZtlng2M161ujzp0pHbfhNNyjA
 xeiHwor4Pa7gtipfBdE2Xyw/5O3eTY+OrxtneNgiJWqrYMcs15pI7YZG12eJ+rTMAErL
 3Buf0e0EVzM/0LSP2MFNkc7g6gjFzPDvNTC2STUIooq3kiYEdnpDZJ/3laERZt1iNbBI
 1tjPQh1z+Tuqm5U9LlSnsi5JmCMZ17HTjOv6SGFcezW3O0asUYa18Z6WBxNxDWSpAnCU
 r62U7YSF4uCCVywsYFoM8bS070r7O0OdSpmHLfOsoJYJBwviRB6b1PoU0WuS26CQ5Wa4
 24YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=1t4C6hJFamqbU7IDZaNfsvQVRkq+UVj+9twweJKBJmo=;
 b=ZEw2evSXItbnl5nTtOCtLMh7yaqx7Obf5UuYlAGNHuoJMOX6OwoRD40N/QC96xZGX2
 Tf7kXjE9OBEuWBCPu8tANludNETi8ZHVKi/iS8AAN7z6oGrFZTNv6mkmr51Vxz5Yi9b5
 peYzkAKmXPnEdanfLiZvWLGIMciHBaGwMXcbwgkWeypyGzi/WkhB/+MFDUOwi1+zR27g
 8Pgh1fLFaOr1EkpX4Ms4Xtbgm9xWLDJ4kMkKNmBbPYw81C05a5Igpm7XEvgHc9SMIytS
 7MTNgDrt+4IK+JSGVfKD4L8C1Lufi4AE8dJqgORUHP0ERh7zSoH3CPnP/+veytRQEO0p
 yV3g==
X-Gm-Message-State: AOAM533EALxQwvsfXfHT7PABHdG5Jh9i7Oz7O68EiAIY5+LAgm/55IAO
 2kUX8xVDhLFyL5SU7SIXEi67B21KUfguKlVdF0We8lbFaKzZK1CgZ0G4xiFoB8NDEQ87vF33Etx
 ETyFuSvLyJTX5FORIWND19pK+aYwl5ougaZ5f8xyvSgHW+icZ0gbLLY9eTCwg165RIsZsqXON
X-Google-Smtp-Source: ABdhPJyKfgLbpjRvxXH6s/OOkKAxjero/ui32HTdz9vnKOUUCIQ3+JwR/2tIRrkt6fOKe+/IuePNCZ4vImcm
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a0c:e90a:: with SMTP id
 a10mr8225156qvo.38.1610645087031; Thu, 14 Jan 2021 09:24:47 -0800 (PST)
Date: Thu, 14 Jan 2021 17:23:34 +0000
In-Reply-To: <20210114172338.2798389-1-lenaptr@google.com>
Message-Id: <20210114172338.2798389-5-lenaptr@google.com>
Mime-Version: 1.0
References: <20210114172338.2798389-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 4/9] KVM: arm64: Enable UBsan check for unreachable code
 inside hyp/nVHE code
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

The data from __ubsan_handle_builtin_unreachable is passed to the buffer
and printed inside the kernel by its simetric handler.

Signed-off-by: George Popescu <georgepope@google.com>
Change-Id: I71d789b7f4ec3d4c787012a061b7f5d7952cee19
Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 12 +++++++++++-
 arch/arm64/kvm/kvm_ubsan_buffer.c  |  3 +++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index 4f471acb88b0..70c6f2541d07 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -19,9 +19,11 @@ struct ubsan_values {
 struct kvm_ubsan_info {
 	enum {
 		UBSAN_OUT_OF_BOUNDS,
+		UBSAN_UNREACHABLE_DATA
 	} type;
 	union {
 		struct out_of_bounds_data out_of_bounds_data;
+		struct unreachable_data unreachable_data;
 	};
 	union {
 		struct ubsan_values u_val;
@@ -29,3 +31,4 @@ struct kvm_ubsan_info {
 };
 
 void __ubsan_handle_out_of_bounds(void *_data, void *index);
+void __ubsan_handle_builtin_unreachable(void *_data);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index 55a8f6db8555..5e55897b2d72 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -58,6 +58,16 @@ void __ubsan_handle_out_of_bounds(void *_data, void *index)
 
 void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs) {}
 
-void __ubsan_handle_builtin_unreachable(void *_data) {}
+void __ubsan_handle_builtin_unreachable(void *_data)
+{
+	struct kvm_ubsan_info *slot;
+	struct unreachable_data *data = _data;
+
+	slot = kvm_ubsan_buffer_next_slot();
+	if (slot) {
+		slot->type = UBSAN_UNREACHABLE_DATA;
+		slot->unreachable_data = *data;
+	}
+}
 
 void __ubsan_handle_load_invalid_value(void *_data, void *val) {}
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index a1523f86be3c..e51949c275aa 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -24,6 +24,9 @@ void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
 		__ubsan_handle_out_of_bounds(&slot->out_of_bounds_data,
 				slot->u_val.lval);
 		break;
+	case UBSAN_UNREACHABLE_DATA:
+		__ubsan_handle_builtin_unreachable(&slot->unreachable_data);
+		break;
 	}
 }
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
