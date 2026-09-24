Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F88C30C168
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 01:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790212316; cv=none; b=rnL1idgeMm9YyB0mVXCpC3ij5kW1hSZwanAkK62khJGWpZFV8NNn0oudsE56VI5K0gSSXtsmx466MlvRwE/P2QAJ+dCUeWmNjqSlGW8Efwrap9VL24+xehMdeVX0LhUMnvfEZzozgeA63WhD8uMEpo3AUr5nI7jpOH7gaVxpt8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790212316; c=relaxed/simple;
	bh=Sc+zZHLJMN0HfwUHpJogwnFnq2tXlmaY17KL/jtRoCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ThongXjcgC2VQhoSJ3cF1XBcRl8TFDM9j+E9V0uWdBYpz8sEiqmhLYvv0Fp4U9KGnBdCteaU1/cGbmbKGl7fIShP2IbUvnKKq0FddXXReOwnnt2KOmiICoOOXsKC7E5ibT+5awfqwcW/kAjfAPov5CzjrhM3nd5YnJzm+9GRt5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h6//0jrk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h6//0jrk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790212312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tlRch4dqNbG4JyE54CvXv0yBLQFJZwLvo229WrWsKR8=;
	b=h6//0jrkT6Ve2o2B/+l+pfQD5nZi8/wcf2pkMoQELgXkDty5kXaR4RR7hJKZM3m93X5ELJ
	/5je1AJZe3VRPyO7RR9Ox37T3TT3/gg+qWwBEu3CYQ1excMYxPS9W3TpUGr7P6RhUNBSfx
	DQyCZnL2nJmlG8NvIV+x+YrcoCukxWw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-Ju5Yf0bhPHWr-mMpWJ8Kcw-1; Wed, 23 Sep 2026 21:11:51 -0400
X-MC-Unique: Ju5Yf0bhPHWr-mMpWJ8Kcw-1
X-Mimecast-MFC-AGG-ID: Ju5Yf0bhPHWr-mMpWJ8Kcw_1790212310
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39aee9b4cf2so2326691a91.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 18:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790212310; x=1790817110;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tlRch4dqNbG4JyE54CvXv0yBLQFJZwLvo229WrWsKR8=;
        b=dpU8XgRpr37zNZ8Qv8RHUtXAqAD0X+QK1IvhmuE9YoarT78mL2JhaR09pI1HTkLdXD
         WW3s9sXZ8BP3d1AUoey1egfnfeQAMtzSx1dPCj19aNcrpRu/sqFdeLME3sCD1cuf5x30
         1pHv69hg5VhnDZ6jmX/fbJv4JnAAJsQC8M2d7JTXKr+UO4p/vSj6J2W+d736DY/HbXLR
         +KmjVp9fgcnyhMc3wLdU+U4rA1rSICzNX52Goznru0hmitYgPvCMSdmr6sShWCBAbvFj
         nsAsLQhWWyvJe9XHeSzRhpNZuhvUbws+9Dsj7nXFOk/UUu9SJECdQGl6ufE9d37BHWLi
         tnNw==
X-Forwarded-Encrypted: i=1; AKwUvBzkuWfeopLvREbKWwYZ2/HsgWQFYD43Rycrh/FDcSE8goS5llNAGEe361Hpc/wi/tgs9vg/OH8=@lists.linux.dev
X-Gm-Message-State: AFuF++ncNF7BNLXU6gqXZjI1IdxJk786pVmzx5S2tOz3VSnCwZJN0yyr
	ey62cP7jIZH0A6npimJTo8YLMT6UIYwq23dF2OGLB0yC4yxfAc+3JuZKz93AuZZQM/PvqMJPtLs
	DnRlYhLMxj/Zlw0vAKL77C0DwUesrJutFt4GB4iRNi5iXm+BLl3wvQtvX7w==
X-Gm-Gg: AYBFou29MyjmfjP/WSrKJqEzoH0c4mlms1+IL3XQu082VIQQxe2ATbdP0YgFxjOR8Br
	xDgfjLR8I5ytNc4hKIpx+znE2S0p4zYTRo3cbysvx9v3KOh6lWvDs+IEBAsn7eG7S2rjkuiBkYv
	xKSYh526nNEbtubP+nBDepBzUAHKrv5Tpx83en0FnoSC4vucrLiE4s5qVX+OUksSdZSncg2osBp
	aPOyh5N9G/pH07TdQ5NOPUv10M0x9/NmR8WxVQ+qhooipp95VR0zK+ApnKqKpAPs+kaLo3Z8iYZ
	Jg8ITDEIeeQelG0VRbmBe8GGcZNq5QiruMwI3ExStsYdT/6+agMJ+4Ig+FMRNQRi/SXDN3JlaOa
	+lsPaVpXFC0AOTlBdSN5nFwXK3LVe4a693/VDnNx6PQ==
X-Received: by 2002:a17:90b:39ae:b0:39e:6a7f:1dc6 with SMTP id 98e67ed59e1d1-3a098db9894mr688424a91.34.1790212309773;
        Wed, 23 Sep 2026 18:11:49 -0700 (PDT)
X-Received: by 2002:a17:90b:39ae:b0:39e:6a7f:1dc6 with SMTP id 98e67ed59e1d1-3a098db9894mr688389a91.34.1790212309147;
        Wed, 23 Sep 2026 18:11:49 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a096a61d9bsm1687097a91.0.2026.09.23.18.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 18:11:48 -0700 (PDT)
Message-ID: <beb1c5ba-681e-4b1a-9fbc-4f137c0d6894@redhat.com>
Date: Thu, 24 Sep 2026 11:11:40 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 05/20] KVM: arm64: Track the type of VM in kvm_arch
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-6-suzuki.poulose@arm.com>
 <69ff265b-a110-46c5-a061-a875b2f86c03@redhat.com>
 <e1bd3155-acb2-4c80-b963-6cd7865c9ce3@redhat.com>
 <672c4905-09c9-4e40-97ea-c87a987bda19@arm.com>
 <0ddf1529-a198-413d-bffb-1dbc7b6ee25f@redhat.com>
 <f61aa43b-ed90-4b6e-8bef-35e0fe2e6dc2@arm.com>
 <700e9eaf-b3e8-4129-9471-25de73f008b3@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <700e9eaf-b3e8-4129-9471-25de73f008b3@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jFdLaaEBityIqXS7ZoYMWvwNDWcHln84Pm1mAk-dktU_1790212310
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/24/26 7:37 AM, Suzuki K Poulose wrote:
> On 23/09/2026 17:27, Suzuki K Poulose wrote:
>> On 23/09/2026 14:23, Gavin Shan wrote:
>>> On 9/23/26 8:24 PM, Suzuki K Poulose wrote:
>>>> On 23/09/2026 07:19, Gavin Shan wrote:
>>>>> On 9/23/26 4:05 PM, Gavin Shan wrote:
>>>>>> On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
>>>>>>> KVM arm64 has different types of VMs with all the different modes in which
>>>>>>> the hypervisor code can be run. e.g., VHE, nVHE, pKVM etc. Then there is
>>>>>>> protected VM and normal VMs with pKVM. We might soon add other types,
>>>>>>> e.g., Arm CCA Realm. So in an effort to make the handling of these
>>>>>>> different types of VMs a bit more friendly to the eyes, add a VM flavor to
>>>>>>> the kvm_arch and we could then add handlers for different operations based
>>>>>>> on the VM type.
>>>>>>>
>>>>>>> Keep the flavor initialisation at the beginning to allow for the detection
>>>>>>> early enough and fail out on any unsupported requests.
>>>>>>>
>>>>>>> With that, add wrappers for checking the "type" of a VM and replace the
>>>>>>> existing users with the new wrappers.
>>>>>>>
>>>>>>> Given we already have the construct of "kvm_vm_is_protected" in the core
>>>>>>> KVM code, use that for all confidential compute guests including Realms
>>>>>>> that we are about to add.
>>>>>>>
>>>>>>> Adds __VM_PROTECTED marker vm flavor to generalize kvm_vm_is_protected()
>>>>>>> to predicate all confidential guests running on KVM. In later patches, we
>>>>>>> would add Realm VMs, which would also be classified as protected.
>>>>>>>
>>>>>>> Add explicit helper to detect if a given VM is a "protected" VM under pKVM.
>>>>>>> Change the existing users that precisely want to check the VM type. These
>>>>>>> include :
>>>>>>>    - kvm_arch_prepare_memory_region - For preventing memslot changes after
>>>>>>>      pVM creation.
>>>>>>>
>>>>>>> All the others are retained as a wider check for confidential guest VMs.
>>>>>>> These are:
>>>>>>>   - kvm_vm_ioctl_set_counter_offset - For disallowing timer offset
>>>>>>>     configuration
>>>>>>>   - io_mem_abort for dabt handling without valid syndrome information
>>>>>>>
>>>>>>> Both of which are true for Realms too.
>>>>>>>
>>>>>>> Realms support is restricted to VHE host and thus "kvm_vm_is_protected()"
>>>>>>> checks in the pkvm hyp specific code doesn't need to change, as the only
>>>>>>> protected guests it deals with is "protected pKVM" guests. To tighten this
>>>>>>> init_pkvm_hyp_vm() restricts the hyp copy of the vm_flavor to the ones it
>>>>>>> supports.
>>>>>>>
>>>>>>> Suggested-by: Marc Zyngier <maz@kernel.org>
>>>>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>>>> ---
>>>>>>> Changes since v18:
>>>>>>>   - Merge the __VM_PROTECTED marker and the widening of kvm_vm_is_protected()
>>>>>>>     to this patch.
>>>>>>>   - Merge the use of kvm_vm_is_unprotected_pkvm() for ! kvm_vm_is_protected()
>>>>>>>     given the scope changes here.
>>>>>>>   - Drop Fuad's review tag, as this patch has multiple merges
>>>>>>>   - Restrict the VM flavors to the supported types in init_pkvm_hyp_vm().
>>>>>>>   - Drop kvm_vm_hyp_is_pkvm() and revert to is_protected_kvm_enabled()
>>>>>>>   - Use is_protected_kvm_enabled() to make the pKVM guest flavor checks.
>>>>>>>   - s/PKVM/pKVM for commit descriptions too
>>>>>>>
>>>>>>> Changes since v17:
>>>>>>>   * s/PKVM/pKVM for the comments
>>>>>>>   * Drop type argument for pkvm_init_host_vm and also drop protected variable.
>>>>>>>   * Add helpers for checking if the VM is running on pKVM (kvm_vm_hyp_is_pkvm())
>>>>>>>   * Use kvm_vm_hyp_is_pkvm() to replace is_protected_kvm_enabled() with valid
>>>>>>>     kvm instance
>>>>>>> ---
>>>>>>>   arch/arm64/include/asm/kvm_host.h | 22 +++++++++++++++++++---
>>>>>>>   arch/arm64/include/asm/kvm_pkvm.h |  4 ++--
>>>>>>>   arch/arm64/kvm/arm.c              | 31 +++++++++++++++++++++++++ +-----
>>>>>>>   arch/arm64/kvm/handle_exit.c      |  2 +-
>>>>>>>   arch/arm64/kvm/hyp/nvhe/pkvm.c    |  6 +++++-
>>>>>>>   arch/arm64/kvm/mmu.c              |  2 +-
>>>>>>>   arch/arm64/kvm/pkvm.c             |  6 ++----
>>>>>>>   7 files changed, 56 insertions(+), 17 deletions(-)
>>>>>>>
>>>>>>
>>>>>> This causes broken nVHE mode. I applied PATCH[01-05] to v7.3.rc4 whose head commit
>>>>>> is f0100363d8c3, and kselftests/kvm/guest_print causes host crash (as below). I don't
>>>>>> see the crash if only PATCH[01-04] are applied.
>>>>>>
>>>>>> host$ cat /proc/cmdline | grep kvm-arm\.mode
>>>>>> BOOT_IMAGE=(hd0,gpt2)/vmlinuz-7.3.0-rc4-gavin+ root=/dev/mapper/ rhel_nvidia--grace--hopper--01-root ro crashkernel=2G-4G:406M,4G-64G:470M,64G-:726M rd.lvm.lv=rhel_nvidia- grace-hopper-01/root rd.lvm.lv=rhel_nvidia-grace-hopper-01/swap video=simplefb:off kvm-arm.mode=nvhe
>>>>>>
>>>>>> host$ cd linux/tools/testing/selftests/kvm
>>>>>> host$ ./guest_print_test
>>>>>> Random seed: 0x193a0ed3
>>>>>> [  192.754328] kvm [6674]: nVHE hyp panic at: [<ffff8000811da044>] __kvm_nvhe___timer_enable_traps+0x4/0x160!
>>>>>> [  192.754338] kvm [6674]: nVHE call trace:
>>>>>> [  192.754339] kvm [6674]:  [<ffff8000811dcf34>] __kvm_nvhe_hyp_panic+0xb4/0xe0
>>>>>> [  192.754342] kvm [6674]:  [<ffff8000811dcba4>] __kvm_nvhe___kvm_vcpu_run+0x164/0x440
>>>>>> [  192.754344] kvm [6674]:  [<ffff8000811dfe90>] __kvm_nvhe_handle___kvm_vcpu_run+0x40/0x1f0
>>>>>> [  192.754346] kvm [6674]:  [<ffff8000811e0238>] __kvm_nvhe_handle_trap+0x158/0x280
>>>>>> [  192.754347] kvm [6674]:  [<ffff8000811dd8fc>] __kvm_nvhe___skip_pauth_save+0x4/0x4
>>>>>> [  192.754348] kvm [6674]: ---[ end nVHE call trace ]---
>>>>>> [  192.754350] Code: d2818002 17fffff7 d503201f f9400001 (b94a6821)
>>>>>> [  192.754350] kvm [6674]: Hyp Offset: 0xfffeb0d7fe2e0000
>>>>>> [  192.754351] Kernel panic - not syncing: HYP panic:
>>>>>> [  192.754351] PS:834003c9 PC:0000cf2882efa044 ESR:0000000096000004
>>>>>> [  192.754351] FAR:ffff00009b286a68 HPFAR:8000000000000000 PAR:1d00ec7edbadc8de
>>>>>> [  192.754351] VCPU:0000cf011848a350
>>>>>> [  192.845154] CPU: 12 UID: 0 PID: 6674 Comm: guest_print_tes Kdump: loaded Not tainted 7.3.0-rc4-gavin+ #7 PREEMPT(full)
>>>>>> [  192.856182] Hardware name:  GH200 P5042, BIOS 02.04.01 20250422
>>>>>> [  192.862231] Call trace:
>>>>>> [  192.864725]  show_stack+0x20/0x38 (C)
>>>>>> [  192.868471]  dump_stack_lvl+0x88/0xb8
>>>>>> [  192.872215]  dump_stack+0x18/0x30
>>>>>> [  192.875598]  vpanic+0x280/0x498
>>>>>> [  192.878806]  panic+0x68/0x70
>>>>>> [  192.881745]  nvhe_hyp_panic_handler+0x184/0x190
>>>>>> [  192.886372]  kvm_arm_vcpu_enter_exit+0x24/0x100
>>>>>> [  192.891003]  kvm_arch_vcpu_ioctl_run+0x254/0x7c0
>>>>>> [  192.895726]  kvm_vcpu_ioctl+0x174/0xb40
>>>>>> [  192.899645]  __arm64_sys_ioctl+0xb0/0x120
>>>>>> [  192.903745]  invoke_syscall.constprop.0+0xa8/0x100
>>>>>> [  192.908639]  do_el0_svc+0xb8/0xe0
>>>>>> [  192.912022]  el0_svc+0x48/0x1f8
>>>>>> [  192.915228]  el0t_64_sync_handler+0xa0/0xe8
>>>>>> [  192.919500]  el0t_64_sync+0x1ac/0x1b0
>>>>>> [  192.923243] SMP: stopping secondary CPUs
>>>>>> [  192.927653] Starting crashdump kernel...
>>>>>> [  192.931658] Bye!
>>>>>>
>>>>>
>>>>> With the following changes applied after PATCH[01-05] on top of v7.3.rc4, the crash
>>>>> is avoided.
>>>>>
>>>>> In arch/arm64/include/asm/kvm_host.h:
>>>>>
>>>>> -#define kvm_vm_is_protected(kvm)       ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>>>>> +#define kvm_vm_is_protected(kvm)       \
>>>>> +       (is_protected_kvm_enabled() && (kvm)->arch.vm_flavor >= __VM_PROTECTED)
>>>>
>>>> That only papers over the problem. We can't use the vcpu_is_*
>>>> constructs from nvhe hyp, without converting the vcpu->kvm to
>>>> the hyp address, before accessing it. The fix is a bit more
>>>> involved. One option is to define the vcpu_is_* helpers only
>>>> for the !NVHE hyp code in the kvm_host.h (to avoid pulling
>>>> in the asm/kvm_mmu.h in to kvm_host.h and then make a mess
>>>> with header dependencies) and define the NVHE version in
>>>> asm/kvm_hyp.h. Something like :
>>>>
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/ asm/kvm_host.h
>>>> index 46a7f6c1e426c..4016d09ed39c3 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -1545,11 +1545,14 @@ struct kvm *kvm_arch_alloc_vm(void);
>>>>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>>>>
>>>>   #define kvm_vm_is_protected(kvm)       ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>>>> +
>>>> +#ifndef __KVM_NVHE_HYPERVISOR__
>>>>   #define vcpu_is_protected(vcpu) kvm_vm_is_protected((vcpu)->kvm)
>>>> +#define vcpu_is_protected_pkvm(vcpu) kvm_vm_is_protected_pkvm((vcpu)- >kvm)
>>>> +#endif
>>>>
>>>>   #define kvm_vm_is_protected_pkvm(kvm)          \
>>>>          (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
>>>> -#define vcpu_is_protected_pkvm(vcpu) kvm_vm_is_protected_pkvm(vcpu- >kvm)
>>>>
>>>>   #define kvm_vm_is_unprotected_pkvm(kvm)                \
>>>>          (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PKVM))
>>>> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/ asm/kvm_hyp.h
>>>> index 4974492744cc8..3bf87e81af430 100644
>>>> --- a/arch/arm64/include/asm/kvm_hyp.h
>>>> +++ b/arch/arm64/include/asm/kvm_hyp.h
>>>> @@ -137,6 +137,19 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_bas
>>>>   void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
>>>>   #endif
>>>>
>>>> +#ifdef __KVM_NVHE_HYPERVISOR__
>>>> +#define vcpu_is_protected(vcpu)        \
>>>> + ({                                                              \
>>>> +               struct kvm *__kvm = READ_ONCE((vcpu)- >kvm);             \
>>>> +               __kvm && kvm_vm_is_protected((kern_hyp_va(__kvm)));     \
>>>> +       })
>>>> +#define vcpu_is_protected_pkvm(vcpu)                                   \
>>>> + ({                                                              \
>>>> +               struct kvm *__kvm = READ_ONCE((vcpu)- >kvm);             \
>>>> +               __kvm && kvm_vm_is_protected_pkvm((kern_hyp_va(__kvm)));\
>>>> +       })
>>>> +#endif
>>>> +
>>>>
>>>>
>>>> Or explicitly convert all nvhe accessors to a new "nvhe_vcpu_is_protected"
>>>>
>>>> The second one sounds like a better option to me.
>>>>
>>>
>>> We just need to include "asm/kvm_mmu.h" to "arch/arm64/mmio.c". With it,
>>> we can have unified functions (macros) in kvm_host.h to accomodate all
>>> cases, like below.
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/ asm/ kvm_host.h
>>> index 9b1cf9c59e81..b9c9a9f203f9 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -1514,11 +1514,36 @@ struct kvm *kvm_arch_alloc_vm(void);
>>>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>>>
>>>   #define kvm_vm_is_protected(kvm)       ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>>> -#define vcpu_is_protected(vcpu) kvm_vm_is_protected((vcpu)->kvm)
>>> +#define vcpu_is_protected(vcpu)                                                \
>>> +       ({                                                              \
>>> +               struct kvm *__kvm = READ_ONCE((vcpu)->kvm);             \
>>> +               bool __protected = false;                               \
>>> +                                                                       \
>>> +               if (__kvm) {                                            \
>>> +                       if (is_nvhe_hyp_code())                         \
> 
> This needs to be :
>                if (is_nvhe_hyp_code() && !is_protected_kvm_enabled())
> 

Yes.

>>> +                               __kvm = kern_hyp_va(__kvm);             \
> 
> Otherwise, we unnecessarily convert the vcpu->kvm for a hyp_vcpu and
> that is not going to end well for pKVM.
> 

Yes. kern_hyp_va() isn't needed when is_protected_kvm_enabled() is true.
Besides, vcpu_is_protected_pkvm() can be further simplifed by fully exploiting
the check (is_protected_kvm_enabled()) done in vcpu_is_protected_pkvm(),
see below.

> Cheers
> Suzuki
> 
> 
>>> +                       __protected = kvm_vm_is_protected(__kvm);       \
>>> +               }                                                       \
>>> +                                                                       \
>>> +               __protected;                                            \
>>> +        })
>>> +
>>>
>>>   #define kvm_vm_is_protected_pkvm(kvm)          \
>>>          (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
>>> -#define vcpu_is_protected_pkvm(vcpu)   kvm_vm_is_protected_pkvm(vcpu- >kvm)
>>> +#define vcpu_is_protected_pkvm(vcpu)                                   \
>>> +       ({                                                              \
>>> +               struct kvm *__kvm = READ_ONCE((vcpu)->kvm);             \
>>> +               bool __protected = false;                               \
>>> +                                                                       \
>>> +               if (__kvm) {                                            \
>>> +                       if (is_nvhe_hyp_code())                         \
>>> +                               __kvm = kern_hyp_va(__kvm);             \
>>> +                       __protected = kvm_vm_is_protected_pkvm(__kvm);  \
>>> +               }                                                       \
>>> +                                                                       \
>>> +               __protected;                                            \
>>> +        })

This can be further simplified by fully expliting the check (is_protected_kvm_enabled())
in kvm_vm_is_protected_pkvm(), as below. The point is that the check is_protected_kvm_enabled()
gurantees that kern_hyp_va() isn't needed.

#define vcpu_is_protected_pkvm(vcpu)                                    \
         ({                                                              \
                 struct kvm *__kvm = READ_ONCE((vcpu)->kvm);             \
                 bool __protected = false;                               \
                                                                         \
                 if (__kvm)                                              \
                         __protected = kvm_vm_is_protected_pkvm(__kvm);  \
                                                                         \
                 __protected;                                            \
         })

>>>
>>>   #define kvm_vm_is_unprotected_pkvm(kvm)                \
>>>          (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PKVM))
>>> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
>>> index d1c3a352d5a2..ab1d2fef9a52 100644
>>> --- a/arch/arm64/kvm/mmio.c
>>> +++ b/arch/arm64/kvm/mmio.c
>>> @@ -6,6 +6,7 @@
>>>
>>>   #include <linux/kvm_host.h>
>>>   #include <asm/kvm_emulate.h>
>>> +#include <asm/kvm_mmu.h>
>>>   #include <trace/events/kvm.h>
>>>
>>>   #include "trace.h"
>>>
>>
>> Thanks Gavin, that works and looks neat. I will incorporate it.
>>

Thanks,
Gavin

