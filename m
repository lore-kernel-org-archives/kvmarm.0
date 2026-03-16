Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87BD2F872
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 19:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773690361; cv=pass; b=BRtbhDjAUUjE4UMyUovFsuEitHcSKZVbnM0tfwdiVRtbrHdECuJhlUKXRNh3oUG0QMo92zQMKFa8dKWE9FKMTrc8xpwlhXPjSTcIPUzbS4YevaEtt6IEOOablz2JHzMgw9dLKh0Ddf9N/h840SLnoJ04MeM5v4Sq4/HDn5Jeuls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773690361; c=relaxed/simple;
	bh=YKUoL6gMzoXcPPEHwWAlRR25PiaOdj8yEfWHQWJxGb0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JCaJudr2Ywrik3rmO2+EfzrESSkA12DBYdy81+nZCKlMLmzOhCEmFea5BQiH2qEIeaqBDrGfXJi2d+DlpXtPt9GP8SLEjtyEMGiYtI8M3BSQCxBbWc1ij2F2uCma5b3u8zgN6T4qRFNkObBdHQEY/uJe/2RIkEfl77CyJ57joQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hedewemO; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hedewemO"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-509069a7a7fso147121cf.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 12:45:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773690359; cv=none;
        d=google.com; s=arc-20240605;
        b=BCgBkxpcevzYdJCOH+bkCOsrgsJe7EszJy1/cj5JLSxukEolv0V7GAnglMl3yiLi4B
         Xkr2BEi2qNg6Mf2XALPo9i+opcDG7jg/ThXRBudoLiQ+aQrffFLDCH+gmxUI5MMgADKP
         PR9thUkFUR5uYMnXWMkuup1JK1E0bwSy19Bt5hOunFlmCo62dbaICCPgLzBaqGNggOK8
         3U/MiuBkMa0vQxL1UvGgsEB6l9ZJCTT4GVUrkn5S0DCGg2Jvzlqyb3p/swEwrYSUDYgW
         IAnMiPN0RE9dK9ruhQlqI1eb9UAlKZeexfAM9G1ILMgLuUp8fG4Hxr7TsGCDODhsspZt
         mgog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=K/XljB+DzgWrRFl21SQKsmodBlgq6W2fULdZ4nu2KB4=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=XibWFJ0FHI8+rgG4BODoDfPcBpfMhNH1EraFYGKA38d7vPrrO5FmR9E6EmH3ZVHG7C
         ZfhHCBbY34KONGWGKrTyc7bfKelteE4ubOIYJF5ZUUDh5UVf7ac0KxqSCKVoufMrttV7
         DtOnfpkrxquJMRPfOU+TP0UUorbygZHgmYmPLNyRdpXGlY9sqtdlgAMVnIHShuFoOteG
         xN9QTS2OSZeUd0ZxpyKBxdGcQPFAHXZEnCpVduRRe/UXb3OsLkp4hYIjFfJhq3SbWGXf
         x8JDvCJb+I1DSLu+q6pBu1N49ya562WdngEIV0cNlMkdKL5/lq85gWz+mi16Gq55BzTg
         if+Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773690359; x=1774295159; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K/XljB+DzgWrRFl21SQKsmodBlgq6W2fULdZ4nu2KB4=;
        b=hedewemObGRHaKcQ7cTEIixJdDuJxhkn3GiAGMBVJQOqZtkHLRy6V6LTB1a4/3BHvk
         y1/Hi/wvhhXZyxMazbNCZHIjJw1LogHVi5U1gQiUuU2VlCPR5Gx0nRZ2oxGR00cMyT8S
         4dnUYHabYQkKB7/UMWUnZ4rYFrr0kktamxbo5pz/DOAsqcI7Hdu3vLoNWsMCt2CooXQb
         gv817chL9qGX7XODBj77MmF4ZLWNYsyI3LOSOIJXgoBCuaCyLIc9KTyG7pWzBLdVEwqY
         z6sRJ0djIv2ogrl/jfXdXZp9EePYteMxid7u79JFtKwDKghLR6jHLIhGOKRfTty8wk/4
         Im3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773690359; x=1774295159;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K/XljB+DzgWrRFl21SQKsmodBlgq6W2fULdZ4nu2KB4=;
        b=jJeYgTRqpmdTstx1hqvY07uAsZam7gwp69ydVQygee7WlrmvGnvcYANa33eKRE20qs
         iaTcJtDVhroDPc7z11TgSqBzesqvjf/xEz/UJ013bnvHsuKaUacPipCz5c8ydCG2ApFA
         gl1D9KRabyJiE81GoSyPfpUMvJRnydGOaFBQFuAtzrN6Px4/XAKJYrRQVv8vDLJMTynI
         jEmH8EsDU7Pa7pD43EOdY0fSN9+EPw1L6fLlrGBVZV6O1P4v+PucbCNsJDD/EIgiYG0j
         6UFCuHdRo/2GCeuXaryGa3y2qpcgtR09QaKsBMMVMohOU8am0M9E+Bdn9gV0NrcCzT2q
         1fEQ==
X-Gm-Message-State: AOJu0YyVDFDdauT2wAJcbfhLUWIkMtGEhiqFQTBOlADBhQJKq50vT/5D
	mD/KWdcN0kQUfwHwtRscOvbbm98bi8RIYXqoNNUFTUTYfBrPRF+OMrsvBTt/biptzhbqktA8yg3
	N6Y4brsTjjJw7mDXydyVvDhmrBHG8ucnn3azdmI9L
X-Gm-Gg: ATEYQzxR4KMDCn3bg8VQC7J6oJHOe0KKA+Wj2pSTZ/kDoCFj0odjwLuUmLIDWSzbAP6
	jw9PNxzHRn562oHAWCk5p25CyX/y6xH+4l/o4/XBUToaJ7uqmBbsR+7E2oxIh1dDa2yTHAztyCd
	JTd0bQKZiBvFjR7dkx7eV8vTI3dJY6DOCCF1KjfpTZ14/+esfOWEwJDaoXLUuFDtCtMapC7P/rR
	21HeIDk6dmUxSe4Nm2DrT7ZItFOVqyw7/xoQrLFSBjSRKssyVQCgPULwRQlGlu2RRmIgqIuznZa
	N0zYrDOX
X-Received: by 2002:ac8:5acd:0:b0:506:1f23:e22c with SMTP id
 d75a77b69052e-50998d3ad15mr456311cf.6.1773690358263; Mon, 16 Mar 2026
 12:45:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 16 Mar 2026 19:45:20 +0000
X-Gm-Features: AaiRm53vnZJxjvhwHPVI4NgCZVcmbKDWdM_VkB7D1-YURQfFQInZ6ytFCm9YQso
Message-ID: <CA+EHjTxysP-uBzpW1mg=6i8KnmgdDsymn=t2a6hgGho=sf74sA@mail.gmail.com>
Subject: Re: [PATCH 00/17] KVM: arm64: More user_mem_abort() rework
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> Piqued by Fuad's initial set of patches[1] splitting user_mem_abort()
> into more "edible" functions, I've added my on take on top of it with
> a few goals in mind:

I'm glad I piqued your interest with these patches. I had a look at
the final result, and it looks good. I will start reviewing this
series in detail soon!

Thanks,
/fuad

> - contextualise the state by splitting kvm_s2_fault into more granular
>   structures
>
> - reduce the amount of state that is visible and/or mutable by any
>   single function
>
> - reduce the number of variable that simply cache state that is
>   already implicitly available (and often only a helper away)
>
> I find the result reasonably attractive, and throwing it at a couple
> of machines didn't result in anything out of the ordinary.
>
> For those interested, I have stashed a branch at [2], and I'd
> appreciate some feedback on the outcome.
>
> [1] https://lore.kernel.org/all/20260306140232.2193802-1-tabba@google.com/
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=hack/user_mem_abort-rework
>
> Marc Zyngier (17):
>   KVM: arm64: Kill fault->ipa
>   KVM: arm64: Make fault_ipa immutable
>   KVM: arm64: Move fault context to const structure
>   KVM: arm64: Replace fault_is_perm with a helper
>   KVM: arm64: Constrain fault_granule to kvm_s2_fault_map()
>   KVM: arm64: Kill write_fault from kvm_s2_fault
>   KVM: arm64: Kill exec_fault from kvm_s2_fault
>   KVM: arm64: Kill topup_memcache from kvm_s2_fault
>   KVM: arm64: Move VMA-related information to kvm_s2_fault_vma_info
>   KVM: arm64: Kill logging_active from kvm_s2_fault
>   KVM: arm64: Restrict the scope of the 'writable' attribute
>   KVM: arm64: Move kvm_s2_fault.{pfn,page} to kvm_s2_vma_info
>   KVM: arm64: Replace force_pte with a max_map_size attribute
>   KVM: arm64: Move device mapping management into kvm_s2_fault_pin_pfn()
>   KVM: arm64: Directly expose mapping prot and kill kvm_s2_fault
>   KVM: arm64: Simplify integration of adjust_nested_*_perms()
>   KVM: arm64: Convert gmem_abort() to struct kvm_s2_fault_desc
>
>  arch/arm64/kvm/mmu.c | 428 ++++++++++++++++++++++---------------------
>  1 file changed, 223 insertions(+), 205 deletions(-)
>
> --
> 2.47.3
>
