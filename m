Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BDD47A895
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 16:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791908949; cv=none; b=BSzEhVrSq0FXk/so4cCCs/b5PPt1vPN0uZrElLTmrnSePiRFYwa1BtJjm2f4jHs5pgyO2T20wc1ubu2+AIbYzgTwGUbj5/yL4Gl2dYju+v1UfXKckxua/PaqrvnWDXnkOJb5KoAhuLeBh10frTP/qlnekQzXo5yxBJ7DXvad+AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791908949; c=relaxed/simple;
	bh=hT10YEh8gpLga8eETCQsbuAQGVBcyFRVjqQif1cywmM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UzfoGxK6H8wF24DhhNi8gysxx1I3V9AWup0ADU5a5GhtPS5aXJCe+D01A2QPvvF9E/7LAk1dkCah+pBnSxvZW+mfTxvznFB6ruH0eBmPtqiMh5AhB4h9KY5x4Ovnry1X6weLqze24Wq4tKqF1enaOJRwpOW5cQxWbV+hOzHp81U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIZODnQv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIZODnQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33031F00893
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 16:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791908947;
	bh=2U9zEpn0AXs6lLEm2UZzitB8Wqsn/VzGaFG21nyW/jM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VIZODnQvYcE9Tkf4OS2kP6zEmJ4q9/eSeEMzSvW1BAPseLlozADSIkP8cizT90Fuy
	 /YPq1OIGa19EHNHc60Rlp05boMetMPeRYrw8/+Js2Z3GoMXzvJgy+OYlX3BXnZwtoS
	 HDnDrEhJHgknR4wHMA9vNuABJHyhLRDbM4cstx+nPk/fdWOZX2Oq5fkX3IwU5v4js9
	 cboYLjyQJd8f41AFk+DWmUoB2HLOHBgEYaey7MQ9oK0+BbkVsnT77yNQpNx1Abr3ZI
	 6VEuHPF8BbD05ndJbfrhY+25J8Qbic+7IZ0T5sIpjdG8+OFic5lt5jBszam3d4aluF
	 XtetxPXmpxXsA==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5bccc73eea4so123240e87.1
        for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 09:29:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBySIDD2HTdtgQnl9iEYPhFBopEPEpAb8yqp/mw39Y/V6PKRWb2srRQfnexy04T7nz9DL+PtxXw=@lists.linux.dev
X-Gm-Message-State: AFq9FYLLnvmb2pcA+AYvxk0J4f3RqGo5/eHoTpmjG/64jnHjofXLt8w5
	/nGBQ38tjloGReXecrZa/dXgj1ENI29PEwEqM8xfnDZmAJvi6dvph88zLxyZrPbDlh1qYZ20mTe
	jPv6rqopJ2uNyXDYRK5RTeq23EdGEeI8=
X-Received: by 2002:a05:6512:3d94:b0:5b4:af24:3612 with SMTP id
 2adb3069b0e04-5bcdd509e2bmr4521635e87.20.1791908946678; Tue, 13 Oct 2026
 09:29:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260916-aarch64-clear-pages-c-v2-1-0393769f7912@kernel.org>
 <aqq1sxdQNZ93oV9A@LeoBrasDK> <aqq7oZzutLP82WYB@LeoBrasDK> <arP619hd9Rx8Vlrx@arm.com>
 <ec298ee5-5080-494d-b735-7ba7bd20cdf0@arm.com> <as4sY3Eq-B_59lW9@arm.com>
In-Reply-To: <as4sY3Eq-B_59lW9@arm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 13 Oct 2026 18:28:54 +0200
X-Gmail-Original-Message-ID: <CAD++jLmMoD_FPno2Q47WyWicpRaf8x46YREt0eyUzAXkOU5cFA@mail.gmail.com>
X-Gm-Features: AclHuK_FYdXBkzOaQUWuxycJBffBsmxf6yQ-hSZTX0gPejiYwMWk2Xc7z3lDJUY
Message-ID: <CAD++jLmMoD_FPno2Q47WyWicpRaf8x46YREt0eyUzAXkOU5cFA@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: clear_page[s] using memset
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, Leonardo Bras <leo.bras@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 3:04=E2=80=AFPM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:

> Trying to make sense of the above. So based on -next of 22nd of
> September, the table means:
>
> vanilla         - next/master on that day (current clear_page())
> patch           - memset()-based clear_page() patch (Linus's patch)
> stnp            - vanilla clear_page() without DC ZVA
> patch_stp       - memset()-based clear_page() patch without DC ZVA
>
> I assume the vanilla vs patch columns are just noise. Well, there's a
> -1.17% regression (not flagged) on Ampere but what's the standard
> deviation for this column? Similarly for the -1.15% on the AWS patch_stp
> test (vs stnp in the same test, it's no worse).
>
> Vanilla vs stnp shows a regression on Ampere, however that's expected as
> we no longer do the DC ZVA. Interestingly, the patch_stp result doesn't h=
ave
> this regression, so I reckon DC ZVA behaves mostly in line with STP on
> this hardware.
>
> Basically I was looking for the stnp vs patch_stp results. If I read it
> correctly, there's no significant change going from non-temporal to
> temporal stores (and a small improvement for Ampere). Assuming future
> FEAT_MOPS will have similar behaviour, moving clear_page() to memset()
> shouldn't cause any regressions. Before FEAT_MOPS, we'll use DC ZVA here
> anyway.

That almost sounds like an Acked-by if Usama can confirm your
assumptions above!

Yours,
Linus Walleij
