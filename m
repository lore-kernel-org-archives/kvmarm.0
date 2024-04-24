Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C540215B55C
	for <kvmarm@lists.linux.dev>; Wed, 24 Apr 2024 17:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713980414; cv=none; b=RE9xFSLp+q89GX7dMqMxgLcboTAwFuMOgnrqCGi4iesNGDphNULqcQ2q2w7480YaRHKAqgyn9ABLqtY3udb35qhPB5dVTQWFRpJxR/+6dsDE8XzMLDfAMKqkblC9TifVgfYCi/ebgQ7D7ka6ffwi4NNBZmWB99AkhIflkRPr74o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713980414; c=relaxed/simple;
	bh=9cjGIBWDtm293I1mBUzGX8gnpk+3cVyprZL/pD5e56M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M6HXXL2rvaDLFY0oYJFIOdc7vYSBVBhSs+SrIuRdxhSsarBNxJixMBi5Eib6sQFlWQPRHH5ku88WxVCEkRX8GvBOASA3Hi//3bM1EYQ7GHDAp30yTqx7GuE/iFGrl/usNUTGO8MWDWodx2K0oBPLhB5GdtnlmHfQ51F/IbsWiLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZWEZ6M52; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZWEZ6M52"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713980409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ODFn/kVBzjTb2vYSbkWdi27ylHj8BGS28Jm50+JvVcA=;
	b=ZWEZ6M5270ub3EKUHnXXcVXQAq6mzhWeuca/QguRFnyae+P5I8bocDBXvbMfnqdNLILHe0
	sng22/MMsrl/+cdn1MKoYgW76/r3TmIegCmrq4jlexdxfyxcVEoboE9dFVSA+80hPYbY4L
	xSJAOr8dYQ7mxjycE7TOYmnWt9R8lrg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Avoid NULL dereference in vgic-v2 device attr accessors
Date: Wed, 24 Apr 2024 17:39:57 +0000
Message-ID: <20240424173959.3776798-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Alex reports that it is possible to trigger a NULL dereference via the
vgic-v2 device attribute accessors, stemming from a lack of sanitization
of user input...

Here's a fix + regression test for the bug. Obviously, I intend to take
these as a fix ASAP.

Oliver Upton (2):
  KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()
  KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF

 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  8 +--
 .../testing/selftests/kvm/aarch64/vgic_init.c | 49 +++++++++++++++++++
 2 files changed, 53 insertions(+), 4 deletions(-)


base-commit: fec50db7033ea478773b159e0e2efb135270e3b7
-- 
2.44.0.769.g3c40516874-goog

