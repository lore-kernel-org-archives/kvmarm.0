From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Thu, 7 Jan 2016 21:36:47 +0100
Message-ID: <20160107203647.GJ6199@hawk.localdomain>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
 <CAFEAcA_MDiOphseZ7RGNE3G=4ZDF5SFV5krOjanPbVuhgg9gnQ@mail.gmail.com>
 <568E7AF1.9040103@huawei.com>
 <CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Shannon Zhao <zhaoshenglong@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvm-devel <kvm@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 07, 2016 at 02:56:15PM +0000, Peter Maydell wrote:
> On 7 January 2016 at 14:49, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> >>> +
> >>> +Groups:
> >>> +  KVM_DEV_ARM_PMU_GRP_IRQ
> >>> +  Attributes:
> >>> +    The attr field of kvm_device_attr encodes one value:
> >>> +    bits:     | 63 .... 32 | 31 ....  0 |
> >>> +    values:   |  reserved  | vcpu_index |
> >>> +    A value describing the PMU overflow interrupt number for the specified
> >>> +    vcpu_index vcpu. This interrupt could be a PPI or SPI, but for one VM the
> >>> +    interrupt type must be same for each vcpu. As a PPI, the interrupt number is
> >>> +    same for all vcpus, while as a SPI it must be different for each vcpu.
> >>
> >> I see we're using vcpu_index rather than MPIDR affinity value
> >> for specifying which CPU we're configuring. Is this in line with
> >> our planned API for GICv3 configuration?
> >>
> > Here vcpu_index is used to indexing the vCPU, no special use.
> 
> Yes, but you can identify the CPU by index, or by its MPIDR.
> We had a discussion about which was the best way for doing
> the VGIC API, and I can't remember which way round we ended up
> going for. Whichever we chose, we should do the same thing here.

I think we should start up a new discussion on this. My understanding,
after a chat with Igor, who was involved in the untangling of vcpu-id and
apic-id for x86, is that using vcpu-id is preferred, unless of course
the device expects an apic-id/mpidr, in which case there's no reason to
translate it on both sides.

Other things to discuss are
1) Consistent use of the term vcpu-id vs. vcpu-index in the documentation.
   I just brought that up in my last reply to this patch.
2) Extending a vcpu-index [id] beyond 8-bits.
3) Should vcpu-ids be reusable after hotunplugging them?
4) Devices like this pmu and the vgic have some global (all vcpus wide)
   properties, but then also vcpu specific registers, which require the
   vcpu-index parameter. Should we instead create a "vcpu device ioctl"
   for these? I.e. extend SET/GET_DEVICE_ATTR to also be of type
   'vcpu ioctl', allowing the vcpu-index parameter to be dropped?

Thanks,
drew
