From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Sat, 9 Jan 2016 15:03:39 +0000
Message-ID: <20160109150339.10576e81@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
	<1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
	<CAFEAcA_MDiOphseZ7RGNE3G=4ZDF5SFV5krOjanPbVuhgg9gnQ@mail.gmail.com>
	<568E7AF1.9040103@huawei.com>
	<CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com>
	<20160107203647.GJ6199@hawk.localdomain>
	<20160109122956.GA30867@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160109122956.GA30867@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, 9 Jan 2016 13:29:56 +0100
Christoffer Dall <christoffer.dall@linaro.org> wrote:

> On Thu, Jan 07, 2016 at 09:36:47PM +0100, Andrew Jones wrote:
> > On Thu, Jan 07, 2016 at 02:56:15PM +0000, Peter Maydell wrote:
> > > On 7 January 2016 at 14:49, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> > > >>> +
> > > >>> +Groups:
> > > >>> +  KVM_DEV_ARM_PMU_GRP_IRQ
> > > >>> +  Attributes:
> > > >>> +    The attr field of kvm_device_attr encodes one value:
> > > >>> +    bits:     | 63 .... 32 | 31 ....  0 |
> > > >>> +    values:   |  reserved  | vcpu_index |
> > > >>> +    A value describing the PMU overflow interrupt number for the specified
> > > >>> +    vcpu_index vcpu. This interrupt could be a PPI or SPI, but for one VM the
> > > >>> +    interrupt type must be same for each vcpu. As a PPI, the interrupt number is
> > > >>> +    same for all vcpus, while as a SPI it must be different for each vcpu.
> > > >>
> > > >> I see we're using vcpu_index rather than MPIDR affinity value
> > > >> for specifying which CPU we're configuring. Is this in line with
> > > >> our planned API for GICv3 configuration?
> > > >>
> > > > Here vcpu_index is used to indexing the vCPU, no special use.
> > > 
> > > Yes, but you can identify the CPU by index, or by its MPIDR.
> > > We had a discussion about which was the best way for doing
> > > the VGIC API, and I can't remember which way round we ended up
> > > going for. Whichever we chose, we should do the same thing here.
> > 
> > I think we should start up a new discussion on this. My understanding,
> > after a chat with Igor, who was involved in the untangling of vcpu-id and
> > apic-id for x86, is that using vcpu-id is preferred, unless of course
> > the device expects an apic-id/mpidr, in which case there's no reason to
> > translate it on both sides.
> > 
> 
> I'm fairly strongly convinced that we should use the full 32-bit
> compressed MPIDR for everything ARM related going forward, as this will
> cover any case required and leverages and architecturally defined way of
> uniquely identifying a (v)CPU.

+1.

vcpu_ids, indexes or any other constructs are just a bunch
of KVM-specific definitions that do not describe the VM from an
architecture PoV. In contrast, the MPIDR is guaranteed to be unique
stable, and identifies a given (v)CPU.

As for the PMU: either 1) we instantiate it together with the CPU
(with a new capability/feature), or 2) we map it to a MPIDR, and
associate it with its vcpu at runtime.

I'm slightly in favor of 1), as it simplifies things a bit, but 2) is
doable as well (GICv3 has similar requirements).

	M.
-- 
Jazz is not dead. It just smells funny.
