From: lantianyu1986@gmail.com
Subject: [PATCH 3/11] KVM: Add spte's point in the struct kvm_mmu_page
Date: Fri,  4 Jan 2019 16:53:57 +0800
Message-ID: <20190104085405.40356-4-Tianyu.Lan@microsoft.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D0FA4A39B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 03:54:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p4GoU14iCi-q for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jan 2019 03:54:43 -0500 (EST)
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com
 [209.85.210.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 40CDC4A32D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 03:54:43 -0500 (EST)
Received: by mail-pf1-f194.google.com with SMTP id c73so17983469pfe.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Jan 2019 00:54:43 -0800 (PST)
In-Reply-To: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, pbonzini@redhat.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

It's necessary to check whether mmu page is last or large page when add
mmu page into flush list. "spte" is needed for such check and so add
spte point in the struct kvm_mmu_page.

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu.c              | 5 +++++
 arch/x86/kvm/paging_tmpl.h      | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4660ce90de7f..78d2a6714c3b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -332,6 +332,7 @@ struct kvm_mmu_page {
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
 	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
+	u64 *sptep;
 
 	/* The page is obsolete if mmu_valid_gen != kvm->arch.mmu_valid_gen.  */
 	unsigned long mmu_valid_gen;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ce770b446238..068694fa2371 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3160,6 +3160,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, int write, int map_writable,
 			pseudo_gfn = base_addr >> PAGE_SHIFT;
 			sp = kvm_mmu_get_page(vcpu, pseudo_gfn, iterator.addr,
 					      iterator.level - 1, 1, ACC_ALL);
+			sp->sptep = iterator.sptep;
 
 			link_shadow_page(vcpu, iterator.sptep, sp);
 		}
@@ -3588,6 +3589,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		sp = kvm_mmu_get_page(vcpu, 0, 0,
 				vcpu->arch.mmu->shadow_root_level, 1, ACC_ALL);
 		++sp->root_count;
+		sp->sptep = NULL;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu->root_hpa = __pa(sp->spt);
 	} else if (vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL) {
@@ -3604,6 +3606,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 					i << 30, PT32_ROOT_LEVEL, 1, ACC_ALL);
 			root = __pa(sp->spt);
 			++sp->root_count;
+			sp->sptep = NULL;
 			spin_unlock(&vcpu->kvm->mmu_lock);
 			vcpu->arch.mmu->pae_root[i] = root | PT_PRESENT_MASK;
 		}
@@ -3644,6 +3647,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 				vcpu->arch.mmu->shadow_root_level, 0, ACC_ALL);
 		root = __pa(sp->spt);
 		++sp->root_count;
+		sp->sptep = NULL;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu->root_hpa = root;
 		return 0;
@@ -3681,6 +3685,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 				      0, ACC_ALL);
 		root = __pa(sp->spt);
 		++sp->root_count;
+		sp->sptep = NULL;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 
 		vcpu->arch.mmu->pae_root[i] = root | pm_mask;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6bdca39829bc..833e8855bbc9 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -633,6 +633,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			table_gfn = gw->table_gfn[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
 					      false, access);
+			sp->sptep = it.sptep;
 		}
 
 		/*
@@ -663,6 +664,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 
 		sp = kvm_mmu_get_page(vcpu, direct_gfn, addr, it.level-1,
 				      true, direct_access);
+		sp->sptep = it.sptep;
 		link_shadow_page(vcpu, it.sptep, sp);
 	}
 
-- 
2.14.4
