Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5D4C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 531BA60F11
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 531BA60F11
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 096FE4AEDC;
	Mon, 26 Jul 2021 05:29:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h+dCKlKP0u63; Mon, 26 Jul 2021 05:29:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E4D4B093;
	Mon, 26 Jul 2021 05:29:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB98D4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kpnoR2Ju8o9Q for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:38 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B198040870
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:38 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 o5-20020a2581050000b029055ab4873f4cso12828174ybk.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=MJIro2WTfm4GzLtRoDylovuZ45jqLgFOexzn+Zy4wjs=;
 b=FSUlFamdvZmCkq1K/PPVAVpzWQ2IdtDwEy8DAyitecCP9UoJnIxQmUsQfqZUzVuPEk
 Hn6Y0ZdCypMyVxkddka1PFuUUmL82O98WDLQQxOW9w5/1xNezpgSU3+VjjTAM3QiiFYb
 lc+Oyf1eR0aufgHOQtp6oaewCjRopIvo2NIIYIzU038nPMU79T0GnRIAM620SA+Uowrp
 PsNp374AxcYuwdiWR5/zympTvFOzT+i4A8R/bc8CeqCmKLxZ6wYASldpJ9oV5r2GkoYK
 WtkZCG4iM7dS0bKA4FDvw5WqKlxqUe23jdLdajTqkFZbRzI4KaYW5x8/tmwqWByjNRsS
 KBAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MJIro2WTfm4GzLtRoDylovuZ45jqLgFOexzn+Zy4wjs=;
 b=moNfZuDNr787oVt+6frKQLX/4ft6Z/OtYjV1ayLklxJldzXqsclrmnZgEDVKjFwkf8
 RB4JORJJR3bN4z3DAEna5MxQ7nI0CIUImns1xV7wg+mdQUnCzx63Tpj7EPKu5/fLxYf6
 wf56BASCAVNRXzdnlEly4xqW7BlE/vI77nC3a3bDTpJ/wNVhFSxzD407JuB4RNjufu67
 lw9guLuL3mZBMR1beGQVpSuWC+Y8rX6dghfo3jDkt/TZGtimK3lVDhpJZJRcifZo9XFK
 Dnsh4Glt7o5hZiYDTKOqmpAlPYG/TDTo2EP/f/BpgImefzAmMUtX+wiOCBHgHd6xIvek
 pAxQ==
X-Gm-Message-State: AOAM531mCdigG4WfCfa7EymVvZ/GPfYuBX3La/HNKBGETTvDrj0zoEbu
 Bivsyl/FDoL4h8yag8S1Pj6/KTQ+ShgP
X-Google-Smtp-Source: ABdhPJzFtCNc3wRUZQkuMVZikxDARzQyAhA2u+pAgC1/vs0Dkse5PCCu9I9np2lmsIsb+H72joir6vU8V2M2
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a25:6088:: with SMTP id
 u130mr23486646ybb.257.1627291778107; Mon, 26 Jul 2021 02:29:38 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:29:01 +0100
In-Reply-To: <20210726092905.2198501-1-qperret@google.com>
Message-Id: <20210726092905.2198501-13-qperret@google.com>
Mime-Version: 1.0
References: <20210726092905.2198501-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 12/16] KVM: arm64: Mark host bss and rodata section as
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
 arch/arm64/kvm/hyp/nvhe/setup.c | 52 ++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 0b574d106519..285c8aea5065 100644
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
+	 * stage-2. This will done later (see finalize_mappings()) once the
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
 
@@ -148,6 +159,27 @@ static void hpool_put_page(void *addr)
 	hyp_put_page(&hpool, addr);
 }
 
+static int finalize_mappings(void)
+{
+	enum kvm_pgtable_prot prot;
+	int ret;
+
+	/*
+	 * The host's .bss and .rodata sections are now conceptually owned by
+	 * the hypervisor, so mark them as 'borrowed' in the host stage-2. We
+	 * can safely use host_stage2_idmap_locked() at this point since the
+	 * host stage-2 has not been enabled yet.
+	 */
+	prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_BORROWED);
+	ret = host_stage2_idmap_locked(__hyp_pa(__start_rodata),
+				       __hyp_pa(__end_rodata), prot);
+	if (ret)
+		return ret;
+
+	return host_stage2_idmap_locked(__hyp_pa(__hyp_bss_end),
+					__hyp_pa(__bss_stop), prot);
+}
+
 void __noreturn __pkvm_init_finalise(void)
 {
 	struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
@@ -167,6 +199,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = finalize_mappings();
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
