Return-Path: <SRS0=VgM6=WY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FECBC3A5A6
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 13:49:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 09DC022CF5
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 13:49:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09DC022CF5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C6024A584;
	Wed, 28 Aug 2019 09:49:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y6oBaU1RO3aw; Wed, 28 Aug 2019 09:49:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CC204A557;
	Wed, 28 Aug 2019 09:49:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 602074A552
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 09:49:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bjBMg2tFVbXj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Aug 2019 09:49:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDF0A4A4EE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 09:49:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F43828;
 Wed, 28 Aug 2019 06:49:02 -0700 (PDT)
Received: from localhost (c02w217fhv2r.copenhagen.arm.com [10.32.148.24])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1DA13F246;
 Wed, 28 Aug 2019 06:49:01 -0700 (PDT)
Date: Wed, 28 Aug 2019 15:49:00 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 01/10] KVM: arm64: Document PV-time interface
Message-ID: <20190828134900.GA2113@lvm>
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-2-steven.price@arm.com>
 <20190827085706.GB6541@e113682-lin.lund.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190827085706.GB6541@e113682-lin.lund.arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Aug 27, 2019 at 10:57:06AM +0200, Christoffer Dall wrote:
> On Wed, Aug 21, 2019 at 04:36:47PM +0100, Steven Price wrote:
> > Introduce a paravirtualization interface for KVM/arm64 based on the
> > "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
> > 
> > This only adds the details about "Stolen Time" as the details of "Live
> > Physical Time" have not been fully agreed.
> > 
> > User space can specify a reserved area of memory for the guest and
> > inform KVM to populate the memory with information on time that the host
> > kernel has stolen from the guest.
> > 
> > A hypercall interface is provided for the guest to interrogate the
> > hypervisor's support for this interface and the location of the shared
> > memory structures.
> > 
> > Signed-off-by: Steven Price <steven.price@arm.com>
> > ---
> >  Documentation/virt/kvm/arm/pvtime.txt | 100 ++++++++++++++++++++++++++
> >  1 file changed, 100 insertions(+)
> >  create mode 100644 Documentation/virt/kvm/arm/pvtime.txt
> > 
> > diff --git a/Documentation/virt/kvm/arm/pvtime.txt b/Documentation/virt/kvm/arm/pvtime.txt
> > new file mode 100644
> > index 000000000000..1ceb118694e7
> > --- /dev/null
> > +++ b/Documentation/virt/kvm/arm/pvtime.txt
> > @@ -0,0 +1,100 @@
> > +Paravirtualized time support for arm64
> > +======================================
> > +
> > +Arm specification DEN0057/A defined a standard for paravirtualised time
> > +support for AArch64 guests:
> > +
> > +https://developer.arm.com/docs/den0057/a
> > +
> > +KVM/arm64 implements the stolen time part of this specification by providing
> > +some hypervisor service calls to support a paravirtualized guest obtaining a
> > +view of the amount of time stolen from its execution.
> > +
> > +Two new SMCCC compatible hypercalls are defined:
> > +
> > +PV_FEATURES 0xC5000020
> > +PV_TIME_ST  0xC5000022
> > +
> > +These are only available in the SMC64/HVC64 calling convention as
> > +paravirtualized time is not available to 32 bit Arm guests. The existence of
> > +the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
> > +mechanism before calling it.
> > +
> > +PV_FEATURES
> > +    Function ID:  (uint32)  : 0xC5000020
> > +    PV_func_id:   (uint32)  : Either PV_TIME_LPT or PV_TIME_ST
> > +    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
> > +                              PV-time feature is supported by the hypervisor.
> > +
> > +PV_TIME_ST
> > +    Function ID:  (uint32)  : 0xC5000022
> > +    Return value: (int64)   : IPA of the stolen time data structure for this
> > +                              (V)CPU. On failure:
> > +                              NOT_SUPPORTED (-1)
> > +
> > +The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
> > +with inner and outer write back caching attributes, in the inner shareable
> > +domain. A total of 16 bytes from the IPA returned are guaranteed to be
> > +meaningfully filled by the hypervisor (see structure below).
> > +
> > +PV_TIME_ST returns the structure for the calling VCPU.
> > +
> > +Stolen Time
> > +-----------
> > +
> > +The structure pointed to by the PV_TIME_ST hypercall is as follows:
> > +
> > +  Field       | Byte Length | Byte Offset | Description
> > +  ----------- | ----------- | ----------- | --------------------------
> > +  Revision    |      4      |      0      | Must be 0 for version 0.1
> > +  Attributes  |      4      |      4      | Must be 0
> > +  Stolen time |      8      |      8      | Stolen time in unsigned
> > +              |             |             | nanoseconds indicating how
> > +              |             |             | much time this VCPU thread
> > +              |             |             | was involuntarily not
> > +              |             |             | running on a physical CPU.
> > +
> > +The structure will be updated by the hypervisor prior to scheduling a VCPU. It
> > +will be present within a reserved region of the normal memory given to the
> > +guest. The guest should not attempt to write into this memory. There is a
> > +structure per VCPU of the guest.
> > +
> > +User space interface
> > +====================
> > +
> > +User space can request that KVM provide the paravirtualized time interface to
> > +a guest by creating a KVM_DEV_TYPE_ARM_PV_TIME device, for example:
> > +
> > +    struct kvm_create_device pvtime_device = {
> > +            .type = KVM_DEV_TYPE_ARM_PV_TIME,
> > +            .attr = 0,
> > +            .flags = 0,
> > +    };
> > +
> > +    pvtime_fd = ioctl(vm_fd, KVM_CREATE_DEVICE, &pvtime_device);
> > +
> > +Creation of the device should be done after creating the vCPUs of the virtual
> > +machine.
> > +
> > +The IPA of the structures must be given to KVM. This is the base address
> > +of an array of stolen time structures (one for each VCPU). The base address
> > +must be page aligned. The size must be at least 64 * number of VCPUs and be a
> > +multiple of PAGE_SIZE.
> > +
> > +The memory for these structures should be added to the guest in the usual
> > +manner (e.g. using KVM_SET_USER_MEMORY_REGION).
> > +
> > +For example:
> > +
> > +    struct kvm_dev_arm_st_region region = {
> > +            .gpa = <IPA of guest base address>,
> > +            .size = <size in bytes>
> > +    };
> 
> This feel fragile; how are you handling userspace creating VCPUs after
> setting this up, the GPA overlapping guest memory, etc.  Is the
> philosophy here that the VMM can mess up the VM if it wants, but that
> this should never lead attacks on the host (we better hope not) and so
> we don't care?
> 
> It seems to me setting the IPA per vcpu throught the VCPU device would
> avoid a lot of these issues.  See
> Documentation/virt/kvm/devices/vcpu.txt.
> 
> 
I discussed this with Marc the other day, and we realized that if we
make the configuration of the IPA per-PE, then a VMM can construct a VM
where these data structures are distributed within the IPA space of a
VM, which could lead to a lower TLB pressure for some
configurations/workloads.

Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
