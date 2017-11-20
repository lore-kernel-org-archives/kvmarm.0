From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 4/7] KVM: arm/arm64: vgic-its: Check result of allocation
 before use
Date: Mon, 20 Nov 2017 15:58:14 +0100
Message-ID: <20171120145814.GM28855@cbox>
References: <20171116175821.26544-1-marc.zyngier@arm.com>
 <20171116175821.26544-5-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171116175821.26544-5-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Kristina Martsenko <kristina.martsenko@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 16, 2017 at 05:58:18PM +0000, Marc Zyngier wrote:
> We miss a test against NULL after allocation.
> 
> Fixes: 6d03a68f8054 ("KVM: arm64: vgic-its: Turn device_id validation into generic ID validation")
> Cc: stable@vger.kernel.org # 4.8
> Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 370086006838..30f7c7e6d2f4 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -821,6 +821,8 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
>  		return E_ITS_MAPC_COLLECTION_OOR;
>  
>  	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
> +	if (!collection)
> +		return -ENOMEM;

Our processing of this return value seems to be "shrug, something went
wrong, let's move on to the next command".  Is this really a valid thing
to do if we're so much under memory pressure that we dannot allocate a
collection structure?

My question notwithstanding:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

>  
>  	collection->collection_id = coll_id;
>  	collection->target_addr = COLLECTION_NOT_MAPPED;
> -- 
> 2.14.2
> 
