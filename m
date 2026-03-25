Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CEED175A95
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 00:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399062; cv=none; b=M0yhqhT4NKA7XYMTYfoejJYz81w7Ey5V4nnlw/mcJL36T+SFYpv8WHj7lUNlRr46vJ++5gFnSUUCEl5Cq0nv/0sXg8QKknWDeI3a8lgejZskpRAEs4maUPu1Gnib1BT4aVx706KY+Tg2yf62xetNWJ3k73IDC+Kctv8kv/96O7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399062; c=relaxed/simple;
	bh=Epyy7iecwoAn93JWXH+OSMxoxwAIEDRTjD5ZKKL3pZw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WZdkgJOZn/FrkNAj+x/SpgWHH93qDO1IVT92UN6eAUYTbDkpC/oEaC8L2rLletjHcb02G9bTh2CkdlSmTxuJP+ufWPjOesC+BO5F2ireQqeHh4rEmFYkL3xMinza1eYPgweT/7NGbkZaPxRDSbH80UF1JpEYqGqnsLcbliCCThI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MnR3rorX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MnR3rorX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F5C516F2;
	Tue, 24 Mar 2026 17:37:27 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 130513FB90;
	Tue, 24 Mar 2026 17:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774399053; bh=Epyy7iecwoAn93JWXH+OSMxoxwAIEDRTjD5ZKKL3pZw=;
	h=From:To:Cc:Subject:Date:From;
	b=MnR3rorXkjxXLLNMQEvTUR+UbtwJDSGr3bzysj4xgUSLtTg7nEdk0wr7TiTqIHXe7
	 nczxlFPNVf7GrasIcAdzyGlaMf5PpGc1+5Vf0yTZe8PgA9TiJKtM83zQFnX0o0ZWgF
	 9CE6bxws/dv2PFOPeAnZzEWz6vAdHbu2gY1KFPuc=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 0/3] KVM: arm64: selftests: Basic nested guest support
Date: Wed, 25 Mar 2026 00:36:17 +0000
Message-ID: <20260325003620.2214766-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series adds basic support for running nested guests (L2) in
kselftest. The first patch adds library functions. While designing the
APIs for userspace, I referenced Joey's approach for kvm-unit-tests [1].
In summary, four preparatory functions are provided for userspace to
set up state to run an L2 in EL1:

 - prepare_l2_stack()            <- sets up stack for L2
 - prepare_hyp_state()           <- sets up vEL2 registers
 - prepare_eret_destination()    <- userspace passes a function pointer
                                    for L2 to run
 - prepare_nested_sync_handler() <- sets up hvc handler in order to
                                    regain control after L2's hvc

After calling those functions, userspace can vcpu_run(), and when
run_l2() is called within the guest, the supplied function will be run
in L2, with the control flow managed by the library code in nested.c and
nested_asm.S. After running the L2 function, run_l2() will automatically
return. Note that the L2 function supplied by the user does not have to
call hvc.

Patch 2 demonstrates usage of the APIs introduced above, with a simple
L1 -> L2 -> L1 sequence, with an empty L2 function.

Patch 3 enhances the library functions by setting up L2 -> L1 stage-2
translation. Currently the translation is simple, with start level 0, 4
levels, 4KB granules, normal cachable, 48-bit IA, 40-bit OA.

[1]: https://lore.kernel.org/kvmarm/20260306142656.2775185-1-joey.gouly@arm.com/

Wei-Lin Chang (3):
  KVM: arm64: selftests: Add library functions for NV
  KVM: arm64: sefltests: Add basic NV selftest
  KVM: arm64: selftests: Enable stage-2 in NV preparation functions

 tools/testing/selftests/kvm/Makefile.kvm      |   3 +
 .../selftests/kvm/arm64/hello_nested.c        |  65 ++++++++
 .../selftests/kvm/include/arm64/nested.h      |  25 +++
 .../selftests/kvm/include/arm64/processor.h   |   9 +
 .../testing/selftests/kvm/lib/arm64/nested.c  | 154 ++++++++++++++++++
 .../selftests/kvm/lib/arm64/nested_asm.S      |  35 ++++
 6 files changed, 291 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/hello_nested.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/nested.h
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/nested.c
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/nested_asm.S

-- 
2.43.0

