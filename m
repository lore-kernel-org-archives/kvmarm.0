Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB57834EEF5
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094597; cv=pass; b=QsPcff+4gGvetQ3jLKy7n7ZiEOOHkYQn8s/VGylgapOA3Jv6BUMJPzL+b0IP0LkgkLVeDQXIxMifPehoGJINXcIyNEb4N1kRxioz40y2p4xM0FB/iL7gxoatvnmVeT+gVhPdD0ZNgqDZQk8LoaAtnhrJPu901Evt6YzKNG+/sZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094597; c=relaxed/simple;
	bh=d6/9w0b4OJBi5qq24Z/ZDQA6804dgbE/pccNert9Rcs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AqR9MY1x7zBqqtgklbitFoklMlrfyBocJ74MN9xoiOtRDHf3806chbrwTHvyrYlkK9zftgksL5iIbAKnYyVr8RCC/Kjdc12yf7R1Kaj1p19/eUn4iKYrXOV5CmdwHh0EUmOSoigDj/n6DXzdEAZXSE9nEGwTyXPk7BI5AB5MTlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UsMTBLA0; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UsMTBLA0"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-501511aa012so379761cf.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 07:09:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769094594; cv=none;
        d=google.com; s=arc-20240605;
        b=CQhAj5ZsbS92isC0VkLbO9qpDzh4aQ69dLEdACXZNUlCKshpZQRbCNS5IDPRq9vYb2
         uMXljMgiw7KkUQaEXtnz9VmxT1gNtJRnS+j3dwOFFxHoE6RCroXQQ9yLQ6lN2gFnG+rW
         L4dO+t6rlfrVN2cU63rRi5KarX0RUWujW1+GVcfoloLUhQbNMyU+oJSPIt+jrs86UpL8
         Cvuvn5rZQ/sgO2056ZDBxNdOZZW8CltMxfZI2VK80ZsJ8SejO5a5qLWz4nAbEKlbW6tu
         yeX/PFGiNH8qD5616an0BUsNmeuB9O3/3kQzX4pDWXelysUIj52bWk5QxysF4eqOdf8l
         8ohA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vvCkmh9jlVByBeKIvdOHUOcBwUtzU/25mi8V73JbEG0=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=RE+s9I/LY3ODVuR/6dZfjYOwzqKXWJQ6M7ZF5SK3EZK0FhTaFB0mTC641La4uxFPMI
         UK94SyDeoAsm4nzJ9M1NdZZ45gtVJr/kEASWCGdvLRnkRyO0XxRcIk31d9ietuVVHkUr
         Q/Tl5A6EThYMKPEs1vUE8nfB7gPtMMIbGn1MUanRHPDv6+eqiy3aDCeXndP1VOWNC+Yw
         gYGQjWmiXkJQCkptzr5zYoyw3GzvXkGqdhaimTgOlgHRSGXY+gzb+eC0cQCl6eqXL0Xd
         GbxNNgl6QTCuY9MVhO0Ia7pQm8p2V1643NAI0iFM/bcV98PGGUltJN2jfn+yoCjrOWU0
         T5zw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769094594; x=1769699394; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vvCkmh9jlVByBeKIvdOHUOcBwUtzU/25mi8V73JbEG0=;
        b=UsMTBLA0vSlqCViDVAyAMbLczX1Qw17Lj6BkuEk8V64PHt0W6tF+P+T6fifAB4Sjd/
         ClmBBTvx+AOnkdURCYufw6OoC5S7DOJ5m3b3shltNhdal+LqQMTDui7qdFLlriQPWGUO
         M4z0FLb9q1F8n/zVet6rnrku/+m6PcdaLSaf4yLqCFn4w4UqmTjztzqRF5X/DtVAZVd0
         5Mhks/a1xyf3cE3Vs4PO0knA39x5yl8+jCkhQvArsn8GAA/By7bXzsWfuNijF+dfbHoN
         0ppSr51hzyd4BivpzccyZvIoWUc5fyyVM13crd5uA34EC1Z8D2PFF4NMv+gdpA+eNviZ
         thtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769094594; x=1769699394;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vvCkmh9jlVByBeKIvdOHUOcBwUtzU/25mi8V73JbEG0=;
        b=fjozYO+8FVPUfVjP/CFYrQT5TFXKQ4Co1nXbnZF0B+h2xMqT8VlLSHfFhOgFyO/mDF
         lE/yeDgKf89Evze8d+lcmKw/f+7GtcyAgWNEckYDb/fTGjF4uuWkpFC+ZZC8pnxaYWdu
         mL9mFNJoI/2wSk8L8tD1BgUMzAp7Jzbqr2HUydH1tfrIO8JIJTpmsD/8xUw6kI0YB+kF
         sBNI00BSWOfQHaQE/++hWtBkChfz+PnkSMR039zBpy9Sstd6BG26VwIbX75E4lRQSmko
         G2NwfAs0IZwcvUS2J6HS3GNJkZF1C5h/HpAohZafm+7KUL9NaCpz738QYde+QV7sp8Qx
         0Big==
X-Gm-Message-State: AOJu0YyaLZksMTu0AwLXrBL4OgbKRVYQz8hyB75+a6nCHzrNJl55HkGm
	QOHsPZiy0i5sYYCQ2JTdpZyfQwvt8oQyHyae3EpWwIREdRLXzbitgAddf00ea0YtaEeFt60C3c2
	u9pBGT+ub41R6sYrKEVUDQYNbZpLzzNFWkSsNF+oZ
X-Gm-Gg: AZuq6aLyHkfXm6S0AHx2Snay/bJ4pZyLjgv3HQ2PJg9uVH1PRwRDulZLkA4Yc10P0Dj
	X4eCOapEM64a5evBTNHLfJdfm2kRCzoPLM+B/Blh92GVbtZq8dlLgAGNNEejhhsJk7Z+4VJDrLU
	SpHWpQqEFqO15MFXP2zAJ0W0W/sM3RVcvZ7G6wXtAII+N2az42EXAhpqn9Xb1m+3EwbMqdeK3T7
	ch08x7wZpZq4G6SYgCy2/sRTGQzKGKhvKDVfoOnMboA+nWEwuhQipbHnA2SRQ0sD69CQ4oaR0Kh
	atiSQ1l7R6OxFy7EHeSiaClbDhXnD4gd+J3S
X-Received: by 2002:a05:622a:994:b0:4ff:bf96:db86 with SMTP id
 d75a77b69052e-502ebd89420mr14663551cf.16.1769094593435; Thu, 22 Jan 2026
 07:09:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119105651.255693-1-maz@kernel.org> <20260119105651.255693-5-maz@kernel.org>
In-Reply-To: <20260119105651.255693-5-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 22 Jan 2026 15:09:16 +0000
X-Gm-Features: AZwV_Qgn974Rn-FnK4kC6GfYpfe9Us7HnF_BLs1xt04WEDzmacqD6_IPgM9DxZw
Message-ID: <CA+EHjTyWGmnJ+xMGJ4oGaP1pPGWA7tJD9kxDxhdtxAAj6dnFLg@mail.gmail.com>
Subject: Re: [PATCH 4/6] KVM: arm64: Switch pKVM host S2 over to KVM_PGTABLE_S2_AS_S1
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 19 Jan 2026 at 10:56, Marc Zyngier <maz@kernel.org> wrote:
>
> Since we have the basics to use the S1 memory attributes as the
> final ones with FWB, flip the host over to that when FWB is present.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
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

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>         /*
>          * The CMO below not only cleans the updated params to the
> --
> 2.47.3
>
