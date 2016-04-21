From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v7 1/6] KVM: arm/arm64: Add VGICv3 save/restore API
 documentation
Date: Thu, 21 Apr 2016 20:30:56 +0200
Message-ID: <20160421183056.GA25288@cbox>
References: <cover.1449491035.git.p.fedin@samsung.com>
 <204d6b178e611ee0b5aede2b945516e0a6048c3c.1449491035.git.p.fedin@samsung.com>
 <CAFEAcA_N7F4r6fpQTW8Duyu577=uGcRyS7VhAMxumwTDN3khcw@mail.gmail.com>
 <CAMJs5B8b1kpdeUDPGOcyaiNjSo+ZSzzUZOS4+wJ6cWmjtd58dg@mail.gmail.com>
 <CAFEAcA8mtkLqrTKVQsCCG9xyb0MsFasxXZM=8bZ=covrBd6VrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA8mtkLqrTKVQsCCG9xyb0MsFasxXZM=8bZ=covrBd6VrQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 20, 2016 at 02:28:05PM +0100, Peter Maydell wrote:
> On 20 April 2016 at 11:59, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > On Friday, 15 April 2016, Peter Maydell <peter.maydell@linaro.org> wrote:
> >> Nothing in here describes a mechanism for reading or writing the
> >> current interrupt line_level state from the kernel (which doesn't
> >> matter for edge triggered interrupts but does for level triggered
> >> interrupts). Do we need accessors for these or does somebody
> >> have a good rationale for why we don't need to migrate that data?
> >> (Christoffer?)
> 
> > I thought we relied on user space to migrate its device state including the
> > interrupt line output state and set the corresponding line state to the
> > kernel, but that may have been wrong, and would rely on userspace to call
> > the IRQ_LINE ioctl again.  Would that work?
> 
> I'm not sure; it's definitely not what we do today, anyway...
> 
> > How is it again, does QEMU preserve the IRQ output line state per device?
> 
> In QEMU device models, each device has its own state and generally
> tracks the level of its input lines as necessary. When state
> restore happens, the device on the sending end restores its own
> state but doesn't reassert the irq line; the assumption is that
> the device on the receiving end restores its own state including
> the level of its input lines.
> 
> > This may just work currently because we rely on the reads/writes to SPENDR
> > to preserve the state and apparently level triggered interrupts are
> > reinjected as needed.
> 
> I think the reason it more or less works is that as you say we
> write the pending bits back to the PENDR registers. There are
> two cases where this goes wrong for level triggered interrupts,
> though:
> (1) if a device deasserts its interrupt output before the
> guest OS gets round to acknowledging the interrupt, then
> what should happen is that the interrupt stops being pending;
> since we wrote to PENDR then the latch means we'll deliver
> the guest a spurious interrupt
> (2) if a guest OS's interrupt handler doesn't quiesce the
> device such that it deasserts the interrupt output, then
> what should happen is that when the interrupt is dismissed
> it remains pending and will trigger again; since we didn't
> copy the level state into the kernel then the kernel won't
> notice and won't deliver the interrupt again
> 
> Since the distributor/redistributor is fully emulated inside
> the kernel, we have the underlying state separately for
> levels and for the pending-latch, right? We don't need to
> make it impossible to access the latch separately just
> because that's what the hardware does...
> 
So I agree about the latch state, that should be exported, if nothing
else so that a VM can't use this particular change to detect a
migration, for example.

However, for the input level, I really do see this as a wire state
between userspace and the kernel, and as something that userspace should
re-establish after migration, since userspace already knows what the
line level is, why does it need to pull it out of the kernel again?

-Christoffer
