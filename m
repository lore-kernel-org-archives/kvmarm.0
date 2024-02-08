Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7FA6EB76
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 10:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707389680; cv=none; b=ItsmAfETj4BmVyaOWKw+clruuEodrMRHu05tkAKL+iFaIfY/UCF3marNAIycgiYX+DswisF+ZDemWN34lJ2ByC5uR3oimpaHB8gRlGSZD7Qzc7lDem8aqCH3REKiwWDMywqZEEgSvQU8d8+wPSWCnAdpeSlz0y0hodkBu35R7WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707389680; c=relaxed/simple;
	bh=OLWtKP0uVrFPnaCFYmHPoEhS423Sy4XFQXcamT8L5Zk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TxAslOi4FX09NhNQv+fJNMIV1g3srIDDtgE5vstCy9DkA3RcOoBc+S4LWRWSQDLSn2loXe+2KIQRszXJmcU1LjuuKXWezTHNaWrgQCIKagNHgNAd7ZBW2lqqLsw83XZ4mcfYMBXLfKQts6UU1HLej2FpHeuMFo92ZWcq4hAiPyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F6DC1FB;
	Thu,  8 Feb 2024 02:55:18 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10AB03F762;
	Thu,  8 Feb 2024 02:54:34 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: joey.gouly@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v1 0/2] small kern_hyp_va() cleanups
Date: Thu,  8 Feb 2024 10:54:20 +0000
Message-Id: <20240208105422.3444159-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I wanted to add some comments to __kern_hyp_va(), since I was recently trying
to understand it, and I think it could be helpful for someone looking at it in
the future.

The second patch removes the assembly macro version, since it is unused. Maybe
(out-of-tree) pkvm uses it or it's just worth keeping around in case someone
needs it in the future. So if that patch isn't applied it's not too important.

Thanks,
Joey

Joey Gouly (2):
  KVM: arm64: add comments to __kern_hyp_va
  KVM: arm64: removed unused kern_hyp_va asm macro

 arch/arm64/include/asm/kvm_mmu.h | 41 ++++++++++++--------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

-- 
2.25.1

