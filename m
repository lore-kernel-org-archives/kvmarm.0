Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E20393002B9
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807227; cv=none; b=lnvHL3qeasNe67IrOQMmq4hQXim0ft/0YCZ8NgNHZZQOwgGjANCeaMWCdDdXoeif/nEKGvHQGdGfh6wB6c2oPYZ8OTxIiKeC2ebD9/9CWQUt9nzvCoDsP5y5ifiwK2xEoOHYK1RVBEvu1mU9gB6pNvIMgJOg33zm8KkqDAP4n1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807227; c=relaxed/simple;
	bh=RCx8Uur8nmzrjLseT2+H+BKPeCt6hLI0iYLPgFtbN00=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FLP9fFQADe55yY4Ei/V2es8XOZ1BS/f+bXI1TArrIR6vp+wSfochX88bUvfND1wng1W24BxGxPOUhpnUppuwF1++14St2seqEWw10E2JGxn3w061MbIvIkuLbzOfVuBpMvpIx3N2a/ykF3cA/I/DajTraA5loeBlKhO05Kh8tSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6840497;
	Fri,  6 Mar 2026 06:26:58 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50E973F73B;
	Fri,  6 Mar 2026 06:27:04 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: joey.gouly@arm.com,
	andrew.jones@linux.dev,
	alexandru.elisei@arm.com,
	Marc Zyngier <maz@kernel.org>
Subject: [kvm-unit-tests PATCH v1 0/5] basic EL1/EL0 guest support
Date: Fri,  6 Mar 2026 14:26:51 +0000
Message-Id: <20260306142656.2775185-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is some basic infrastructure for running code at EL1 or EL0.

This is currently aimed at writing simple tests that don't require a
separate address space for EL1/EL0 nor multiple contexts (that is, a
single EL1 or EL0 exist).

First 3 patches are some preparatory patches, patch 4 adds the 'guest'
API and the last patch adds a test using it.

Thanks,
Joey

Joey Gouly (5):
  arm64: add thread_info helpers
  arm64: add macros for manipulating SP
  arm64: context switch SP_EL0/SP_EL1 depending on context
  arm64: add EL0/EL1 guest functionality
  arm64: add hypervisor trapping test

 arm/Makefile.arm64        |   2 +
 arm/cstart64.S            |  70 ++++++++++++++++++-
 arm/hyp-test.c            | 139 ++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/thread_info.h |  11 +++
 lib/arm64/asm/esr.h       |   2 +
 lib/arm64/asm/guest.h     |  14 ++++
 lib/arm64/asm/sysreg.h    |  12 ++++
 lib/arm64/guest.c         |  67 ++++++++++++++++++
 lib/arm64/processor.c     |   7 ++
 9 files changed, 322 insertions(+), 2 deletions(-)
 create mode 100644 arm/hyp-test.c
 create mode 100644 lib/arm64/asm/guest.h
 create mode 100644 lib/arm64/guest.c

-- 
2.25.1

