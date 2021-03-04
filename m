Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CB9C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 20:03:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57A2E64F70
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 20:03:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57A2E64F70
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F20E84B4A3;
	Thu,  4 Mar 2021 15:03:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FOA5zDwnYBxz; Thu,  4 Mar 2021 15:03:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4E904B3D0;
	Thu,  4 Mar 2021 15:03:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C367E4B34C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 15:03:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aVZdBF85jMLp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 15:03:43 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E11384B322
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 15:03:42 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 352FE64F65;
 Thu,  4 Mar 2021 20:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614888221;
 bh=U98Si46P9QGICBUxtNMdo2gi+WMxJtL8qV9OiXNLz/g=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=U4gN8l38meTixs38uXpwshwzF5+yHfcTiLAS+WdCPLbxYXrlkbU8LnAcwsYLd8HZn
 FPczhctWD+SdQO4jwsx5UhtC2onXyL5dt/nrLzLpt4CMLx+RTCAMK++uqcogKDeaPe
 kqynj+Kb7qnAO7rJjCWuPASACOtt2/Q0m7aQSKKuBf5VvZxBh5Dl0DstNLJtBcMhJl
 21a5SCZ83VWuZ/8+eOtKUadSKTbDPzJK7iIrYAKl2hRvY+CAmiz0wj7y+uiGLgn1VQ
 62YQbH0sgziQWESXpm/kU5XlICQSWxeFyPeS71LfQ8uf82+/Qaj4Pco/qlfRx5dBff
 2NqXoQCem14IA==
Date: Thu, 4 Mar 2021 20:03:36 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 27/32] KVM: arm64: Refactor stage2_map_set_prot_attr()
Message-ID: <20210304200335.GG21950@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-28-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-28-qperret@google.com>
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

On Tue, Mar 02, 2021 at 02:59:57PM +0000, Quentin Perret wrote:
> In order to ease its re-use in other code paths, refactor
> stage2_map_set_prot_attr() to not depend on a stage2_map_data struct.
> No functional change intended.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 8e7059fcfd40..8aa01a9e2603 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -494,8 +494,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
>  	return vtcr;
>  }
>  
> -static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
> -				    struct stage2_map_data *data)
> +static kvm_pte_t stage2_get_prot_attr(enum kvm_pgtable_prot prot)
>  {
>  	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
>  	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
> @@ -504,15 +503,15 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
>  
>  	if (prot & KVM_PGTABLE_PROT_NONE) {
>  		if (prot != KVM_PGTABLE_PROT_NONE)
> -			return -EINVAL;
> +			return 0;

Hmm, does the architecture actually say that having all these attributes
as 0 is illegal? If not, I think it would be better to keep the int return
code and replace the 'data' parameter with a pointer to a kvm_pte_t.

Does that work?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
