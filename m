From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 23/26] KVM: arm/arm64: GICv4: Prevent a VM using GICv4
 from being saved
Date: Thu, 26 Oct 2017 17:28:28 +0200
Message-ID: <20171026152828.GD2166@lvm>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-24-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171006153401.5481-24-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 04:33:58PM +0100, Marc Zyngier wrote:
> The GICv4 architecture doesn't make it easy for save/restore to
> work, as it doesn't give any guarantee that the pending state
> is written into the pending table.
> 
> So let's not take any chance, and let's return an error if
> we encounter any LPI that has the HW bit set.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index f434748439ee..01aa4d9d405e 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1987,6 +1987,15 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
>  	list_for_each_entry(ite, &device->itt_head, ite_list) {
>  		gpa_t gpa = base + ite->event_id * ite_esz;
>  
> +		/*
> +		 * If an LPI carries the HW bit, this means that this
> +		 * interrupt is controlled by GICv4, and we do not
> +		 * have direct access to that state. Let's simply fail
> +		 * the save operation...
> +		 */
> +		if (ite->irq->hw)
> +			return -EINVAL;

Will this conflict with other error messages, and will QEMU have a
reasonable way to tell the user what's going on?

Perhaps we shoul document the return code in the ITS device doc and
choose something unique, like -EBUSY?

Thanks,
-Christoffer

> +
>  		ret = vgic_its_save_ite(its, device, ite, gpa, ite_esz);
>  		if (ret)
>  			return ret;
> -- 
> 2.14.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
