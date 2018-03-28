From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 63/85] KVM: arm/arm64: Fix idmap size and alignment
Date: Wed, 28 Mar 2018 13:52:32 +0100
Message-ID: <20180328125254.31380-64-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C6984A051
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:58:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H30yZM45hNJI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:58:25 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27E174A0D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:49:17 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Although the idmap section of KVM can only be at most 4kB and
must be aligned on a 4kB boundary, the rest of the code expects
it to be page aligned. Things get messy when tearing down the
HYP page tables when PAGE_SIZE is 64K, and the idmap section isn't
64K aligned.

Let's fix this by computing aligned boundaries that the HYP code
will use.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: James Morse <james.morse@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 52b0ee31ebee..c41d03a8af93 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1815,7 +1815,9 @@ int kvm_mmu_init(void)
 	int err;
 
 	hyp_idmap_start = kvm_virt_to_phys(__hyp_idmap_text_start);
+	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
 	hyp_idmap_end = kvm_virt_to_phys(__hyp_idmap_text_end);
+	hyp_idmap_end = ALIGN(hyp_idmap_end, PAGE_SIZE);
 	hyp_idmap_vector = kvm_virt_to_phys(__kvm_hyp_init);
 
 	/*
-- 
2.14.2
