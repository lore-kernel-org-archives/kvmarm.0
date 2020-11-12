Return-Path: <SRS0=fMed=ES=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E7F2C2D0A3
	for <kvmarm@archiver.kernel.org>; Thu, 12 Nov 2020 11:08:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8AEBE22201
	for <kvmarm@archiver.kernel.org>; Thu, 12 Nov 2020 11:08:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AgpnNl+B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8AEBE22201
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5B2B4B918;
	Thu, 12 Nov 2020 06:08:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R3sNfk8z3s1X; Thu, 12 Nov 2020 06:08:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E69E44BB7B;
	Thu, 12 Nov 2020 06:08:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A69A4BB7B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2020 06:08:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xrXyFW+Vmi6t for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Nov 2020 06:07:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 301B24BB1A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2020 06:07:59 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AFAD922201;
 Thu, 12 Nov 2020 11:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605179277;
 bh=2ZdXPWyHczH4vd7Kp2AjWXnP7Ym8vWQdb/X5Za8HFtk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=AgpnNl+BgSixwxoYc/nr5hplirg9nP7j6QLq+RftOsTvw93tpTKBHbzs/gGXPLwva
 CtHFTtjAfR85apkXtSywil0MfF1Q1JV9FqrTCnnVu0iFwFG8wA6mkXF0fdPeOFaufm
 9JlzX0U91/ywm/SLE7LSTDWt++/ayLWxRZiza88o=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kdASJ-00A0wZ-MP; Thu, 12 Nov 2020 11:07:55 +0000
MIME-Version: 1.0
Date: Thu, 12 Nov 2020 11:07:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 7/9] KVM: arm64: Allocate hyp vectors statically
In-Reply-To: <20201109214726.15276-8-will@kernel.org>
References: <20201109214726.15276-1-will@kernel.org>
 <20201109214726.15276-8-will@kernel.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <f26c82b8bbb75904d7b8cf9ce84a507e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.cs.columbia.edu,
 catalin.marinas@arm.com, kernel-team@android.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-11-09 21:47, Will Deacon wrote:
> The EL2 vectors installed when a guest is running point at one of the
> following configurations for a given CPU:
> 
>   - Straight at __kvm_hyp_vector
>   - A trampoline containing an SMC sequence to mitigate Spectre-v2 and
>     then a direct branch to __kvm_hyp_vector
>   - A dynamically-allocated trampoline which has an indirect branch to
>     __kvm_hyp_vector
>   - A dynamically-allocated trampoline containing an SMC sequence to
>     mitigate Spectre-v2 and then an indirect branch to __kvm_hyp_vector
> 
> The indirect branches mean that VA randomization at EL2 isn't trivially
> bypassable using Spectre-v3a (where the vector base is readable by the
> guest).
> 
> Rather than populate these vectors dynamically, configure everything
> statically and use an enumerated type to identify the vector "slot"
> corresponding to one of the configurations above. This both simplifies
> the code, but also makes it much easier to implement at EL2 later on.

This series terminally breaks VHE (the host locks up on the first guest
run, CPU is nowhere to be seen again).

I have a hunch about what is happening, see below.

[...]

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 044c5fc81f90..ec6dce70c611 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -51,14 +51,6 @@ DECLARE_KVM_HYP_PER_CPU(unsigned long, 
> kvm_hyp_vector);
>  static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
>  unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
> 
> -/* Hypervisor VA of the indirect vector trampoline page */
> -static void *__kvm_bp_vect_base;
> -/*
> - * Slot in the hyp vector page for use by the indirect vector 
> trampoline
> - * when mitigation against Spectre-v2 is not required.
> - */
> -static int __kvm_harden_el2_vector_slot;
> -
>  /* The VMID used in the VTTBR */
>  static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
>  static u32 kvm_next_vmid;
> @@ -1303,33 +1295,36 @@ static unsigned long nvhe_percpu_order(void)
>  	return size ? get_order(size) : 0;
>  }
> 
> -static int kvm_map_vectors(void)
> +/* A lookup table holding the hypervisor VA for each vector slot */
> +static void *hyp_spectre_vector_selector[BP_HARDEN_EL2_SLOTS];
> +
> +static void kvm_init_vector_slot(void *base, enum
> arm64_hyp_spectre_vector slot)
>  {
> -	int slot;
> +	hyp_spectre_vector_selector[slot] = base + (slot * SZ_2K);
> +}
> +
> +static int kvm_init_vector_slots(void)
> +{
> +	int err;
> +	void *base;
> +
> +	base = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
> +	kvm_init_vector_slot(base, HYP_VECTOR_DIRECT);
> +
> +	base = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
> +	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_DIRECT);
> 
> -	/*
> -	 * SV2  = ARM64_SPECTRE_V2
> -	 * HEL2 = ARM64_HARDEN_EL2_VECTORS
> -	 *
> -	 * !SV2 + !HEL2 -> use direct vectors
> -	 *  SV2 + !HEL2 -> use hardened vectors in place
> -	 * !SV2 +  HEL2 -> allocate one vector slot and use exec mapping
> -	 *  SV2 +  HEL2 -> use hardened vectors and use exec mapping
> -	 */
>  	if (!cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS))
>  		return 0;
> 
> -	/*
> -	 * Always allocate a spare vector slot, as we don't know yet which 
> CPUs
> -	 * have a BP hardening slot that we can reuse.
> -	 */
> -	slot = atomic_inc_return(&arm64_el2_vector_last_slot);
> -	BUG_ON(slot >= BP_HARDEN_EL2_SLOTS);
> -	__kvm_harden_el2_vector_slot = slot;
> +	err = create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
> +				       __BP_HARDEN_HYP_VECS_SZ, &base);
> +	if (err)
> +		return err;
> 
> -	return create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
> -					__BP_HARDEN_HYP_VECS_SZ,
> -					&__kvm_bp_vect_base);
> +	kvm_init_vector_slot(base, HYP_VECTOR_INDIRECT);
> +	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_INDIRECT);
> +	return 0;
>  }
> 
>  static void cpu_init_hyp_mode(void)
> @@ -1406,24 +1401,9 @@ static void cpu_hyp_reset(void)
>  static void cpu_set_hyp_vector(void)
>  {
>  	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
> -	void *vect = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
> -	int slot = -1;
> -
> -	if (cpus_have_const_cap(ARM64_SPECTRE_V2) && data->fn) {
> -		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
> -		slot = data->hyp_vectors_slot;
> -	}
> -
> -	if (this_cpu_has_cap(ARM64_HARDEN_EL2_VECTORS) && !has_vhe()) {
> -		vect = __kvm_bp_vect_base;
> -		if (slot == -1)
> -			slot = __kvm_harden_el2_vector_slot;
> -	}
> -
> -	if (slot != -1)
> -		vect += slot * SZ_2K;
> +	void *vector = hyp_spectre_vector_selector[data->slot];
> 
> -	*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vect;
> +	*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vector;
>  }
> 
>  static void cpu_hyp_reinit(void)
> @@ -1661,9 +1641,9 @@ static int init_hyp_mode(void)
>  		goto out_err;
>  	}
> 
> -	err = kvm_map_vectors();
> +	err = kvm_init_vector_slots();

Here, you have turned the mapping of the vectors into the full
init+map. The mapping makes no sense on VHE, but the initialization
does matter! init_hyp_mode() being only called on non-VHE, the HYP
vectors are never initialized. Too bad.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
