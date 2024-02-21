Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0790E3A8D2
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 05:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708494203; cv=none; b=lhfym8akH8m1RMH0yFp4EqTyIubtsLfHUK4+tilfMFDHT5eWGG4GzheZPHSg0MUfMWQvpxez14Ag4rTlCqxgAO0mCzRuPERscpZx6Me7K9OJGZd+RlHSyuxf/lsgRP+6VW8djdNgv0EiHsyT5+gZ4Z05igi1+8TTFVqe2ImVGBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708494203; c=relaxed/simple;
	bh=7Rss8dEy/kleI+VwoacNEfis/mgGm1UZXOe2ZRncC0o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q+B0ib4zF0fs83tIuWKOAoeucYIE1qPOLjrxlFdUFENQIV/1ENhhPP9JRsxZQvmGEgPnUDyLLaanxY4Ag2LFQUhZ2WJjUlQJGZNVe/veKlFWY7kRYLvgpi3E0H/vD9KKYHqpN3/0l+F/DU+Hv8hLxvi3c4ueeJKzThul3Kfl8nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QlIZNZ1D; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QlIZNZ1D"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708494198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R/Or/Yh2fAMtkGN2IdwrHuQeB2WLq6uP7r3G04y+nVk=;
	b=QlIZNZ1DPWCe1i+G3NUfzvZGRnxgOcqyEY/nDbKoZZFAtnXrvqNokC8nAIe74UMerLAVQP
	3PRjEsb9s7Fh6gKlOBloWypS7xAfOouIToj/uuwOZgWdu8NP+TamKP6qQmSTdB5UTVnYEH
	m7WNUpJF6lsl2OzO7+py7MtmhiA1Ue4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 00/10] KVM: arm64: Avoid serializing LPI get() / put()
Date: Wed, 21 Feb 2024 05:42:43 +0000
Message-ID: <20240221054253.3848076-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Addressing a few more goofs that Zenghui was kind enough to point out.
Clearly all of the bugs have been found and addressed at this point.

v2: https://lore.kernel.org/kvmarm/20240213093250.3960069-1-oliver.upton@linux.dev/
v3: https://lore.kernel.org/kvmarm/20240216184153.2714504-1-oliver.upton@linux.dev/

v3 -> v4:
 - Actually walk the LPI INTID range in vgic_copy_lpi_list() (Zenghui)
 - Ensure xa_lock is taken w/ IRQs disabled, even after purging usage of
   the lpi_list_lock (Zenghui)
 - Document the lock ordering (Marc)

Oliver Upton (10):
  KVM: arm64: vgic: Store LPIs in an xarray
  KVM: arm64: vgic: Use xarray to find LPI in vgic_get_lpi()
  KVM: arm64: vgic-v3: Iterate the xarray to find pending LPIs
  KVM: arm64: vgic-its: Walk the LPI xarray in vgic_copy_lpi_list()
  KVM: arm64: vgic: Get rid of the LPI linked-list
  KVM: arm64: vgic: Use atomics to count LPIs
  KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
  KVM: arm64: vgic: Rely on RCU protection in vgic_get_lpi()
  KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
  KVM: arm64: vgic: Don't acquire the lpi_list_lock in vgic_put_irq()

 arch/arm64/kvm/vgic/vgic-debug.c |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c  |  4 ++-
 arch/arm64/kvm/vgic/vgic-its.c   | 55 +++++++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-v3.c    |  3 +-
 arch/arm64/kvm/vgic/vgic.c       | 60 +++++++++++---------------------
 arch/arm64/kvm/vgic/vgic.h       | 15 +++++---
 include/kvm/arm_vgic.h           |  9 ++---
 7 files changed, 79 insertions(+), 69 deletions(-)


base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
2.44.0.rc0.258.g7320e95886-goog

