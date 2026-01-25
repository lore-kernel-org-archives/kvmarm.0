Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CFD2741A0
	for <kvmarm@lists.linux.dev>; Sun, 25 Jan 2026 13:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769349057; cv=pass; b=cmxphz58tkE5UA5J6Tw2mqLD2Gy1bufDPqQ/eYx6bOy+ST/3kEWBXHGhbyaG6QWLftdurxvTpWSXD26CIYTdKdlXKWPBVUjEYQQcMW5BeTedYgA0BKwkx2TJSaFXioTbaiTfP5bA+Vlm5v0g3xY8yqH5NkHsMDJ2vWIHC5HeG1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769349057; c=relaxed/simple;
	bh=rlAK/BatGRuo9kHWHuJjdpMjxK2eikEg2S8ysY4p7cE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K7G9TtZyHOuZB/QiPqkYM5nfkZ6tBEvVYchyjjIqfIQ88lDKFD/hjQsAw+V+Bld0r5w0mut18XAQAV2tEMVdIGPYjaKwf9sdbxi0JgNkiEJNUDiyO8sx8no7Y9766Vh1vNrSI2541TrjiTCRXoZ+sMNAsngBz0RRGWgRvCTlAlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FMvLaETN; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FMvLaETN"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50299648ae9so497261cf.1
        for <kvmarm@lists.linux.dev>; Sun, 25 Jan 2026 05:50:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769349055; cv=none;
        d=google.com; s=arc-20240605;
        b=NRc985g+xQHVDZcJh8DFpaRj72jOHEa2bAzy1TLaMN/CgH2bDjUp2ltxEmueM/Ben4
         fVjavrw3EaUbZKVT7sgpiy+0/FHzYwDQJ4CCMCg4PJLQqd21VCq33t0THIbW6a3oHOqj
         afGEuWdckeImiK3VgNPFuXzN/pJ/phEOCsQCGFId6BaBhklwjq4mOjOrcKf3KKqIP0ZM
         X8dh579fmvuTU3Ru7ma0z07R8gY5OS0PK8NX1M5wGaXbJdWyx9J3zChZIbqgI/pnpef4
         /gqLXBDowzoR7o5aVzxSsXjdl33lRjJ8/SR49+JKGsYF0lw1Iqlg5KevxhJcQYwrKrYU
         UDfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bvtCjytnh3m0w4xXt7ewKdUhvsuqlVQAf7Vxj7DBbXU=;
        fh=oKlrb0qZ1hR4CAuTOFfiao8JkykPVcF24VV3oTmJ1vk=;
        b=aLfbc9XGlGohdlmG6CeJGuygHgZJGC+0xViu4rs+ZUft6w5vUl95E0ntwE0WLCzqvB
         QQtSRiJke48rpP1aSg2ipbHlEnYJf+YN+MqNSwNKtwA5cRmPGMzviVOxVkPtSjP3yteD
         GoEXZ4bl5CvhnB+95D4FlhCRvrM1ECJxIx9bPpUiUSlUf24z6MxXD20hf0xBHsQvFPGa
         MFpzfXh0N3AptS1nb2tXzS7IdO95fS/jLlMMYHylQYo9+ezQ2HMyFK6ZpSTl2rsUiio7
         kIRvqpjpHuX/aLkJ7/VKwXk0OcS3Phs2iKc3S1+erqeyFhBHIlf2tWGgrFnZXgK3UrIX
         XV8w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769349055; x=1769953855; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bvtCjytnh3m0w4xXt7ewKdUhvsuqlVQAf7Vxj7DBbXU=;
        b=FMvLaETNZyKSoaSxY6oThZVtiO+ip0ljxhQo4Vt/RgUrD4K1m5OMUaGahCS2boB5nx
         Wy5VC/uC/c8w4sVqqamuiptx9fPc78BdNx6w4cN+kH7yvzYNH8xZkx+eLCXJwKkob0g7
         URdyBgHFqmUpw9np/rcqaiT7WMmeSRAgIA6ZtrRoi598cvG96X43+wl2jYejvsvZNNuA
         2m9q9aGnUR72phz+2zxveLaguuXeRxRND7E+ysN/z/HVvc0WTUTvLub5CFgmmSKao7ri
         KaWKb74KXZ8275bXYVF+ULWrog0vAIsXDVKxvzcXQe2eINt4TyXdB4Bwd/iruwYD9o6X
         cZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769349055; x=1769953855;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvtCjytnh3m0w4xXt7ewKdUhvsuqlVQAf7Vxj7DBbXU=;
        b=OmDhFukzUJuWyqlVVpSN/LP+rZkU+STylZj1dmAberylIiFqMIRFvaKWA5wVWaPCzz
         AXui/DMuIcNJAqFM5IwcnKgC3rzWdc4vlfbRh8kehniB3JyqNmZ5LMI29CW1PW3dzMHs
         Yh/mdTrqW21L1UAgBf5MFFsi8w+2O6nkaMtyAZal0uK3zGn6fbKYm8S6MgWjqBFkVbKK
         S6ze3uYZkDk1VwEhYTxkuqiF+dghGQUvIS9BrqiWsT8K5zS4SH+W4SenKBSFb8whJ/z4
         MaRz6h3G/+Ls+rjM18dcmTnaIHDm5DH90sWVccpPSa4QKcQeFNNW+xhlPIFzVs87nKmk
         kAhg==
X-Gm-Message-State: AOJu0YzWpg6p/G1LcRzzNOG+A58Uvbv/aEUxJrb2t+wmO+uPxqV2i7Pt
	4BxtpVvs1hw+qOLUOt8lajNKMJtVyYRSiNLkQZP0dOjwFnzY51FH+JKwZBGk4vm1eGMNiZekHLq
	2dQhiGU24jPhS7tYFTbhHaboO5eOc/Y0s9M899oyU
X-Gm-Gg: AZuq6aLW5UbhnTCguh87weZ08czF9yHtucqoCVR+QQwAsdqptBOHJFZ05cFMJtOPUBa
	xVy3X7d1C8MxhpoaQzjG5SHK9ZSLzZrThbombk5V29OzPK0TNog1K/wpvHnGgjRDofu3MH40MUc
	5azgx0rWtJRmPEBceGw0qFLQkGSWR0TaZuT+PVVN/mBI5tRcMkW4+Bb9oxLap8DIc19czmimFD9
	aMLS33e15rJXs1mj92W17I2xdMP0XV2gq1ry4y6SPxt+moAhWgfm7rmUG4RjcMKMaDSDi5K
X-Received: by 2002:ac8:5987:0:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-5031428f089mr4086301cf.5.1769349054528; Sun, 25 Jan 2026
 05:50:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260123191637.715429-1-maz@kernel.org> <20260123191637.715429-4-maz@kernel.org>
In-Reply-To: <20260123191637.715429-4-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 25 Jan 2026 13:50:17 +0000
X-Gm-Features: AZwV_QgL4MA9dzU0hsWQWkYWo_GVTF-8xtdiRpx6vT3QpIK8K8eZ4J0wi3LqHIQ
Message-ID: <CA+EHjTyCLMpfwJ8_4hs2AZudQadvjqrRm7ULSsw0DQrsDEBFHQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] KVM: arm64: Switch pKVM host S2 over to KVM_PGTABLE_S2_AS_S1
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 23 Jan 2026 at 19:16, Marc Zyngier <maz@kernel.org> wrote:
>
> Since we have the basics to use the S1 memory attributes as the
> final ones with FWB, flip the host over to that when FWB is present.
>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Tested-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 49db32f3ddf71..38f66a56a7665 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -19,7 +19,7 @@
>  #include <nvhe/mem_protect.h>
>  #include <nvhe/mm.h>
>
> -#define KVM_HOST_S2_FLAGS (KVM_PGTABLE_S2_NOFWB | KVM_PGTABLE_S2_IDMAP)
> +#define KVM_HOST_S2_FLAGS (KVM_PGTABLE_S2_AS_S1 | KVM_PGTABLE_S2_IDMAP)
>
>  struct host_mmu host_mmu;
>
> @@ -324,6 +324,8 @@ int __pkvm_prot_finalize(void)
>         params->vttbr = kvm_get_vttbr(mmu);
>         params->vtcr = mmu->vtcr;
>         params->hcr_el2 |= HCR_VM;
> +       if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> +               params->hcr_el2 |= HCR_FWB;
>
>         /*
>          * The CMO below not only cleans the updated params to the
> --
> 2.47.3
>
