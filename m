Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC403C6A3A
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773223892; cv=pass; b=ggjlY0FkntK2Z6j8vMJcVEpCePUvQJFq6v2ZsorFWvmk1EyAY4rkxd6yb8r/tpyhBwpoBfLui56ZBWLQWk2kone7GmaQ3MAxR8Tj/LTg+vMj1lR0dsTo08k9tfcrmlg1kLuN1T+/he2jGB8MTVV7pfMm8OD8jdUEG32wm8KV06Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773223892; c=relaxed/simple;
	bh=zzxXXvU9RKCUMkpWDvrlxzk/91zkGKAbI0zSc3/HrrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I0qRcIdkSeXNb52IGjw1hFo3mriDCBHV11i3tcNomA8llhMe4VVXUQvi+pIjF8Sk0Q2g4NhkKCF1W4BjNnkvvmK+Uyru2MbuqXAS0Lmn02dHhVpkPzfUhqQqDxGTuBvLkyvhUUIVlSyT+96BCnnhNmRoJotYrxGi+FhGu5R9h9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e/oo9WS3; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e/oo9WS3"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-509062d829dso408511cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:11:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773223890; cv=none;
        d=google.com; s=arc-20240605;
        b=PtxUPbQqJIwGXUTwIpvvQGzd5TJa+aNlCInwnCr7p3lxN5vJ6uxDY5iH/tJlsLqMrf
         l30950e8P3NLdc3+AX8DFFZXYZspVFdoMbVDf+EEgL23O/NxCpIkzM/1i91RWzHECbkr
         bLHA4NoKR3LR7iYrJO03d1vbnMb3QY5jEaMHxO+awfe0JxbPHs+iPQETiGrBuGRFd3v/
         K4LZZME3wRJSeblaqmk/c/KHndWthnSjcBBk7/nfQKcAA/Mwb2qUBbsX6DDSeRB98YIQ
         A2+Dcr2jhE/NdZr0epYT4+utJAonlg7JZktMc01WjSm5ryFhU9SBETDRZKhzUEgiWqtN
         SyJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=S9G3GwF7me9FsUvlcx2km6nfd0c02NVD1RLBApgqDjU=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=VEK6Cc2AZOYd/Nmr8E+mrbn1BBK9tmOrz2pKhCEPvNcsR+0H51mfWcq08uzqndHTxQ
         uOSGuu+45hDNyI5kx4Ee6GT0i16g9O2aFdDHyyzJh9qHMcizsQhvruadgCx2zgO1iT+N
         ArgPPZ+xCNj46MbRN63Wi9TwWn6Onkx4tObpbKxa0SuiVd8hiLNdC1Xnk80mjbGH095S
         OY9ZiMQ07i4Crl+uTImATQtHagGtQRP7BDNpN0NNdbGREEa14XQwP3X/rcoC+4oEV2eB
         X/QkOblkD3omJdjvpaKFeiA7RPssWFPKGQHcUKZEMXvRYobQkC5Ii9PvyC3+0FWzM/oU
         wKxw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773223890; x=1773828690; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S9G3GwF7me9FsUvlcx2km6nfd0c02NVD1RLBApgqDjU=;
        b=e/oo9WS3iaU052iApJig+yi7dsJWXLhIYGfOrqMUPBu1u4WHm0d9uH8THZVdfVIgE2
         v3L3SjWgn9B6dcpC/6nC4Lo2VydTSS/JKI5YHLD7ceBnCGBGvRIGVemK8gn9i5cLisbf
         Yjxx5axXU0Eh6Q9Z7IGWyUAcq1vKJpuy6L6c4JL3gcA7pPVcWudlX/mB6wzT+dfgQRhi
         rsh3/byenkR3+QpN73DimXqUQGyKZTirF6/wCoA1eCFP7dG+OC0GI2gWFyQY8SYZU2EU
         CKvzfdGPP1qBcjo81f8eSBLE1SfN+/8d+7TPor/r7Q9fPzy9fvNFGYtDUHuRLcHpbVYZ
         /VJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773223890; x=1773828690;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9G3GwF7me9FsUvlcx2km6nfd0c02NVD1RLBApgqDjU=;
        b=Ah/4gm6NSoWouGH+6plnrSB5j4lPV8GdsFnokYrgpu/KgxfKgZYSWF4Qlt6/LIo+Fu
         DnZHfAjhBPk9E9/CQyOHyncaGY5gbVpzFtqcx1xjJO6tdhzqOnvDe56t3fmlliS8D1Ok
         zlxWZe7OHCd+d2lKkz093a6pMvZbc3Daj6FvA6LLCzszKciRVXUhF2oaMIovaJ/BIlPR
         8QBiAxrwnBPAYyZJDl73lPhFN5N7GU2vYuXGopy7UGu3hOF7vKInqBWBGSfgwWclEJDJ
         k08+VD/u4Zb7vy7EZDoh7wQob9LAcmY7fbAbYfTuGY9C9YWExC0r/ZXm1l5jPbepb/YV
         mhKg==
X-Gm-Message-State: AOJu0YyOZWuKBAG1j2JjZK5VR4bsui6mDTsyUsw6jROwtrchI6zjXrIR
	Rawbhmfgt6/FeXiWo9Kub02D7WCI5LvS+FS6uTt6DC1MgCHNpEyehq3SiF9w13Q5a3QnUTlazlr
	rWZUnnRsHKxlJF20FTdiNWF3owW3oTrDF4pH/myAh
X-Gm-Gg: ATEYQzyy1x0Qdf9dM9FPFghXZ/CwUKrWtQSdmDG0/WHvLq2jL2llef++lb6Ip9iP6VQ
	aVW5GzM6r7rRjitF0MUzw0L2ACdVSqJ6nSzneheW7gw5rmVReYV1ARSq/Wbk1BfVcaH3GES3EFh
	GzjXTY5B7UO0NuFL6tD6AMlnZmoj5v7a+ZDqQeBa1rc1f6X8H60nUXuFuXcmC+nS0dtElIzcYmX
	pfnwDb8SVNPz5AfQycwQXdP4k1lrINaoERXsitSL/+o3MHmSV9sTJjpz5UhfuX96UoGBe8/fNIh
	rwkpuATrQ8zzYAjymGH1TClbD8pxZ/AMX9romg==
X-Received: by 2002:a05:622a:649:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-5093801c297mr11760731cf.0.1773223889091; Wed, 11 Mar 2026
 03:11:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-10-will@kernel.org>
In-Reply-To: <20260305144351.17071-10-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:10:51 +0000
X-Gm-Features: AaiRm51wLLcqX-yQ2yuchM8-vCLVMN2vS0uhjH_pET-oWf_5OhyyEHXhYTChr_s
Message-ID: <CA+EHjTw54G1GO775CCGC=C0X6s=4Srg2mJ6uJT6RKJFjfGOpNQ@mail.gmail.com>
Subject: Re: [PATCH v3 09/36] KVM: arm64: Ignore -EAGAIN when mapping in pages
 for the pKVM host
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:44, Will Deacon <will@kernel.org> wrote:
>
> If the host takes a stage-2 translation fault on two CPUs at the same
> time, one of them will get back -EAGAIN from the page-table mapping code
> when it runs into the mapping installed by the other.

I ran into this while porting the Android patches, and this patch
fixed the issue. Thank you.

Reviewed-by: Fuad Tabba <tabba@google.com>

/fuad

> Rather than handle this explicitly in handle_host_mem_abort(), pass the
> new KVM_PGTABLE_WALK_IGNORE_EAGAIN flag to kvm_pgtable_stage2_map() from
> __host_stage2_idmap() and return -EEXIST if host_stage2_adjust_range()
> finds a valid pte. This will avoid having to test for -EAGAIN on the
> reclaim path in subsequent patches.
>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 38f66a56a766..7b0f8ad7b20f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -461,8 +461,15 @@ static bool range_is_memory(u64 start, u64 end)
>  static inline int __host_stage2_idmap(u64 start, u64 end,
>                                       enum kvm_pgtable_prot prot)
>  {
> +       /*
> +        * We don't make permission changes to the host idmap after
> +        * initialisation, so we can squash -EAGAIN to save callers
> +        * having to treat it like success in the case that they try to
> +        * map something that is already mapped.
> +        */
>         return kvm_pgtable_stage2_map(&host_mmu.pgt, start, end - start, start,
> -                                     prot, &host_s2_pool, 0);
> +                                     prot, &host_s2_pool,
> +                                     KVM_PGTABLE_WALK_IGNORE_EAGAIN);
>  }
>
>  /*
> @@ -504,7 +511,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
>                 return ret;
>
>         if (kvm_pte_valid(pte))
> -               return -EAGAIN;
> +               return -EEXIST;
>
>         if (pte) {
>                 WARN_ON(addr_is_memory(addr) &&
> @@ -609,7 +616,6 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>  {
>         struct kvm_vcpu_fault_info fault;
>         u64 esr, addr;
> -       int ret = 0;
>
>         esr = read_sysreg_el2(SYS_ESR);
>         if (!__get_fault_info(esr, &fault)) {
> @@ -628,8 +634,13 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>         BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
>         addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
>
> -       ret = host_stage2_idmap(addr);
> -       BUG_ON(ret && ret != -EAGAIN);
> +       switch (host_stage2_idmap(addr)) {
> +       case -EEXIST:
> +       case 0:
> +               break;
> +       default:
> +               BUG();
> +       }
>  }
>
>  struct check_walk_data {
> --
> 2.53.0.473.g4a7958ca14-goog
>
