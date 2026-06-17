Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ADF480DDA
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 15:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781709504; cv=none; b=qrwe3VAWbBVgqH4O65fpW8mjNSGH4iMQaJyNsMgP2LoCVI2FO+J6uknmArASaxrXTyzwiaHbDjC4SpnFU8dPL8S1Enufr1Te0ltMt933PEnGy+Qamf+loGG8t0YBNZV9t/kKrs+nz/XyyWt3evNxU6kRswyXsHfCS+NPvY2e+c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781709504; c=relaxed/simple;
	bh=BZkBBgo6FOGhRA65fc+wphwXMwga1SrpQGoU/M2VqcY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EAWU7PRaC4rfXy9hGbJ1jgGNY1SuCrQc7CztqL08vtlgB8emMBMjjoOD4xxX9ktc6l/m/jC34T9lETZL+6OjZP8cE62eemfRqoO+AIE8HSHgdTUmobijvD71kfLyoIf9aPkDqlKi5taCCyuagGREdCKmp6wRzXK0xckVeS7xiOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVFvkIBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVFvkIBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328AE1F000E9;
	Wed, 17 Jun 2026 15:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781709501;
	bh=LwYJgX8EdUiGtuZObyr77nGbCrEppAPCg/jylHlggr4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SVFvkIBeZTDfkcSwkgk6z1YlMv7XcI4C8+04cOY6VFJuDU/yQufnHAZz9oiPA+QU+
	 5ciwyY21b1U6xFgbaHt5h3BGj0nZ+iTvgL99liGAxGRjTOZIWciwBwd4rX/pQraM4A
	 toyppFnq91TvKlVk7x1CZoESt/+4j8Xd2Msx9VVv+8uZ0w8l5aPR7m1YzSy8WmSSnA
	 yKsOJ/YoZ8OutJebQzUm+tSowvY12yByEwcRv9dEwsuFnBH/qJvNDyVfHIP+x1OVC5
	 dzOdlR9A+6OfgrQVhwhc0UvcF7M5EzZ5WmbvAi87GNeEYru/Sb5UOxiKf/daQH1KmY
	 0VOsxoUXRYBVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 4/7] KVM: arm64: Fix bounds checking in
 do_ffa_mem_reclaim()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260617145130.3729015-5-sebastianene@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-5-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Jun 2026 15:18:20 +0000
Message-Id: <20260617151821.328AE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Unbalanced double-release of the FF-A RX buffer on the newly added =
error path.
--

commit 4c27507e65d7c9e01d4ac8269e48ef52850308ea
Author: Mostafa Saleh <smostafa@google.com>

KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()

This commit addresses a potential out-of-bounds access by splitting the FF-A
descriptor length validation into two steps. It ensures that both the fixed
portion and the variable array size (addr_range_cnt) fit within the
descriptor length.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178a..2d211661952e3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c

[ ... ]

> @@ -636,11 +636,17 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2=
_regs *res,
>  		ffa_rx_release(res);
>  	}
> =20
> +	reg =3D (void *)buf + offset;
> +	if (offset + CONSTITUENTS_OFFSET(reg->addr_range_cnt) > len) {
> +		ret =3D FFA_RET_ABORTED;
> +		ffa_rx_release(res);

[Severity: Low]
Does this error path trigger an unbalanced double-release of the FF-A RX
buffer?

Looking just above this new block, the EL2 RX buffer has already been
released prior to the loop and at the end of every fragment iteration:

	for (fragoff =3D fraglen; fragoff < len; fragoff +=3D fraglen) {
		...
		memcpy((void *)buf + fragoff, hyp_buffers.rx, fraglen);
		ffa_rx_release(res);
	}

If the newly added bounds check fails here, calling ffa_rx_release() again
appears to issue a spurious FFA_RX_RELEASE SMC call to the SPMD for a buffer
KVM no longer holds. Would it be better to omit the ffa_rx_release() in
this new error path?

> +		goto out_unlock;
> +	}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260617145130.3729=
015-1-sebastianene@google.com?part=3D4
