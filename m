Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2F88C1A
	for <kvmarm@lists.linux.dev>; Wed,  7 Dec 2022 21:48:28 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670449701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=16LMNcduUmJXQJNzhs+CPaMIYUMzlfOKY+rOo3K6LbQ=;
	b=u63UBWyhpAxMlem/etDv9iTa0u6y7HKmhxIez0MD8dedIZiU5ViY2yr9IXP3CuYiD3RfWe
	J/6c2HMI5Lq/sZ/WcKkd8IWu6JHyh4J0YjR4lmfLolPHXcfudpJ5PoxihxSG4TSDFBnt8l
	PNKkzvRIBpGlvjTvrx90ImyS1fcbAwg=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/4] KVM: selftests: Fixes for ucall pool + page_fault_test
Date: Wed,  7 Dec 2022 21:48:04 +0000
Message-ID: <20221207214809.489070-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221207214804.FtF6YCdOsAkGzNjjzHA-z17-fvyQMGY74FDhqLaBjI0@z>

The combination of the pool-based ucall implementation + page_fault_test
resulted in some 'fun' bugs, not the least of which is that our handling
of the VA space on arm64 is completely wrong.

Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
be squashed into Paolo's merge resolution, if desired.

Mark Brown (1):
  KVM: selftests: Fix build due to ucall_uninit() removal

Oliver Upton (3):
  KVM: selftests: Setup ucall after loading program into guest memory
  KVM: arm64: selftests: Align VA space allocator with TTBR0
  KVM: selftests: Allocate ucall pool from MEM_REGION_DATA

 .../selftests/kvm/aarch64/page_fault_test.c       |  9 +++++++--
 .../testing/selftests/kvm/include/kvm_util_base.h |  1 +
 .../testing/selftests/kvm/lib/aarch64/processor.c | 10 ++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c        | 15 ++++++++++-----
 tools/testing/selftests/kvm/lib/ucall_common.c    |  2 +-
 5 files changed, 29 insertions(+), 8 deletions(-)

-- 
2.39.0.rc0.267.gcb52ba06e7-goog

