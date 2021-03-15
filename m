Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 676F2C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 07:49:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE99064E49
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 07:49:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE99064E49
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 529864B2CF;
	Mon, 15 Mar 2021 03:49:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5vDtAqPh3Z99; Mon, 15 Mar 2021 03:49:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4992A4B2E1;
	Mon, 15 Mar 2021 03:49:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2832D4B2D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 03:49:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xrPcqDws7zoJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 03:49:16 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A8654B2CF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 03:49:16 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DzT6F5WH2zlVnM;
 Mon, 15 Mar 2021 15:47:33 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 15:49:02 +0800
Subject: Re: [PATCH 1/4] KVM: arm64: Hide kvm_mmu_wp_memory_region()
To: Gavin Shan <gshan@redhat.com>, <kvmarm@lists.cs.columbia.edu>
References: <20210315041844.64915-1-gshan@redhat.com>
 <20210315041844.64915-2-gshan@redhat.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <c16969db-480e-3229-9d90-a62a0f7d8a2a@huawei.com>
Date: Mon, 15 Mar 2021 15:49:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210315041844.64915-2-gshan@redhat.com>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org, will@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com
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

Hi Gavin,

This function is only used by mmu.c in the first commit c64735554c0a, so please feel free
to add:

Reviewed-by: Keqian Zhu <zhukeqian1@huawei.com>


Thanks,
Keqian

On 2021/3/15 12:18, Gavin Shan wrote:
> We needn't expose the function as it's only used by mmu.c.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 1 -
>  arch/arm64/kvm/mmu.c              | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3d10e6527f7d..688f2df1957b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -632,7 +632,6 @@ void kvm_arm_resume_guest(struct kvm *kvm);
>  	})
>  
>  void force_vm_exit(const cpumask_t *mask);
> -void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>  
>  int handle_exit(struct kvm_vcpu *vcpu, int exception_index);
>  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 77cb2d28f2a4..84e70f953de6 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -555,7 +555,7 @@ static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_
>   * Acquires kvm_mmu_lock. Called with kvm->slots_lock mutex acquired,
>   * serializing operations for VM memory regions.
>   */
> -void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
> +static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
>  {
>  	struct kvm_memslots *slots = kvm_memslots(kvm);
>  	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
