Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711182;
	b=diGkEu8ZLAKV0I0XjQaA9LbJQ9YceHwc3rzhb3foFK0AzFH/68MD6DeA8HwCsjRCsbEj
	 SzG64i2PUChQdQEL+GjGo3QNqdFfGZhqiVGOSv7vkm7TivdjtvKjtjlylFWEvntNBa5yQ
	 IZrlOY5RdokckKAFvE0aEDbXM4rukpC8DfA9CsyJ8SvqMyK9s05Oo2DCUVAjgs7xoJfbE
	 j4nzFqBTv2hOu2WviDX+iu4abmU3XFgINmOb/HNJAhklPENYJveHFXNHv/jnoI9XOdutp
	 tyo5NQP1tvaKWgKk7jj6m1AgxtSnffsu1MmIgca9owEnKSmfiK44KkcvR78nBYr32pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711182;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=gi/ch/JS08KZSEQShoG8gR4zN7dxLDnzLol7acy/5Vg=;
	b=XgYFnhgi9AGz0GYtH503gL/FmRp76zmfHN77iGMIdsW0YTTCBzOVs4qRz8lBAM8uUl8E
	 wWoU6qKTzK4uSvXEw0MEa8s3fYiccCdg1Esh6YIcWZe5oSJ6N3F5J4KzDpqj7ZutBbjb2
	 rNvNTbkpjlEomsTerOXzVDoDuXbFxZf0t9EU7PacuNEg1FDLk8g7Bg1wFAckVHcHfsieO
	 EgZgvxG68pqeLhZyglT2UhIOAXAOJfqqGeVI2QYgMA9/khIoLK7YDXf1JSa65oaq7U0SO
	 2PtD5kw/f9AStpWfAEHy/5wOrK4utnJq/fFWDaGIiYpgbh2QuvJBERPHQ2fjycDUkJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EvQhj2iV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F320606EE83
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EvQhj2iV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8642E1F00A1D;
	Tue,  3 Nov 2026 13:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711182;
	bh=gi/ch/JS08KZSEQShoG8gR4zN7dxLDnzLol7acy/5Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvQhj2iVix1aRypilF9q5+I4jRU6doXjIxnrceClJ2CCua5UejUQacIa9qU0b8P0A
	 3/HLIwKBzEuZxE6FuYx30iQXymrdxQ9PQIGsgiCT1gGiC6iJjiDfs+aQhme95KN+tp
	 hYy1w8Ym09+e8bOrwC89CmOFaEjUumLuV8MuywguvanpYsTuPSDx+/zRU/iLYn7WGK
	 /PkEf9GBLizjkkEBtYzVJTvQB9Px7wSZCNkTeei6f4rqSFxLnPRy1tkKanonEmPJ1X
	 6ARFk565Ijt5CwMNcnm2+WM4oKtAFGRz0r3ELbrLdHvYAgMbFAeam0k+2w55/yHIca
	 fjpwUu8Yn+tMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDU-0000000ATWs-3brp;
	Tue, 03 Nov 2026 13:06:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	fuad.tabba@linux.dev
Subject: Re: [PATCH v3 0/3] KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
Date: Tue,  3 Nov 2026 13:05:43 +0000
Message-ID: <179371111274.2844725.10738351642638708821.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026163937.963087-1-vdonnefort@google.com>
References: <20261026163937.963087-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 26 Oct 2026 16:39:34 +0000, Vincent Donnefort wrote:
> The GICv3 List Registers (LRs) are architecturally UNKNOWN when a CPU
> boots or wakes up from a low-power state. When pKVM is enabled,
> __vgic_v3_init_lrs() is currently never called on boot, CPU hotplug, or
> CPU PM resume.
> 
> Following Marc's comments on v1, instead of handling the LR reset inside
> the pKVM hypervisor, this series fixes the host CPU init, hotplug, and
> PM paths to properly reset the vGIC LRs even when pKVM is enabled. This
> removes a few calls to is_protected_kvm_enabled(), making the whole
> hypervisor init machinery more generic.
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: Make __vgic_v3_init_lrs HVC always available
      commit: a511905b3c0d6e73afcc4016b2eddc159703060e
[2/3] KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
      commit: 91e496a1e474d56e296f3997ed2a34185e9a1c0c
[3/3] KVM: arm64: pkvm: Reset GICv3 LRs in the hypervisor
      commit: 5fe9e7dbc78e3ade118a8f64952b7ed84e502afa

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


