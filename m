Return-Path: <SRS0=HDjL=MW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522BDC4338F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 12:50:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1CA361019
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 12:50:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C1CA361019
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49B9F4B09B;
	Fri, 30 Jul 2021 08:50:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CQaBhK+KiCuU; Fri, 30 Jul 2021 08:50:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1D844B0B3;
	Fri, 30 Jul 2021 08:50:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF0DB4B09E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 08:50:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zthvdZQwwCuO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 08:50:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A35974B09B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 08:50:15 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84E8060F94;
 Fri, 30 Jul 2021 12:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627649414;
 bh=Qx8s173dITTj8lJV0Vz8eXvZOBa4mUT9bdDcZtwP9Uo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=FElWlKyjKu/pcWTrbgSrqv/Is3Rt7MaSar2yTy2qsCABnJd2AlNmxJP17O/tqGRmn
 Z+OrWRwxwm+SjOmpbYX2hRt0zu+6dPgzKnxi8SCvCqokvhn3XdrEvRuoa8F+9xg0/l
 kEKUMk6Q6fHWLK8pI4QJuS4aejesAiwFNKpJAK2mUaVHEx9hAEVZzS39P+v/va8ik0
 DguLFDI2Jlg+dzGCuTAdx1/Su7YHNFHHF02BCsIPZCCUjdLYTgmrT+26Ar/MRDFhDH
 f/caP/gOfCDjDOxCkP4VOx9QzBfgcwCfUcvC0MIuoyVo6CYTwZ1t/fdnbAe9kNVWc5
 0XVIgQF+h36wA==
Date: Fri, 30 Jul 2021 13:50:09 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 06/16] KVM: arm64: Force a full unmap on vpcu reinit
Message-ID: <20210730125008.GB23756@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-7-maz@kernel.org>
 <20210727181132.GE19173@willie-the-truck>
 <87wnpad8pg.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87wnpad8pg.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Jul 28, 2021 at 11:38:35AM +0100, Marc Zyngier wrote:
> On Tue, 27 Jul 2021 19:11:33 +0100,
> Will Deacon <will@kernel.org> wrote:
> > 
> > On Thu, Jul 15, 2021 at 05:31:49PM +0100, Marc Zyngier wrote:
> > > As we now keep information in the S2PT, we must be careful not
> > > to keep it across a VM reboot, which could otherwise lead to
> > > interesting problems.
> > > 
> > > Make sure that the S2 is completely discarded on reset of
> > > a vcpu, and remove the flag that enforces the MMIO check.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/arm.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 97ab1512c44f..b0d2225190d2 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -1096,12 +1096,18 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
> > >  	 * ensuring that the data side is always coherent. We still
> > >  	 * need to invalidate the I-cache though, as FWB does *not*
> > >  	 * imply CTR_EL0.DIC.
> > > +	 *
> > > +	 * If the MMIO guard was enabled, we pay the price of a full
> > > +	 * unmap to get back to a sane state (and clear the flag).
> > >  	 */
> > >  	if (vcpu->arch.has_run_once) {
> > > -		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> > > +		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) ||
> > > +		    test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
> > >  			stage2_unmap_vm(vcpu->kvm);
> > >  		else
> > >  			icache_inval_all_pou();
> > > +
> > > +		clear_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags);
> > 
> > What prevents this racing with another vCPU trying to set the bit?
> 
> Not much. We could take the kvm lock on both ends to serialize it, but
> that's pretty ugly. And should we care? What is the semantic of
> resetting a vcpu while another is still running?

It's definitely weird, but given that this is an attack vector I don't think
we can rule out attackers trying whacky stuff like this (although maybe
we end up forbidding vcpu reset in pKVM -- dunno).

> If we want to support this sort of behaviour, then our tracking is
> totally bogus, because it is VM-wide. And you don't even have to play
> with that bit from another vcpu: all the information is lost at the
> point where we unmap the S2 PTs.
> 
> Maybe an alternative is to move this to the halt/reboot PSCI handlers,
> making it clearer what we expect?

I think that's probably worth looking at. The race is quite hard to reason
about otherwise, so if clearing the bit can be done on the teardown path
in single-threaded context then I think that's better. It looks like
kvm_prepare_system_event() has all the synchronisation we need there.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
