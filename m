From: Mukesh Ojha <mojha@codeaurora.org>
Subject: Re: [PATCH -next] KVM: arm: vgic: Make two functions static
Date: Thu, 21 Mar 2019 00:38:24 +0530
Message-ID: <de8edaed-a37b-f143-75d8-9db9c45c5543@codeaurora.org>
References: <20190320141813.10380-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320141813.10380-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, james.morse@arm.com, julien.thierry@arm.com, suzuki.poulose@arm.com, andre.przywara@arm.com
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu


On 3/20/2019 7:48 PM, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
>
> Fix sparse warnings:
>
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c:1732:5: warning:
>   symbol 'vgic_its_has_attr_regs' was not declared. Should it be static?
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c:1753:5: warning:
>   symbol 'vgic_its_attr_regs_access' was not declared. Should it be static?
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   virt/kvm/arm/vgic/vgic-its.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index ab3f477..a97db69 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1729,8 +1729,8 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
>   	kfree(its);
>   }
>   
> -int vgic_its_has_attr_regs(struct kvm_device *dev,
> -			   struct kvm_device_attr *attr)
> +static int vgic_its_has_attr_regs(struct kvm_device *dev,
> +				  struct kvm_device_attr *attr)
>   {
>   	const struct vgic_register_region *region;
>   	gpa_t offset = attr->attr;
> @@ -1750,9 +1750,9 @@ int vgic_its_has_attr_regs(struct kvm_device *dev,
>   	return 0;
>   }
>   
> -int vgic_its_attr_regs_access(struct kvm_device *dev,
> -			      struct kvm_device_attr *attr,
> -			      u64 *reg, bool is_write)
> +static int vgic_its_attr_regs_access(struct kvm_device *dev,
> +				     struct kvm_device_attr *attr,
> +				     u64 *reg, bool is_write)
>   {
>   	const struct vgic_register_region *region;
>   	struct vgic_its *its;


Acked-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
Mukesh
