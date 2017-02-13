From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 28/33] irqchip/gic-v3-its: Support VPE doorbell
 invalidation even when !DirectLPI
Date: Mon, 13 Feb 2017 12:15:53 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131214430.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com> <1484648454-21216-29-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484648454-21216-29-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 17 Jan 2017, Marc Zyngier wrote:
> When we don't have the DirectLPI feature, we must work around the
> architecture shortcomings to be able to perform the required
> invalidation.
> 
> For this, we create a fake device whose sole purpose is to
> provide a way to issue a map/inv/unmap sequence (and the corresponding
> sync operations). That's 6 commands and a full serialization point
> to be able to do this.
> 
> You just have hope the hypervisor won't do that too often...
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
