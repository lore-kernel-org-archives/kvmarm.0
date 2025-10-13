Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8ED1F419B;
	Mon, 13 Oct 2025 16:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374569; cv=none; b=YvNfiAv4Iis/NIG7D52hhDV5A/98ARdgFu7TmnHYwFyzadvvxeBmouwaHfyVs2usZKEuq5Bx+E1OiYL9I+8zcgkQKO6Ezn2gHS/AxnZoHgImfdOYSNio0hmP3AYZ4oQQiSSuDFoSiOw87R1UiqTgtvJFxeq5+qSiN1QKQ12ZwOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374569; c=relaxed/simple;
	bh=V/MAAI6c/W2kXvAAM5vLnSBH5PzenfxxUv7lXNVHDf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g5gNKTXcZTVEqvhu+eSP60dJQhP17iY+2Y+kdSUGIq08AHmfmdpwZu1W9queEoikFX+E1uSXP8ikLHvsYVZF2nXJ0+j76k7oU6RsRlPKTa13oJFcP5Mv5JluZmuFqAaEss1bAb4hIdlWFgmtmhVff1ypEx3w+0DTO15uPDMcsyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jF4RAZSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jF4RAZSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06314C116B1;
	Mon, 13 Oct 2025 16:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760374569;
	bh=V/MAAI6c/W2kXvAAM5vLnSBH5PzenfxxUv7lXNVHDf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jF4RAZSKXO3/wzVMsevgsaewpkLC0B2J8nl5Yc1Io10RtKWu2D4oSTPU+MWqYoBYF
	 /vMzHsLzzH8x6Z6/XET5+J546Nm6m8OoABIkWNWYuyNJWWVxU9MFNDTlDuCvRfdQPF
	 0IAUIcxuJuw0ZCRze57yrwXpuM0O4rChgaDoMsAp97Np/ajxwBeurSvVflzw49CXNI
	 nd9NZeEN+XMcJRSDo1Fvu0ilsrYRjsj6hXxkqUTheVWsjPkQvjuTYdOF0GCdm2A6OE
	 mNYWvFD34hHOxbg3rUCGQdeiikHZk5hT5giw54WGJbuJoVYMtVvGEJZTfR9r1Gmdoi
	 Ya4LNurAJzzzw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8LqA-0000000DaUU-2pWO;
	Mon, 13 Oct 2025 16:56:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Guard PMSCR_EL1 initialization with SPE presence check
Date: Mon, 13 Oct 2025 17:56:03 +0100
Message-ID: <176037441177.969330.7925084033862079350.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251010174707.1684200-1-mukesh.ojha@oss.qualcomm.com>
References: <20251010174707.1684200-1-mukesh.ojha@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, catalin.marinas@arm.com, will@kernel.org, alexandru.elisei@arm.com, mukesh.ojha@oss.qualcomm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 10 Oct 2025 23:17:07 +0530, Mukesh Ojha wrote:
> Commit efad60e46057 ("KVM: arm64: Initialize PMSCR_EL1 when in VHE")
> does not perform sufficient check before initializing PMSCR_EL1 to 0
> when running in VHE mode. On some platforms, this causes the system to
> hang during boot, as EL3 has not delegated access to the Profiling
> Buffer to the Non-secure world, nor does it reinject an UNDEF on sysreg
> trap.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Guard PMSCR_EL1 initialization with SPE presence check
      commit: c35dd838666d47de2848639234ec32e3ba22b49f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


