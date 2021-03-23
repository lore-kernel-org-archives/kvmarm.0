Return-Path: <SRS0=T+on=IV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECEBC433C1
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 11:52:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 26AFE619B1
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 11:52:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26AFE619B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 859014B32E;
	Tue, 23 Mar 2021 07:52:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gUMcihzR1QoI; Tue, 23 Mar 2021 07:52:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DBAB4B32D;
	Tue, 23 Mar 2021 07:52:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A21E04B31F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 07:52:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vA0C55HXa7IJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Mar 2021 07:52:49 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B43974B29E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 07:52:49 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F4V7933ccz19Gd0;
 Tue, 23 Mar 2021 19:50:45 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Mar 2021 19:52:38 +0800
Subject: Re: [PATCH 1/7] KVM: arm64: Add two page mapping counters for kvm_stat
To: Yoan Picchi <yoan.picchi@arm.com>, <maz@kernel.org>,
 <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
 <suzuki.poulose@arm.com>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>
References: <20210319161711.24972-1-yoan.picchi@arm.com>
 <20210319161711.24972-2-yoan.picchi@arm.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <fe120fea-b2a3-d80f-38df-2430a0b2029e@huawei.com>
Date: Tue, 23 Mar 2021 19:52:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210319161711.24972-2-yoan.picchi@arm.com>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: catalin.marinas@arm.com, will@kernel.org
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

Hi Yoan,

On 2021/3/20 0:17, Yoan Picchi wrote:
> Add a counter for when a regular page is mapped, and another
> for when a huge page is mapped.
> 
> Signed-off-by: Yoan Picchi <yoan.picchi@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 2 ++
>  arch/arm64/kvm/guest.c            | 2 ++
>  arch/arm64/kvm/mmu.c              | 7 +++++++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3d10e6527..863603285 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -561,6 +561,8 @@ struct kvm_vcpu_stat {
>  	u64 wfi_exit_stat;
>  	u64 mmio_exit_user;
>  	u64 mmio_exit_kernel;
> +	u64 regular_page_mapped;
> +	u64 huge_page_mapped;
>  	u64 exits;
>  };
>  
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 9bbd30e62..14b15fb8f 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -38,6 +38,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	VCPU_STAT("wfi_exit_stat", wfi_exit_stat),
>  	VCPU_STAT("mmio_exit_user", mmio_exit_user),
>  	VCPU_STAT("mmio_exit_kernel", mmio_exit_kernel),
> +	VCPU_STAT("regular_page_mapped", regular_page_mapped),
> +	VCPU_STAT("huge_page_mapped", huge_page_mapped),
>  	VCPU_STAT("exits", exits),
>  	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
>  	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 77cb2d28f..3996b28da 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -914,6 +914,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		mark_page_dirty(kvm, gfn);
>  	}
>  
> +	if (ret >= 0) {
> +		if (vma_pagesize == PAGE_SIZE) {
> +			vcpu->stat.regular_page_mapped++;
> +		} else {
> +			vcpu->stat.huge_page_mapped++;
> +		}
> +	}
This looks too simple, as we don't always map a new regular_page or huge_page here.
We may just relax permission or change mapping size, etc. If we mix these operations,
the stat result seems not very valuable...

Thanks,
Keqian

>  out_unlock:
>  	spin_unlock(&kvm->mmu_lock);
>  	kvm_set_pfn_accessed(pfn);
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
