Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59AEC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 19:25:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4574564F69
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 19:25:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4574564F69
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA18C4B429;
	Thu,  4 Mar 2021 14:25:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T51xhqQsgrF3; Thu,  4 Mar 2021 14:25:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC5FA4B42A;
	Thu,  4 Mar 2021 14:25:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADD134B42A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 14:25:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id loJMOYulzcWH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 14:25:48 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E8C54B429
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 14:25:48 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CD2A64F60;
 Thu,  4 Mar 2021 19:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614885947;
 bh=d5oyr0RbUTr11eGau8HQOa9mCj+ZMHZCRHmDN/GuD5o=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=eoTTgYBi5Y3qIoUH4K2ybb28vRP9ms605NREGXE9ltqXx1sIS6WNUyKEXteNnyJPy
 eEfyhYFaf9li2Otd8xLVO7qcKq6MJIjSalFKpTMcq17zvI9cwWJKu5Vb5EFb/XYVCZ
 2IhNMlyJJZIN8U3rm1c2NqktkoeCD+i0qn2po3eWk5i7wnVk5izKSyIF1LPV5o/s2B
 4+q7xqXHuRHVQ0OjT47DYPDjKn2VxmZ9f8NWSo0KIZFDjJ5IHlICuwqRUoBEqS0RvA
 8m5RZ0wJ8gGiEWFgJJycEvk9brxtFyGUFBb1kaXyBbB0CCMxFv+GreCHZ0D/QEfFtn
 shJ9nsNOAfWxg==
Date: Thu, 4 Mar 2021 19:25:41 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 16/32] KVM: arm64: Elevate hypervisor mappings
 creation at EL2
Message-ID: <20210304192540.GE21795@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-17-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-17-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 02, 2021 at 02:59:46PM +0000, Quentin Perret wrote:
> Previous commits have introduced infrastructure to enable the EL2 code
> to manage its own stage 1 mappings. However, this was preliminary work,
> and none of it is currently in use.
> 
> Put all of this together by elevating the mapping creation at EL2 when
> memory protection is enabled. In this case, the host kernel running
> at EL1 still creates _temporary_ EL2 mappings, only used while
> initializing the hypervisor, but frees them right after.
> 
> As such, all calls to create_hyp_mappings() after kvm init has finished
> turn into hypercalls, as the host now has no 'legal' way to modify the
> hypevisor page tables directly.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h |  2 +-
>  arch/arm64/kvm/arm.c             | 87 +++++++++++++++++++++++++++++---
>  arch/arm64/kvm/mmu.c             | 43 ++++++++++++++--
>  3 files changed, 120 insertions(+), 12 deletions(-)

[...]

> @@ -1489,13 +1497,14 @@ static void cpu_hyp_reinit(void)
>  	kvm_init_host_cpu_context(&this_cpu_ptr_hyp_sym(kvm_host_data)->host_ctxt);
>  
>  	cpu_hyp_reset();
> -	cpu_set_hyp_vector();
>  
>  	if (is_kernel_in_hyp_mode())
>  		kvm_timer_init_vhe();
>  	else
>  		cpu_init_hyp_mode();
>  
> +	cpu_set_hyp_vector();
> +
>  	kvm_arm_init_debug();
>  
>  	if (vgic_present)
> @@ -1691,18 +1700,59 @@ static void teardown_hyp_mode(void)
>  	}
>  }
>  
> +static int do_pkvm_init(u32 hyp_va_bits)
> +{
> +	void *per_cpu_base = kvm_ksym_ref(kvm_arm_hyp_percpu_base);
> +	int ret;
> +
> +	preempt_disable();
> +	hyp_install_host_vector();

It's a shame we need this both here _and_ on the reinit path, but it looks
like it's necessary.

> +	ret = kvm_call_hyp_nvhe(__pkvm_init, hyp_mem_base, hyp_mem_size,
> +				num_possible_cpus(), kern_hyp_va(per_cpu_base),
> +				hyp_va_bits);
> +	preempt_enable();
> +
> +	return ret;
> +}

[...]

>  /**
>   * Inits Hyp-mode on all online CPUs
>   */
>  static int init_hyp_mode(void)
>  {
> +	u32 hyp_va_bits;
>  	int cpu;
> -	int err = 0;
> +	int err = -ENOMEM;
> +
> +	/*
> +	 * The protected Hyp-mode cannot be initialized if the memory pool
> +	 * allocation has failed.
> +	 */
> +	if (is_protected_kvm_enabled() && !hyp_mem_base)
> +		return err;

This skips the error message you get on the out_err path.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 4d41d7838d53..9d331bf262d2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -221,15 +221,39 @@ void free_hyp_pgds(void)
>  	if (hyp_pgtable) {
>  		kvm_pgtable_hyp_destroy(hyp_pgtable);
>  		kfree(hyp_pgtable);
> +		hyp_pgtable = NULL;
>  	}
>  	mutex_unlock(&kvm_hyp_pgd_mutex);
>  }
>  
> +static bool kvm_host_owns_hyp_mappings(void)
> +{
> +	if (static_branch_likely(&kvm_protected_mode_initialized))
> +		return false;
> +
> +	/*
> +	 * This can happen at boot time when __create_hyp_mappings() is called
> +	 * after the hyp protection has been enabled, but the static key has
> +	 * not been flipped yet.
> +	 */
> +	if (!hyp_pgtable && is_protected_kvm_enabled())
> +		return false;
> +
> +	WARN_ON(!hyp_pgtable);
> +
> +	return true;

	return !(WARN_ON(!hyp_pgtable) && is_protected_kvm_enabled());

?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
