Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092224;
	b=fGv+W6lGkBpIr2nB3kFGNBgHQ1K7xwoEALA/oLoxih7rBce0HTpkdyCXR8oaootbnVRd
	 CQCkct8n8jJPX1RXrtzkwFtKkeMUt4iz7fi0oi++vgS4N8MjI/e0LwCj9n5VSGuOMIZxd
	 OeMBtLTUAxf1hSVv9ZWAHgf1tkFtjROt4vOq8aW5xlJ+9Mf1hm8Hxm8HK8XYxEGrnMSfs
	 jRaHYBxKAYfLFcv66IL0QtlSJgyYXFB8gnROVTmiIgXBvSkN3q8aTicBDx662Ktzm4JRR
	 AnUikQ/XpA8bibR/gzyLSKvYSWcJJZNgFgoLKos3CvgrO/EyvidOEU/fUpZVErI8RaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092224;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=hRnWmfScATD3nQzk0VPVzsF6FXjE11MnTpihYFOM0gM=;
	b=yH4amLBgQ+S8zLM7GPzmZLStvJeTE0+/vYrVJSYVVt9ekgVsKBStfa9o9HT1BOSc9OIc
	 OK2SYKiyH44wPI3KgRLlu3tkGYHS162hjAcaGea63lyuAoP1FiyfCjg2FtB46ZRTJ/0Dy
	 cOevOr/KrpRZUTs3Bx7alL23SEM0ulA+axqP/KPH05NToOKwAAA1kaAEqJ4wBNkqZSooP
	 ovLFcs5KDOBVdOh/Ncc5qdxe40KBeKCBQ/Vnptrc5gVzWFW1llcnQKAZHNYlJX9wVMcQr
	 nZoSvhNRs7GydSNj8wUdqgL5w8P7j+GZwPfTG1AmI0lAfFHlokdvsQQXKcr7YOMoENQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d6wxq2l7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC59606A325
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 12:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d6wxq2l7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601CC1F000C7;
	Thu, 19 Nov 2026 12:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795092224;
	bh=hRnWmfScATD3nQzk0VPVzsF6FXjE11MnTpihYFOM0gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6wxq2l7FpYBN5F2T9OycOQ4WR5trl8sjs7e4cEqtUCJdpz854coxXt0IZBSzXfBO
	 e3dEnXtq1b3e/PCFzsr4XlkWhct/3Km6q65L8w7BQb35cnrM6SCglfIgVEs0Qsw4DK
	 VGpaD/c0ygUGVf5eg3Xj4XlyUoCkZU1X4v+YobJJ4VdEBc3H3ZDRksE46ZG72RUgK/
	 UNl0tBboWi7SPIkgI+Gj+MyuLAz+33l2h17lg2NgLO95vyom6mOxXqInowuSleOmB2
	 tPS0gYns9cs4qgSXJXLpFwUP1572CmLQ0Si3KdAxHz/C5OUB7S8NQyBRM1H8nxjWgw
	 2GRhYjvt/kLlw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xU1UM-00000000RvW-1rl4;
	Thu, 19 Nov 2026 12:43:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: Dan Carpenter <dan@pereq.eu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?UTF-8?q?Cl=C3=A9ment=20Blaudeau?= <clement@cryspen.com>
Subject: Re: [PATCH 0/3] KVM: arm64: nv: trap forwarding bugs
Date: Thu, 19 Nov 2026 12:43:31 +0000
Message-ID: <179509215918.3938200.11293350722517708122.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795014776.git.dan@pereq.eu>
References: <cover.1795014776.git.dan@pereq.eu>
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
X-SA-Exim-Rcpt-To: dan@pereq.eu, catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, oupton@kernel.org, seiden@linux.ibm.com, suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com, karthik@pereq.eu, clement@cryspen.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 18 Nov 2026 18:29:39 +0300, Dan Carpenter wrote:
> This was detected as part of our Formal Analysis work at Pereq.
> 
> Regular KVM and nested virt traps have been getting out of sync.  Fix a
> couple bugs and add a boot time check to prevent future bugs.
> 
> Dan Carpenter (3):
>   KVM: arm64: nv: Forward PIR_EL2, PIRE0_EL2 and POR_EL2 traps
>   KVM: arm64: nv: Forward CNTP_TVAL_EL02 and CNTV_TVAL_EL02 traps
>   KVM: arm64: nv: Report EL2 registers with no trap forwarding
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: nv: Forward PIR_EL2, PIRE0_EL2 and POR_EL2 traps
      commit: 88fa0c91640ce163190531bf3e975c73c77d7c7b
[2/3] KVM: arm64: nv: Forward CNTP_TVAL_EL02 and CNTV_TVAL_EL02 traps
      commit: fb32e91ac511101f528fa2f33cb1904b3796f5c3
[3/3] KVM: arm64: nv: Report EL2 registers with no trap forwarding
      commit: 2fec206f37582b9295185a86e43a08ac74e149d2

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


