Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333FB3C3782;
	Wed, 15 Jul 2026 07:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784102280; cv=none; b=imDOL41G0P+gfb+E/yTOzwMZ9h7fW4MzOVAn2p619HitgMjkHboKnAud5XYZ92xFzGSbBukbBFga+PHa4cIw2NBUl6pGVW3yAckl3yEz1CJ7rjnKkX61XgW5KxO8N55KXd2jMo4EBYZdQFz51WEVOOGq0efs3npn4jIYzgvgy8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784102280; c=relaxed/simple;
	bh=d1ZQqI7pkvSGmMeyEkeZGYlautT+Ugm9TT7zYritOL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SouyY7KMRhfzWsf8rZaaX2FZMdPosQaVYI9fItADE38aNC3GmQCsGGi+xrRJpq0vlBm/9bQClMnWgYFDeUSVduKwvD5R+lYdra4/veVWWc9RkRlynVctp7MDsd65+YdZCa5KXS4CjaWvBOzOcBkYZFBJKojuou+g8P0uZieYGPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTutL9Nd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTutL9Nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C099A1F00A3F;
	Wed, 15 Jul 2026 07:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784102278;
	bh=k+3ToxkDkXKSTYa3CW80v6cGbf1lnA9p9fs5IAEEyPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTutL9NdcqRpRYT54c12udtzTJi3wGe5m4SOk8p5hKYZ+njZxCfKpYXpQogx46YMU
	 YDCEWW27ssqY6Xp8oW5rc763DtqXXg2ad5YkwPx4l6Irl6thyCrGezaqfUiKpYV5Ul
	 VwY7S1/N9PPiVG2IH59estqB1Ps9fq4obKlm/nIRRGOAWpNtV3rfPFVV+ssy6Lg84H
	 PFtrD3SnfBXnvMx9ELNfRagL83EcByE5xgSIBKG4vykWbjjd1unuBfiPP4wVnm2dcY
	 yv7Fn42DMtfzhujvqJ8EGCH0A/AtALR1A72nIdQVOPHUjoVna8+qpp++Vp0UyRXy+N
	 hEag4wR/VOnZg==
From: Oliver Upton <oupton@kernel.org>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mostafa Saleh <smostafa@google.com>
Cc: Oliver Upton <oupton@kernel.org>,
	maz@kernel.org,
	seiden@linux.ibm.com,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	vdonnefort@google.com,
	tabba@google.com,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2] KVM: arm64: Avoid naming collision in tracing
Date: Wed, 15 Jul 2026 00:57:55 -0700
Message-ID: <178410226171.1693421.5370206670309948931.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260713141320.4065600-1-smostafa@google.com>
References: <20260713141320.4065600-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 13 Jul 2026 14:13:20 +0000, Mostafa Saleh wrote:
> When the hypervisor tracing (CONFIG_NVHE_EL2_TRACING) is disabled, it
> defines a static inline stub for trace_clock().
> 
> However, trace_clock() is already declared as an extern function in
> linux/trace_clock.h which is pulled in EL2 compilation.
> 
> If the file <nvhe/clock.h> is included when CONFIG_NVHE_EL2_TRACING
> is disabled (by including it manually in setup.c) it will cause:
> In file included from arch/arm64/kvm/hyp/nvhe/setup.c:22:
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Avoid naming collision in tracing
      https://git.kernel.org/kvmarm/kvmarm/c/007e0f0fd9b7

--
Best,
Oliver
