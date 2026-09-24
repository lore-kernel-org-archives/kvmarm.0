Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF014414437;
	Thu, 24 Sep 2026 17:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272152; cv=none; b=LMykVZyQKnH0+D9V96yo5n8U+bg7iEAEjsAekrNtFijegD+B+Ydk1lSyXGClzNQ/xDknVQzreeJS4X/CbXE3UjUHa+YjLZ1KjT/RGIPUNmFSoqSGOwxsYrOW/rI6sJNGJRCBVtlmifB2UISTid5XBPC7OGamrZ48H3FghjKi/Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272152; c=relaxed/simple;
	bh=RUGKJkpvGNOw3D5W12r3yu8YHb2YTtJ+Va6FrA7Uklc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uDZykYPJAqWbZ1a1h1qI63JhAJcwnIfi+lTqVX0w/gNn3jaq7WUCLCgr+futzqUf7KalmUZCcB5A89Ap13qXmph9O1mFztMLWiQ7qafDlGLxx5pJVCAkFBwWq5OvrR+cVex6HEiMy7XDspe1nUs56fJkZGj3RR8NlEA8EYni7Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8HentsL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8HentsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B3D1F00898;
	Thu, 24 Sep 2026 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272151;
	bh=Afh7CKlBfr6yRc5hBa6fV0pLtIgFU+C2KyxzkcSDOKk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L8HentsLssZFv4ouM3Hnt0KjfLLS0pDJ+soBoooSZ0s8FuhPwosqzCXyNCJqV+vmH
	 vsJz1m3961QdQMoWyYGRSmODTOFSB3zV5mEf8K9MJ1f69UJeQJ33qM2e8yh518nER4
	 W1HW/FGUZFzlsGN52DsKk9pugWYZsKMrExLxYcYbEk8gEVDftDClYICmfZ0AnluUOh
	 EEeKyOCZVqYg5lztJAbqTAcp73YINEzBmbc7UxGJAxltp/aMEJ0gjK1hj4GbRdTVhG
	 ozvuxsYXLH6AdlM+i4KXjyxNqKzmeEezIVGEww+kmtu9iuLYXHzNoF0RZrEW6l/ur3
	 K/bsDv8Ov5dFw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 03/22] KVM: arm64: Reorganize PMU functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260924172928.2110956-4-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-4-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:49:10 +0000
Message-Id: <20260924174910.E0B3D1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] kvm: arm_pmu.h relies on VGIC_NR_SGIS without including arm_vgic.h
--

commit 11313a8fb957f8fbf17d341d98c082ca4fdb6a91
Author: Colton Lewis <coltonlewis@google.com>
KVM: arm64: Reorganize PMU functions

This commit moves several functions that aren't specific to the emulated PMU
implementation out of pmu-emul.c and relocates them to the more appropriate
pmu.c file where shared PMU functions live.

[ ... ]

> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 93f41ac77c25f..e1bf29de0b6dd 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -50,18 +50,21 @@ struct arm_pmu_entry {
>  };
> =20
>  bool kvm_supports_guest_pmuv3(void);
> -#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num !=3D 0)
> +#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >=3D VGIC_=
NR_SGIS)

[Severity: Low]
Does this make the include/kvm/arm_pmu.h header no longer self-contained?

The updated kvm_arm_pmu_irq_initialized() macro relies on VGIC_NR_SGIS, but=
=20
the header doesn't appear to include <kvm/arm_vgic.h>. Any future C file th=
at
includes this header and expands this macro without also including the VGIC=
=20
header will likely fail to compile.=20

Should we add the missing include to ensure the header remains self-contain=
ed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D3
