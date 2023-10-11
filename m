Received: from out-198.mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761DB12E5B
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 19:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XSVr3Ias"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697054278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NBdFJkgYJSOzXayzM8jpEgticEipqKrh87vuZZUVqWI=;
	b=XSVr3Iasililq6Jjf897ZcVr2TR3WCtF3BasDbHQAplqCTJ1uripBA2LHchI2JFxJT+oMa
	OSAkltHILlIHKi5+ll7X6VeJXzcQCgn6N1v+j61rkzdduSBRK6AooSaccrblDz25LKq/uU
	Zby2ksf7qO6a7XAzQgLmdkwVmyUnQpE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	Mark Brown <broonie@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 0/5] KVM: selftests: Add ID reg test, update headers
Date: Wed, 11 Oct 2023 19:57:35 +0000
Message-ID: <20231011195740.3349631-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v2: https://lore.kernel.org/kvmarm/20231010011023.2497088-1-oliver.upton@linux.dev/

v2 -> v3:
 - Use the kernel's script/data for generating the header instad of a
   copy (broonie)

Jing Zhang (2):
  tools headers arm64: Update sysreg.h with kernel sources
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (3):
  tools: arm64: Add a Makefile for generating sysreg-defs.h
  perf build: Generate arm64's sysreg-defs.h and add to include path
  KVM: selftests: Generate sysreg-defs.h and add to include path

 tools/arch/arm64/include/.gitignore           |   1 +
 tools/arch/arm64/include/asm/gpr-num.h        |  26 +
 tools/arch/arm64/include/asm/sysreg.h         | 839 ++++--------------
 tools/arch/arm64/tools/Makefile               |  38 +
 tools/perf/Makefile.perf                      |  15 +-
 tools/perf/util/Build                         |   2 +-
 tools/testing/selftests/kvm/Makefile          |  24 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |   4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |  12 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |   6 +-
 .../selftests/kvm/aarch64/set_id_regs.c       | 479 ++++++++++
 .../selftests/kvm/lib/aarch64/processor.c     |   6 +-
 12 files changed, 785 insertions(+), 667 deletions(-)
 create mode 100644 tools/arch/arm64/include/.gitignore
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h
 create mode 100644 tools/arch/arm64/tools/Makefile
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: dafa493dd01d5992f1cb70b08d1741c3ab99e04a
-- 
2.42.0.609.gbb76f46606-goog

