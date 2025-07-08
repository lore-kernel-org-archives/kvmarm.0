Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9A912CD8B
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 23:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752016006; cv=none; b=HVhddyxukpUxIzx6Eb7b+BTuayyVRxAceYwfeTFzabCXomckbM2iAYi3N0YXqbUWaaSTFjfgRK/WZVxU/mD6Hgd1U47jpoPWgScmJGA6Rx10VFH4HkgEEfDhv7NE259T+1RuqxHkjvQeBfhb53TbrAZxrJf/RSlFfqYxS0sPmkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752016006; c=relaxed/simple;
	bh=5NynQjBfoySs9EB38qn6Us8vqkTX4OQOF3wp28ToL6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=G2vCRDqW6KIU6AsCFJdfKClODpfhnkIk5AG+3403RghnYtPz4/m/5Wx/7dPQzGGsRTvlFfdjzs7vgO81wyW0o2Jba/SlTEM10ut44upMoKNlSI2OZmoG0zvP4Ww1DYODqtBXjhK8hR6RPnZVTf9HySw5unXzkH/Zfus/0rCOF1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HuIgxxyr; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HuIgxxyr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752016002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=A23pMAfb1inJrPAkiKdjBHXh7ToAfu6TdlmhAIDJs88=;
	b=HuIgxxyr6zFDuI4zRnAZmGuKXJHUdtRtjLy26avynO5gYAeNzPmyVoxeljXUgqDj4nASPL
	seLNG2qmg7ph4oTxliQyK1j0ZLtcaHfxWFC3eTfWQr9Xe3Zj4CZz37pmrTrMqfZWN1MrZ3
	AaqUsxKiAbc6w2jcN4HC8/rnTzABkLg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Fix + test for SError ESR
Date: Tue,  8 Jul 2025 16:06:30 -0700
Message-Id: <20250708230632.1954240-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

VSESR_EL2 only provides an ESR_EL1.ISS value for the SError, not a
complete ESR. Namely, hardware sets the EC field to indicate an SError
(0x2F), meaning we need to do the same for our software-emulated SError
injection.

Note that this behavior already exists for nested SError injection in
kvm_inject_nested_serror(). I also extended the external_aborts test to
assert the guest sees an expected ESR value for an SError.

Oliver Upton (2):
  KVM: arm64: Populate ESR_ELx.EC for emulated SError injection
  KVM: arm64: selftests: Test ESR propagation for vSError injection

 arch/arm64/kvm/inject_fault.c                 |  4 +++
 .../selftests/kvm/arm64/external_aborts.c     | 32 +++++++++++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)


base-commit: 3c5832f03f2ecd2b881f5bfbae06feeead432c16
-- 
2.39.5

