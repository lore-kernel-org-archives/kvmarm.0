From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 23/26] KVM: arm/arm64: GICv4: Prevent a VM using GICv4
 from being saved
Date: Tue, 7 Nov 2017 16:24:32 +0100
Message-ID: <1f75a11a-41c3-71b8-6abf-4aa2962e348e@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-24-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-24-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

Hi Marc,
On 27/10/2017 16:28, Marc Zyngier wrote:
> The GICv4 architecture doesn't make it easy for save/restore to
> work, as it doesn't give any guarantee that the pending state
> is written into the pending table.

I don't understand where does the limitation exactly come from. Can't we
use the GICR_VPENDBASER table data?

Thanks

Eric
> 
> So let's not take any chance, and let's return an error if
> we encounter any LPI that has the HW bit set. In order for
> userspace to distinguish this error from other failure modes,
> use -EACCES as an error code.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  Documentation/virtual/kvm/devices/arm-vgic-its.txt | 2 ++
>  virt/kvm/arm/vgic/vgic-its.c                       | 9 +++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> index eb06beb75960..1eec7bcb2d52 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
> @@ -60,6 +60,8 @@ Groups:
>      -EINVAL: Inconsistent restored data
>      -EFAULT: Invalid guest ram access
>      -EBUSY:  One or more VCPUS are running
> +    -EACCES: The virtual ITS is backed by a physical GICv4 ITS, and the
> +    	     state is not available
>  
>    KVM_DEV_ARM_VGIC_GRP_ITS_REGS
>    Attributes:
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index eb72eb027060..2710834d0920 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1989,6 +1989,15 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
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
> +			return -EACCES;
> +
>  		ret = vgic_its_save_ite(its, device, ite, gpa, ite_esz);
>  		if (ret)
>  			return ret;
> 
