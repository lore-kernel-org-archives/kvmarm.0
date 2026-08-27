Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C70332601;
	Thu, 27 Aug 2026 06:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787812497; cv=none; b=TUZ3ofEr+0uywh1/6mKlE0mg40xk5x8m9TVRc4Iw4kR9pfZyjJsJkiiEeiMBRwwzIv1jqgNcWlU85jMZYEsnMDYddN0I/kzez32HhZdgLeCVRRZj56MdZk+FGVMKWzAAYXSC9wj6PQUPY3JyhKVcICug8Up/o25HanFg45PLWNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787812497; c=relaxed/simple;
	bh=/oLrLIhWZriKl1OH/cRnIgSblg3BigY/ITaC53mUQBM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=iEbNxpVO1s9FzmTvLqVBAGGc6R3izJiIkl34VB27fe768NHa7B4Smippp3+iSk0bcAJjk9ogmlCNznnkziN991aq0/sDIhU2NOCWWmqm/El5yRBDgiBDeDz8+Eul8Ch1LZN93pVYIPoIFvibN5YWNsNMruJQERRINYS0c5j+DHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxfdKI2o9q4ZcFAA--.15649S3;
	Thu, 27 Aug 2026 14:34:49 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCx9cyC2o9qduYTAA--.11229S2;
	Thu, 27 Aug 2026 14:34:44 +0800 (CST)
Subject: Re: [PATCH 02/20] KVM: selftests: Bump the minimum GPA for page
 tables to 0x200000
To: Sean Christopherson <seanjc@google.com>, sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
 kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>
References: <20260826230511.972824-1-seanjc@google.com>
 <20260826230511.972824-3-seanjc@google.com>
 <20260826232224.782021F000E9@smtp.kernel.org> <ao946gGsIkSkEwAs@google.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <de6deb5a-5ce8-2acf-01b8-9d597b2e3769@loongson.cn>
Date: Thu, 27 Aug 2026 14:34:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ao946gGsIkSkEwAs@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx9cyC2o9qduYTAA--.11229S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGryxuw17try7Cw1fZr15KFX_yoW5KF1rpa
	48Ja1Ykr48tFySyrn2gw1q9ryvkwsayFW8Cr15Cry5Zw15try2yr1xGay3Za43ZrsYqF4F
	vFZrWanrZF48XwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
	6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zyIUUUUU
	U==



On 2026/8/27 上午7:38, Sean Christopherson wrote:
> +LoongArch folks (question below for you)
> 
> On Wed, Aug 26, 2026, sashiko-bot@kernel.org wrote:
>>> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
>>> index 5a7a455b53875..70906a0d1003c 100644
>>> --- a/tools/testing/selftests/kvm/include/kvm_util.h
>>> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
>>> @@ -175,7 +175,7 @@ static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
>>>   
>>>   /* Minimum allocated guest virtual and physical addresses */
>>>   #define KVM_UTIL_MIN_VADDR		0x2000
>>> -#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
>>> +#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x200000
>>
>> [Severity: High]
>> Does bumping the minimum GPA to 0x200000 cause the guest page tables to overlap
>> with the VGIC redistributor on ARM64?
> 
> This is definitely a Marc/Oliver question.  FWIW, I didn't see failures on arm64,
> but I also have no idea if the hardware I was using supports the v3 tests, so
> it's entirely possible this is a real and obvious problem.
> 
>> In tools/testing/selftests/kvm/arm64/vgic_init.c:subtest_v3_redist_regions(),
>> the redistributor is hardcoded to be placed at the same address:
>>
>>      addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
>>      kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>>                          KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
>>
>> Because KVM maps the redistributor over memory, wouldn't the hardware MMU's
>> stage-1 page table walk attempt to read page table entries from an emulated IO
>> region?
>>
>> This seems like it would cause a stage-2 fault that KVM cannot handle for a
>> stage-1 page table walk, leading to an infinite exception loop.
>>
>> Additionally, does starting allocations at 0x200000 severely reduce the
>> available memory in memslot 0?
>>
>> In tools/testing/selftests/kvm/lib/kvm_util.c:vm_nr_pages_required(), memslot 0
>> is sized to be just slightly larger than 2MB:
>>
>>      nr_pages = 512;
>>      
>>      /* Account for the per-vCPU stacks on behalf of the test. */
>>      nr_pages += nr_runnable_vcpus * DEFAULT_STACK_PGS;
> 
> Ugh, right, because this doesn't change the base of the memslot.
> 
> Why does LoongArch use 0x200000 instead of 0x180000 as the base?  I switched the
> common macro purely because I thought it would be the path of least resistance,
> but maybe "fixing" LoongArch to use KVM_GUEST_PAGE_TABLE_MIN_PADDR is easier?
It is no limitation on LoongArch with physical address, the common 
address 0x180000 is ok. Originally it is to add huge page on VM side in 
future, it seems that it is VA address macro KVM_UTIL_MIN_VADDR rather 
than PA address for page table for huge page purpose.

Regards
Bibo Mao
> 
>> It seems like this leaves only a few pages for page tables. If a test has
>> multiple vCPUs, wouldn't it exhaust this tiny pool and trigger the abort in
>> tools/testing/selftests/kvm/lib/kvm_util.c:____vm_phy_pages_alloc()?
>>
>>      enomem:
>>          fprintf(stderr, "No guest physical page available, min_gpa: 0x%lx "
>>                  "page_size: 0x%x memslot: %u\n",
>>                  min_gpa, vm->page_size, memslot);
>>          fputs("---- vm dump ----\n", stderr);
>>          vm_dump(stderr, vm, 2);
>>          abort();
>>
>>>   
>>>   #define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
>>>   #define DEFAULT_STACK_PGS		5
>>
>> -- 
>> Sashiko AI review · https://sashiko.dev/#/patchset/20260826230511.972824-1-seanjc@google.com?part=2

