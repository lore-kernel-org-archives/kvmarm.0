Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162313BD24D
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 12:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749617; cv=pass; b=bb5/K4YqRA0DkZHxs7qCOqzfONlkKcC+sG2dDvxHzX2Y5In+0N6b/cepf1cGx5kBN4swNj8V546hJIozzp97Tfb/Yplw5XtKm2ALktzZRyTwdrOO3XoNcY9SNy7FJY23+wHJ+vd9NolF108+esP50FVX1QhjEP9DrcStcp+MItk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749617; c=relaxed/simple;
	bh=lOndnAaLoKMyJ7IGOo4C/9q1yyeh4731Ys2b0OKEX+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nzo+NEXcf4Lrwfs+5hW49HnXNO2PCNnw1qUsJXlx6AtlvtxyM8EVJhOchrETUVRTS8yp1YiZcRVymuK1zmPNL3rh0gfYkoZJjGKyPdX2NA73Ny8shjAuBb5BMOLKeFYZDf9smEiJCLTj+sOQwEkrS64XOqJP3dmIzgiFlhQi+yY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kv2y4XWD; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kv2y4XWD"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50906a98ffeso585781cf.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 05:13:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773749615; cv=none;
        d=google.com; s=arc-20240605;
        b=Z8neVaNCrI9uNW4zFf3CDmISLIOT7NeM5IuaM9Dc4zUxf9nFjJRe8L6lOSlZ5SbHlw
         bKyfPGMhfSe171jj9r8B6HK/j2d7jgxYOB1WbkMo9xHXxCmfjCKxyzjhuH9k6IHXRChc
         NtqtOKzv8lOXHZLfjVlVeFqXIubZIRrva8Ie/oC/2q2BJuWqgtzKJACUyWZYfVAuS1S8
         O7KqjMVXig4FzS5rpCuPR54iEOLwhCT4rYAFEzDTanzQVWGychqig2I8TWA6gvWMKPxi
         vHc083y60PagQ/EcLPr73UIte47mEBrgcSO1wp0yj0HidDuanPR1NqKK8+xCePaqZ62k
         Pd/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=hwWNJTID6ZXpzh92DfTBNJePUIEHrZBNUiZwgIap8M4=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=EcmhJZFkcLJc0/deHJjIFb9ddZgCeVo5nvjg/oURAaqoObhH2eQdsO5MxEL1J4b7wU
         U7GuEOQW1CoZ6jkvWI4ZVk0RimVBs1cSK82sgCHPw4bHGCeVRCHRnGjhywiAQ0UY/9qY
         Uwjp7cfpX2b1SfBM33upAUKnyu6QgbUMKZBGOY39xJQksQziAVMMZTtRa6h8VoPe5m2S
         r2Z8m8Slap+lfhm3fcczV+XktIpTZBn9uQ9llNST1g4VFeFvqIzyfTPkuOr0khlp73Ki
         IAdbnNkLznQz7b+J8vqQ95rSNpuEFXsefJTJp+P30MaZ7yvbzItasMLBBlzYXmeXDCgS
         /wFw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773749615; x=1774354415; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hwWNJTID6ZXpzh92DfTBNJePUIEHrZBNUiZwgIap8M4=;
        b=kv2y4XWDHRZgCBK/TDV2CNg3Rp8pVnBa1MdKVWtciKlfHiOnjyCNbbT4HwqIv08d/G
         QcXqrvW/H6okx5QEYOqHKcpgAcpXV833mFxySJqqSdvCC1cFDEfWXKM0TKf+5KhXLOA9
         sapLdkKNHMsmKr9yt1RawSwVWa3tNIqKWShq7yEK03ZjlLzcdup9qdhN/+w045H20KLA
         GgXPDcBxzk3+/Q1zZvEo4FqjmNDJRLGq+JSM0Q/DtC0+Chqkrnputnm1ps4BTvOmJ5Ot
         ICzFXYMz1VLgUD2Jk8muszyO6HIZjonG5rE/WaiT7W50ln5hWob9iBfUI6NKvOZ3Kv7W
         skCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773749615; x=1774354415;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hwWNJTID6ZXpzh92DfTBNJePUIEHrZBNUiZwgIap8M4=;
        b=Xp8c9vR1HbGwrzHaszSW4ETuS38HvagYZLalXERfpq2Ybx1uJqtDac4ZgP9QN5uMWU
         IyJ5IsCbYJHjnbE8RVgBtmqkkC7dsmIsLaN1YD4MMftmfqDIOc+CXsAtImE2gnJQGZzG
         4YKmTMu8+ffXAn5gaXqdcpRbpEl4NbAbBCqgf2VW7V7tUf9UKRMoRI8nqwxXntIM5teO
         H6F7VGtzN7HFGdw7xtsrlNW+HFcJB8reUGNF46aIVcR58BM8dXudY4Ec76mTVqI9MqOR
         tMuIN5VQ43MKBd66PxjhYRAlrL9Z94PG6zWdESJHhujDHBG9wR9Y7PWs7BVM+eb+RSNf
         CLaw==
X-Gm-Message-State: AOJu0Yz9S2M4CG60GKRSJ1Ru0S5tjRn0kLIB3/pT8xx0CRH4KMtwCrpV
	wfyAnBh5XxJevLk5mvAFZIiWmWWI1IIenVCmu1BGbT0c+hwcr6gvv1YUKxcIs/RVc6s/VGkdWa/
	8JdpTiRL0rkz312J3pyH1MYHl1V6uq+fwSCz2OW4r
X-Gm-Gg: ATEYQzxe9FGORxlMjgkZI8JgPx+2RhMjaudaORWku4ZRUiw7lyA2/0qGK01CFsV+Cgn
	fH5YGzzFsZvjp4PCWkPTlrid7QbmnyOXT+3QT2jSYsbQrPEupSR3njEwZnRCwUQaVDkZQ2TAv5n
	qI+himYMo1QiM1+TIWEicTXCvMVpQr7lnblaqw2yI0I4lcjWiITHD1a9KyMFDSBjoasKtD4cF5E
	DO5TUKidZW/2SxOjKKODc54pyregMQVpcyNKbzSbb5JOxRSlO1Ya3zByekOmNkFBRAI87bUIkfW
	PTt+Wbd3qqkhYUR8lp7Q9M4t8uADU4AkTUw4
X-Received: by 2002:ac8:598c:0:b0:509:25c5:42b4 with SMTP id
 d75a77b69052e-5099ae752a3mr11728141cf.13.1773749614349; Tue, 17 Mar 2026
 05:13:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-9-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-9-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 12:12:57 +0000
X-Gm-Features: AaiRm52d-_Ix5WYeihZWEM26ba847CqKWtem_pAtFTeh0W9v9Uwl5qcj1eW1Z_k
Message-ID: <CA+EHjTwHGkTjB1vgY3UdC2OpbAS3i5yCH=cbLNu38uBSmOxarQ@mail.gmail.com>
Subject: Re: [PATCH 08/17] KVM: arm64: Kill topup_memcache from kvm_s2_fault
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> The topup_memcache field can be easily replaced by the equivalent
> conditions, and the resulting code is not much worse.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 11820e39ad8e1..abe239752c696 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1712,7 +1712,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>
>  struct kvm_s2_fault {
>         bool writable;
> -       bool topup_memcache;
>         bool mte_allowed;
>         bool is_vma_cacheable;
>         bool s2_force_noncacheable;
> @@ -1983,7 +1982,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>                 .logging_active = logging_active,
>                 .force_pte = logging_active,
>                 .prot = KVM_PGTABLE_PROT_R,
> -               .topup_memcache = !perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu)),
>         };
>         void *memcache;
>         int ret;
> @@ -1994,9 +1992,11 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>          * only exception to this is when dirty logging is enabled at runtime
>          * and a write fault needs to collapse a block entry into a table.
>          */
> -       ret = prepare_mmu_memcache(s2fd->vcpu, fault.topup_memcache, &memcache);
> -       if (ret)
> -               return ret;
> +       if (!perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu))) {
> +               ret = prepare_mmu_memcache(s2fd->vcpu, true, &memcache);
> +               if (ret)
> +                       return ret;
> +       }

Further up in user_mem_abort(), when memcache is declared it should be
initialized to NULL, since prepare_mmu_memcache() isn't called if this
evaluates to false.

With that fixed:
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
>         /*
>          * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
> --
> 2.47.3
>
