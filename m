From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 14/33] irqchip/gic-v3-its: Generalize LPI
 configuration
Date: Mon, 13 Feb 2017 11:32:47 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131132360.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com> <1484648454-21216-15-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484648454-21216-15-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 17 Jan 2017, Marc Zyngier wrote:

> We're are going to need to change a bit more than just the enable
> bit in the LPI property table in the future. So let's change the
> LPI configuration funtion to take a set of bits to be cleared,
> and a set of bits to be set.
> 
> This way, we'll be able to use it when a guest updates an LPI
> property (priority, for example).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
