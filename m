Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECEDC07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A46C161107
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A46C161107
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4666949E8C;
	Mon, 19 Jul 2021 06:48:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kiXqgm5rqKRo; Mon, 19 Jul 2021 06:48:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA8544B096;
	Mon, 19 Jul 2021 06:48:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0686240808
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:48:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2HjZQhJXHSWr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 06:48:03 -0400 (EDT)
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com
 [209.85.218.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEEE24A1AF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:48:02 -0400 (EDT)
Received: by mail-ej1-f74.google.com with SMTP id
 r10-20020a170906350ab02904f12f4a8c69so5226774eja.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 03:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=dNi42ehjO4NUi77Uj+cYvrOU4Ks5G49fj0fQYIq6rpI=;
 b=Zo9CxzDhUX2cZC2KYawro8tC3zo0gCGU9bsbwig5j0S3OAyeSDfj6KLCvhewOJXss3
 ScGYWjjud+BfSjX1bw156hEet1J0T/Zqk+5fp1+CJaOunTaub7sgNqmoVkWv4/0g/rzU
 ZYfZpco3hJ67xUtZI9pTg9Vo5ayKvZcYbWYX32i7f9viXdeSPFpPtsmRiydpflNHKvaZ
 xJX3jC/HH6IpfzQrNolC63LcfYbtbE36mpB0gvl0+eobqmpRV69cepN1WIehO6m5AK3p
 /KS5RCENmYr5NttKLDRGsPdS7odJ5r7HBgi/UC8GW3gSGPXH/MBjxAGstC6Bk+7nxeXY
 xpPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=dNi42ehjO4NUi77Uj+cYvrOU4Ks5G49fj0fQYIq6rpI=;
 b=aT4NlVBmdMG0UO//sNUU+aRg3FsnEAwmXlR/LnuxaDR5AEUQoDwug4POrZNvuh4khr
 x28Z20tTycu4e5eVSAxHKRorRgYDGUa+zsDoaa2gSv71gQ9ru2O1pZcJzAyuXXLo7f4x
 C04Cksnek59N0q/L2+yr6f8gT9Q3ICmOrNrhdQIfifqEE7D0fiW1p2uz3dqngarmUIC3
 XHxjKZkOuXl9ny/a1TYm8DFhnb8Z+D1HD3WKiIM0F0o4Ys8YvRscFY6gYLlyN+cJQWA0
 0G4JxXYzXclp1nFg2lQhAfAVqJhIocsKhPwRPH7QAjXK2W8vRR4qjM2fcARFxgpvU/kR
 Rs4g==
X-Gm-Message-State: AOAM530HhZF9cabdSp1WdZb14R/0R6Vax9oRQxeLepoz4EBtmHkLVQTX
 7b54xGAanfcRMd4qXEr749XH6l1k1utc
X-Google-Smtp-Source: ABdhPJyAyrN45gMOAlaStcGcdibOpYIOibhoQ9RmoK/yB/n96peiRQ6P/R0p8ef0yM8amQWGs/batNr68Iti
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1a96:a43f:6c2e:bb5a])
 (user=qperret job=sendgmr) by 2002:a17:906:d8da:: with SMTP id
 re26mr26655364ejb.205.1626691681533; Mon, 19 Jul 2021 03:48:01 -0700 (PDT)
Date: Mon, 19 Jul 2021 11:47:30 +0100
In-Reply-To: <20210719104735.3681732-1-qperret@google.com>
Message-Id: <20210719104735.3681732-10-qperret@google.com>
Mime-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 09/14] KVM: arm64: Mark host bss and rodata section as shared
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
hypervisor itself, and share the page back with the host.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  7 ++-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 52 ++++++++++++++++---
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 9c227d87c36d..b39047463075 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -23,6 +23,7 @@ extern struct host_kvm host_kvm;
 int __pkvm_prot_finalize(void);
 int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
 
+int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index cdace80d3e28..6f28edf58407 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -235,6 +235,11 @@ static bool host_stage2_want_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot pro
 		return prot != KVM_PGTABLE_PROT_RW;
 }
 
+int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot)
+{
+	return host_stage2_try(__host_stage2_idmap, start, end, prot);
+}
+
 static int host_stage2_idmap(u64 addr)
 {
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_RW;
@@ -250,7 +255,7 @@ static int host_stage2_idmap(u64 addr)
 	if (ret)
 		goto unlock;
 
-	ret = host_stage2_try(__host_stage2_idmap, range.start, range.end, prot);
+	ret = host_stage2_idmap_locked(range.start, range.end, prot);
 unlock:
 	hyp_spin_unlock(&host_kvm.lock);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 0b574d106519..74dce83a6fad 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -83,10 +83,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
-	ret = pkvm_create_mappings(__start_rodata, __end_rodata, PAGE_HYP_RO);
-	if (ret)
-		return ret;
-
 	ret = pkvm_create_mappings(__hyp_rodata_start, __hyp_rodata_end, PAGE_HYP_RO);
 	if (ret)
 		return ret;
@@ -95,10 +91,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
-	ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop, PAGE_HYP_RO);
-	if (ret)
-		return ret;
-
 	ret = pkvm_create_mappings(virt, virt + size, PAGE_HYP);
 	if (ret)
 		return ret;
@@ -117,6 +109,25 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
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
+	ret = pkvm_create_mappings(__start_rodata, __end_rodata,
+				   PAGE_HYP_RO | KVM_PGTABLE_STATE_SHARED);
+	if (ret)
+		return ret;
+
+	ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop,
+				   PAGE_HYP_RO | KVM_PGTABLE_STATE_SHARED);
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
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_RWX;
+	int ret;
+
+	/*
+	 * The host's .bss and .rodata sections are now conceptually owned by
+	 * the hypervisor, so mark them as 'borrowed' in the host stage-2. We
+	 * can safely use host_stage2_idmap_locked() at this point since the
+	 * host stage-2 has not been enabled yet.
+	 */
+	prot |= KVM_PGTABLE_STATE_SHARED | KVM_PGTABLE_STATE_BORROWED;
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
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
