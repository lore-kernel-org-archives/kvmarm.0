Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDB037DAAE
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 11:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784027826; cv=none; b=EGl82pHcar/cpHg9QOaTJjvFKjYvgTfVR0s/yu1n0iB0hctAWxKGEbQTg+BhpStDhrmIiK8zL7qDXnivFLFuVqOtzLM9oYrot+HCWu9uyMreyzvfoGsULW0edSveZlG8rVnXfd6HvWrqi4jRQdnuLXFWnIGbw8EA4Hryab2a+wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784027826; c=relaxed/simple;
	bh=nINWUrQikdbllWTvIkLTn9mf9ZNgmHtbS1mnxxfcbUg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EDbhnqZD0UCOifFEh/z3C+mJB93FRzXbRUtILL9hQeW3XUMosIziQARRZ3wztHgfn0HC4uh0VhNwcUbLTyddndAmUCntSaxct7KVQDMNANSwnUj41O/+HpohH3IgR1pjC9QWTWDL6borkLmV6hHSfO7Sb+m/yt5poGJepS+Od1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kn5ZHYP7; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kn5ZHYP7"
X-Gm-Message-State: AOJu0YzWctXDoYLxAMf8nVv7kwDz0q2TA+3HXRJORARgd34I6w44+1OE
	uAAj/K0TWe6ahLaxJCehJa85RSgVv9doHAv7ckTjdhSU+zBs+DVUxCSx+pvAIhCIOWtEotDOG3K
	GwuHBcl/gpBotjMWbMKoQzq5JRF/YD9aXkFjGu4q3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784027823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nINWUrQikdbllWTvIkLTn9mf9ZNgmHtbS1mnxxfcbUg=;
	b=Kn5ZHYP7f7Bs2vQpT1KyhO/GSxYLJNu/ZWn89jUgohU5YTw6Zfg/xRH6g1s0xpB0YnukeI
	kdQrV4CKljXWtrq5ImdCoWHx2hMfsC5FoRmoRw2C+jS4HMoqO510IQVc6UWvF3epftJ56J
	YhCR60qrRVma3EA9Ix7iRH6htHIeA7I=
X-Received: by 2002:ac8:5d56:0:b0:516:ccc0:ee38 with SMTP id
 d75a77b69052e-51d7bcd4bb1mr13120371cf.9.1784027791943; Tue, 14 Jul 2026
 04:16:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
 <20260714101601.4142645-5-fuad.tabba@linux.dev> <20260714111016.E23701F000E9@smtp.kernel.org>
In-Reply-To: <20260714111016.E23701F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 12:15:55 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxqw1sXKrxXeQUBsvsJ7Dd5B=hwRfwWsJ1YJB1cfrf_KA@mail.gmail.com>
X-Gm-Features: AUfX_mwCi_A0yHjYEVQMFUPMbEzWFlVH-91GEsRIGuF7VX-GACalBygVEVcpVCI
Message-ID: <CA+EHjTxqw1sXKrxXeQUBsvsJ7Dd5B=hwRfwWsJ1YJB1cfrf_KA@mail.gmail.com>
Subject: Re: [PATCH v5 4/8] KVM: arm64: Move PSCI helper functions to a shared header
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Tue, 14 Jul 2026 at 12:10, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Low] The header `include/kvm/arm_psci.h` uses architecture-specific fu=
nctions (`vcpu_get_reg`, `vcpu_set_reg`) without including the necessary he=
ader `<asm/kvm_emulate.h>`, breaking header self-containment.

https://lore.kernel.org/all/CA+EHjTwpB2fmoYGfkP5RVZcB4sgbVPQ0=3DQR5dyUJnpQ_=
VQa+pA@mail.gmail.com/

/fuad

> --
>
> --- Patch [4]: [PATCH v5 4/8] KVM: arm64: Move PSCI helper functions to a=
 shared header ---
> Note: The format of this report has been altered due to recitation restri=
ctions. The original patch code is not quoted directly.
>
> commit 0c74ab23a0a20b7f1a788c6ac3e03217bd5099cd
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Move PSCI helper functions to a shared header
>
> This commit moves several PSCI helper functions out of arch/arm64/kvm/psc=
i.c
> and into the shared include/kvm/arm_psci.h header. This allows the functi=
ons
> to be reused, specifically for a follow-up series that handles protected-=
guest
> PSCI calls at EL2.
>
> [Severity: Low]
> Does include/kvm/arm_psci.h need to explicitly include <asm/kvm_emulate.h=
>?
>
> Looking at the moved inline function kvm_psci_narrow_to_32bit(), it relie=
s
> on vcpu_get_reg() and vcpu_set_reg(). These functions are provided by
> <asm/kvm_emulate.h>, but that header does not appear to be included in
> include/kvm/arm_psci.h.
>
> Will this cause build failures if a new compilation unit (such as the EL2
> pKVM follow-up series mentioned in the commit message) includes
> <kvm/arm_psci.h> directly without having already included <asm/kvm_emulat=
e.h>?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714101601.41=
42645-1-fuad.tabba@linux.dev?part=3D4
