From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 16/19] KVM: arm64: ITS: vgic_its_check_id returns the
 entry's GPA
Date: Tue, 21 Mar 2017 18:12:54 +0000
Message-ID: <be79d92f-2522-a754-f006-66901d26e94c@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-17-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7241C40A66
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 14:09:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iJ8dsHTYmuxH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 14:09:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53D0740A54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 14:09:13 -0400 (EDT)
In-Reply-To: <1488800074-21991-17-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 06/03/17 11:34, Eric Auger wrote:
> As vgic_its_check_id() computes the device/collection entry's
> GPA, let's return it so that new callers can retrieve it easily.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v2: new
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index ad67759..1060125 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -637,7 +637,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>   * is actually valid (covered by a memslot and guest accessible).
>   * For this we have to read the respective first level entry.
>   */
> -static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
> +static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id,
> +			      gpa_t *eaddr)
>  {
>  	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
>  	int index;
> @@ -657,6 +658,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
>  		addr = BASER_ADDRESS(baser) + id * esz;
>  		gfn = addr >> PAGE_SHIFT;
>  
> +		*eaddr = addr;

If you check that eaddr is not NULL before writing to it, you can save
the dummy variable in the two callers below (which doesn't hurt, but
does not help readability either).

Cheers,
Andre.

>  		return kvm_is_visible_gfn(its->dev->kvm, gfn);
>  	}
>  
> @@ -689,6 +691,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
>  	indirect_ptr += index * esz;
>  	gfn = indirect_ptr >> PAGE_SHIFT;
>  
> +	*eaddr = indirect_ptr;
>  	return kvm_is_visible_gfn(its->dev->kvm, gfn);
>  }
>  
> @@ -697,8 +700,9 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
>  				     u32 coll_id)
>  {
>  	struct its_collection *collection;
> +	gpa_t eaddr;
>  
> -	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id))
> +	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, &eaddr))
>  		return E_ITS_MAPC_COLLECTION_OOR;
>  
>  	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
> @@ -910,8 +914,9 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>  	size_t size = its_cmd_get_size(its_cmd);
>  	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
>  	struct its_device *device;
> +	gpa_t eaddr;
>  
> -	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
> +	if (!vgic_its_check_id(its, its->baser_device_table, device_id, &eaddr))
>  		return E_ITS_MAPD_DEVICE_OOR;
>  
>  	if (valid && size > VITS_TYPER_IDBITS)
> 
