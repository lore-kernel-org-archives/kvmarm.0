Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711180;
	b=DSSJR8cgITIW41anecj++z9YCamWInoeaTXnoou7ezZGdkHcgNR7aR5AMMB7XfDqrcdk
	 StHqsa98Q+cEJzYmWvjeIh58miuNWwmpWc7bCihceoqVSC052ZLX4PoSf3pR3kRSE44wA
	 AGF/MeJacs/EK8KIbjhbyijdjD6dBCdtZigeSfUWIizB8kmU9SanCfT1ooPzKwO7kKhcY
	 HS8ssRq18pZxQIE8Ofz5GzDoyIrbbqDOff8FSIyzMUCe6wrFwR0ND4HHAv7JrsKAoslsS
	 8v1QSm5jrxcGBEXbaUJ4ZZu/4TVWuznN8t+vVWAaW4GAhxLLv/zZBXkAt/ol4rkBXgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711180;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=uv05EscnTJ3kxav6QFkV6qM9VsMv62uR9qYoY8LEkSQ=;
	b=DV30yF22Whbu4acnSt7EF9CvJUhhikZptRgnhAJf4XkCyv86pqzUvqbvQ839+ySw1n0K
	 EHqiFgT4T3GCN/+0EGFOkKiao9U+G5fukYaRGRWQuzdWsC4adfuJNIFvCxMCDBSMoiWdw
	 FtlmkCONO9OM88WdwwcjDDJ4xf+cONrDezYxxw9WCm0nD+JFf7FRqcRoVigl4wnJwdYF3
	 gKph0r2NYVtJVfXzMDtguKI9kh4uxhHnOfak/cTDAUvXqW1LVNX9MaZU35RNZcMzAWCIX
	 rcVIaY3pLU70F0O7do9LmKjY7okQVAcNXBpdEju69s3jDMfk/kY1v0OCYeAQhCrYMnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nSTrAcv4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC915606A33B
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nSTrAcv4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DF11F00A1A;
	Tue,  3 Nov 2026 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711179;
	bh=uv05EscnTJ3kxav6QFkV6qM9VsMv62uR9qYoY8LEkSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSTrAcv4wsBRDB5Gl53KLVEB9IbIw7Lhu/cz80kl/dzx5Bxf82MwtpTYeOKVxT5h5
	 oTYBfAHmbmWytLCE+q7Cp70Gi4f6vyrZ2eZA6p0JscYj1NWGq57obb8YiVlsRvn9RG
	 xXoHkV+RVePgXy5TQauEG8QLQ6oZHuk0Xn1m7LkM5ThM+uyubfeS8CEDMzFW7+1/H6
	 GAwC77o4/19cU9UmKUYORNbKSTqoLMUuifdN7YWT5DBFQDRWuECx0PdUPZdptoUvts
	 BlGOkYZKioca7qKp/0pw1akVR6yvchhKPHAUz2ZF8gjelTMAcryvnMGv3TBpmRUqWT
	 2LvMmt6o+rNSA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDR-0000000ATWs-3sDx;
	Tue, 03 Nov 2026 13:06:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: selftests: Cover the ITS MOVALL command
Date: Tue,  3 Nov 2026 13:05:32 +0000
Message-ID: <179371111252.2844725.16046624190812989103.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261001071100.190013-1-fuad.tabba@linux.dev>
References: <20261001071100.190013-1-fuad.tabba@linux.dev>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seiden@linux.ibm.com, ndaugoing@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 01 Oct 2026 08:10:57 +0100, Fuad Tabba wrote:
> Changes since v1 [1]:
>   - Make the LPIs pending before they're moved, since pending state is
>     what MOVALL moves. (Marc)
>   - Put the test in vgic_lpi_stress, which now builds a VM per test.
>     (Marc)
>   - Test MOVI as well.
>   - Rebased on kvmarm/next.
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: selftests: Add MOVI and MOVALL commands to the ITS library
      commit: 6e4aea4c279c1be2707e5f1d8f94a3afc408b591
[2/3] KVM: arm64: selftests: Build a VM per test in vgic_lpi_stress
      commit: 0edd1f549a1d543fce3e0f6b5c87d182575cb267
[3/3] KVM: arm64: selftests: Test MOVI and MOVALL on a pending LPI
      commit: b5d08dcf25e7a22a7f52d9806c6c6db0c3354a0b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


