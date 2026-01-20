Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ADB3BBA1C
	for <kvmarm@lists.linux.dev>; Tue, 20 Jan 2026 09:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768899958; cv=pass; b=p0PGHXmD/4YNzmZX0CG0fXa+fulr1VhlvVBkNyr3pUH1wbDdaTIELQJw5O66O/AeXengNCGIXkm361mndWb7DvvnKD3wBXhGPjmcV0PD0e91LUWLZ85cJSVSalYpnuin8E6OW5ouE1CpjvNdyerpLKI1Yspz+hwpBHIHKrnogho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768899958; c=relaxed/simple;
	bh=KY2xlS/OqOjpneOdAYcP85NJ46P/3Q0Ojs3FNxjawDo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iClJQgdIlTfzAeZYA/nFAtMD1ir72xaCRt0OKeaCOq5C1THuovv0MqeGK++c1UG2uWxfPgqlrcsbg2/1ZByF9NQVjyX+eN7X+ho7ylHu4vpN8u4k5CtJAvi0P0GlxVsGM68TfEwy7dhm4Zoe5WLY+xIpEx8AfPrWla6BEBfdibA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BfrgyKoB; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BfrgyKoB"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5014b5d8551so1270591cf.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Jan 2026 01:05:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768899955; cv=none;
        d=google.com; s=arc-20240605;
        b=ScgYOqoJp51zLeFzbDvpJ3cBVAXwxCW3cIvTAkEV3+/gTg0Cq3fYBw8N63ur5plupm
         gqf7LXpyBn8O/z5qpb8AGCjqNlKFtct3GugkwMu9GGVJov+EF1XKTY3cM2SVGkCvzYOl
         aSvH0EShUosgdRZOUVhba3DxhMRMnzTSTP4p8fh9YBm/JHODFAASNykpyAvoleqg6CMh
         /nx63G9rtM0k+bKYIYpghLSRgZm/2rHOxSh8Ylw2rvV3N3V4+sq/gbcDmAsa0ozMeff3
         8V7rbYqSkA6puD6AtFljmn7SqSTkGSLfMzRhwqR6WCI7YlbhjWS8Acrwrq0dYFq/UGiI
         SFmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Zxb0bCjWw+8Tx61kop8UU9Q6FPDuxjKBr+a9QDCVakE=;
        fh=o0/Hm1aS1LjyxEa+9pWnGmShActuq+GFNJtSruYHsig=;
        b=IYumOY5djDLTUUSRO5Mio4cTY/cajyTo2bIO3o7H/sNKIGwBiApRmQ7Yhr/iii0cWQ
         bG+x6Yt3KEFnVZFz0EDXjTosF0FWXeux/TttzRFG/+7qTPKzECLA3wHN36zIuyk9tAY6
         e54nl2zZgzU8vKXMXkP9PVuwD0IBAIJ7yTdkpEZ8SXYvE06Jk50e+tNLhP6eZA+LbROs
         0N4EojjPcTPaSNmPFi8Fqj8MmG9ksEgUUXJRrnsfp0Vs7KV0seW+TrCtm/w+13daCk/v
         wSbSS+3lQTl+XpgD+zBU56dSLn3rhOwIkyS0XA7x0ccItqvLHdJPHOmQnNOhZ6qHOeSI
         2Byg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768899955; x=1769504755; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Zxb0bCjWw+8Tx61kop8UU9Q6FPDuxjKBr+a9QDCVakE=;
        b=BfrgyKoBczvjO1lPrYwQPwz5KjPnAyw+5wM4czguc920bT1lcfMRXlVrRCQ42rPEFG
         TzY3GYVJSqAfs6d4k/F6Ak1FpTrw9li10QFuNxP/1dfoQTcf1P967pRzmNM0tC00QWjS
         g2KkQtZSDr0zaF0sLDsB2r66Ja+kqgAq+MJGkaA3MW1h8CQ3x61wqHv1HdeF41HtzzD3
         QVYUFOZCLb+pszqQownCVv/SvN9385M7LEVYFlgepdmRXDCyanpwvLBTMI8eNgM5NK2J
         ORAzrYgVICHEU/+Uz8PWs4CsK+JoaoKArfcfBUfPZF9iZTYMYeqKkTdZsjSmizpIwsQ7
         HSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768899955; x=1769504755;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zxb0bCjWw+8Tx61kop8UU9Q6FPDuxjKBr+a9QDCVakE=;
        b=s3ivvAF1uFtRdC3F11CD5Jt1IHQwKwoAa4NXdrh/YUtTMfazML88CewFFZlS1y6Rp3
         5BfR8zd67rxIHScMNh5IUfNkeBWHWZqMCy1DG8Z6+biWX2apqzUa4ksB35ZhzWTPp/aE
         qvxrx+MZb54bEL6GI0/qa1SAnWcJCImqb7gFaaBpH0cG4JfRVxtQsS+JjX458AsN3Tts
         Tu9rtw5vI+nKfOlWCEgKuaFOuWYSsdlujUjvJnSqu7yUfRqdOziXjEnnI1j0U+hWeZ+/
         InwvgGr7KP68UWjk2BwiLa6PHoKoQmpM/Hu7x16C91EwH+AXjs19he/lKB7uR1/MYeQC
         LFug==
X-Gm-Message-State: AOJu0YykQD7TI6txssjFdUa+p+RDbYkoy0xr+Ag+xKUDAe6pZiWlHFTV
	ppAqsO6flUFBBDuLV7UT+tYxiarrpt+OTkZkCOX+Ecpp7eVJX4YEkMHcE8uIQqWAWZBmIBCCANz
	Rcb/snkIVeaoXDKWe6n8B+Yj3GWs9+WnEpjXu+fdSm3+mGZBVhCJKgDt//gw=
X-Gm-Gg: AY/fxX6hpYXSrBkF8ornIYdN3gCU1BbNe5G0fdxol49gGiU7P4L2twB5TNc6kq+T51/
	TG9cHuA8mJ0gibNoDVM8iIlQqsq+4ubktKRaZWBXmolyjYUZUjyxNsB+Gd/YL7yVf67TygpdL3F
	aQOmBlZcS6SSrfOq4gi3EbBXZLexBIMJdrMbusXa8ikFbf7T2g64gZmDk6rypogaREtqivnxIds
	3TzpPX04hJE2DWOxMa3dGiLTL+zGmPKWoeAYDsuty6CCFv5bWBBHjDfH9PIGq/TTLpaQURGRCGh
	HjyylA2kpuJMjsiEr2Po2D9g
X-Received: by 2002:ac8:5a09:0:b0:4f4:bb86:504f with SMTP id
 d75a77b69052e-502afa34633mr27614241cf.16.1768899954787; Tue, 20 Jan 2026
 01:05:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251211113828.370370-1-tabba@google.com>
In-Reply-To: <20251211113828.370370-1-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 20 Jan 2026 09:05:18 +0000
X-Gm-Features: AZwV_QinPp0oM39FyUR1L7fuX3qSCH416MYXIyl6zO7KU-GMsNZIJeM6CnncU2U
Message-ID: <CA+EHjTza1LRztOLnmnwr-g9oYFQ0mLG0AvLW9FeHZHm0qguTEA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] KVM: arm64: Enforce MTE disablement at EL2
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I was wondering if there's anything else you would like me to do for
this series. Should I rebase it on 6.19-rc6?

Cheers,
/fuad

On Thu, 11 Dec 2025 at 11:38, Fuad Tabba <tabba@google.com> wrote:
>
> pKVM never exposes MTE to protected guests (pVM), but we must also
> ensure a malicious host cannot use MTE to attack the hypervisor or a
> pVM.
>
> If MTE is supported by the hardware (and is enabled at EL3), it remains
> available to lower exception levels by default. Disabling it in the host
> kernel (e.g., via 'arm64.nomte') only stops the kernel from advertising
> the feature; it does not physically disable MTE in the hardware.
>
> The ability to disable MTE in the host kernel is used by some systems,
> such as Android, so that the physical memory otherwise used as tag
> storage can be used for other things (i.e. treated just like the rest of
> memory).
>
> In this scenario, a malicious host could still access tags in pages
> donated to a guest using MTE instructions (e.g., STG and LDG), bypassing
> the kernel's configuration.
>
> To prevent this, explicitly disable MTE at EL2 (by clearing HCR_EL2.ATA)
> when the host has MTE disabled. This causes any MTE instruction usage to
> generate a Data Abort (trap) to the hypervisor.
>
> Additionally, to faithfully mimic hardware that does not support MTE,
> trap accesses to MTE system registers (e.g., GCR_EL1) and inject an
> Undefined Instruction exception back to the host.
>
> This logic is applied in all non-VHE modes. For non-protected modes,
> this remains beneficial as it prevents unpredictable behavior caused by
> accessing allocation tags when the system considers them disabled.
>
> Note that this ties into my other outgoing patch series [1], which also
> has some MTE-related fixes, but is not dependent on it.
>
> Based on Linux 6.18
>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/all/20251211104710.151771-1-tabba@google.com/
> [2] https://lore.kernel.org/all/20251127122210.4111702-1-tabba@google.com/
>
> Fuad Tabba (4):
>   arm64: Remove dead code resetting HCR_EL2 for pKVM
>   arm64: Clear HCR_EL2.ATA when MTE is not supported or disabled
>   arm64: Inject UNDEF when accessing MTE sysregs with MTE disabled
>   KVM: arm64: Use kvm_has_mte() in pKVM trap initialization
>
> Quentin Perret (1):
>   KVM: arm64: Refactor enter_exception64()
>
>  arch/arm64/include/asm/kvm_arm.h     |   2 +-
>  arch/arm64/include/asm/kvm_emulate.h |   5 ++
>  arch/arm64/kernel/head.S             |   2 +-
>  arch/arm64/kvm/arm.c                 |   4 ++
>  arch/arm64/kvm/hyp/exception.c       | 100 ++++++++++++++++-----------
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S   |   5 --
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  44 ++++++++++++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c       |   2 +-
>  8 files changed, 114 insertions(+), 50 deletions(-)
>
>
> base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
> --
> 2.52.0.223.gf5cc29aaa4-goog
>
