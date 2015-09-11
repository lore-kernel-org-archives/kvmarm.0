From: Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH v4 3/4] irqchip: GIC: Convert to EOImode == 1
Date: Fri, 11 Sep 2015 11:54:41 +0100
Message-ID: <1441968881.3549.20.camel@citrix.com>
References: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com>
	 <1440604845-28229-4-git-send-email-marc.zyngier@arm.com>
	 <55F08731.3050402@citrix.com> <55F15353.2000800@arm.com>
	 <55F1AE75.6000405@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55F1AE75.6000405@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Grall <julien.grall@citrix.com>, Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Stefano Stabellini <stefano.stabellini@eu.citrix.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-09-10 at 17:23 +0100, Julien Grall wrote:
> I applied the two patches on top of linus/master and I'm able to boot
> correctly on X-gene. Thank you!

Perhaps we should replicate this approach in Xen and get rid of
 PLATFORM_QUIRK_GIC_64K_STRIDE?

Ian.
