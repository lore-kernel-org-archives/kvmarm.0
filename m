Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5AA27F72C
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 14:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785076615; cv=none; b=PlAcPSvXGwxlYOrI4FNYBoopm3wy0HB2+x2FLp+HtBN+YY6rnRr7NuNnhqTe8npVpaEMs0NFDhbP+whk9GZmyFDSYKHAcJ8Lv+xJLtkbI4kz6KxkGkWVlzzaNowcBGOckHHniRt9Ovcrs9JztZCIKzsw1H7RX9x65wqlWEr2PNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785076615; c=relaxed/simple;
	bh=Q8rNjTvfzolZ5EMNozn3JqopQwiWcQVu+PIRMvpYn18=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MhdR+g0ns1jkyDMdSwkM0enVBD385edKOM7pTcBHKq0pH+8O6nQU/FNaNj+qEcT1WThenNczbloPZOxq+4qjHrl9hbxGWGA/RGIs9YxbYmKAy03lBYb31NFpVR18V3QGODKuL4FrftGoErdO/LDvDfZdcdbGf15nrHThk0S6ap4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CzwtEhdf; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CzwtEhdf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785076609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YUbh/jeX6MQJU0OuMCBPWaUgK9Wq5JZDryZHeFVQHR8=;
	b=CzwtEhdfxc/GE4a9FO6weiX1hwjqbESUyXiFvDp97OJf0TeRNIr1qbJS3TiqOZeQg7uihK
	XX6tWOP5ZQCLqZHOUIp2lFNA0SR1bXC2bp8IJI04qukvR3ICxbMq2+bojKu0D/qa7EoHuL
	eClDKyQSS0XyN5jTRVkccsBd8oDfp9M=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	tabba@google.com
Subject: [PATCH 0/2] KVM: arm64: Fix host-directed debug for non-protected pKVM guests
Date: Sun, 26 Jul 2026 15:36:41 +0100
Message-Id: <20260726143643.303456-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Under pKVM, host-directed hardware debug of a non-protected guest
(KVM_GUESTDBG_USE_HW) and userspace single-step never fire.

When the host owns the debug registers, the world switch loads
MDSCR_EL1 from external_mdscr_el1, where the host's MDE/KDE/SS bits
live. flush_debug_state() copies the guest's debug_owner and the
owner-selected debug register state to the hyp vCPU, but not
external_mdscr_el1, so the field reaches hardware as zero and the debug
exceptions stay disabled. Patch 1 propagates it.

Patch 2 adds a debug-exceptions selftest for a userspace watchpoint,
which the suite did not cover: it checks that the watchpoint fires and
reports the accessed address in debug.arch.far. It fails without patch
1 and passes with it. The existing single-step test passes even when
stepping never fires, so it does not catch this.

Found while adding self-hosted debug support for protected VMs.

Based on Linux 7.2-rc4 (1590cf0329716).

Cheers,
/fuad

Fuad Tabba (2):
  KVM: arm64: Flush external_mdscr_el1 to the pKVM hyp vCPU
  KVM: arm64: selftests: Add a userspace watchpoint test

 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 10 ++++-
 .../selftests/kvm/arm64/debug-exceptions.c    | 41 +++++++++++++++++++
 2 files changed, 49 insertions(+), 2 deletions(-)


base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
2.39.5

