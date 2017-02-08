From: Linu Cherian <linucherian@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Increase number of memslots to 512
Date: Wed, 8 Feb 2017 07:27:57 +0530
Message-ID: <CAGOz-0ZCAcGembZCYcD1CGHvSUr+CDkicKRUGjM0d9Qz7Y+Mjg@mail.gmail.com>
References: <1484153537-20984-1-git-send-email-linucherian@gmail.com>
 <fd707698-ba58-f3cb-f0c5-6a4507585bd7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C609340783
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Feb 2017 20:57:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OhP6WxGPGR9t for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Feb 2017 20:57:25 -0500 (EST)
Received: from mail-yw0-f193.google.com (mail-yw0-f193.google.com
 [209.85.161.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC87C40284
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Feb 2017 20:57:25 -0500 (EST)
Received: by mail-yw0-f193.google.com with SMTP id q71so10819510ywg.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Feb 2017 17:57:58 -0800 (PST)
In-Reply-To: <fd707698-ba58-f3cb-f0c5-6a4507585bd7@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: sunil.goutham@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Linu Cherian <linu.cherian@cavium.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 7, 2017 at 3:46 PM, Auger Eric <eric.auger@redhat.com> wrote:
> Hi Linu,
>
> On 11/01/2017 17:52, linucherian@gmail.com wrote:
>> From: Linu Cherian <linu.cherian@cavium.com>
>>
>> Having only 32 memslots is a real constraint for the maximum number of
>> PCI devices that can be assigned to a single guest. Assuming each PCI
>> device/virtual function having two memory BAR regions, we could assign
>> only 15 devices/virtual functions to a guest.
>>
>> So increase KVM_MEM_SLOTS_NUM to 512 as done in other archs like x86 and
>> powerpc. For this, KVM_USER_MEM_SLOTS has been changed to 508.
>>
>> Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
>
>> ---
>>  arch/arm/kvm/arm.c                | 3 +++
>>  arch/arm64/include/asm/kvm_host.h | 2 +-
>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 8f92efa..a19389b 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -221,6 +221,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>       case KVM_CAP_MAX_VCPUS:
>>               r = KVM_MAX_VCPUS;
>>               break;
>> +     case KVM_CAP_NR_MEMSLOTS:
>> +             r = KVM_USER_MEM_SLOTS;
>> +             break;
> This change is not documented in the commit message and I think it
> should since we now allow KVM/ARM to report the number of available user
> mem slots. I would personally suggest to put it in a sepate patch as it
> was done on s390 for instance
> (http://marc.info/?l=linux-s390&m=136422861316920&w=2)
>

Thanks for reviewing. Will send out another version with this fixed.
