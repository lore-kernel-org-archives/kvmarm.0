Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58891E3DD0
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 20:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743625063; cv=none; b=dWzEC8Jjph1wD8ca1vK6WTTlHigrVgfe+HllU6ylqA0hWTXR+zq2SDk6agHVDMjbppGOh0cvxJdvZwSF3PQEIhsC0SjdczhbEXStcp13BCWmImdWc/fEf9iD5A/Yu5mzvrLHH4eEV07TnXre/0kpmGSdUZZ3+LTq/xAfjGuVtbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743625063; c=relaxed/simple;
	bh=6yCRGVfy1sWyXQ2/RtCBznaKho2aSVgkYck/ooVA/rg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sGbkH9Myf3KPhBRG6U/I5cu5rN8+nCwsvkuAKDrNFUElz0QJYEdy+P9MfkCAyWZpP8L93YbPbQbQn/nj7TYCUO2F9WWrdcrAew7yZh7lhp9vHiOu503wYEvZnT/1f4mU1RCCYrtaEx+TwPmrBFa/mLsFNp+a6Ec+h1MbfIObMjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jGYnFUMZ; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jGYnFUMZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743625058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Qr68chHpPKfgPAq3vLTJ0bBNN8MEh7W2FbbYjV5kfnw=;
	b=jGYnFUMZrXzKd7z9w7VHyqDLKVjHut7NEIGJt48+oz6NU8UHVypCy2N9JzKv4wM9bkBfoR
	DTm6SHHqyo6hjFajUTkaLI6//Z8CyGh8OqKwXBboWgT0OtwkksOPYrXs03y0e6eKRRYXPj
	qCZUNkNTj9oESRvu23fi63gGRHeFOXU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/3] KVM: arm64: Fixes for resolving the fault IPA
Date: Wed,  2 Apr 2025 13:17:22 -0700
Message-Id: <20250402201725.2963645-1-oliver.upton@linux.dev>
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

v1: https://lore.kernel.org/kvmarm/20250401224234.2906739-1-oliver.upton@linux.dev/

v1 -> v2 (addressed Marc's feedback):
 - Drop section reference in favor of the rule for HPFAR_EL2 validity
 - Fold test for Address size fault into helper, reuse existing
   definitions
 - Get rid of 'magic' shift for transforming FIPA field to an actual IPA
 - Add BUG_ON() to handle_host_mem_abort() if we fail to resolve the
   fault IPA.

Oliver Upton (3):
  KVM: arm64: Only read HPFAR_EL2 when value is architecturally valid
  arm64: Convert HPFAR_EL2 to sysreg table
  KVM: arm64: Don't translate FAR if invalid/unsafe

 arch/arm64/include/asm/esr.h           | 44 +++++++++++++++-
 arch/arm64/include/asm/kvm_emulate.h   |  7 ++-
 arch/arm64/include/asm/kvm_ras.h       |  2 +-
 arch/arm64/kvm/hyp/include/hyp/fault.h | 70 ++++++++++++++++++--------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c  |  9 +++-
 arch/arm64/kvm/mmu.c                   | 31 +++++++-----
 arch/arm64/tools/sysreg                |  7 +++
 7 files changed, 131 insertions(+), 39 deletions(-)


base-commit: 369c0122682c4468a69f2454614eded71c5348f3
-- 
2.39.5

