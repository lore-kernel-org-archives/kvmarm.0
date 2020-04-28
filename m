Return-Path: <SRS0=hKGY=6M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B2AC83000
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 09:08:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1205B206D9
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 09:08:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1205B206D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BCC34B238;
	Tue, 28 Apr 2020 05:08:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dh-TfWTpe07A; Tue, 28 Apr 2020 05:08:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64F204B247;
	Tue, 28 Apr 2020 05:08:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE5084B217
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 05:08:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J0S8rg7xd0LU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2020 05:08:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A36C14B20E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 05:08:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A83B30E;
 Tue, 28 Apr 2020 02:08:55 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A8743F305;
 Tue, 28 Apr 2020 02:08:53 -0700 (PDT)
Subject: Re: [PATCH][kvmtool] kvm: Request VM specific limits instead of
 system-wide ones
To: Marc Zyngier <maz@kernel.org>
References: <20200427141738.285217-1-maz@kernel.org>
 <d27e4a14-34b8-7f3d-1e58-ef2ae13e443b@arm.com>
 <7ac17890-72d1-1c81-e513-5d4f7841ca9d@arm.com> <20200427183331.48f411f5@why>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9305b65b-8431-e609-6756-07f1960ff95e@arm.com>
Date: Tue, 28 Apr 2020 10:09:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427183331.48f411f5@why>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
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

Hi,

On 4/27/20 6:33 PM, Marc Zyngier wrote:
> On Mon, 27 Apr 2020 16:00:58 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
>> Hi,
>>
>> On 4/27/20 3:44 PM, Alexandru Elisei wrote:
>>> Hi,
>>>
>>> On 4/27/20 3:17 PM, Marc Zyngier wrote:  
>>>> On arm64, the maximum number of vcpus is constrained by the type
>>>> of interrupt controller that has been selected (GICv2 imposes a
>>>> limit of 8 vcpus, while GICv3 currently has a limit of 512).
>>>>
>>>> It is thus important to request this limit on the VM file descriptor
>>>> rather than on the one that corresponds to /dev/kvm, as the latter
>>>> is likely to return something that doesn't take the constraints into
>>>> account.
>>>>
>>>> Reported-by: Ard Biesheuvel <ardb@kernel.org>
>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>> ---
>>>>  kvm.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/kvm.c b/kvm.c
>>>> index e327541..3d5173d 100644
>>>> --- a/kvm.c
>>>> +++ b/kvm.c
>>>> @@ -406,7 +406,7 @@ int kvm__recommended_cpus(struct kvm *kvm)
>>>>  {
>>>>  	int ret;
>>>>  
>>>> -	ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION, KVM_CAP_NR_VCPUS);
>>>> +	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_NR_VCPUS);
>>>>  	if (ret <= 0)
>>>>  		/*
>>>>  		 * api.txt states that if KVM_CAP_NR_VCPUS does not exist,
>>>> @@ -421,7 +421,7 @@ int kvm__max_cpus(struct kvm *kvm)
>>>>  {
>>>>  	int ret;
>>>>  
>>>> -	ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION, KVM_CAP_MAX_VCPUS);
>>>> +	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_MAX_VCPUS);
>>>>  	if (ret <= 0)
>>>>  		ret = kvm__recommended_cpus(kvm);
>>>>    
>>> I've checked that gic__create comes before the call kvm__recommended_capus:
>>> gic__create is in core_init (called via kvm__init->kvm_arch_init), and
>>> kvm__recommended_cpus is in base_init (called via kvm__cpu_init ->
>>> kvm__{recommended,max}_cpus).
>>>
>>> The KVM api documentation states that KVM_CHECK_EXTENSION is available for the vm
>>> fd only if the system capability KVM_CAP_CHECK_EXTENSION_VM is present. kvmtool
>>> already has a function for checking extensions on the vm fd, it's called
>>> kvm__supports_vm_extension. Can we use that instead of doing the ioctl directly on
>>> the vm fd?  
>> Scratch that, kvm__supports_vm_extension returns a bool, not an int.
>> How about we write kvm__check_vm_extension that returns an int, and
>> kvm__supports_vm_extension calls it?
> That, or we just change the return type for kvm__supports_vm_extension,
> and hack the only places that uses it so far (the GIC code) to detect
> the error.

Yep, whatever you prefer.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
