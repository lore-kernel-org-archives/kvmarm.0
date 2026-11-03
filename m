Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713526;
	b=o04EfVM61r8JdmVwyKMWCZMeRSLjdXnqvMuDCavm3yTLOtoGfTxFsHFUN77PXboWd0qQ
	 lLHo9oFuzE4nh5G92RXqUDfK3Hz5L4G/KyChLMiODHpJ2aQnclk3jJoCfmoEr7sdsUhJk
	 TatrfjOHtpwMZlSiAn0V4KfJpigs0Qg4+W/UEjDXB2XX3HN1ZVK080snxul+Jfm9meYCO
	 kkBDhCIiTknpbyS4l3SeURGQEQDkPj/7FejzdST1exhLvLzO5Fzi3KCDqrSikBD7mkGKa
	 9LjoukzSPP+iPe8oL9y4z47W3a16ARE2AOiA3YVw8mvNCthFhIU5R2NYU4IPrAEwH/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713526;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=eirSbdBsDnP2H3EX3QFaToBg2WK7+I8nA5mg6pTJZAc=;
	b=Tlr7YHfMwV4tj3NrpKgD4x5JuaYpyILhM4+vKXtRFMmFAo3zn8d8FS8/Ld/AghQIILtd
	 iVLKU6jqLtma1Bd9AS7Yxi90xHv3n5vA7XGYEmpouuuvQqSeA0uVlYL0kMiJiRplEJRw+
	 vMkd0iCQfzkIsDWBusGK3EkAdOUDC8G7ixlCEnkE/0gYZsvdWst7/POSsMSJ0oosDaDzq
	 1ko5PEszwH1WnP00Rayc133kHjlZNW6bBYzVd3Ncosy9VILmAqR8GPd5C5+uOc7V2HLn+
	 X3w6SPL7S9rx/jPcqDYnQVjKD/tRHwWwfFjVCzBKj4m1a0ncBPyGLs9IyLAw53iF8hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fOIpFBTM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1CE606A326
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fOIpFBTM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3541F00919;
	Tue,  3 Nov 2026 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793713525;
	bh=eirSbdBsDnP2H3EX3QFaToBg2WK7+I8nA5mg6pTJZAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOIpFBTMyxU45+1ODm2v727R+mJeqTcyXMPJoW27BGVkQH8/UcwqGUhiY2OoI/rbg
	 qguwGOOQKUUX8ccM+Mh+2ZrG7w469jX/FfAM7RrByixMCvXq+HK+ke8Gm8Fo5HJowC
	 Ngn7JfIb8OiWC6YN3MTlO0+/zQnp8BijHUdOPKczu08foCQDYEmuqBtIOfsHEmrpVg
	 qFf0vEkAtuUvh8Ef9L5NGjPNPA7JKfdFJWZy5XZkzYmRSF6PGcsu9PrgHmkTRsit4t
	 Hti6kTxBV3WLREHPrhiJR3wkukw2SsJOw4smiFR1KiVxaCpPtgEtPPOOc8Z507VK2C
	 UgSpuAsMru5pg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEpH-0000000AV4j-2A9l;
	Tue, 03 Nov 2026 13:45:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Reenable MTE on VHE guest exit
Date: Tue,  3 Nov 2026 13:45:19 +0000
Message-ID: <179371351574.2945223.14818427732835128303.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026082305.2515705-1-maz@kernel.org>
References: <20261026082305.2515705-1-maz@kernel.org>
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
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 26 Oct 2026 08:23:03 +0000, Marc Zyngier wrote:
> Upton taking an exception, the CPU sets PSTATE.TCO to ensure that no
> tag fault can be taken while handling the exception. It is SW's job to
> eventually clear it when it is safe to do so.
> 
> It appears that when MTE is enabled and that the kernel is running
> VHE, nothing eventually clears TCO when we come back from the guest,
> so things such as KASAN_HW_TAGS will not work until the next exit to
> userspace.
> 
> [...]

Applied to fixes, thanks!

[1/2] arm64: Add return value to mte_disable_tco_entry()
      commit: 09436ffe8f1b396c6446eda12798e46f82fed48c
[2/2] KVM: arm64: Reenable MTE tag checking on exit from guest when running VHE
      commit: 491fe17530d662a7e6c6b4d139d950dfa0e3a210

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


