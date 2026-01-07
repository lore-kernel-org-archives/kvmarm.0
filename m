Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512302E62C4
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 18:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809228; cv=none; b=MNDVBV+euJyZs69dnDsRd8uekoAFikrDN0j2Wahnezod6NMZ4SEPF8+iUFufYUKNayA7q594wAcOiYGFoJWrpA+gWehxDWCdNXL5+gpm3y9r560u4dXwQyBzaAVSZd7OrUGGka75d1u9N8gTdnpS49q8JktmP2gdYUJbDrG7iiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809228; c=relaxed/simple;
	bh=ZeslsZxILV34i/sGoYHyxlv20RmBgrVCfD69wbKG7so=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GHXaZESC7scYswvSITlAOqPg7LxaNJkWCWvV/jhLht8g9cGHsXInYf19VWrqwMYmgtFvUpLUcE8rJOOQ4Q/6cr3TifzTLac7chFkUTjWB0o0eQCFw/Wc58p/lPo1yCOMJeFaW7jae1iwZGkoZp7gPRP2vFdSyc/SnKQ5pUVuyBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNyYwV02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNyYwV02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0DAC4CEF1;
	Wed,  7 Jan 2026 18:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767809227;
	bh=ZeslsZxILV34i/sGoYHyxlv20RmBgrVCfD69wbKG7so=;
	h=From:To:Cc:Subject:Date:From;
	b=CNyYwV02q8flOo8pgKj2VaOx5p+stTtiP93dfeaSrn5QRuIZ6Oq2PlmQmMVhkgZLE
	 hpGB8YXcrnCHEsoiZjzteuz/lTB0OTdALB0otn9Y8dcU4XEE+i1oTsvljUH4miglur
	 7QSaIpNJCOh4C5l4YeFt/Mz8aZLBvcbJS/rxtspBRvZUgMmS9IqJaVZ7Q8xMDAuLE0
	 18kzvdIxnpS+2HyHyTH+J++PRFDoPsA5e3wjMUzgvZbRy2QOf1ZNMACvB1/zam3PNh
	 yugNhWIpVTgiEp9JNhuiSavKFvye4m35KwznLTcTRZmQxb8r4H9BLx1NfByxaIO4DY
	 lH/mFtquFL9cg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdXw1-00000000A9B-1sfk;
	Wed, 07 Jan 2026 18:07:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/3] arm64: Unconditionally compile LSE/PAN/EPAN support
Date: Wed,  7 Jan 2026 18:06:58 +0000
Message-ID: <20260107180701.2858276-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_LSE and FEAT_PAN have been around for a *very* long time (ARMv8.1
was published 11 years ago), and it is about time we enable these by
default. The additional text is very small, the advantages pretty
large in terms of performance (LSE) and security (PAN), and it is very
hard to find a semi-modern machine that doesn't have these (even the
RPi5 is ARMv8.2...).

On top of that, FEAT_PAN3 (aka EPAN) is a very nice to have, and
naturally complement PAN for exec-only mappings.

Drop the configuration symbols for these three extensions, and let the
automatic detection of features to its job.

Only very lightly tested, but what could possibly go wrong? ;-)

Marc Zyngier (3):
  arm64: Unconditionally enable LSE support
  arm64: Unconditionally enable PAN support
  arm64: Unconditionally enable EPAN support

 arch/arm64/Kconfig                  | 46 -----------------------------
 arch/arm64/configs/hardening.config |  3 --
 arch/arm64/include/asm/cpucaps.h    |  4 ---
 arch/arm64/include/asm/insn.h       | 23 ---------------
 arch/arm64/include/asm/lse.h        |  9 ------
 arch/arm64/include/asm/uaccess.h    |  6 ++--
 arch/arm64/kernel/cpufeature.c      |  8 -----
 arch/arm64/kvm/at.c                 |  7 -----
 arch/arm64/kvm/hyp/entry.S          |  2 +-
 arch/arm64/lib/insn.c               |  2 --
 arch/arm64/net/bpf_jit_comp.c       |  7 -----
 11 files changed, 3 insertions(+), 114 deletions(-)

-- 
2.47.3

