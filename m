Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435DB2C08D1
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 09:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770111630; cv=pass; b=SDLOV2V96MP2fU2qzTAZzT4NpA9tqRSUG53+vGL248Z4xV6D9Pr7IlEDfqSKkPSKEDrekkS5dKgvHv7R6rbTseHjBDmd2qCGnKY7stu6jPsMFkrfNLQZ/s8jj5ox5jK/LOk6UziTs7/Jrsp57z26TZ/JIKViMkZ5U0rJ9hWL84c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770111630; c=relaxed/simple;
	bh=F7oytjxQ/ZM2+D72Ivu9+6l4pfn1cS7+cfPa4Xr1Y/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N+4lYP2N/cd7MVTWE31bUegwkN/SYPa49aogJn/MAc733I8PuyphTGaqtbWvACsZ5LfSU/lkde2mSsVpQVpVTTrXf/pyyUT+0kabP7i+wnGruiDOaQ7VrhD1yuo5AqfkWpJem7MxrE7drsj8hSkcmaxL6HK4jPN2AfWMFHtJlpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2yrT3UD6; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2yrT3UD6"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-505d3baf1a7so346131cf.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Feb 2026 01:40:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770111626; cv=none;
        d=google.com; s=arc-20240605;
        b=GoWX0vnzIG5jZUFmOQUrIkd6cxbFuEkeOBQztrnlNDi5qYbo+W7jntA7rcL584/ffX
         TbJ9tCjoRXIvdGjwkWk6gYCYzKs2mTrX6s3Zmi8hEPgLCg6DL7G+4wayfehK94LqhsAx
         jwjRfwaLkgV04eiIK14TotqMX9a6BXq/E5a+SwWog6wxDvosI1quLYqXbBHdfUb7jc42
         7xZJGFaOhqFaio49gNh/TbfS1j6c2+cfN342ZjaLI5XlG8GTii7Xyb7GJWRhXnzQeUNH
         G01Q+bFpeTAAEmzzyzcNRWSy7NQw5Ja7uiSOBBpxUgLvkqjDAaUDBDPKZ1FdvVUvfvv7
         N0bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/iLRVFcvI8PBqaXa13EXF14ab440i5Z61zkbAzzGqTg=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=drbr/Gy1+dY8e1gtqLcMuMZCDL+O0ZZhBhrO+B13gJsnfSmH6c6FznbU35UWLSkYOa
         ioVC6sK1fucy4osvGRYGrJ0qU3rZqnpQ217mm7m+h3DgbEwCUgu37x2pIjTK2bDL7tBq
         /Lud7lmCuUJttIBfSZNuhehvOiqo/tvuopmTHihNZYNmbyif8tZGt/plkjTae98GXTOC
         NRzbMRs4mBY4gvWTbMEM3/l2q5sl10H93K/+mKJJdtLScfwSLziVRI/omFD/51+jN16A
         8sIUCSVyJJ9n8lmPLuwodiTdo/JVf/xYHsdrFh8CdGlVhoXSy076C1Mkkps/Vg1yfP8R
         7CCA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770111626; x=1770716426; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/iLRVFcvI8PBqaXa13EXF14ab440i5Z61zkbAzzGqTg=;
        b=2yrT3UD64T0Z6JZ7zb9Nd5RCkTs6Fd7PWJ2meaeoxgOMnNVY2Bsq6OKc2ChYlHX3Fj
         B24sg1tAiNPH+zdS9hNNf5xB6pUtkhaiPtRRnAGCGzinzV60HZnqd88cI0yhrWmW4kcu
         NpfewWtWs9+n6QGd0RLQi6/VUy+Umlm34JyrOB5Y2g8CWeFBu/SxFoCrohHf1cw82LRN
         UFBayoRcwEe5kAEjMG7phOf/R+kccnApe8TMe1Gqc1wkRmzF5H1cS33D9n3lUY1Ay8lb
         O/LfaaX3OF61X4xzuVX3wvucglV9imfms3CBfTwa3HdiJnzGetMp/jJh69gkESX+6z9n
         +AYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770111626; x=1770716426;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iLRVFcvI8PBqaXa13EXF14ab440i5Z61zkbAzzGqTg=;
        b=ZALODGb6oha0nn8KN4YIy0P7RxNTfZM9tCp72eNg4C0fNHgtleHTW3NDcoewWPQkuH
         eDlOXHAJXjZFOP+sPjIX1IngjCCkV3v/ni0Wq2CWcqhohHsh3J65e8GAA4AeeQ2rbXcK
         2SzT6JHtWcqpWqXoH2RGPDPvOkd+mV2rBnZHt+nIfF2uVGOIwsVfsLTjzsVr3THFqCnX
         HWB9B0+D7pXBR1Gg48pLOyzXiZQnccytNkhrPkixr1XcRyd+3pq4Sm0XXSbSwIxl5rcu
         x99la7dlhD17fagSdxpL4No2x+HIiGNiponJlMgJvsEicDmmQ+o4GX/eHZwOFhh6ej6y
         y4ew==
X-Gm-Message-State: AOJu0Yys6a6uFZBW2RsaMmjx0njc5RG2t3cnIEPOZG6d/XcqqLaoVUWT
	nz7rOd8qtWtkLFtqqapcoIGMJheiSSefB4z9Riv6vabBxqfIYERZt11gTTNHm56XI0KzQpSiOrg
	lySJTq5hqmV+s4SDrt89gG7bXYNTs9yp9eUjeava/
X-Gm-Gg: AZuq6aK/74PaIC6uDVsNIJxsEcWmcgldmjmxekHoMmzZxf2PJfIC6K3TDaJ9pjltn/V
	KlPF9IPDKH0V4JM5zZVmNfdN4pyYVuEFQWg4PI5pvm6UiFk5tdFm5hSGnob/4g39JkB2z1D4xWm
	FSqQltsDwbtjPsghXaWtifS5BVT9IlIUiJCjNiDl5y2mwC42Fq7XQMlCMRa0ciyNr9frGxhJnvU
	k8a2bXQnHoolrJTS4fw6AFl8C8x3PTH2qt8YjeBOELKSbuS2R37lJilCJzD9On+JaAqoEZ5VZdl
	oD7DpkhGbnqo9Unrbgxc2QjjfGAywBllEZzk
X-Received: by 2002:a05:622a:e:b0:501:4539:c81 with SMTP id
 d75a77b69052e-5060f009ad3mr4642661cf.2.1770111625864; Tue, 03 Feb 2026
 01:40:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260202184329.2724080-1-maz@kernel.org> <20260202184329.2724080-13-maz@kernel.org>
In-Reply-To: <20260202184329.2724080-13-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 3 Feb 2026 09:39:49 +0000
X-Gm-Features: AZwV_QgvgYBl296K0duqDRaBXXRaqyX8U8f5zkdPWeOZQX-Dkj3fpYJk1QlQ7I8
Message-ID: <CA+EHjTwvXhzMP7WYQycs5CdPD1u-Ycj32-L1kC2Qvw4nmyempg@mail.gmail.com>
Subject: Re: [PATCH v2 12/20] KVM: arm64: Add RES1_WHEN_E2Hx constraints as
 configuration flags
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 2 Feb 2026 at 18:43, Marc Zyngier <maz@kernel.org> wrote:
>
> "Thanks" to VHE, SCTLR_EL2 radically changes shape depending on the
> value of HCR_EL2.E2H, as a lot of the bits that didn't have much
> meaning with E2H=0 start impacting EL0 with E2H=1.
>
> This has a direct impact on the RESx behaviour of these bits, and
> we need a way to express them.
>
> For this purpose, introduce two new constaints that, when the

nit: constants

> controlling feature is not present, force the field to RES1 depending
> on the value of E2H. Note that RES0 is still implicit,

nit: , -> .
>
> This allows diverging RESx values depending on the value of E2H,
> something that is required by a bunch of SCTLR_EL2 bits.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/config.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 7d133954ae01b..7e8e42c1cee4a 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -26,6 +26,8 @@ struct reg_bits_to_feat_map {
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
>  #define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
> +#define        RES1_WHEN_E2H0  BIT(6)  /* RES1 when E2H=0 and not supported */
> +#define        RES1_WHEN_E2H1  BIT(7)  /* RES1 when E2H=1 and not supported */
>
>         unsigned long   flags;
>
> @@ -1297,10 +1299,14 @@ static struct resx compute_resx_bits(struct kvm *kvm,
>                         match &= !e2h0;
>
>                 if (!match) {
> -                       if (map[i].flags & AS_RES1)
> -                               resx.res1 |= reg_feat_map_bits(&map[i]);
> +                       u64 bits = reg_feat_map_bits(&map[i]);
> +
> +                       if ((map[i].flags & AS_RES1)                    ||
> +                           (e2h0 && (map[i].flags & RES1_WHEN_E2H0))   ||
> +                           (!e2h0 && (map[i].flags & RES1_WHEN_E2H1)))
> +                               resx.res1 |= bits;
>                         else
> -                               resx.res0 |= reg_feat_map_bits(&map[i]);
> +                               resx.res0 |= bits;
>                 }
>         }
>
> --
> 2.47.3
>
