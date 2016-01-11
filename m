From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Mon, 11 Jan 2016 12:52:25 +0100
Message-ID: <20160111115225.GC3924@hawk.localdomain>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
 <CAFEAcA_MDiOphseZ7RGNE3G=4ZDF5SFV5krOjanPbVuhgg9gnQ@mail.gmail.com>
 <568E7AF1.9040103@huawei.com>
 <CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com>
 <20160107203647.GJ6199@hawk.localdomain>
 <20160109122956.GA30867@cbox>
 <20160109150339.10576e81@arm.com>
 <56936B91.301@huawei.com>
 <56936EFA.1000404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56936EFA.1000404@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shannon Zhao <zhaoshenglong@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 11, 2016 at 08:59:38AM +0000, Marc Zyngier wrote:
> On 11/01/16 08:45, Shannon Zhao wrote:
> > 
> > 
> > On 2016/1/9 23:03, Marc Zyngier wrote:
> >> On Sat, 9 Jan 2016 13:29:56 +0100
> >> Christoffer Dall <christoffer.dall@linaro.org> wrote:
> >>
> >>>> On Thu, Jan 07, 2016 at 09:36:47PM +0100, Andrew Jones wrote:
> >>>>>> On Thu, Jan 07, 2016 at 02:56:15PM +0000, Peter Maydell wrote:
> >>>>>>>> On 7 January 2016 at 14:49, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>> +Groups:
> >>>>>>>>>>>>>> +  KVM_DEV_ARM_PMU_GRP_IRQ
> >>>>>>>>>>>>>> +  Attributes:
> >>>>>>>>>>>>>> +    The attr field of kvm_device_attr encodes one value:
> >>>>>>>>>>>>>> +    bits:     | 63 .... 32 | 31 ....  0 |
> >>>>>>>>>>>>>> +    values:   |  reserved  | vcpu_index |
> >>>>>>>>>>>>>> +    A value describing the PMU overflow interrupt number for the specified
> >>>>>>>>>>>>>> +    vcpu_index vcpu. This interrupt could be a PPI or SPI, but for one VM the
> >>>>>>>>>>>>>> +    interrupt type must be same for each vcpu. As a PPI, the interrupt number is
> >>>>>>>>>>>>>> +    same for all vcpus, while as a SPI it must be different for each vcpu.
> >>>>>>>>>>>>
> >>>>>>>>>>>> I see we're using vcpu_index rather than MPIDR affinity value
> >>>>>>>>>>>> for specifying which CPU we're configuring. Is this in line with
> >>>>>>>>>>>> our planned API for GICv3 configuration?
> >>>>>>>>>>>>
> >>>>>>>>>> Here vcpu_index is used to indexing the vCPU, no special use.
> >>>>>>>>
> >>>>>>>> Yes, but you can identify the CPU by index, or by its MPIDR.
> >>>>>>>> We had a discussion about which was the best way for doing
> >>>>>>>> the VGIC API, and I can't remember which way round we ended up
> >>>>>>>> going for. Whichever we chose, we should do the same thing here.
> >>>>>>
> >>>>>> I think we should start up a new discussion on this. My understanding,
> >>>>>> after a chat with Igor, who was involved in the untangling of vcpu-id and
> >>>>>> apic-id for x86, is that using vcpu-id is preferred, unless of course
> >>>>>> the device expects an apic-id/mpidr, in which case there's no reason to
> >>>>>> translate it on both sides.
> >>>>>>
> >>>>
> >>>> I'm fairly strongly convinced that we should use the full 32-bit
> >>>> compressed MPIDR for everything ARM related going forward, as this will
> >>>> cover any case required and leverages and architecturally defined way of
> >>>> uniquely identifying a (v)CPU.
> >> +1.
> >>
> >> vcpu_ids, indexes or any other constructs are just a bunch
> >> of KVM-specific definitions that do not describe the VM from an
> >> architecture PoV. In contrast, the MPIDR is guaranteed to be unique
> >> stable, and identifies a given (v)CPU.
> >>
> >> As for the PMU: either 1) we instantiate it together with the CPU
> >> (with a new capability/feature), 
> > So spare some bits(e.g. 10 bits) of the features array to pass the PMU
> > irq number or add KVM_SET/GET_DEVICE_ATTR for vcpu ioctl?
> 
> Using the device attributes seems more suitable, but I don't know if
> using GET/SET_DEVICE_ATTR without the actual creation of a device is
> acceptable...

There's precedent set by s390 to take only the set/get/has api into a
new context, commit f206165620.

Thanks,
drew
