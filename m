Received: from mta1.migadu.com (out-66.mta1.migadu.com [95.215.58.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F5923EA8B
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 13:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896579; cv=none; b=MZwa5HJ6y//12ExpWXL0D2/My9TrSI2N1yhSp1whBSLjF7TcMKajE7KzfJtQR8woOLYoC/4iubqva0ah6u1Y8jfEZG2iOPJV9qFZJeUK0CBF92/1695odWGwzf0TtGuqT2hSAZMU8uzjlEESqug38jjqBqYe0GIObkq/Eugcxj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896579; c=relaxed/simple;
	bh=ZrqN4SwiMfEFjFMJxxaia+E+p360c/BMd14mXe0AmBE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u1l7r4xZvSi1IIGxWoXjiY/z8vlJJw16TUuY/umuGpDRLXNSMyels2B/rSVsnEfkIGhcPOHzVfAwYGXQ0UXeBv1j0Drdi5s820VhvHDi9m9jwqAjvLgciiuz2LMd0p0AQQo9cUYGMUqTduqVPxplr/vDZtBs7RjtkZZdfV0DjXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UvoO1oKv; arc=none smtp.client-ip=95.215.58.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UvoO1oKv"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ZrqN4SwiMfEFjFMJxxaia+E+p360c/BMd14mXe0AmBE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791896574; v=1; x=1792501374;
 b=UvoO1oKvm6CIs2UP34wYbPATNuM6vw+boI/0tuolMfoYR2G6PTWd4dYTgAIUgaRu0RCtx+gS
 Egx9v9DAUxGKKu5AFUw4DU0Ms8HirR3asnLEQ7amTJyNTTYTXqR6z0ASx66fAD5sPppRRmEZx0b
 RogMUI7aWPUcGM7lcCfHuIvg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5eb0838c8443a40b;
	Tue, 13 Oct 2026 13:02:54 +0000
X-Mizu-Trace-ID: 5eb0838c8443a40b
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Brown <broonie@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] arm64: sysreg: Bring field definitions in line with the spec
Date: Tue, 13 Oct 2026 14:02:43 +0100
Message-Id: <20261013130247.4135515-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Fixes to definitions in the sysreg file that don't match the current
spec: three wrong enum values, two misspelt field names, and fields the
architecture has dropped, including leftovers from FEAT_TME. The last
patch also removes the BRBE driver's check on two more such
fields (BRBINFx_EL1.T and LASTFAILED), the only functional change in
the series.

These came out of the pKVM feature-bit audit, which led me to check the
whole file against ARM's register descriptions.

I plan to look at turning that check into a linter under
arch/arm64/tools, along the lines Will suggested [1], so the next
batch doesn't depend on someone reading the spec.

Based on Linux 7.3-rc6 (a90ee4305c4a5).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20241211224015.GB17836@willie-the-truck/

Fuad Tabba (4):
  arm64: sysreg: Fix three incorrect enum values
  arm64: sysreg: Fix the names of two misspelt fields
  arm64: sysreg: Mark fields the architecture dropped as RES0
  perf: arm_brbe: Remove the check for TME transaction states

 arch/arm64/kvm/config.c         |  4 ++--
 arch/arm64/kvm/emulate-nested.c |  2 +-
 arch/arm64/tools/sysreg         | 28 ++++++++++------------------
 drivers/perf/arm_brbe.c         | 18 ------------------
 4 files changed, 13 insertions(+), 39 deletions(-)


base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a
-- 
2.39.5

