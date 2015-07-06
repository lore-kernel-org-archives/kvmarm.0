From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Mon, 6 Jul 2015 14:08:37 +0200
Message-ID: <20150706120837.GA13530@cbox>
References: <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com>
 <5596503E.6040902@arm.com>
 <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com>
 <559A3C9C.6050302@arm.com>
 <20150706093026.GA11590@cbox>
 <559A52E6.5050402@arm.com>
 <20150706103755.GC11590@cbox>
 <559A6164.1000401@redhat.com>
 <559A6527.1040107@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <559A6527.1040107@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Pavel Fedin <p.fedin@samsung.com>, 'Eric Auger' <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 12:23:19PM +0100, Andre Przywara wrote:
> Hi Paolo,
> 
> thanks for looking at this!
> 
> On 06/07/15 12:07, Paolo Bonzini wrote:
> > 
> > 
> > On 06/07/2015 12:37, Christoffer Dall wrote:
> >> I don't view it as 'the kernel requires this' but as 'the kernel will
> >> not complain with arbitrary error code if you set the devid flag'
> >> capability, and it's up to userspace (as usual) to provide the correct
> >> arguments for things to work, and up to the kernel to ensure we don't
> >> crash the system etc.
> >>
> >> Thus, if you want to advertise it as a capability, I would rather call
> >> it KVM_CAP_MSI_DEVID.
> > 
> > I agree.  Does userspace know that ITS guests always require devid?
> 
> Well, as we are about to implement this: yes. But the issue is that MSI
> injection and GSI routing code is generic PCI code in userland (at least
> in kvmtool, guess in QEMU, too), so I don't want to pull in any kind of
> ARM specific code in there. The idea is to always provide the device ID
> from the PCI code (for PCI devices it's just the B/D/F triplet), but
> only send it to the kernel if needed. Querying a KVM capability is
> perfectly fine for this IMO.
> 
> > I
> > guess it's okay to return -EINVAL if the userspace doesn't set the flag
> > but the virtual hardware requires it.
> 
> Yes, that is what I do in the kernel implementation. And that is
> perfectly fine: the ITS emulation does not work without a device ID, the
> ITS driver in the guest assigns the very same payload (and address) to
> different devices, so there is no way to tell the MSIs apart without a
> unique device ID.
> 
Just so I'm sure I understand: The way the kernel differentiates between
no-devid and devid==0, is whether or not the devid flag is set, correct?

-Christoffer
