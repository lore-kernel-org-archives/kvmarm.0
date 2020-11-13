Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53573C388F7
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 12:02:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 758682224C
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 12:02:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rx9Nol8R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 758682224C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D63474BCD4;
	Fri, 13 Nov 2020 07:02:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H0IzlCWhn6np; Fri, 13 Nov 2020 07:02:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C2E94BB5B;
	Fri, 13 Nov 2020 07:02:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58E154BB32
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 07:02:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qQKQk-JYyGSQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 07:02:14 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1148D4BAD6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 07:02:14 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A90222224C;
 Fri, 13 Nov 2020 12:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605268932;
 bh=wP1gTYbIvaPmk4DQqZ6jzXtVQ2Z0F9iOFv2jcrpBATM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Rx9Nol8RcLjrlPMv2mQsG/juGWdLnuNyAwnvHGgl/aQjUi+iUR1jQ64Ab7ujzNegK
 a8sLwfbji7pIq2QKZvF7ELWV8TOTxh8p8T2ZafTs163mvrYwJgodQXqBKFADkAl10o
 w7Qj8HeFFRFy2seIcGHy0xmoX80v1ExvuWMpkH8U=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kdXmM-00AJsY-Ct; Fri, 13 Nov 2020 12:02:10 +0000
MIME-Version: 1.0
Date: Fri, 13 Nov 2020 12:02:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 07/10] KVM: arm64: Allocate hyp vectors statically
In-Reply-To: <20201113113847.21619-8-will@kernel.org>
References: <20201113113847.21619-1-will@kernel.org>
 <20201113113847.21619-8-will@kernel.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <90f9dc9475059997d80dd254186c74f6@kernel.org>
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

On 2020-11-13 11:38, Will Deacon wrote:
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
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h |  5 --
>  arch/arm64/include/asm/spectre.h | 36 +++++++++++++-
>  arch/arm64/kernel/cpu_errata.c   |  2 +
>  arch/arm64/kernel/proton-pack.c  | 63 +++++-------------------
>  arch/arm64/kvm/arm.c             | 82 +++++++++++++-------------------
>  arch/arm64/kvm/hyp/Makefile      |  2 +-
>  arch/arm64/kvm/hyp/hyp-entry.S   | 72 ++++++++++++++++------------
>  arch/arm64/kvm/hyp/smccc_wa.S    | 32 -------------
>  arch/arm64/kvm/va_layout.c       | 11 +----
>  9 files changed, 126 insertions(+), 179 deletions(-)
>  delete mode 100644 arch/arm64/kvm/hyp/smccc_wa.S

I haven't had a chance to test this series yet, but I may have spotted
another small nit, see below:

[...]

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
> +	if (!has_vhe()) {
> +		err = create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
> +					       __BP_HARDEN_HYP_VECS_SZ, &base);
> +		if (err)
> +			return err;
> +	}
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
> @@ -1406,24 +1403,9 @@ static void cpu_hyp_reset(void)
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
> +	void *vector = hyp_spectre_vector_selector[data->slot];
> 
> -	if (this_cpu_has_cap(ARM64_HARDEN_EL2_VECTORS) && !has_vhe()) {
> -		vect = __kvm_bp_vect_base;
> -		if (slot == -1)
> -			slot = __kvm_harden_el2_vector_slot;
> -	}
> -
> -	if (slot != -1)
> -		vect += slot * SZ_2K;
> -
> -	*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vect;
> +	*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vector;
>  }
> 
>  static void cpu_hyp_reinit(void)
> @@ -1661,9 +1643,9 @@ static int init_hyp_mode(void)
>  		goto out_err;
>  	}
> 
> -	err = kvm_map_vectors();
> +	err = kvm_init_vector_slots();
>  	if (err) {
> -		kvm_err("Cannot map vectors\n");
> +		kvm_err("Cannot initialise vector slots\n");
>  		goto out_err;
>  	}
> 
> @@ -1810,6 +1792,10 @@ int kvm_arch_init(void *opaque)
>  			goto out_err;
>  	}
> 
> +	err = kvm_init_vector_slots();
> +	if (err)
> +		goto out_err;

Don't you end-up calling kvm_init_vector_slots() twice on nVHE?
It's probably harmless, but I think we can have a single call here,
and drop the call from init_hyp_mode().

What do you think? If you agree, I can perform the change when queuing
the series.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
