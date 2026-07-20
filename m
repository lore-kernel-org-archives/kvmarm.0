Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEC2445ADE
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568573; cv=none; b=JQwmygBpzRtC0O7QqdBAwZTsG4wFrOlZAdYDN2byqkYJs8y+DMwFXOAFjzyn6ZWECFMuyPKGY4QN/VfLgT/kTeEnZmU03I6njyQrLqfN5p0D6FVqEHuqzj7DL/F5z+r981C/oAOko4H9Ynq35VIPK2Cv0bvOcT9yzQ6Z7BERDI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568573; c=relaxed/simple;
	bh=RCOFZyrYzeNhamdQAAN/K6HUUD3e7jFDsduTJsJD5Fg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SlqbBCtQp5H/pmCtK9bUnojwE2jC7NE7T9cfQ48IkXlgOafMB5pxCj/vZ/fb4e++8Wod0pqHuOX/MnbbHtz19yDRFORZr3W/bu6SRempsmJY8C3xraXf9xMSzYRfv/Q3P7sQbMhCjYjr+bm0al1NxUAjBeTjDzEq2KzMUmf74Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gh/WsWyD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gh/WsWyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F161F000E9;
	Mon, 20 Jul 2026 17:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784568564;
	bh=EKISEnzmdVIFSxKFUHVZ0amXQ7KxfPcwcvbMFxZJ8GU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gh/WsWyD2i9QsTwcMzwMvMj2mltkuUlWcDZwGfHXC6QUAdA6kvr5zYub5ID7oSDdj
	 HpdF3lYTF99AuPbwWCB4o/8OF3JQsBoWtdSEdHSf5NA9+IcCtiwdm6fg/v44b+fpbM
	 TA4Bn+TIPU8+roQj7mJ0bhZ7SmU2oyEDSQjHFPkMKj4SB8CWMRdjARU2UukY7Q41Oh
	 R8/jylGYhNolP8pdAGstTescRFqI5/GkeAY0Ai/Khe+TqYCuSeVXQgKDzCEHndjycJ
	 6eJsDUHH4FWSyguwJogKz4XoQhyo7xK5ZVNohXzXB/tXhVvfjy0VrZaj0nPDJrYJAG
	 DXgoPL1y9npfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 09/11] KVM: arm64: Type-check hypercall arguments at
 the caller
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260720161343.1367007-10-fuad.tabba@linux.dev>
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
 <20260720161343.1367007-10-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:29:23 +0000
Message-Id: <20260720172923.E4F161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Disabling the hypervisor trace clock fails to stop the background =
clock synchronization worker.
--

--- Patch [9]: [PATCH v1 09/11] KVM: arm64: Type-check hypercall arguments =
at the caller ---
commit 171ebbffa4142a86e7fab981732cd83df6923869
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Type-check hypercall arguments at the caller

This commit replaces the untyped kvm_call_hyp_nvhe macro with typed stubs
generated for each declared hypercall. This ensures that hypercall arguments
are checked for correct number and types at compile time.

> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 2411b4c32932c..7fe0e8feb7d7c 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c

[ ... ]

[Severity: High]
This is a pre-existing issue, but I noticed a logic error in this same file
in hyp_trace_clock_enable() when tracing is disabled:

arch/arm64/kvm/hyp_trace.c:hyp_trace_clock_enable() {
...
        if (!enable) {
                cancel_delayed_work_sync(&hyp_clock->work);
                hyp_clock->running =3D false;
        }
...

Does this accidentally restart the background clock synchronization worker=
=20
instead of stopping it?=20

Without a return statement inside the if (!enable) block, execution appears
to continue down the function. This would cause the worker to be inadverten=
tly
re-initialized and restarted, leaving the background task running and making
periodic __tracing_update_clock hypercalls indefinitely after tracing has
been disabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720162412.1401=
272-1-fuad.tabba@linux.dev?part=3D9
