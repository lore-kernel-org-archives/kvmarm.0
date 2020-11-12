Return-Path: <SRS0=fMed=ES=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC0CC55ABD
	for <kvmarm@archiver.kernel.org>; Thu, 12 Nov 2020 11:27:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B3C372220B
	for <kvmarm@archiver.kernel.org>; Thu, 12 Nov 2020 11:27:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SqkVWeCM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3C372220B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0EC44BB83;
	Thu, 12 Nov 2020 06:27:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ia++EGDZmsLm; Thu, 12 Nov 2020 06:27:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D697A4BB7A;
	Thu, 12 Nov 2020 06:27:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F67E4BB68
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2020 06:27:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hcdyVFjulQdW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Nov 2020 06:27:23 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75E804BB65
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2020 06:27:23 -0500 (EST)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3161F221FE;
 Thu, 12 Nov 2020 11:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605180442;
 bh=WIxo/Ou22FPz/Q4i2VfKpSHgdhoTQnhmY/L6dUPlfro=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=SqkVWeCMqApYNl59Pw1hG4eQ8Gk9rVIfp8jaMeLsTmGjGFQcbeCHKqwT0sf1IxFnG
 c3PJMfnfOnM6oSQOd4dAfxBOkCXOz/PsYBUgXcoGwasNs7JqI3YP3GYOPEE9X3LCuW
 vZODIDFHYugnNNrc/Au7Kp6z1mpNrv1IEP3Ms/u8=
Date: Thu, 12 Nov 2020 11:27:17 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 7/9] KVM: arm64: Allocate hyp vectors statically
Message-ID: <20201112112717.GA19696@willie-the-truck>
References: <20201109214726.15276-1-will@kernel.org>
 <20201109214726.15276-8-will@kernel.org>
 <f26c82b8bbb75904d7b8cf9ce84a507e@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f26c82b8bbb75904d7b8cf9ce84a507e@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Nov 12, 2020 at 11:07:55AM +0000, Marc Zyngier wrote:
> On 2020-11-09 21:47, Will Deacon wrote:
> > The EL2 vectors installed when a guest is running point at one of the
> > following configurations for a given CPU:
> > 
> >   - Straight at __kvm_hyp_vector
> >   - A trampoline containing an SMC sequence to mitigate Spectre-v2 and
> >     then a direct branch to __kvm_hyp_vector
> >   - A dynamically-allocated trampoline which has an indirect branch to
> >     __kvm_hyp_vector
> >   - A dynamically-allocated trampoline containing an SMC sequence to
> >     mitigate Spectre-v2 and then an indirect branch to __kvm_hyp_vector
> > 
> > The indirect branches mean that VA randomization at EL2 isn't trivially
> > bypassable using Spectre-v3a (where the vector base is readable by the
> > guest).
> > 
> > Rather than populate these vectors dynamically, configure everything
> > statically and use an enumerated type to identify the vector "slot"
> > corresponding to one of the configurations above. This both simplifies
> > the code, but also makes it much easier to implement at EL2 later on.
> 
> This series terminally breaks VHE (the host locks up on the first guest
> run, CPU is nowhere to be seen again).

Whoops, sorry about that. I'll look into it.

> I have a hunch about what is happening, see below.
> 
> [...]
> 
> > @@ -1406,24 +1401,9 @@ static void cpu_hyp_reset(void)
> >  static void cpu_set_hyp_vector(void)
> >  {
> >  	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
> > -	void *vect = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
> > -	int slot = -1;
> > -
> > -	if (cpus_have_const_cap(ARM64_SPECTRE_V2) && data->fn) {
> > -		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
> > -		slot = data->hyp_vectors_slot;
> > -	}
> > -
> > -	if (this_cpu_has_cap(ARM64_HARDEN_EL2_VECTORS) && !has_vhe()) {
> > -		vect = __kvm_bp_vect_base;
> > -		if (slot == -1)
> > -			slot = __kvm_harden_el2_vector_slot;
> > -	}
> > -
> > -	if (slot != -1)
> > -		vect += slot * SZ_2K;
> > +	void *vector = hyp_spectre_vector_selector[data->slot];
> > 
> > -	*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vect;
> > +	*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vector;
> >  }
> > 
> >  static void cpu_hyp_reinit(void)
> > @@ -1661,9 +1641,9 @@ static int init_hyp_mode(void)
> >  		goto out_err;
> >  	}
> > 
> > -	err = kvm_map_vectors();
> > +	err = kvm_init_vector_slots();
> 
> Here, you have turned the mapping of the vectors into the full
> init+map. The mapping makes no sense on VHE, but the initialization
> does matter! init_hyp_mode() being only called on non-VHE, the HYP
> vectors are never initialized. Too bad.

Yeah, that certainly smells bad. I'll hack at it now and post a v3 when
it comes back to life.

Cheers,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
