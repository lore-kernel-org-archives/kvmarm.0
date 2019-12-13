Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B7EC43603
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 21:33:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B21C824681
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 21:33:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B21C824681
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1DB64AEBD;
	Fri, 13 Dec 2019 13:27:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JHwt3UCyarHe; Fri, 13 Dec 2019 13:27:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB13C4AEDE;
	Fri, 13 Dec 2019 13:27:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6011A4AEBD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 13:27:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z04lFn1kuiWX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 13:27:52 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87E734A534
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 13:27:52 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ifpdI-0001O7-2m; Fri, 13 Dec 2019 19:25:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: 
Subject: [PATCH 5/7] KVM: arm/arm64: Elide both CMOs and TBLIs on freeing the
 whole Stage-2
Date: Fri, 13 Dec 2019 18:25:01 +0000
Message-Id: <20191213182503.14460-6-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213182503.14460-1-maz@kernel.org>
References: <20191213182503.14460-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, jhogan@kernel.org, paulus@ozlabs.org,
 pbonzini@redhat.com, rkrcmar@redhat.com, sean.j.christopherson@intel.com,
 vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
 joro@8bytes.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm-ppc@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, James Hogan <jhogan@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paul Mackerras <paulus@ozlabs.org>, linux-arm-kernel@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

When freeing the whole of a VM's Stage-2 page tables, there is
little point in doing cache maintenance on each and every page
(the guest won't be running anymore, let alone having its MMU
off). As for TLBs, there is no point in invalidating individual
pages, as we can replace the whole thing with a VMALL operation,
which invalidates all the TLBs for this VM in one go.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 4399866842dc..d7c710491d26 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1016,10 +1016,13 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
-		unmap_stage2_range(kvm, 0, kvm_phys_size(kvm), 0);
+		unmap_stage2_range(kvm, 0, kvm_phys_size(kvm),
+				   KVM_UNMAP_ELIDE_CMO | KVM_UNMAP_ELIDE_TBLI);
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 		kvm->arch.pgd_phys = 0;
+
+		kvm_flush_remote_tlbs(kvm);
 	}
 	spin_unlock(&kvm->mmu_lock);
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
