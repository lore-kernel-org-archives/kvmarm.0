Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E51443E4E
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 06:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790144389; cv=none; b=dm39lmx/j/RNjj12Ho/AOaGnNHlUlRtHYQAgagk3/cVCQZiXC6T3iTfASDOICRdFmwOLCH27xeh0QbRBC2L+t4qNLo4vjNHRNE1qxLiytp1xQL2dqCMZac3BJK+YNH/l7i3sb3tcA0eqGogTjjmBfAapm3DZqrvek6NL55EM03o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790144389; c=relaxed/simple;
	bh=5BWfhi/nzXw6sGVXrb9Ww51TWpOVydjiYgAOsoBlMJc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=fL0XCGrd5nyS5ZK/4REGRfiOLfxOrlMmj3SozcyMKGYvPqB1FKQPgM6O8rwS5REJEGFBXLdfjox9hav9EMVueSFb4RhsVsUFfxXCGPxZHDPs7X63tHYE+0UdcibMbJ19RYAeaGVbDEdn1ZFWoiMSW6IHPrg+Zlk0k/rDJRA7YVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NJzGZpN7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NJzGZpN7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790144378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RLwB8wedvDVEeXIAGGHDfxUbkD2wGilvXWJcQTJVMbo=;
	b=NJzGZpN7/NXfZyqwBE0uc2stS0DUVw4Y0TMs+/3Mj6vPJedBsfUfwdSeEVw5hGo5Bn4c48
	AOeBo+6vy1apMDWhx+XjZAR91DMT9P040pyuUM8BZrLn9bZs+cj+Ej1zBkOLtbfwOewAkn
	bY6s/sbeplDlwfAPcL2CMGXOSOIInZE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-feEtV_PLNKO0BCRuZ9H1gw-1; Wed, 23 Sep 2026 02:19:37 -0400
X-MC-Unique: feEtV_PLNKO0BCRuZ9H1gw-1
X-Mimecast-MFC-AGG-ID: feEtV_PLNKO0BCRuZ9H1gw_1790144377
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-86b70a52946so638679b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 23:19:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144376; x=1790749176;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RLwB8wedvDVEeXIAGGHDfxUbkD2wGilvXWJcQTJVMbo=;
        b=pToUK4fu+WGqoJ/N45TG0DLwQa9V/lzZBqz+y7R09LXkQgxFCxYOnZL7e1NAucUJF7
         7IzaiQkz/gMPGgfGcBVPBOzyhFCWLtZCY48bbV1e7ja/s+ohXlRZX8JHyHHVWEIspJuJ
         YoHtumn6ks928BMsT64UAT7f8JMtADFWTi8Tzb/DSOmgX2S1XXiVCBGSsUKmp+nsgLdE
         9xXNGKRASyLFg8yA4se6Rttn415IVRk+uzC5UaCbH0HmLu8mUMrTSG/Kugv6/kOjBcr7
         Zx74TSG34grumEjHd+9bOMTgGrbhqn9yZTa1trzns0fED6VPZGBpNjbtqe62XZmZV34w
         e40A==
X-Forwarded-Encrypted: i=1; AKwUvBxFOgN84eUr6aqUTShx/FmaQtEz0BDUgtyLO3WSlOnUTkhHIdWaSBvd5KNYPMCBoTrih9girz8=@lists.linux.dev
X-Gm-Message-State: AFuF++m+gMIZCEwiD4Wz5OHyD6EvnIkwCds5I6OlZnAISA2KSHIPrkXk
	SKe6vQQj1C13WGJh+SY2jWTcfzubZTr+7NaRmGwZrNT2Ovb8hXxGGvjdwcD4Asfa7bHrReK3jcX
	/NREh8PoQPucArVOUm59GwsxEhi5+h5HLxiiNiJ1UCy5WlLETBJZHewltyg==
X-Gm-Gg: AYBFou1Cwvs4sUd00MPJHANl7QRoV6Tfb88E/zoDVO352bEstOWD/fWOafqdgwiELJh
	vvKn9kVgOfxdHji69lbZleAd31BxEhKuujxOp+KcWta0H8Naw1qXGJtVAcnc6nMwKPV8nhzIaYN
	xBet/eR/27ZxPnGcYnn0grH8p080X07kZUAh2ROXuZiuhJOoopAXr0+xF+kkhnOXbtHHrShVcQX
	UD/ykGFl0hcCxty3qz/YfK84IMfwnmFhyV/7U8JG5hfG5XjbDn5QKPFaGCfr8Sw3RAZEh2lQJ1y
	oL7hwzIwmk3HktjYU2WhwEg13LF3JBVfxdRXXKpArlNbKmuaXWOHC7blJAWfLYS4pBWzCda8stX
	a8qE1n6liD2DJydCOk0c7Tk/WfIPR1VmvkNeUwHVNFQ==
X-Received: by 2002:a05:6a00:928c:b0:878:34e7:9a43 with SMTP id d2e1a72fcca58-87d1c3c7d1dmr1547490b3a.60.1790144376286;
        Tue, 22 Sep 2026 23:19:36 -0700 (PDT)
X-Received: by 2002:a05:6a00:928c:b0:878:34e7:9a43 with SMTP id d2e1a72fcca58-87d1c3c7d1dmr1547464b3a.60.1790144375706;
        Tue, 22 Sep 2026 23:19:35 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1dacd460sm742290b3a.33.2026.09.22.23.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 23:19:34 -0700 (PDT)
Message-ID: <e1bd3155-acb2-4c80-b963-6cd7865c9ce3@redhat.com>
Date: Wed, 23 Sep 2026 16:19:27 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 05/20] KVM: arm64: Track the type of VM in kvm_arch
From: Gavin Shan <gshan@redhat.com>
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
In-Reply-To: <69ff265b-a110-46c5-a061-a875b2f86c03@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: toiFzzhnWl3nUKPT9bCs-sHqXGkI4ALWUAmfqa5gdhg_1790144377
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/23/26 4:05 PM, Gavin Shan wrote:
> On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
>> KVM arm64 has different types of VMs with all the different modes in which
>> the hypervisor code can be run. e.g., VHE, nVHE, pKVM etc. Then there is
>> protected VM and normal VMs with pKVM. We might soon add other types,
>> e.g., Arm CCA Realm. So in an effort to make the handling of these
>> different types of VMs a bit more friendly to the eyes, add a VM flavor to
>> the kvm_arch and we could then add handlers for different operations based
>> on the VM type.
>>
>> Keep the flavor initialisation at the beginning to allow for the detection
>> early enough and fail out on any unsupported requests.
>>
>> With that, add wrappers for checking the "type" of a VM and replace the
>> existing users with the new wrappers.
>>
>> Given we already have the construct of "kvm_vm_is_protected" in the core
>> KVM code, use that for all confidential compute guests including Realms
>> that we are about to add.
>>
>> Adds __VM_PROTECTED marker vm flavor to generalize kvm_vm_is_protected()
>> to predicate all confidential guests running on KVM. In later patches, we
>> would add Realm VMs, which would also be classified as protected.
>>
>> Add explicit helper to detect if a given VM is a "protected" VM under pKVM.
>> Change the existing users that precisely want to check the VM type. These
>> include :
>>    - kvm_arch_prepare_memory_region - For preventing memslot changes after
>>      pVM creation.
>>
>> All the others are retained as a wider check for confidential guest VMs.
>> These are:
>>   - kvm_vm_ioctl_set_counter_offset - For disallowing timer offset
>>     configuration
>>   - io_mem_abort for dabt handling without valid syndrome information
>>
>> Both of which are true for Realms too.
>>
>> Realms support is restricted to VHE host and thus "kvm_vm_is_protected()"
>> checks in the pkvm hyp specific code doesn't need to change, as the only
>> protected guests it deals with is "protected pKVM" guests. To tighten this
>> init_pkvm_hyp_vm() restricts the hyp copy of the vm_flavor to the ones it
>> supports.
>>
>> Suggested-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v18:
>>   - Merge the __VM_PROTECTED marker and the widening of kvm_vm_is_protected()
>>     to this patch.
>>   - Merge the use of kvm_vm_is_unprotected_pkvm() for !kvm_vm_is_protected()
>>     given the scope changes here.
>>   - Drop Fuad's review tag, as this patch has multiple merges
>>   - Restrict the VM flavors to the supported types in init_pkvm_hyp_vm().
>>   - Drop kvm_vm_hyp_is_pkvm() and revert to is_protected_kvm_enabled()
>>   - Use is_protected_kvm_enabled() to make the pKVM guest flavor checks.
>>   - s/PKVM/pKVM for commit descriptions too
>>
>> Changes since v17:
>>   * s/PKVM/pKVM for the comments
>>   * Drop type argument for pkvm_init_host_vm and also drop protected variable.
>>   * Add helpers for checking if the VM is running on pKVM (kvm_vm_hyp_is_pkvm())
>>   * Use kvm_vm_hyp_is_pkvm() to replace is_protected_kvm_enabled() with valid
>>     kvm instance
>> ---
>>   arch/arm64/include/asm/kvm_host.h | 22 +++++++++++++++++++---
>>   arch/arm64/include/asm/kvm_pkvm.h |  4 ++--
>>   arch/arm64/kvm/arm.c              | 31 ++++++++++++++++++++++++++-----
>>   arch/arm64/kvm/handle_exit.c      |  2 +-
>>   arch/arm64/kvm/hyp/nvhe/pkvm.c    |  6 +++++-
>>   arch/arm64/kvm/mmu.c              |  2 +-
>>   arch/arm64/kvm/pkvm.c             |  6 ++----
>>   7 files changed, 56 insertions(+), 17 deletions(-)
>>
> 
> This causes broken nVHE mode. I applied PATCH[01-05] to v7.3.rc4 whose head commit
> is f0100363d8c3, and kselftests/kvm/guest_print causes host crash (as below). I don't
> see the crash if only PATCH[01-04] are applied.
> 
> host$ cat /proc/cmdline | grep kvm-arm\.mode
> BOOT_IMAGE=(hd0,gpt2)/vmlinuz-7.3.0-rc4-gavin+ root=/dev/mapper/rhel_nvidia--grace--hopper--01-root ro crashkernel=2G-4G:406M,4G-64G:470M,64G-:726M rd.lvm.lv=rhel_nvidia-grace-hopper-01/root rd.lvm.lv=rhel_nvidia-grace-hopper-01/swap video=simplefb:off kvm-arm.mode=nvhe
> 
> host$ cd linux/tools/testing/selftests/kvm
> host$ ./guest_print_test
> Random seed: 0x193a0ed3
> [  192.754328] kvm [6674]: nVHE hyp panic at: [<ffff8000811da044>] __kvm_nvhe___timer_enable_traps+0x4/0x160!
> [  192.754338] kvm [6674]: nVHE call trace:
> [  192.754339] kvm [6674]:  [<ffff8000811dcf34>] __kvm_nvhe_hyp_panic+0xb4/0xe0
> [  192.754342] kvm [6674]:  [<ffff8000811dcba4>] __kvm_nvhe___kvm_vcpu_run+0x164/0x440
> [  192.754344] kvm [6674]:  [<ffff8000811dfe90>] __kvm_nvhe_handle___kvm_vcpu_run+0x40/0x1f0
> [  192.754346] kvm [6674]:  [<ffff8000811e0238>] __kvm_nvhe_handle_trap+0x158/0x280
> [  192.754347] kvm [6674]:  [<ffff8000811dd8fc>] __kvm_nvhe___skip_pauth_save+0x4/0x4
> [  192.754348] kvm [6674]: ---[ end nVHE call trace ]---
> [  192.754350] Code: d2818002 17fffff7 d503201f f9400001 (b94a6821)
> [  192.754350] kvm [6674]: Hyp Offset: 0xfffeb0d7fe2e0000
> [  192.754351] Kernel panic - not syncing: HYP panic:
> [  192.754351] PS:834003c9 PC:0000cf2882efa044 ESR:0000000096000004
> [  192.754351] FAR:ffff00009b286a68 HPFAR:8000000000000000 PAR:1d00ec7edbadc8de
> [  192.754351] VCPU:0000cf011848a350
> [  192.845154] CPU: 12 UID: 0 PID: 6674 Comm: guest_print_tes Kdump: loaded Not tainted 7.3.0-rc4-gavin+ #7 PREEMPT(full)
> [  192.856182] Hardware name:  GH200 P5042, BIOS 02.04.01 20250422
> [  192.862231] Call trace:
> [  192.864725]  show_stack+0x20/0x38 (C)
> [  192.868471]  dump_stack_lvl+0x88/0xb8
> [  192.872215]  dump_stack+0x18/0x30
> [  192.875598]  vpanic+0x280/0x498
> [  192.878806]  panic+0x68/0x70
> [  192.881745]  nvhe_hyp_panic_handler+0x184/0x190
> [  192.886372]  kvm_arm_vcpu_enter_exit+0x24/0x100
> [  192.891003]  kvm_arch_vcpu_ioctl_run+0x254/0x7c0
> [  192.895726]  kvm_vcpu_ioctl+0x174/0xb40
> [  192.899645]  __arm64_sys_ioctl+0xb0/0x120
> [  192.903745]  invoke_syscall.constprop.0+0xa8/0x100
> [  192.908639]  do_el0_svc+0xb8/0xe0
> [  192.912022]  el0_svc+0x48/0x1f8
> [  192.915228]  el0t_64_sync_handler+0xa0/0xe8
> [  192.919500]  el0t_64_sync+0x1ac/0x1b0
> [  192.923243] SMP: stopping secondary CPUs
> [  192.927653] Starting crashdump kernel...
> [  192.931658] Bye!
> 

With the following changes applied after PATCH[01-05] on top of v7.3.rc4, the crash
is avoided.

In arch/arm64/include/asm/kvm_host.h:

-#define kvm_vm_is_protected(kvm)       ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
+#define kvm_vm_is_protected(kvm)       \
+       (is_protected_kvm_enabled() && (kvm)->arch.vm_flavor >= __VM_PROTECTED)


Thanks,
Gavin

>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 286489a69dff5..9b1cf9c59e81f 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -257,7 +257,6 @@ struct kvm_protected_vm {
>>       pkvm_handle_t handle;
>>       struct kvm_hyp_memcache teardown_mc;
>>       struct kvm_hyp_memcache stage2_teardown_mc;
>> -    bool is_protected;
>>       bool is_created;
>>       /*
>> @@ -306,9 +305,19 @@ enum fgt_group_id {
>>       __NR_FGT_GROUP_IDS__
>>   };
>> +enum kvm_arm_vm_flavor {
>> +    VM_NVHE,
>> +    VM_VHE,
>> +    VM_PKVM,        /* Normal guests on pKVM */
>> +    MARKER(__VM_PROTECTED),
>> +    VM_PROTECTED_PKVM,    /* Protected VM */
>> +    VM_FLAVOR_MAX,
>> +};
>> +
>>   struct kvm_arch {
>>       struct kvm_s2_mmu mmu;
>> +    enum kvm_arm_vm_flavor vm_flavor;
>>       /*
>>        * Fine-Grained UNDEF, mimicking the FGT layout defined by the
>>        * architecture. We track them globally, as we present the
>> @@ -1504,10 +1513,17 @@ struct kvm *kvm_arch_alloc_vm(void);
>>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>> -#define kvm_vm_is_protected(kvm)    (is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
>> -
>> +#define kvm_vm_is_protected(kvm)    ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>>   #define vcpu_is_protected(vcpu)        kvm_vm_is_protected((vcpu)->kvm)
>> +#define kvm_vm_is_protected_pkvm(kvm)        \
>> +    (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
>> +#define vcpu_is_protected_pkvm(vcpu)    kvm_vm_is_protected_pkvm(vcpu->kvm)
>> +
>> +#define kvm_vm_is_unprotected_pkvm(kvm)        \
>> +    (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PKVM))
>> +
>> +
>>   int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>>   bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
>> index 54a618d887fa4..e4ea80711bec6 100644
>> --- a/arch/arm64/include/asm/kvm_pkvm.h
>> +++ b/arch/arm64/include/asm/kvm_pkvm.h
>> @@ -17,7 +17,7 @@
>>   #define HYP_MEMBLOCK_REGIONS 128
>> -int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
>> +int pkvm_init_host_vm(struct kvm *kvm);
>>   int pkvm_create_hyp_vm(struct kvm *kvm);
>>   bool pkvm_hyp_vm_is_created(struct kvm *kvm);
>>   void pkvm_destroy_hyp_vm(struct kvm *kvm);
>> @@ -49,7 +49,7 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
>>       case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
>>           return false;
>>       default:
>> -        return !kvm || !kvm_vm_is_protected(kvm);
>> +        return !kvm || kvm_vm_is_unprotected_pkvm(kvm);
>>       }
>>   }
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index db36815630790..8c784b266a8e8 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -214,6 +214,26 @@ static int kvm_arm_default_max_vcpus(void)
>>       return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>>   }
>> +static int kvm_init_vm_flavor(struct kvm *kvm, unsigned long type)
>> +{
>> +    bool protected = type & KVM_VM_TYPE_ARM_PROTECTED;
>> +
>> +    if (is_protected_kvm_enabled()) {
>> +        if (protected)
>> +            kvm->arch.vm_flavor = VM_PROTECTED_PKVM;
>> +        else
>> +            kvm->arch.vm_flavor = VM_PKVM;
>> +    } else if (protected) {
>> +        return -EINVAL;
>> +    } else if (has_vhe()) {
>> +        kvm->arch.vm_flavor = VM_VHE;
>> +    } else {
>> +        kvm->arch.vm_flavor = VM_NVHE;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   /**
>>    * kvm_arch_init_vm - initializes a VM data structure
>>    * @kvm:    pointer to the KVM struct
>> @@ -236,6 +256,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>       mutex_unlock(&kvm->lock);
>>   #endif
>> +    ret = kvm_init_vm_flavor(kvm, type);
>> +    if (ret)
>> +        return ret;
>> +
>>       kvm_init_nested(kvm);
>>       ret = kvm_share_hyp(kvm, kvm + 1);
>> @@ -257,12 +281,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>            * If any failures occur after this is successful, make sure to
>>            * call __pkvm_unreserve_vm to unreserve the VM in hyp.
>>            */
>> -        ret = pkvm_init_host_vm(kvm, type);
>> +        ret = pkvm_init_host_vm(kvm);
>>           if (ret)
>>               goto err_uninit_mmu;
>> -    } else if (type & KVM_VM_TYPE_ARM_PROTECTED) {
>> -        ret = -EINVAL;
>> -        goto err_uninit_mmu;
>>       }
>>       kvm_vgic_early_init(kvm);
>> @@ -985,7 +1006,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>>       if (is_protected_kvm_enabled()) {
>>           /* Start with the vcpu in a dirty state */
>> -        if (!kvm_vm_is_protected(vcpu->kvm))
>> +        if (kvm_vm_is_unprotected_pkvm(vcpu->kvm))
>>               vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
>>           ret = pkvm_create_hyp_vm(kvm);
>>           if (ret)
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index db37678dcb05c..384c5d258c7f8 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -490,7 +490,7 @@ static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exception_index)
>>   {
>>       int exception_code = ARM_EXCEPTION_CODE(exception_index);
>> -    if (!is_protected_kvm_enabled() || kvm_vm_is_protected(vcpu->kvm))
>> +    if (!kvm_vm_is_unprotected_pkvm(vcpu->kvm))
>>           return;
>>       /*
>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> index 459bd9eb7e4bc..57e2eef6d7426 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> @@ -432,7 +432,11 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
>>       hyp_vm->host_kvm = host_kvm;
>>       hyp_vm->kvm.created_vcpus = nr_vcpus;
>> -    hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
>> +    if (kvm_vm_is_protected(host_kvm))
>> +        hyp_vm->kvm.arch.vm_flavor = VM_PROTECTED_PKVM;
>> +    else
>> +        hyp_vm->kvm.arch.vm_flavor = VM_PKVM;
>> +
>>       hyp_vm->kvm.arch.flags = 0;
>>       pkvm_init_features_from_host(hyp_vm, host_kvm);
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 9ba86450fe4af..0f4e8b71fa85d 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -2624,7 +2624,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>       hva_t hva, reg_end;
>>       int ret = 0;
>> -    if (kvm_vm_is_protected(kvm)) {
>> +    if (kvm_vm_is_protected_pkvm(kvm)) {
>>           /* Cannot modify memslots once a pVM has run. */
>>           if (pkvm_hyp_vm_is_created(kvm) &&
>>               (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
>> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
>> index 8e4c6e4bec123..8e9176a700926 100644
>> --- a/arch/arm64/kvm/pkvm.c
>> +++ b/arch/arm64/kvm/pkvm.c
>> @@ -229,10 +229,9 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm)
>>       mutex_unlock(&kvm->arch.config_lock);
>>   }
>> -int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
>> +int pkvm_init_host_vm(struct kvm *kvm)
>>   {
>>       int ret;
>> -    bool protected = type & KVM_VM_TYPE_ARM_PROTECTED;
>>       /* Reserve the VM in hyp and obtain a hyp handle for the VM. */
>>       ret = kvm_call_hyp_nvhe(__pkvm_reserve_vm);
>> @@ -240,8 +239,7 @@ int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
>>           return ret;
>>       kvm->arch.pkvm.handle = ret;
>> -    kvm->arch.pkvm.is_protected = protected;
>> -    if (protected) {
>> +    if (kvm_vm_is_protected(kvm)) {
>>           pr_warn_once("kvm: protected VMs are experimental and for development only, tainting kernel\n");
>>           add_taint(TAINT_USER, LOCKDEP_STILL_OK);
>>       }
> 

