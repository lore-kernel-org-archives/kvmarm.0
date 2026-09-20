Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E09E3A9018
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 14:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789915411; cv=none; b=LrtSUkmP6XpRsFmSuzzwj7mj1OjxoTqeRxQ0YKA2mxKpkGNGmgdYfDM2Xp/e1J8U/w6JzA72cXGmN1cJnuYgmtGCYGNbpp8lmukm1JRtzRwR4kwuro5EKk1+jdvDy5bwnwI69SpTeHj02Xs6gR/0Wq0vHsborGys2Vo0M2l4hgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789915411; c=relaxed/simple;
	bh=gM4dLcKAjlvwqbcZzf0lMd4pbz2znaxfLkXxxOxgqjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UprNv81IDUK3Fenpd3SJRocV8cHzgefjoEINneMPAuO/IFNhMxTMwdfYH3M/ZtxXCAqNAZFtA2cBDQBZ9cPUYJ+nnvZsR4wMU2kbasrRQEFkXY+/Y3SPJr0IqDbC1AWo8RejdnZ52dgp6pM+lU3xYpE4h6dSg3/izUtEv2Yf7oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kgcyq49u; arc=none smtp.client-ip=95.215.58.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kgcyq49u"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=gM4dLcKAjlvwqbcZzf0lMd4pbz2znaxfLkXxxOxgqjE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789915407; v=1; x=1790520207;
 b=kgcyq49uD4mOJZtJ+Eo677EejXSjmSY2MyIK6MZXLs9n3IGgkbZkx91B+r3Ex0njFNQXDk1k
 16F8SCtSP5JCyHixude0cav1ce4C5KJFaEqvi8zrQ3N5fUmTT4+tIL6Wb7e21ikBjN2Zin57nmU
 po1Vp/lRFoSwge7Tb06Vx3Kc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ec648d1ebfdc9b95;
	Sun, 20 Sep 2026 14:43:27 +0000
X-Mizu-Trace-ID: ec648d1ebfdc9b95
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b83c1421ecso4258e87.1
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 07:43:23 -0700 (PDT)
X-Gm-Message-State: AFuF++lh1Oeb3ShYSUvMuJdJErtN6kfIJkYauR1KbOHOmNnyjBfq81C0
	ehgyWqNbFy6wpTC3zgkFyABdyNxkBAa7wGRAkb8X3mSxx4f3VlJvTzXhfaddDgc+wqH/bDykJZG
	RIbhFBgd8rKxC/DwgJwhx3sY3m50xyZn3nIg/UJs6
X-Received: by 2002:a05:6512:b87:b0:5b6:4ad:d6ba with SMTP id
 2adb3069b0e04-5b8c7eaffdemr82528e87.15.1789915402616; Sun, 20 Sep 2026
 07:43:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260919123150.3283606-1-maz@kernel.org> <20260919123150.3283606-3-maz@kernel.org>
In-Reply-To: <20260919123150.3283606-3-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 20 Sep 2026 15:42:46 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzm=kN6cUXtF6FEo4XSZkNj=cSUffCJ5YWHe5GjCxe=zQ@mail.gmail.com>
X-Gm-Features: AcwNN1UMc1fUZyuBAnLvsDe3WEmHsJtOO9PCxP2Icvg_OpPj2A6l7rmpgXfBR5A
Message-ID: <CA+EHjTzm=kN6cUXtF6FEo4XSZkNj=cSUffCJ5YWHe5GjCxe=zQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: arm64: vgic-v5: Correctly reset h_lpi_ist to NULL
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sascha Bischoff <sascha.bischoff@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 19 Sept 2026 at 13:32, Marc Zyngier <maz@kernel.org> wrote:
>
> Resetting a pointer to 0 is not completely wrong, but sparse
> legitimately shouts about it integer/pointer mix.
>
> Use NULL as expected.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609190952.glUgOBvp-lkp@intel.com/
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/vgic/vgic-v5-tables.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgic-v5-tables.c
> index ba8a8d5fcc2a3..d7196ed5d1bfd 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
> @@ -1066,7 +1066,7 @@ static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm, unsigned int id_bits
>                 /* Free the L1 IST again */
>                 vmi = xa_load(&vm_info, vm_id);
>                 kfree(vmi->h_lpi_ist);
> -               vmi->h_lpi_ist = 0;
> +               vmi->h_lpi_ist = NULL;
>
>                 return ret;
>         }
> --
> 2.47.3
>
>
