From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: vgic-its: Plug race in vgic_put_irq
Date: Tue, 9 Aug 2016 14:04:22 +0100
Message-ID: <7fa86f52-9010-be42-0090-54a9cbd540d2@arm.com>
References: <20160809111606.28744-1-christoffer.dall@linaro.org>
 <20160809111606.28744-3-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ABA2412A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 08:56:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rlQQF2fpRtqr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 08:56:10 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1312040B58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 08:56:09 -0400 (EDT)
In-Reply-To: <20160809111606.28744-3-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 09/08/16 12:16, Christoffer Dall wrote:
> Right now the following sequence of events can happen:
> 
>   1. Thread X calls vgic_put_irq
>   2. Thread Y calls vgic_add_lpi
>   3. Thread Y gets lpi_list_lock
>   4. Thread X drops the ref count to 0 and blocks on lpi_list_lock
>   5. Thread Y finds the irq via the lpi_list_lock, raises the ref
>      count to 1, and release the lpi_list_lock.
>   6. Thread X proceeds and frees the irq.
> 
> Avoid this by holding the spinlock around the kref_put.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks!
Andre

> ---
> 
> Notes:
>     Changes since v1:
>      - Stylistic change: Don't use else branch
> 
>  virt/kvm/arm/vgic/vgic.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index e7aeac7..e83b7fe 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -117,17 +117,17 @@ static void vgic_irq_release(struct kref *ref)
>  
>  void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  {
> -	struct vgic_dist *dist;
> +	struct vgic_dist *dist = &kvm->arch.vgic;
>  
>  	if (irq->intid < VGIC_MIN_LPI)
>  		return;
>  
> -	if (!kref_put(&irq->refcount, vgic_irq_release))
> +	spin_lock(&dist->lpi_list_lock);
> +	if (!kref_put(&irq->refcount, vgic_irq_release)) {
> +		spin_unlock(&dist->lpi_list_lock);
>  		return;
> +	};
>  
> -	dist = &kvm->arch.vgic;
> -
> -	spin_lock(&dist->lpi_list_lock);
>  	list_del(&irq->lpi_list);
>  	dist->lpi_list_count--;
>  	spin_unlock(&dist->lpi_list_lock);
> 
