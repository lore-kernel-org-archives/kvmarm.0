Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711179;
	b=SOL/3Bc6efzqB7RBMuu0hhX82ndcxFsFcesARoe9GF2bc+b9dPIm5xcbQ63XvJ8hBvKy
	 q75gGcLYExUnQs7z9LGGC6JbtE1oXsO60i4fhS15p1kdOEKoLyywd1tLUqEtQbmxY5hcV
	 2P0qjcuj+s+iqRbJqBO6by6mpnZz60yTZJbz6wOVnlYsLwd1efIcMwvHPa7CMhmHRLO0r
	 dWd4ieaA1KeZ0GedaCPPIKlMWVKHdknIW8xI6Wc6ko/pNzlcCA5bNk89Axfdj2sZIJ+F1
	 y5DUxnipDX3BZJgJsxxqKq55ha2Km7y9jUemWOZym9RPellb6uQ9lvmnOQ/UzzfkQvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711179;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=jpC9vuyM0oDYGwUVcqxTgssTiCR7zkzLjAhyFTXihMI=;
	b=fJvASzleC+1Z7S7qWWAAOU1IQ5rSaxXdSWN11lAq4BeJ3Y2DkzgZEwvLmcnq3PGXA8Rd
	 cgRajdQI3vDzasITlOmJFYS5qwKJPf8fJyVR20FyHmm8Rcvs1RJ7VD3zMY1HubUOA88lM
	 Nen94AiWVZvpO57L0RkEcHUPeQKrg9lPV+peahzKs6V0rVhs7dKfoob6Qddza+0s/ruB5
	 6iEgTL3YQIgYDgVFeTSrzdXyrFPpN6thqtehln3Jp549nFMyXTbXtzSdoTlD1ukhpTHEU
	 It6u9qtm1AAEwqCzq43PGG8onbxnim4w9OTQDcQItsAsjo7B5zXhuq3SmUVcDQX0HLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GmUeDqRi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C53606A329;
	Tue,  3 Nov 2026 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GmUeDqRi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F32C1F00A18;
	Tue,  3 Nov 2026 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711179;
	bh=jpC9vuyM0oDYGwUVcqxTgssTiCR7zkzLjAhyFTXihMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GmUeDqRiqyFQcvTbGC+coMj8CxGZAvxnQJCXNyGsRAh2/9RZN9iQJC6jihMnZPCtx
	 wJdP7j6kbof2dCwHOVI1q7tEfu4pQwjxrL9mxx1PMRIQGy4WQy9no+TZqt8wRnn4Rj
	 ChnfVoeB7d3roJXeLq8GVrRU1rdytqyTiqYQ5ypRiRV5hsdYlN/3rlVQ8jRLcuLDXG
	 RSMDPxtnaeGUjMOeIGY2BChfgsCjx1XAl82QfobI2T2+XUD/e6ekVIzvafsY6ngpA9
	 +o0/yuN04ouux4/5H71nw5Us7I9FxnZIEWBSh5mNZTntn+RkZZiCU4eYnQrIU8Az6s
	 NYnXul8JBksnw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDR-0000000ATWs-1t0Z;
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
	Eric Auger <eric.auger@redhat.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: vgic: LPI fixes for redistributors with LPIs disabled
Date: Tue,  3 Nov 2026 13:05:30 +0000
Message-ID: <179371111251.2844725.11327747024377032677.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026092802.2636798-1-fuad.tabba@linux.dev>
References: <20261026092802.2636798-1-fuad.tabba@linux.dev>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, fuad.tabba@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seiden@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, ndaugoing@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 26 Oct 2026 09:28:00 +0000, Fuad Tabba wrote:
> Two fixes on top of Marc's cross-CPU vcpu pausing series [1], for LPIs
> whose redistributor has LPIs disabled. Without them, the guest can take
> such an LPI with EnableLPIs clear, or lose one mapped before it enables
> them.
> 
> The first is the vgic_target_oracle() change Oliver suggested on v2 of
> that series [2]. It stops an LPI from being queued to a redistributor
> with EnableLPIs clear once the disable path has retired the vCPU's AP
> list. With that check, the path has to pause the vCPU before clearing
> EnableLPIs, so that the retire still finds its LPIs.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: vgic: Don't forward LPIs to a redistributor with LPIs disabled
      commit: bf9c9ed5204fe8155bfff96a737faaae6afe07d8
[2/2] KVM: arm64: vgic-v3: Don't drop a pending LPI mapped with LPIs disabled
      commit: b4c9f30194a421b069bcfef18ccbee004c97b9f2

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


