From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 49/59] KVM: arm/arm64: GICv4: Propagate VLPI
 properties at map time
Date: Wed, 30 Aug 2017 22:12:25 +0200
Message-ID: <20170830201225.GM24522@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-50-marc.zyngier@arm.com>
 <20170828181841.GJ24649@cbox>
 <60012f9d-7eb9-e8f4-a2c4-82e00ff52c0c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <60012f9d-7eb9-e8f4-a2c4-82e00ff52c0c@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 30, 2017 at 03:56:57PM +0100, Marc Zyngier wrote:
> On 28/08/17 19:18, Christoffer Dall wrote:
> > On Mon, Jul 31, 2017 at 06:26:27PM +0100, Marc Zyngier wrote:
> >> When the VLPI gets mapped, it must inherit the configuration of
> >> LPI configured at the vITS level. FOr that purpose, let's make
> > 
> > *the LPI
> > *For that
> 
> Will fix, thanks.
> 
> > 
> >> update_lpi_config globally available and call it just after
> >> having performed the VLPI map operation.
> >>
> > 
> > I assume this means that the GIC compares the priorities of virtual
> > interrupts in the LRs with the priorities of the pending VLPIs and
> > figures out what to signal first?  I couldn't find anywhere in the spec
> > where this is explicitly stated.
> 
> There is this mention in IHI0069D, 5.4 (Virtual LPI support):
> 
> "The Redistributor associated with the PE on which the vPE is scheduled
> determines the highest priority pending vLPI, and forwards this to the
> virtual CPU interface of the vPE. This vLPI and the interrupts in the
> List register are then prioritized together to determine the highest
> priority pending virtual interrupt for the vPE."
> 

Wow, I didn't find that staring at the manual for a considerable amount
of time.  Thanks for the pointer.

Thanks,
-Christoffer
