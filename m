Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575F8C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF5EF238EE
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:19:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF5EF238EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B7514B250;
	Fri, 15 Jan 2021 12:19:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VBBvKrtQlu8P; Fri, 15 Jan 2021 12:19:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B1204B24A;
	Fri, 15 Jan 2021 12:19:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 968704B228
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YA+vko+qo-ta for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 12:19:01 -0500 (EST)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EB314B254
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:19:00 -0500 (EST)
Received: by mail-qk1-f201.google.com with SMTP id q3so8624295qkq.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=VLLmnZ0Ac3m76z32lc7f4mhhOZikEiI3As160KoTLrU=;
 b=egSS6f+/ZiSYDrYEqcmLy80yB2G8pLh4/46w4bOcE9bAiACETRhrIOb9DHjpvEIVRC
 /PgKrFttwj0MMDdD5zOroWcM10AEnpHSh4bCQdjiPpZNljcUGkNfLJRvgUCW/z/yGQfN
 LnctQtGQmXmFh4qFP8c74u0vAbaWhzKuG3qTIL0jDn8XsP/f1xVmGf2wfipFy0xdD1a5
 6PsIwBV/6iCT6SuAY28J4lBPpO182IzI3Mhs0PwRRVnv53i45BbGMWwOVIb6W+dV/wtZ
 ZRYUwJGEFaLcB/qIU7O2/lXdYU4SRAXB0q5fCJNRSpnp5nw0eVPUwCE/IrGeHwWLtMxi
 PtdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VLLmnZ0Ac3m76z32lc7f4mhhOZikEiI3As160KoTLrU=;
 b=t6ZRPEd6pGJv4dY+of7XT6vx1OxGsXt3odHYobmUiP+RBgTNKHFt7gR/vIPkl8n1fJ
 hhqVEy4emAHMUZTgthb6kZNxxuHrICfc+ZTKGO+/5dD+0/UwrGFqkFGNCBuPzakEFTdB
 oF5QQdXX6CwcCDQ4dlILdfj1c9QQnHPmHblrakzOnuPkAv9G1zy3Djlkwm9acxR7pMt3
 Noe3rMmjFgF5Geaojp9XHc5Jzg9LhKkxJ0P39t+Xjdzlc0+ZGB1M+QiAWUoG1f1RPDNO
 IQd2ssUo851kg5O4/kIhwOnk3XTOEQYH/6Ek4F9JKaVT85TeU0qXLdDZt+UUUw76lPG1
 EYwg==
X-Gm-Message-State: AOAM531VKYGGVYCFblDbd+dLxXLyLagOoc8nzphPzTT58M+Ob9SW59J0
 xhD6YRnlYPmu2QvnnitvjOf8aZugQ7vvkv00tfoYOnSqwza/CdZ/nhYP2AcUsxeZegxDzxtrTRe
 WZKreaH4EOjDR2/8aMnV0SbHgFuEhiHKDy66Rc1UvvrkOliOspmB80KnZnS7YZ5lWOqalCQ7W
X-Google-Smtp-Source: ABdhPJyX2gz/c3WBh1CNS135ZWzqDcKoMX6gQYN7QuSu6bRWqRPWCQ+Yg2fsS5KxlhOHepRi0Xak+17hYmtT
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a05:6214:a94:: with SMTP id
 ev20mr13079298qvb.56.1610731139913; Fri, 15 Jan 2021 09:18:59 -0800 (PST)
Date: Fri, 15 Jan 2021 17:18:25 +0000
In-Reply-To: <20210115171830.3602110-1-lenaptr@google.com>
Message-Id: <20210115171830.3602110-5-lenaptr@google.com>
Mime-Version: 1.0
References: <20210115171830.3602110-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
Subject: [PATCH v3 4/9] KVM: arm64: Enable UBsan check for unreachable code
 inside hyp/nVHE code
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

The data from __ubsan_handle_builtin_unreachable is passed to the buffer
and printed inside the kernel by its simetric handler.

Signed-off-by: George Popescu <georgepope@google.com>
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
2.30.0.296.g2bfb1c46d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
