Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC06C47095
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 08:56:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14FC661183
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 08:56:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14FC661183
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB8844086D;
	Wed,  9 Jun 2021 04:56:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RmFDN2O216DO; Wed,  9 Jun 2021 04:56:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 619F4402A9;
	Wed,  9 Jun 2021 04:56:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 604984024F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 04:56:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GaQf7lTVVnd9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 04:56:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D76C40294
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 04:56:53 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE86D1396;
 Wed,  9 Jun 2021 01:56:52 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28BAF3F792;
 Wed,  9 Jun 2021 01:56:50 -0700 (PDT)
Subject: Re: [PATCH v14 8/8] KVM: arm64: Document MTE capability and ioctl
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20210607110816.25762-1-steven.price@arm.com>
 <20210607110816.25762-9-steven.price@arm.com>
 <20210607173213.GC17957@arm.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <48353256-a6ef-e075-6784-fa0bc81a7587@arm.com>
Date: Wed, 9 Jun 2021 09:56:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210607173213.GC17957@arm.com>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
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

On 07/06/2021 18:32, Catalin Marinas wrote:
> On Mon, Jun 07, 2021 at 12:08:16PM +0100, Steven Price wrote:
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 22d077562149..fc6f0cbc30b3 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -5034,6 +5034,42 @@ see KVM_XEN_VCPU_SET_ATTR above.
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
>> +:Returns: number of bytes copied, < 0 on error
> 
> I guess you can be a bit more specific here, -EINVAL on incorrect
> arguments, -EFAULT if the guest memory cannot be accessed.

Sure. Note that -EFAULT can also be returned if the VMM's memory cannot
be accessed (the other end of the copy).

>> +
>> +::
>> +
>> +  struct kvm_arm_copy_mte_tags {
>> +	__u64 guest_ipa;
>> +	__u64 length;
>> +	void __user *addr;
>> +	__u64 flags;
>> +	__u64 reserved[2];
>> +  };
>> +
>> +Copies Memory Tagging Extension (MTE) tags to/from guest tag memory. The
>> +``guest_ipa`` and ``length`` fields must be ``PAGE_SIZE`` aligned. The ``addr``
>> +fieldmust point to a buffer which the tags will be copied to or from.
> 
> s/fieldmust/field must/

Thanks - Vim's spell checker missed that apparently because it's syntax
highlighter got confused.

>> +
>> +``flags`` specifies the direction of copy, either ``KVM_ARM_TAGS_TO_GUEST`` or
>> +``KVM_ARM_TAGS_FROM_GUEST``.
>> +
>> +The size of the buffer to store the tags is ``(length / 16)`` bytes
>> +(granules in MTE are 16 bytes long). Each byte contains a single tag
>> +value. This matches the format of ``PTRACE_PEEKMTETAGS`` and
>> +``PTRACE_POKEMTETAGS``.
> 
> One difference I think with ptrace() is that iov_len (length here) is
> the actual buffer size. But for kvm I think this works better since
> length is tied to the guest_ipa.

What I intended to say is that the storage in memory patches ptrace (one
byte per tag). In the kernel (e.g. for swap) we store it more compactly
(two tags per byte). As you say I think having 'length' match
'guest_ipa' is sensible rather than deducing it from the buffer size.

>> +
>> +If an error occurs before any data is copied then a negative error code is
>> +returned. If some tags have been copied before an error occurs then the number
>> +of bytes successfully copied is returned. If the call completes successfully
>> +then ``length`` is returned.
>> +
>>  5. The kvm_run structure
>>  ========================
>>  
>> @@ -6362,6 +6398,27 @@ default.
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
>> +VMM before creating any VCPUs to allow the guest access. Note that MTE is only
>> +available to a guest running in AArch64 mode and enabling this capability will
>> +cause attempts to create AArch32 VCPUs to fail.
>> +
>> +When enabled the guest is able to access tags associated with any memory given
>> +to the guest. KVM will ensure that the pages are flagged ``PG_mte_tagged`` so
>> +that the tags are maintained during swap or hibernation of the host; however
> 
> I'd drop PG_mte_tagged here, that's just how the implementation handles
> it, not necessary for describing the API. You can just say "KVM will
> ensure that the tags are maintained during swap or hibernation of the
> host"

Good point - will update with your wording.

>> +the VMM needs to manually save/restore the tags as appropriate if the VM is
>> +migrated.
>> +
>> +When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
>> +perform a bulk copy of tags to/from the guest.
>> +
>>  8. Other capabilities.
>>  ======================
>>  
>> -- 
>> 2.20.1
> 
> Otherwise, feel free to add:
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 

Thanks!

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
