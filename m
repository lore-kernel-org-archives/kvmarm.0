Return-Path: <SRS0=4dlz=WB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE9BC433FF
	for <kvmarm@archiver.kernel.org>; Mon,  5 Aug 2019 13:06:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14291206C1
	for <kvmarm@archiver.kernel.org>; Mon,  5 Aug 2019 13:06:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14291206C1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7426F4A525;
	Mon,  5 Aug 2019 09:06:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AEErPyKPWSWA; Mon,  5 Aug 2019 09:06:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B471B4A4FC;
	Mon,  5 Aug 2019 09:06:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA7BB4A527
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Aug 2019 09:06:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZTWY++iIZPiD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Aug 2019 09:06:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3A4C4A525
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Aug 2019 09:06:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C0D91597;
 Mon,  5 Aug 2019 06:06:11 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AEB373F706;
 Mon,  5 Aug 2019 06:06:09 -0700 (PDT)
Subject: Re: [PATCH 1/9] KVM: arm64: Document PV-time interface
To: Marc Zyngier <maz@kernel.org>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-2-steven.price@arm.com> <20190803121343.2f482200@why>
From: Steven Price <steven.price@arm.com>
Message-ID: <9b2077d1-29f2-549a-fd61-f9c8d3730c9c@arm.com>
Date: Mon, 5 Aug 2019 14:06:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190803121343.2f482200@why>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 03/08/2019 12:13, Marc Zyngier wrote:
> On Fri,  2 Aug 2019 15:50:09 +0100
> Steven Price <steven.price@arm.com> wrote:
> 
> [+Peter for the userspace aspect of things]
> 
> Hi Steve,
> 
>> Introduce a paravirtualization interface for KVM/arm64 based on the
>> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
>>
>> This only adds the details about "Stolen Time" as the details of "Live
>> Physical Time" have not been fully agreed.
>>
>> User space can specify a reserved area of memory for the guest and
>> inform KVM to populate the memory with information on time that the host
>> kernel has stolen from the guest.
>>
>> A hypercall interface is provided for the guest to interrogate the
>> hypervisor's support for this interface and the location of the shared
>> memory structures.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  Documentation/virtual/kvm/arm/pvtime.txt | 107 +++++++++++++++++++++++
>>  1 file changed, 107 insertions(+)
>>  create mode 100644 Documentation/virtual/kvm/arm/pvtime.txt
>>
>> diff --git a/Documentation/virtual/kvm/arm/pvtime.txt b/Documentation/virtual/kvm/arm/pvtime.txt
>> new file mode 100644
>> index 000000000000..e6ae9799e1d5
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/arm/pvtime.txt
>> @@ -0,0 +1,107 @@
>> +Paravirtualized time support for arm64
>> +======================================
>> +
>> +Arm specification DEN0057/A defined a standard for paravirtualised time
>> +support for Aarch64 guests:
> 
> nit: AArch64
> 
>> +
>> +https://developer.arm.com/docs/den0057/a
> 
> Between this file and the above document, which one is authoritative?

The above document should be authoritative - although I'm still waiting
for the final version to be published. I'm not expecting any changes to
the stolen time part though.

>> +
>> +KVM/Arm64 implements the stolen time part of this specification by providing
> 
> nit: KVM/arm64
> 
>> +some hypervisor service calls to support a paravirtualized guest obtaining a
>> +view of the amount of time stolen from its execution.
>> +
>> +Two new SMCCC compatible hypercalls are defined:
>> +
>> +PV_FEATURES 0xC5000020
>> +PV_TIME_ST  0xC5000022
>> +
>> +These are only available in the SMC64/HVC64 calling convention as
>> +paravirtualized time is not available to 32 bit Arm guests.
>> +
>> +PV_FEATURES
>> +    Function ID:  (uint32)  : 0xC5000020
>> +    PV_func_id:   (uint32)  : Either PV_TIME_LPT or PV_TIME_ST
>> +    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
>> +                              PV-time feature is supported by the hypervisor.
> 
> How is PV_FEATURES discovered? Is the intention to make it a generic
> ARM-wide PV discovery mechanism, not specific to PV time?

SMCCC is mandated for PV time. So, assuming the hypervisor supports
SMCCC, the "NOT_SUPPORTED" return is mandated by SMCCC if PV time isn't
supported.

However, we do also use the SMCCC_ARCH_FEATURES mechanism to check the
existence of PV_FEATURES before use. I'll update the document to call
this out.

>> +
>> +PV_TIME_ST
>> +    Function ID:  (uint32)  : 0xC5000022
>> +    Return value: (int64)   : IPA of the stolen time data structure for this
>> +                              (V)CPU. On failure:
>> +                              NOT_SUPPORTED (-1)
>> +
> 
> Is the size implicit? What are the memory attributes? This either needs
> documenting here, or point to the right bit to the spec.

The size is implicit - it's a pointer to the below structure, so the
guest can only rely on the first 16 bytes being valid. The memory
attributes are described in the specification as:

"The calling guest can map the IPA into normal memory with inner and
outer write back caching attributes, in the inner sharable domain"

I'll put those details in this document for completeness.

>> +Stolen Time
>> +-----------
>> +
>> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
>> +
>> +  Field       | Byte Length | Byte Offset | Description
>> +  ----------- | ----------- | ----------- | --------------------------
>> +  Revision    |      4      |      0      | Must be 0 for version 0.1
>> +  Attributes  |      4      |      4      | Must be 0
>> +  Stolen time |      8      |      8      | Stolen time in unsigned
>> +              |             |             | nanoseconds indicating how
>> +              |             |             | much time this VCPU thread
>> +              |             |             | was involuntarily not
>> +              |             |             | running on a physical CPU.
>> +
>> +The structure will be updated by the hypervisor periodically as time is stolen
> 
> Is it really periodic? If so, when is the update frequency?

Hmm, periodic might be the wrong term - there is no guaranteed frequency
of update. The spec says:

"The hypervisor must update this value prior to scheduling a virtual CPU"

I guess that's probably the best description.

>> +from the VCPU. It will be present within a reserved region of the normal
>> +memory given to the guest. The guest should not attempt to write into this
>> +memory. There is a structure by VCPU of the guest.
> 
> What if the vcpu writes to it? Does it get a fault?

From the perspective from the specification this is undefined. A fault
would therefore be acceptable but isn't generated in the implementation
defined here.

> If there is a
> structure per vcpu, what is the layout in memory? How does a vcpu find
> its own data structure? Is that the address returned by PV_TIME_ST?

A call to PV_TIME_ST returns the structure for the calling vCPU - I'll
make that explicit. The layout is therefore defined by the hypervisor
and cannot be relied on by the guest. As below this implementation uses
a simple array of structures.

>> +
>> +User space interface
>> +====================
>> +
>> +User space can request that KVM provide the paravirtualized time interface to
>> +a guest by creating a KVM_DEV_TYPE_ARM_PV_TIME device, for example:
>> +
>> +    struct kvm_create_device pvtime_device = {
>> +            .type = KVM_DEV_TYPE_ARM_PV_TIME,
>> +            .attr = 0,
>> +            .flags = 0,
>> +    };
>> +
>> +    pvtime_fd = ioctl(vm_fd, KVM_CREATE_DEVICE, &pvtime_device);
>> +
>> +The guest IPA of the structures must be given to KVM. This is the base address
> 
> nit: s/guest //
> 
>> +of an array of stolen time structures (one for each VCPU). For example:
>> +
>> +    struct kvm_device_attr st_base = {
>> +            .group = KVM_DEV_ARM_PV_TIME_PADDR,
>> +            .attr = KVM_DEV_ARM_PV_TIME_ST,
>> +            .addr = (u64)(unsigned long)&st_paddr
>> +    };
>> +
>> +    ioctl(pvtime_fd, KVM_SET_DEVICE_ATTR, &st_base);
> 
> So the allocation itself is performed by the kernel? What are the
> ordering requirements between creating vcpus and the device? What are
> the alignment requirements for the base address?

The base address should be page aligned - I'll spell that out.

There are currently no ordering requirements between creating vcpus and
the device. However...

>> +
>> +For migration (or save/restore) of a guest it is necessary to save the contents
>> +of the shared page(s) and later restore them. KVM_DEV_ARM_PV_TIME_STATE_SIZE
>> +provides the size of this data and KVM_DEV_ARM_PV_TIME_STATE allows the state
>> +to be read/written.
> 
> Is the size variable depending on the number of vcpus?

...yes - so restoring the state after migration must be done after
creating the vcpus. I'll point out that the device should created after.

Thanks for the review,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
