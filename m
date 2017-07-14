From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH kvm-unit-tests 1/3] arm64: timer: Fix vtimer interrupt
 test
Date: Fri, 14 Jul 2017 08:55:32 +0100
Message-ID: <a9e2f409-2188-2fbb-3ae6-ea8515fe8758@arm.com>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170713192009.10069-2-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170713192009.10069-2-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Andrew Jones <drjones@redhat.com>, Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 13/07/17 20:20, Christoffer Dall wrote:
> The timer irq_handler is supposed to mask the timer signal, but unfortunately
> also disables the timer at the same time, even though we loop and wait on
> ISTATUS to become set.
> 
> According to the ARM ARM, "When the value of the ENABLE bit is 0, the
> ISTATUS field is UNKNOWN."  This test happens to work on AMD Seattle, but
> doesn't work on Mustang or on QEMU with TCG.

Note that this wording is a tightening of what was written in previous
of the ARMv8 ARM. Version DDI0874B.a has the above, while DDI0487A.h
doesn't, neither has the ARMv7 version.

This may explain why this was initially written this way.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
