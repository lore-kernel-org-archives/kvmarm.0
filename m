Received: from out-19.mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2FB21CDB
	for <kvmarm@lists.linux.dev>; Wed, 10 May 2023 20:50:45 +0000 (UTC)
Date: Wed, 10 May 2023 20:50:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1683751843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ia1kM68Ic5dNBsF/3H/24Hp4BGYNPwK+/DTRDRhBRdY=;
	b=I0ZgYP82Ue7Uh0Fumyom/yIkhXk8Xig6P6LghPEcAVqknbPZfTuFUsNaDjhwxXQHGSu9xh
	pUZ/B9ye9mOvFs5CwgFGpy4yiJIsP+vnZcqKIiPltZ5Pc++yIc4eya4yZDt6FtpiXEJcjW
	iu5jvUGxfuUB/QrQXByvjtbmN5aMDCQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Quentin Perret <qperret@google.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	kernel-team@android.com, Andrew Walbran <qwandor@google.com>
Subject: Re: [PATCH v2 04/10] KVM: arm64: Handle FFA_RXTX_MAP and
 FFA_RXTX_UNMAP calls from the host
Message-ID: <ZFwDnwLdxjG/XCcM@linux.dev>
References: <20230419122051.1341-1-will@kernel.org>
 <20230419122051.1341-5-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419122051.1341-5-will@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hi Will,

On Wed, Apr 19, 2023 at 01:20:45PM +0100, Will Deacon wrote:
> Handle FFA_RXTX_MAP and FFA_RXTX_UNMAP calls from the host by sharing
> the host's mailbox memory with the hypervisor and establishing a
> separate pair of mailboxes between the hypervisor and the SPMD at EL3.
> 
> Co-developed-by: Andrew Walbran <qwandor@google.com>
> Signed-off-by: Andrew Walbran <qwandor@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 184 ++++++++++++++++++++++++++++++++++
>  include/linux/arm_ffa.h       |   8 ++
>  2 files changed, 192 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index de0fba79b195..9ee3be517e1e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -31,6 +31,8 @@
>  #include <asm/kvm_pkvm.h>
>  
>  #include <nvhe/ffa.h>
> +#include <nvhe/mem_protect.h>
> +#include <nvhe/memory.h>
>  #include <nvhe/trap_handler.h>
>  #include <nvhe/spinlock.h>
>  
> @@ -52,6 +54,7 @@ struct kvm_ffa_buffers {
>   * client.
>   */
>  static struct kvm_ffa_buffers hyp_buffers;
> +static struct kvm_ffa_buffers host_buffers;
>  
>  static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
>  {
> @@ -61,6 +64,15 @@ static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
>  	};
>  }
>  
> +static void ffa_to_smccc_res(struct arm_smccc_res *res, int ret)
> +{
> +	if (ret == FFA_RET_SUCCESS) {
> +		*res = (struct arm_smccc_res) { .a0 = FFA_SUCCESS };
> +	} else {
> +		ffa_to_smccc_error(res, ret);
> +	}
> +}
> +
>  static void ffa_set_retval(struct kvm_cpu_context *ctxt,
>  			   struct arm_smccc_res *res)
>  {
> @@ -78,6 +90,140 @@ static bool is_ffa_call(u64 func_id)
>  	       ARM_SMCCC_FUNC_NUM(func_id) <= FFA_MAX_FUNC_NUM;
>  }

<snip>

> +static int spmd_map_ffa_buffers(u64 ffa_page_count)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_smc(FFA_FN64_RXTX_MAP,
> +			  hyp_virt_to_phys(hyp_buffers.tx),
> +			  hyp_virt_to_phys(hyp_buffers.rx),
> +			  ffa_page_count,
> +			  0, 0, 0, 0,
> +			  &res);
> +
> +	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
> +}
> +
> +static int spmd_unmap_ffa_buffers(void)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_smc(FFA_RXTX_UNMAP,
> +			  HOST_FFA_ID,
> +			  0, 0, 0, 0, 0, 0,
> +			  &res);
> +
> +	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
> +}

</snip>

I understand SPMD is significant in the context of the whole FF-A spec,
but I don't think the degree of precision is necessary to get the point
across for someone coming at this from a more KVM-centric background.

So, for the sake of readability, could these helpers be named
ffa_map_hyp_buffers()/ffa_unmap_hyp_buffers() (or similar)? Sticking
'hyp' in there somewhere helps the reader understand exactly what is
getting mapped, since there are both hyp and host buffers.

Apologies for bikeshedding, but I want to make sure folks w/o knowledge
of FF-A can at least grasp some of the mechanics here.

> +static void do_ffa_rxtx_map(struct arm_smccc_res *res,
> +			    struct kvm_cpu_context *ctxt)

This could do with some clarifying comments as well, since there is
rather significant interaction between host MAP calls and how we handle
host/hyp buffers.

> +{
> +	DECLARE_REG(phys_addr_t, tx, ctxt, 1);
> +	DECLARE_REG(phys_addr_t, rx, ctxt, 2);
> +	DECLARE_REG(u32, npages, ctxt, 3);
> +	int ret = 0;
> +	void *rx_virt, *tx_virt;
> +
> +	if (npages != (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) / FFA_PAGE_SIZE) {
> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		goto out;
> +	}
> +
> +	if (!PAGE_ALIGNED(tx) || !PAGE_ALIGNED(rx)) {
> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		goto out;
> +	}
> +
> +	hyp_spin_lock(&host_buffers.lock);
> +	if (host_buffers.tx) {
> +		ret = FFA_RET_DENIED;
> +		goto out_unlock;
> +	}
> +
> +	ret = spmd_map_ffa_buffers(npages);
> +	if (ret)
> +		goto out_unlock;
> +
> +	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(tx));
> +	if (ret) {
> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		goto err_unmap;
> +	}
> +
> +	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(rx));
> +	if (ret) {
> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		goto err_unshare_tx;
> +	}
> +
> +	tx_virt = hyp_phys_to_virt(tx);
> +	ret = hyp_pin_shared_mem(tx_virt, tx_virt + 1);
> +	if (ret) {
> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		goto err_unshare_rx;
> +	}
> +
> +	rx_virt = hyp_phys_to_virt(rx);
> +	ret = hyp_pin_shared_mem(rx_virt, rx_virt + 1);
> +	if (ret) {
> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		goto err_unpin_tx;
> +	}
> +
> +	host_buffers.tx = tx_virt;
> +	host_buffers.rx = rx_virt;
> +
> +out_unlock:
> +	hyp_spin_unlock(&host_buffers.lock);
> +out:
> +	ffa_to_smccc_res(res, ret);
> +	return;
> +
> +err_unpin_tx:
> +	hyp_unpin_shared_mem(tx_virt, tx_virt + 1);
> +err_unshare_rx:
> +	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(rx));
> +err_unshare_tx:
> +	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(tx));
> +err_unmap:
> +	spmd_unmap_ffa_buffers();
> +	goto out_unlock;
> +}

-- 
Thanks,
Oliver
