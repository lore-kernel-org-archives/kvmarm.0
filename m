Return-Path: <SRS0=LqQy=H4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A5AC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 26 Feb 2021 19:06:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C68664F2B
	for <kvmarm@archiver.kernel.org>; Fri, 26 Feb 2021 19:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C68664F2B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F12424B308;
	Fri, 26 Feb 2021 14:06:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9biloDyBERm6; Fri, 26 Feb 2021 14:05:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E379D4B2FA;
	Fri, 26 Feb 2021 14:05:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEA694B2F3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2021 14:05:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h7pA8dC7s2it for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2021 14:05:57 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C21F54B2F0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2021 14:05:57 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55E9064EFA;
 Fri, 26 Feb 2021 19:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614366356;
 bh=/b4ys3WDojeIMBKFZ7oN//rLP0M5lRr285LlWdBs8ac=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=s3ravjhZxvr4pz1VHNtLhrSEQe4D3Re+vFYgqiVPcatv466Z9+sqF9VfGHNtF36++
 MItka4aOe2aLmU70bvuQyV59TVodmrvgryGZSZ87AsUxUzbKm6urMcIAlUuiIA961u
 XJB8fQcuH5psJuSrwCAaah2U5ZPoUOxGKnGUz5ErbFaCK7sbR4XwL4M6qs6SPchR+R
 hkmjOWhy0RYK0cj8I0JPwGlSl1ndSnVXckCmYyOJeDBiIvmVM1Mw08w9hjoP9dLkE6
 9IygiPsudwaoJOXWp7sh4wDmwGyJvipOY5f3ea+IMkoDutSAeFhvEXfMcQQ8JIrHMW
 kl6ywOtrY5J/A==
Date: Fri, 26 Feb 2021 19:05:52 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Avoid corrupting vCPU context register in
 guest exit
Message-ID: <20210226190551.GA14700@willie-the-truck>
References: <20210226181211.14542-1-will@kernel.org>
 <f6b11e03ac9f0a4830e0a8f56a91450f@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f6b11e03ac9f0a4830e0a8f56a91450f@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: stable@vger.kernel.org, kernel-team@android.com,
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

On Fri, Feb 26, 2021 at 06:35:42PM +0000, Marc Zyngier wrote:
> On 2021-02-26 18:12, Will Deacon wrote:
> > Commit 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest
> > context") tracks the currently running vCPU, clearing the pointer to
> > NULL on exit from a guest.
> > 
> > Unfortunately, the use of 'set_loaded_vcpu' clobbers x1 to point at the
> > kvm_hyp_ctxt instead of the vCPU context, causing the subsequent RAS
> > code to go off into the weeds when it saves the DISR assuming that the
> > CPU context is embedded in a struct vCPU.
> > 
> > Leave x1 alone and use x3 as a temporary register instead when clearing
> > the vCPU on the guest exit path.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Andrew Scull <ascull@google.com>
> > Cc: <stable@vger.kernel.org>
> > Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest
> > context")
> > Suggested-by: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> > 
> > This was pretty awful to debug!
> > 
> >  arch/arm64/kvm/hyp/entry.S | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> > index b0afad7a99c6..0c66a1d408fd 100644
> > --- a/arch/arm64/kvm/hyp/entry.S
> > +++ b/arch/arm64/kvm/hyp/entry.S
> > @@ -146,7 +146,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
> >  	// Now restore the hyp regs
> >  	restore_callee_saved_regs x2
> > 
> > -	set_loaded_vcpu xzr, x1, x2
> > +	set_loaded_vcpu xzr, x2, x3
> > 
> >  alternative_if ARM64_HAS_RAS_EXTN
> >  	// If we have the RAS extensions we can consume a pending error
> 
> Grmbl... How comes we have never seen that for the past 5 months,
> including on CPUs that implement RAS?

I think it's probably a combination of (a) not having a massive testing
community (b) not having tools that would scream about this (e.g. I don't
think you could detect this with KASAN) and (c) the nature of the
corruption being mostly benign in practice.

We found it in pKVM development because it landed on the vtcr we were
restoring when coming out of suspend, which then meant the page-table
code went wonky on the next stage-2 fault because it got the wrong start
level and kept returning -EAGAIN because it thought a table was a leaf.
So even then, the failure mode is horribly subtle.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
