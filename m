Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E24EC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 10:29:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE5E04B0BF;
	Thu,  9 Dec 2021 05:29:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zT3T0MlcblXO; Thu,  9 Dec 2021 05:29:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B4F54B0B4;
	Thu,  9 Dec 2021 05:29:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 153254B0B4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 05:29:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L7rtNO1c60Sk for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 05:29:32 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79BD04064F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 05:29:32 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 17651B82413;
 Thu,  9 Dec 2021 10:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0745EC004DD;
 Thu,  9 Dec 2021 10:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639045769;
 bh=/QmpjCuL6s7njp6n+riNneGXXg+eNgJnvQsS9FTssPs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=kg0OeLHSNtdKhMVXmUzK4SbKdfW/VPLENXZuwCaVbwkm3WO4VU8H9W5Tis5BKW2/1
 hwLrw/mYRHZXzd3PuTFvKdF6WA4nzlv+icBWWczLcuscBt3cIajskOgByQRmpV+JI8
 ddtFZja/LVZRt7kzrq2fVnqLfl7KTKBDw7GhZfsDLSfsV0FeGSA5xQZBEb3xhl11uB
 mUEl5zf/Ehn3amARhmC8KMYAC8b92UbnjJBS1cNqb7BpI1CwDDaUPZPuZxJtLAR8TU
 ICRbqfkcKDcZjU2UPInYyCCz2OfMr/bCQNJoqNRwi5lBSJ0Qevao1eN9lEBRiQXRhB
 8QJb5R4CJQJOQ==
Date: Thu, 9 Dec 2021 10:29:24 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 03/15] KVM: arm64: Refcount hyp stage-1 pgtable pages
Message-ID: <20211209102924.GC1833@willie-the-truck>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-4-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211201170411.1561936-4-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Dec 01, 2021 at 05:03:57PM +0000, Quentin Perret wrote:
> To prepare the ground for allowing hyp stage-1 mappings to be removed at
> run-time, update the KVM page-table code to maintain a correct refcount
> using the ->{get,put}_page() function callbacks.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index f8ceebe4982e..768a58835153 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -408,8 +408,10 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  		return false;
>  
>  	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
> -	if (hyp_pte_needs_update(old, new))
> +	if (hyp_pte_needs_update(old, new)) {
>  		smp_store_release(ptep, new);
> +		data->mm_ops->get_page(ptep);

In the case where we're just updating software bits for a valid pte, doesn't
this result in us taking a spurious reference to the page?

> @@ -482,8 +485,16 @@ static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  			   enum kvm_pgtable_walk_flags flag, void * const arg)
>  {
>  	struct kvm_pgtable_mm_ops *mm_ops = arg;
> +	kvm_pte_t pte = *ptep;
> +
> +	if (!kvm_pte_valid(pte))
> +		return 0;
> +
> +	mm_ops->put_page(ptep);
> +
> +	if (kvm_pte_table(pte, level))
> +		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
>  
> -	mm_ops->put_page((void *)kvm_pte_follow(*ptep, mm_ops));
>  	return 0;

This looks pretty similar to the stage-2 walker now, but given how small the
functions are, I'm not sure we'd really gain much by abstracting the "pte
counted" check.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
