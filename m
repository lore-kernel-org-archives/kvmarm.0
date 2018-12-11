From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v2 4/4] KVM: arm/arm64: vgic: Make vgic_cpu->ap_list_lock
 a raw_spinlock
Date: Tue, 11 Dec 2018 11:32:32 +0100
Message-ID: <20181211103232.GW30263@e113682-lin.lund.arm.com>
References: <1543256807-9768-1-git-send-email-julien.thierry@arm.com>
 <1543256807-9768-5-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1543256807-9768-5-git-send-email-julien.thierry@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, linux-rt-users@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org, bigeasy@linutronix.de
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 26, 2018 at 06:26:47PM +0000, Julien Thierry wrote:
> vgic_cpu->ap_list_lock must always be taken with interrupts disabled as
> it is used in interrupt context.
> 
> For configurations such as PREEMPT_RT_FULL, this means that it should
> be a raw_spinlock since RT spinlocks are interruptible.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>


Acked-by: Christoffer Dall <christoffer.dall@arm.com>
