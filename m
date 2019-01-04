From: lantianyu1986@gmail.com
Subject: [PATCH 6/11] KVM/MMU: Flush tlb with range list in sync_page()
Date: Fri,  4 Jan 2019 16:54:00 +0800
Message-ID: <20190104085405.40356-7-Tianyu.Lan@microsoft.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FCA84A3A4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 03:55:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6fwJKVtTHNl9 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jan 2019 03:55:05 -0500 (EST)
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com
 [209.85.214.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B1F74A375
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 03:55:05 -0500 (EST)
Received: by mail-pl1-f196.google.com with SMTP id b5so17163419plr.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Jan 2019 00:55:05 -0800 (PST)
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

This patch is to flush tlb via flush list function.

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
 arch/x86/kvm/paging_tmpl.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 833e8855bbc9..866ccdea762e 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -973,6 +973,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	bool host_writable;
 	gpa_t first_pte_gpa;
 	int set_spte_ret = 0;
+	LIST_HEAD(flush_list);
 
 	/* direct kvm_mmu_page can not be unsync. */
 	BUG_ON(sp->role.direct);
@@ -980,6 +981,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+		int tmp_spte_ret = 0;
 		unsigned pte_access;
 		pt_element_t gpte;
 		gpa_t pte_gpa;
@@ -1029,14 +1031,24 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
 
-		set_spte_ret |= set_spte(vcpu, &sp->spt[i],
+		tmp_spte_ret = set_spte(vcpu, &sp->spt[i],
 					 pte_access, PT_PAGE_TABLE_LEVEL,
 					 gfn, spte_to_pfn(sp->spt[i]),
 					 true, false, host_writable);
+
+		if (kvm_available_flush_tlb_with_range()
+		    && (tmp_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH)) {
+			struct kvm_mmu_page *leaf_sp = page_header(sp->spt[i]
+					& PT64_BASE_ADDR_MASK);
+			list_add(&leaf_sp->flush_link, &flush_list);
+		}
+
+		set_spte_ret |= tmp_spte_ret;
+
 	}
 
 	if (set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH)
-		kvm_flush_remote_tlbs(vcpu->kvm);
+		kvm_flush_remote_tlbs_with_list(vcpu->kvm, &flush_list);
 
 	return nr_present;
 }
-- 
2.14.4
