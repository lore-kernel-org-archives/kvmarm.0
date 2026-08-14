Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3FA39021F
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 22:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786746330; cv=none; b=ElPp674tvobjsa8VqJiwDKG28laCy2BGawtSTuFr8+I/2hLWcyn/UZlqrOBrGzNfXHwaS6oGKWT8u4kmHQ7uw1N3BuDctMvMHgk9JQ0DhpkQPBAgxubJVghfMxguSTpVYTOAWfK7yr+ClWVdexNnBxawD5Nc2kVIBZ+/8v7Iy0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786746330; c=relaxed/simple;
	bh=6/V4aV3g0qBuiI8PmXGjHqwJRwdTQPSXQ+huEkBWn6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lHT/ob0xZxk4SZl6B07Z3McfNuQAePeuLy+H8p/n2Qa5jbFdePjmfXlZT802ngaO6Y98EPIH17JFvZ60srkuf7SOLEaVrrGa+Cwyl+7fUHsLq4xfi11kCWMqOHz9RVtwWMgOsx71+qCoNv32kqM8nC64FN31P110ZQNgGKsIuS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gkLremvs; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gkLremvs"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54F181BCA;
	Fri, 14 Aug 2026 15:25:21 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 091D93F632;
	Fri, 14 Aug 2026 15:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786746325; bh=6/V4aV3g0qBuiI8PmXGjHqwJRwdTQPSXQ+huEkBWn6M=;
	h=From:To:Cc:Subject:Date:From;
	b=gkLremvsiYLZ1ce5HKb0X2QbVeMJPn/ITko7pdh9kZC0H1Cz7GK6xNHbQ3Rz3126P
	 Xf3PwClxmIjqS3PmDICtaH2bKpYMGPT5omfmhabRR6lgmnBBv+4/LuEfnnJKFmPUh+
	 t5ITEnbKscduYz0JubZxreNQV9q/7x9w5ikpMGt4=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Fleming <matt@codeblueprint.co.uk>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 0/2] arm64: ptdump flush fixes
Date: Fri, 14 Aug 2026 23:24:56 +0100
Message-ID: <20260814222458.584906-1-weilin.chang@arm.com>
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
   not account for address spaces that have IA < 64. Other than making
   the last region extremely huge, the attributes of the last region
   within the address spaces appear to extend all the way to 1 << 64.

2. KVM/arm64's stage-2 ptdump missed calling note_page_flush().

To address Will's comment [1], I have created an end_address field for
struct ptdump_pg_state, and initialized it with the end address of the
ptdumps. It follows the same convention as the last range->end:
exclusive end, except for the case where the address space ends at
1 << 64. In that case it is set as ULONG_MAX.

Caching the end address avoids duplicating the range iteration in
note_page_flush(), at the cost of duplicating state in ptdump_pg_state.

Series is based on v7.2-rc5.

* Changes from v2:

  - Instead of scanning ptdump_state.range[] to find the end address,
    cache the end address in a new field end_address when we initialize
    struct ptdump_pg_state.

  - Adjust KVM's struct ptdump_pg_state initialization so it uses
    end_address instead of ptdump_state.range[].

  - Collected Reviewed-by and Tested-by from Dev, thanks!

  - v2: https://lore.kernel.org/r/20260724185431.2990395-1-weilin.chang@arm.com/

* Changes from v1:

  - Instead of manually calling note_page() for flushing, fix
    note_page_flush() so that it ends the ptdump at the end of the
    address space.

  - Changed the start address of the second marker to ULONG_MAX for KVM
    ptdump, so we don't output extra marker names, and advance past the
    end of the marker array.

  - v1: https://lore.kernel.org/r/20260717231233.2299068-1-weilin.chang@arm.com/

Thanks!

[1]: https://lore.kernel.org/r/anXFo-igVdqrCogQ@willie-the-truck/

Wei-Lin Chang (2):
  arm64: ptdump: Make note_page_flush() range aware
  KVM: arm64: ptdump: Flush the last region

 arch/arm64/include/asm/ptdump.h |  2 ++
 arch/arm64/kvm/ptdump.c         | 11 +++++++----
 arch/arm64/mm/ptdump.c          | 14 +++++++++++++-
 3 files changed, 22 insertions(+), 5 deletions(-)

-- 
2.43.0

