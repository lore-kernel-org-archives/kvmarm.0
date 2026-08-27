Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48AC3644BE;
	Thu, 27 Aug 2026 06:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787813050; cv=none; b=YX4O1dNHSoCs7iah+YatQza12HRLaouO9MTCDwEDaNuQHi717hD8/mcAYJl2il+GdVR2EljPPproW3OnZQS/+e1/I4D29LC2lmRPd1YDNayuzzKDtDaClERRVLbzuvvv4dbeykW6ib00men1doS5B6zZeiW6KQcS0oJmS+ctaZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787813050; c=relaxed/simple;
	bh=gH9GxUtMX3ZyT5grThk9F17Hlp570HWZH/x+4ozovWU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=aELjbRKcbg9fE1PI5QoK0OPgwCU5/8QgnJ5qBvzjjNN1jUAMaWqD3jaP3HVTioEgAsTygsqhNwK/WBiJgalGqIWTHMb58EqUU8BOCdhM/A4P6fkzlpr0ZQtGyVCxahkzwTDZU2euFZJeZPUCkNUhNdhMngySq7YqUN4P3XZmgVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Ax29G23I9qoJgFAA--.15846S3;
	Thu, 27 Aug 2026 14:44:06 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxpMyw3I9qFekTAA--.11563S2;
	Thu, 27 Aug 2026 14:44:03 +0800 (CST)
Subject: Re: [PATCH 03/20] KVM: selftests: Use vm_alloc_page_table() to
 allocate LoongArch page tables
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
 Ritesh Harjani <ritesh.list@gmail.com>
References: <20260826230511.972824-1-seanjc@google.com>
 <20260826230511.972824-4-seanjc@google.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <9b5244ae-5927-b775-e0c4-deaefa9961e7@loongson.cn>
Date: Thu, 27 Aug 2026 14:43:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260826230511.972824-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxpMyw3I9qFekTAA--.11563S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Kr17CrW3XF18AFyUJr4UJrc_yoW8WFy3pa
	4kCry0kr4rGw17KrZ7Gwn2qFyxKFs7GrWxAF1ftry8ZwnrAryIqrs7KF9rXa45Z3yvv3WS
	vF1I9r4fZF48Z3XCm3ZEXasCq-sJn29KB7ZKAUJUUUUd529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1q6r43M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUtVW8ZwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jCMKZUUU
	UU=



On 2026/8/27 上午7:04, Sean Christopherson wrote:
> Now that KVM_GUEST_PAGE_TABLE_MIN_PADDR == LOONGARCH_PAGE_TABLE_PHYS_MIN,
> use the common vm_alloc_page_table() instead of open coding the same.
> 
> Opportunistically drop the assert that the allocation succeeded, as the
> allocator itself guarantees success.
> 
> For all intents and purposes, no functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/lib/loongarch/processor.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
> index 47bbde3e205a..fcd41bc6fbda 100644
> --- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
> +++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
> @@ -9,7 +9,6 @@
>   #include "processor.h"
>   #include "ucall_common.h"
>   
> -#define LOONGARCH_PAGE_TABLE_PHYS_MIN		0x200000
>   #define LOONGARCH_GUEST_STACK_VADDR_MIN		0x200000
>   
>   static gpa_t invalid_pgtable[4];
> @@ -57,9 +56,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>   	child = table = 0;
>   	for (i = 0; i < vm->mmu.pgtable_levels; i++) {
>   		invalid_pgtable[i] = child;
> -		table = vm_phy_page_alloc(vm, LOONGARCH_PAGE_TABLE_PHYS_MIN,
> -				vm->memslots[MEM_REGION_PT]);
> -		TEST_ASSERT(table, "Fail to allocate page tale at level %d\n", i);
> +		table = vm_alloc_page_table(vm);
>   		virt_set_pgtable(vm, table, child);
>   		child = table;
>   	}
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>

