Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE22480DE3
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327992; cv=none; b=oc9NyPSxfy2WMF/O2OdA/sy8dgVGZi2j2XVa1SHGR7qgLjIezxFPEtOBgA3zzhQJKdHBmWe1AwCNsiZRAf6CfJHYf7NShPVyKOkxqbvwXoo987SLIfS1mvnsRn1L5NPW6AN2/Q+UvsldWQjzhQqP4XUgDVCsFkWl2DDXHEKNCIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327992; c=relaxed/simple;
	bh=mCTYthsiQiFF4hE0BvO5NGed3VpFS3Fs0bjmRckYj1s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e4gxzCy+r7NK4nbe9vXyaKMyJa7lakXnxXZJXqtar3hNhSOiXJmRe5IG5GUZQFFSTBHq2mJYO28xzkYE5BhWABXq9KyIvc8l9wGOVl7iJtak7guYJ+/j7MM2hRMxKqGtgU9/3R6VaJ3rM8eRJyJmV2csGRCi+JlG8Bu5MZ6xVTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RdHGJXEP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RdHGJXEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53D01F00A3A;
	Wed, 29 Jul 2026 12:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785327990;
	bh=EYdLFDukt7wUFSyUsai/qrQeMUgbRzG4JcuEX8PEMkg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RdHGJXEPXpoGDDrKZ5D+RxneNp22IfMYI/VALZ0zKOFSn6pXr6GpCE8QuncO1zEZi
	 vA4msllvifN0UXhNV0kJ6eFOCj7mogiW+hRABB4QDIL0cI/ESlP2M5r3+dT5UtBjDQ
	 tBrSl5XrgG6aRrw0RlY2oaGAc07uR2dPsf0v5zwGI2QSZRAtGZ2iopLq+UkVY3gzCW
	 WdSjUJmRSFq9q24m3ot1y87+/Q6LqZJCOnZnmUnViD/fF45DD+y00X3/DSDRAMAMAg
	 wgY6QiDRUtp5m1ZLLG8Fqo5GQccVemhFFROsls9BUE3blqIZ58xkydJaRrDZe/Z9VW
	 ukU6bCamb31Xg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 6/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in
 host handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260729121306.1519473-8-sebastianene@google.com>
References: <20260729121306.1519473-2-sebastianene@google.com>
 <20260729121306.1519473-8-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 12:26:29 +0000
Message-Id: <20260729122629.D53D01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] FFA_NOTIFICATION_INFO_GET is passed through directly to EL3 withou=
t proxying the RX buffer, causing the host to read stale data when there ar=
e more than 5 endpoints.
--

--- Patch [6]: [PATCH v8 6/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET=
 in host handler ---
commit 027209aeedfc445dc1a85dadbbed6fe91255d566
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler

This commit allows the host to send FF-A notification queries to Trustzone =
and
proxies these messages from pKVM by removing FFA_NOTIFICATION_INFO_GET from
the unsupported calls list.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index c22fe45147414..712811e894352 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -678,8 +678,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_RXTX_MAP:
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
> -       /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_INFO_GET:

[Severity: High]
Does this code successfully proxy the RX buffer when there are more than 5
endpoints with pending notifications?

According to the FF-A specification (v1.1, section 17.5.2), when more than 5
endpoints have pending notifications, EL3 returns the notification array in
the caller's RX buffer.

Because EL2 passes the call through natively without a dedicated proxy
handler in kvm_host_ffa_handler(), EL3 will write the data into EL2's
hyp_buffers.rx.

Without a proxy handler to copy this data to host_buffers.rx (like is done
for FFA_PARTITION_INFO_GET), won't the host read stale or garbage data from
its own buffer?

Furthermore, does this direct pass-through modify EL3's RX buffer state to
Full without EL2 synchronizing via host_buffers.lock?

>  	/* Optional interfaces added in FF-A 1.2 */
>  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
>  	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729121306.1519=
473-2-sebastianene@google.com?part=3D6
