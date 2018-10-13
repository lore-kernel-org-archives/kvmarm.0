From: lantianyu1986@gmail.com
Subject: [PATCH V4 1/15] KVM: Add tlb_remote_flush_with_range callback in kvm_x86_ops
Date: Sat, 13 Oct 2018 22:53:52 +0800
Message-ID: <20181013145406.4911-2-Tianyu.Lan@microsoft.com>
References: <20181013145406.4911-1-Tianyu.Lan@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013145406.4911-1-Tianyu.Lan@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au, kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, devel@linuxdriverproject.org, kvm@vger.kernel.org, michael.h.kelley@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

Add flush range call back in the kvm_x86_ops and platform can use it
to register its associated function. The parameter "kvm_tlb_range"
accepts a single range and flush list which contains a list of ranges.

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
Change since v1:
       Change "end_gfn" to "pages" to aviod confusion as to whether
"end_gfn" is inclusive or exlusive.
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4b09d4aa9bf4..fea95aa77319 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -439,6 +439,12 @@ struct kvm_mmu {
 	u64 pdptrs[4]; /* pae */
 };
 
+struct kvm_tlb_range {
+	u64 start_gfn;
+	u64 pages;
+	struct list_head *flush_list;
+};
+
 enum pmc_type {
 	KVM_PMC_GP = 0,
 	KVM_PMC_FIXED,
@@ -1039,6 +1045,8 @@ struct kvm_x86_ops {
 
 	void (*tlb_flush)(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 	int  (*tlb_remote_flush)(struct kvm *kvm);
+	int  (*tlb_remote_flush_with_range)(struct kvm *kvm,
+			struct kvm_tlb_range *range);
 
 	/*
 	 * Flush any TLB entries associated with the given GVA.
-- 
2.14.4
