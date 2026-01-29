Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B16B3570AF
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 18:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769710439; cv=pass; b=eVjKosb9HBFLfIi3lthjyC8a41hGUurEQSUyEqhfgiNBUqHF19HK7VfLj4QHsdg1rxVZ13a3JMQOSxmrSFruiNHqgktj242/vpnG5wb9l1s3MvnaD/6f9zenV4ejcubtbfLs7edEKwXF+1i7wLqgKszYEfQEdoHhuobk4hxKbpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769710439; c=relaxed/simple;
	bh=yHb3p2o4wgMcF55JscMbe7n4TM3E7DPuyumFVJ/+Qbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gQABapTu2oD5IgK8cHQ2nK8JJLzgRstaMBI/auUu6ymRXDkzAvNfNltqXJDl//RET8JYBt21kS/tTSXc/wGX99brxp/eh0/W6QWezs4q4XY7+7NO7kWpq0YXfqjPYOlJ/owjwgxsdaNvgoaL/WfpqeXAfVpGH3Xtquptkt9vlAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gRW4wbAi; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gRW4wbAi"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5033b0b6eabso4701cf.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 10:13:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769710436; cv=none;
        d=google.com; s=arc-20240605;
        b=OfHn28mdirmpRiHENX2KFL9kjk7y6XyfuCMMK/IrgPRQMMZjLRWgCLzjaHCftccXfI
         STbdjbOMStHSejJI+/ImnWu40CwoJJbJIQznsrsdxZidW4vJ1TGNoxPKRvgoaGkXc91K
         rGr6cz2gDy+9rGTGaddnp6u98aggBB+gvmui0lHJssN6ltl+NZONj7phaR+7tVKM4xnK
         jNLFSbwfA0O4TIX66qafdso4CRGQ5BD545yTfXOPi8+vZTtjcLFtDjx3iMpoIkNxgP29
         JksozlhZYvzvGweYxNzmbIeridCrX5seWus/lmYyQvLNVtzzrYBK69vSMJ1N7LHa86Gf
         W/CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=55DBf6vGz6h/IMUX0dUx145BpEo7/T5ZyZBZO9eqOec=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=HUnXmG6FC43lmlv4sPZFbgQAnCelFDLDsHEyCwGdAEtk7gDlYZczcj0IRrXPkAYkna
         28N78VQzYlhcKHetc6w1z1un9Hy0B6gdGWfSVDgjsNSTk4qgjTJDJaLarDb5vrX45NR5
         D48PG+t1wgwUpel/aGPCNbUjvYltTSbwG7r+YBPVL6khmgk9iV0tdpml64NbfrcaySjy
         SVnn2QfRoN8QXNEaNnz3XOpdeSB2DX2Z9RV6ZCe6ycL04gZexV7HK9dux2fLzwvk4uH1
         ABxuoJd4CscvqL+T4xmXb4is2j8cVAcCh0ifb+RDFpMMFg4E5FfSVAea2lvev/SVuigM
         6GoA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769710436; x=1770315236; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=55DBf6vGz6h/IMUX0dUx145BpEo7/T5ZyZBZO9eqOec=;
        b=gRW4wbAi6WwYOBKdBnWT+b/sesgSxjP6PfcC9UAYXyGYaNg5pJf4+D6AfUr/sKzmC6
         nwEIbWZ+Yl/1o4vZxr99Wk6jPzkiqn2g0cjpxr5u6trU93v6vgvYemq+6Hk12ChVB6/X
         khxL7hjvJRk/fmB3b0TuVx6Z3chSyXVsTtZkAPbz3ilxknzjTN0eezz9YWy+MBED+rK3
         EYkbs1RwH+S6GJX5rjR0p6XLlW+My/BMqHjIJFsc0TLBeCCAhFPuJiezN5v3LbnL4SCL
         KeFZJB+DCzc5HWNUJkPypMzs/oVxQzGllOHZWDm/8gu7j5R+0ZYAFaX28EdUxxtCL/lP
         swiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769710436; x=1770315236;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=55DBf6vGz6h/IMUX0dUx145BpEo7/T5ZyZBZO9eqOec=;
        b=C/JDLGl2LZd2BUAHWw5DnlFH5AweE3BrvTb+mcYo/uPryC9/GasgiQOWOgE/2Cd4R6
         1u/bh82s4kTNL4jFpasqVNf7i3+3t5IRB0nsWVisnNKTFhTvlXzaY1+1GUWF1ox4+gDe
         7d+TDlrj0hJm6Wg8L9UJg9OMz15W9DM1S7Ly1vYH8IIXeqKd5ZSnMw6oVITPlnvDyfxq
         sXc+yPaHHLVFVGhrSCaWNVBhVWHZCcW/V+4I9XVFVprRMR9CK9PT6QWwA/i5/wY7tjOT
         VsdT4RelDH8Ng6f8CY9aPQLtpoUOxqt7aLmZlLpk0sigwHtzD2dmkDfSpKLtnfqY88pU
         zn3g==
X-Gm-Message-State: AOJu0YxeYJ8hgSr0Q0AQ1q+LUJER/gl31F91ltJTPN5pWZkTGxBDSNms
	XcaZNORRsZQdTICJ+3MPd6QKbvujt/aWHiDHCbPVEOquKIg5CRaYQm0rCgymvPcygx1bj+UI+h7
	CkmMYPVM00WkTwZWALS/1XOISL+dnrr8YhD2G9o4q
X-Gm-Gg: AZuq6aKYd77A6qKaOCQXGR+fHgiIMJObeI0cpHo5Qff7cpSMo/sFKc9ZO1Nym63tvF3
	WS8RWc7BerMjDoyG2sEsoOvQ41irJVl4ZvbvQ2z05ILExK++NSbxsgPdxMe4dKhtsuQCyHRrZcS
	VM5nPtytqsPuH9rNRxutk8NQXkMjkbwihp4dogfIP4Crp8ns09D+1D7WltWQ17HZh/ZXuSFYkFy
	q1ZA6z3NOJhYMREkhSZkkcWYenMX99XLkTiit54YTuRQAFUHJ6Us3dx/W4FqC1XtVNJZfcB
X-Received: by 2002:a05:622a:34c:b0:4f1:a61a:1e8 with SMTP id
 d75a77b69052e-505d29ee0b0mr171561cf.10.1769710435542; Thu, 29 Jan 2026
 10:13:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-14-maz@kernel.org>
 <CA+EHjTw_4WJgiS7vTUprvJOjdNrnW=sjhazCkU9eQW8BUYuZZw@mail.gmail.com>
 <86a4xwbakk.wl-maz@kernel.org> <868qdgb8ct.wl-maz@kernel.org>
In-Reply-To: <868qdgb8ct.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 18:13:18 +0000
X-Gm-Features: AZwV_QgctsLMiyW-LHXWNuYMwH3G1Jg_V-pn8ePMlloILfrF3aUeUb1VzhoKoQ0
Message-ID: <CA+EHjTwxS_xvQqsOJw7PzZBD5Z-oM14z1VwSTC5dCS+79DEpfQ@mail.gmail.com>
Subject: Re: [PATCH 13/20] KVM: arm64: Move RESx into individual register descriptors
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

>
> Actually, this interacts badly with check_feat_map(), which tries to
> find whether we have fully populated the registers, excluding the RESx
> bits. But since we consider E2H to be a reserved but, we end-up with:
>
> [    0.141317] kvm [1]: Undefined HCR_EL2 behaviour, bits 0000000400000000
>
> With my approach, it was possible to distinguish the architecturally
> RESx bits (defined as RES0 or RES1), as they were the only ones with
> the FORCE_RESx attribute.
>
> I can work around it with
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 364bdd1e5be51..398458f4a6b7b 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1283,7 +1283,7 @@ static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
>         u64 mask = 0;
>
>         for (int i = 0; i < map_size; i++)
> -               if (!(map[i].flags & FORCE_RESx))
> +               if (!(map[i].flags & FORCE_RESx) || !(map[i].bits & resx))
>                         mask |= map[i].bits;
>
>         if (mask != ~resx)
>
> but it becomes a bit awkward...

If it becomes more complicated than the original, then what's the
point. Up to you whether you want to try to pursue this or not. From
my part:

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad




>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
