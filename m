Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF212359A68;
	Fri,  8 May 2026 07:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778225072; cv=none; b=eVKcDPmwxqtV3jIgTcXqSSut31vCrwHJvoQHMKjZtsJMwAHawoWPPWqRbceZ+ErsCzulQYHB6VUR2fEx5dwoGFMP8VoywKcooP6rI7dyeCzC4ZTJU4xSJtg8mRi1mlI3op1f+AbvRMScRvRwEJWeXCLthxdPBbGkp/Ax+cOylzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778225072; c=relaxed/simple;
	bh=TI90CHXwtptjDqV8T7my7F6jyD1/4mK2rWz8hwhRW3o=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Ibrww5qC9+0rfK1G9cPCkbAjNlmnY8fDTe7nPy/ZIp1WNLTDwnbKkQP1uXe6QWfgMXYwLZbkLKqQnhpmE1MtyqFqGhKVrNTEpnQqXfDRRPnBKogi9WYm7o0dSHahTuaMSj+AV2T9pQiSc9u6buzOm3pcwtS7Zwpy2oRnXJdIOak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxncCpj_1piM4HAA--.1250S3;
	Fri, 08 May 2026 15:24:25 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxTMKoj_1pUcZ8AA--.38271S3;
	Fri, 08 May 2026 15:24:24 +0800 (CST)
Subject: Re: [PATCH 2/5] KVM: loongarch: Grab MMU lock in
 kvm_arch_flush_shadow_all()
To: James Houghton <jthoughton@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>,
 Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>,
 Ricardo Koller <ricarkol@google.com>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 James Hogan <jhogan@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260504224213.1049426-1-jthoughton@google.com>
 <20260504224213.1049426-3-jthoughton@google.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <f47ec704-813e-e6a2-687b-7076be465a1b@loongson.cn>
Date: Fri, 8 May 2026 15:21:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260504224213.1049426-3-jthoughton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxTMKoj_1pUcZ8AA--.38271S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoW7XFWrCw1UZrW7Kw4rAr13Awc_yoWkCrc_AF
	12yw10grWxJa93X3Wkt3W3tF9Iyw1rCFsavrn7Xr97J3s8t3sakr4jgan3Cr90grWxWFW3
	ArWDZrZ5Zr4avosvyTuYvTs0mTUanT9S1TB71UUUUjUqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbqkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j7BMNUUU
	UU=



On 2026/5/5 上午6:42, James Houghton wrote:
> kvm_arch_flush_shadow_all() may be called concurrently on the same
> `kvm`. This could at least result in accounting mistakes (e.g.
> underflows on `kvm->stat.*pages`).
> 
> Cc: stable@vger.kernel.org
> Fixes: 752e2cd7b4fb ("LoongArch: KVM: Implement kvm mmu operations")
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> Note: This is compile-tested only!
> 
>   arch/loongarch/kvm/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index a7fa458e3360..5dbce9b18e1c 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -486,7 +486,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   
>   void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   {
> -	kvm_flush_range(kvm, 0, kvm->arch.gpa_size >> PAGE_SHIFT, 0);
> +	kvm_flush_range(kvm, 0, kvm->arch.gpa_size >> PAGE_SHIFT, 1);
>   }
>   
>   void kvm_arch_flush_shadow_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>

