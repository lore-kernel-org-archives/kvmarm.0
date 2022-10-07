Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAD45380
	for <kvmarm@lists.linux.dev>; Fri,  7 Oct 2022 23:42:05 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1665186123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8gk76JRqjPqMzkfoKmXkwFy1NQbQ1ICsFcGyhsYU5J0=;
	b=v/KiVBTDrWvVn+101zSX+yMTklfcDfKoScD2vAnF13qg7YbpUTAe7yBbTpCiXRoBauVVq6
	u4QQyKsJyiZHkTVlzpoDMQoMyEwou6RWbcC1OnniQKHbu1HXKUNwF+xXqNFfUlc4wCga/N
	PJeClBh18muHjmvswN/3a9VXwgI940o=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 0/2] KVM: arm64: Limit stage2_apply_range() batch size to largest block
Date: Fri,  7 Oct 2022 23:41:49 +0000
Message-ID: <20221007234151.461779-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221007234149.WmcVCEHo3NrAJoVrWEqYPATvG8bGVvpneY20MHKCbGg@z>

Continuing with MMU patches to post, a small series fixing some soft
lockups caused by stage2_apply_range(). Depending on the paging setup,
we could walk a very large amount of memory before dropping the lock and
rescheduling.

Applies to kvmarm-6.1. Tested with KVM selftests and kvm-unit-tests with
all supported page sizes (4K, 16K, 64K). Additionally, I no longer saw
soft lockups with the following:

  ./dirty_log_perf_test -m -2 -s anonymous_thp -b 4G -v 48

v2: https://lore.kernel.org/kvmarm/20220926222146.661633-1-oliver.upton@linux.dev/

v2 -> v3:
 - Just use the largest block size as the batch size (Marc)

Oliver Upton (2):
  KVM: arm64: Work out supported block level at compile time
  KVM: arm64: Limit stage2_apply_range() batch size to largest block

 arch/arm64/include/asm/kvm_pgtable.h    | 18 +++++++++++++-----
 arch/arm64/include/asm/stage2_pgtable.h | 20 --------------------
 arch/arm64/kvm/mmu.c                    |  9 ++++++++-
 3 files changed, 21 insertions(+), 26 deletions(-)


base-commit: b302ca52ba8235ff0e18c0fa1fa92b51784aef6a
-- 
2.38.0.rc1.362.ged0d419d3c-goog

