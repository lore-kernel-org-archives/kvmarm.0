Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82406C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 11:22:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DAEA4B0DB;
	Thu,  9 Dec 2021 06:22:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SPr0Fqld3kZ1; Thu,  9 Dec 2021 06:22:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3D034B102;
	Thu,  9 Dec 2021 06:22:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C28594B0DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 06:22:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sWxjsTuWbozt for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 06:22:40 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 637A74B0D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 06:22:40 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D2B98B8245A;
 Thu,  9 Dec 2021 11:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BDCC004DD;
 Thu,  9 Dec 2021 11:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639048958;
 bh=O1MP/jZT+iP4CkJdmDjsljgxpj4vHoKDEn9+msO/wM0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=P294UhYKpxbWw0WFvDMWrDL/T6MfhlqNnKVGPQ8P3Z7ZZ+hfspik40BxDTCBh/rxi
 6TQxm2Jejt4fvjCCGXw7y82pDgzM009JJE3pmSHDD9Cxs/7NlxXsBmbhfVIVZPm2bk
 N4Af7QeOraNbUqP31lZtjAn5NzPe+cQ9LegtlzchMORBPTj3NKOGVkQNIkAxI2jfmE
 7u2BVdFlx23AzXUGOVAFmzjBaCCEy/h7GbMYRvH/S6zY5CVRNrIsbjk5Gv+8RK5qY8
 Xc0Eu1kFmCkeF1uwbicAyRRTiFWd3QBgdX7cC11otsI144MXQfin+szwb2ESmP1au5
 /KCjvZDPvPnPA==
Date: Thu, 9 Dec 2021 11:22:33 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 15/15] KVM: arm64: pkvm: Unshare guest structs during
 teardown
Message-ID: <20211209112233.GD1912@willie-the-truck>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-16-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211201170411.1561936-16-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Dec 01, 2021 at 05:04:09PM +0000, Quentin Perret wrote:
> Make use of the newly introduced unshare hypercall during guest teardown
> to unmap guest-related data structures from the hyp stage-1.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/include/asm/kvm_mmu.h  |  1 +
>  arch/arm64/kvm/arm.c              |  2 ++
>  arch/arm64/kvm/fpsimd.c           | 34 ++++++++++++++++++++++---
>  arch/arm64/kvm/mmu.c              | 42 +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/reset.c            |  8 +++++-
>  6 files changed, 85 insertions(+), 4 deletions(-)

[...]

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d72566896755..8e506ba8988e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -344,6 +344,32 @@ static int share_pfn_hyp(u64 pfn)
>  	return ret;
>  }
>  
> +static int unshare_pfn_hyp(u64 pfn)
> +{
> +	struct rb_node **node, *parent;
> +	struct hyp_shared_pfn *this;
> +	int ret = 0;
> +
> +	mutex_lock(&hyp_shared_pfns_lock);
> +	this = find_shared_pfn(pfn, &node, &parent);
> +	if (WARN_ON(!this)) {
> +		ret = -EINVAL;

-ENOENT?

> +		goto unlock;
> +	}
> +
> +	this->count--;
> +	if (this->count)
> +		goto unlock;

Again, if we did an RCU lookup then this could be converted to a refcount_t
to take the mutex only when it hits zero. But for now I think it's fine.

> +
> +	rb_erase(&this->node, &hyp_shared_pfns);
> +	kfree(this);
> +	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn, 1);
> +unlock:
> +	mutex_unlock(&hyp_shared_pfns_lock);
> +
> +	return ret;
> +}
> +
>  int kvm_share_hyp(void *from, void *to)
>  {
>  	phys_addr_t start, end, cur;
> @@ -376,6 +402,22 @@ int kvm_share_hyp(void *from, void *to)
>  	return 0;
>  }
>  
> +void kvm_unshare_hyp(void *from, void *to)
> +{
> +	phys_addr_t start, end, cur;
> +	u64 pfn;
> +
> +	if (is_kernel_in_hyp_mode() || kvm_host_owns_hyp_mappings() || !from)

I don't think you need the is_kernel_in_hyp_mode() check any more not that
you've moved that into kvm_host_owns_hyp_mappings().

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
