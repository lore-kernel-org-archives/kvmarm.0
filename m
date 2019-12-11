Return-Path: <SRS0=JFMI=2B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71D5C43603
	for <kvmarm@archiver.kernel.org>; Wed, 11 Dec 2019 16:57:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A066F22527
	for <kvmarm@archiver.kernel.org>; Wed, 11 Dec 2019 16:57:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A066F22527
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58C174AF06;
	Wed, 11 Dec 2019 11:57:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VVOiTIpMuUOy; Wed, 11 Dec 2019 11:57:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5118A4AEEC;
	Wed, 11 Dec 2019 11:57:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9FF94AEA7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Dec 2019 11:57:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wIVlLnlYSEhV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Dec 2019 11:57:07 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E14CF4AEB2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Dec 2019 11:57:06 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1if5IP-00076q-7X; Wed, 11 Dec 2019 17:57:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] KVM: arm/arm64: Re-check VMA on detecting a poisoned page
Date: Wed, 11 Dec 2019 16:56:49 +0000
Message-Id: <20191211165651.7889-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211165651.7889-1-maz@kernel.org>
References: <20191211165651.7889-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 Christoffer.Dall@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
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

When we check for a poisoned page, we use the VMA to tell userspace
about the looming disaster. But we pass a pointer to this VMA
after having released the mmap_sem, which isn't a good idea.

Instead, re-check that we have still have a VMA, and that this
VMA still points to a poisoned page. If the VMA isn't there,
userspace is playing with our nerves, so lety's give it a -EFAULT
(it deserves it). If the PFN isn't poisoned anymore, let's restart
from the top and handle the fault again.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/mmu.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0b32a904a1bb..f73393f5ddb7 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1741,9 +1741,30 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(hva, vma);
-		return 0;
+		/*
+		 * Search for the VMA again, as it may have been
+		 * removed in the interval...
+		 */
+		down_read(&current->mm->mmap_sem);
+		vma = find_vma_intersection(current->mm, hva, hva + 1);
+		if (vma) {
+			/*
+			 * Recheck for a poisoned page. If something changed
+			 * behind our back, don't do a thing and take the
+			 * fault again.
+			 */
+			pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
+			if (pfn == KVM_PFN_ERR_HWPOISON)
+				kvm_send_hwpoison_signal(hva, vma);
+
+			ret = 0;
+		} else {
+			ret = -EFAULT;
+		}
+		up_read(&current->mm->mmap_sem);
+		return ret;
 	}
+
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
