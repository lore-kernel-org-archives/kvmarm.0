From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 00/12] KVM: arm/arm64: move VGIC MMIO to kvm_io_bus
Date: Tue, 24 Mar 2015 10:10:47 +0000
Message-ID: <55113827.60708@arm.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
 <CADDJ2=NVaAwuE9LZj5Uhjo=JEHKsf_CYxs391Pk4+6SNJcH8+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BDCE4987F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Mar 2015 06:04:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dp00FVdPZY0i for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Mar 2015 06:03:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AC7049882
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Mar 2015 06:03:58 -0400 (EDT)
In-Reply-To: <CADDJ2=NVaAwuE9LZj5Uhjo=JEHKsf_CYxs391Pk4+6SNJcH8+A@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>, Andre Przywara <Andre.Przywara@arm.com>
Cc: VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>, list@foss.arm.com, ARM PORT <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, moderated@foss.arm.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/03/15 21:50, Nikolay Nikolaev wrote:
> On Mon, Mar 23, 2015 at 5:58 PM, Andre Przywara <andre.przywara@arm.com> wrote:
>> This series converts the VGIC MMIO handling routines to the generic
>> kvm_io_bus framework. The framework is needed for the ioeventfd
>> functionality, some people on the list wanted to see the VGIC
>> converted over to use it, too.
>> Beside from now moving to a generic framework instead of relying on
>> an ARM specific one we also clean up quite some code and get rid of
>> some unnecessary copying.
>> On that way the MMIO abort handling for ARM has changed quite a bit,
>> so please have a closer look and test it on your setup if possible.
>>
>> Based on the v1 review I addressed Christoffer's minor comments, but
>> also heavily changed [11/12]: "KVM: ARM: on IO mem abort - route the
>> call to KVM MMIO bus" to get rid of the now unnecessary copying and
>> the usage of kvm_exit_mmio in that early stage. See the respective
>> commit message for more details.
>>
>> The series is loosely based on Nikolay's work[1], thanks especially
>> for the tedious first patch.
>> I totally reworked Nikolay's 3/5 to avoid adding another MMIO handling
>> layer on top of the already quite convoluted VGIC MMIO handling.
>> Also Nikolay's 2/5 get extended and changed significantly, that's why
>> I dropped his Signed-off-by.
>>
>> Unfortunately kvm_io_bus lacks an opaque pointer to pass in some data,
>> so I worked around this by using container_of.
>> Now for every struct kvm_mmio_range array a KVM I/O device is
>> registered (one for VGICv2, 2*nr_vcpus + 1 for VGICv3), using the
>> struct kvm_io_device variable as an anchor into the new
>> struct vgic_io_device. This one holds the base address, the
>> vgic_io_range pointer and (in case of the GICv3 redistributor) the
>> associated vCPU, so that we can access all instance-specific data
>> easily.
>>
>> Patch 2 moves the iodev.h header file around, that solves a problem
>> when embedding a struct in arm_vgic.h later. That looks like a nice
>> cleanup anyway, so I added two patches to remove the compiler switch
>> to add virt/kvm as a include directory. This has been tested for
>> arm/arm64 and x86. As soon as I get around to compile-test the other
>> architectures, I can send out the respective patches for those, too.
>>
>> Patches 5-7 tweak the existing code a bit to make it fit for the
>> conversion.
>> Patch 8 contains the framework for the new handling, while
>> patch 9 and 10 enable the GICv2 and GICv3 emulation, respectively.
>> Patch 11 finally switches over to the new kvm_io_bus handling,
>> reworking the early ARM KVM MMIO handling quite a bit. Patch 12
>> removes the now unneeded code. I split this up to ease reviewing, I
>> could merge patches as well if needed.
> 
> Shall we add here also the last 2 patches from my series that actually enable
> the eventfd compilation and KVM_CAP_IOEVENTFD? Or should I send them separately?

I think that this is the goal, so please send them as a follow-up to
this series.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
