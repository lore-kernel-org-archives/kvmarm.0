From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/8] arm64: KVM: Disable virtual timer even if the guest
 is not using it
Date: Thu, 17 Sep 2015 17:31:02 +0200
Message-ID: <55FADCB6.8010100@redhat.com>
References: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
 <1442501171-24484-6-git-send-email-marc.zyngier@arm.com>
 <55FAD607.9040305@redhat.com> <55FADC1E.50909@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55FADC1E.50909@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, Marek Majtyka <marek.majtyka@tieto.com>, Pavel Fedin <p.fedin@samsung.com>, Ming Lei <ming.lei@canonical.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 17/09/2015 17:28, Marc Zyngier wrote:
> > diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
> > index 702740d37465..93e322b4d242 100644
> > --- a/arch/arm/kvm/interrupts_head.S
> > +++ b/arch/arm/kvm/interrupts_head.S
> > @@ -514,6 +514,7 @@ ARM_BE8(rev	r6, r6  )
> >  	beq	1f
> >  
> >  	mrc	p15, 0, r2, c14, c3, 1	@ CNTV_CTL
> > +	and	r2, r2, #3
> 
> I don't think we need this. Exposing the ISTATUS bit to the kernel (or
> even userspace) is not really a problem (that's actually an interesting
> piece of information), and restoring it is not possible since it is
> read-only.
> 
> We should drop the equivalent 'and' from the arm64 version.

Ok.  I'll resend the thing as a proper patch.

Paolo
