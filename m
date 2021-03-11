Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F93C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 12:34:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D991864FE6
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 12:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D991864FE6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ECC14B68F;
	Thu, 11 Mar 2021 07:34:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cILgUmNPOqAf; Thu, 11 Mar 2021 07:34:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A84154B672;
	Thu, 11 Mar 2021 07:34:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9DC04B656
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 07:34:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xtsm9TTLN1TM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 07:34:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A29A4B615
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 07:34:36 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9572AED1;
 Thu, 11 Mar 2021 04:34:35 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 074673F793;
 Thu, 11 Mar 2021 04:34:32 -0800 (PST)
Subject: Re: [PATCH v9 6/6] KVM: arm64: Document MTE capability and ioctl
To: Peter Maydell <peter.maydell@linaro.org>
References: <20210301142315.30920-1-steven.price@arm.com>
 <20210301142315.30920-7-steven.price@arm.com>
 <CAFEAcA8pkvWeGV19QEaZx+pENDpUTO3=p-euPjkjeiU8OGtZzw@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <1ea52603-2e99-1e81-92b3-0e14cf1e2d1e@arm.com>
Date: Thu, 11 Mar 2021 12:35:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA8pkvWeGV19QEaZx+pENDpUTO3=p-euPjkjeiU8OGtZzw@mail.gmail.com>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Dave Martin <Dave.Martin@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/03/2021 11:01, Peter Maydell wrote:
> On Mon, 1 Mar 2021 at 14:23, Steven Price <steven.price@arm.com> wrote:
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
>>   Documentation/virt/kvm/api.rst | 37 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 37 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index aed52b0fc16e..1406ea138127 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -4939,6 +4939,23 @@ KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
>>   Allows Xen vCPU attributes to be read. For the structure and types,
>>   see KVM_XEN_VCPU_SET_ATTR above.
>>
>> +4.131 KVM_ARM_MTE_COPY_TAGS
>> +---------------------------
>> +
>> +:Capability: KVM_CAP_ARM_MTE
>> +:Architectures: arm64
>> +:Type: vm ioctl
>> +:Parameters: struct kvm_arm_copy_mte_tags
>> +:Returns: 0 on success, < 0 on error
>> +
>> +Copies Memory Tagging Extension (MTE) tags to/from guest tag memory.
> 
> Mostly virt/kvm/api.rst seems to include documentation of the
> associated structs, something like:
> 
> ::
> 
>    struct kvm_arm_copy_mte_tags {
>           __u64 guest_ipa;
>           __u64 length;
>           union {
>                   void __user *addr;
>                   __u64 padding;
>           };
>           __u64 flags;
>    };
> 
> 
> which saves the reader having to cross-reference against the header file.

Good point - I'll add that.

> It also means you can more naturally use the actual field names in the doc,
> eg:
> 
>> +The
>> +starting address and length of guest memory must be ``PAGE_SIZE`` aligned.
> 
> you could say "The guest_ipa and length fields" here.
> 
> Also "The addr field must point to a buffer which the tags will
> be copied to or from." I assume.

Indeed - I'll add the clarification.

>> +The size of the buffer to store the tags is ``(length / MTE_GRANULE_SIZE)``
>> +bytes (i.e. 1/16th of the corresponding size).
> 
>> + Each byte contains a single tag
>> +value. This matches the format of ``PTRACE_PEEKMTETAGS`` and
>> +``PTRACE_POKEMTETAGS``.
> 
> What are the valid values for 'flags' ? It looks like they specify which
> direction the copy is, which we definitely need to document here.

Yes either KVM_ARM_TAGS_TO_GUEST or KVM_ARM_TAGS_FROM_GUEST - again I'll 
clarify that.

> What happens if the caller requests a tag copy for an area of guest
> address space which doesn't have tags (eg it has nothing mapped),
> or for an area of guest addres space which has tags in some parts
> but not in others ?

Guest memory either exists (and has tags) or doesn't exist (assuming MTE 
is enabled for the guest). So the cases this can fail are:

  * The region isn't completely covered with memslots
  * The region isn't completely writable (and KVM_ARM_TAGS_TO_GUEST is 
specified).
  * User space doesn't have access to the memory (i.e. the memory would 
SIGSEGV or similar if the VMM accessed it).

Currently all the above produce the error -ENOENT, which now I come to 
enumerate the cases doesn't seem like a great error code (it's really 
only appropriate for the first)! Perhaps -EFAULT would be better.

>> +
>>   5. The kvm_run structure
>>   ========================
>>
>> @@ -6227,6 +6244,25 @@ KVM_RUN_BUS_LOCK flag is used to distinguish between them.
>>   This capability can be used to check / enable 2nd DAWR feature provided
>>   by POWER10 processor.
>>
>> +7.23 KVM_CAP_ARM_MTE
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
>> +that the tags are maintained during swap or hibernation of the host, however
> 
> s/,/;/

Yep

>> +the VMM needs to manually save/restore the tags as appropriate if the VM is
>> +migrated.
>> +
>> +When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
>> +perform a bulk copy of tags to/from the guest
> 
> "guest."

Good spot.

>> +
>>   8. Other capabilities.
>>   ======================
>>
>> @@ -6716,3 +6752,4 @@ KVM_XEN_HVM_SET_ATTR, KVM_XEN_HVM_GET_ATTR, KVM_XEN_VCPU_SET_ATTR and
>>   KVM_XEN_VCPU_GET_ATTR ioctls, as well as the delivery of exception vectors
>>   for event channel upcalls when the evtchn_upcall_pending field of a vcpu's
>>   vcpu_info is set.
>> +
>> --
>> 2.20.1
> 
> 
> Stray whitespace change ?

Not sure how that got there - but will remove.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
