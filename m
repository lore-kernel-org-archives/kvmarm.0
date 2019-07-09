Return-Path: <SRS0=/6PO=VG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E60C606DA
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jul 2019 09:59:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E6ABE2080C
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jul 2019 09:59:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6ABE2080C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0D94A543;
	Tue,  9 Jul 2019 05:59:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zh5gR+-soqHo; Tue,  9 Jul 2019 05:59:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A86D4A540;
	Tue,  9 Jul 2019 05:59:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 430E34A53D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jul 2019 05:59:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r4m8Im7L2ufV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jul 2019 05:59:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C28B04A530
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jul 2019 05:59:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D0AE28;
 Tue,  9 Jul 2019 02:59:09 -0700 (PDT)
Received: from [10.1.196.217] (unassigned-hostname.cambridge.arm.com
 [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67F323F738;
 Tue,  9 Jul 2019 02:59:08 -0700 (PDT)
Subject: Re: [PATCH 40/59] KVM: arm64: nv: Don't always start an S2 MMU search
 from the beginning
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-41-marc.zyngier@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ccb11c22-0aa9-7e6a-98b2-acdfa0603eb0@arm.com>
Date: Tue, 9 Jul 2019 10:59:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-41-marc.zyngier@arm.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

On 6/21/19 10:38 AM, Marc Zyngier wrote:
> Starting a S2 MMU search from the beginning all the time means that
> we're potentially nuking a useful context (like we'd potentially
> have on a !VHE KVM guest).
>
> Instead, let's always start the search from the point *after* the
> last allocated context. This should ensure that alternating between
> two EL1 contexts will not result in nuking the whole S2 each time.
>
> lookup_s2_mmu now has a chance to provide a hit.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/nested.c           | 14 ++++++++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b71a7a237f95..b7c44adcdbf3 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -123,6 +123,7 @@ struct kvm_arch {
>  	 */
>  	struct kvm_s2_mmu *nested_mmus;
>  	size_t nested_mmus_size;
> +	int nested_mmus_next;

For consistency, shouldn't nested_mmus_next be zero initialized in
kvm_init_nested (arch/arm64/kvm/nested.c), like nested_mmus and
nested_mmus_size? Not a big deal either way, since struct kvm is allocated using
vzalloc.

>  really
>  	/* VTCR_EL2 value for this VM */
>  	u64    vtcr;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 09afafbdc8fe..214d59019935 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -363,14 +363,24 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
>  	if (s2_mmu)
>  		goto out;
>  
> -	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> -		s2_mmu = &kvm->arch.nested_mmus[i];
> +	/*
> +	 * Make sure we don't always search from the same point, or we
> +	 * will always reuse a potentially active context, leaving
> +	 * free contexts unused.
> +	 */
> +	for (i = kvm->arch.nested_mmus_next;
> +	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
> +	     i++) {
> +		s2_mmu = &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
>  
>  		if (atomic_read(&s2_mmu->refcnt) == 0)
>  			break;
>  	}
>  	BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */
>  
> +	/* Set the scene for the next search */
> +	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
> +
>  	if (kvm_s2_mmu_valid(s2_mmu)) {
>  		/* Clear the old state */
>  		kvm_unmap_stage2_range(s2_mmu, 0, kvm_phys_size(kvm));
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
