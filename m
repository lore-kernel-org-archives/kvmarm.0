From: lantianyu1986@gmail.com
Subject: [PATCH V3 2/10] KVM/VMX: Fill range list in kvm_fill_hv_flush_list_func()
Date: Fri, 22 Feb 2019 23:06:29 +0800
Message-ID: <20190222150637.2337-3-Tianyu.Lan@microsoft.com>
References: <20190222150637.2337-1-Tianyu.Lan@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222150637.2337-1-Tianyu.Lan@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au, pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, michael.h.kelley@microsoft.com, kys@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

Populate ranges on the flush list into struct hv_guest_mapping_flush_list
when flush list is available in the struct kvm_tlb_range.

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
Change since v2:
	- Fix calculation of flush pages in the kvm_fill_hv_flush_list_func()
---
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 18 ++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 875ae7256608..9fc9dd0c92cb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -318,6 +318,12 @@ struct kvm_rmap_head {
 
 struct kvm_mmu_page {
 	struct list_head link;
+
+	/*
+	 * Tlb flush with range list uses struct kvm_mmu_page as list entry
+	 * and all list operations should be under protection of mmu_lock.
+	 */
+	struct hlist_node flush_link;
 	struct hlist_node hash_link;
 	bool unsync;
 	bool mmio_cached;
@@ -441,6 +447,7 @@ struct kvm_mmu {
 struct kvm_tlb_range {
 	u64 start_gfn;
 	u64 pages;
+	struct hlist_head *flush_list;
 };
 
 enum pmc_type {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 77b5379e3655..85139d318490 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -432,9 +432,23 @@ static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush
 		void *data)
 {
 	struct kvm_tlb_range *range = data;
+	struct kvm_mmu_page *sp;
 
-	return hyperv_fill_flush_guest_mapping_list(flush, 0, range->start_gfn,
-			range->pages);
+	if (!range->flush_list) {
+		return hyperv_fill_flush_guest_mapping_list(flush,
+			0, range->start_gfn, range->pages);
+	} else {
+		int offset = 0;
+
+		hlist_for_each_entry(sp, range->flush_list, flush_link) {
+			int pages = KVM_PAGES_PER_HPAGE(sp->role.level + 1);
+
+			offset = hyperv_fill_flush_guest_mapping_list(flush,
+					offset, sp->gfn, pages);
+		}
+
+		return offset;
+	}
 }
 
 static inline int __hv_remote_flush_tlb_with_range(struct kvm *kvm,
-- 
2.14.4
