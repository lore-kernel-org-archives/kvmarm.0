From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 08/10] KVM: arm/arm64: vgic-its: Free caches when
 GITS_BASER Valid bit is cleared
Date: Wed, 25 Oct 2017 11:23:09 +0100
Message-ID: <86mv4fedbm.fsf@arm.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
 <1508767709-15256-9-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51115406BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 06:22:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oj86qw6RNBHN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Oct 2017 06:21:55 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1724440418
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 06:21:55 -0400 (EDT)
In-Reply-To: <1508767709-15256-9-git-send-email-eric.auger@redhat.com> (Eric
 Auger's message of "Mon, 23 Oct 2017 16:08:27 +0200")
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

On Mon, Oct 23 2017 at  4:08:27 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> When the GITS_BASER<n>.Valid gets cleared, the data structures in
> guest RAM are not valid anymore. The device, collection
> and LPI lists stored in the in-kernel ITS represent the same
> information in some form of cache. So let's void the cache.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
> v4 -> v5:
> - add comment about locking
>
> v2 -> v3:
> - add a comment and clear cache in if block
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 8098f91..bdfceb4 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1434,8 +1434,9 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>  				      unsigned long val)
>  {
>  	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> -	u64 entry_size, device_type;
> +	u64 entry_size;
>  	u64 reg, *regptr, clearbits = 0;
> +	int type;
>  
>  	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
>  	if (its->enabled)
> @@ -1445,12 +1446,12 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>  	case 0:
>  		regptr = &its->baser_device_table;
>  		entry_size = abi->dte_esz;
> -		device_type = GITS_BASER_TYPE_DEVICE;
> +		type = GITS_BASER_TYPE_DEVICE;
>  		break;
>  	case 1:
>  		regptr = &its->baser_coll_table;
>  		entry_size = abi->cte_esz;
> -		device_type = GITS_BASER_TYPE_COLLECTION;
> +		type = GITS_BASER_TYPE_COLLECTION;
>  		clearbits = GITS_BASER_INDIRECT;
>  		break;
>  	default:
> @@ -1462,10 +1463,28 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>  	reg &= ~clearbits;
>  
>  	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
> -	reg |= device_type << GITS_BASER_TYPE_SHIFT;
> +	reg |= (u64)type << GITS_BASER_TYPE_SHIFT;

Nit: Why having changed the type to being an int? The existing type (u64) was
perfectly sane, and avoids the ugly cast. Also, table_type would be more
explicit than the pretty generic "type".

>  	reg = vgic_sanitise_its_baser(reg);
>  
>  	*regptr = reg;
> +
> +	/*
> +	 * If the table is no longer valid, we clear the associated cached data.
> +	 * Note: there cannot be any race with save/restore code which locks
> +	 * all vcpus.
> +	 */
> +	if (!(reg & GITS_BASER_VALID)) {
> +		switch (type) {
> +		case GITS_BASER_TYPE_DEVICE:
> +			vgic_its_free_device_list(kvm, its);
> +			break;
> +		case GITS_BASER_TYPE_COLLECTION:
> +			vgic_its_free_collection_list(kvm, its);
> +			break;
> +		default:
> +			break;

Nit: this default clause is useless.

> +		}
> +	}
>  }
>  
>  static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,

Otherwise:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
