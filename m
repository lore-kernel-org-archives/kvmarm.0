Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE43DC433E1
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 15:54:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 345C1206F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 15:54:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Fc6AThDw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 345C1206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 661444B2AF;
	Wed, 22 Jul 2020 11:54:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2e3ovAPeEeiz; Wed, 22 Jul 2020 11:54:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 460084B2AC;
	Wed, 22 Jul 2020 11:54:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FA4D4B2AA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 11:54:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EOSXvxd160eK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 11:54:34 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05FC74B2A5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 11:54:33 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id 88so2407610wrh.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 08:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=MIgLg/+oCtXlnnVfAH5YGWvDn4tjulz+CHstgUNDuBI=;
 b=Fc6AThDwpMZFaDh1J0ZF6aEYxH5PWsiLQnsPcR1msZjugsxaTlPNJI1EaPiYtBVUrL
 w7/aLZZWVHoz96ozYeZPpGKs1CgLpnSC8NvJMSz1tAty6ZTzfV2MIHXG2k1Ap+gkx6KW
 uR8LAOJFitbxsqxEeqS85LtqoOb9fLCCRKzFz2Jp2jcPk7sBGzwJPzuK4yNzDm12i5Q2
 +Br4rSACN+TBzT16HLMpPbKnDWFd3VexUwg9izcccJw/AYqrjWCWt1g47A231rQxUTIr
 H0kYmZqtfksQSJpjjrgRTWNLWAJFJ1JDmFIZdeOQz1sBGfeS0uDm/K3gFJoGV/AExT7P
 ksmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MIgLg/+oCtXlnnVfAH5YGWvDn4tjulz+CHstgUNDuBI=;
 b=LHgeFKced3xLBjgJt5DbLWT87onSrtCHHTJqG+d3yJAO5gYnJ2EDgVQMCtohi27xPy
 lr6T94xeevji7ikFEpex/PSnq16zmoDTyhEGXNzo5+JgrcVuwPZlrpZvHIxk/pjuyxjU
 jGBDunZ8zCL+rATl5CMRyg6QIHxmebGAPnLtDzKcTktYEvsJrx5gLGZvEUie7sisrE2G
 LcS44OxQydohkHddhE3X614Jgn9vU9Yrq/lY23NKuqxNUF4YnOcAhv5GiTHzfWRS6zSW
 DQJr+XRDDd0xqfJigtPcTXQawP3Xj1GKD7zDYDlq8VeDyPR/w8XIB7ly4dEGTv+LWkL0
 6u3Q==
X-Gm-Message-State: AOAM530phDYZIzfQ3FEztBA73xMUkmg3O5qqGFuuDtSjgxAG4JtmXvzu
 uhR4QcARSI24EFEaBGPRESTbXg==
X-Google-Smtp-Source: ABdhPJyQ3z9VjiLaef75OMhJ7VefC8duEZSjc0/Ra37mpKst2cgL8HBdMjFok5IZBXkFsUtMCGezDQ==
X-Received: by 2002:adf:ed88:: with SMTP id c8mr169859wro.233.1595433272651;
 Wed, 22 Jul 2020 08:54:32 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id c7sm378288wrq.58.2020.07.22.08.54.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Jul 2020 08:54:31 -0700 (PDT)
Date: Wed, 22 Jul 2020 16:54:28 +0100
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Don't inherit exec permission across
 page-table levels
Message-ID: <20200722155428.GA275809@google.com>
References: <20200722131511.14639-1-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200722131511.14639-1-will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hey Will,

On Wednesday 22 Jul 2020 at 14:15:10 (+0100), Will Deacon wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8c0035cab6b6..69dc36d1d486 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1326,7 +1326,7 @@ static bool stage2_get_leaf_entry(struct kvm *kvm, phys_addr_t addr,
>  	return true;
>  }
>  
> -static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
> +static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr, unsigned long sz)
>  {
>  	pud_t *pudp;
>  	pmd_t *pmdp;
> @@ -1338,9 +1338,9 @@ static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
>  		return false;
>  
>  	if (pudp)
> -		return kvm_s2pud_exec(pudp);
> +		return sz == PUD_SIZE && kvm_s2pud_exec(pudp);
>  	else if (pmdp)
> -		return kvm_s2pmd_exec(pmdp);
> +		return sz == PMD_SIZE && kvm_s2pmd_exec(pmdp);
>  	else
>  		return kvm_s2pte_exec(ptep);

This wants a 'sz == PAGE_SIZE' check, otherwise you'll happily inherit
the exec flag when a PTE has exec rights while you create a block
mapping on top.

Also, I think it should be safe to make the PMD and PUD case more
permissive, as 'sz <= PMD_SIZE' for instance, as the icache
invalidation shouldn't be an issue there? That probably doesn't matter
all that much though.

>  }
> @@ -1958,7 +1958,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * execute permissions, and we preserve whatever we have.
>  	 */
>  	needs_exec = exec_fault ||
> -		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
> +		(fault_status == FSC_PERM &&
> +		 stage2_is_exec(kvm, fault_ipa, vma_pagesize));
>  
>  	if (vma_pagesize == PUD_SIZE) {
>  		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
> -- 
> 2.28.0.rc0.105.gf9edc3c819-goog
> 

FWIW, I reproduced the issue with a dummy guest accessing memory just
the wrong way, and toggling dirty logging at the right moment. And this
patch + my suggestion above seems to cure things. So, with the above
applied:

Reviewed-by: Quentin Perret <qperret@google.com>
Tested-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
