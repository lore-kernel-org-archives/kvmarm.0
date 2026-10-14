Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB303A5422
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 09:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791971861; cv=none; b=AF9eLfGKeGqxSc8TmCHDuZkSDGRexa6MGPf+PHk28d5RZcUzVnoJvuXxqNgrKKUYNNYEK+Z+8MVxokYubhHQzeoLBCHGmsZ36IzlL6JmgwUj5s2YAlWFtpnLVSRYJUBCAlyE9SPfxrAMGLV6NVl4y+z7YVfC8eKTyDtjB8L3mVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791971861; c=relaxed/simple;
	bh=bnC5HCu6Fv9bI+FYECKXEgB2Jb++sTIm82VofegOFek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WUwFzChC4HqhPbnU+VVP/7FTxfOkdeR+d2aBZjlP/Ewq8xhk6TecUVjtJtt/oqvjFUBE8s9/MBdEwfN2LfyrpZRHXaI54so2OuIsomUeokv5uiXPj43H9RMXrbaLtElZgan1cDb3lY9+o0eCiGDnLJ0GhdPe8xTMT7ju2LbIhBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WhGYToyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhGYToyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF51E1F000FF
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 09:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791971859;
	bh=bnC5HCu6Fv9bI+FYECKXEgB2Jb++sTIm82VofegOFek=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WhGYToyp7quWbsAOAQJtsKXFIbz79+wVriYt5Zi5GdmnbpfzyCbwWsag+QSNOVVi4
	 37hBe7akAFxgm1T2ZFd+7AxrfQROIJZjW1mnrV7wZAzwuvPg7RuRJZJDN3ziVsVkqa
	 JHRKDI1CvOywcka8xgG2utdaXq+Os/3FK6pgnQJEnTgvNIXzcX/odWDkW/lGhEUUKi
	 UF/Ex7bPlNWdU66iuGqdoJAAmf+RaRmcIRjAZsiHsNI4FiuH0N9tPZqM5xCYwy2mo8
	 OCLbb1gNuBt8F8CQt5NawZ5AH4PFqNDQUYAXXmVf4UojJj3F5g1t2YhQwYb7VoHk+B
	 jo0i8iMGe7VWw==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5bcc6094d7fso3191079e87.2
        for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 02:57:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByEECkC/P9wyK3S6X1193BWhKBfMb3SfAnLbxorUUPPQoHSClEfBK8M6vlYCh38lbVqBcM0X4Q=@lists.linux.dev
X-Gm-Message-State: AFq9FYLVmqfVBsMzRomVfichS1f3RI0UR7loNWP5rCJe+t589YaUH4b9
	OrXdH7pC5y++VKX7wVrD6iKBeuZoA4s8e8Fa8BGgAZQz6fXvhtNjBALCCnj7kQn1fy0rv1C0cyZ
	y/I09m4W4bIYkwBff3xuNpDRbi6ucft4=
X-Received: by 2002:a05:6512:3e22:b0:5b8:f1d8:7ce4 with SMTP id
 2adb3069b0e04-5bcde6bb58fmr5113230e87.12.1791971858651; Wed, 14 Oct 2026
 02:57:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260916-aarch64-clear-pages-c-v2-1-0393769f7912@kernel.org>
 <aqq1sxdQNZ93oV9A@LeoBrasDK> <aqq7oZzutLP82WYB@LeoBrasDK> <arP619hd9Rx8Vlrx@arm.com>
 <ec298ee5-5080-494d-b735-7ba7bd20cdf0@arm.com> <as4sY3Eq-B_59lW9@arm.com>
 <CAD++jLmMoD_FPno2Q47WyWicpRaf8x46YREt0eyUzAXkOU5cFA@mail.gmail.com> <as9FRpnL7851aTVj@arm.com>
In-Reply-To: <as9FRpnL7851aTVj@arm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Wed, 14 Oct 2026 11:57:25 +0200
X-Gmail-Original-Message-ID: <CAD++jLk3k9WErpwOC7c654nieSOVaawNKUxRWtu2wbHz-J943w@mail.gmail.com>
X-Gm-Features: AclHuK-o28Ze4TG6AkXgZ438sQ2zDkoV31u7LInsppRnghwUH_vXr243YJqhsko
Message-ID: <CAD++jLk3k9WErpwOC7c654nieSOVaawNKUxRWtu2wbHz-J943w@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: clear_page[s] using memset
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, Leonardo Bras <leo.bras@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 11:03=E2=80=AFAM Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Tue, Oct 13, 2026 at 06:28:54PM +0200, Linus Walleij wrote:

> > That almost sounds like an Acked-by if Usama can confirm your
> > assumptions above!
>
> It's queued but we can revert it if it shows real regression.

Thanks Catalin, holding my breath that this will work,
once it is solid I will do arch generalization.

Yours,
Linus Walleij
