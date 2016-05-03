From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v6 00/10] arm64: Add support for KVM with ACPI
Date: Tue, 3 May 2016 12:46:18 +0000
Message-ID: <20160503124618.GW27057@io.lakedaemon.net>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <57220C73.7010900@arm.com>
 <20160502125414.GR27057@io.lakedaemon.net>
 <20160503082124.GA17923@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160503082124.GA17923@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, Thomas Gleixner <tglx@linutronix.de>, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, gg@slimlogic.co.uk, hanjun.guo@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 03, 2016 at 10:21:24AM +0200, Christoffer Dall wrote:
> On Mon, May 02, 2016 at 12:54:14PM +0000, Jason Cooper wrote:
> > On Thu, Apr 28, 2016 at 02:13:23PM +0100, Marc Zyngier wrote:
> > > [+ Thomas, Jason]
> > > 
> > > Do you have any objection against this going through the KVM tree? The
> > > dependencies are rather intricate, and Daniel gave us his green light
> > > already for the clocksource part.
> > > 
> > > If you'd rather maintain the usual flow, please let us know and we'll
> > > deal with it.
> > 
> > I've no objection.
> > 
> > Acked-by: Jason Cooper <jason@lakedaemon.net>
> > 
> Just to be clear, that's on all the irqchip patches, right?

Correct.

thx,

Jason.
