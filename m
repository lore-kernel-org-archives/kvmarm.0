Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E0C1EDA02
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738855273; cv=none; b=tpuwXKCR0ZFTRW5dtuzsQMjczE8iQIc94M5dXRN2TmGSlrPyhRdQlgslr7Su5o2XbQWw2tu8ie1eKA72YHvjUJi07K9b5hnpYzDdILnOER6RKMywbKU/ug+xQdLXv3qPcql/xrAFqLmHjh95tAKS4xMGqPApL2tM9suiCKDp/38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738855273; c=relaxed/simple;
	bh=eQlGH64WFsKvyNl+JJp7HVJjAWxwJIxovk4rzFV0bm8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Vpd28FeWLhWNYxrjD2fydtgPu2kwnHdr3Somk/I3JvlXxhD5LkVaWWVHIdbBmfS0CgZavlywRqo/NFWldgOunXYcaNDYci4HivucmGn2RZOl/LbE17tbmcnMLsBxchbjFkK5WNqWmmPYqcHIWBWnKS6IWOrmnfn+Gv9UhqwX0A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUg/B5Md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUg/B5Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7928C4CEDD;
	Thu,  6 Feb 2025 15:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738855272;
	bh=eQlGH64WFsKvyNl+JJp7HVJjAWxwJIxovk4rzFV0bm8=;
	h=From:To:Cc:Subject:Date:From;
	b=JUg/B5MdF3LXUE4kZ7v8Xz5nVXk8k5lrUOA0BPQE7D/6fu53KfWkrLtFA6pA/TBQb
	 L9s9Zg1BKhoVEiL/xD+socdW1LOERAHYZJznzwwwduKz4FTASjmGK46hi1FS9UiOBM
	 HC+8RIsPCopfD/7eBPojmizx4EbtsBeS5IGco6uTC+dyjWoTcZyJmCSMpRWcsKUS82
	 pr1gUFJxASd1IkCW2A7gvwZ+U6txJWuNgxNFiC+oFUiE8eXllgMN1k+a1VapjRmB8t
	 AdN5BmXzVNRkLi8oFPCMqXRAoxuyDNaRSbEwCbMxZGPHXcIPx8wdM4DiAhEj/WfV9Z
	 JGbvhiRS+IkXQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg3gk-001Axu-0A;
	Thu, 06 Feb 2025 15:21:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Alexander Potapenko <glider@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/3] KVM: arm64: Assorted vgic fixes for 6.14
Date: Thu,  6 Feb 2025 15:20:57 +0000
Message-Id: <20250206152100.1107909-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, glider@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Alexander, while fuzzing KVM/arm64, found an annoying set of problems,
all stemming from the fact that the vgic can be destroyed in parallel
with the rest of the guest still being live.

Yes, this is annoying.

Fixing this is not going to happen overnight (though I have some
ideas), but we can make what we have today a bit more robust.

This is what patch #2 is doing. Patch #1 is just removing a loud
WARN_ON() that serves little purpose, and patch #3 fixes the actual
bug that Alex reported.

Hopefully, none of that is controversial...

Marc Zyngier (3):
  KVM: arm64: timer: Drop warning on failed interrupt signalling
  KVM: arm64: vgic: Check for unallocated PPI/SPI arrays
  KVM: arm64: vgic: Gracefully handle resetting an unallocated interrupt

 arch/arm64/kvm/arch_timer.c | 16 +++++++---------
 arch/arm64/kvm/vgic/vgic.c  |  7 +++++++
 2 files changed, 14 insertions(+), 9 deletions(-)

-- 
2.39.2

