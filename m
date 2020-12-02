Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 312CCC64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 16:33:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B86120872
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 16:33:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B86120872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6549D4B367;
	Wed,  2 Dec 2020 11:33:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fW6zzXfKIYKq; Wed,  2 Dec 2020 11:33:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 232F14B36D;
	Wed,  2 Dec 2020 11:33:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B4334B36D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 11:33:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gy0vbxBCzGbu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 11:33:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97A0E4B367
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 11:33:47 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E6CF1063;
 Wed,  2 Dec 2020 08:33:47 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D2E83F718;
 Wed,  2 Dec 2020 08:33:45 -0800 (PST)
Subject: Re: [RFC PATCH v3 10/16] KVM: arm64: Add a new VM device control
 group for SPE
To: Haibo Xu <haibo.xu@linaro.org>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
 <20201027172705.15181-11-alexandru.elisei@arm.com>
 <CAJc+Z1HJq_j2wVXBM=0BY7p_A7=1sR+Gdf+edEQ5wZkT6-arfQ@mail.gmail.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <04a896b9-3bc9-f9be-81a4-0eaef37f286f@arm.com>
Date: Wed, 2 Dec 2020 16:35:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAJc+Z1HJq_j2wVXBM=0BY7p_A7=1sR+Gdf+edEQ5wZkT6-arfQ@mail.gmail.com>
Content-Language: en-US
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Haibo,

On 11/5/20 10:10 AM, Haibo Xu wrote:
> On Wed, 28 Oct 2020 at 01:26, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> Stage 2 faults triggered by the profiling buffer attempting to write to
>> memory are reported by the SPE hardware by asserting a buffer management
>> event interrupt. Interrupts are by their nature asynchronous, which means
>> that the guest might have changed its stage 1 translation tables since the
>> attempted write. SPE reports the guest virtual address that caused the data
>> abort, but not the IPA, which means that KVM would have to walk the guest's
>> stage 1 tables to find the IPA; using the AT instruction to walk the
>> guest's tables in hardware is not an option because it doesn't report the
>> IPA in the case of a stage 2 fault on a stage 1 table walk.
>>
>> Fix both problems by pre-mapping the guest's memory at stage 2 with write
>> permissions to avoid any faults. Userspace calls mlock() on the VMAs that
>> back the guest's memory, pinning the pages in memory, then tells KVM to map
>> the memory at stage 2 by using the VM control group KVM_ARM_VM_SPE_CTRL
>> with the attribute KVM_ARM_VM_SPE_FINALIZE. KVM will map all writable VMAs
>> which have the VM_LOCKED flag set. Hugetlb VMAs are practically pinned in
>> memory after they are faulted in and mlock() doesn't set the VM_LOCKED
>> flag, and just faults the pages in; KVM will treat hugetlb VMAs like they
>> have the VM_LOCKED flag and will also map them, faulting them in if
>> necessary, when handling the ioctl.
>>
>> VM live migration relies on a bitmap of dirty pages. This bitmap is created
>> by write-protecting a memslot and updating it as KVM handles stage 2 write
>> faults. Because KVM cannot handle stage 2 faults reported by the profiling
>> buffer, it will not pre-map a logging memslot. This effectively means that
>> profiling is not available when the VM is configured for live migration.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>> [..]
> It seems that the below function is used to de-finalize the spe status
> if I get it correctly.
> How about rename the function to some like "kvm_arm_vcpu_init_spe_definalize()"

I don't have a strong opinion about the name and I'll keep your suggestion in mind
for the next iteration. The series is an RFC and the function might not even be
there in the final version.

>
>> +void kvm_arm_spe_notify_vcpu_init(struct kvm_vcpu *vcpu)
>> +{
>> +       vcpu->kvm->arch.spe.finalized = false;
>> +}
>> +
>>  static bool kvm_arm_vcpu_supports_spe(struct kvm_vcpu *vcpu)
>>  {
>>         if (!vcpu_has_spe(vcpu))
>> @@ -115,6 +122,50 @@ int kvm_arm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>>         return -ENXIO;
>>  }
>>
>> +static int kvm_arm_spe_finalize(struct kvm *kvm)
>> +{
>> +       struct kvm_memory_slot *memslot;
>> +       enum kvm_pgtable_prot prot;
>> +       struct kvm_vcpu *vcpu;
>> +       int i, ret;
>> +
>> +       kvm_for_each_vcpu(i, vcpu, kvm) {
>> +               if (!kvm_arm_spe_vcpu_initialized(vcpu))
>> +                       return -ENXIO;
>> +       }
>> +
>> +       mutex_unlock(&kvm->slots_lock);
> Should be mutex_lock(&kvm->slots_lock);?

Definitely, nicely spotted! That's a typo on my part.

It doesn't affect the test results because kvmtool will call finalize exactly once
after the entire VM has been initialized, so there will be no concurrent accesses
to this function.

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
