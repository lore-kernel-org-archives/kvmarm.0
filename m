Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AEA47B429
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 13:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780578117; cv=pass; b=OXemK16tlyjszZviqyy6ndpLNzl6JumKasnP9pAdbURy5Q/X0VJ0LznIymSCwiWEbq734ehuY4d9b8sWpcd2BJCRUCDmiU+kINvG9mRXLvrlSZDK2c5089Jt5t2nadfJi5fOv6HuoazXXHmDmiGoA/aSMp+kyNE42e82Ft1THlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780578117; c=relaxed/simple;
	bh=L1ExFWng8f9EdhY2axcoNwuEcI1yfeErZ6FCuGou438=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PVdlyWyo8vfQ33AW780sFUy5nf4AreNpknLmJVfZCxEeSkqmyrRkpJx2ojehcYYnv6EoaUYt2zBxMy+odQAFK52PBbRrmtlV9XYove+EeaGpJSSDxKtqc2UZNPpuP6eFbjYzqRYdNQ3Yyj0WLA7y+m6IxdE4mahTx9YgeFWvVYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ubscIfqN; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ubscIfqN"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51765331535so472931cf.1
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 06:01:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780578115; cv=none;
        d=google.com; s=arc-20240605;
        b=FWcHfrgv1KRjOHuoBvth6/eSdlD01dvxYsE2epNH+OiosT68K6K1m9QP/3spfueKNH
         tx8DM4zjQAFSKPixRiocGiVSzqSElW+jGcHb3CZIG1OxtXmffY97PsNEkFziWr4zxOcx
         /qaMHgimunMqaBbQHSksGDB7HYB4aRVKgfm1nLsdaEoe5IEZczEKATYu3P0jIGv0LMnT
         HOn7l3vTAYqOEWxyTN5aJJvHSicIi51RCNCQciSgwKA8IKpF8M5JmWFtIgvApuT28EzL
         6hWmWK2H2FzXtMsa6GEA6z0I1qxj+bMJ484tD6zNPkF9E5sKH7Jl9exHpiXZWX32Lu/a
         LBWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=abvCoXD4ApuT4IBhlncgonT/f2/XPLlXlo2SlRJs3xY=;
        fh=SviaApaIcQwTLWDTlZDcHjGH92v3blqnxLzyOMOyBjw=;
        b=NJpgV6R+QIJXhSCmmAvtQeMhmwRR+fdQvIZsYVNjqw12pHmmBKsL5/8dYHGPbDNgjn
         zfJcrHage2lFdp5AlEqBzhfUqyne/DKQ1/slQYP1MyYJO/YDwegM1omW4Rw+36OocRz/
         vCuiy0+7lp9uwIzaTXWjniCAfAMPGGXDb1yiL+0NnA5maNLCK31FV3EF2iFPAzukJrkw
         j2qKfqidwJ4B+bIavSni7CD1K73PKziLN39Udz2EqcAsgJpoYY9qbNtEbiiKUTEJ62/L
         mFvg8f+sFe3e0K0nqlQZzvN1xGyIReJAb9t+XJZS2wZMR2LmIWUokr/J3iwgvCHkT/0/
         fEQg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780578115; x=1781182915; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=abvCoXD4ApuT4IBhlncgonT/f2/XPLlXlo2SlRJs3xY=;
        b=ubscIfqNh+s9d9JISUn5fvFFqwUQ8ux0HPBxALRFJDJU+iSx62h+acPWm8QDTmPasm
         c1kXNkGbHU9gRR4EFuigQWNE8kckAEMrKd/fZbRb6OwWx1sORKNXz1ggPMgk8nONkM8u
         8QN2Hb/Il+ztMZrgKmY4hPGcjOYJLY3gNyK/FTS1PQTj8R+cIlW49ySRMPLJae/HeL0J
         LeLnjU4GWPq4VcZ5p9xLhzmDRm3SWTWJBhCY5Sa7kbz6ykS5zk+omK+bKdatm16TOL+x
         /iqptkArFUWq6beW/Lay8UqoV/93hP+vVq6iaSP4oKxhCZ7VU1RamKgMajnygTZ7NxWX
         siZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780578115; x=1781182915;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abvCoXD4ApuT4IBhlncgonT/f2/XPLlXlo2SlRJs3xY=;
        b=qAxjlW7IZ4bfBZc525TOVkysqtQs1r0cf2DMp9vCPAV9TTdm8GXR69A9UqGytvncnx
         1pzRLrtM70voVXwrEI3+C0nlqxoEPIUnaYxuJjlJPiG5uiNyvYoZ1QccdTVdJfpek7AM
         KmZZcBUZGvsVn/tztvfLi7j/tkeMgiQq6IW+HXTTZaKtvKh9Daj4u0LSrtXBZRrdMVVS
         BJvpOq888rkBuRBoIpgyEURCN0QwzrzmTydNmFxZ9pPLW4wEdVXBJgVkN4uSuanDz/ZT
         EpgrdO+ahVems9FgkNZzvWfvyXO5gEdMxpSAIXgFniwUwqgSbPZJ6wpwBcHXUiyq4gkx
         daow==
X-Forwarded-Encrypted: i=1; AFNElJ8q53ITszQGqDxEyJNtl2b3kjj3TOluxCIiwypK/4L5C4guFJ68i4OfUcBq6ys+xI/jm1mSTcw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGD4mOCLd30pcMYO9/ucYlwcuhUrUWD6hQzIkNGCwh5hguijFO
	rL5i7vjdJumR8qYqrYbgsskmk4qpwvUSxENViGnXbLnhKzDIZgzM7H4JlkwU3SKdMCdPQm51DKB
	hh5TJrMlTfTjapgkIx4w7ZpGstuGtdNspJnfEn7p7
X-Gm-Gg: Acq92OFfkwjSwKIQym8LEDNR3IaJ8RDi1Y9UwxKnclHTeN4mgzotqHDoSJ/+NNcOu/m
	881bB5+V9f6WIJdYsuvZaY/iJrwp3Fi7UHowSKCPPybY/CfpqGQJtz3IC5uyiBuF/On3XCtEJPm
	1Ct7/wsAJ33i0CtGkUaCgUuNVpFMFqH9uwV7sdVlxBZZmjdhH0kpHSEW3eii5Tby5dealMpf3FK
	1qJyYejuCyRrA5yllLO0RXZXErVTNRuEflrdGIiOMkpYo2cdliwhEhGMEGxcJIaS7r0WeVxzTkj
	c2/sKR9kR893K/wNdzA=
X-Received: by 2002:a05:622a:1885:b0:516:d570:82c0 with SMTP id
 d75a77b69052e-517890b8d90mr6766011cf.15.1780578114344; Thu, 04 Jun 2026
 06:01:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aiFe-CXo-XVTFz1g@v4bel>
In-Reply-To: <aiFe-CXo-XVTFz1g@v4bel>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 4 Jun 2026 14:01:17 +0100
X-Gm-Features: AVVi8CfHHlZEI2hILdx1PsPvsAWlx2wW9yyM9N0c2QlyzumkAgqr3-x7eWBlJOs
Message-ID: <CA+EHjTwgPFbbp7khcy+DZ9HZWCX-OWPfO78Gj_eQuCoj+SA90g@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Sanitise host vCPU fields in flush_hyp_vcpu()
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Hyunwoo,

On Thu, 4 Jun 2026 at 12:18, Hyunwoo Kim <imv4bel@gmail.com> wrote:
>
> flush_hyp_vcpu() copies the host vCPU context and vGIC state into the
> hyp's private vCPU on every run. ctxt_to_vcpu() expects a guest context
> to have a NULL __hyp_running_vcpu, which is only ever set on the host
> context, so that it resolves the vCPU via container_of(). The vGIC list
> register save and restore expect used_lrs to stay within the number of
> implemented list registers. While this is generally the case,
> flush_hyp_vcpu() copies both fields verbatim from the host vCPU and
> enforces neither expectation.
>
> Fix by clearing __hyp_running_vcpu and clamping used_lrs after the copy.

Nice catch, both fixes are correct.

Please split this into two patches, one per field. They are independent
bugs that just happen to share a Fixes: tag and the function. Both are
host -> EL2, so worth stating that in the commit messages.

Otherwise this looks right to me.

Cheers,
/fuad


>
> Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 06db299c37a89..ef9318ff0c25e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -7,6 +7,7 @@
>  #include <hyp/adjust_pc.h>
>  #include <hyp/switch.h>
>
> +#include <asm/arch_gicv3.h>
>  #include <asm/pgtable-types.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
> @@ -128,6 +129,9 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>
>         hyp_vcpu->vcpu.arch.ctxt        = host_vcpu->arch.ctxt;
>
> +       /* A guest context must keep a NULL __hyp_running_vcpu. */
> +       hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
> +
>         hyp_vcpu->vcpu.arch.mdcr_el2    = host_vcpu->arch.mdcr_el2;
>         hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
>         hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> @@ -139,6 +143,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>
>         hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
>
> +       /* Bound the host-provided used_lrs by the implemented list registers. */
> +       if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
> +               hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs =
> +                       min_t(unsigned int,
> +                             hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs,
> +                             (read_gicreg(ICH_VTR_EL2) & 0xf) + 1);
> +
>         hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
>  }
>
> --
> 2.43.0
>
>
