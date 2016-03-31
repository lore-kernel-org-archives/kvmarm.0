From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 00/45] KVM: arm/arm64: Rework virtual GIC emulation
Date: Thu, 31 Mar 2016 20:28:42 +0200
Message-ID: <20160331182842.GJ4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On Fri, Mar 25, 2016 at 02:04:23AM +0000, Andre Przywara wrote:
> This series is a joint effort to re-implement KVM's GIC emulation.
> 
> While the current implementation is centered around providing
> efficient MMIO emulation, the hot path for most guests is actually
> the guest entry and exit, which currently is rather costly.
> Also the existing emulation has a global distributor lock, which
> quickly becomes a bottleneck once the number of VCPUs increases.
> Additionally the emulation was originally designed for GICv2, adding
> GICv3 ITS emulation support to this proved to be rather painful.
> Last, but not least the existing code became less and less
> maintainable, with many special cases handled explicitly.
> 
> The new implementation is build around a struct vgic_irq data data
> structure, which holds all information about a virtual interrupt.
> Interruts which should be injected are hold in a per-VCPU list, this
> make the entry/exit path much more efficient. Also the new structure
> allows to have more fine grained locking - per IRQ and per VCPU -
> getting rid of the global distributor lock.
> As a result of the new design ITS emulation fits in more nicely, the
> respective code will be provided as a follow-up series.
> 
> This series implements the same feature set as the existing emulation,
> as a goodie we now implement priorities correctly.
> To allow an easy transition with good test coverage, but still maintain
> stability, both implementations live side by side, selectable via a
> Kconfig option. The default is the new implementation.
> If this code proves to be reliable, we will later remove the current
> implementation with an extra patch set.
> 
> Please have a look at the series, review it and give the code some
> serious testing (and possibly debugging). All feedback is appreciated.
> 

Huge thanks for all the hard work in putting this together, I'm sure it
hasn't been easy.

I have gone through this series and I think we're overall in pretty good
shape.  I haven't reviewed the code in detail, checked every bitfield
etc., but focused on the overall design choices, locking correctness
etc.

A number of patches don't have have commit message and some commit
messages could be clarified, but it is what it is.

I've given this a quick test on Mustang and on TC2, and it builds and
appears to run decently stable.  Obviously we should give this some more
rigorous testing, but I will wait until v2 with that.

I'll probably send the timer/vgic interface changes bits as patches for
you to base the next series on, assuming you and the others agreed with
my comments and suggestions on that part here.

Thanks,
-Christoffer
