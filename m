Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F24D175A8D
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 15:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780673635; cv=none; b=OIvzglzCJBJvr/5eHVIYu2InI/lUNB1rHdTBPaS/GIwWJwJ8u9zVzH5Pj99xJEGsenr2YDJPy3qPLW2vYf+pEf4ee/98YVHF8ZCj+m0+SWxwkqrxb6wzR0W/NGkIVsHdC3Q5mu0pEij5MTIYiOrc7tIYTIkB3ZZQoS1yeDcajRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780673635; c=relaxed/simple;
	bh=cJZsMWwAthFAD+EfG9pOv5vX8VDeNvwWNRcwfK6nxt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jbc4ielcIb/siZqbRO2RPaF0YsXowPWlcgt1ifRvkdWZE6pRQovRXc5NOsZlCmrl31MwFaXqagNqn1Sls4Uk79+6n4Dzl3NGHZO2HmNtgofxDtoFFyxM0IFUoONo3PrIb/wP0ojGIwBfcAXUX7n7qGp4NphIXrT2YRMvYJ5uEX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Vrd/1ldl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Vrd/1ldl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CD893297;
	Fri,  5 Jun 2026 08:33:45 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22C373F86F;
	Fri,  5 Jun 2026 08:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780673630; bh=cJZsMWwAthFAD+EfG9pOv5vX8VDeNvwWNRcwfK6nxt0=;
	h=From:To:Cc:Subject:Date:From;
	b=Vrd/1ldlMKg1nW90t60ZpKirXZGIwzjv/XJfW03+uMnfda0YDB3AXgH8UdEehyn3/
	 o43oLDBBCnrv4SBXFheZPiMAfcBXZJbT0LIKzYfHevxH3icxyYYpCeY+Yts1pFOHyo
	 pSLTsMDXY7yly3I+vGm718BzpsEUpKVX4rx717tM=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 0/2] KVM: arm64: Small dirty logging fixes/cleanups
Date: Fri,  5 Jun 2026 16:32:46 +0100
Message-ID: <20260605153248.2412064-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

These are two minor fixes/cleanups I found when reading the code.
Although the diff are small the first patch has some implications.
Please view the patches for more detail.

Thanks,

Wei-Lin Chang (2):
  KVM: arm64: Replace memslot_is_logging() with
    kvm_slot_dirty_track_enabled()
  KVM: arm64: Remove superfluous aligning of gfn for dirty logging

 arch/arm64/kvm/mmu.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

-- 
2.43.0

