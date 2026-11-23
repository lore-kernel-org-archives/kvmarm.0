Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795431661;
	b=e90NW371enYm/g1K3y9LNxUBT5wc8L5Cq3nj/Wvt9Ap9B/ssn5YzlsNYc6cr+99FV+Pu
	 pccCrcCNOHszTZt4vfZeyteVCSCFV5NBmjg+2uNdQBf4Q8a602UjiQk0AMUfsNDJqK9MO
	 Y+WxzeuybmL1gRrx6VJL7VlHTHqB92hfAK5YH9aXwBhJThYV+pl6yuVve1TIH9bw18g7j
	 /oD0Q/devMcYETmGPOzrqsdUEmCwqrY/D3Q/14FgpH4sSP8cVjLopAidAGljVWTl96leV
	 ytZo5CVZGVlZzKwn7781YANUb/csfvg7iYuMmNqL24aZl9E8ggpvFol+pFSfNg2u01A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795431661;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1VAdt+1sVGwlsBwq7UEZYv8RXRv/Lu96NDni5I2M+gQ=;
	b=3yC1iyYEi7ezrt5T6XbksXjqOAda1IYgAJoOK07q4DiVFOUeoZ3NgEyCPHJ5N0VONbrn
	 0b8DMbASFBc7J+7ZEdWG4UZiImWE2OP80P6U7VOmIk+SWIBtyHYpbd90TpHENYAjSLiav
	 BvCynhAbgcihLrl5GPiNVIhbEwb75m1DNVnxagsydthmiQ3NXphhJt0dAVr7dGpXOysNR
	 wpYsDR6cNT9rOABoMEWqfskdkkLSYNltQjvV8n+ucb+9Svs7SZpWWM+kB/4TsoKPJxMsv
	 R08RfXIldHQUP7c8WvyOofcHGNLNNtWYFxZJGWdFXKzBblWKEZ94y/5D9aXN0MankNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtZGXJFT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA34606A335;
	Mon, 23 Nov 2026 11:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtZGXJFT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832AE1F000D4;
	Mon, 23 Nov 2026 11:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795431661;
	bh=1VAdt+1sVGwlsBwq7UEZYv8RXRv/Lu96NDni5I2M+gQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gtZGXJFTtocmzSFBtFsKEZ/mWnt9o5K0RbY9e5eQHzRK9Eb6VePh+6WWpY9RJVSt9
	 3ubxuTaTfS5WBcC84dynIryyK7tc3NS6tATu77WaQa/jOsXa9fbAR8UWnfWOxVc+lr
	 wxs24sy2BXK3T43xup0LztW21/m/2adSvhv8uyYUeGNra8zmHMh7eWVH7tS1FjQ1sB
	 8J8YaH+/gEHCusr7yKZbg1vi4upA7aO/Xxnjof9BJj/Tz5h6lc+Y0O0KEOczNPKLq/
	 +bSKFKKp8i2djhBKtPHJ5plyDgbh3jI9hzhFBIKOB7ftTscEHwIo6JP+buDmxy6Dj9
	 PS+IP4rCoXiAw==
Message-ID: <sashiko-outbox-229087@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/11] KVM: arm64: CCA: Destroy RTTs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261123104233.95710-7-steven.price@arm.com>
References: <20261123104233.95710-1-steven.price@arm.com>
 <20261123104233.95710-7-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 11:00:58 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] KVM: arm64: CCA: commit message describes start_level change
  from parent commit
--

commit 31acfdb8b4fe1e156914926f66bf5cbc470cc71b
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Destroy RTTs

This commit implements Realm Translation Table (RTT) destruction and
undelegation during Realm stage-2 teardown and final VM destruction.

> Use the same minimum of two stage-2 levels as VTCR when deriving
> the Realm's starting RTT level. Without this, narrow IPAs on
> 64K-page hosts can give the RMM a different starting level from
> KVM's own page tables.

[Severity: Low]
Does this paragraph belong in the commit message for commit "KVM: arm64:
CCA: Add basic infrastructure for creating a realm" instead?

That earlier patch in the series introduces realm->start_level =3D 4 -
VTCR_EL2_LVLS(kvm->arch.mmu.vtcr) in kvm_init_realm(), while this patch
does not touch how start_level is derived.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123104233.9571=
0-1-steven.price@arm.com?part=3D6
