Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20401CD2C
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 00:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740444856; cv=none; b=esjTTsC40idbH7GTM53bhtdUcz7SyIkAmFjK3hnajOVdgAqpJMcAvNzQReRmJNJ6+s/VuRm+Z6Gv3vPVTyh19h/JGlxYoNZjqoDoKUU25B4mFEx7fxeqsmEf91UJsvMPc0hVUL3jElJJWBGbl2T55UUM00bGk4468Sl4UWrO9U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740444856; c=relaxed/simple;
	bh=/QimwqdDvYX6h7Wz0wd1J3ic4UAJLnsi2wMrTlxegqw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NXTUPuCHKcDotCzGR/Ipp2PjwPaRjSHQIH1zRfBr8L2Eg1AEGk9ziQYy6te/5AZ12uG+mP1mEFRje1wYYwYbsR5ebcVqhI8DKQFEmPTyH/xqxSBYTxczBHaoA5ArI86VCOy6D3LCa3ItDpFVJdDm7vuZ/mz/B9ib5lLsCPBjWLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OgQvRjl6; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OgQvRjl6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740444851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3DorAnUeEG/hBnx4WJstzSCXw8X1seAEIzU2bR6UqMI=;
	b=OgQvRjl61IpdhNvxOaCi/axAmp/1F7FrOL9slUrf/3JwY2TiXf6YRJjkW7j5V1ytUrLg7+
	vC8HnzITk/iE/WwTueIIgOSOWbYQn4Yf37MJ5vZBW+DT55t3pBvC/yOD1g5GciupWb/ZZN
	Jorz4tF+LtrpNwgkFAiL7FhDUv1zl3o=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 0/5] KVM: arm64: Writable MIDR/REVIDR (and associated baggage)
Date: Mon, 24 Feb 2025 16:53:56 -0800
Message-Id: <20250225005401.679536-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This is hopefully the last take on the writable MIDR/REVIDR/AIDR series.

I've restructured things in order to work around the existing
shortcomings, have a stable-worthy backport for SMIDR_EL1, and avoid
breaking ABI.

I personally hate using a capability for this, but given the subtlety of
the issue (and our habit of breaking save/restore) it is probably best
to put userspace in the driver's seat.

v3: https://lore.kernel.org/kvmarm/20250218163443.32836-1-sebott@redhat.com/

v3 -> v4:
 - Trap SMIDR_EL1 accesses so they actually UNDEF
 - Snapshot MIDR, REVIDR, and AIDR from the boot CPU
 - Require buy-in from userspace to make ID registers writable

Oliver Upton (2):
  KVM: arm64: Set HCR_EL2.TID1 unconditionally
  KVM: arm64: Load VPIDR_EL2 with the VM's MIDR_EL1 value

Sebastian Ott (3):
  KVM: arm64: Maintain per-VM copy of implementation ID regs
  KVM: arm64: Allow userspace to change the implementation ID registers
  KVM: selftests: arm64: Test writes to MIDR,REVIDR,AIDR

 Documentation/virt/kvm/api.rst                |  18 ++
 arch/arm64/include/asm/kvm_arm.h              |   4 +-
 arch/arm64/include/asm/kvm_host.h             |  11 +
 arch/arm64/kvm/arm.c                          |   9 +
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |  14 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |   4 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |  28 +--
 arch/arm64/kvm/sys_regs.c                     | 219 +++++++++++-------
 include/uapi/linux/kvm.h                      |   1 +
 .../testing/selftests/kvm/arm64/set_id_regs.c |  37 ++-
 10 files changed, 229 insertions(+), 116 deletions(-)


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.39.5

