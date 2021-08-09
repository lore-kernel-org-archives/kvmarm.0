Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2D4C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A29236101D
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A29236101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 439334B102;
	Mon,  9 Aug 2021 11:25:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4V6xRnLCvpaf; Mon,  9 Aug 2021 11:25:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FF624B10D;
	Mon,  9 Aug 2021 11:25:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CFDC4B0C7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qgHJxuTdDqSO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:35 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 135E84B113
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:34 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 l19-20020a05600c4f13b029025b036c91c6so4141949wmq.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0vnFX0HCkFp8ZLTU0btBJYZAdzWXKCWbI3FuYOfCODA=;
 b=edLLNeSUJUuSeZh6U5LgHuiFbQdxbqRKi/NQ1RSRnsUEn2S/8ryLev1RWgMSfDbltm
 Om9IrwxtxrsFpwCskBaMEJ7xBMB6hChrlzhzMzZ2whQvKh0X0/PsQAyhN2UbcMabEKhJ
 kFITxof5dzgHb27rpT/TUwsw9eujgADfYDSuydpjHXLWRa3f3mUrl1r2tJHF5HcYrnXM
 ZVct81ad5/jrKV4yq33XFH/l0LAM02qWUJwCBxnaoSuNVHOUDowrr9GS0w/R/KbWvIzV
 XsiLCk2wB36vg/uxYgid0GyY+bEKFJ/s794tI7nnae4HsUsaHCOpJbS240pLizQYB85F
 EWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0vnFX0HCkFp8ZLTU0btBJYZAdzWXKCWbI3FuYOfCODA=;
 b=ON++dQDU1tql5f50bgEGQqvrgBhCNvoXAhJgLgeFIuD3xa2vrysHnElP1UCeGx8Tfw
 TW6Nc2H2qJGcK6xgcLkVnRYsSSitEfnTiR0j/T8NN2lf1n8uIgj6PYwQY6Y6AVKNoAO+
 rghiPxIbv90y+A/9Z55ZlPtBhW/EUnoQKelDC0LP0GCb+pteZ+hoUob/cUXyQ3ODoeCy
 M/zwulSHWfwMUk81kJXyPn8xHdhPpm3yvAoDGMbWd+HBJMD/7Mw2BarlM69sqHpSG9zO
 irZ0fivSD8PhZFTkXF5IX+eVb6LiuP87SplufdCaShhs1uHqdRlU9foa2VE8LVQa1iwt
 RBcQ==
X-Gm-Message-State: AOAM533+MLG6JdH+V1Dgd73Iftx1wL2/ovrb+9ZiTid0fNnmt04qb+C1
 YTpngKihfkQ1aPk581Vsb/5yZLxZBZPC
X-Google-Smtp-Source: ABdhPJyIOtnzxP4S0R25oU2iubMhTBhg+aNqUgDs+Hxip8y4Nj2Lxx59WuSTFwfisX1gdgavPWTXBcPgInrK
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a7b:cb99:: with SMTP id
 m25mr33616400wmi.90.1628522733253; Mon, 09 Aug 2021 08:25:33 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:46 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-20-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 19/21] KVM: arm64: Refactor protected nVHE stage-1 locking
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

Refactor the hypervisor stage-1 locking in nVHE protected mode to expose
a new pkvm_create_mappings_locked() function. This will be used in later
patches to allow walking and changing the hypervisor stage-1 without
releasing the lock.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mm.c         | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 8ec3a5a7744b..c76d7136ed9b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -23,6 +23,7 @@ int hyp_map_vectors(void);
 int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
+int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
 int __pkvm_create_mappings(unsigned long start, unsigned long size,
 			   unsigned long phys, enum kvm_pgtable_prot prot);
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index a8efdf0f9003..6fbe8e8030f6 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -67,13 +67,15 @@ unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 	return addr;
 }
 
-int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
+int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot)
 {
 	unsigned long start = (unsigned long)from;
 	unsigned long end = (unsigned long)to;
 	unsigned long virt_addr;
 	phys_addr_t phys;
 
+	hyp_assert_lock_held(&pkvm_pgd_lock);
+
 	start = start & PAGE_MASK;
 	end = PAGE_ALIGN(end);
 
@@ -81,7 +83,8 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 		int err;
 
 		phys = hyp_virt_to_phys((void *)virt_addr);
-		err = __pkvm_create_mappings(virt_addr, PAGE_SIZE, phys, prot);
+		err = kvm_pgtable_hyp_map(&pkvm_pgtable, virt_addr, PAGE_SIZE,
+					  phys, prot);
 		if (err)
 			return err;
 	}
@@ -89,6 +92,17 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return 0;
 }
 
+int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
+{
+	int ret;
+
+	hyp_spin_lock(&pkvm_pgd_lock);
+	ret = pkvm_create_mappings_locked(from, to, prot);
+	hyp_spin_unlock(&pkvm_pgd_lock);
+
+	return ret;
+}
+
 int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back)
 {
 	unsigned long start, end;
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
