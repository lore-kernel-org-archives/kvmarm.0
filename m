Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01592357D0B
	for <kvmarm@lists.linux.dev>; Sun, 30 Aug 2026 23:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788132042; cv=none; b=i/ABUNpIK2kAhf35G8Jz01ZHRbJUXuvambZ2C8kbmKoqOyvXTzqPDolrQAZ61IHneSuMhUVCERz8GCY/0amkx9ykSHpoOhxVG2yaDqyzlGUWlehY1fsnbpdFYhKBFuMSOVmaxejFh3lrdkCkHAiB4bRdQknuW++zN+bDTalygMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788132042; c=relaxed/simple;
	bh=DROVcdnJ47tU/IoZwJG6vTr0l3j/QDBq1a1dO8iPizY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YUXb6N0ukTAsfPZ9fAoDXGUeIqONWUsNSAfSIV6ETl+pcdaFTGYEP26se2fp/QhwUpuOzH2071ZnbkxAGON25DYU8YPam13KlltxtnPwUl+Rf8A4JcvpLMAEHsLwjgW8DZDII1B5RONGrOCsDdvzscWXaqS2SjCBVGIeJuFLKC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CtQyYYzU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CtQyYYzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0931F000E9;
	Sun, 30 Aug 2026 23:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788132040;
	bh=fbhpO6QEwIVB61SqTrkYrCXm6V/4kBcpQjDOUHSZsZ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CtQyYYzUHdVn0/aFTsuS08Rck90Uj02MEvW1pu1pP8XryBR5fUoxEnAwz+b3FQsTd
	 4ylk9nB45I1bViAwKXBYF4UF0PnTrUfmbYcoWVLBcf0g+AYcO+y8LF/19RO0ROdDB+
	 KmUHBu21aBTr9wXjcTZc1QQdyFfcr09yOU3/AV/Z2odQtK7GjJy+OR7Jr99lXJO+3C
	 jgAY6nAKRAjB3gxt7saP+F9Zg8HUqQK4KZtMa5PmUqOgW8scZVbN4y7Glq9uQ0+Dfu
	 2qfBDBmy0ceVDa1SA30YxxTpk34uBZrM68AeVIE6+RNuskle4arzcoTk++V5VmnhgP
	 fALbPZnxoRFFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 1/3] KVM: arm64: Block host-initiated FF-A direct
 responses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Per Larsen" <perlarsen@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260830-host-direct-messages-v7-1-45f6e6db72c2@google.com>
References: <20260830-host-direct-messages-v7-0-45f6e6db72c2@google.com>
 <20260830-host-direct-messages-v7-1-45f6e6db72c2@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 23:20:39 +0000
Message-Id: <20260830232040.5B0931F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The ffa_call_supported() denylist omits several critical FF-A =
interfaces (e.g., FFA_RX_RELEASE, FFA_MSG_SEND2, FFA_RX_ACQUIRE, and the 64=
-bit FFA_FN64_NOTIFICATION_INFO_GET). This allows these calls to fall throu=
gh as "supported" and be passed directly to EL3, which leads to both a TOCT=
OU vulnerability on the hypervisor's RX buffer and the false advertisement =
of unimplemented interfaces.
--

commit fe4021e3b775f95729beec069334d0e2505a799d
Author: Per Larsen <perlarsen@google.com>

KVM: arm64: Block host-initiated FF-A direct responses
   =20
This commit blocks the host from initiating FF-A direct responses by
rejecting both the 32-bit and 64-bit calling conventions for
FFA_MSG_SEND_DIRECT_RESP in ffa_call_supported().

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index a327c2bbb6b64..9e8bb95e8845c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -686,8 +686,10 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_MSG_SEND:
>  	case FFA_MSG_POLL:
>  	case FFA_MSG_WAIT:

[Severity: Critical]
This is a pre-existing issue, but the ffa_call_supported() blocklist omits
several critical FF-A interfaces such as FFA_RX_RELEASE, FFA_MSG_SEND2,
and FFA_RX_ACQUIRE.

Because these missing function IDs return true here, they fall through to
kvm_host_ffa_handler() and are passed directly to EL3 without any locking or
validation:

arch/arm64/kvm/hyp/nvhe/ffa.c:kvm_host_ffa_handler() {
    ...
	if (ffa_call_supported(func_id))
		return false; /* Pass through */
    ...
}

This opens a TOCTOU window on the hypervisor's RX buffer. KVM (EL2) uses
its own hypervisor RX buffer to receive descriptors from EL3. Concurrently,
a malicious host can issue an FFA_RX_RELEASE SMC on another CPU. Since it is
passed directly to EL3 via __kvm_hyp_host_forward_smc() without acquiring
host_buffers.lock, EL3 releases KVM's RX buffer.

Could this allow KVM's RX buffer to be overwritten by new incoming FF-A
messages while KVM CPU 0 is still processing the previous message, letting
the host exploit this to unshare arbitrary hypervisor memory?

Additionally, it seems the 64-bit variant FFA_FN64_NOTIFICATION_INFO_GET
is missing from the blocklist further down in this function, which allows t=
he
host to circumvent the restriction on the 32-bit interface and causes
do_ffa_features() to falsely advertise support for interfaces pKVM does not
implement. Should these missing interfaces also be added to the blocklist?

> -	/* 32-bit variants of 64-bit calls */
> +	/* The host is never the target of a direct request */
>  	case FFA_MSG_SEND_DIRECT_RESP:
> +	case FFA_FN64_MSG_SEND_DIRECT_RESP:
> +	/* 32-bit variants of 64-bit calls */
>  	case FFA_RXTX_MAP:
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830-host-direc=
t-messages-v7-0-45f6e6db72c2@google.com?part=3D1
