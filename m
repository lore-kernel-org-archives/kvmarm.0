Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F31472783
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246285; cv=none; b=ClJx/PwkiANrYvnzn8Js60pfqXEfaHLt5PjzDB/iXixrcinE8ZMWhI+DNWTIRmWW1LkOcXOlbkPx2isSEb3iw8P4jWHPfWXYRqMDJ4lfS7JvbU6WLyaLejYrQSsvT8KN3jtKdxTF7ZucFQdyNQTsNGYznBfMt3KKJ33XVELKTkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246285; c=relaxed/simple;
	bh=A8xsQJ2linduh8LyiNqxYa3X+Ud+PNJ2iO8AypsdtIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FWONU6sh3IJhzEyGCS3QfCpgUEuJ2LazQIwpaq0wA1QHflf1oNy6EA13sURUsfJM3w7uoUK3hKuNHicRn9CAe2OLbi2+fUhHuAsrd2R0hbALGLZZEvPggo8HCD7+NsJRHO28kxH4y5UxaSnBvjq688Yc2y95RPqusy+J5tbZAbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iu4JdmcY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iu4JdmcY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790246281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uAVbcKNtAzIm2if8Vp//CW0uy9ovqdlJEmpzowvI5xg=;
	b=iu4JdmcYQUyp/bJojiax9tbADBUjoGGy5DKFQ0KrefDjfIhh6zqtWDEvRTDHNXf1Jtv3Yj
	z5ttsXuu/R7m5/tseEjv71CutJXRAsf+LulX8lX0S1tRBcU3VxEz4aa7D48y13ZYVAUJGx
	wnqSA+jj/lECMn1LfDOjmBkLB7QjQHo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-JvplWwYgNcCVL-VNGMKTmg-1; Thu, 24 Sep 2026 06:37:58 -0400
X-MC-Unique: JvplWwYgNcCVL-VNGMKTmg-1
X-Mimecast-MFC-AGG-ID: JvplWwYgNcCVL-VNGMKTmg_1790246277
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39d8646b10eso1529638a91.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 03:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790246277; x=1790851077;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uAVbcKNtAzIm2if8Vp//CW0uy9ovqdlJEmpzowvI5xg=;
        b=dGfGdpMRagQIzX6KaGCFxFQ16l3NyLRVLeMmE+ABOfoQoHejLTKeuuSjXinhRmFbBJ
         uoduC4sDspgtr2jx6+pKY4SL6++6zQWwNaeseU/1I8aDSjBJpoB197Drv5fZQwE1tEEw
         G0+qtvYOUKHCrZZcinmQQkXhPyBK5cKe1yNQGvXfwZ3zavZKdegHBonz7HCjwjEchNip
         5/AW3YNl3/apeU8Fe3igvUAvwpe5wWG15aDvXoKvOXRymxuUBfKi8gZGZl7l8jgByxCs
         AnoiYXYSILtmeiqkeFK1EkybFAASXB/IiK9f+Sg0gpisk0vcgc8VH+OleuRc2Mbn8ZM7
         4kRg==
X-Forwarded-Encrypted: i=1; AKwUvBxcmwJQo0tJWPY8vzR6/dZJnQCkcml6yYJ19/lOqCV3KCql4yzQRS0CgYf3zmeHKYtj7nD0YcY=@lists.linux.dev
X-Gm-Message-State: AFuF++nGwZFOXjNwvP85hYhBO8JKdwgEEi8aHMMT2GxjrNDGpcJcrZD1
	No9FQ2oSm8tfwtK2i0PHvDPxxiFLUFd5m8jOrnJXEuricWyWHq4fxpYy3eBOa2GMgcPdl335BRe
	ynpHJRf6RmaM8G19sU5/Cdpeftkzc1rKpOIwdKVA/vDZIfHvd5IChh9ndcA==
X-Gm-Gg: AYBFou013gAEK07+6Cq0wvoB18qtHR81fSzxYBeJt1FJu9H3Ayvw9olKppWMRoOsmH6
	O2W+WKyTrlaJJxXGq8DloLlfVROReoi4hHgNnDS/IW5bLq/ZMiZGtqnRe9LCVpAzNj+j4vgHcEX
	mY+A+gQ0fJZ5NuBAT5SddqOV84PmxGD2VUlWacJM7FDMNArZ6zeWz0iEeuzwT3z/IGMA5SWSzmz
	SCzuzA2qJMlEhAAlnqNtYkK9UxdHVCRcNiA9NRwQchhSVDqtfOl8f+foXJ61N70nx1aG7K8Pfvp
	P6uSWlAKBRsphRwZ4g0mK0UY33bKT9bNWTm1XWAqC7o1tYQ6WKcQAG7vmc2Q3jTWBNDKi+x6nXd
	V08KL3R/FsRmeYg0VjyYqGcs59HZKBTjHkxzaJ97RzA==
X-Received: by 2002:a17:90b:4c0d:b0:36d:9e0b:3801 with SMTP id 98e67ed59e1d1-3a0985baa7dmr1701213a91.8.1790246276872;
        Thu, 24 Sep 2026 03:37:56 -0700 (PDT)
X-Received: by 2002:a17:90b:4c0d:b0:36d:9e0b:3801 with SMTP id 98e67ed59e1d1-3a0985baa7dmr1701179a91.8.1790246276182;
        Thu, 24 Sep 2026 03:37:56 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a097663fd0sm4220632a91.9.2026.09.24.03.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 03:37:55 -0700 (PDT)
Message-ID: <aa6133dd-bc9a-4bf1-877d-3a1230efa644@redhat.com>
Date: Thu, 24 Sep 2026 20:37:46 +1000
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
 <beb1c5ba-681e-4b1a-9fbc-4f137c0d6894@redhat.com>
 <f926af3f-2109-4da7-9b18-cc49eac6ce1e@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <f926af3f-2109-4da7-9b18-cc49eac6ce1e@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OPFr9vBVtchwnnx_d5jfkGj7TYqLV0N7t_3UP2pcrNU_1790246277
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/24/26 6:48 PM, Suzuki K Poulose wrote:
> On 24/09/2026 02:11, Gavin Shan wrote:
>> On 9/24/26 7:37 AM, Suzuki K Poulose wrote:
>>> On 23/09/2026 17:27, Suzuki K Poulose wrote:
>>>> On 23/09/2026 14:23, Gavin Shan wrote:
>>>>> On 9/23/26 8:24 PM, Suzuki K Poulose wrote:
>>>>>> On 23/09/2026 07:19, Gavin Shan wrote:
>>>>>>> On 9/23/26 4:05 PM, Gavin Shan wrote:
>>>>>>>> On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
>>>>>>>>> KVM arm64 has different types of VMs with all the different modes in which
>>>>>>>>> the hypervisor code can be run. e.g., VHE, nVHE, pKVM etc. Then there is
>>>>>>>>> protected VM and normal VMs with pKVM. We might soon add other types,
>>>>>>>>> e.g., Arm CCA Realm. So in an effort to make the handling of these
>>>>>>>>> different types of VMs a bit more friendly to the eyes, add a VM flavor to
>>>>>>>>> the kvm_arch and we could then add handlers for different operations based
>>>>>>>>> on the VM type.
>>>>>>>>>
>>>>>>>>> Keep the flavor initialisation at the beginning to allow for the detection
>>>>>>>>> early enough and fail out on any unsupported requests.
>>>>>>>>>
>>>>>>>>> With that, add wrappers for checking the "type" of a VM and replace the
>>>>>>>>> existing users with the new wrappers.
>>>>>>>>>
>>>>>>>>> Given we already have the construct of "kvm_vm_is_protected" in the core
>>>>>>>>> KVM code, use that for all confidential compute guests including Realms
>>>>>>>>> that we are about to add.
>>>>>>>>>
>>>>>>>>> Adds __VM_PROTECTED marker vm flavor to generalize kvm_vm_is_protected()
>>>>>>>>> to predicate all confidential guests running on KVM. In later patches, we
>>>>>>>>> would add Realm VMs, which would also be classified as protected.
>>>>>>>>>
>>>>>>>>> Add explicit helper to detect if a given VM is a "protected" VM under pKVM.
>>>>>>>>> Change the existing users that precisely want to check the VM type. These
>>>>>>>>> include :
>>>>>>>>>    - kvm_arch_prepare_memory_region - For preventing memslot changes after
>>>>>>>>>      pVM creation.
>>>>>>>>>
>>>>>>>>> All the others are retained as a wider check for confidential guest VMs.
>>>>>>>>> These are:
>>>>>>>>>   - kvm_vm_ioctl_set_counter_offset - For disallowing timer offset
>>>>>>>>>     configuration
>>>>>>>>>   - io_mem_abort for dabt handling without valid syndrome information
>>>>>>>>>
>>>>>>>>> Both of which are true for Realms too.
>>>>>>>>>
>>>>>>>>> Realms support is restricted to VHE host and thus "kvm_vm_is_protected()"
>>>>>>>>> checks in the pkvm hyp specific code doesn't need to change, as the only
>>>>>>>>> protected guests it deals with is "protected pKVM" guests. To tighten this
>>>>>>>>> init_pkvm_hyp_vm() restricts the hyp copy of the vm_flavor to the ones it
>>>>>>>>> supports.
>>>>>>>>>
>>>>>>>>> Suggested-by: Marc Zyngier <maz@kernel.org>
>>>>>>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>>>>>> ---
>>>>>>>>> Changes since v18:
>>>>>>>>>   - Merge the __VM_PROTECTED marker and the widening of kvm_vm_is_protected()
>>>>>>>>>     to this patch.
>>>>>>>>>   - Merge the use of kvm_vm_is_unprotected_pkvm() for ! kvm_vm_is_protected()
>>>>>>>>>     given the scope changes here.
>>>>>>>>>   - Drop Fuad's review tag, as this patch has multiple merges
>>>>>>>>>   - Restrict the VM flavors to the supported types in init_pkvm_hyp_vm().
>>>>>>>>>   - Drop kvm_vm_hyp_is_pkvm() and revert to is_protected_kvm_enabled()
>>>>>>>>>   - Use is_protected_kvm_enabled() to make the pKVM guest flavor checks.
>>>>>>>>>   - s/PKVM/pKVM for commit descriptions too
>>>>>>>>>
>>>>>>>>> Changes since v17:
>>>>>>>>>   * s/PKVM/pKVM for the comments
>>>>>>>>>   * Drop type argument for pkvm_init_host_vm and also drop protected variable.
>>>>>>>>>   * Add helpers for checking if the VM is running on pKVM (kvm_vm_hyp_is_pkvm())
>>>>>>>>>   * Use kvm_vm_hyp_is_pkvm() to replace is_protected_kvm_enabled() with valid
>>>>>>>>>     kvm instance
>>>>>>>>> ---
>>>>>>>>>   arch/arm64/include/asm/kvm_host.h | 22 +++++++++++++++++++---
>>>>>>>>>   arch/arm64/include/asm/kvm_pkvm.h |  4 ++--
>>>>>>>>>   arch/arm64/kvm/arm.c              | 31 +++++++++++++++++++++++ ++ +-----
>>>>>>>>>   arch/arm64/kvm/handle_exit.c      |  2 +-
>>>>>>>>>   arch/arm64/kvm/hyp/nvhe/pkvm.c    |  6 +++++-
>>>>>>>>>   arch/arm64/kvm/mmu.c              |  2 +-
>>>>>>>>>   arch/arm64/kvm/pkvm.c             |  6 ++----
>>>>>>>>>   7 files changed, 56 insertions(+), 17 deletions(-)
>>>>>>>>>
>>>>>>>>
>>>>>>>> This causes broken nVHE mode. I applied PATCH[01-05] to v7.3.rc4 whose head commit
>>>>>>>> is f0100363d8c3, and kselftests/kvm/guest_print causes host crash (as below). I don't
>>>>>>>> see the crash if only PATCH[01-04] are applied.
>>>>>>>>
>>>>>>>> host$ cat /proc/cmdline | grep kvm-arm\.mode
>>>>>>>> BOOT_IMAGE=(hd0,gpt2)/vmlinuz-7.3.0-rc4-gavin+ root=/dev/mapper/ rhel_nvidia--grace--hopper--01-root ro crashkernel=2G-4G:406M,4G-64G:470M,64G-:726M rd.lvm.lv=rhel_nvidia- grace-hopper-01/root rd.lvm.lv=rhel_nvidia-grace-hopper-01/swap video=simplefb:off kvm-arm.mode=nvhe
>>>>>>>>
>>>>>>>> host$ cd linux/tools/testing/selftests/kvm
>>>>>>>> host$ ./guest_print_test
>>>>>>>> Random seed: 0x193a0ed3
>>>>>>>> [  192.754328] kvm [6674]: nVHE hyp panic at: [<ffff8000811da044>] __kvm_nvhe___timer_enable_traps+0x4/0x160!
>>>>>>>> [  192.754338] kvm [6674]: nVHE call trace:
>>>>>>>> [  192.754339] kvm [6674]:  [<ffff8000811dcf34>] __kvm_nvhe_hyp_panic+0xb4/0xe0
>>>>>>>> [  192.754342] kvm [6674]:  [<ffff8000811dcba4>] __kvm_nvhe___kvm_vcpu_run+0x164/0x440
>>>>>>>> [  192.754344] kvm [6674]:  [<ffff8000811dfe90>] __kvm_nvhe_handle___kvm_vcpu_run+0x40/0x1f0
>>>>>>>> [  192.754346] kvm [6674]:  [<ffff8000811e0238>] __kvm_nvhe_handle_trap+0x158/0x280
>>>>>>>> [  192.754347] kvm [6674]:  [<ffff8000811dd8fc>] __kvm_nvhe___skip_pauth_save+0x4/0x4
>>>>>>>> [  192.754348] kvm [6674]: ---[ end nVHE call trace ]---
>>>>>>>> [  192.754350] Code: d2818002 17fffff7 d503201f f9400001 (b94a6821)
>>>>>>>> [  192.754350] kvm [6674]: Hyp Offset: 0xfffeb0d7fe2e0000
>>>>>>>> [  192.754351] Kernel panic - not syncing: HYP panic:
>>>>>>>> [  192.754351] PS:834003c9 PC:0000cf2882efa044 ESR:0000000096000004
>>>>>>>> [  192.754351] FAR:ffff00009b286a68 HPFAR:8000000000000000 PAR:1d00ec7edbadc8de
>>>>>>>> [  192.754351] VCPU:0000cf011848a350
>>>>>>>> [  192.845154] CPU: 12 UID: 0 PID: 6674 Comm: guest_print_tes Kdump: loaded Not tainted 7.3.0-rc4-gavin+ #7 PREEMPT(full)
>>>>>>>> [  192.856182] Hardware name:  GH200 P5042, BIOS 02.04.01 20250422
>>>>>>>> [  192.862231] Call trace:
>>>>>>>> [  192.864725]  show_stack+0x20/0x38 (C)
>>>>>>>> [  192.868471]  dump_stack_lvl+0x88/0xb8
>>>>>>>> [  192.872215]  dump_stack+0x18/0x30
>>>>>>>> [  192.875598]  vpanic+0x280/0x498
>>>>>>>> [  192.878806]  panic+0x68/0x70
>>>>>>>> [  192.881745]  nvhe_hyp_panic_handler+0x184/0x190
>>>>>>>> [  192.886372]  kvm_arm_vcpu_enter_exit+0x24/0x100
>>>>>>>> [  192.891003]  kvm_arch_vcpu_ioctl_run+0x254/0x7c0
>>>>>>>> [  192.895726]  kvm_vcpu_ioctl+0x174/0xb40
>>>>>>>> [  192.899645]  __arm64_sys_ioctl+0xb0/0x120
>>>>>>>> [  192.903745]  invoke_syscall.constprop.0+0xa8/0x100
>>>>>>>> [  192.908639]  do_el0_svc+0xb8/0xe0
>>>>>>>> [  192.912022]  el0_svc+0x48/0x1f8
>>>>>>>> [  192.915228]  el0t_64_sync_handler+0xa0/0xe8
>>>>>>>> [  192.919500]  el0t_64_sync+0x1ac/0x1b0
>>>>>>>> [  192.923243] SMP: stopping secondary CPUs
>>>>>>>> [  192.927653] Starting crashdump kernel...
>>>>>>>> [  192.931658] Bye!
>>>>>>>>
>>>>>>>
>>>>>>> With the following changes applied after PATCH[01-05] on top of v7.3.rc4, the crash
>>>>>>> is avoided.
>>>>>>>
>>>>>>> In arch/arm64/include/asm/kvm_host.h:
>>>>>>>
>>>>>>> -#define kvm_vm_is_protected(kvm)       ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>>>>>>> +#define kvm_vm_is_protected(kvm)       \
>>>>>>> +       (is_protected_kvm_enabled() && (kvm)->arch.vm_flavor >= __VM_PROTECTED)
>>>>>>
>>>>>> That only papers over the problem. We can't use the vcpu_is_*
>>>>>> constructs from nvhe hyp, without converting the vcpu->kvm to
>>>>>> the hyp address, before accessing it. The fix is a bit more
>>>>>> involved. One option is to define the vcpu_is_* helpers only
>>>>>> for the !NVHE hyp code in the kvm_host.h (to avoid pulling
>>>>>> in the asm/kvm_mmu.h in to kvm_host.h and then make a mess
>>>>>> with header dependencies) and define the NVHE version in
>>>>>> asm/kvm_hyp.h. Something like :
>>>>>>
>>>>>>
>>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/ include/ asm/kvm_host.h
>>>>>> index 46a7f6c1e426c..4016d09ed39c3 100644
>>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>>> @@ -1545,11 +1545,14 @@ struct kvm *kvm_arch_alloc_vm(void);
>>>>>>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>>>>>>
>>>>>>   #define kvm_vm_is_protected(kvm)       ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>>>>>> +
>>>>>> +#ifndef __KVM_NVHE_HYPERVISOR__
>>>>>>   #define vcpu_is_protected(vcpu) kvm_vm_is_protected((vcpu)->kvm)
>>>>>> +#define vcpu_is_protected_pkvm(vcpu) kvm_vm_is_protected_pkvm((vcpu)- >kvm)
>>>>>> +#endif
>>>>>>
>>>>>>   #define kvm_vm_is_protected_pkvm(kvm)          \
>>>>>>          (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
>>>>>> -#define vcpu_is_protected_pkvm(vcpu) kvm_vm_is_protected_pkvm(vcpu- >kvm)
>>>>>>
>>>>>>   #define kvm_vm_is_unprotected_pkvm(kvm)                \
>>>>>>          (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PKVM))
>>>>>> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/ asm/kvm_hyp.h
>>>>>> index 4974492744cc8..3bf87e81af430 100644
>>>>>> --- a/arch/arm64/include/asm/kvm_hyp.h
>>>>>> +++ b/arch/arm64/include/asm/kvm_hyp.h
>>>>>> @@ -137,6 +137,19 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_bas
>>>>>>   void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
>>>>>>   #endif
>>>>>>
>>>>>> +#ifdef __KVM_NVHE_HYPERVISOR__
>>>>>> +#define vcpu_is_protected(vcpu)        \
>>>>>> + ({                                                              \
>>>>>> +               struct kvm *__kvm = READ_ONCE((vcpu)- >kvm);             \
>>>>>> +               __kvm && kvm_vm_is_protected((kern_hyp_va(__kvm)));     \
>>>>>> +       })
>>>>>> +#define vcpu_is_protected_pkvm(vcpu)                                   \
>>>>>> + ({                                                              \
>>>>>> +               struct kvm *__kvm = READ_ONCE((vcpu)- >kvm);             \
>>>>>> +               __kvm && kvm_vm_is_protected_pkvm((kern_hyp_va(__kvm)));\
>>>>>> +       })
>>>>>> +#endif
>>>>>> +
>>>>>>
>>>>>>
>>>>>> Or explicitly convert all nvhe accessors to a new "nvhe_vcpu_is_protected"
>>>>>>
>>>>>> The second one sounds like a better option to me.
>>>>>>
>>>>>
>>>>> We just need to include "asm/kvm_mmu.h" to "arch/arm64/mmio.c". With it,
>>>>> we can have unified functions (macros) in kvm_host.h to accomodate all
>>>>> cases, like below.
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/ asm/ kvm_host.h
>>>>> index 9b1cf9c59e81..b9c9a9f203f9 100644
>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>> @@ -1514,11 +1514,36 @@ struct kvm *kvm_arch_alloc_vm(void);
>>>>>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>>>>>
>>>>>   #define kvm_vm_is_protected(kvm)       ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>>>>> -#define vcpu_is_protected(vcpu) kvm_vm_is_protected((vcpu)->kvm)
>>>>> +#define vcpu_is_protected(vcpu)                                                \
>>>>> + ({                                                              \
>>>>> +               struct kvm *__kvm = READ_ONCE((vcpu)- >kvm);             \
>>>>> +               bool __protected = false;                               \
>>>>> +                                                                       \
>>>>> +               if (__kvm) {                                            \
>>>>> +                       if (is_nvhe_hyp_code())                         \
>>>
>>> This needs to be :
>>>                if (is_nvhe_hyp_code() && !is_protected_kvm_enabled())
>>>
>>
>> Yes.
>>
>>>>> +                               __kvm = kern_hyp_va(__kvm);             \
>>>
>>> Otherwise, we unnecessarily convert the vcpu->kvm for a hyp_vcpu and
>>> that is not going to end well for pKVM.
>>>
>>
>> Yes. kern_hyp_va() isn't needed when is_protected_kvm_enabled() is true.
> 
> nit : It is not that it is needed, but it is incorrect to convert the vcpu->kvm which is already a HYP VA via kern_hyp_va() which is not
> idempotent and thus we end up accessing something junk.
> 

Yes.

>> Besides, vcpu_is_protected_pkvm() can be further simplifed by fully exploiting
>> the check (is_protected_kvm_enabled()) done in vcpu_is_protected_pkvm(),
>> see below.
> 
> Good point.
> 
>>
>>> Cheers
>>> Suzuki
>>>
>>>
>>>>> +                       __protected = kvm_vm_is_protected(__kvm);       \
>>>>> +               }                                                       \
>>>>> +                                                                       \
>>>>> + __protected;                                            \
>>>>> +        })
>>>>> +
>>>>>
>>>>>   #define kvm_vm_is_protected_pkvm(kvm)          \
>>>>>          (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
>>>>> -#define vcpu_is_protected_pkvm(vcpu) kvm_vm_is_protected_pkvm(vcpu- >kvm)
>>>>> +#define vcpu_is_protected_pkvm(vcpu)                                   \
>>>>> + ({                                                              \
>>>>> +               struct kvm *__kvm = READ_ONCE((vcpu)- >kvm);             \
>>>>> +               bool __protected = false;                               \
>>>>> +                                                                       \
>>>>> +               if (__kvm) {                                            \
>>>>> +                       if (is_nvhe_hyp_code())                         \
>>>>> +                               __kvm = kern_hyp_va(__kvm);             \
>>>>> +                       __protected = kvm_vm_is_protected_pkvm(__kvm);  \
>>>>> +               }                                                       \
>>>>> +                                                                       \
>>>>> + __protected;                                            \
>>>>> +        })
>>
>> This can be further simplified by fully expliting the check (is_protected_kvm_enabled())
>> in kvm_vm_is_protected_pkvm(), as below. The point is that the check is_protected_kvm_enabled()
>> gurantees that kern_hyp_va() isn't needed.
>>
>> #define vcpu_is_protected_pkvm(vcpu)                                    \
>>          ({                                                              \
>>                  struct kvm *__kvm = READ_ONCE((vcpu)->kvm);             \
>>                  bool __protected = false;                               \
>>                                                                          \
>>                  if (__kvm)                                              \
>>                          __protected = kvm_vm_is_protected_pkvm(__kvm);  \
>>                                                                          \
>>                  __protected;                                            \
>>          })
>>
> 
> Ack, I have reduced this to:
> 
> 
> /*
>   * Rely on is_protected_kvm_enabled() check in kvm_vm_is_protected_pkvm() to
>   * make sure the vcpu->kvm is always valid VA in the context
>   */
> #define vcpu_is_protected_pkvm(vcpu)                                    \
>          ({                                                              \
>                  struct kvm *__kvm = READ_ONCE((vcpu)->kvm);             \
>                                                                          \
>                  (__kvm) && kvm_vm_is_protected_pkvm(__kvm));            \
>          })
> 

Parentheses for the local variable '__kvm' can be dropped. With this, this
looks good to me.

                    (__kvm && kvm_vm_is_protected_pkvm(__kvm));

Thanks,
Gavin

> 
> Cheers
> Suzuki
> 
>>>>>
>>>>>   #define kvm_vm_is_unprotected_pkvm(kvm)                \
>>>>>          (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PKVM))
>>>>> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
>>>>> index d1c3a352d5a2..ab1d2fef9a52 100644
>>>>> --- a/arch/arm64/kvm/mmio.c
>>>>> +++ b/arch/arm64/kvm/mmio.c
>>>>> @@ -6,6 +6,7 @@
>>>>>
>>>>>   #include <linux/kvm_host.h>
>>>>>   #include <asm/kvm_emulate.h>
>>>>> +#include <asm/kvm_mmu.h>
>>>>>   #include <trace/events/kvm.h>
>>>>>
>>>>>   #include "trace.h"
>>>>>
>>>>
>>>> Thanks Gavin, that works and looks neat. I will incorporate it.
>>>>
>>
>> Thanks,
>> Gavin
>>
> 

