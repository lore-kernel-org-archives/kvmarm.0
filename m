Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966493E639D
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371073; cv=none; b=fmpEEd8HGbB78bF87LUoVUjpkB6cs0CXypK2c/bFLZNRqszs7p32i3l5YbsZkEqjxz/T4JptX4PMG+FJ6yuMuKO3USfhUYfsBIx77m3Q8kyRxhUd6FXXY6JYU33dZ17mWohbBdWAhwy4Btd+wBZMkToAUifGRceWHtHg1SQpm7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371073; c=relaxed/simple;
	bh=5/qH9WQH0xnxZiSwc57XSnnm6CjMDXhHBj4pLQbDsZk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=pG3z/hG9Dbwt1gq5zZATJg7TOABzrAA+Ye4qUKjlBYfofNB5Ne9IJDCBsykrT6AbnNXGXmOmQr5YN8YdPQ7mnILdNBLfNd+I4At5OPKu7DpWX0GQl/CG7hyrRKM8HFaUGt+P5MeQy0gwU5MM/OH1IZAwuCA6YliFbOq3MQf/V/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=ooqvViFm; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="ooqvViFm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789371070; x=1820907070;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=5/qH9WQH0xnxZiSwc57XSnnm6CjMDXhHBj4pLQbDsZk=;
  b=ooqvViFmxeoy+WW+pXY9Ei1spNk5yeSU188tJ/ngkLHxqiUDyT/3DvzC
   6Sup3w+gcSwrqOZzFFQ7nLn62lZp7tDvAR6L0DMMnLOdwkKW5yb7uIImI
   ciPQkOO1KRu/3+VPhw1vtzzzV+tH31fGHYz8UpUEa/WKFhODCBrgYgw7S
   VbN+RxqomlvRNUOSBYC30/zsfKFNOWB6sq+aJ8Ss40fsAMBscRkBYxNZY
   htth2RAz+w/hqMc83djfiv2bzcoPqHDXiFGzkHurASS1AiVYPV17VWXPm
   gpaZbS73rE39zP8a0/igVvCfbKZMJ2FKzN/m3BCjT8tLZjTDyWDV5CieE
   A==;
X-CSE-ConnectionGUID: por5LIe5RnqyzcXa+4bgig==
X-CSE-MsgGUID: mYnXI7b0SQqqiDJWUgub7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11904"; a="253154728"
X-IronPort-AV: E=Sophos;i="6.27,102,1786978800"; 
   d="scan'208";a="253154728"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 16:31:03 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 8A8D0C0182F
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:31:03 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 3ECCD18002D1
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:31:03 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with ESMTP id 65571180012C;
	Mon, 14 Sep 2026 07:30:57 +0000 (UTC)
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Subject: [PATCH v2 0/3] 52-bit VA guest mode ID support
Date: Mon, 14 Sep 2026 16:30:43 +0900
Message-Id: <20260914-arm64-52bit-va-v2-0-3911cb9d4ad4@fujitsu.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKOip2oC/12NQQ6CMBBFr0Jm7Zh2gAZdeQ/DAkorQwKYtjQaw
 t2lGDcuX/L++yt449h4uGYrOBPZ8zztQKcMdN9MD4Pc7QwkSImKSmzcqAosqeWAscGcrLSF7kQ
 pOthHT2csv47gvf6yX9rB6JAqyejZh9m9j8cok/eLq/94lChQFkZfKpIyV/nNLgMHv5z1PEK9b
 dsHgk4c3MAAAAA=
X-Change-ID: 20260825-arm64-52bit-va-32f1f4cd050d
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
 Takayuki Okamoto <tokamoto@fujitsu.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789371056; l=3154;
 i=itaru.kitayama@fujitsu.com; s=20260825; h=from:subject:message-id;
 bh=5/qH9WQH0xnxZiSwc57XSnnm6CjMDXhHBj4pLQbDsZk=;
 b=Vrji+rOz7LhmW6GdQCEDDXWddYrkAdBps2e04+1rLpswYZDXxv+ahTbGMs9yqV0gtrDVHhhwN
 LFHDUSJNmUnDuyYdXr8NBnwbrjHCUMRBlvptVI8wlBP+R+wwItjuMqR
X-Developer-Key: i=itaru.kitayama@fujitsu.com; a=ed25519;
 pk=g9bTnr9giRP7JwNSZHy+OMLQZBEUtSE9tUnXso0hH1Y=

This patch series extends the arm64 KVM selftest framework
to support 52-bit guest virtual address (VA) modes in addition to
the existing 52-bit physical address (PA) configurations.
The motivation is to enable validation of LPA2 guest memory-management
behaviour in configurations that use a 52-bit VA space.
While the selftest framework already supports testing 52-bit PA
configurations, it lacks the ability to exercise guests running with
52-bit virtual addresses, leaving part of the LPA2 functionality untested.
To address this, the series introduces new guest modes for 52-bit VA
operation, adds five-level page table support where required, and
performs runtime detection of host 52-bit VA capability so that
LPA2-enabled guest VA tests are executed only on supported systems.

Testing:

Built and ran lpa_test on QEMU with 52-bit VA support. 
The test verified shared mappings at low and high guest virtual addresses, 
then remapped the high VA to a different GPA and verified that 
the mappings remained independent.

Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Reviewed-by: Takayuki Okamoto <tokamoto@fujitsu.com>
---
Changes in v2:
- Reorganize the series so that each patch builds independently.
- Move all P52V52 mode definitions and uses into the same patch.
- Use the standard "KVM: arm64: selftests:" subject prefix.
- Reuse one probe VM and vCPU for IPA and 64K VA capability detection.
- Make the VARange result explicitly specific to the 64K granule.
- Clarify that only the 4K P52V52 mode uses five page-table levels.
- Link to v1: https://patch.msgid.link/20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com

To: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
To: Steffen Eiden <seiden@linux.ibm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Zenghui Yu <yuzenghui@huawei.com>
To: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
To: Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
Itaru Kitayama (3):
      KVM: arm64: selftests: Support five-level stage-1 page tables
      KVM: arm64: selftests: Add 52-bit VA guest modes
      KVM: arm64: selftests: Test 52-bit guest virtual addresses

 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/arm64/lpa_test.c       | 124 +++++++++++++++++++++
 .../selftests/kvm/include/arm64/processor.h        |   3 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |   3 +
 tools/testing/selftests/kvm/lib/arm64/processor.c  |  60 +++++++++-
 tools/testing/selftests/kvm/lib/guest_modes.c      |   7 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  11 ++
 7 files changed, 200 insertions(+), 9 deletions(-)
---
base-commit: 28924df2a08f440c73991b83028032c901de2ae4
change-id: 20260825-arm64-52bit-va-32f1f4cd050d

Best regards,
--  
Itaru Kitayama <itaru.kitayama@fujitsu.com>

