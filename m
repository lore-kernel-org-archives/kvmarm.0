Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A423451056
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625809; cv=none; b=TD3Jam/gP2B9RAlWzrFc6ILuqC+4BxJT8Mdth8j/xF650O5uaIoNdyw4NhaguNLhCpweyHVfYA8ILTn5wPrVZoXs1HqPLV97vtuKkM7BdohORdogGPliQZ82OzMRDar1ljpmzUTi+A73h3pCne3+wd1wOZxRUNm3RGQe4ildd1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625809; c=relaxed/simple;
	bh=02+TLLfALcvJ1AnAJy3rdnLqs5iUzB+JcBLO9NxI7LY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uc2IMGfXq8blOO9iXQyKOcmc3KZtjsGybBP1DsXUa3E9Lw8mboH3TOZYKG9MTK/ixyK6QhiOhuDire7W3h96R+BC4XCe7Y6cobgTXL1nltOxV9tA2UmQetMib6CVMv80OuqnXGeh6v3mwijpddZubQRvBCRyjbTBJxQrBGsNifk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AbfSk5fd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbfSk5fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F54A1F000E9;
	Tue, 16 Jun 2026 16:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781625808;
	bh=7XBLDx1ims5k/VJRqgvkKIL8kCqt4SbTGlJ6RzIWObY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AbfSk5fdc2g8dUtKNxzY4SpJ5bcp5C/OTk9u7P2vY6PQ+VOSXRHV8esVTS8/flYcf
	 eU4p5QFYe9XQHNR4vDaLovFzpO4rnRgvjweBAMe/V7fTGb0HHpy8NTqeV3CVWvZQdB
	 3GNrnZe+TLdfsAD9RYAZA1wg0rGdfiEa5e0E/lkcXtI4zZIRIoc6jSSW6Tsm1/Vx2a
	 gNCPV176QjD4EkVlhJ+1ohitA+dHDyj3uxYFb4qvQfbXrBsiUfmRYsEqetuHTKaDgF
	 WJiYM1BkYha3oN3xv8fAqglXWdIvDzJqquMtEqSXGzrMu4mTBfBEh/muJxhbbik8pw
	 Yv4AHNNH7pPsA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 7/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in
 host handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260616154149.2763214-8-sebastianene@google.com>
References: <20260616154149.2763214-8-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jun 2026 16:03:27 +0000
Message-Id: <20260616160328.0F54A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The 64-bit variant of `FFA_NOTIFICATION_INFO_GET` (`FFA_FN64_NOT=
IFICATION_INFO_GET`) is not intercepted, allowing the host to bypass the ne=
wly added SBZ enforcement.
--

commit 9394d3f8c8ebd222066a0b0a791f85587bdb9eb5
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler

Allow the host to query the FF-A notifiction status and proxy the info
get message to Trustzone. Make sure that the SBZ fields are enforced.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index de47943383883..ffb6d44b5010d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
[ ... ]
> @@ -1100,6 +1112,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *h=
ost_ctxt, u32 func_id)
>  	case FFA_NOTIFICATION_GET:
>  		do_ffa_notif_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_NOTIFICATION_INFO_GET:
> +		do_ffa_notif_info_get(&res, host_ctxt);
> +		goto out_handled;

[Severity: Medium]
Does this miss the 64-bit variant (FFA_FN64_NOTIFICATION_INFO_GET)?

If the host natively issues the 64-bit SMC ID, it will fall through this
switch statement. It will then be evaluated by ffa_call_supported(), which
returns true because it is not explicitly blocked. This causes the unvalida=
ted
call to be passed directly through to EL3, bypassing the newly added SBZ
validation entirely.

Should FFA_FN64_NOTIFICATION_INFO_GET be handled here alongside the
32-bit variant to ensure the validation is enforced for both?

>  	}
> =20
>  	if (ffa_call_supported(func_id))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260616154149.2763=
214-1-sebastianene@google.com?part=3D7
