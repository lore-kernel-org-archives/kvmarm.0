Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711182;
	b=NDyRaQsYWAxUg9ixv47PbiDiTBijyki566tPRBTPIF3/Gq9NH40zWiT+V6qbfEu4fz5Y
	 doFOiqqC2Gvhsi4tdS2OnJdC84D5ZLAgThktr3DD9BiSbR5zpKx3ClAVFBYjnTAuw56VC
	 7oe3mBOow6LFoOWknZxmipW+E8fQEBtaWxTNitgotPehEWFlomPGoCl5EQVe3z7Lb1LDL
	 QT0wkV3uzuP0N25L5AM4qQw+0dlV3keVUupgCidm+iUnSVypf3ppLLUhga7r0WM/MXxDy
	 JMBdGq1lt/hhuBPmJj2EFgMJmuwSzF+VVLwhVQhKZyAligN6kP1pRQnF3qUzwrQaGJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711182;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=yLW6N3IDkrwbT/Cv198pCe7+B8PW0CEgrsdweEneovo=;
	b=4soIetsmtg40Qf+NdiNt86scS1hKtx6mW3sZhJEVybj3R9b/ipiHZV1FfZoGOgbhBkSq
	 m690Lyzw57IOMpiFNJX4NqdajV0BbmlbvjScsigE9rOMhjpN24HgZprllF6EPjDwlpUYw
	 E7/ZgNVXlz2LPKcNPovHMMu/MxZZscMUneYwHP8Al+GanAgVbSXqOqJRIMgbExW3B3K+4
	 mBX+JWDs/AepU1gNOgy9Wn1s65RmQek8FYKwypqenZdAWWCVsuuPQkfr+SrR/NnmYtQH8
	 rIj9D/SbGYnvqp7ULIOM6tMaCFURcD//P+u4pSCyzpSFU+uaI7iNX1dloVXwli8xNbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C4NinK0A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255D4606D834
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C4NinK0A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C06E1F00A1C;
	Tue,  3 Nov 2026 13:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711182;
	bh=yLW6N3IDkrwbT/Cv198pCe7+B8PW0CEgrsdweEneovo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4NinK0AzAJ3zDFwTaXJapiRhjHisR2Yo3mrpSVDKb8FCFlhMjLsnKR8JJi/AJo1p
	 W4oEotY1qOlw2cwuS8ed2UqXZ87mwCGKME4/4qgNPuMPoqERYeaygv+jhGOSqOdEns
	 Jiovf655KXoJg0gro9JYk7yQTXRDQ1CL5wtK9x0rG7zZBH+mHrLZx0SfDXJYjH7BZe
	 EJMXGe0ogPNEsO8zQGb9pmG7WYpOZ9MW39LES6HU3hEtYhIMW/HhSLUoc7480eL4Rv
	 EjASeMU1sXAG4d3R8+QZOS5V4BjFBzufIvvLzp+JO+NS10Urw4w9ymW3PVwmK1RLdL
	 W8L8xVqw0mgQg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDU-0000000ATWs-1cwH;
	Tue, 03 Nov 2026 13:06:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v3 0/5] KVM: arm64: TCR_EL2 fixes, FEAT_LPA2=NI for NV
Date: Tue,  3 Nov 2026 13:05:41 +0000
Message-ID: <179371111258.2844725.32981511741827893.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029223732.103785-1-oupton@kernel.org>
References: <20261029223732.103785-1-oupton@kernel.org>
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
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, weilin.chang@arm.com, seiden@linux.ibm.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 29 Oct 2026 15:37:27 -0700, Oliver Upton wrote:
> I went ahead and grabbed Wei-Lin's series [1] that added TCR_EL2
> sanitisation since it makes life quite a bit easier for computing an
> effective TCR_EL1.
> 
> Tested on Neoverse-V2 running a guest with FEAT_E2H0.
> 
> v2 -> v3:
>  - Collect R-b's from Joey
>  - Add patch "KVM: arm64: nv: Correctly compute the effective TCR_EL1
>    for nVHE TCR_EL2", itself picking up fixes for forwarding missing
>    fields into the effective TCR_EL1 value (Fuad)
> 
> [...]

Applied to fixes, thanks!

[1/5] KVM: arm64: nv: Don't advertise FEAT_LPA2 for guest stage-1
      commit: 192a20f6e105e679c48e98c66af6336d37095f09
[2/5] arm64: sysreg: Add TCR_EL2 to sysreg infrastructure
      commit: 2942baff3a951e0805d0ce9608f318e21c7e3744
[3/5] KVM: arm64: Reset TCR_EL2 according to guest's E2H mode
      commit: 81755e75f86c490bc9296f6cec0cd221edecaa27
[4/5] KVM: arm64: Convert TCR_EL2 to config-driven sanitisation
      commit: 388faffbd371fd367d39535ad2aa07fbbd745c08
[5/5] KVM: arm64: nv: Correctly compute the effective TCR_EL1 for nVHE TCR_EL2
      commit: 361564a8d4305100ee4140ff7b345d1bf2c1a1b2

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


