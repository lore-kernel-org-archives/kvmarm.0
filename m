Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A900C1D90DF
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751641990; cv=none; b=cfaydxuMRrNv0NxBC+bgmq9hLyRtYcndEsmSIkFCU/64Le/rWmVFAs+FG+Q0rwtfr+kn/YInHJMDJgyF8i8vKQvZh8m+BfMlCFmav8HKps9dnVPoLkieKkFmPzGWpno3A5C5n0slusX4RKW9jeG0if1t8CPWebtEFEDAm2p1jAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751641990; c=relaxed/simple;
	bh=C3R6ndvVfqHw2+mN8wRj6Mg2GLCHpzq/7hp+tGlpp18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=inXaAQ8KQgeMbir8i47VnEFLbPbNaczolNnTJtyVwL6sQgN7ubjGID0meM4EoaQ+tX3t0HYvRCx0HROuSKudjF4F0tzhA7sesG+1i93TTsZA7FhC/fJIWHwWRWX/OKyKk97KHEUlNIist8m4CTocK1m12CQBFasQL6RYErE4VRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cPVq4pas; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cPVq4pas"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751641976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=muPd8ALb5wcmT6P5lEUElOFpEadSmXSUQz2XkdW4i10=;
	b=cPVq4pasQ4CgcqfXj7bto9SHoNcU2IB5CFsvqnCCfvBph9UqAHPr+IwSpBKHDBU7HYE/6C
	5DFpU9IgZspaKhaRXVePObGfr2yLvFnV5eRlJgHqWZS8ld/lGN488jkUMdgLuf28MG5ZRU
	xBFnh3r8Ez8MFJv4EBrw5DUs/bZ/Cck=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	cleger@rivosinc.com,
	jesse@rivosinc.com,
	jamestiotio@gmail.com,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH 0/2] riscv: Add kvmtool support
Date: Fri,  4 Jul 2025 17:12:55 +0200
Message-ID: <20250704151254.100351-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The first patch is for arm's scripts. It adds a check that I found
useful on the riscv side. The second patch enables riscv to use
kvmtool too.

Andrew Jones (2):
  arm/arm64: Ensure proper host arch with kvmtool
  riscv: Add kvmtool support

 README.md     |   7 ++--
 arm/run       |   5 +++
 configure     |  12 ++++--
 riscv/efi/run |   6 +++
 riscv/run     | 110 +++++++++++++++++++++++++++++++++++---------------
 5 files changed, 101 insertions(+), 39 deletions(-)

-- 
2.49.0

