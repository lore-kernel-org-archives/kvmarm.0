From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 23/28] arm64/sve: KVM: Treat guest SVE use as
 undefined instruction execution
Date: Fri, 29 Sep 2017 14:00:30 +0100
Message-ID: <20170929130029.GG3611@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-24-git-send-email-Dave.Martin@arm.com>
 <874ls59zku.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <874ls59zku.fsf@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 14, 2017 at 02:31:13PM +0100, Alex Bennée wrote:
> 
> Dave Martin <Dave.Martin@arm.com> writes:
> 
> > When trapping forbidden attempts by a guest to use SVE, we want the
> > guest to see a trap consistent with SVE not being implemented.
> >
> > This patch injects an undefined instruction exception into the
> > guest in response to such an exception.
> 
> I do wonder if this should be merged with the previous trap enabling
> patch though?

Yes, that would make sense now I look at it.

Can I keep your Reviewed-by on the combined patch?

Cheers
---Dave

> 
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kvm/handle_exit.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index 17d8a16..e3e42d0 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -147,6 +147,13 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  	return 1;
> >  }
> >
> > +static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > +{
> > +	/* Until SVE is supported for guests: */
> > +	kvm_inject_undefined(vcpu);
> > +	return 1;
> > +}
> > +
> >  static exit_handle_fn arm_exit_handlers[] = {
> >  	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
> >  	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
> > @@ -160,6 +167,7 @@ static exit_handle_fn arm_exit_handlers[] = {
> >  	[ESR_ELx_EC_HVC64]	= handle_hvc,
> >  	[ESR_ELx_EC_SMC64]	= handle_smc,
> >  	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
> > +	[ESR_ELx_EC_SVE]	= handle_sve,
> >  	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
> >  	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
> >  	[ESR_ELx_EC_SOFTSTP_LOW]= kvm_handle_guest_debug,
> 
> 
> --
> Alex Bennée
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
