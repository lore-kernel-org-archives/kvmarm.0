Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1AB51BE87F;
	Fri,  2 Aug 2024 07:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722584085; cv=none; b=qNc4rGwmNWLyHxihEp0Fy0yoJ+34VAVxI/2knktQXzu7BzjXOnOnFT+bqibCno4gD9bR37U278eAIYYBWJ5cMPp6qDjFVN/J/TE8VUK8jIqRb4opbOI3v3a+Ut+spfwEOH2cluw16rkCDDoyc93xxFCoTfop9W0fD4A8m7FwElI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722584085; c=relaxed/simple;
	bh=28kV5J8/flAVt86/GsEj43NZxtciKgmXFgOHNgHpFQI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Nkt1whhHeHqduO2aeRypfZkO/l/pO76WKHur2omTYhcbhOumMdklxrDUy94fsAcdJUHzlVwkOtRULmmHWNKnBzvIiKobZUl2arE5dZzTmJI5HSU93jUkNTtrFjHWDML8ao+sVq5Xu7SY6Bnm5Hauo8dFEbQ+yvi99Pud2CI1dGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxnOoQjKxmAVoGAA--.22201S3;
	Fri, 02 Aug 2024 15:34:40 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxbuUPjKxm0GILAA--.55848S3;
	Fri, 02 Aug 2024 15:34:39 +0800 (CST)
Subject: Re: [PATCH v12 65/84] KVM: LoongArch: Mark "struct page" pfns
 accessed only in "slow" page fault path
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
 David Stevens <stevensd@chromium.org>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-66-seanjc@google.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <d5405245-edd3-9bc5-0c40-282a30e46fae@loongson.cn>
Date: Fri, 2 Aug 2024 15:34:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240726235234.228822-66-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxbuUPjKxm0GILAA--.55848S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7WFWUJw1rKF47AFWUZFWfCrX_yoW8ZF1xpF
	ZxCwsrtr4rtrn093srta4qvF17Gw4DKr1xX3W2q34FkFnIqw1Y93W8W397WFyUJ392ya1S
	vF1rt3WUWan0vacCm3ZEXasCq-sJn29KB7ZKAUJUUUUk529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUtVW8ZwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUstxhDU
	UUU



On 2024/7/27 上午7:52, Sean Christopherson wrote:
> Mark pages accessed only in the slow path, before dropping mmu_lock when
> faulting in guest memory so that LoongArch can convert to
> kvm_release_faultin_page() without tripping its lockdep assertion on
> mmu_lock being held.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/loongarch/kvm/mmu.c | 20 ++------------------
>   1 file changed, 2 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index 364dd35e0557..52b5c16cf250 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -552,12 +552,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>   {
>   	int ret = 0;
> -	kvm_pfn_t pfn = 0;
>   	kvm_pte_t *ptep, changed, new;
>   	gfn_t gfn = gpa >> PAGE_SHIFT;
>   	struct kvm *kvm = vcpu->kvm;
>   	struct kvm_memory_slot *slot;
> -	struct page *page;
>   
>   	spin_lock(&kvm->mmu_lock);
>   
> @@ -570,8 +568,6 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>   
>   	/* Track access to pages marked old */
>   	new = kvm_pte_mkyoung(*ptep);
> -	/* call kvm_set_pfn_accessed() after unlock */
> -
>   	if (write && !kvm_pte_dirty(new)) {
>   		if (!kvm_pte_write(new)) {
>   			ret = -EFAULT;
> @@ -595,23 +591,11 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>   	}
>   
>   	changed = new ^ (*ptep);
> -	if (changed) {
> +	if (changed)
>   		kvm_set_pte(ptep, new);
> -		pfn = kvm_pte_pfn(new);
> -		page = kvm_pfn_to_refcounted_page(pfn);
> -		if (page)
> -			get_page(page);
> -	}
> +
>   	spin_unlock(&kvm->mmu_lock);
>   
> -	if (changed) {
> -		if (kvm_pte_young(changed))
> -			kvm_set_pfn_accessed(pfn);
> -
> -		if (page)
> -			put_page(page);
> -	}
> -
>   	if (kvm_pte_dirty(changed))
>   		mark_page_dirty(kvm, gfn);
>   
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>

