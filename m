From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 06/12] KVM: mark kvm->buses as empty once they were
 destroyed
Date: Wed, 25 Mar 2015 17:09:13 +0000
Message-ID: <5512EBB9.2050304@arm.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com> <1427126309-11223-7-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427126309-11223-7-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "n.nikolaev@virtualopensystems.com" <n.nikolaev@virtualopensystems.com>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Marcelo Tosatti <mtosatti@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/03/15 15:58, Andre Przywara wrote:
> In kvm_destroy_vm() we call kvm_io_bus_destroy() pretty early,
> especially before calling kvm_arch_destroy_vm(). To avoid
> unregistering devices from the already destroyed bus, let's mark
> the bus with NULL to let other users know it has been destroyed
> already.
> This avoids a crash on a VM shutdown with the VGIC using the
> kvm_io_bus later (the unregistering is in there to be able to roll
> back a faulting init).
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

That seems sensible, but I don't see why nobody else hits that. What are
we doing differently?

Otherwise,

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Paolo, Marcelo, can we have your Ack on this?

Thanks,

	M.

> ---
>  virt/kvm/kvm_main.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8c7ab0b..6f164eb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -604,8 +604,10 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	list_del(&kvm->vm_list);
>  	spin_unlock(&kvm_lock);
>  	kvm_free_irq_routing(kvm);
> -	for (i = 0; i < KVM_NR_BUSES; i++)
> +	for (i = 0; i < KVM_NR_BUSES; i++) {
>  		kvm_io_bus_destroy(kvm->buses[i]);
> +		kvm->buses[i] = NULL;
> +	}
>  	kvm_coalesced_mmio_free(kvm);
>  #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
>  	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
> 


-- 
Jazz is not dead. It just smells funny...
