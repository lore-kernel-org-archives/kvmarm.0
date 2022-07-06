Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99674C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 09:20:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 202DA4C034;
	Wed,  6 Jul 2022 05:20:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8OGIptIz0RVq; Wed,  6 Jul 2022 05:20:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B43464C035;
	Wed,  6 Jul 2022 05:20:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CDA64C032
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 05:20:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qjPVaZR3W5jQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 05:20:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D4264C028
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 05:20:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E64515DB;
 Wed,  6 Jul 2022 02:20:15 -0700 (PDT)
Received: from [10.57.10.18] (unknown [10.57.10.18])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24ED13F66F;
 Wed,  6 Jul 2022 02:20:11 -0700 (PDT)
Message-ID: <33aafc05-daa1-50e0-00ab-dab97bb8a879@arm.com>
Date: Wed, 6 Jul 2022 10:20:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] KVM: arm64: Use the bitmap API to allocate bitmaps
Content-Language: en-US
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <a93d3e94be2003922c7e9652b57e96261cc47641.1656961792.git.christophe.jaillet@wanadoo.fr>
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <a93d3e94be2003922c7e9652b57e96261cc47641.1656961792.git.christophe.jaillet@wanadoo.fr>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On 7/4/22 20:10, Christophe JAILLET wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> While at it, turn a bitmap_clear() into an equivalent bitmap_zero(). It is
> also less verbose.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  arch/arm64/kvm/vmid.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
> index d78ae63d7c15..f4612cdb60ff 100644
> --- a/arch/arm64/kvm/vmid.c
> +++ b/arch/arm64/kvm/vmid.c
> @@ -47,7 +47,7 @@ static void flush_context(void)
>  	int cpu;
>  	u64 vmid;
>  
> -	bitmap_clear(vmid_map, 0, NUM_USER_VMIDS);
> +	bitmap_zero(vmid_map, NUM_USER_VMIDS);
>  
>  	for_each_possible_cpu(cpu) {
>  		vmid = atomic64_xchg_relaxed(&per_cpu(active_vmids, cpu), 0);
> @@ -182,8 +182,7 @@ int kvm_arm_vmid_alloc_init(void)
>  	 */
>  	WARN_ON(NUM_USER_VMIDS - 1 <= num_possible_cpus());
>  	atomic64_set(&vmid_generation, VMID_FIRST_VERSION);
> -	vmid_map = kcalloc(BITS_TO_LONGS(NUM_USER_VMIDS),
> -			   sizeof(*vmid_map), GFP_KERNEL);
> +	vmid_map = bitmap_zalloc(NUM_USER_VMIDS, GFP_KERNEL);
>  	if (!vmid_map)
>  		return -ENOMEM;
>  
> @@ -192,5 +191,5 @@ int kvm_arm_vmid_alloc_init(void)
>  
>  void kvm_arm_vmid_alloc_free(void)
>  {
> -	kfree(vmid_map);
> +	bitmap_free(vmid_map);
>  }

FWIW

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

Cheers
Vladimir
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
