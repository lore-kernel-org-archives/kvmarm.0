Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711179;
	b=k5MeD+hm99SDYV08SXzraTR/6DGjG66QuSUav8nl0tBzeEWM4VJ9PKyBNY6zHjaN1jUH
	 bLk8p9EFmpGP0k2uYrujuh3iFTSW+Y1fv2P471IyY3ja0gE4bgilhhXgD/D6hM2Vhd5id
	 iZZqm0fcxddmIm7T/EeXr5sbQ6hU8YK8KVhOAYD6chefOuTYICTSh/I2f4WzvXCnCKiQw
	 8ir/+f2xDE1iyFPLZSQ+dAKyqzuqL2ob5jC4IzmmVC9Nto3aeZxO2H+QpkPJUtt8Ue0q3
	 v6SIABxjwPDNT+udGKkXXCu1iZPWUAIoM8cB9kBwC2e5TMbE4br+Az8OtZgtyzxP8zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711179;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=fQtvAH2sPMwT9/4es6pBdDYQq3km/ja6qrg1DCjQiSQ=;
	b=GrJ3Mt2S2EbnQfSTpiiVjRxVL95O6FeW6bO/yrX6ZsoxNtmpiuNVwjNTYhwQpAtbpvy5
	 I/Ky+ce4QmVRiBR6FNhUJYeJvcvSU31bg+f+Ul47qY/ALX7y0bWHy+ssxQhjn6XqM1kbW
	 jf+nAOifuTHG13K4aFyO1hnTen5kupRUb2RtUYkgGXEDt5RrWG3l1DWwMkHQmVIElzWO5
	 btP9Mg5OtrW2qbmo/DCRlkw2WLOF941hTql7LNY4Fuh2Grmxqd9k4jCEQFnwED83WcrVM
	 o7UJmPQAL6pgt90IN27R0WKQmnajD00eNDS3BYVU6Urt/be3rd3kTphgNojWRIQ/ivw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=atr+m2FA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D221606A32D;
	Tue,  3 Nov 2026 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=atr+m2FA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDBC1F00A16;
	Tue,  3 Nov 2026 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711179;
	bh=fQtvAH2sPMwT9/4es6pBdDYQq3km/ja6qrg1DCjQiSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=atr+m2FAPDD64iZ0XyyXQ84HIDyCT15hGJd8UDkIosZFda0Asq5FLv1zhEnVoMf/h
	 amTA7w2QlkPTjPAg4yHenT11i68/8G20FDF4ET+TZF+UpnqsMdxh6HlDOFGU4qDsCb
	 xMiNOJ3ZGWFrBLo0VXwcr2QukT9zTexv57RsfOwV6HG+fp0o0chH2sJGodmgT3SFCO
	 yqaM7pHwkWJ6NccTMuAJZb94E9/4wGUq5uljxMN/G9P14VH7PuLd+iGFTpInewdRQY
	 +PCw24EUs0DAWRwuHgSIGnOKuGJ+cd3wTgtvzocJCTGOviUGQqMSXizqokFYEDhY4U
	 6bSHbcT8+Zu4g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDR-0000000ATWs-0m1K;
	Tue, 03 Nov 2026 13:06:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: vgic-its: LPI pending-state fixes for DISCARD and CLEAR
Date: Tue,  3 Nov 2026 13:05:29 +0000
Message-ID: <179371111242.2844725.6486225294847802157.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028173319.1807811-1-fuad.tabba@linux.dev>
References: <20261028173319.1807811-1-fuad.tabba@linux.dev>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, fuad.tabba@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seiden@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, andre.przywara@arm.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 28 Oct 2026 17:33:17 +0000, Fuad Tabba wrote:
> Two follow-ups to my DISCARD fix [1], for LPI pending state that KVM
> keeps after the guest has removed it. Hopefully in time for the next
> fixes pull.
> 
> The first closes a window in that fix in which the guest can still take
> the LPI it discarded.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: vgic-its: Clear an unqueued LPI before dropping its lock
      commit: e1024ed9c3823fbc4b1e65f351088f0bf999b887
[2/2] KVM: arm64: vgic-its: Remove the pending state of a cleared LPI
      commit: 147ce65112bc7255d5e2d3b12aaa23dc9ce44371

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


