Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3A9C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 10:52:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C60BD611C2
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 10:52:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C60BD611C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 556B24B6B7;
	Thu, 20 May 2021 06:52:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5PGLZ4TDDOm6; Thu, 20 May 2021 06:52:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8389C4B4F2;
	Thu, 20 May 2021 06:52:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C5C44B47D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 06:52:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FU63tmVHcmZg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 06:52:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A0A64B45C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 06:52:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0EDCD150C;
 Thu, 20 May 2021 03:52:16 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C18FE3F719;
 Thu, 20 May 2021 03:52:12 -0700 (PDT)
Subject: Re: [PATCH v12 8/8] KVM: arm64: Document MTE capability and ioctl
To: Marc Zyngier <maz@kernel.org>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-9-steven.price@arm.com> <87r1i5teou.wl-maz@kernel.org>
 <3b4cca00-e81d-322e-6f65-4d0850aac5a5@arm.com> <871ra1vh2s.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <3e9f2388-89fe-f762-8e59-03f4d70320fc@arm.com>
Date: Thu, 20 May 2021 11:52:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <871ra1vh2s.wl-maz@kernel.org>
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

On 20/05/2021 11:24, Marc Zyngier wrote:
> On Wed, 19 May 2021 15:09:23 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> On 17/05/2021 19:09, Marc Zyngier wrote:
>>> On Mon, 17 May 2021 13:32:39 +0100,
>>> Steven Price <steven.price@arm.com> wrote:
[...]>>>> +bytes (i.e. 1/16th of the corresponding size). Each byte
contains a single tag
>>>> +value. This matches the format of ``PTRACE_PEEKMTETAGS`` and
>>>> +``PTRACE_POKEMTETAGS``.
>>>> +
>>>>  5. The kvm_run structure
>>>>  ========================
>>>>  
>>>> @@ -6362,6 +6396,25 @@ default.
>>>>  
>>>>  See Documentation/x86/sgx/2.Kernel-internals.rst for more details.
>>>>  
>>>> +7.26 KVM_CAP_ARM_MTE
>>>> +--------------------
>>>> +
>>>> +:Architectures: arm64
>>>> +:Parameters: none
>>>> +
>>>> +This capability indicates that KVM (and the hardware) supports exposing the
>>>> +Memory Tagging Extensions (MTE) to the guest. It must also be enabled by the
>>>> +VMM before the guest will be granted access.
>>>> +
>>>> +When enabled the guest is able to access tags associated with any memory given
>>>> +to the guest. KVM will ensure that the pages are flagged ``PG_mte_tagged`` so
>>>> +that the tags are maintained during swap or hibernation of the host; however
>>>> +the VMM needs to manually save/restore the tags as appropriate if the VM is
>>>> +migrated.
>>>> +
>>>> +When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
>>>> +perform a bulk copy of tags to/from the guest.
>>>> +
>>>
>>> Missing limitation to AArch64 guests.
>>
>> As mentioned previously it's not technically limited to AArch64, but
>> I'll expand this to make it clear that MTE isn't usable from a AArch32 VCPU.
> 
> I believe the architecture is quite clear that it *is* limited to
> AArch64. The clarification is welcome though.

I explained that badly. A system supporting MTE doesn't have to have all
CPUs running AArch64 - fairly obviously you can boot a 32 bit OS on a
system supporting AArch64.

Since the KVM capability is a VM capability it's not architecturally
inconsistent to enable it even if all your CPUs are running AArch32 (at
EL1 and lower) - just a bit pointless.

However, given your comment that a mixture of AArch32/AArch64 VCPUs is a
bug - we can fail creation of AArch32 VCPUs and I'll explicitly document
this is a AArch64 only feature.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
