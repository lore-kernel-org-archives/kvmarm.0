Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B49420AF98
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 23:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741216118; cv=none; b=tVlqwzvEbna0CocHRqvHfrZUllZIJP/H5ky0gqtL78FXJMG2f4/00pdJGrnfjbstC7a4y4O5Ncw7ttVIlv83LloAbor6qK+XCxMzuAsUZ8vl4HKiS6ceQl4P41n/E93RfCKEz84XQ5YTJ9APNG2jacKIH7O9C4dY7cSmsamKHbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741216118; c=relaxed/simple;
	bh=16CBZcFsR9yCYZBwFJXk1mk30H83qBEUq6bHSt2vuHc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E75DZTaMD3OQAa+QHxLFQACLS1Gy1ZY0hzKiBcvtib5+RJ2efEbsVzZ6VcXvM+LMKf8U1KNnl6pLZt+Y3mjHLIqCUBx3wz/a6pFjZZbAiTH4B9aVHnFd/Ld16EkbiTuhA9WYpK+mswWJfW+irhiXl+xXeqm8q8Sdjr8wGMsD4Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eXUkSSRf; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eXUkSSRf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741216114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=edrQ4vcxF/l5pNr2lcG1N9hHl6Bs6mjWXLXbxCSFcGk=;
	b=eXUkSSRftTqSUZamuWNt8Bb9lKeKwMmh1swIy10MOj3OcjX0F6T8fcytEFu8DxAPb4/2b/
	c400NbAwva6N5gVrFNLH1Uon+cCK2LixoSdWGxWePAZJ7egAGEeOFCjdWt6y7I7edkf1Al
	/OO1BqZ3oSADycl8BK/2AMd05+xY8mE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: Fixes for 'writable' ID registers in protected mode
Date: Wed,  5 Mar 2025 15:08:22 -0800
Message-Id: <20250305230825.484091-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Address a few issues with ID register handling in protected mode:

 - CTR_EL0 isn't trapped on FEAT_EVT systems if userspace changed the
   guest value

 - VPIDR_EL2 is set to 0 if userspace enabled writable 'implementation
   ID' registers

 - Fix in capability documentation

Oliver Upton (3):
  KVM: arm64: Copy guest CTR_EL0 into hyp VM
  KVM: arm64: Copy MIDR_EL1 into hyp VM when it is writable
  KVM: arm64: Fix documentation for KVM_CAP_ARM_WRITABLE_IMP_ID_REGS

 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)


base-commit: 164f95739b6893716add9439cf765edd5254d0f6
-- 
2.39.5

