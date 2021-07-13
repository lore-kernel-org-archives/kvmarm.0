Return-Path: <SRS0=yjsw=MF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D918C07E95
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 16:18:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EACE661175
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 16:18:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EACE661175
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FF534A19A;
	Tue, 13 Jul 2021 12:18:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lN5hEaWK17Oq; Tue, 13 Jul 2021 12:18:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB3E14A19E;
	Tue, 13 Jul 2021 12:18:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14DDA40821
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 12:18:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fuUWI+gwkK+U for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Jul 2021 12:18:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D1E24083E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 12:18:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CD206D;
 Tue, 13 Jul 2021 09:18:40 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C11E03F7D8;
 Tue, 13 Jul 2021 09:18:38 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Fix detection of shared VMAs on guest fault
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
References: <20210713114804.594993-1-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <017a25b0-d706-df97-dbba-80d5b21d1779@arm.com>
Date: Tue, 13 Jul 2021 17:18:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713114804.594993-1-maz@kernel.org>
Content-Language: en-GB
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
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

On 13/07/2021 12:48, Marc Zyngier wrote:
> When merging the KVM MTE support, the blob that was interposed between
> the chair and the keyboard experienced a neuronal accident (also known
> as a brain fart), turning a check for VM_SHARED into VM_PFNMAP as it
> was reshuffling some of the code.
> 
> The blob having now come back to its senses, let's restore the
> initial check that the original author got right the first place.
> 
> Fixes: ea7fc1bb1cd1 ("KVM: arm64: Introduce MTE VM feature")
> Cc: Steven Price <steven.price@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Steven Price <steven.price@arm.com>

Somehow this blob missed it too while reviewing the changes you'd made.

Thanks,

Steve

> ---
>  arch/arm64/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3155c9e778f0..0625bf2353c2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -947,7 +947,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		vma_shift = get_vma_page_shift(vma, hva);
>  	}
>  
> -	shared = (vma->vm_flags & VM_PFNMAP);
> +	shared = (vma->vm_flags & VM_SHARED);
>  
>  	switch (vma_shift) {
>  #ifndef __PAGETABLE_PMD_FOLDED
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
