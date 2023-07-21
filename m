Received: from out-59.mta0.migadu.com (out-59.mta0.migadu.com [91.218.175.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F143DDD4
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 21:21:26 +0000 (UTC)
Date: Fri, 21 Jul 2023 21:21:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689974484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l1F2LielEVtTj34TacMtsWZhZDvmKwTIQhFVeQuVmjM=;
	b=Qv+jzEa8HG5gCsJk6FOcTZLqMEaQVXbVuxjBggvl/f2CYie6ENnVXXtmnyBKYBppeQH18w
	j7CAjAyIcHIF3mriAWpEg1WaBk8r9V/NfzcwOSfUSnnjNrjnA/cUdc6hMVI83VG9iKxBWv
	WPS1nQUCFeJhXBh3JuWuhq+fiE7tnpQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org
Subject: Re: [PATCH v2 1/7] KVM: arm64: Factor out code for checking E2H into
 a macro
Message-ID: <ZLr20NXdQfXlxV9j@linux.dev>
References: <20230721095144.306817-1-tabba@google.com>
 <20230721095144.306817-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721095144.306817-2-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Fuad,

On Fri, Jul 21, 2023 at 10:51:38AM +0100, Fuad Tabba wrote:
> The code for checking whether the kernel is in (h)VHE mode is
> repeated, and will be needed again in future patches. Factor it
> out in a macro.
> 
> No functional change intended.
> No change in emitted assembly code intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Looks good, one nitpick below:

> ---
>  arch/arm64/include/asm/el2_setup.h | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 8e5ffb58f83e..383f6be66ed6 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -31,6 +31,13 @@
>  .Lskip_hcrx_\@:
>  .endm
>  
> +/* Check if running in host at EL2 mode, i.e., (h)VHE. Jumps to fail if not. */
> +.macro __check_e2h fail, tmp
> +	mrs	\tmp, hcr_el2
> +	and	\tmp, \tmp, #HCR_E2H
> +	cbz	\tmp, \fail
> +.endm
> +

I was really hoping for the macro to have hVHE somewhere in the name,
since it may not be immediately obvious to folks why we're testing E2H
in this context.

So maybe: s/__check_e2h/__check_hvhe/ ?

I can fix it up when applying the series if you agree.

-- 
Thanks,
Oliver
