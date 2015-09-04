From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/2] arm/arm64: KVM: arch timer: Reset CNTV_CTL to 0
Date: Fri, 04 Sep 2015 15:51:44 +0100
Message-ID: <55E9B000.9040502@arm.com>
References: <1441376679-8341-1-git-send-email-christoffer.dall@linaro.org> <1441376679-8341-3-git-send-email-christoffer.dall@linaro.org> <20150904144719.GJ5171@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150904144719.GJ5171@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Laszlo Ersek <lersek@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Drew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/09/15 15:47, Christoffer Dall wrote:
> On Fri, Sep 04, 2015 at 04:24:39PM +0200, Christoffer Dall wrote:
>> Provide a better quality of implementation and be architecture compliant
>> on ARMv7 for the architected timer by resetting the CNTV_CTL to 0 on
>> reset of the timer, and call kvm_timer_update_state(vcpu) at the same
>> time, ensuring the timer output is not asserted after, for example, a
>> PSCI system reset.
> 
> forgot to remove the bit about kvm_timer_update_state(vcpu) which is no
> longer valid when these patches are merged before the rework series.
> 
> Marc, if you're otherwise happy with this patch, can you fix this up at
> commit time?

No problem, I can fix the commit message on applying the patch.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
