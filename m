Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401B123BD1D
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452635; cv=none; b=uldVRX8aKW1nqB7yD76imSNI57t9i5jkfV4jLMf+JiVogID3to8loSGbs6upQzrN9sQPSaS119DyjpSvUU7SA8NxBoRPMLHTAhtSkWPb3JLSS8dKw+OP4Kkf4DCTtb0OI7SeBdFaMvaj8ZdxTdZSgMZGDNf5rPZzLDXD19ihs5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452635; c=relaxed/simple;
	bh=c49Vj6dYxBjCUX5m63Z1mVVfVLMWdQ22PCQzSa8wfQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KJyIjlwxXzYHI4CbtKiGBfa/+OpIgiPwRC/vffcgWJv70nK3Vt2+nl4VnpGWNRlG2jWdVP5cM7tSYbamhU9Ub6cd40/o+mwg2aHfHhPW2CsVZiqcmYJ2nEfl2RpkwrADqyx+gtj1p22JToXYYQaMpxl5v+9xGANEbCDSDsXo+/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UVmCX3Io; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UVmCX3Io"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7764C19423;
	Mon,  2 Mar 2026 11:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772452634;
	bh=c49Vj6dYxBjCUX5m63Z1mVVfVLMWdQ22PCQzSa8wfQ8=;
	h=From:To:Cc:Subject:Date:From;
	b=UVmCX3IoDgCmqpqpmjBui/OrryISQMxnOSAkik4i17ixpSSw2tiNjZ1t/gsIRzcCb
	 84gB8YdIaCncB9PIEo23HzIKTvZiPKuSqGlZRpjvSmWVrQC6edK6rNp1mUknBpcf2o
	 8kcovZ+SSoYDGq6EksYR4DOc22uQMWubcoKpFTOAqcHpOkQyDp0hBSGtr8bNbDApKM
	 Aqjn6BtI7I9NFiTAniRhnaaYqBVKYZ0NktGpjF5Oj7sQ+/K+rPauDr9PDFEaR4Nrpu
	 3URiicXMHyeWxv9rR6XQuq8PFOnsNlvpsms8DOzfNH/MordQ5MxNduJ3qpwfT3bowo
	 Bp6hVzQUfoa1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx1tg-0000000FDFJ-3ap5;
	Mon, 02 Mar 2026 11:57:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 00/11] arm64: Fully disable configured-out features
Date: Mon,  2 Mar 2026 11:56:41 +0000
Message-ID: <20260302115653.1517326-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is v2 of this series attempting at making the handling of
features that are disabled at compile time a bit less awkward for
non-userspace consumers of the sanitised feature bits.

A few things have changed, thanks to Fuad and Suzuki spending time on
reviewing this, but the overall behaviour is the same.

* From v1 [1]:

  - Mark ALL_HIDDEN and HIGHER_SAFE as incompatible

  - Don't update a feature that is ALL_HIDDEN (or overridden) on the
    secondary boot path

  - Reduce the size of struct arm64_ftr_bits

  - Add a helper for setting a field to its safe value

[1] https://lore.kernel.org/r/20260219195533.2455736-1-maz@kernel.org

Marc Zyngier (11):
  arm64: Skip update of an idreg field affected by an override
  arm64: Add a helper setting a feature field to its safe value
  arm64: Add logic to fully remove features from sanitised id registers
  arm64: Convert CONFIG_ARM64_PTR_AUTH to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_SVE to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_SME to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_GCS to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_MTE to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_POE to FTR_CONFIG()
  arm64: Convert CONFIG_ARM64_BTI to FTR_CONFIG()
  arm64: Remove FTR_VISIBLE_IF_IS_ENABLED()

 arch/arm64/include/asm/cpufeature.h |  15 +--
 arch/arm64/kernel/cpufeature.c      | 141 +++++++++++++++++-----------
 2 files changed, 94 insertions(+), 62 deletions(-)

-- 
2.47.3

