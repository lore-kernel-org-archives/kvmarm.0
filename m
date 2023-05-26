Received: from out-51.mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D072923A4
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 08:35:22 +0000 (UTC)
Date: Fri, 26 May 2023 08:35:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685090121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=60ZRjnDpSzrKHJnFhfQJQPcygblaw4mPC1sJAyo86Gs=;
	b=imS8kWAWRPLrNaHU9Yj/6vqLATAdhqtPr7EcSVQL+mbuIsBTcFcQzHsjQTxw1/PzTZkTf1
	U2NnkWDQpZxliJk4IUsvXWG3Wt/09hNIPIw7xWnd75RrmwTWl0TWZjVBnQbp8sjfjwbnrf
	vs3/Xm89LSnaQAfSck2DxMZhgX8BUbU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jun Miao <jun.miao@intel.com>
Cc: maz@kernel.org, oliver.upton@linux.de, james.morse@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: fix typo
Message-ID: <ZHBvRe9ejErYwB0t@linux.dev>
References: <20230526081548.12729-1-jun.miao@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526081548.12729-1-jun.miao@intel.com>
X-Migadu-Flow: FLOW_OUT

Hi Jun,

The shortlog is too vague. While typo fixes don't need to be
exhaustively described, 'Fix typo' doesn't give any indication as to
where it is.

  KVM: arm64: Fix comment typo in hyp_back_vmemmap()

On Fri, May 26, 2023 at 04:15:48PM +0800, Jun Miao wrote:
> Change "begining" to "beginning"
> 
> Fixes: 8e6bcc3a4502 ("KVM: arm64: Back the hypervisor 'struct hyp_page' array for all memory")

This is a misuse of the Fixes tag. A typo in a comment is not a bug.

> Signed-off-by: Jun Miao <jun.miao@intel.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 318298eb3d6b..f16d9f38bb48 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -145,7 +145,7 @@ int hyp_back_vmemmap(phys_addr_t back)
>  		start = hyp_memory[i].base;
>  		start = ALIGN_DOWN((u64)hyp_phys_to_page(start), PAGE_SIZE);
>  		/*
> -		 * The begining of the hyp_vmemmap region for the current
> +		 * The beginning of the hyp_vmemmap region for the current
>  		 * memblock may already be backed by the page backing the end
>  		 * the previous region, so avoid mapping it twice.
>  		 */
> -- 
> 2.32.0
> 
> 

-- 
Thanks,
Oliver
