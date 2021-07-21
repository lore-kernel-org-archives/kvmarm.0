Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73346C12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 08:38:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E6A346101E
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 08:38:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6A346101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA994B0E9;
	Wed, 21 Jul 2021 04:38:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BmUw4QFPdmGb; Wed, 21 Jul 2021 04:38:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F6FA4B0E8;
	Wed, 21 Jul 2021 04:38:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 504784B0E8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 04:38:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iaFSnrBBCtJD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 04:38:35 -0400 (EDT)
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com
 [209.85.161.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39C8C4B0E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 04:38:35 -0400 (EDT)
Received: by mail-oo1-f43.google.com with SMTP id
 a17-20020a4ad5d10000b0290263c143bcb2so393905oot.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 01:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=hjk9wYDN8kF50l88X0tsNPFKkVLnNkYeT23mxxv/7SU=;
 b=hfZh63wEsME9LvocLpRlEw6rVj1VQ/v2IP8BtPmf0LPzZCTj2bN5J3t708OsoRiTeT
 05sBX9PNxg98AWKgt1OiqvVFL3v6P5xH3fXY0zrTZXW+BcdR+xAT6CsFcdTgZHMghUb1
 wI76eJkMMogT83dSC+fvHNUwsZDEiBaGIBCk9noNDVYjDyoxlJMEgh4EH8mvMQW+2goj
 cSB+zyC1L4CjC0WmVP5Nl0grIimlVFIiRuS0h209pZOjYNth9pVSWS62D35mhmDXIgZ5
 lf1GZX7lZLb5zANyF51wURmgOtTSXCumIGGj2X8RuM+kbpiZddh4CgUlVdKh+AxLiDpJ
 t57g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=hjk9wYDN8kF50l88X0tsNPFKkVLnNkYeT23mxxv/7SU=;
 b=ePGo/ZYgBkeCMX1OnQYtQ3sT79tvy+cO0jFllUc48A07F9btYKhZ640qcpqGKl76gX
 Fnb5iPaDHL8zCFqKNEwtUdDLMStPlRDpgEjs9Kwcbeoj/Ols8hJQeF4lTKcfCoOJjaTw
 K2XoSnUFNstBlJWXZED24MkcYO5mc66WMtjE2olPlUALH6FDTZmSLjZC5nY3MuVPznAx
 odNnjZ8FWw1Sa/bZCyC6B7dHhKcyH4owDCc9EptwbgD7/K9NGglaOkKpdyktQU/hsAw9
 JRjEqLYzctSZPDU1sRDC3sN+ByyWaZO+SiWkpY1QOpn+DPkzZikh4TaYPjFdDyrS6vh/
 ANOw==
X-Gm-Message-State: AOAM531bAm/d3URAJqb76qTCjXZIGPIq7bKSI399bz4/USQjU1MeC09l
 R1n1eodsQ/lLh1EIwOE/Tiu77HthHrTXwk+NykSRdg==
X-Google-Smtp-Source: ABdhPJy//VB1TOY10+y4WgHDnbceTtCEaCsqZmkKqh7tjjUE/NPaPwrvOM7CfoskWl8rUmKPhGYBa3HPSWiZvxL9j2Q=
X-Received: by 2002:a4a:e14f:: with SMTP id p15mr6493966oot.42.1626856714449; 
 Wed, 21 Jul 2021 01:38:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-13-qperret@google.com>
In-Reply-To: <20210719104735.3681732-13-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 21 Jul 2021 09:37:58 +0100
Message-ID: <CA+EHjTxnkhDJTAokEA7PsaL9VAZ296Gp3B8CAu4cMSqp67MNwA@mail.gmail.com>
Subject: Re: [PATCH 12/14] KVM: arm64: Refactor pkvm_pgtable locking
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
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

Hi Quentin,

On Mon, Jul 19, 2021 at 11:48 AM Quentin Perret <qperret@google.com> wrote:
>
> Refactor the hypervisor stage-1 locking in nVHE protected mode to expose
> a new pkvm_create_mappings_locked() function. This will be used in later
> patches to allow walking and changing the hypervisor stage-1 without
> releasing the lock.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/mm.c         | 16 ++++++++++++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> index 8ec3a5a7744b..c76d7136ed9b 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -23,6 +23,7 @@ int hyp_map_vectors(void);
>  int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
>  int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
>  int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
> +int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
>  int __pkvm_create_mappings(unsigned long start, unsigned long size,
>                            unsigned long phys, enum kvm_pgtable_prot prot);
>  unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,

The locking logic seems to be consistent, with pkvm_create_mappings()
holding the lock for the whole duration of the operation rather than
per-iteration.

It would be nice though to document which lock should be held for the
_locked versions.

Thanks,
/fuad




> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index a8efdf0f9003..dde22e2a322a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -67,7 +67,7 @@ unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
>         return addr;
>  }
>
> -int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> +int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot)
>  {
>         unsigned long start = (unsigned long)from;
>         unsigned long end = (unsigned long)to;
> @@ -81,7 +81,8 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
>                 int err;
>
>                 phys = hyp_virt_to_phys((void *)virt_addr);
> -               err = __pkvm_create_mappings(virt_addr, PAGE_SIZE, phys, prot);
> +               err = kvm_pgtable_hyp_map(&pkvm_pgtable, virt_addr, PAGE_SIZE,
> +                                         phys, prot);
>                 if (err)
>                         return err;
>         }
> @@ -89,6 +90,17 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
>         return 0;
>  }
>
> +int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> +{
> +       int ret;
> +
> +       hyp_spin_lock(&pkvm_pgd_lock);
> +       ret = pkvm_create_mappings_locked(from, to, prot);
> +       hyp_spin_unlock(&pkvm_pgd_lock);
> +
> +       return ret;
> +}
> +
>  int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back)
>  {
>         unsigned long start, end;
> --
> 2.32.0.402.g57bb445576-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
