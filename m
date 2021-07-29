Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D45C4320A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:29:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 16D7260C41
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:29:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 16D7260C41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0224B117;
	Thu, 29 Jul 2021 09:29:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GMB1YAsfr9Zf; Thu, 29 Jul 2021 09:29:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BE6A4B118;
	Thu, 29 Jul 2021 09:29:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 436504B104
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:29:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P52wTbEcxEAQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:29:02 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35E2A4B10D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:29:02 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 kl8-20020a0562145188b02902e01fc8ee77so3887546qvb.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=t9d8PqBzyoMiv4uaDaKWmALSR0AbEM5jj3yE0ogaIjo=;
 b=qdH4TWs2IPN7BH6Qf64dcpE5qjfH2iCeLcZX05rnMNjDWiBnFROcDGWEe/SdMju7x/
 ieDbYf7UO1Mq1ELT6YQ0XasLQyPpiRUTXjG3KEShWGZ9JFwQgDi7gkhanF3t14H2Lrym
 g4bXAIzrDRY7b8rE1N2wpQCdJQ3W8gXHS8E/CnjFZDjpruQc0oXYrRONUVWJjdhikTu5
 ir2JnbEZXVpjouYRcMnnxiQPaEo/yNabkdYo1ggwEFlG75vu2TUW02dmBDAgZ7PyOssP
 7FFDhwLvfwHe2cXVTR6aKM4U+/2gXXzCmDt3Jp5HQJXGNJ1OLuNREzhPnRzyyh3OtZkf
 WWqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=t9d8PqBzyoMiv4uaDaKWmALSR0AbEM5jj3yE0ogaIjo=;
 b=GWvbCzAfqgPsuA1cxh5MnnkYWcfqRBLUdMFhkJpecW6qPkdzG9hsAIA6A+8FBU0eky
 NYlogvVTi/r1mPhSKOC1tSAd2N+qw5yJSlv7PyLF1s4H7xDP2G34SgklK/1ZFATuOMeK
 PsGEvnCoIxB2COFOtfssW8cepj/JRHCvZz1HErxuJoX2kfr8b9gCDZZi1kueF7q9jCU3
 /9Z8yqIHaMe4TX34fmdDJ/m9B450UVaD0LxY7GhwznUYYeC7WDV6VZSPFlRZS2ku7EsT
 oUi+PqWqS3GmIZxZH9WsGso4gegq8qdgruOkRBIGpG+nLcAYVyE8/BFd5zxmUEtfc0Ys
 Od+A==
X-Gm-Message-State: AOAM530Du27Qewh7I6+R0EP33oYCbbcqzdF2AOtvHYvaFGLpa8lx/xvh
 942asnsSKOA9Krd7NuFslkVNAItxuqwZ
X-Google-Smtp-Source: ABdhPJxqCORnrX6VEWjxQJG0CdLIdUAJQytJlymD5vtw/Ugu5Brx5yVux+z3aZpshYRqV+Kxtuu7tq0zDGIm
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:ad4:5965:: with SMTP id
 eq5mr4814986qvb.41.1627565341803; Thu, 29 Jul 2021 06:29:01 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:14 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-18-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 17/21] KVM: arm64: Mark host bss and rodata section as
 shared
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

As the hypervisor maps the host's .bss and .rodata sections in its
stage-1, make sure to tag them as shared in hyp and host page-tables.

But since the hypervisor relies on the presence of these mappings, we
cannot let the host in complete control of the memory regions -- it
must not unshare or donate them to another entity for example. To
prevent this, let's transfer the ownership of those ranges to the
hypervisor itself, and share the pages back with the host.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 82 +++++++++++++++++++++++++++++----
 1 file changed, 74 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 0b574d106519..7f557b264f62 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -58,6 +58,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 {
 	void *start, *end, *virt = hyp_phys_to_virt(phys);
 	unsigned long pgt_size = hyp_s1_pgtable_pages() << PAGE_SHIFT;
+	enum kvm_pgtable_prot prot;
 	int ret, i;
 
 	/* Recreate the hyp page-table using the early page allocator */
@@ -83,10 +84,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
-	ret = pkvm_create_mappings(__start_rodata, __end_rodata, PAGE_HYP_RO);
-	if (ret)
-		return ret;
-
 	ret = pkvm_create_mappings(__hyp_rodata_start, __hyp_rodata_end, PAGE_HYP_RO);
 	if (ret)
 		return ret;
@@ -95,10 +92,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
-	ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop, PAGE_HYP_RO);
-	if (ret)
-		return ret;
-
 	ret = pkvm_create_mappings(virt, virt + size, PAGE_HYP);
 	if (ret)
 		return ret;
@@ -117,6 +110,24 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 			return ret;
 	}
 
+	/*
+	 * Map the host's .bss and .rodata sections RO in the hypervisor, but
+	 * transfer the ownerhsip from the host to the hypervisor itself to
+	 * make sure it can't be donated or shared with another entity.
+	 *
+	 * The ownership transtion requires matching changes in the host
+	 * stage-2. This will done later (see finalize_host_mappings()) once the
+	 * hyp_vmemmap is addressable.
+	 */
+	prot = pkvm_mkstate(PAGE_HYP_RO, PKVM_PAGE_SHARED_OWNED);
+	ret = pkvm_create_mappings(__start_rodata, __end_rodata, prot);
+	if (ret)
+		return ret;
+
+	ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop, prot);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
@@ -148,6 +159,57 @@ static void hpool_put_page(void *addr)
 	hyp_put_page(&hpool, addr);
 }
 
+static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
+					 kvm_pte_t *ptep,
+					 enum kvm_pgtable_walk_flags flag,
+					 void * const arg)
+{
+	enum kvm_pgtable_prot prot;
+	enum pkvm_page_state state;
+	kvm_pte_t pte = *ptep;
+	phys_addr_t phys;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
+		return -EINVAL;
+
+	phys = kvm_pte_to_phys(pte);
+	if (!addr_is_memory(phys))
+		return 0;
+
+	/*
+	 * Adjust the host stage-2 mappings to match the ownership attributes
+	 * configured in the hypervisor stage-1.
+	 */
+	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
+	switch (state) {
+	case PKVM_PAGE_OWNED:
+		return host_stage2_set_owner_locked(phys, phys + PAGE_SIZE, pkvm_hyp_id);
+	case PKVM_PAGE_SHARED_OWNED:
+		prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_BORROWED);
+		break;
+	case PKVM_PAGE_SHARED_BORROWED:
+		prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return host_stage2_idmap_locked(phys, phys + PAGE_SIZE, prot);
+}
+
+static int finalize_host_mappings(void)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= finalize_host_mappings_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits), &walker);
+}
+
 void __noreturn __pkvm_init_finalise(void)
 {
 	struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
@@ -167,6 +229,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = finalize_host_mappings();
+	if (ret)
+		goto out;
+
 	pkvm_pgtable_mm_ops = (struct kvm_pgtable_mm_ops) {
 		.zalloc_page = hyp_zalloc_hyp_page,
 		.phys_to_virt = hyp_phys_to_virt,
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
