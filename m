Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865377;
	b=icFUvAXtYjO6MVWRXB8aqnzo8WBhKqc1lFnBHUJP3GabQXiLTyD7/7oAgesI5t30vw0w
	 qdaqVntnpPf8ETN5oZILlS1QVSPSDuCc1Vx1NylPTleZnC0mVAnPRLwTczb6A5b24eD8M
	 xwl1RDv7B8CsOjoDK2mhDhqpcvE7Kh+6CABrs0OdLOxxAhFTmw0+r78jjxwwAcldOuJj2
	 nzLj4UUuMNa+hGd2MxVPa+mzSgk9BwK5rCu7osjTxBGmtxzAfsSj+vAdyX1h54JyDytv/
	 OJZVI3o5q5KHuc083XvGn/D2DtG7EvbzB/GLTGkSRC4IoXV36xLCypxuQL+KqTC8jgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865377;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xAxX/hOOVgl9MP4qMrRYqYmI6pYWtxVRbAVic/Kn+0I=;
	b=Q3HsasK/hishHoeoLCyJISeO+ybLBq7xahJe+mH+4k7fOh/r+LV7QaMN97X4IONFzOsx
	 BaTsnZSrBjWMVHK18D0K/RxmaS44UM/PqfMNuH2173ic19Cch9YERQn0P+9iZmTg6O91I
	 73VfVKKekjQpuyCok2q4plm6BZZfurOqpFRJx5e8o3XvD+R0OEfbg7iboVX3XgkE7rjQ4
	 06VLa0jr7koe52ox+uaAFLV7Xpk22S+4UGjKCy+J00YNHBgqtZEuTE8kNOQ3s0YzYaw4a
	 +KHygATvomf6hXCUMJ1FDldQJ6hiiHsnISDR07CN1c3IJ5MVZ22DQCi+vhNYvLIeB3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MbMaG9T5;
	arc=none smtp.remote-ip=95.215.58.139
Received: from mta1.migadu.com (out-139.mta1.migadu.com [95.215.58.139])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F336606A339
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 07:56:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F336606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MbMaG9T5
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qVD1PACKjTczzGaztvFKYuRGh7H3JFoR6xRbscqjfaA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793865373; v=1; x=1794470173;
 b=MbMaG9T5UXK30o8GXml7xw621m+pew8SJ24tmEZAQ9lcD/0xMidgs8V7BCqGrIy7eWJ6+Dsf
 euApyX5L0zFg9K1CYK17dEjPSwcq1MHcDogUkgKs7Imt2GEreaH6fxgMt5N4efECoqTGJjbj0Lx
 xMm1nrEeIY1Guhbt4rWE1JO8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 556cd0a12ca46ba7;
	Thu, 05 Nov 2026 07:56:13 +0000
X-Mizu-Trace-ID: 556cd0a12ca46ba7
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Martijn Bogaard <martijnbogaard@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: arm64: Align the pKVM selftest VM's stage-2 PGD
Date: Thu,  5 Nov 2026 07:56:05 +0000
Message-ID: <20261105075606.367005-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105075606.367005-1-fuad.tabba@linux.dev>
References: <20261105075606.367005-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CONFIG_NVHE_EL2_DEBUG, pKVM init sets up a selftest VM whose PGD is
the start of its 32-page block. That block is the first allocation out
of the hyp reserve, which falls back to page alignment when its
PMD-aligned allocation fails (512M on a 64K host).

A PGD of concatenated tables must be naturally aligned, or the VM's pool
never coalesces it into a block hyp_alloc_pages() can return. So when
the reserve isn't aligned to the PGD's size, the allocation in
guest_s2_zalloc_pages_exact() fails and pKVM init panics. A 64K host
with a 44-bit PA has a four-page PGD, and on a 1G QEMU VM the reserve
landed at 0x7fae0000.

Take the aligned pages inside the block instead. The pages either side
of it go to the memcache and the pool. The PGD is at most 16 pages, so
it always fits.

Fixes: 48d5645072930 ("KVM: arm64: Extend pKVM selftest for np-guests")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 03e530e15b4a2..820baf9ff74a2 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -847,10 +847,14 @@ struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
 {
 	struct hyp_page *p = hyp_virt_to_page(virt);
 	unsigned long min_pages, seeded = 0;
+	void *pgd;
 	int i;
 
 	selftest_vm.kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
-	WARN_ON(kvm_guest_prepare_stage2(&selftest_vm, virt));
+
+	/* A concatenated PGD must be naturally aligned for the pool to coalesce it. */
+	pgd = PTR_ALIGN(virt, kvm_pgtable_stage2_pgd_size(selftest_vm.kvm.arch.mmu.vtcr));
+	WARN_ON(kvm_guest_prepare_stage2(&selftest_vm, pgd));
 
 	/*
 	 * Mirror pkvm_refill_memcache() for the share/donate pre-checks;
-- 
2.47.3

