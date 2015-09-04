From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/9] KVM: Add kvm_arch_vcpu_{un}blocking callbacks
Date: Fri, 4 Sep 2015 16:50:23 +0200
Message-ID: <20150904145023.GK5171@cbox>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
 <1440942866-23802-2-git-send-email-christoffer.dall@linaro.org>
 <55E9A190.10602@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55E9A190.10602@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 04, 2015 at 03:50:08PM +0200, Eric Auger wrote:
> Hi Christoffer,
> On 08/30/2015 03:54 PM, Christoffer Dall wrote:
> > Some times it is useful for architecture implementations of KVM to know
> > when the VCPU thread is about to block or when it comes back from
> > blocking (arm/arm64 needs to know this to properly implement timers, for
> > example).
> what about vcpu_sleep()? Is that callback specific to kvm_vcpu_block
> function entry/exit points or is it more generic? The question also
> applies to future halt/resume functions
> 
For ARM, This should be called when we're about to block in a situation
where timer interrupts could affect our sleep state, which would not be
the case for vcpu_sleep, which unconditionally puts the vcpu to sleep
based on other conditions.

I believe that any case where you care about incoming interrupts are
covered by the semantics of kvm_vcpu_block, and therefore these hooks
should only be called by kvm_vcpu_block.

Thanks,
-Christoffer
