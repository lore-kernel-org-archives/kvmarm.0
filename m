Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF3A3AE70C
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747914; cv=pass; b=uWDzNgBmHURv5/6zXcldxMTSK7NspJzi+ivkZZOEwYXD/+zajTR/My3rAjYBUBcy8mxNvxIPYYQ+sYWSFOEA8Xzgs7DYb+6PJm2qOH+hmXEXenYKnOd3V4BPl2Hkl1f7l6Xdc3gDNEIB1hUJt7EwTAmF9oXpMAwno5SuPL9NVyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747914; c=relaxed/simple;
	bh=jcsJfBsO1qUKkcQ1Fu2VZ9c9qHC7osweh3hOy15c1GY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RhXOJYnGpoSq/RZA/BHuVfa2iifpsOct9oPXGzAchkGSh7z75vs7WHIVoeMb/sHfhv/i7HZ8u1uuVhu3nsWSPs3HM64VTHF+O3XlimEY8MSzP4AXFK+qfv1x7Z3AcenF14M95QqYe0cOvTHO3jM4A8357AdcnFwyvoHNfN6Bw0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yy4f9hzH; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yy4f9hzH"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5091ed02c54so365461cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 04:45:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773747912; cv=none;
        d=google.com; s=arc-20240605;
        b=WDSdp4XG+sMr8SQFT+5LjwDfAWoNXd/IRciRG6dgDmgvRGFywimRIaeagdM6tHJWr9
         eOtigxbeWAVc8LNLyUiqjgeUQrJkJImPh59Jrr0R6Am3FSqe19DyPMvAi33WZi8pheD0
         HICJuKv8H5LUmZjp5Yvbiga23mPmqjDzoPnf2K7eFfoHtziszsv+lDiALGmu6rY0TqcG
         +i+W8K1Jt6TIY/H7MYT1dvvniO/VmSMnjzpaNKmRgQq4xqEPAB7yRSFN0BaOfvsDudWZ
         QpxEU16NanT6rc+uJnXlg8GqrVi5im1vzKaBK+2nJRsDe17hNgaFMUdD7eny9WAtDbY1
         64EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mSP+5ZiGrT8VoG2czM5Q9RwvJ6j1xtoayCufilySkAw=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=IjeiaIGu2zYvQ2YmKAelG5B0Ot6j9l4izXEEtLSa0i+DG4LwxPGffzzlDnlESLnXzN
         icDnpsfVIuBEBlXyx5DW4PM154JGipKEcRQ8MXDIznJaEQFyn/5gWkJs24g9ZABVqcnr
         EQ27Z1SE4S6VOugVftf77EXCggODuAMz8RYGwzyxBvb40taNeQj74fMUU/w1QMjgZOWX
         1RjUYT/rIsMqx7K/61f9xxN00K6sxCE10fX5o9ikPy9rbnuGc1JwxROTK/a7dROCUMnl
         TvmslYvTNBU2fvgw9HWStyiF4Tuo6r9o7vdaOAlB5FvuC+3Fy9V4JXZ3EutTAxuFpeuL
         pBdw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773747912; x=1774352712; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mSP+5ZiGrT8VoG2czM5Q9RwvJ6j1xtoayCufilySkAw=;
        b=Yy4f9hzHVtgRE/j6i5sydL/nQqZ7ZO7VnRLreAbwkhsEDvdLdMJy5BkH6UXVmKow80
         rCb4t8KIqcd6YaOtHXf3dJIlCNksJFOxOvTjy5bVgo7v77dfUUIYut0imLfBDjH1VmWp
         zLFVk3kEV9cChg2SnvTsHdGXhYSVb9Me4CtvdntQC+08yacwNgr+oVThu/54ZKuMG4bg
         A63RiNUqmim+y2pUd5f+8wO4U9f6IRbFnSce+TEb7PjRqfRZXwVcM0HzmB+Jv8+vofsF
         7wNhEkC1ZPGffqktKeuvhBEcBy+Nawp74T98AvJIvKm1BLhvUk2zTxrD2hUHNoAx8OfD
         Uevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773747912; x=1774352712;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSP+5ZiGrT8VoG2czM5Q9RwvJ6j1xtoayCufilySkAw=;
        b=XhnjfnsKDRc3TJcZB+0yMFr2PxtamoYj1IxxT8hACXSBFFF63hnku45mE1oNdE7Smj
         U5omGxbgAtV5Y6isOeH4AWSjZFPsyOtuhyZ10JVEVqSUMD1ujlP46QOHhdSVfq5Xs9yM
         DBRRArSUVZ8ffTHOW14NjFiBG7WM5ymcSa/BzwtcGl8h8KV7ubxp6Mvb3o5nKqA+C22G
         nF3gETkuzsd8tBlWRM38B5kY8YgV6vxEdwV4qra2J9wdr7xhlnz283F6JFiLTeL1yf6m
         9ez03BhM6WowyQ8l7oey6Mvysbx+QS/sZNUbbKCw8gXGomNfKnGLqV/SukBFMitPuDvQ
         hwPw==
X-Gm-Message-State: AOJu0Yy/1DVX+AOTq8IqVE0/o6V9B1tHhK8iLpMfgaOG7tr/ShMAePnh
	skcca692GzCzGqK5S/hOi022SaK96OEqKrU2B6DymR2taay8CTeTY8OiU8xIWZXAM1KzdQ/32j2
	IpKyXSeVB50nFSF4cBA2VM010B6Ga7j7SUdtxBJuF
X-Gm-Gg: ATEYQzyUHHeA9hO9FZynQ57YzBFyJQOV3e26CLrQXNSkaSo7A/XLluttpU8gUflBWCZ
	GIJriq6Ebu7z6gVxpRa7f27bg+s7f3gP9QXq/LZa04BXtwzhRGn5A53Ee/QFYyj/vYlUHa+BIfi
	Puu3ivDTt7irsxIkYO+cs0QpTIwwv8+Rdyf61xBzzV0Ke5cjqZe7A51kFqL4HkyeVjGvQLJR8Xo
	wBxmv6fBZ4Y25vKWNa46cPDBlUXsvrSptVxIkPwH0bD0bwxdPPtZWWbqIMV30A5LYjQDbCXG5+t
	xiHpdEdAxakf7ZlaRU5B0CLz+yUMpJAbOOx1
X-Received: by 2002:a05:622a:34f:b0:509:1cf9:ea11 with SMTP id
 d75a77b69052e-5099ae36e43mr12562501cf.7.1773747911711; Tue, 17 Mar 2026
 04:45:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-8-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-8-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 11:44:34 +0000
X-Gm-Features: AaiRm51lXiyKLg4OKdcVXNwJmHZcYFDhdZMB_eojSJsLTLxE5Cp49WmpL5pRhKA
Message-ID: <CA+EHjTzjFvVP+E-4rtiup2FibCO1cuti-YEF4WtdbMMz1HkXPA@mail.gmail.com>
Subject: Re: [PATCH 07/17] KVM: arm64: Kill exec_fault from kvm_s2_fault
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> Similarly to write_fault, exec_fault can be advantageously replaced
> by the kvm_vcpu_trap_is_exec_fault() predicate where needed.
>
> Another one bites the dust...
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/mmu.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 86950acbd7e6b..11820e39ad8e1 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1711,7 +1711,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>  }
>
>  struct kvm_s2_fault {
> -       bool exec_fault;
>         bool writable;
>         bool topup_memcache;
>         bool mte_allowed;
> @@ -1857,7 +1856,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                 fault->writable = false;
>         }
>
> -       if (fault->exec_fault && fault->s2_force_noncacheable)
> +       if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && fault->s2_force_noncacheable)
>                 return -ENOEXEC;
>
>         /*
> @@ -1877,7 +1876,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>         if (fault->writable)
>                 fault->prot |= KVM_PGTABLE_PROT_W;
>
> -       if (fault->exec_fault)
> +       if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
>                 fault->prot |= KVM_PGTABLE_PROT_X;
>
>         if (fault->s2_force_noncacheable)
> @@ -1984,7 +1983,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>                 .logging_active = logging_active,
>                 .force_pte = logging_active,
>                 .prot = KVM_PGTABLE_PROT_R,
> -               .exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu),
>                 .topup_memcache = !perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu)),
>         };
>         void *memcache;
> --
> 2.47.3
>
>
