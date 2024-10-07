Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D9A1DD9AD
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 18:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728327102; cv=none; b=YXdXD9ABMsPVooxZy7K2CqjL4rnub+eAk3rQte6gl0FdpnibY1CeGHOuQdtFFsCOzEpg3q2ebIgyXY7rMMUIeXNRX7z13IjSz7jEiuW/Mn4WDRJG820tHsgtfh5QMedz0ngmrPJ9kBIdYOLgJ6UPVRHQGzjyQ9gALbsdJf8PQ10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728327102; c=relaxed/simple;
	bh=Iwt00qRZJKzMpD/SsNl8cwYs3nOX1XtxeoxZE5jQjKU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s0LpfcKGYqpjbs0luTKrcWjUr2EAMdjD+/ol5U7A95C7JNZn4Uyj5ZpsAvOXdCQx4nWI9SN3QQAqUJJyRSpTWQxG344Wg9Kdam+pw2R5l/5wAUEupk2Wi8uFJB7MMkTlcqD9ma/g96JLu0FvyfLlusaQNd5g9kCNzD5EsdtByV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tjb89tql; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tjb89tql"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e25d62bfe12so7425555276.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Oct 2024 11:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728327099; x=1728931899; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sr+clt445+1CFLN2b1lD2RZolPoj2I2apMG3jGPpa7o=;
        b=tjb89tqll6kN7OFEQvZuaUga9vmY2iOjFO2GdyCLFViCHEZ5/seVn+W/IgqKpIz+FV
         8aVPbb//La2mxZbHOuew6GblArRApYZncqq+Ov02+Q3C5nAIWi5cvcih6SWb0/5qUIKP
         4S4k0h3ZAouurJ3bd5dx5E/6cYHBc4d31R7GIbqIrsiErLkgBf0IyXjRQCZMX/5C0Aii
         A+t63TiAjOap0WDKABS49YkpsScDLPO32RQ10lgMBClgfYyo3pfO3IeZm3L0e+f7HQZq
         FMl6l88YU0mNckMgfJuvr6Le0CGK7NP5vrCWqqDSYqCiJuEY1+hjwOB0ZY+XD//8HUWs
         oi7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728327099; x=1728931899;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sr+clt445+1CFLN2b1lD2RZolPoj2I2apMG3jGPpa7o=;
        b=OukuFAOA3JUxGo07kYnqUXGqfeqvRncATuX3jXhmtnYx5OA+vYLE1jTpPeeJ/wujHz
         6UdyNHhN2CfUolLoZeyQqpvQR8gLAVEMVIevarsO6yHX8QiAH5wrIBEVXDacfsar6K7H
         2pIJ7Oxggju+0L/CfmAS/Ap/4quOiReE4YvnHDfDe1v1lKw4Lg2uRS0OyA1O5dIBTnve
         PkUlth/KwZ7bY6gglHRjAAFNw8pemr7Y7giAn24WdV5TybpLulVWYOoR1G65cE6LzYUi
         1Kg1EI22LVB0wu+VRwif/NhCyy257TiIL6w0AYR7cb+yVRSzxxGY3/pCKDWtXuyoHCTK
         sFAw==
X-Gm-Message-State: AOJu0YzjZxAfDCKkuqGi3ik8gayMLlML47/E+9SKT1a2QP9XwLvGrwWV
	qkriEUxQBGXIsO23q4iQPuSm3SP06J8bRVSA5z57ki1yZaX6sS9HblM1UnKvw4TWDWLbXuKIBnT
	UNw==
X-Google-Smtp-Source: AGHT+IF5aJlStfcNEIx6zdhqB7hP2sbQ0kvGWwzl+K5zval+bMC+DQGZIQ9igXXowSbPiif5mTIetG2u8s8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ae56:0:b0:e11:5b8c:f9c with SMTP id
 3f1490d57ef6-e2893501a23mr54811276.0.1728327099342; Mon, 07 Oct 2024 11:51:39
 -0700 (PDT)
Date: Mon, 7 Oct 2024 11:51:37 -0700
In-Reply-To: <20241007164256.1795250-5-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241007164256.1795250-1-oliver.upton@linux.dev> <20241007164256.1795250-5-oliver.upton@linux.dev>
Message-ID: <ZwQtuQ4mU-i3kY4i@google.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: nv: Clarify safety of allowing TLBI
 unmaps to reschedule
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 07, 2024, Oliver Upton wrote:
> There's been a decent amount of attention around unmaps of nested MMUs,
> and TLBI handling is no exception to this. Add a comment clarifying why
> it is safe to reschedule during a TLBI unmap, even without a reference
> on the MMU in progress.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e0c7cc16466e..b773d107cd35 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2955,6 +2955,29 @@ union tlbi_info {
>  static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
>  			       const union tlbi_info *info)
>  {
> +	/*
> +	 * The unmap operation is allowed to drop the MMU lock and block, which
> +	 * means that @mmu could be used for a different context than the one
> +	 * currently being invalidated.
> +	 *
> +	 * This behavior is still safe, as:
> +	 *
> +	 *  1) The vCPU that recycled the MMU is responsible for invalidating
> +	 *     the entire MMU before reusing it, which still honors the intent
> +	 *     of a TLBI.

I think it's worth calling out that other vCPUs that want to reuse the "new" MMU
will also ensure the entire MMU is invalidated before reusing it, and maybe even
that multiple vCPUs can participate in recyling an MMU.  The "The vCPU" wording
is probably going to be interpreted by most readers as meaning only _one_ vCPU
will ensure the MMU is invalidated.

> +	 *  2) Until the guest TLBI instruction is 'retired' (i.e. increment PC
> +	 *     and ERET to the guest), other vCPUs are allowed to use stale
> +	 *     translations.
> +	 *
> +	 *  3) Accidentally unmapping an unrelated MMU context is nonfatal, and
> +	 *     at worst may cause more aborts for shadow stage-2 fills.
> +	 *
> +	 * Dropping the MMU lock also implies that shadow stage-2 fills could
> +	 * happen behind the back of the TLBI. This is still safe, though, as
> +	 * the L1 needs to put its stage-2 in a consistent state before doing
> +	 * the TLBI.
> +	 */
>  	kvm_stage2_unmap_range(mmu, info->range.start, info->range.size, true);
>  }
>  
> @@ -3050,6 +3073,10 @@ static void s2_mmu_unmap_ipa(struct kvm_s2_mmu *mmu,
>  	max_size = compute_tlb_inval_range(mmu, info->ipa.addr);
>  	base_addr &= ~(max_size - 1);
>  
> +	/*
> +	 * See comment in s2_mmu_unmap_range() for why this is allowed to
> +	 * reschedule.
> +	 */
>  	kvm_stage2_unmap_range(mmu, base_addr, max_size, true);
>  }
>  
> -- 
> 2.47.0.rc0.187.ge670bccf7e-goog
> 
