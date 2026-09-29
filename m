Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9CE54705E
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 19:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790708702; cv=none; b=clP9umIrRfA6Urdz/my9cakHZml6wRBXP3+I1OH7FYqotzkXh2Pt1qiem/uI7ye5eCOg3vFq96ja5wfwZkRTuCR6ZdlexC4XnqDOZvrXDCwjzvEA4th2Wi2hZjFd9XV7D4BbVYaBFdexFmOdD9x5MOCK3K28XMcyJaCcHtVJk2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790708702; c=relaxed/simple;
	bh=Wv2LAC871pIKGb/ciNqR/Im7/rPMRTvo6hq+2IOPT14=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EYU663KRIC60MeAOdt4//SOMWNJiXwlLiVL/YXjZ8oFV5XebgUdlhUSvKo9YzeGIywTZmR9Mfxuv3AQPtteoA5Dazqsp84Ya3nbeiWxl/LQb9Bwew9FmUX5GeR3Fl3HIjD5DSb1cCXrLo2IZeYoYhrCFxHOQqyZzwk2jy2HRRSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mNMLys/w; arc=none smtp.client-ip=91.218.175.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mNMLys/w"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Wv2LAC871pIKGb/ciNqR/Im7/rPMRTvo6hq+2IOPT14=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790708696; v=1; x=1791313496;
 b=mNMLys/wi2jHhDzR0Yiyty/LtQf0xUIYF2VClxECQS1/0RLOxA9ik3HlpadGd1lpDR/rR1s+
 XaPSW6DpTXfShhoDnGhGfnhqQfRPwFyznHlGkC3aLoIVxikPTQQ348nZO/VVhlpWip3Au+mozvM
 81q9fjUBb319pfxsgGzSp54U=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e8e09ddc74236482;
	Tue, 29 Sep 2026 19:04:56 +0000
X-Mizu-Trace-ID: e8e09ddc74236482
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v1 0/2] KVM: arm64: selftests: Cover the ITS MOVALL command
Date: Tue, 29 Sep 2026 20:04:50 +0100
Message-Id: <cover.1790708299.git.fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260929093548.3598547-1-maz@kernel.org>
References: <20260929093548.3598547-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

I wrote this to test your series [1]. It fails without patch 6 and
passes with the whole series, on QEMU with pKVM, VHE and nVHE hosts. On
an Apple M4 host, the series boots and runs protected and non-protected
guests. The M4's GIC has no ITS, so the test doesn't run there.

Feel free to take it with your series if you think it's useful.

Based on kvmarm/next (5c49bb52faf38).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260929093548.3598547-1-maz@kernel.org/

Fuad Tabba (2):
  KVM: arm64: selftests: Add a MOVALL command to the ITS library
  KVM: arm64: selftests: Add an ITS MOVALL test

 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/vgic_its_movall.c     | 341 ++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v3_its.h  |   1 +
 .../selftests/kvm/lib/arm64/gic_v3_its.c      |  16 +
 4 files changed, 359 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_its_movall.c


base-commit: 5c49bb52faf38ddf9c3383807b1d814ef8769b80
-- 
2.39.5

