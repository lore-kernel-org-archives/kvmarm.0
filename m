Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6E41F181F
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094510; cv=pass; b=ezg7SJz5cDgDJ1GWM1ML2qtVfYg5EscxH8YXHgDEbXZUOZfudW5EHaEHGLAumD2aU1TkdkauaIck/zk7Z0WPtUJ+VYU1X1qd+6e90ISZEsuKPIz1VuRzt92wF5XhglmxODRI3EON4oF5zd21DsWItlghE3pxgQlAdHToFc6B+WE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094510; c=relaxed/simple;
	bh=jjEFChMoWNvx5P3JA1aE20y0ZtH7uLN7sj2ClplL370=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KN8fS/450QMGXDVFb+PeSNgJIqhkjZb+d9TKlJ5W1LuySKiv8gQhOPvDqZQsoomXl5AQgzpDJZWejPga7MN5tQs+3A4U0C0KfkicNVeyaejyBC9ZjoVgg6p8RTxbnRn/4F/8ex9HorTVlCPLY8puy/ZmxWFQE9j3YkPbDd8soeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zl/qSjLm; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zl/qSjLm"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5014acad6f2so419871cf.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 07:08:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769094508; cv=none;
        d=google.com; s=arc-20240605;
        b=BGK7uXy/kZEMmzUucsJvMW+XCrTHKxnEA/7wCze39u4mQ7HGG+D+1/009qCcyMVSnz
         +XgirbX/8L42l0IEfyvtQ41LCl0oftIMjqIV5lIKakTYCiSrfzVW0LQb46S5uVd0jV/Y
         MAD7U48YnyFyKM/peqP+G//TLPpVqa9hiRoQ9w4a9hH0Tt/nusuzws+AEy3l3d/QqeYl
         n91Pj2SA0I54I+8t7JY+iyGfx8atcQUjFMeJ+4vhGtNTCoK+tL2tlYxB4fwYG7DSaM6/
         MZ+zDdet5PVua2gtYoaW5m8w++BL6Q6yL2cWhQZxn/NHK1YHN8FRm6V85Cq3ARPlGqey
         SjXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uIqUtHaa3fDMkmu3xX2bwporJYMUaefca/7Wsj4lcEg=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=VnT5fcBEiwd2FP8ieHGZaitfscq7xFJ5g80coOyNASMQhtwyV7cxQaSzudMkYvjqG5
         aJsFWon7XsXJ8VryjkT4ImBVHB/n0OrQPpupo4D+6Eqmmnlzpq6wqia6T2kjlNKnkFs8
         nvJw9xOATPlmYDAkW9G86vIRp1qfUeONEYrrrVxrknrtiTmEu+4IIMaBAfMTUPkuRruS
         X+lQ7X514UeBxgxWlVyChgcpU/igwNZpuJDOLuWTKa4ISfIz3UUwDucvdko5/Rc+3iPc
         B62zj6nDZPlxtPbye4gAapVHFMj86YNjsTOQCgWIyJpxb6dCOJSU5K2cAEzY9EMdUyxI
         Kwtg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769094508; x=1769699308; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uIqUtHaa3fDMkmu3xX2bwporJYMUaefca/7Wsj4lcEg=;
        b=Zl/qSjLm9Io8HeKwq412NPIHKu//zjcTuwrryLvBJTutKtJy6mRmI9hXphm+AToe4Y
         iYlSlAHdb+GhpdLUItMkKejdMtQWUOaTlFlPrY5SvoYrbdro/bM9aBX5Ba6aVKDjdaKD
         umDABqMwCmmcvpOAyiFXuQnJnC8WXB2OF/FIvjNiz5w+FYPQkOOQ6l6ZU7yhFucaPF7r
         16tga4zNgdULkiZKrQA487tS+ykVes+2ONS3toQI0DUrDKZWGeu1TbyDMgUquenBawbT
         t8P7hLCad/djgLiC+vE3xLaK6Bel9+BbtIFrrtpKxcgIoqWq3rIrihDhuv4ZiWt19wr5
         pJ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769094508; x=1769699308;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIqUtHaa3fDMkmu3xX2bwporJYMUaefca/7Wsj4lcEg=;
        b=pbKhlsKKkGBwLeJWme93YE7RVCjxjzzClSehBFg81R5BZS3vvSwRpbqzEKlCIcmBNp
         XcUtcfTyueqkRhxSTqdOzcW8Godqnh6aaapgAW+FGzWDc5fjnegc4qMbJ4hRhwV9RVho
         djRQnmRG3hkGIDZRsV0pwC+SxO6QRYNh2FwOf/idr1GzKriATkxpZGZAbrULpv1bhKKG
         5xOPpteCJdYNbCR+kdh/+i7+9Nt5Es3lhLl8T408l2rkI2Gqougxc1YQTqj/39aebi1c
         hNrE3CzVgc7FBi5KY1Ju75gBNmP1sc0OeF5l2cXdSfU7Cyw4CctgIjTP36lBnwFrSEU4
         2shQ==
X-Gm-Message-State: AOJu0Yxf46UVCkXjmVHX8EwDY+aN08HreaP5Agr2pAiDUsWEtElkbz5y
	cBXHX9LsVw32y+UvcHo2QVVV18FkzqXA+ziXDvUka5RWD/K0fRzYPUbMpwk6oCvoZaC88krHEhf
	9eDn/YCvjTszFHykMLfX14DQex8H975qrE2LsX5/4
X-Gm-Gg: AZuq6aKCnOu3Nn7iDX8XjbJQ0+yUNyS09KXnbI3f+fTNNjH9xdlwzEbjBd3Iglyki9X
	fnh2FckTQphDqMv49/KxGxl/vXIJHOnKRbCj5oMJ4Ay1Ca6eSlT/UrvFn6SNbAm+icK4OTQqne3
	fFZNgOwSxC5KdbbpctEh+5VeDeKk9m6X4o0HomaeGQvuPo1S2w1B3O8ZID7FKAR5cBzWD3UMX2T
	RGkPoM6vqssF0vLSOx/rfW6Fp8DtbLTcA9duOUAyY41XNu5BbyXXSyM0SnuNXUJnO0d3D5GAT1c
	EzFa6NMN4RdfPfA7rXeADqyEjA==
X-Received: by 2002:a05:622a:1394:b0:4ff:bfdd:3f46 with SMTP id
 d75a77b69052e-502ece37d74mr9505941cf.15.1769094507375; Thu, 22 Jan 2026
 07:08:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119105651.255693-1-maz@kernel.org> <20260119105651.255693-2-maz@kernel.org>
In-Reply-To: <20260119105651.255693-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 22 Jan 2026 15:07:50 +0000
X-Gm-Features: AZwV_Qh6OJ3XDx0KYwplAZkpiFx5faOmuYbi-9K2EsoJeKTcMmvZRwIumA1kCv8
Message-ID: <CA+EHjTxiGSxG6DpXxY8Qw3uSceYn46QBsrYi2de1j+1Q0j6qkg@mail.gmail.com>
Subject: Re: [PATCH 1/6] arm64: Add MT_S2{,_FWB}_AS_S1 encodings
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 19 Jan 2026 at 10:56, Marc Zyngier <maz@kernel.org> wrote:
>
> pKVM usage of S2 translation on the host is purely for isolation
> purposes, not translation. To that effect, the memory attributes
> being used must be that of S1.
>
> With FWB=0, this is easily achieved by using the Normal Cacheable
> type (which is the weakest possible memory type) at S2, and let S1
> pick something stronger as required.
>
> With FWB=1, the attributes are combined in a different way, and we
> cannot arbitrarily use Normal Cacheable. We can, however, use a
> memattr encoding that indicates that the final attributes are that
> of Stage-1.
>
> Add these encoding and a few pointers to the relevant parts of the
> specification. It might come handy some day.

The Day that Never Comes?

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/memory.h | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index 9d54b2ea49d66..a2b7a33966ff1 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -175,19 +175,24 @@
>  #define MT_DEVICE_nGnRE                4
>
>  /*
> - * Memory types for Stage-2 translation
> + * Memory types for Stage-2 translation when HCR_EL2.FWB=0. See R_HMNDG,
> + * R_TNHFM, R_GQFSF and I_MCQKW for the details on how these attributes get
> + * combined with Stage-1.
>   */
>  #define MT_S2_NORMAL           0xf
>  #define MT_S2_NORMAL_NC                0x5
>  #define MT_S2_DEVICE_nGnRE     0x1
> +#define MT_S2_AS_S1            MT_S2_NORMAL
>
>  /*
> - * Memory types for Stage-2 translation when ID_AA64MMFR2_EL1.FWB is 0001
> - * Stage-2 enforces Normal-WB and Device-nGnRE
> + * Memory types for Stage-2 translation when HCR_EL2.FWB=1. Stage-2 enforces
> + * Normal-WB and Device-nGnRE, unless we actively say that S1 wins. See
> + * R_VRJSW and R_RHWZM for details.
>   */
>  #define MT_S2_FWB_NORMAL       6
>  #define MT_S2_FWB_NORMAL_NC    5
>  #define MT_S2_FWB_DEVICE_nGnRE 1
> +#define MT_S2_FWB_AS_S1                7

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad






>
>  #ifdef CONFIG_ARM64_4K_PAGES
>  #define IOREMAP_MAX_ORDER      (PUD_SHIFT)
> --
> 2.47.3
>
