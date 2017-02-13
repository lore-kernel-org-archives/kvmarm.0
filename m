From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 01/33] irqchip/gic-v3: Add redistributor iterator
Date: Mon, 13 Feb 2017 10:39:14 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131039020.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com> <1484648454-21216-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484648454-21216-2-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 17 Jan 2017, Marc Zyngier wrote:

> In order to discover the VLPI properties, we need to iterate over
> the redistributor regions. As we already have code that does this,
> let's factor it out and make it slightly more generic.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
