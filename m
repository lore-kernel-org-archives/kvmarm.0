Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662031EF378
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 22:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743547369; cv=none; b=pIf5xIptorIjhrlCk4ZLZ9bR4LENzg4Q39Ms4Jqkg3KRCtkEkAmDopOZlagVTSlbqKUZO6Z6hr0+Aga4rD7NvWSXplwY+dmmez4lNycJEELa6/KSZh23Ayol3ELSFHoNWhngdCvHU8HV1D4CEX1t3fgbR8jWj/2FGbmk3eTRIp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743547369; c=relaxed/simple;
	bh=dkb4QMKXv9MFMRounFnYMH7scjqFGzOZLHZ3yBBbMgM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AyUMYmbIvKPv1k0Vl75a8srwJV1fvG4sRIPFMvP5UTfC6nKVLYlZaivAvvR60UbfHaDyYGV/EoBBNFAsYuJxHATeVem8f5AzTcW/jC25JREoQBcCtpxaAhv/EQC31k+QPz1MuaPYnlvzlu8Oh+sdQZfNsNRDsb/F6LOig28lhco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PRzzPgEC; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PRzzPgEC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743547364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=avbj0MhoHrdYUi25n2jo2ySDVXM1cSDhy11R+jdiPho=;
	b=PRzzPgECcQApcatnysovnR4Jx7tB89KcNX8grczBejY4vR/HseRXKIpSkZDp2fCh/fNU+d
	f+/2IjMr19kWJoWCIiQJZrVINiYCFxuspQv4gskkzd0hIJI0NY4YuP4hsxjkMET5vm/Aie
	eWAqPiIw9L4KfKwiExto2QEXXjMjJXk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: Fixes for resolving the fault IPA
Date: Tue,  1 Apr 2025 15:42:31 -0700
Message-Id: <20250401224234.2906739-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM's heuristics for determining the fault IPA are a bit shaky and don't
necessarily align with the letter of the architecture. On top of that,
HPFAR_EL2 is UNKNOWN if an SEA occurred during a table walk. Re-walking
the page tables will replay the SEA at EL2, becoming a panic in the hyp.

Oliver Upton (3):
  KVM: arm64: Only read HPFAR_EL2 when value is architecturally valid
  arm64: Convert HPFAR_EL2 to sysreg table
  KVM: arm64: Don't translate FAR if invalid/unsafe

 arch/arm64/include/asm/esr.h           | 23 +++++++++
 arch/arm64/include/asm/kvm_emulate.h   |  7 ++-
 arch/arm64/include/asm/kvm_ras.h       |  2 +-
 arch/arm64/kvm/hyp/include/hyp/fault.h | 70 ++++++++++++++++++--------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c  |  2 +-
 arch/arm64/kvm/mmu.c                   | 31 +++++++-----
 arch/arm64/tools/sysreg                |  7 +++
 7 files changed, 105 insertions(+), 37 deletions(-)


base-commit: 369c0122682c4468a69f2454614eded71c5348f3
-- 
2.39.5

