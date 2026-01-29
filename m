Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635AB35295D
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 17:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708093; cv=pass; b=ku+ElMvYY5rmGpEQRl4V8s96TbJF4rzaYTP6ZdJ1EV/3Ivm1RN8lWdeHQc5Op+M/jHfH6AldNW2rhTTduPaqjJtd3VdV2riRP9qaDEm5YRInePhMFCQTYZ/+qzmTt5WKy3Dla4N1zGAZJckF1rptS5I44bxoZa779RL8/F3F+jk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708093; c=relaxed/simple;
	bh=UaPo9BsXw41+UwtF89c2dJMBz8qHAJ6NArRn59ehYok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dyHD+JmLg0QRSEbFNG7ww+q2Tev76wTkju7KFT+XBPaP1ScC0rXyB9425KPQMD0xwxySQq3h7pcjAWkqttRwMBDnAxd/e0OGlKIHbAAA6d5XZ3uGV7njxKI+yn84uS/GLoaK/VvoaCNPlePiihJIYHelqHUSfGXgMMLuEGE9qPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JV+Mc72g; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JV+Mc72g"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5014b5d8551so2361cf.0
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 09:34:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769708091; cv=none;
        d=google.com; s=arc-20240605;
        b=Wk79y4Vn55dPMzhsqT8kZqF6978vvYv3xiyaezzpouPRh8rigrlvFKs62l99yvK2Vq
         C+WWPmOO6QgdOzqaWK6fwFqWwH5wG5cTRJrtQq4RK62TS8fiMS2bv7siJQfLzex4YfaF
         eSqFgjM6792aQ5byYV5XQ82SR6AH5+YRoey6zXIG9wgZXKPtsIR0wMX4KoabXRlE0lbG
         NlhHhWC2Fz1sfiCgwGuEKU7FbcWh8B9yb73SP0htbzO9i/SctNqF2+4x0DgS1Wa/o1Wf
         uuNcQQg1znei922+cI8OditmHLxdnUx5+eXQBA/oUun42G7mxF1F7pxfUT8iAYdvIJt5
         yZTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OCjRmeNlyKGhmHNcoMiPz9wOGxIE7UrMLqkSTeQIzDw=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=RMhqYQEr9R1+C0LVh3XafHbrEc6ecEbyy/o6t56DiMu3GvcMX6h6Y4DG3S9gVnl3rD
         q3u5SWJeHwJKg8yGN7Y8l/5Xm4KOtdBVRBkhS6Gl35zC51PiNIrJF85fYncQ1n7MoOni
         EePnyTwKx1gMJ1TKmPGACZPuDtCQesM6JT0aaVleKkKSt2q1EPJ9VY/kt5ZCHBSLTtQ8
         cVoiCaORAAJveQIfFLtwyG07uSu2acVuSJyrXEHkt+Sb54672f7ccoLZUM8Nu8hWVXZ4
         7ZcSksnqpBhc89/hh+IGFZbh/wyM4OxHIP66i8aGuSLEEsqjtWR3UOJuqHZhupcFVSkS
         C4hA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769708091; x=1770312891; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OCjRmeNlyKGhmHNcoMiPz9wOGxIE7UrMLqkSTeQIzDw=;
        b=JV+Mc72gDJhcBKL/P73vc3mCT+83sReK/dgJj3xVTPeIbmkUf1IayK/Qn6WUhwO8BH
         uYDy5jh9Rn2YhfqSyVXQeHKGtrw+ZXbQdylWaxtidP+7yv+8CYvlPXyxw6Zt7hQorrey
         8ORa9fuqrZiKIk9Z1z5jzyAM5ZqwiSVpCig/miUSG5EFyGoObbo6M9smqP1BSOFDardj
         PHIa0GZV9zUjvESWAA1zSKK0/wfouSdH5Y8F/j3+ArQm7VwdVhiuhakKw7K25r8QcqIt
         Rmhld2nI7VtwPJoOClWQVJsWvuq3uoP89wHTnoCAe02zQkWA93kUVx1mc4pCTOuVZt9L
         JM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708091; x=1770312891;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCjRmeNlyKGhmHNcoMiPz9wOGxIE7UrMLqkSTeQIzDw=;
        b=FWHttwVhmpgs7V987j+9/+A5TOEQZOyawxlD4B5Ltgodx5KK5oOhISJFuLhOriPPD8
         eQk44hPv9gcvvHjAVqjYoPUO2JStNSN7p2VU2i+1QFu2JQyH5LHsp3hyNJyNxXYw2Hvq
         hZRuqpwLln1e4OeW29Z2g7aIBNyt1POUatO+JarzUfXM7v2jk8Xx1jHpaGkZWulWn3Yn
         4rmF+BmBKTPS4zpNh5ShRndNxQDztkpY6bw31v1cc+uDJqN0q/JGCY8cXS8HiCiYYaek
         HaLOIR8W9jIMEB6ClD2KB1ga0LA6RIloNVwUOtQfzyjbobryRGo0Yv8izm48jloleDGi
         tCGw==
X-Gm-Message-State: AOJu0YxJpjbn5wRF91zZente8WMcSFxRs6j6qv7+Gw2Xz0Pnt/F7+hDx
	bcpTqq9JWDaTll1F0xNy5zi5rRDctR6suPcMYW3vltcSqMm76qoA5tYXHmsNhpMprzmQq5G/C9M
	5JbR78zrviQAPnluHKPSlrI9sDp4w2kzqloe90CXY
X-Gm-Gg: AZuq6aKbSciOSNDPYl6qROhx+uKSUcDDorvI11sVKe0wx6VhT6FENjsFWU6/LdWxbDw
	GmcGP3r85jRIsu8gXmQRDMr8nkHa717v51P0nR3voOnBHn6VmG1hXypE3MtLQw/kfieVJtwyFuF
	M9a9HvkN97hCFS+2uUnhVWcjtlkx/VdFMLhtB+XJiHLu1fGbvTydCFOicpbZw7O6ZV0rQ4GGX5y
	yz7zb9TVOF87SowG2YBnjAZuyrrkajmNXIHu5naZ1nCBGPaAJCspIshmYr67SoDUHiUhWbL
X-Received: by 2002:ac8:5dc7:0:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-504310c6a76mr11415131cf.17.1769708090725; Thu, 29 Jan 2026
 09:34:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-17-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-17-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 17:34:13 +0000
X-Gm-Features: AZwV_QiTE6QZNIoj8DOQzS5LJpafanXH_brsaCuAk8_cVjfPbm_tEiXo0cJUCrM
Message-ID: <CA+EHjTxS-TVNzFdENTa3F3V1Z5+grxx7x5MO1YJGrZJEY+kUaQ@mail.gmail.com>
Subject: Re: [PATCH 16/20] KVM: arm64: Simplify handling of full register
 invalid constraint
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Now that we embed the RESx bits in the register description, it becomes
> easier to deal with registers that are simply not valid, as their
> existence is not satisfied by the configuration (SCTLR2_ELx without
> FEAT_SCTLR2, for example). Such registers essentially become RES0 for
> any bit that wasn't already advertised as RESx.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/config.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 28e534f2850ea..0c037742215ac 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1332,7 +1332,7 @@ struct resx compute_reg_resx_bits(struct kvm *kvm,
>                                  const struct reg_feat_map_desc *r,
>                                  unsigned long require, unsigned long exclude)
>  {
> -       struct resx resx, tmp;
> +       struct resx resx;
>
>         resx = compute_resx_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
>                                  require, exclude);
> @@ -1342,11 +1342,14 @@ struct resx compute_reg_resx_bits(struct kvm *kvm,
>                 resx.res1 |= r->feat_map.masks->res1;
>         }
>
> -       tmp = compute_resx_bits(kvm, &r->feat_map, 1, require, exclude);
> -
> -       resx.res0 |= tmp.res0;
> -       resx.res0 |= ~reg_feat_map_bits(&r->feat_map);
> -       resx.res1 |= tmp.res1;
> +       /*
> +        * If the register itself was not valid, all the non-RESx bits are
> +        * now considered RES0 (this matches the behaviour of registers such
> +        * as SCTLR2 and TCR2). Weed out any potential (though unlikely)
> +        * overlap with RES1 bits coming from the previous computation.
> +        */
> +       resx.res0 |= compute_resx_bits(kvm, &r->feat_map, 1, require, exclude).res0;
> +       resx.res1 &= ~resx.res0;
>
>         return resx;
>  }
> --
> 2.47.3
>
