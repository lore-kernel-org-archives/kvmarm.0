Received: from out-45.mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66CD79DE
	for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 16:11:02 +0000 (UTC)
Date: Fri, 31 Mar 2023 16:10:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680279060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+lxPASBKZp7epsEpoEJ/xRVGiXQ6rwMrwRM8RJUtv8=;
	b=HT161TKGYpXwxa27Wt/Me8h3bRTsaxZZVQ1lM81yLNldqxj+ohAfxekTF4Q5crAdOg9Miz
	wuT57QyL/h3QUmFxbYr1xwPMilGg8kljwZ72VzY0RhyEU6iofYj2lWLwk44gtZFbI+Otm5
	jhPMhl+IaR01o7zC056fIGZu79AVWeM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oupton@google.com,
	will@kernel.org, pbonzini@redhat.com, james.morse@arm.com,
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, reijiw@google.com,
	ricarkol@google.com, rananta@google.com, jingzhangos@google.com
Subject: Re: [PATCH v3] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to
 protected VMs
Message-ID: <ZCcGD+El90tBpexd@linux.dev>
References: <20230331131218.2063233-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331131218.2063233-1-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Fuad,

Thanks for catching the masking issue in v2. Few comments:

On Fri, Mar 31, 2023 at 02:12:18PM +0100, Fuad Tabba wrote:
> The existing pKVM code attempts to do that using a value

nit: it is more readable if you restate what 'that' is in the changelog,
even if it is already in the shortlog.

> initialized to 0, but never set. To advertise csv2/3 to protected
> guests, pass the csv values to hyp when initializing hyp's view
> of guests' ID_AA64PFR0_EL1.
> 
> Similar to non-protected KVM, these are system-wide, rather than
> per cpu, for simplicity.
> 
> Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> Changes from V2: Fix masking not to affect bits other than CSV2/3.

Commentary like this that you don't want to appear in the commit when
applied should appear below the '---'

> ---

I.e. right here.

>  arch/arm64/kvm/arm.c                          | 24 ++++++++++++++++++-
>  .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  5 +++-
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  7 ------
>  3 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3bd732eaf087..0ae927c99fa1 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1889,9 +1889,31 @@ static int __init do_pkvm_init(u32 hyp_va_bits)
>  	return ret;
>  }
>  
> +static u64 get_hyp_id_aa64pfr0_el1(void)
> +{
> +	u64 mask = ~0ULL;
> +
> +	/*
> +	 * Track whether the system isn't affected by spectre/meltown in the
> +	 * hypervisor's view of id_aa64pfr0_el1, used for protected VMs.
> +	 * Although this is per-CPU, we make it global for simplicity, e.g., not
> +	 * to have to worry about vcpu migration.
> +	 *
> +	 * Unlike for non-protected VMs, userspace cannot override this for
> +	 * protected VMs.
> +	 */
> +	if (arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED)
> +		mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> +
> +	if (arm64_get_meltdown_state() != SPECTRE_UNAFFECTED)
> +		mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);

Doesn't this introduce a subtle change to the way that the CSV[23] values
are constrained in KVM? At least for 'normal' VMs we constrain both fields
to having a max value of 1.

-- 
Thanks,
Oliver
