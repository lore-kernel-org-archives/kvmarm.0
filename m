Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B33422E22
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785328502; cv=none; b=XZUD1qKz9kk6lysjJK8hKDIscTWxzJ0WNdCD+3E1QXMIUMAVLMJT9h0REkwM/CTWZkYdnPGmGHy+QL0rUVBv7gGMh687dPtKJhXzLzhggli3/YzQ0cl1aRJw4oJ0guwkm+cphQtNR+fq4I18iPzfcvFeVwxTfOlbT841A0UlNKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785328502; c=relaxed/simple;
	bh=v8wqD0ExU863bvET2m+/0hY0aJi4ZpmSm3ziduyjKk4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tV82FxxlO9K4oah6ztoUSR1cSaXScRlU71iW4OSvimJ2gfVM8oBLizMS4WbMVThC2aa+ykaeBkCUlHHqdbYFKJIT7m6ID9QBNtwqk90KCeIoOpIemqKQ/4DgPF5NTnH23L9yieZ9XrJ9A37289Re+jtMZyH+/76+vSBfZLnIU70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kusmz4rI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kusmz4rI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBAE1F000E9;
	Wed, 29 Jul 2026 12:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785328498;
	bh=DVgStKt1JcmuY5vJ+PWP0GfoOBAQXeWLuSPv4wcPCFY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kusmz4rIEGUp4Cx3aW6Wm6AjCSsflIlORRwZ/MWCNWdCvOFcT7g/821KM8jsKFnwU
	 wt2xGkXwmLutKKyiu0k+Ui1BT+SSa7G7RNMN8GH8A0n+BIA2BKg7FvXa3WhDUYfbq3
	 sq+K0iiXAA+TpCIyppwyQe5GIcBFkPcGfcdImHWj/ElsYMquXOfUGekbqEMClUJPQM
	 xWAgp/cWTJ6BM395iI4XcWMTpaymLG8apY9ejwTSPGRGJ/W3Y4P/njpH0+k6F5z7h6
	 /tQjFVh8WpHd5m6CE65GrSQvAAL4g9elR1KpWoTexfvYTEVgV8IrKekqvbfVeewFoL
	 S1fRpQBHLpX4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in
 host handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260729121306.1519473-4-sebastianene@google.com>
References: <20260729121306.1519473-2-sebastianene@google.com>
 <20260729121306.1519473-4-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 12:34:57 +0000
Message-Id: <20260729123457.EEBAE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Implementing FFA_NOTIFICATION_BIND without GET creates a broken st=
ate machine leading to host interrupt storms.
--

--- Patch [2]: [PATCH v8 2/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in =
host handler ---
commit f4a2e54088009879e5d48f31a72e3e0893929ac2
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler

This commit adds support for forwarding the FFA_NOTIFICATION_BIND hypercall
to TrustZone, allowing the host to bind FF-A notifications.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index ecc13b795f2c3..331d9d0d82871 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
[ ... ]
> @@ -676,7 +678,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
>         /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_BIND:
>  	case FFA_NOTIFICATION_UNBIND:
>  	case FFA_NOTIFICATION_SET:
>  	case FFA_NOTIFICATION_GET:

[Severity: High]
Will allowing FFA_NOTIFICATION_BIND to succeed while FFA_NOTIFICATION_GET
remains unsupported cause an interrupt storm on the host?

If the host successfully binds notifications, the SPMC will assert the
level-triggered Schedule Receiver Interrupt (SRI) or Notification Pending
Interrupt (NPI) when a hardware notification arrives. When the host's
interrupt handler attempts to clear this interrupt by issuing an
FFA_NOTIFICATION_GET hypercall, KVM will reject it because
ffa_call_supported() still returns false for FFA_NOTIFICATION_GET.

Since the call never reaches the SPMC, the notification state is never
cleared, and the physical interrupt remains asserted. This results in the
host immediately trapping the same interrupt again upon returning from the
ISR, leading to an infinite interrupt storm.

Could this be used by an unprivileged userspace application (e.g., via
OP-TEE exposing FF-A notifications) to crash the host kernel?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729121306.1519=
473-2-sebastianene@google.com?part=3D2
