Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2321A486
	for <kvmarm@lists.linux.dev>; Fri, 18 Nov 2022 21:15:22 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668806120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IBgRCeErwQCUyfW70Ze08m0oR+9ioab9xsEyeSrJGBc=;
	b=CJghzJslYjDa3bJIZ+4nUqnhQoU1COpSvTrvrZ9QPdkAQXdgD6FGprBEqLng210wqHRQrU
	pHEelwRlJn5H8tm2S+pEYnwbonN0rzdRa3lGPTKZXVwE5HiK9U7rEh7zw3HOrm6sxG5LAY
	Wl0+VVZPUmT/5IgoYWiJHxSEF4XC5DQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Gavin Shan <gshan@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/2] KVM: selftests: Enable access_tracking_perf_test for arm64
Date: Fri, 18 Nov 2022 21:15:01 +0000
Message-ID: <20221118211503.4049023-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221118211501.uLmqiyoXvMnPL_nI8oyZMuBpG0BnjcMBkCvQnMU7fUQ@z>

Small series to add support for arm64 to access_tracking_perf_test and
correct a couple bugs along the way.

Tested on Ampere Altra w/ all supported guest modes.

v1 -> v2:
 - Have perf_test_util indicate when to stop vCPU threads (Sean)
 - Collect Gavin's R-b on the second patch. I left off Gavin's R-b on
   the first patch as it was retooled.

v1: https://lore.kernel.org/kvmarm/20221111231946.944807-1-oliver.upton@linux.dev/

Oliver Upton (2):
  KVM: selftests: Have perf_test_util signal when to stop vCPUs
  KVM: selftests: Build access_tracking_perf_test for arm64

 tools/testing/selftests/kvm/Makefile                      | 1 +
 tools/testing/selftests/kvm/access_tracking_perf_test.c   | 8 +-------
 tools/testing/selftests/kvm/include/perf_test_util.h      | 3 +++
 tools/testing/selftests/kvm/lib/perf_test_util.c          | 3 +++
 .../selftests/kvm/memslot_modification_stress_test.c      | 6 +-----
 5 files changed, 9 insertions(+), 12 deletions(-)


base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
-- 
2.38.1.584.g0f3c55d4c2-goog

