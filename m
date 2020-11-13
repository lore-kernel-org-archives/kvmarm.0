Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F19C63699
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 12:11:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 672082224B
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 12:11:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="0UXXAZ8s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 672082224B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C08644BC1F;
	Fri, 13 Nov 2020 07:11:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3mjNk5lmhrlA; Fri, 13 Nov 2020 07:11:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB3804BC24;
	Fri, 13 Nov 2020 07:11:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FA464BC15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 07:11:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nUwO5BjFW6jB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 07:11:05 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A2B54BC14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 07:11:05 -0500 (EST)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E98F92078B;
 Fri, 13 Nov 2020 12:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605269463;
 bh=N6qEsPRm0magsFzv4kgcAE+U0ZxZ08yiafOjCiOrVyU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=0UXXAZ8sHuhqKWJhdkpdmZa8xWgfcQV7FDT0bD4dCo4pS2RZQ/1LFsLRupyzeYMgL
 rwUw8PiAbgtG20t9TINJC2sXxnfqtvEQGJJ0TZDNeoCoQ98RGzabfUMly7Fb65c8jl
 uwwfJ91rDgj0grIRubieqqGFMtlcdgvgXaL8lc3M=
Date: Fri, 13 Nov 2020 12:10:59 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 07/10] KVM: arm64: Allocate hyp vectors statically
Message-ID: <20201113121059.GA21956@willie-the-truck>
References: <20201113113847.21619-1-will@kernel.org>
 <20201113113847.21619-8-will@kernel.org>
 <90f9dc9475059997d80dd254186c74f6@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <90f9dc9475059997d80dd254186c74f6@kernel.org>
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

On Fri, Nov 13, 2020 at 12:02:10PM +0000, Marc Zyngier wrote:
> On 2020-11-13 11:38, Will Deacon wrote:
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
> >  arch/arm64/include/asm/kvm_asm.h |  5 --
> >  arch/arm64/include/asm/spectre.h | 36 +++++++++++++-
> >  arch/arm64/kernel/cpu_errata.c   |  2 +
> >  arch/arm64/kernel/proton-pack.c  | 63 +++++-------------------
> >  arch/arm64/kvm/arm.c             | 82 +++++++++++++-------------------
> >  arch/arm64/kvm/hyp/Makefile      |  2 +-
> >  arch/arm64/kvm/hyp/hyp-entry.S   | 72 ++++++++++++++++------------
> >  arch/arm64/kvm/hyp/smccc_wa.S    | 32 -------------
> >  arch/arm64/kvm/va_layout.c       | 11 +----
> >  9 files changed, 126 insertions(+), 179 deletions(-)
> >  delete mode 100644 arch/arm64/kvm/hyp/smccc_wa.S
> 
> I haven't had a chance to test this series yet, but I may have spotted
> another small nit, see below:
> 
> > @@ -1810,6 +1792,10 @@ int kvm_arch_init(void *opaque)
> >  			goto out_err;
> >  	}
> > 
> > +	err = kvm_init_vector_slots();
> > +	if (err)
> > +		goto out_err;
> 
> Don't you end-up calling kvm_init_vector_slots() twice on nVHE?
> It's probably harmless, but I think we can have a single call here,
> and drop the call from init_hyp_mode().
> 
> What do you think? If you agree, I can perform the change when queuing
> the series.

Yes, I meant to remove the old call but evidently forgot to do that when
I rebased. Well spotted!

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
