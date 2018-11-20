From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 0/4] KVM: arm/arm64: vgic: Use raw_spinlock for locks
 taken in IRQ context
Date: Tue, 20 Nov 2018 15:20:00 +0100
Message-ID: <20181120142000.GB11162@e113682-lin.lund.arm.com>
References: <1542647279-46609-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1542647279-46609-1-git-send-email-julien.thierry@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, linux-rt-users@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org, bigeasy@linutronix.de
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 19, 2018 at 05:07:55PM +0000, Julien Thierry wrote:
> While testing KVM running on PREEMPT_RT, starting guest could simply
> freeze the machine. This is because we are using spinlocks for VGIC
> locks, which is invalid in the VGIC case since the locks must be take
> with interrupts disabled.
> 
> The solution is to use raw_spinlock instead of spinlocks.
> 
> Replacing those locks also highlighted an issue where we attempt to
> cond_resched with interrupts disabled.
> 
> Patch 1 fixes the cond_resched issue.

I don't agree with this fix without seeing a more thorough analysis.

> Patch 2-4 replace the VGIC spinlocks with raw_spinlocks
> 

For these:

Acked-by: Christoffer Dall <christoffer.dall@arm.com>



Thanks,

    Christoffer
