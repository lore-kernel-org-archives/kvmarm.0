Return-Path: <SRS0=T474=AL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEEDC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jun 2020 08:00:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80AEB2067D
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jun 2020 08:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80AEB2067D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBA704B189;
	Tue, 30 Jun 2020 04:00:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uOXntacVRmzD; Tue, 30 Jun 2020 04:00:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 903654B1DE;
	Tue, 30 Jun 2020 04:00:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9E74B1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2020 04:00:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oeMqjbhbYyMT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Jun 2020 04:00:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C634B1DE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2020 04:00:53 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C71B81FB;
 Tue, 30 Jun 2020 01:00:52 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.4.5])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B8063F68F;
 Tue, 30 Jun 2020 01:00:51 -0700 (PDT)
Date: Tue, 30 Jun 2020 09:00:45 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 2/2] kvm/arm64: Detach ESR operator from vCPU struct
Message-ID: <20200630080045.GA71077@C02TD0UTHF1T.local>
References: <20200629091841.88198-1-gshan@redhat.com>
 <20200629091841.88198-3-gshan@redhat.com>
 <20200629110016.GB59769@C02TD0UTHF1T.local>
 <1947c322-4fd0-5161-eab8-3504235408c1@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1947c322-4fd0-5161-eab8-3504235408c1@redhat.com>
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Tue, Jun 30, 2020 at 10:16:07AM +1000, Gavin Shan wrote:
> Hi Mark,
> 
> On 6/29/20 9:00 PM, Mark Rutland wrote:
> > On Mon, Jun 29, 2020 at 07:18:41PM +1000, Gavin Shan wrote:
> > > There are a set of inline functions defined in kvm_emulate.h. Those
> > > functions reads ESR from vCPU fault information struct and then operate
> > > on it. So it's tied with vCPU fault information and vCPU struct. It
> > > limits their usage scope.
> > > 
> > > This detaches these functions from the vCPU struct by introducing an
> > > other set of inline functions in esr.h to manupulate the specified
> > > ESR value. With it, the inline functions defined in kvm_emulate.h
> > > can call these inline functions (in esr.h) instead. This shouldn't
> > > cause any functional changes.
> > > 
> > > Signed-off-by: Gavin Shan <gshan@redhat.com>
> > 
> > TBH, I'm not sure that this patch makes much sense on its own.
> > 
> > We already use vcpu_get_esr(), which is the bit that'd have to change if
> > we didn't pass the vcpu around, and the new helpers are just consuming
> > the value in a sifferent way rather than a necessarily simpler way.
> > 
> > Further comments on that front below.
> > 
> > > ---
> > >   arch/arm64/include/asm/esr.h         | 32 +++++++++++++++++++++
> > >   arch/arm64/include/asm/kvm_emulate.h | 43 ++++++++++++----------------
> > >   2 files changed, 51 insertions(+), 24 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > > index 035003acfa87..950204c5fbe1 100644
> > > --- a/arch/arm64/include/asm/esr.h
> > > +++ b/arch/arm64/include/asm/esr.h
> > > @@ -326,6 +326,38 @@ static inline bool esr_is_data_abort(u32 esr)
> > >   	return ec == ESR_ELx_EC_DABT_LOW || ec == ESR_ELx_EC_DABT_CUR;
> > >   }
> > > +#define ESR_DECLARE_CHECK_FUNC(name, field)	\
> > > +static inline bool esr_is_##name(u32 esr)	\
> > > +{						\
> > > +	return !!(esr & (field));		\
> > > +}
> > > +#define ESR_DECLARE_GET_FUNC(name, mask, shift)	\
> > > +static inline u32 esr_get_##name(u32 esr)	\
> > > +{						\
> > > +	return ((esr & (mask)) >> (shift));	\
> > > +}
> > > +
> > > +ESR_DECLARE_CHECK_FUNC(il_32bit,   ESR_ELx_IL);
> > > +ESR_DECLARE_CHECK_FUNC(condition,  ESR_ELx_CV);
> > > +ESR_DECLARE_CHECK_FUNC(dabt_valid, ESR_ELx_ISV);
> > > +ESR_DECLARE_CHECK_FUNC(dabt_sse,   ESR_ELx_SSE);
> > > +ESR_DECLARE_CHECK_FUNC(dabt_sf,    ESR_ELx_SF);
> > > +ESR_DECLARE_CHECK_FUNC(dabt_s1ptw, ESR_ELx_S1PTW);
> > > +ESR_DECLARE_CHECK_FUNC(dabt_write, ESR_ELx_WNR);
> > > +ESR_DECLARE_CHECK_FUNC(dabt_cm,    ESR_ELx_CM);
> > > +
> > > +ESR_DECLARE_GET_FUNC(class,        ESR_ELx_EC_MASK,      ESR_ELx_EC_SHIFT);
> > > +ESR_DECLARE_GET_FUNC(fault,        ESR_ELx_FSC,          0);
> > > +ESR_DECLARE_GET_FUNC(fault_type,   ESR_ELx_FSC_TYPE,     0);
> > > +ESR_DECLARE_GET_FUNC(condition,    ESR_ELx_COND_MASK,    ESR_ELx_COND_SHIFT);
> > > +ESR_DECLARE_GET_FUNC(hvc_imm,      ESR_ELx_xVC_IMM_MASK, 0);
> > > +ESR_DECLARE_GET_FUNC(dabt_iss_nisv_sanitized,
> > > +		     (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC), 0);
> > > +ESR_DECLARE_GET_FUNC(dabt_rd,      ESR_ELx_SRT_MASK,     ESR_ELx_SRT_SHIFT);
> > > +ESR_DECLARE_GET_FUNC(dabt_as,      ESR_ELx_SAS,          ESR_ELx_SAS_SHIFT);
> > > +ESR_DECLARE_GET_FUNC(sys_rt,       ESR_ELx_SYS64_ISS_RT_MASK,
> > > +				   ESR_ELx_SYS64_ISS_RT_SHIFT);
> > 
> > I'm really not keen on this, as I think it's abstracting the problem at
> > the wrong level, hiding information and making things harder to reason
> > about rather than abstracting that.
> > 
> > I strongly suspect the right thing to do is use FIELD_GET() in-place in
> > the functions below, e.g.
> > 
> >     !!FIELD_GET(esr, ESR_ELx_IL);
> > 
> > ... rather than:
> > 
> >     esr_get_il_32bit(esr);
> > 
> > ... as that avoids the wrapper entirely, minimizing indirection and
> > making the codebase simpler to navigate.
> > 
> > For the cases where we *really* want a helper, i'd rather write those
> > out explicitly, e.g.
> 
> It will be no difference except to use FIELD_GET() to make the code
> more explicit. Maybe I didn't fully understand your comments here.
> Please let me know if something like below is what you expect?

Sorry; my point here was just that using FIELD_GET() explicitly was
preferable to generating an entire function with
ESR_DECLARE_CHECK_FUNC() if the goal was just to remove the explciit
mask-and-shift at each callsite.

I agree they'd have the same functional behaviour, but I think the
explicit FIELD_GET() approach is easier to read (and possible to search
for), which makes code maintenance much easier.

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index c9ba0df47f7d..e8294edcd8f4 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -343,7 +343,7 @@ static __always_inline unsigned int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *
>  /* This one is not specific to Data Abort */
>  static __always_inline bool kvm_vcpu_trap_il_is32bit(const struct kvm_vcpu *vcpu)
>  {
> -       return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_IL);
> +       return !!FIELD_GET(kvm_vcpu_get_esr(vcpu), ESR_ELx_IL);
>  }
> 
> If my understanding is correct, I think we needn't change the code
> and this patch can be dropped.

If you don't see a need for a change, I'm also happy for this to be
dropped.

[...]

> > #define esr_get_hvc_imm(esr)	FIELD_GET(esr, ESR_ELx_xVC_IMM_MASK)
> > 
> > ... but I'm not sure if we really need those given these are mostly used
> > *once* below.
> > 
> 
> We don't need these for now, but will be needed when the next revision
> of async page fault is posted. Lets ignore this requirement for now
> because I can revisit it when the async page fault patchset is posted.
> That time, we can have accessors defined in esr.h and helpers in
> kvm_emulate.h use those accessors. It's similar to what you're suggesting.
> 
> #define esr_get_hvc_imm(esr)	FIELD_GET(esr, ESR_ELx_xVC_IMM_MASK)
> 
> static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
> {
> 	return esr_get_hvc_imm(kvm_vcpu_get_esr(vcpu));
> }

That'd be fine by me.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
