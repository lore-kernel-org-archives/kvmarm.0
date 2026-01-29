Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B62342158
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 16:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769704956; cv=pass; b=RmwO3dKfc0IByYUi6eHPGAPnxSYLetFNt0mEAz1MKQ5Bsn0z6V+lnspvJExQ0ladKaWwYlYlN3AI+LVrTKP6txK+jzLFH/7as/+zZdCvLX8mku9RgqsE1IDG6591WGUKGwjbeop8COQpcj5nuDDhNNGB3Qz/s8sv/13UTsLI8PI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769704956; c=relaxed/simple;
	bh=MwG6UqR6avV7JdKFskgLX/UuuUNq7QZrPqAsH3rPeMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZF/k2PTQE7edqWmh/DNCL+pWYjVWvHmGO8WYkXPeWQ7ZoytyPh5APe+k9UPm1kuWyFqheK1sjZjINTqifvYKAcnrpgbE/sC6PDuK4r7hMjJKxfajk03evR/gmG7JbXmpXntE8asMRKh3ms6ftdO2w+3+SvlvOoSznQP38s0lMUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FvoskzM/; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FvoskzM/"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5033b0b6eabso636711cf.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 08:42:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769704954; cv=none;
        d=google.com; s=arc-20240605;
        b=cjQVqqSwAbB/5RPEcENlbdHyHx8DKPTw6RtPEueMmA0n3XGv0syNL48f2l5IQRF743
         UxyIGXedZPncFILwh0PnvLFypOK2nhj3KdsSHg8FwcHW6slBBgOFwAOpsU1erO8SGf/e
         /JrZyc1YmeBrlO29S3gsJuF6gEl2jiFjuyUQfc9CbHWyz0OSkVtXXrle38GnoUdc1DZB
         ORkhM/Ra7aSfHOLRFmUzMe7HZeRlrLV6IrUChaE51fTCqtiScgNxIgmR0WX/WzEe8qDn
         HQfmMHgse88kKVMNPe8Z9ml/oGPQQAMn4+zd6z8v8F6ta6a79+/9MqYBu8hAc4VzIe+t
         cNpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mie6pCcIIw47fH1gJHDTDQWilzzUt5ppA4ofEa1Bgr0=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=Lh17R40vvIqXRHkSWLttu3U3FbxugeJdmebc0XgfnotbsxQL6pC81o4D9H1kCV8Qba
         MS92KXZeQ6z6tsgtVeK3OKO03h0FZMinsiJEGJcrKsMvpisZ45X5i8u9qjjkBzQ3bgty
         4sv4p1Ny2SG9QfdJNEwKDjSgPr7QddN48vWZr1crYmCbhQhGRndsAtsBfDQvu7l5/ub/
         VByEjBAGMLAQLcoqreT0pHog5WUw0JEHJ2oXem3c6UEUCqA9F7gXPo9si1EDoE/gU8Ki
         KC+wcg0Q0BdodTTZ5U/cOOfClKX7QOJWiwrLiG8U5rxt8UBfxr/OSESVv5epRhhRSu8o
         +F6w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769704954; x=1770309754; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mie6pCcIIw47fH1gJHDTDQWilzzUt5ppA4ofEa1Bgr0=;
        b=FvoskzM/67rryK29HEq+Jge20ozeAO3iXHpHr76i5kfG9yqGYfnRVc3oEue1hfNo31
         bzkG7ehjq9PC3ewl5cU//OC10jOm/rGcLZCdAW66xA7F/3PGgvgHl8ftRHxcg/qbeC5F
         y/5Zx1zIYLFszbzhU9E/K2Mu3Entxe/7tRKnJJ3Uzd/RtrO/BupuszCfDJZdpGipoVmy
         9ZxiYrVwL9Hfq/XuvuYW9DVGVfK0peGoxy+W1kBJdxbLqfuAeeZAhsWleCC8HwMjYGND
         QYglmKU1gr/+Hy8wH5Ga4PZT0OI0iRCY9YVfpeak02BGk9/QXeLmJXG89JiOw6HJr3Wd
         BnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769704954; x=1770309754;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mie6pCcIIw47fH1gJHDTDQWilzzUt5ppA4ofEa1Bgr0=;
        b=wkyCU0NmvG+3JKYir3hyM+kbMj8VrWAxKRLaTk7D1VB+CuO+K5EaPYj/Uf/Vl1rOXN
         mmJDVj03EDKh4iio2GmN2FfHbfqqyrRwGQ3tG1SufquVwfCikm+RAcdQ2BqMBbB3+6oy
         s9ZfB/ZKKKTkXvvEcvbo4FiJRhd7PDfBymApJC+52nKS2uvtw5eX6/1/C2b5x6Tlji8p
         u2SyZFQB2t93MrQpVimgP+bnns4bG/DLs3x1Ov6UvsLLz2k6hUu8C2isHlmfPS+eHSDs
         +GiDwvS5dHP+qkjfoSmanDdrY9JeN+lxoZa3+yhsrLrZOOgJP3Rgd+lLAc8yVOkZePIK
         XnkQ==
X-Gm-Message-State: AOJu0YzgI1Lxilj6D3IqjccUS0zirDaLxye0MFK8GCnOg6t3DWwXM4ep
	Sux0dxn2Il3ubDdext1NNxcgKYzNdrMGYI+gNz/191CUegA4y2/JOxHX/IuodAyQfOPIY/xWyxc
	5NMz7ah+GDgrSrImIS3dfJY6bpX5Yg0R71/GcbWA7
X-Gm-Gg: AZuq6aIDOet/lOxpFSrfBOCjx7Ifs0dQwWxv5TNsu6EZ6kdPvtmaoale7eOLbSFpyLI
	zO2VMTyRViAORHhvReiAacfpscL06Zg1YZfo98K9lIkJ1q+ew+jif6xyQjotDF3S8MJVP44rWo4
	DxIVwyBAzpSGvv5uly+3YpozsiGPuqvJtoRX2paCMBMsdrXLQzLgreLSwLEefn7ElTmvFLQtDBk
	/HvXAIWykdYy7ZnEy1d1Vyf+xg6kyyPhc2VeU0QYoAHmQxWFNTXwwy20hH2lqeaQAOBanxK
X-Received: by 2002:ac8:58c9:0:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-50428e79945mr12313541cf.3.1769704953904; Thu, 29 Jan 2026
 08:42:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-15-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-15-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 16:41:57 +0000
X-Gm-Features: AZwV_QgUsDZZ79om87g5fzEjBCiqAJNzGck6Go33ZwAHIlJhkXiSMYJ8ttr0Cec
Message-ID: <CA+EHjTzf4TLO+UOkbsqzEuzaaPQgHFjWLpRRrn0jZDndcSGMDA@mail.gmail.com>
Subject: Re: [PATCH 14/20] KVM: arm64: Simplify handling of HCR_EL2.E2H RESx
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Now that we can link the RESx behaviour with the value of HCR_EL2.E2H,
> we can trivially express the tautological constraint that makes E2H
> a reserved value at all times.
>
> Fun, isn't it?
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index d5871758f1fcc..187d047a9cf4a 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -394,16 +394,6 @@ static bool feat_vmid16(struct kvm *kvm)
>         return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
>  }
>
> -static bool compute_hcr_e2h(struct kvm *kvm, struct resx *bits)
> -{
> -       if (kvm_has_feat(kvm, FEAT_E2H0))
> -               bits->res0 |= HCR_EL2_E2H;
> -       else
> -               bits->res1 |= HCR_EL2_E2H;
> -
> -       return true;
> -}
> -
>  static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
>         NEEDS_FEAT(HFGRTR_EL2_nAMAIR2_EL1       |
>                    HFGRTR_EL2_nMAIR2_EL1,
> @@ -1023,7 +1013,8 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>         NEEDS_FEAT(HCR_EL2_TWEDEL       |
>                    HCR_EL2_TWEDEn,
>                    FEAT_TWED),
> -       NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
> +       NEEDS_FEAT_FLAG(HCR_EL2_E2H, RES0_WHEN_E2H0 | RES1_WHEN_E2H1,
> +                       enforce_resx),

If you were to take my suggestion for the previous patch, I think that
you could express this as follows:

    FORCE_RESx | RES0_WHEN_E2H0 | RES1_WHEN_E2H1

Or if you use the modified patch 12:

    FORCE_RESx | RES1_WHEN_E2H1

Either way:
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>         FORCE_RES0(HCR_EL2_RES0),
>         FORCE_RES1(HCR_EL2_RES1),
>  };


> --
> 2.47.3
>
