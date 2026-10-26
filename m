Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016083;
	b=wq57bMwNzJ139XlrcghUTrUoWrQay2DOFABi+JEfAuZJvnS/VjBIsSqZtMV/GXEQ6e1F
	 2DHAaeu+GFucFkFy35Ojq2YMGfJwPB4UJwpEcx2P9qf/7/d/J9KaBx9XSj67Kx7JVP5Di
	 3vppo3yNG7S9XOgUbs4Q5QHmt5Xvw+UPf49TL2PR19zZx6IHMaEO+XwuG+6OV1KWbJ16M
	 ug9qb2/6s6SGdYDaNnlBuBYQkcJHNVZeHY9q45uyTROszgoCLOf7esmlk8l3fKUhFAZaT
	 jkRtSqpLVD0+5rSc1KrSF4IXbJcRzb2PpCdA7dIEwnVlB3FExsGoAgXIVDXpBTSoCfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016083;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=OSKQ5HiKHS7VyDFvKfOVWU7kBHEXK2Qv2Aln+gNIB+Q=;
	b=nTQYwkivfVNTZdQVf2i6w3f+eTeXH89b+huQ2jmxcNj2bhOEUCQ4yfjojm82IYIRfdc2
	 NKsebNFEK+n4aedMZwSSB9R/IZiGjJWmOLki1tVja/P7pqm79H5Up/t4MlbYpp3/puiF4
	 MhiOizOirYnhqX2kcBDYBMKCsRbQM9dILH0xGQBb4Rsrvx73j/ecQ1NXSULAwNluDPtM2
	 C96G+fqEgrsy6Ue699Wv84lV5iisfg3xSeT6ardu5EMY4FgJ83ANsIuSyfqaj27gYst2e
	 2NTuxUuJRX2P1hYuD+OFxxFFxZAMiFgz6w4d/BuwEXEgUEyXfLJuPjyAG/fnfAGW86w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f+4rBuIb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A395606A325;
	Mon, 26 Oct 2026 12:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f+4rBuIb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35691F031E0;
	Mon, 26 Oct 2026 12:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016077;
	bh=OSKQ5HiKHS7VyDFvKfOVWU7kBHEXK2Qv2Aln+gNIB+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+4rBuIbYdiek7nz9qLpx2TV0UJDpibSMTPc+lKhFwQetxbrU+ekIL7IWrnxAJhi8
	 s3jZVG2JXsE3vg4AIfv7Ia6dF4s6/7XpxN7x6S9Tw/CT17yHc8MV9z0yI8t9MudY1m
	 /V4j/0iIRsmTMmEOuRwlTstybh8UYMJTSvysBn4IXbxE0gGhTL8PIu1VEuLVAn7974
	 thK/XLj4Ci6AWmSIxOhPSvQWVBbdlDB+vqYQNlQrKpdUAoT8KhGscqn2mE2u/ioK+x
	 zqKR7U4dC2LfyS1Hbn1phXatqnD5ZE86II1Mo7UnALfB1y18LrPJmdsl6pX8jKfN0p
	 lNtCiqoAsCcoA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJO7-00000007Fr6-30mh;
	Mon, 26 Oct 2026 12:01:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH] KVM: arm64: Return on kvm_gmem_get_pfn() failure in gmem_abort()
Date: Mon, 26 Oct 2026 12:00:57 +0000
Message-ID: <179301587191.2527370.3684405184573124806.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022123054.31729-1-fuad.tabba@linux.dev>
References: <20261022123054.31729-1-fuad.tabba@linux.dev>
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
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seiden@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, vdonnefort@google.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 22 Oct 2026 13:30:54 +0100, Fuad Tabba wrote:
> The kvm-arm64/mmu-fixes-7.4 merge dropped the return from the
> kvm_gmem_get_pfn() error path in gmem_abort(). Both parents of the
> merge keep that return. On a failed kvm_gmem_get_pfn(), gmem_abort()
> then carries on with a zero pfn, and on a nested stage-2 it uses the
> mapping it has just freed.
> 
> Restore the return.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Return on kvm_gmem_get_pfn() failure in gmem_abort()
      commit: c4c362949dcaaaabaa5db34acaa6e91b9912094c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


