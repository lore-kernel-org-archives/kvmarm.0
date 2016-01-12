From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] arm64: KVM: Fix AArch64 guest userspace exception
 injection
Date: Tue, 12 Jan 2016 20:13:35 +0100
Message-ID: <20160112191335.GB5795@hawk.localdomain>
References: <1452157416-9435-1-git-send-email-marc.zyngier@arm.com>
 <20160112182359.GA5795@hawk.localdomain>
 <56954992.7000307@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56954992.7000307@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <shannon.zhao@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 12, 2016 at 06:44:34PM +0000, Marc Zyngier wrote:
> On 12/01/16 18:23, Andrew Jones wrote:
> > Hi Marc,
> > 
> > Please shoot me if the following statement is false.
> 
> I wouldn't do that. Having had the privilege to waste 10 months of my
> life doing a military service, I quickly discovered I didn't like
> weapons nor those who carry them...
> 
> > Without this patch, if a guest that is running in, e.g. PSR_MODE_EL0t,
> > tries to do, e.g. 'smc #0', then KVM will inject an undef exception,
> > which should lead to the guest resuming at VBAR_EL1 + 0x400, but instead
> > it resumes at VBAR_EL1 + 0x200.
> 
> Not quite. SMC is undefined at EL0 (see C6.6.165), so it is not trapped
> to EL2, but to EL1. KVM is not in the loop at all in that case.
> 
> > Now, if you haven't started loading your gun to shoot me yet, then I'm
> > quite confused as to why the unit test[1] I wrote for this works just
> > fine without this patch.
> 
> If you want to exercise that path, you have to access something that
> wouldn't trap to EL1, but that EL2 traps. I don't think we have much
> stuff so far that can be used at EL0 and would be trapped to EL2,
> unfortunately (the PMU code is probably the first thing we'll merge).
>
> In the meantime, this test case is fairly pointless, I'm afraid...

Ah, thanks for the clarification, and the lack of desire to shoot me.
I'll stash this test case for a later day.

drew
