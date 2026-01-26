Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C95226D02
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 18:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769452611; cv=pass; b=TDlCx3U/OxqlbBuZV8dew29Dr1+9TfD3z+VyfrY6ppfQ9fIpuxtJC3OZtqIgYaSbeWAqeWDylEXSxZnhz+Gq5WdwjQrDXIYTAz/+nXTNbJ+dU14n16t52qyCykkJDK1GWD9YmjAUOiYOE+l0t+uS5TMnO9RU/o3JRZVaxGHTOxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769452611; c=relaxed/simple;
	bh=vX1fhktiscd2cjtz1zbJNk4NfMz5KeG+nW9kp+MQDZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MnKqsv1X1v6LBLb4ZFFiQH2i1izbN4ZC37Y+lGk5Vxd7d+NPVnwhDm4J+RX2OiexupQlkypofqN6z+XPqekXB2wyUWJiPvlqOAPQ73pFTF3AEeQxzcsExEAZsojHxaPZu7OFIyidCxucl2S8QQa936M+w1b1UBZFj8XKt8JeMjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MSeqSN3s; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MSeqSN3s"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5014b5d8551so42671cf.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:36:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769452608; cv=none;
        d=google.com; s=arc-20240605;
        b=NP7BJMquKO3SSNZcRMPlSpeyS8CHp+8O5Rxv1MEL04ZvhWyU/fE+S+98T2x6Tf29S0
         rhgN1k8Wcqb3qRFsUz019ao1QjFjcGwfve3A8wKXZqIJ2jZVIYwkfweq1Cvv2DVPv8wI
         2ZSknoS54LMBHD2fFb3w29k1BGEqEYB/k90C6jxx3234iZ7Qwvv2PrmWzvqXjxv+kxTT
         /bCwmdZWR91km45zCu8U+CPXwlj1NY+5opnxjOyyj4iPaMBKQvG3/JK3+2PLTK/3roMQ
         YkyNJf/whVqRC9e+o6iHoRjoi8bAN9EXVq4IqdAP4bJFGZCJYXT+UI9Fq34Vo2mC6sI2
         mP/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Nr6ZY9QUfU1ONCnN3zu+tZf3955xHGY/dQF3/cqaDvg=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=RY9U2U6k5ml0zU+L+ytC7YaFwuhckDdESNZtDiiPwq/T7HCg5t6C1l8p7oohRdi5dQ
         7vqKISgMMopKTrkNBw7q3OcToOQxa9rRDmE0JbGT2zPgTlN1/6e0xFM6gGV0JZ21HP/J
         9ExDn3nkDTFAgrI8U8HmooaeapPJCPMX5QMdADgsHVr8ckO/R+E4SO0CGOJYqgohlMsY
         HLn1liQrz5CySiAeTDiC3CGeASoVLAzb0SECitk5EvwS1PprpIMUn4cQQj6i6BOtiCpj
         1XfNTXddLuANYzRDL/6J0JLgyeiA+L2iJFX1vZax+Sd3xabP5a7ZWptB0bhEeg0sHV0S
         0eXA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769452608; x=1770057408; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nr6ZY9QUfU1ONCnN3zu+tZf3955xHGY/dQF3/cqaDvg=;
        b=MSeqSN3sDczYJjFnj13lbJimI7kUUYe5V5/x4BwW+me1oLh2TNRuAHXvAlXwxuSBWL
         ijI2rGGrBrbROH3jWdW9Ag/nRHCm9X1GeqxHoXmqTPKY4WdcNZ/KiMNN73pl9+Z+bnMC
         txkAEzwKwqTHad9jmphMXaunm/7WUbFjVT04SJC6j0/Hia4s6vwdClOpB9xLeQ0q8h5w
         XO/TAqH+SF1v3tGAW5fBu3BOntgCqu8paU0dTsG2ghNJCuTTKzLP7+GVIjBekBGOOdBv
         qImszc4OyyNyARp8uKo77v7g7UsgclrU8r3VxSm7jOoIaittPrlkluPJcybAroUY7UBh
         G+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769452608; x=1770057408;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nr6ZY9QUfU1ONCnN3zu+tZf3955xHGY/dQF3/cqaDvg=;
        b=apisaJOpKEQY1ft6upODrPi5AjE3fJo7uCW+YIzIL/dzIpNl9+UepGTO364uVaMaKO
         zEMEwmDqaia9mkf+iua985D+koMnbqOYM4+WeGludWQUAJvR1rHn86qz4XOR3HIfWEGY
         8Ohk0csopVlVAL+juk0Sn4MvCQbGbvwADywvBtl4acmAtOz6cMIxJyjIqaVQi35Bmmxd
         KHyF3fnHEqfQacgYoVqtPLJwwphxxUMck3uFxbUxWPLnmSuIflwT3yywp0bF5Nlalx6b
         9XKtnYw3/J4jhLvEA94EROymSvc/U+vU/lWR9fZOolQq72NaIJ/x5mmkwxj21yZeoBXE
         1MwQ==
X-Gm-Message-State: AOJu0YzqG0ZRlv3xUS8KkWyliLOsoZxCl+qNKvatSBAAWrGRXjro+wDt
	Fc+fml2Oa8eyQoKAjHojKZYuUKZMJal4mQEYidLofr8aam1cad02eGoaKj5cHbq7utE8GyvPo1R
	SfeX2akSz91xdmBtQDEIuZ2thMMetieEUBUnp0sXn
X-Gm-Gg: AZuq6aJuZTfPa3oqhraElGxAE76mgApmYPQf7x1KPKzYJx6PZtScR+cfXD5YUXLYNMe
	CdijryaTqiAFziuhuOPrpr/uUXbqdODhQzETiJjKbsvYC4e82E2EyIXdicCjbCn9n+6jkPE+86k
	+E7hqPQdbTtLvmsH6INPutQdNcZL8W8Pm2hu/jWYYwHvbN/DKAEGvOJQOqUtktbkyT6Gjc/WVsD
	yCisjR+ImDk+nPbRc6PP0bYdemjh65w5rqjJgThumv4Kx5VYxr2BefHggLD5PNxLuNBX5Go
X-Received: by 2002:a05:622a:14c7:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-503143735c5mr1861661cf.14.1769452607562; Mon, 26 Jan 2026
 10:36:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-4-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-4-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Jan 2026 18:35:00 +0000
X-Gm-Features: AZwV_QgxoPZSd-obyO74bD1D2orgbXY4GVKiKLrcaTbXWiYTi356mxofCsFsPUg
Message-ID: <CA+EHjTx3C60LaoMtCRH5eYNBmNGPEX+0XHtPgTk7OWjc8MTByQ@mail.gmail.com>
Subject: Re: [PATCH 03/20] KVM: arm64: Introduce standalone FGU computing primitive
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Computing the FGU bits is made oddly complicated, as we use the RES0
> helper instead of using a specific abstraction.
>
> Introduce such an abstraction, which is going to make things significantly
> simpler in the future.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

The old way was mixing "bits that don't exist" with "bits we need to
trap". Here the distinction is clear.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad





> ---
>  arch/arm64/kvm/config.c | 57 ++++++++++++++++++-----------------------
>  1 file changed, 25 insertions(+), 32 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 0bcdb39885734..2122599f7cbbd 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1335,26 +1335,30 @@ static u64 compute_res0_bits(struct kvm *kvm,
>  static u64 compute_reg_res0_bits(struct kvm *kvm,
>                                  const struct reg_feat_map_desc *r,
>                                  unsigned long require, unsigned long exclude)
> -
>  {
>         u64 res0;
>
>         res0 = compute_res0_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
>                                  require, exclude);
>
> -       /*
> -        * If computing FGUs, don't take RES0 or register existence
> -        * into account -- we're not computing bits for the register
> -        * itself.
> -        */
> -       if (!(exclude & NEVER_FGU)) {
> -               res0 |= compute_res0_bits(kvm, &r->feat_map, 1, require, exclude);
> -               res0 |= ~reg_feat_map_bits(&r->feat_map);
> -       }
> +       res0 |= compute_res0_bits(kvm, &r->feat_map, 1, require, exclude);
> +       res0 |= ~reg_feat_map_bits(&r->feat_map);
>
>         return res0;
>  }
>
> +static u64 compute_fgu_bits(struct kvm *kvm, const struct reg_feat_map_desc *r)
> +{
> +       /*
> +        * If computing FGUs, we collect the unsupported feature bits as
> +        * RES0 bits, but don't take the actual RES0 bits or register
> +        * existence into account -- we're not computing bits for the
> +        * register itself.
> +        */
> +       return compute_res0_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
> +                                0, NEVER_FGU);
> +}
> +
>  static u64 compute_reg_fixed_bits(struct kvm *kvm,
>                                   const struct reg_feat_map_desc *r,
>                                   u64 *fixed_bits, unsigned long require,
> @@ -1370,40 +1374,29 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
>
>         switch (fgt) {
>         case HFGRTR_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hfgrtr_desc,
> -                                            0, NEVER_FGU);
> -               val |= compute_reg_res0_bits(kvm, &hfgwtr_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hfgrtr_desc);
> +               val |= compute_fgu_bits(kvm, &hfgwtr_desc);
>                 break;
>         case HFGITR_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hfgitr_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hfgitr_desc);
>                 break;
>         case HDFGRTR_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hdfgrtr_desc,
> -                                            0, NEVER_FGU);
> -               val |= compute_reg_res0_bits(kvm, &hdfgwtr_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hdfgrtr_desc);
> +               val |= compute_fgu_bits(kvm, &hdfgwtr_desc);
>                 break;
>         case HAFGRTR_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hafgrtr_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hafgrtr_desc);
>                 break;
>         case HFGRTR2_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hfgrtr2_desc,
> -                                            0, NEVER_FGU);
> -               val |= compute_reg_res0_bits(kvm, &hfgwtr2_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hfgrtr2_desc);
> +               val |= compute_fgu_bits(kvm, &hfgwtr2_desc);
>                 break;
>         case HFGITR2_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hfgitr2_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hfgitr2_desc);
>                 break;
>         case HDFGRTR2_GROUP:
> -               val |= compute_reg_res0_bits(kvm, &hdfgrtr2_desc,
> -                                            0, NEVER_FGU);
> -               val |= compute_reg_res0_bits(kvm, &hdfgwtr2_desc,
> -                                            0, NEVER_FGU);
> +               val |= compute_fgu_bits(kvm, &hdfgrtr2_desc);
> +               val |= compute_fgu_bits(kvm, &hdfgwtr2_desc);
>                 break;
>         default:
>                 BUG();
> --
> 2.47.3
>
