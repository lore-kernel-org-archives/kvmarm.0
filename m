Return-Path: <SRS0=M1+/=KO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74266C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 14:09:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E457D611C2
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 14:09:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E457D611C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 736934B53D;
	Wed, 19 May 2021 10:09:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id enomwU4B4g34; Wed, 19 May 2021 10:09:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FDDD4B522;
	Wed, 19 May 2021 10:09:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C64C24B522
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 10:09:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NBn33KksOWfA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 May 2021 10:09:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D7DA4B4FE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 10:09:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3F6431B;
 Wed, 19 May 2021 07:09:37 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F3503F73B;
 Wed, 19 May 2021 07:09:35 -0700 (PDT)
Subject: Re: [PATCH v12 8/8] KVM: arm64: Document MTE capability and ioctl
To: Marc Zyngier <maz@kernel.org>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-9-steven.price@arm.com> <87r1i5teou.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <3b4cca00-e81d-322e-6f65-4d0850aac5a5@arm.com>
Date: Wed, 19 May 2021 15:09:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87r1i5teou.wl-maz@kernel.org>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 17/05/2021 19:09, Marc Zyngier wrote:
> On Mon, 17 May 2021 13:32:39 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> A new capability (KVM_CAP_ARM_MTE) identifies that the kernel supports
>> granting a guest access to the tags, and provides a mechanism for the
>> VMM to enable it.
>>
>> A new ioctl (KVM_ARM_MTE_COPY_TAGS) provides a simple way for a VMM to
>> access the tags of a guest without having to maintain a PROT_MTE mapping
>> in userspace. The above capability gates access to the ioctl.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  Documentation/virt/kvm/api.rst | 53 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 53 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 22d077562149..a31661b870ba 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -5034,6 +5034,40 @@ see KVM_XEN_VCPU_SET_ATTR above.
>>  The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
>>  with the KVM_XEN_VCPU_GET_ATTR ioctl.
>>  
>> +4.130 KVM_ARM_MTE_COPY_TAGS
>> +---------------------------
>> +
>> +:Capability: KVM_CAP_ARM_MTE
>> +:Architectures: arm64
>> +:Type: vm ioctl
>> +:Parameters: struct kvm_arm_copy_mte_tags
>> +:Returns: 0 on success, < 0 on error
>> +
>> +::
>> +
>> +  struct kvm_arm_copy_mte_tags {
>> +	__u64 guest_ipa;
>> +	__u64 length;
>> +	union {
>> +		void __user *addr;
>> +		__u64 padding;
>> +	};
>> +	__u64 flags;
>> +	__u64 reserved[2];
>> +  };
> 
> This doesn't exactly match the structure in the previous patch :-(.

:( I knew there was a reason I didn't include it in the documentation
for the first 9 versions... I'll fix this up, thanks for spotting it.

>> +
>> +Copies Memory Tagging Extension (MTE) tags to/from guest tag memory. The
>> +``guest_ipa`` and ``length`` fields must be ``PAGE_SIZE`` aligned. The ``addr``
>> +fieldmust point to a buffer which the tags will be copied to or from.
>> +
>> +``flags`` specifies the direction of copy, either ``KVM_ARM_TAGS_TO_GUEST`` or
>> +``KVM_ARM_TAGS_FROM_GUEST``.
>> +
>> +The size of the buffer to store the tags is ``(length / MTE_GRANULE_SIZE)``
> 
> Should we add a UAPI definition for MTE_GRANULE_SIZE?

I wasn't sure whether to export this or not. The ioctl is based around
the existing ptrace interface (PTRACE_{PEEK,POKE}MTETAGS) which doesn't
expose a UAPI definition. Admittedly the documentation there also just
says "16-byte granule" rather than MTE_GRANULE_SIZE.

So I'll just remove the reference to MTE_GRANULE_SIZE in the
documentation unless you feel that we should have a UAPI definition.

>> +bytes (i.e. 1/16th of the corresponding size). Each byte contains a single tag
>> +value. This matches the format of ``PTRACE_PEEKMTETAGS`` and
>> +``PTRACE_POKEMTETAGS``.
>> +
>>  5. The kvm_run structure
>>  ========================
>>  
>> @@ -6362,6 +6396,25 @@ default.
>>  
>>  See Documentation/x86/sgx/2.Kernel-internals.rst for more details.
>>  
>> +7.26 KVM_CAP_ARM_MTE
>> +--------------------
>> +
>> +:Architectures: arm64
>> +:Parameters: none
>> +
>> +This capability indicates that KVM (and the hardware) supports exposing the
>> +Memory Tagging Extensions (MTE) to the guest. It must also be enabled by the
>> +VMM before the guest will be granted access.
>> +
>> +When enabled the guest is able to access tags associated with any memory given
>> +to the guest. KVM will ensure that the pages are flagged ``PG_mte_tagged`` so
>> +that the tags are maintained during swap or hibernation of the host; however
>> +the VMM needs to manually save/restore the tags as appropriate if the VM is
>> +migrated.
>> +
>> +When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
>> +perform a bulk copy of tags to/from the guest.
>> +
> 
> Missing limitation to AArch64 guests.

As mentioned previously it's not technically limited to AArch64, but
I'll expand this to make it clear that MTE isn't usable from a AArch32 VCPU.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
