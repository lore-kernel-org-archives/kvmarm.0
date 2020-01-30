Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11728C3524A
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:26:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BBA5621734
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:26:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQE5L7PH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBA5621734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 762334AEA0;
	Thu, 30 Jan 2020 08:26:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r+pj9xVJ04sy; Thu, 30 Jan 2020 08:26:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05ADD4AEDC;
	Thu, 30 Jan 2020 08:26:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DECC54AC84
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:26:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UfIxR3ezDkOP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 08:26:18 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 376364AEB4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:26:17 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6313C2253D;
 Thu, 30 Jan 2020 13:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1580390776;
 bh=sU3BN8Mr1a6hHJBH+fD0D7nFUL2EjE2fR14sj2cpogk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RQE5L7PHLSJdraQXk9r6p2fkp+0+sjJEipYB0nxWtgDIDuWzS+cx1b6b9rlmAsLMK
 8o3AY8vMkLO8R5LKEc4U7L0oAPIwP9WmCIpSVGRJK/CtEuyWFdqvvhf4GQhJKjphmm
 0k6rSKZrjeaw9totwXTrFkvBIjMGl+fjDMrMUtEc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1ix9pm-002BmW-N0; Thu, 30 Jan 2020 13:26:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 07/23] KVM: arm/arm64: Re-check VMA on detecting a poisoned
 page
Date: Thu, 30 Jan 2020 13:25:42 +0000
Message-Id: <20200130132558.10201-8-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130132558.10201-1-maz@kernel.org>
References: <20200130132558.10201-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 drjones@redhat.com, andrew.murray@arm.com, beata.michalska@linaro.org,
 christoffer.dall@arm.com, eric.auger@redhat.com, gshan@redhat.com,
 wanghaibin.wang@huawei.com, james.morse@arm.com, broonie@kernel.org,
 mark.rutland@arm.com, rmk+kernel@armlinux.org.uk,
 shannon.zhao@linux.alibaba.com, steven.price@arm.com, will@kernel.org,
 yuehaibing@huawei.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 YueHaibing <yuehaibing@huawei.com>, Steven Price <steven.price@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 Russell King <rmk+kernel@armlinux.org.uk>, Mark Brown <broonie@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Andrew Murray <andrew.murray@arm.com>
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

From: James Morse <james.morse@arm.com>

When we check for a poisoned page, we use the VMA to tell userspace
about the looming disaster. But we pass a pointer to this VMA
after having released the mmap_sem, which isn't a good idea.

Instead, stash the shift value that goes with this pfn while
we are holding the mmap_sem.

Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Link: https://lore.kernel.org/r/20191211165651.7889-3-maz@kernel.org
Link: https://lore.kernel.org/r/20191217123809.197392-1-james.morse@arm.com
---
 virt/kvm/arm/mmu.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0b32a904a1bb..e3ad95013192 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1596,16 +1596,8 @@ static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
 	__invalidate_icache_guest_page(pfn, size);
 }
 
-static void kvm_send_hwpoison_signal(unsigned long address,
-				     struct vm_area_struct *vma)
+static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
-	short lsb;
-
-	if (is_vm_hugetlb_page(vma))
-		lsb = huge_page_shift(hstate_vma(vma));
-	else
-		lsb = PAGE_SHIFT;
-
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
 }
 
@@ -1678,6 +1670,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
+	short vma_shift;
 	kvm_pfn_t pfn;
 	pgprot_t mem_type = PAGE_S2;
 	bool logging_active = memslot_is_logging(memslot);
@@ -1701,7 +1694,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	vma_pagesize = vma_kernel_pagesize(vma);
+	if (is_vm_hugetlb_page(vma))
+		vma_shift = huge_page_shift(hstate_vma(vma));
+	else
+		vma_shift = PAGE_SHIFT;
+
+	vma_pagesize = 1ULL << vma_shift;
 	if (logging_active ||
 	    (vma->vm_flags & VM_PFNMAP) ||
 	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
@@ -1741,7 +1739,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(hva, vma);
+		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
 	if (is_error_noslot_pfn(pfn))
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
