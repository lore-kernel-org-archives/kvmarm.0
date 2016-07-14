From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [patch V2 60/67] KVM/arm/arm64/vgic-new: Convert to hotplug state
 machine
Date: Thu, 14 Jul 2016 14:08:03 +0100
Message-ID: <57878EB3.3040606@arm.com>
References: <20160713153219.128052238@linutronix.de>
 <20160713153337.900484868@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160713153337.900484868@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Anna-Maria Gleixner <anna-maria@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, rt@linutronix.de, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Radim Krcmar <rkrcmar@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 13/07/16 18:17, Anna-Maria Gleixner wrote:
> From: Anna-Maria Gleixner <anna-maria@linutronix.de>
> 
> Install the callbacks via the state machine and let the core invoke
> the callbacks on the already online CPUs.
> 
> Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
> Cc: Andre Przywara <andre.przywara@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Eric Auger <eric.auger@linaro.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: kvm@vger.kernel.org
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-arm-kernel@lists.infradead.org

For patches 3, 4, 5, 6, 7, 44, 45 and 60:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
