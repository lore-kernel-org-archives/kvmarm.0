Return-Path: <SRS0=fMed=ES=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0644EC2D0A3
	for <kvmarm@archiver.kernel.org>; Thu, 12 Nov 2020 12:24:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4FC0322228
	for <kvmarm@archiver.kernel.org>; Thu, 12 Nov 2020 12:24:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1nz4msL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FC0322228
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8349C4BB7F;
	Thu, 12 Nov 2020 07:24:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z9Ph5lWoLCnj; Thu, 12 Nov 2020 07:24:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7381C4BB6F;
	Thu, 12 Nov 2020 07:24:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 255EE4BB69
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2020 07:24:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FeAVbNgZA7Ae for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Nov 2020 07:24:54 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 265944BB62
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2020 07:24:54 -0500 (EST)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id ADE1320872;
 Thu, 12 Nov 2020 12:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605183892;
 bh=2z7gQ3uZQjwnIoNsvH73GUonIWiI9Xo/+yZbWQJ0FE4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=f1nz4msLeW7/vmR9kwh5RdMRKe/FIu9qhvVxqfKzDfvub9Woj5WxJhhRvTlmvrbKG
 CLC7uy4yMAOLPX/l8PCmKSUj2IsXYZQ8NxXoZ5JvXRJ3g1CUjbXIvJzXJGuun7/shN
 LxwV8wGfiugDbfxBZlspMhIFsxz51TARaabDt4Sk=
Date: Thu, 12 Nov 2020 12:24:46 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 7/9] KVM: arm64: Allocate hyp vectors statically
Message-ID: <20201112122446.GB19696@willie-the-truck>
References: <20201109214726.15276-1-will@kernel.org>
 <20201109214726.15276-8-will@kernel.org>
 <02b35eecdc794886509be67d02c8bcea@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <02b35eecdc794886509be67d02c8bcea@kernel.org>
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

On Thu, Nov 12, 2020 at 12:05:54PM +0000, Marc Zyngier wrote:
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
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> 
> [...]
> 
> >  SYM_CODE_START(__bp_harden_hyp_vecs)
> > -	.rept BP_HARDEN_EL2_SLOTS
> > -	generate_vectors
> > -	.endr
> > +	generate_vectors indirect = 0, spectrev2 = 0 // HYP_VECTOR_DIRECT
> > +	generate_vectors indirect = 0, spectrev2 = 1 //
> > HYP_VECTOR_SPECTRE_DIRECT
> > +	generate_vectors indirect = 1, spectrev2 = 0 // HYP_VECTOR_INDIRECT
> > +	generate_vectors indirect = 1, spectrev2 = 1 //
> > HYP_VECTOR_SPECTRE_INDIRECT
> 
> Another nit (though I'm not sure if it it's a regression or not):
> Why do we generate a set of hardened vectors for HYP_VECTOR_DIRECT?
> The code in kvm_init_vector_slots() directly points the per-CPU VBAR
> to __kvm_hyp_vector, which is the right thing to do. I don't think we
> ever use slot 0 in __bp_harden_hyp_vecs, wasting 2kB of text.
> 
> Did I miss something?

It's inherited from the old code, but I agree that the first slot is
unused. We should be able to remove it afaict if we separate
BP_HARDEN_EL2_SLOTS and __BP_HARDEN_HYP_VECS_SZ but, as ever, testing
this is a massive pain. I'll add a patch on top for the next version.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
