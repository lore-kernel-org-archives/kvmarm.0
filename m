Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34AA3E2AD2
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 12:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782737179; cv=none; b=a1DHDIfQHbOJ0F8VLvZNQN5lWGIp007aNME+ESByMru/vqdi5Z1ZV6LdzhHcG3s8b5AV6xB8xtMdBD9BDkMia1SPPRV33zw2IPcmg181cwAU8SXf8a6eHxuNCfq3Rp66gCIbB/0exhjp4orgumJjwP+8BfmXSf3NvoWKbKiNVB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782737179; c=relaxed/simple;
	bh=F0kBL5As4XeGK0e+0NFvt0rFgtjfZesJSFp5/3MGGxo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q+2g5wYEVvpzwJl3l2zC/MXPAY/6UGyIo2VAHvJHS8kcq0G/u++X6DNu4W2UB5mmH4LUUaVcJ8gdMLL+zrdM0u+UC8HvXlsgwznjPer8VqUubDotKgK6Iw7aH36idcwR9C8LpyqDjJUKdaOHECmcqAsPFI3aL2MdSobEsKx+ks0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GhYdL1D1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GhYdL1D1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FC81F000E9;
	Mon, 29 Jun 2026 12:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782737178;
	bh=f15CxIS4FxuCMMr2GX75+FrT5GrvwYJZOd3n7MoZMyQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GhYdL1D15m9Ewlg6d05qZaP8daXn2BJBUkauqi7GsDCsmpmSnaV2/k3H4Gyy+tQAS
	 yKj9iUrCTdUrt+sxpqxAeAoILi/VpQe0S9sLMF6jUtGG7Movwb3HbsKzXB9R0/QmQJ
	 tUSSBMiLdgSfm+u08JkrMFO5tlqsujw3xC4UDSvBqprna3BmyRB9hB+ornBrVUAjuN
	 s2jYq4y2fn4X068lIUeoa+BPBokg6N7th7hTJJIAanX0WtVEQpqwsu32lzbIXAl017
	 xZlAggJ72CQBuK2mpuY6GdF6KS9hJz++jVeYLuvkyYrclHmrDscQDhoRjO6hKIC7w1
	 LhwkuHIZIRf5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 6/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in
 host handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260629093558.2425257-7-sebastianene@google.com>
References: <20260629093558.2425257-1-sebastianene@google.com>
 <20260629093558.2425257-7-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 12:46:17 +0000
Message-Id: <20260629124618.38FC81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Passing through FFA_NOTIFICATION_INFO_GET without RX buffer pr=
oxying or locking causes memory corruption and DoS.

Pre-existing issues:
- [High] Missing masking of unsupported optional FF-A 1.1/1.2 interfaces (e=
.g., FFA_MSG_SEND2) leads to hypervisor information leaks.
--

commit a13e0f442f3327dcf7e9cad61d255528a3a9dd89
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler

This patch allows the host to send FF-A notification queries to Trustzone a=
nd
proxy these messages from pKVM.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -678,8 +678,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_RXTX_MAP:
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
> -       /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_INFO_GET:
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: Critical]
Does removing this from the block list allow the call to pass directly
to EL3 without acquiring host_buffers.lock?

Under the FF-A 1.1 specification, if the endpoints list exceeds register
capacity, EL3 writes it to the caller's (EL2's) RX buffer (hyp_buffers.rx).

If this happens concurrently with do_ffa_mem_reclaim() running on another C=
PU,
could this un-locked write corrupt the buffer during parsing?

Also, since EL2 does not intercept this to proxy the data or issue an
FFA_RX_RELEASE, will hyp_buffers.rx be left permanently marked 'Full' by EL=
3,
causing subsequent hypercalls requiring the RX buffer to fail?

[Severity: High]
This is a pre-existing issue, but are we missing masking for other optional
FF-A 1.1/1.2 interfaces like FFA_MSG_SEND2, FFA_RX_ACQUIRE, and
FFA_MEM_PERM_GET here in ffa_call_supported()?

If FFA_MSG_SEND2 passes through to EL3, EL3 will read the message payload
from EL2's TX buffer (hyp_buffers.tx).

Since EL2 does not proxy this call or populate the TX buffer with the host's
data, could EL3 end up sending uninitialized or stale hypervisor memory
(such as previous memory sharing descriptors) to the destination partition?

>  	/* Optional interfaces added in FF-A 1.2 */
>  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
>  	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629093558.2425=
257-1-sebastianene@google.com?part=3D6
