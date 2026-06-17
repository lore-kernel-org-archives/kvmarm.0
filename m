Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633963ACF1F;
	Wed, 17 Jun 2026 12:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781700083; cv=none; b=ue0S700NLhBxmUycCczLLltyF1FYExC65UJzenGMfYXQW/B/t5acOP8QAZcYzWdePqDp+8Mzu+Wv71xtBl469BGeBXGcP1OdN4AGsDDti/+bgGmWhUCLbXnbtE8QBppExl3bQSoAeBIIJEfE05FgNTFK7pdCYR64JLELXiHcd9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781700083; c=relaxed/simple;
	bh=8rlTMnRIsQrEMU9tPMeSADAwXn5em6v1J4AAIfmNCMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qF7Zra4+kkbLDZsriKmW7ca2oYvSwZVisnc6kWueLJGfuCcgDV2EEW6qUwXoPp2aXn6cuJAPS/Az3jYjKAAATJOi1TZyZQ3Zu7b0ASPKz+Xt9WQ/nnaQXT5ufjU+XMWtdg78xoUoPrMhveJ2P5LPDKiVpP9Kw9IOLLRSvkUN/0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8rdqYQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8rdqYQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70BA1F000E9;
	Wed, 17 Jun 2026 12:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781700082;
	bh=gI37bWtHllnRBBGUGfmHhE8TRqLaBhOaYW5Wb4FZGRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8rdqYQDS88hkg06mnXbShq1Rfj1pe5laKALF1IEXFrMRrAoohE6tfs0dNaF1MSQH
	 Pi4/uOnztAEsakVFzU+SABfHKM72558O7ZdlWYXgNTBSAgR8gSCXRs5W34ejOnAKtS
	 xJIqfh6RuORXLPMCVPSFHToRRCya/t9Y2QjDFFzlP5oiPkfFyw8TSQxc429iHo0nap
	 GTCPlZsKZ30mvereXHWM71MXVt7lzP0d554DLGacHgWcBhkbEi4jl1FvjOxCPuvdl3
	 B5St1R136wB36X7TJ2wpNU0pprZxjinz70Z6N4WiHcwJKsOzaurTB8SzhQMuOCYzEO
	 g6PaJ+ADARYfQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wZpa4-0000000DgLp-09VF;
	Wed, 17 Jun 2026 12:41:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Sync SPSR_EL1 when injecting an exception into a pVM
Date: Wed, 17 Jun 2026 13:41:17 +0100
Message-ID: <178170006643.3087598.16279897743346268565.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260612113414.1022901-1-tabba@google.com>
References: <20260612113414.1022901-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, tabba@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, Sascha.Bischoff@arm.com, drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 12 Jun 2026 12:34:14 +0100, Fuad Tabba wrote:
> When pKVM injects a synchronous exception into a protected guest, it
> re-enters without restoring the guest's EL1 sysregs and writes the EL1
> exception registers to hardware by hand: ESR_EL1 and ELR_EL1, but not
> SPSR_EL1. enter_exception64() sets SPSR_EL1 (the interrupted PSTATE)
> only in memory, so the guest's handler reads a stale SPSR_EL1 and
> restores the wrong PSTATE on eret.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Sync SPSR_EL1 when injecting an exception into a pVM
      commit: ec40342aaca8162bc8ab2607076535ebab1838b8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


