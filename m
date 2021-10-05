Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4122AC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 11:30:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB84861247
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 11:30:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AB84861247
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C03C4B272;
	Tue,  5 Oct 2021 07:30:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dMCLsgVr+8AV; Tue,  5 Oct 2021 07:30:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FFE94B2B7;
	Tue,  5 Oct 2021 07:30:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 977E14B272
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 07:30:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GSz6p8rbJQJg for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 07:30:47 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73A9A4B269
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 07:30:47 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58B4461247;
 Tue,  5 Oct 2021 11:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633433445;
 bh=wNKhKlemUmFvj/9jjAc6uJGFvdce9Q9PFO1r1iZLImE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=YZuidyn+FD6A8mbeiW7M00zIWi61RCYKjg9CiCvFbJVy1xT235FzhR5014EnpF7JU
 1g4EC497fRmBkOn7XJQ8uerd3TKY8IJeR3gsMRw47DiqVp2GuJDuVFJq88g8g02ZRm
 5ajCQfgt66ZVORL+avmC/R22JnkvBqruwlfwYjFjuc6KF3saaxBTwlGHAB5Ad67YF1
 UcVLiR1cAd16GlIMaarhqYMjdN7R+oiYDyaWXa8XjlQ0SdRdeS6pIWxghUwkzJ6EIH
 iJsWUA/AKtO/Q5NL1pM6KS5dW07/90st25NZhANq9UgTWiNFfVM8yFzeAtxz7ib2s3
 I+SOwuTa4xuBw==
Date: Tue, 5 Oct 2021 12:30:41 +0100
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 3/5] KVM: arm64: Propagate errors from
 __pkvm_prot_finalize hypercall
Message-ID: <20211005113040.GA29208@willie-the-truck>
References: <20210923112256.15767-1-will@kernel.org>
 <20210923112256.15767-4-will@kernel.org>
 <YVRr76aI+5zhq3nY@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YVRr76aI+5zhq3nY@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

Hey Quentin,

On Wed, Sep 29, 2021 at 02:36:47PM +0100, Quentin Perret wrote:
> On Thursday 23 Sep 2021 at 12:22:54 (+0100), Will Deacon wrote:
> > If the __pkvm_prot_finalize hypercall returns an error, we WARN but fail
> > to propagate the failure code back to kvm_arch_init().
> > 
> > Pass a pointer to a zero-initialised return variable so that failure
> > to finalise the pKVM protections on a host CPU can be reported back to
> > KVM.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/arm.c | 30 +++++++++++++++++++-----------
> >  1 file changed, 19 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 9506cf88fa0e..13bbf35896cd 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1986,9 +1986,25 @@ static int init_hyp_mode(void)
> >  	return err;
> >  }
> >  
> > -static void _kvm_host_prot_finalize(void *discard)
> > +static void _kvm_host_prot_finalize(void *arg)
> >  {
> > -	WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize));
> > +	int *err = arg;
> > +
> > +	if (WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize)))
> > +		WRITE_ONCE(*err, -EINVAL);
> > +}
> 
> I was going to suggest to propagate the hypercall's error code directly,
> but this becomes very racy so n/m...
> 
> But this got me thinking about what we should do when the hyp init fails
> while the protected mode has been explicitly enabled on the kernel
> cmdline. That is, if we continue and boot the kernel w/o KVM support,
> then I don't know how e.g. EL3 can know that it shouldn't give keys to
> VMs because the kernel (and EL2) can't be trusted. It feels like it is
> the kernel's responsibility to do something while it _is_ still
> trustworthy.
> 
> I guess we could make any error code fatal in kvm_arch_init() when
> is_protected_kvm_enabled() is on, or something along those lines? Maybe
> dependent on CONFIG_NVHE_EL2_DEBUG=n?
> 
> It's probably a bit theoretical because there really shouldn't be any
> reason to fail hyp init in production when using a signed kernel image
> etc etc, but then if that is the case the additional check I'm
> suggesting shouldn't hurt and will give us some peace of mind. Thoughts?

It's an interesting one.

I'm not hugely keen on crashing the system if we fail to deprivilege the
host (which I think is effectively what is happening in the case you
describe), but you're right that we need to disable pKVM somehow in this
case. I think the best thing would be to wipe the pvmfw memory; that would
mean that the host can do whatever it likes at EL2, as the keys will no
longer be available.

I'll make a note about this, since I've parked the pvmfw patches until
we've got more of the pKVM infrastructure up and running.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
