Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB372F39A3
	for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538087; cv=pass; b=CajZPGHuXZUXooSyF9DYGRacEImJlXt+sftvtT/LNmDE9VVlbiGUdvILDrWD/HSUbaIGv4EIQZ8rOn3S+bhGv38iDpeZ7gmB30AhbRhexreGEFQkH/lg1sSO0jCFHGCtZXPHWcelGK9KQ0no2ErAsyWZM8uGsl/9GLwoGgQDYY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538087; c=relaxed/simple;
	bh=g/5hkAwC8K8uuKp+mUsVYSQJdxRY3jyLmOOMHdLbhsw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ohYnJsnnOdRzibpEcJ6lEFtexwego48x763D92d1KuAX4fD5nbUWdGmOami5w5kJgYerY+JHTa6BdsTsQaHcCr+dLwCgE4r07gTAd7cJ8lVH1kSYI4UM89rwVYMbl0T3j8ZnGv5eSXKg0dPVjDBjmB5BgXTc6t4XbJeprb72J8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WK/FWvPL; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WK/FWvPL"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-501511aa012so34421cf.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 10:21:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769538085; cv=none;
        d=google.com; s=arc-20240605;
        b=jTJDpfs2GUULDLbt/6VyYplJW1HMt+1LnQIOu7Z80PhoymyLspm8yBpVGVPZ1naxof
         7X5W8ZpMDx1aZ7QjhLgyd915V98X5sjLMYi7UT2X7ugBuD8JW8RP7LlWBVymCuQhQ9EF
         mG401hXmsqNdNuBkmu+OHjcl1uaMHq9Agx2bAvGHVVCde+FD6m8vHRG+pqDpPIXJacWf
         wdJvzpdTndChyefjlZ0fmtLJg4DcYDp/3YYxmLZYcnP7NgHK/ekTiS5OicARWQ/IisQs
         UpP8YZp3L4eYLKOc0ZbguNXnsXODNQaJnERCNQAQOqtbK/bcU/BdOvRbMd0f9eFh3mMb
         8RVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=v38EWj5h/QCAdjN/pQcmdZuKsr9ZCCkUgpYACTXDljc=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=GfrLUsyBl3v1MOsC6BN0hD0SKjHRbjTrEVd0nFr0u3rgMf0+qtC7KSdM+fPgKoNj5J
         wsUBBGIB41DwQS1HJTt2SeZBUDi9zUuEJcJMUFCwLSnCmXwh/5tpLxazSwdzRnsaNUdM
         bj6RpStLe8g3AEQa2gRdvoiAbgXL1gCJLdVneAFqw8HEp/e1t5R6S2fQiCbvqy4E3FiY
         cXMu5GsvDTpe7xvtOan8SYVOIIA2nXqn+r+WmRe3kLwfSkMHWaPsFMXdjU6QendsczkS
         GLu0wBMZ9dMYrlLQAvTQFA3l0ByYc7JiGd8reM50OuBDZL926aglbJ3DSHK5pNmHBt/L
         Bk9g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769538085; x=1770142885; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v38EWj5h/QCAdjN/pQcmdZuKsr9ZCCkUgpYACTXDljc=;
        b=WK/FWvPLlsiWd1KOnBCOB95oV8yjs++ztNwfALDJ+3zsN/LkEOlX+OEyJonDC0BC3h
         SbipMS0CLx0UUeLNT1nUwGtAVLgXs1awKy2BBgFIw1feRh2STF7J1f/pvgQrSWyJs0M0
         PheGW0ehuddXHjuRqYptewBrygm12PGS4W//XUohAdY0bEzkk3YroGrVidWLKC6d+d3P
         b/UiXzS0dZ6S2vOMfNNnoRtN+iCEobVbJ/05d8IRSAYWg2ZVsuxXAbJNi6bUmTmf/Mft
         5jCc9S88xRWQtHQb+VLfzrtIdfdC8L1SSP4L5+eccQTUvNdO6B9v7/kPjutOoL0CIIvj
         cdEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538085; x=1770142885;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v38EWj5h/QCAdjN/pQcmdZuKsr9ZCCkUgpYACTXDljc=;
        b=vGd7fkMlDos0sJdEbcN8jRmJzyeRASGHAhY3xN2j2A8a3PbSqTtpmJjV7QHPZnd1/3
         sWvkE0E/o/VNKwDJ2tSKstl51Pz5QzktlxAvbOCU6kUDV5fY2gE2J+ESvR+RbeZZ+GWU
         VqX7V7w693YvXR2ZXbeT/AJysBMmGMY0QV6YG4JQvxLxuYCKf8mtuwTrYy6mFfAURmrC
         oUgk91ABe0oLsg69D966psn77mJGnhW8+ywHz5v78IKgi+pkf5jSTWZp3EeaeBxkFaQG
         SGMNGQbRXN9gvVV/umw0yvsnns3YsixNztvP4n6GC4k95ccZwJH71Zu2Y24sNPWMIsey
         HuVQ==
X-Gm-Message-State: AOJu0Yzgu843/aAnWSP+X4iyuXPakEqxM4wuLHprFBcPRG/9oMYyxIgP
	nGVDRzp5eYmJsolT2AekRsxaJLBIVCqrlKV/1qgQHKmQOqdidhnXaYfOdwn0yyMPjLbX5u9FWCg
	5FglojJKfOFE6lWrnSBbsT+3bmRxtb5zSlXw6ECfc7NWWNZwaVbIBZozttg8=
X-Gm-Gg: AZuq6aIbjYAe2XOdzF+1fC8G24qFv3TciFiAzQAfRS++PdlbOT497lu6zwnrsvmyx9l
	NJKRObxKCGEodFwZV/ETBrtU+SnB0J0w7qrP7/aN9+z1wazsGNmqSEKgeY5iNC8b8hjD8PRwBTy
	8777GHpHh4f8SALIhOEkixU0+cRKQmoHRN8IIaLBD5ADx0/M8KFWw0OEmheXzgkM25BAPaJj9YN
	TYJ1/rw0zNLLf2S7SV8p0zxZ6M1OydUvYsBvlMw3Auon3ttyJfazn0yKNHH0OfC9x6IiG2Q
X-Received: by 2002:ac8:5f11:0:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-5032f52b23cmr10650801cf.18.1769538084451; Tue, 27 Jan 2026
 10:21:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-11-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-11-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 18:20:47 +0000
X-Gm-Features: AZwV_QgHSiyi6-Py8aoEMg3B72DbuTR2OJAKTX59HorEV0HuWAtLNErLntzE9YA
Message-ID: <CA+EHjTzjRHXJMDKc8GY=8aQ3KJeLYSQYMH_tA03XMav=0VQ7RQ@mail.gmail.com>
Subject: Re: [PATCH 10/20] KVM: arm64: Simplify FIXED_VALUE handling
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> The FIXED_VALUE qualifier (mostly used for HCR_EL2) is pointlessly
> complicated, as it tries to piggy-back on the previous RES0 handling
> while being done in a different phase, on different data.
>
> Instead, make it an integral part of the RESx computation, and allow
> it to directly set RESx bits. This is much easier to understand.
>
> It also paves the way for some additional changes to that will allow
> the full removal of the FIXED_VALUE handling.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

The new code preserves the logic, and is easier to understand.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/config.c | 67 ++++++++++++++---------------------------
>  1 file changed, 22 insertions(+), 45 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 39487182057a3..4fac04d3132c0 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -37,7 +37,7 @@ struct reg_bits_to_feat_map {
>                         s8      lo_lim;
>                 };
>                 bool    (*match)(struct kvm *);
> -               bool    (*fval)(struct kvm *, u64 *);
> +               bool    (*fval)(struct kvm *, struct resx *);
>         };
>  };
>
> @@ -389,14 +389,12 @@ static bool feat_vmid16(struct kvm *kvm)
>         return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
>  }
>
> -static bool compute_hcr_e2h(struct kvm *kvm, u64 *bits)
> +static bool compute_hcr_e2h(struct kvm *kvm, struct resx *bits)
>  {
> -       if (bits) {
> -               if (kvm_has_feat(kvm, FEAT_E2H0))
> -                       *bits &= ~HCR_EL2_E2H;
> -               else
> -                       *bits |= HCR_EL2_E2H;
> -       }
> +       if (kvm_has_feat(kvm, FEAT_E2H0))
> +               bits->res0 |= HCR_EL2_E2H;
> +       else
> +               bits->res1 |= HCR_EL2_E2H;
>
>         return true;
>  }
> @@ -1281,12 +1279,11 @@ static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map
>  }
>
>  static
> -struct resx __compute_fixed_bits(struct kvm *kvm,
> -                               const struct reg_bits_to_feat_map *map,
> -                               int map_size,
> -                               u64 *fixed_bits,
> -                               unsigned long require,
> -                               unsigned long exclude)
> +struct resx compute_resx_bits(struct kvm *kvm,
> +                             const struct reg_bits_to_feat_map *map,
> +                             int map_size,
> +                             unsigned long require,
> +                             unsigned long exclude)
>  {
>         struct resx resx = {};
>
> @@ -1299,14 +1296,18 @@ struct resx __compute_fixed_bits(struct kvm *kvm,
>                 if (map[i].flags & exclude)
>                         continue;
>
> -               if (map[i].flags & CALL_FUNC)
> -                       match = (map[i].flags & FIXED_VALUE) ?
> -                               map[i].fval(kvm, fixed_bits) :
> -                               map[i].match(kvm);
> -               else
> +               switch (map[i].flags & (CALL_FUNC | FIXED_VALUE)) {
> +               case CALL_FUNC | FIXED_VALUE:
> +                       map[i].fval(kvm, &resx);
> +                       continue;
> +               case CALL_FUNC:
> +                       match = map[i].match(kvm);
> +                       break;
> +               default:
>                         match = idreg_feat_match(kvm, &map[i]);
> +               }
>
> -               if (!match || (map[i].flags & FIXED_VALUE)) {
> +               if (!match) {
>                         if (map[i].flags & AS_RES1)
>                                 resx.res1 |= reg_feat_map_bits(&map[i]);
>                         else
> @@ -1317,17 +1318,6 @@ struct resx __compute_fixed_bits(struct kvm *kvm,
>         return resx;
>  }
>
> -static
> -struct resx compute_resx_bits(struct kvm *kvm,
> -                            const struct reg_bits_to_feat_map *map,
> -                            int map_size,
> -                            unsigned long require,
> -                            unsigned long exclude)
> -{
> -       return __compute_fixed_bits(kvm, map, map_size, NULL,
> -                                   require, exclude | FIXED_VALUE);
> -}
> -
>  static
>  struct resx compute_reg_resx_bits(struct kvm *kvm,
>                                  const struct reg_feat_map_desc *r,
> @@ -1368,16 +1358,6 @@ static u64 compute_fgu_bits(struct kvm *kvm, const struct reg_feat_map_desc *r)
>         return resx.res0 | resx.res1;
>  }
>
> -static
> -struct resx compute_reg_fixed_bits(struct kvm *kvm,
> -                                 const struct reg_feat_map_desc *r,
> -                                 u64 *fixed_bits, unsigned long require,
> -                                 unsigned long exclude)
> -{
> -       return __compute_fixed_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
> -                                   fixed_bits, require | FIXED_VALUE, exclude);
> -}
> -
>  void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
>  {
>         u64 val = 0;
> @@ -1417,7 +1397,6 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
>
>  struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>  {
> -       u64 fixed = 0, mask;
>         struct resx resx;
>
>         switch (reg) {
> @@ -1459,10 +1438,8 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>                 resx.res1 |= __HCRX_EL2_RES1;
>                 break;
>         case HCR_EL2:
> -               mask = compute_reg_fixed_bits(kvm, &hcr_desc, &fixed, 0, 0).res0;
>                 resx = compute_reg_resx_bits(kvm, &hcr_desc, 0, 0);
> -               resx.res0 |= (mask & ~fixed);
> -               resx.res1 |= HCR_EL2_RES1 | (mask & fixed);
> +               resx.res1 |= HCR_EL2_RES1;
>                 break;
>         case SCTLR2_EL1:
>         case SCTLR2_EL2:
> --
> 2.47.3
>
