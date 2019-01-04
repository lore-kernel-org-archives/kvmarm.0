From: lantianyu1986@gmail.com
Subject: [PATCH 00/11] X86/KVM/Hyper-V: Add HV ept tlb range list flush support in KVM
Date: Fri,  4 Jan 2019 16:53:54 +0800
Message-ID: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, christoffer.dall@arm.com, devel@linuxdriverproject.org, haiyangz@microsoft.com, hpa@zytor.com, jhogan@kernel.org, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org, kys@microsoft.com, linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, marc.zyngier@arm.com, mingo@redhat.com, mpe@ellerman.id.au, paul.burton@mips.com, paulus@ozlabs.org, pbonzini@redhat.com, ralf@linux-mips.org, rkrcmar@redhat.com, sthemmin@microsoft.com, tglx@linutronix.de, will.deacon@arm.com, x86@kernel.org, michael.h.kelley@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

This patchset is to introduce hv ept tlb range list flush function
support in the KVM MMU component. Flushing ept tlbs of several address
range can be done via single hypercall and new list flush function is
used in the kvm_mmu_commit_zap_page() and FNAME(sync_page). This patchset
also adds more hv ept tlb range flush support in more KVM MMU function.

Lan Tianyu (11):
  X86/Hyper-V: Add parameter offset for
    hyperv_fill_flush_guest_mapping_list()
  KVM/VMX: Fill range list in kvm_fill_hv_flush_list_func()
  KVM: Add spte's point in the struct kvm_mmu_page
  KVM/MMU: Introduce tlb flush with range list
  KVM/MMU: Flush tlb directly in the kvm_mmu_slot_gfn_write_protect()
  KVM/MMU: Flush tlb with range list in sync_page()
  KVM: Remove redundant check in the kvm_get_dirty_log_protect()
  KVM: Make kvm_arch_mmu_enable_log_dirty_pt_masked() return value
  KVM/MMU: Flush tlb in the kvm_mmu_write_protect_pt_masked()
  KVM: Add flush parameter for kvm_age_hva()
  KVM/MMU: Flush tlb in the kvm_age_rmapp()

 arch/arm/include/asm/kvm_host.h     |  3 +-
 arch/arm64/include/asm/kvm_host.h   |  3 +-
 arch/mips/include/asm/kvm_host.h    |  3 +-
 arch/mips/kvm/mmu.c                 |  8 +++-
 arch/powerpc/include/asm/kvm_host.h |  3 +-
 arch/powerpc/kvm/book3s.c           |  3 +-
 arch/powerpc/kvm/e500_mmu_host.c    |  3 +-
 arch/x86/hyperv/nested.c            |  4 +-
 arch/x86/include/asm/kvm_host.h     | 11 +++++-
 arch/x86/include/asm/mshyperv.h     |  2 +-
 arch/x86/kvm/mmu.c                  | 73 ++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/paging_tmpl.h          | 18 ++++++++-
 arch/x86/kvm/vmx/vmx.c              | 18 ++++++++-
 include/linux/kvm_host.h            |  2 +-
 virt/kvm/arm/mmu.c                  |  8 +++-
 virt/kvm/kvm_main.c                 | 18 ++++-----
 16 files changed, 141 insertions(+), 39 deletions(-)

-- 
2.14.4
