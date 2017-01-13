From: Linu Cherian <linucherian@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Increase number of memslots to 512
Date: Fri, 13 Jan 2017 22:55:43 +0530
Message-ID: <CAGOz-0aD-hV7sDAX70pSGdCj1J4s4xc4qQBwbaKzVZArfRK2AQ@mail.gmail.com>
References: <1484153537-20984-1-git-send-email-linucherian@gmail.com>
 <61fa02f8-b244-6bae-eaa1-cb745ea543e1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E16A94068E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 12:23:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hlMnTMcGi+gM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jan 2017 12:23:57 -0500 (EST)
Received: from mail-yw0-f196.google.com (mail-yw0-f196.google.com
 [209.85.161.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11EB640284
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 12:23:56 -0500 (EST)
Received: by mail-yw0-f196.google.com with SMTP id l75so4167845ywb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 09:25:44 -0800 (PST)
In-Reply-To: <61fa02f8-b244-6bae-eaa1-cb745ea543e1@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: sunil.goutham@cavium.com, Linu Cherian <linu.cherian@cavium.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 13, 2017 at 5:33 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Hi Linu,
>
> On 11/01/17 16:52, linucherian@gmail.com wrote:
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
>>       case KVM_CAP_MSI_DEVID:
>>               if (!kvm)
>>                       r = -EINVAL;
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index e505038..88f017d 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -30,7 +30,7 @@
>>
>>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>>
>> -#define KVM_USER_MEM_SLOTS 32
>> +#define KVM_USER_MEM_SLOTS 508
>>  #define KVM_PRIVATE_MEM_SLOTS 4
>>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>>  #define KVM_HALT_POLL_NS_DEFAULT 500000
>>
>
> I'm not opposed to that patch, but if I may ask: how has that been tested?
>

I have tested this on Cavium ARM64 SOC, by assigning multiple
VFs(virtual functions) of a SRIOV device to a single VM. Each VF has
two memory regions(two BARs) implemented.

Without, this change, when the number of virtual functions assigned to
the guest crosses 15, qemu aborts with
"kvm_alloc_slot: no free slot available", during guest kernel booting.

Now, with this change guest kernel boots fine with more than 15 VFs
assigned(tested upto 29) and also all the PCI VFs assigned to the guest
get listed under lspci with memory resources configured.

Please let me know if you are looking for more specifics like bootlogs etc.
