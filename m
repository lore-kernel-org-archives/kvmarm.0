Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C28F38F629
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 18:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784919292; cv=none; b=W1j/YOSOWy7oR+JHJW/eajtrz01mjCjybZo4hFa6oMI0kvP38nXRJOQ2mCPJ9iMVjHUfdQUtLVEXQxzEI6t9DEbSpPuHi1SPAS4z5X2TWivoa6VPWcu40rDOgFQ88Os6VaI/cmFKCjdsf1u88WkClX88mW0CuHSQuCpvhGt4uVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784919292; c=relaxed/simple;
	bh=BPTEFWR6tr6yjiQpGSUZyUAEINefQ30E9WfvG3o1+Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BEMG3FYy2IOi++0HxBO3n8L8LBc0oNHZRPxXeRN4RvFiRK+oiEsRmqrdHYE1d9WymJoI14zCfR+hRtAPpaMfQ3sf5gAp0mWMhmsQNnfQwrsRDMIzRvMvf62gplJy7jBg/VC/9AZ82RWAIXjmGHnbfhagC+9PlDFaMvBjv2U3vJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c7ljA7QL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c7ljA7QL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A89CB1476;
	Fri, 24 Jul 2026 11:54:43 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 04F173F66F;
	Fri, 24 Jul 2026 11:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784919287; bh=BPTEFWR6tr6yjiQpGSUZyUAEINefQ30E9WfvG3o1+Eo=;
	h=From:To:Cc:Subject:Date:From;
	b=c7ljA7QLCJV9DHZyPmExC24ttLdsZ+joZ49WWP0oYB5jS7BgdX9FM0/ZziUFLpiF3
	 rqzAPY0y0uF7OQEie54KWys5LzQoqncrhCKAf0WTPW/mGFJmBDSV2OyBL8gPgmW+dG
	 ail9DpkcTYY/MAioSf1n4dtgeXfGSRRPD0bKoEvc=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Matt Fleming <matt@codeblueprint.co.uk>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 0/2] arm64: ptdump flush fixes
Date: Fri, 24 Jul 2026 19:54:29 +0100
Message-ID: <20260724185431.2990395-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series fixes two problems around ptdumps:

1. note_page_flush(), which flushes out the last row of ptdumps, does
   not account for address spacees that have IA < 64. Other than making
   the last region extremely huge, the attributes of the last region
   within the address spaces appear to extend all the way to 1 << 64.

2. KVM/arm64's stage-2 ptdump missed calling note_page_flush().

Please see the patches for more detail.

* Changes from v1 [1]:

  - Instead of manually calling note_page() for flushing, fix
    note_page_flush() so that it ends the ptdump at the end of the
    address space.

  - Changed the start address of the second marker to ULONG_MAX for KVM
    ptdump, so we don't output extra marker names, and advance past the
    end of the marker array.

Thanks!

[1]: https://lore.kernel.org/kvmarm/20260717231233.2299068-1-weilin.chang@arm.com/

Wei-Lin Chang (2):
  arm64: ptdump: Make note_page_flush() range aware
  KVM: arm64: ptdump: Flush the last region

 arch/arm64/kvm/ptdump.c | 16 ++++++++++++----
 arch/arm64/mm/ptdump.c  | 17 ++++++++++++++++-
 2 files changed, 28 insertions(+), 5 deletions(-)


base-commit: 679d7201c1f09e37fa1c12ce28d84079c17fc87f
-- 
2.43.0

