Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1771EC432BE
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0ECE60E09
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C0ECE60E09
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7102F49E72;
	Mon, 26 Jul 2021 05:29:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jxVjm4I+Hl1G; Mon, 26 Jul 2021 05:29:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A59A94A523;
	Mon, 26 Jul 2021 05:29:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3F149E5F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dROudFs7TtM0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:35 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B8F8A4B0B1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:33 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 f9-20020a05622a1a09b02902615523e725so3981301qtb.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=oI1lsqd2Q7dxLS0xam0vuO1J8Xxzsd51ZvtsfH3kSqA=;
 b=bXUXb/i9hSD5qN+TC+k+TwbawB1Ioga3ua3ibJeKI8gHVrRfQF1zVfzZ9qUKUJWIZb
 D3xLOECrzB08csaTg6TGm2x6MiN2M0qkKt7aUpIzWlvypa7VgYw7HoaS8o9nwDLUc3Nt
 H/I3JOAjQfDHzXOk2iBvFyJl4Ofl/yegYHjGNrZWBdXPhk1D876uuHch99124AS6qus7
 EeemZ0cg6jHhbWX/57lWGRwafDUed/QpP+m0HQ1U2ANbhgXhsZwGerOpdJs9Df1RiqXo
 uEtAXLQXFJZUQjutSGSIyRCOHeo6U82U5bsQSPmEcXs8Wfx1gjaZbyNisbC3A+TAs1WN
 NoOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=oI1lsqd2Q7dxLS0xam0vuO1J8Xxzsd51ZvtsfH3kSqA=;
 b=gH/a5coK9pkeMnqd3Z68KaC84b3O0A/qxfNPG42agFIo6RDpFJQsnOdyDT8fZpRkrh
 jVFpTU5lDmXlxCa/y8ynbEpJgHhesYM768BKZj8iLwOIr/zmqY9+SRpZb56oGxNz+Xbx
 XEqFcUzWSjiFw3uK0Pea2+KIw8obkigCxxqVr4jGR7ZMi7HzOVET7dAgGpDdO9V76G1W
 sAgyDkuhJL5I2ZXHWM1Yn+MY37qhYusN7C7BJYN53cIa91L0AvIHFVQPq/nTih5wUQpm
 zS1US5u0eBg10SfybqE8jWfmmdGEfi9hb9eWBHkI0EuJi9fTVEMjBUMkqr9Abv+0zmqh
 UgyQ==
X-Gm-Message-State: AOAM531F23kDQrEQc9R+O6c6Tg297Dzo66+VcAF4tXen2Zy+T4t1bZqM
 HgEJkqtV02uVP8UcwsoCtMcsk+Ezp9l/
X-Google-Smtp-Source: ABdhPJyCiJBcW6GLm8E7sXXL2J+ym67KXeRU47WQn21gBL8HZOPCdK1XRTVEI/TyzJ/m4gVul31p0IuTxjtT
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a0c:aacd:: with SMTP id
 g13mr2247331qvb.20.1627291773337; Mon, 26 Jul 2021 02:29:33 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:28:59 +0100
In-Reply-To: <20210726092905.2198501-1-qperret@google.com>
Message-Id: <20210726092905.2198501-11-qperret@google.com>
Mime-Version: 1.0
References: <20210726092905.2198501-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 10/16] KVM: arm64: Add helpers to tag shared pages in SW
 bits
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

We will soon start annotating shared pages in page-tables in nVHE
protected mode. Define all the states in which a page can be (owned,
shared and owned, shared and borrowed), and provide helpers allowing to
convert this into SW bits annotations using the matching prot
attributes.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 9c227d87c36d..facbd9a7ab99 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -12,6 +12,33 @@
 #include <asm/virt.h>
 #include <nvhe/spinlock.h>
 
+/*
+ * SW bits 0-1 are reserved to track the memory ownership state of each page:
+ *   00: The page is owned solely by the page-table owner.
+ *   01: The page is owned by the page-table owner, but is shared
+ *       with another entity.
+ *   10: The page is shared with, but not owned by the page-table owner.
+ *   11: Reserved for future use (lending).
+ */
+enum pkvm_page_state
+{
+	PKVM_PAGE_OWNED			= 0ULL,
+	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
+	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
+};
+
+#define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
+static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
+						 enum pkvm_page_state state)
+{
+	return (prot & ~PKVM_PAGE_STATE_PROT_MASK) | state;
+}
+
+static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
+{
+	return prot & PKVM_PAGE_STATE_PROT_MASK;
+}
+
 struct host_kvm {
 	struct kvm_arch arch;
 	struct kvm_pgtable pgt;
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
