From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 10/10] KVM: arm/arm64: vgic-its: Implement
 KVM_DEV_ARM_ITS_CTRL_RESET
Date: Wed, 25 Oct 2017 11:52:21 +0100
Message-ID: <864lqnebyy.fsf@arm.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
 <1508767709-15256-11-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C14840EA6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 06:51:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 941n5pzM4lRQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Oct 2017 06:51:07 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFAE040651
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 06:51:06 -0400 (EDT)
In-Reply-To: <1508767709-15256-11-git-send-email-eric.auger@redhat.com> (Eric
 Auger's message of "Mon, 23 Oct 2017 16:08:29 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, cdall@linaro.org, andre.przywara@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 23 2017 at  4:08:29 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> On reset we clear the valid bits of GITS_CBASER and GITS_BASER<n>.
> We also clear command queue registers and free the cache (device,
> collection, and lpi lists).
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>
> ---
>
> v2 -> v3:
> - added Christoffer's R-b
> ---
>  arch/arm/include/uapi/asm/kvm.h   |  1 +
>  arch/arm64/include/uapi/asm/kvm.h |  1 +
>  virt/kvm/arm/vgic/vgic-its.c      | 18 ++++++++++++++++++
>  3 files changed, 20 insertions(+)
>
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 5db2d4c..7ef0c06 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -215,6 +215,7 @@ struct kvm_arch_memory_slot {
>  #define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
>  #define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
>  #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
> +#define   KVM_DEV_ARM_ITS_CTRL_RESET		4
>  
>  /* KVM_IRQ_LINE irq field index values */
>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9f3ca24..b5306ce 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -227,6 +227,7 @@ struct kvm_arch_memory_slot {
>  #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
>  #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
>  #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
> +#define   KVM_DEV_ARM_ITS_CTRL_RESET		4
>  
>  /* Device Control API on vcpu fd */
>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index bdfceb4..64b6b04 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2395,6 +2395,19 @@ static int vgic_its_commit_v0(struct vgic_its *its)
>  	return 0;
>  }
>  
> +static void vgic_its_reset(struct kvm *kvm, struct vgic_its *its)
> +{
> +	/* We need to keep the ABI specific field values */
> +	its->baser_coll_table &= ~GITS_BASER_VALID;
> +	its->baser_device_table &= ~GITS_BASER_VALID;
> +	its->cbaser = 0;
> +	its->creadr = 0;
> +	its->cwriter = 0;
> +	its->enabled = 0;
> +	vgic_its_free_device_list(kvm, its);
> +	vgic_its_free_collection_list(kvm, its);

I sense a problem here. There is no locking when resetting the fields,
and there is no guarantee that no vcpus are running at this stage (we
rely on a well behaved userspace).

How do we ensure this? We should move the checks we have in the
save/restore functions to a common location vgic_its_set_attr and
protect all the call sites.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
