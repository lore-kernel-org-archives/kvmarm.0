Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A4CC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 18:48:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B7AA64FD4
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 18:48:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B7AA64FD4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 092DB4B114;
	Thu, 11 Mar 2021 13:48:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m5kJgGenlscZ; Thu, 11 Mar 2021 13:48:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06A244B112;
	Thu, 11 Mar 2021 13:48:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57A174B112
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 13:48:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZEpNFvRVRCfq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 13:48:44 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59C984B109
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 13:48:44 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD2C64FE0;
 Thu, 11 Mar 2021 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615488523;
 bh=jfHJ6GOVhZbFPLB88QSrQHoY4MrIIb7+F7at5DPxqfk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=YKq3LDOC6iUDoX4UfIVEKIMc4PLQXkbXbD0c0GfgtcYH97EDMe1hFsWaGx3W6WiJE
 oyd3jp8e4QHLIf3ZnsS0Sp4ClcCEFwzI1bFrZduWlcC5cs6pNv3CQAzw5ZfkTIxv5Y
 L6JohplRajSKs2nJGlaFWZjIhLSwb6Vc8QMjRs4h8uVxwpBMs35KqnMx4yWCP3emfF
 CCPs/cyNOEKyF/RqxhceU/w28G7yZlvr7kBe1H4FaUr/OM298ZNXgbQ4Qz4AIbVHqZ
 jN3bmP6QR/fvcbPLpUfhbyXthseEmB2D3vgkSAopIpYIEdmTwdjyX5KQpb6hy/8g6+
 H1XwUr1dbURhg==
Date: Thu, 11 Mar 2021 18:48:36 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v4 29/34] KVM: arm64: Refactor stage2_map_set_prot_attr()
Message-ID: <20210311184836.GA31586@willie-the-truck>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-30-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310175751.3320106-30-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 10, 2021 at 05:57:46PM +0000, Quentin Perret wrote:
> In order to ease its re-use in other code paths, refactor
> stage2_map_set_prot_attr() to not depend on a stage2_map_data struct.
> No functional change intended.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index e4670b639726..c16e0306dd9a 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -489,8 +489,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
>  	return vtcr;
>  }
>  
> -static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
> -				    struct stage2_map_data *data)
> +static int stage2_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>  {
>  	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
>  	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
> @@ -510,7 +509,8 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
>  
>  	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
>  	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> -	data->attr = attr;
> +	*ptep = attr;
> +
>  	return 0;
>  }
>  
> @@ -728,7 +728,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		.arg		= &map_data,
>  	};
>  
> -	ret = stage2_map_set_prot_attr(prot, &map_data);
> +	ret = stage2_set_prot_attr(prot, &map_data.attr);
>  	if (ret)
>  		return ret;

(nit: this is now different to hyp_map_set_prot_attr() -- can we do the same
thing there, please?)

With that:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
