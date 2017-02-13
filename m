From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 19/33] irqchip/gic-v3-its: Add VLPI configuration
 handling
Date: Mon, 13 Feb 2017 11:38:43 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131138080.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com> <1484648454-21216-20-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484648454-21216-20-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 17 Jan 2017, Marc Zyngier wrote:

> When a VLPI is reconfigured (enabled, disabled, change in priority),
> the full configuration byte must be written, and the caches invalidated.
> 
> Also, when using the irq_mask/irq_unmask methods, it is necessary
> to disable the doorbell for that particular interrupt (by mapping it
> to 1023) on top of clearing the Enable bit.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Aside of the switch/case part:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
