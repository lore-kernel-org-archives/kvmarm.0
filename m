From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH kvm-unit-tests 1/3] arm64: timer: Fix vtimer interrupt
 test
Date: Fri, 14 Jul 2017 08:43:55 -0700
Message-ID: <20170714154355.GB1535@lvm>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170713192009.10069-2-cdall@linaro.org>
 <a9e2f409-2188-2fbb-3ae6-ea8515fe8758@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a9e2f409-2188-2fbb-3ae6-ea8515fe8758@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Andrew Jones <drjones@redhat.com>, Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 14, 2017 at 08:55:32AM +0100, Marc Zyngier wrote:
> On 13/07/17 20:20, Christoffer Dall wrote:
> > The timer irq_handler is supposed to mask the timer signal, but unfortunately
> > also disables the timer at the same time, even though we loop and wait on
> > ISTATUS to become set.
> > 
> > According to the ARM ARM, "When the value of the ENABLE bit is 0, the
> > ISTATUS field is UNKNOWN."  This test happens to work on AMD Seattle, but
> > doesn't work on Mustang or on QEMU with TCG.
> 
> Note that this wording is a tightening of what was written in previous
> of the ARMv8 ARM. Version DDI0874B.a has the above, while DDI0487A.h
> doesn't, neither has the ARMv7 version.
> 
> This may explain why this was initially written this way.
> 

ok, but even so, this patch should test things in a way that should work
on all systems, right?

Thanks,
-Christoffer
