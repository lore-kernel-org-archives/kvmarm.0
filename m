From: James Hogan <jhogan@kernel.org>
Subject: Re: [PULL RESEND v2 3/4] KVM: Remove obsolete kvm_unmap_hva notifier
 backend
Date: Mon, 10 Sep 2018 07:13:30 +0100
Message-ID: <8296829C-41B7-4E3B-9EC9-5C832CBD0EC2@kernel.org>
References: <20180907131256.2412-1-christoffer.dall@arm.com>
 <20180907131256.2412-4-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180907131256.2412-4-christoffer.dall@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 7 September 2018 14:12:55 BST, Christoffer Dall <christoffer.dall@arm.com> wrote:
>From: Marc Zyngier <marc.zyngier@arm.com>
>
>kvm_unmap_hva is long gone, and we only have kvm_unmap_hva_range to
>deal with. Drop the now obsolete code.
>
>Fixes: fb1522e099f0 ("KVM: update to new mmu_notifier semantic v2")
>Cc: James Hogan <jhogan@kernel.org>
>Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>---

> arch/mips/include/asm/kvm_host.h  |  1 -
> arch/mips/kvm/mmu.c               | 10 ----------

>diff --git a/arch/mips/include/asm/kvm_host.h
>b/arch/mips/include/asm/kvm_host.h
>index a9af1d2dcd69..2c1c53d12179 100644
>--- a/arch/mips/include/asm/kvm_host.h
>+++ b/arch/mips/include/asm/kvm_host.h
>@@ -931,7 +931,6 @@ enum kvm_mips_fault_result
>kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
> 						   bool write);
> 
> #define KVM_ARCH_WANT_MMU_NOTIFIER
>-int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
> int kvm_unmap_hva_range(struct kvm *kvm,
> 			unsigned long start, unsigned long end);
> void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
>index ee64db032793..d8dcdb350405 100644
>--- a/arch/mips/kvm/mmu.c
>+++ b/arch/mips/kvm/mmu.c
>@@ -512,16 +512,6 @@ static int kvm_unmap_hva_handler(struct kvm *kvm,
>gfn_t gfn, gfn_t gfn_end,
> 	return 1;
> }
> 
>-int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
>-{
>-	unsigned long end = hva + PAGE_SIZE;
>-
>-	handle_hva_to_gpa(kvm, hva, end, &kvm_unmap_hva_handler, NULL);
>-
>-	kvm_mips_callbacks->flush_shadow_all(kvm);
>-	return 0;
>-}
>-
>int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned
>long end)
> {
> 	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);

Looks good to me. For MIPS:

Acked-by: James Hogan <jhogan@kernel.org>

thanks
James
