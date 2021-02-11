Return-Path: <SRS0=hpFi=HN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E655BC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Feb 2021 14:27:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 306FA64E13
	for <kvmarm@archiver.kernel.org>; Thu, 11 Feb 2021 14:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 306FA64E13
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF3024B6CB;
	Thu, 11 Feb 2021 09:27:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UvX-y3nLbebJ; Thu, 11 Feb 2021 09:27:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B3DE4B6D5;
	Thu, 11 Feb 2021 09:27:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BA264B42A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2021 09:27:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MhPLSqZleKyd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2021 09:27:54 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EF5B4B40F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2021 09:27:54 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CEEC364E14;
 Thu, 11 Feb 2021 14:27:52 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lACwg-00DYwa-7G; Thu, 11 Feb 2021 14:27:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH] KVM: arm64: Handle CMOs on Read Only memslots
Date: Thu, 11 Feb 2021 14:27:38 +0000
Message-Id: <20210211142738.1478292-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, will@kernel.org, kernel-team@android.com,
 jianyong.wu@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

It appears that when a guest traps into KVM because it is
performing a CMO on a Read Only memslot, our handling of
this operation is "slightly suboptimal", as we treat it as
an MMIO access without a valid syndrome.

The chances that userspace is adequately equiped to deal
with such an exception being slim, it would be better to
handle it in the kernel.

What we need to provide is roughly as follows:

(a) if a CMO hits writeable memory, handle it as a normal memory acess
(b) if a CMO hits non-memory, skip it
(c) if a CMO hits R/O memory, that's where things become fun:
  (1) if the CMO is DC IVAC, the architecture says this should result
      in a permission fault
  (2) if the CMO is DC CIVAC, it should work similarly to (a)

We already perform (a) and (b) correctly, but (c) is a total mess.
Hence we need to distinguish between IVAC (c.1) and CIVAC (c.2).

One way to do it is to treat CMOs generating a translation fault as
a *read*, even when they are on a RW memslot. This allows us to
further triage things:

If they come back with a permission fault, that is because this is
a DC IVAC instruction:
- inside a RW memslot: no problem, treat it as a write (a)(c.2)
- inside a RO memslot: inject a data abort in the guest (c.1)

The only drawback is that DC IVAC on a yet unmapped page faults
twice: one for the initial translation fault that result in a RO
mapping, and once for the permission fault. I think we can live with
that.

Reported-by: Jianyong Wu <jianyong.wu@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---

Notes:
    I have taken the option to inject an abort in the guest when
    it issues a DC IVAC on a R/O memslot, but another option would
    be to just perform the invalidation ourselves as a DC CIAVAC.
    
    This would have the advantage of being consistent with what we
    do for emulated MMIO.

 arch/arm64/kvm/mmu.c | 53 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7d2257cc5438..c7f4388bea45 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -760,7 +760,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct kvm_pgtable *pgt;
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
-	write_fault = kvm_is_write_fault(vcpu);
+	/*
+	 * Treat translation faults on CMOs as read faults. Should
+	 * this further generate a permission fault on a R/O memslot,
+	 * it will be caught in kvm_handle_guest_abort(), with
+	 * prejudice. Permission faults on non-R/O memslot will be
+	 * gracefully handled as writes.
+	 */
+	if (fault_status == FSC_FAULT && kvm_vcpu_dabt_is_cm(vcpu))
+		write_fault = false;
+	else
+		write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_BUG_ON(write_fault && exec_fault);
 
@@ -1013,19 +1023,37 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		}
 
 		/*
-		 * Check for a cache maintenance operation. Since we
-		 * ended-up here, we know it is outside of any memory
-		 * slot. But we can't find out if that is for a device,
-		 * or if the guest is just being stupid. The only thing
-		 * we know for sure is that this range cannot be cached.
+		 * Check for a cache maintenance operation. Three cases:
+		 *
+		 * - It is outside of any memory slot. But we can't find out
+		 *   if that is for a device, or if the guest is just being
+		 *   stupid. The only thing we know for sure is that this
+		 *   range cannot be cached.  So let's assume that the guest
+		 *   is just being cautious, and skip the instruction.
+		 *
+		 * - Otherwise, check whether this is a permission fault.
+		 *   If so, that's a DC IVAC on a R/O memslot, which is a
+		 *   pretty bad idea, and we tell the guest so.
 		 *
-		 * So let's assume that the guest is just being
-		 * cautious, and skip the instruction.
+		 * - If this wasn't a permission fault, pass it along for
+		 *   further handling (including faulting the page in if it
+		 *   was a translation fault).
 		 */
-		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
-			kvm_incr_pc(vcpu);
-			ret = 1;
-			goto out_unlock;
+		if (kvm_vcpu_dabt_is_cm(vcpu)) {
+			if (kvm_is_error_hva(hva)) {
+				kvm_incr_pc(vcpu);
+				ret = 1;
+				goto out_unlock;
+			}
+
+			if (fault_status == FSC_PERM) {
+				/* DC IVAC on a R/O memslot */
+				kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+				ret = 1;
+				goto out_unlock;
+			}
+
+			goto handle_access;
 		}
 
 		/*
@@ -1039,6 +1067,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
+handle_access:
 	/* Userspace should not be able to register out-of-bounds IPAs */
 	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
 
-- 
2.30.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
