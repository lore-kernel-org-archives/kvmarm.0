Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DCC3DD516
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 21:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.37.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787692734; cv=none; b=jBrKGo8wPwaFs2WV5tes73HagW0kRaZMh+VaOFCAgX1QxlRSscbumJ/33VuTeSfcbZ2cZEBrXICc6ovBUfxGllPU0tkjPYi7SmFGjsX6ngaQ7qgpVympP+wq/rjLV+XJA7jgOjsaNiPYJm2ANtQdScllSo+GP9izmJb1znWwoc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787692734; c=relaxed/simple;
	bh=DCkh7zwFwuSOe5fTMEye2Oh1ZEjE4In2M9Rjx+1yMUE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=JoV+f1Q/a7IQ4IS52Eyz8OvW/atz1+tdrUc/eIXp/CaqlidQih43Plkf2+Uh3nDDChKz7FrJ4WA1jtzCdKz+GtToWc8mNTm3hjLG/EsgT5+Ahg7bE/O12HAPN6C8U0Oux+MLYrWeb6/SMxHUDDL+eIPxPvAdPddzpxgPCDcTDwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=hgAlJ8mF; arc=none smtp.client-ip=139.138.37.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="hgAlJ8mF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1787692731; x=1819228731;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=DCkh7zwFwuSOe5fTMEye2Oh1ZEjE4In2M9Rjx+1yMUE=;
  b=hgAlJ8mFFG7rXNAl8ilxL8kTOaZQFHBhUypUt3lavMoyzyHfF6FmuC4J
   fwGMupSAzrq81Fg6MgnSwfhTOs+k5XXgKrrdxHrKwfBr0tVA3DlE7+tKn
   IKcJ7+bZA5GVd+iQDRlpJt/kK3QyW3R61EmfSfPjSK42i1eInFu6rmifA
   J8ULah49qUUxFswEGo9stZpBP2iBs6QYVYOC+rHLCweiDIwxX96dmSs+k
   ULAkVvEzsbkDLG+R38MN1nM7QpBF8BGrZtxprO6ua67tr9uIpwzB/9+Q/
   mFfiwCn4vf6n/kJDt5kpaDvlt2V2w5nWgNblncRvY7qt9HsxV7RQ7eS22
   Q==;
X-CSE-ConnectionGUID: 74X0QkWJQQ2Ladf+jM2t7g==
X-CSE-MsgGUID: 846iczG7QmOkKTAUI3Iy/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="230306791"
X-IronPort-AV: E=Sophos;i="6.25,243,1779116400"; 
   d="scan'208";a="230306791"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 06:18:44 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 5B3621C1C714
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 21:18:44 +0000 (UTC)
Received: from az2uksmom1.o.css.fujitsu.com (unknown [10.151.22.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 173218320FC
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 21:18:44 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom1.o.css.fujitsu.com (Postfix) with ESMTP id 459B81801C01;
	Tue, 25 Aug 2026 21:18:39 +0000 (UTC)
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Subject: [PATCH 0/2] 52-bit VA guest mode ID support
Date: Wed, 26 Aug 2026 06:18:33 +0900
Message-Id: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKkGjmoC/yXMQQqEMAxA0atI1gZqtCJzlcFFbVONMDq0KoJ4d
 6su3+L/AyIH4Qif7IDAm0SZp4Qiz8AOZuoZxSUDKapVQxpN+NUVaupkwc1gSb7wlXVKKwcp+gf
 2sj/Db/s6rt3IdrkvcJ4X9NTgIXIAAAA=
X-Change-ID: 20260825-arm64-52bit-va-32f1f4cd050d
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
 Takayuki Okamoto <tokamoto@fujitsu.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787692718; l=1855;
 i=itaru.kitayama@fujitsu.com; s=20260825; h=from:subject:message-id;
 bh=DCkh7zwFwuSOe5fTMEye2Oh1ZEjE4In2M9Rjx+1yMUE=;
 b=7XNu/jkIySZnSwyMNQ95NlahI1x9xVp4JU7Z8qoAENLXI9Bg2Mlv4Us0xIz4cTk1mLd3wberh
 apmDZOfqdp8Ag/eP9I4BBkHtOVzEu9B1BccGPvdg0H+ylcLNTr/ecuV
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

Built and tested on arm64.
Verified on QEMU with a V52-capable guest configuration.
Confirmed correct operation of high virtual address mappings by
exercising guest memory accesses in the 52-bit VA range.

Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Reviewed-by: Takayuki Okamoto <tokamoto@fujitsu.com>
---
Itaru Kitayama (2):
      KVM: selftest: arm64: Support 5-level paging in stage 1 translation table
      KVM: selftests: arm64: Add 52-bit VA guest modes

 .../selftests/kvm/include/arm64/processor.h        |  2 +
 tools/testing/selftests/kvm/include/kvm_util.h     |  3 +
 tools/testing/selftests/kvm/lib/arm64/processor.c  | 87 ++++++++++++++++++++--
 tools/testing/selftests/kvm/lib/guest_modes.c      |  5 ++
 tools/testing/selftests/kvm/lib/kvm_util.c         | 11 +++
 5 files changed, 103 insertions(+), 5 deletions(-)
---
base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
change-id: 20260825-arm64-52bit-va-32f1f4cd050d

Best regards,
--  
Itaru Kitayama <itaru.kitayama@fujitsu.com>

