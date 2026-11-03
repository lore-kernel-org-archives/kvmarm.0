Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.93
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695666;
	b=U/B2oN1LhvX+5ZIyW1uh4o2tjWDMC2pnuDzoF+xi+zM4rYDa8jBGgF8fecSMCp2jKMNK
	 eQhP7nfS+kjO2Vrn3aLzLf4O5ryi5dQ+fiyJ1+74KZcNCyjD9zgrqnsHKXMutpUmYaLly
	 mxR9WrUnZEblnAhdvlH+xCd+oc/pqCwtNP2++MSyx7mhrmX4cfMGHteAUcJ9NVPyFpbfV
	 6Jtllh4E/8Q+/1MkD+QaiIvWnhodU5v1SVefz1SL3MOoaipl+hJiO8NkrEI+iYPQrpDiE
	 iFlyCjaXg5wOZ0oRgCrXFeFQiLWu8ApEJ51+Q+DWPtshkG1Y0QGB/74FDsd3cEbMSaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695666;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XtJiRyro5pp1Ubk31vh+uEkbIHM0qppKB9W3IOPNN0E=;
	b=ouD9enyUX0ozaH9DeK0nlMRTGFTva0EyoSXizRcn18zdNPQCBkXORvSZRlYyaKpJu71Q
	 dV+mHyz56iN/ghHWEaFRK9yYD0UVhSUqgQVifoaJ74AlRFfcMbYc8uUNe/w6BL7dvFBGo
	 S29+0eKH9O4Awz+lTHdflO8MOo0GzQGW9iP5YFY/T7BfqGgxF35+KwPShbCgG50Cfg2WZ
	 yJW1mgvYYLjyJMUyNAnCRGLUnJdw2MSngg9OUL+Bkm0p7krTynhoZoe81hG9e/OZmfNuY
	 jOvEokFiAJRI0jU03mUJOxkrAF6NBtcOBDgL5M9U7UW4suxBPE+ZyIkr06estFxUk7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="aZ/qKBhl";
	arc=none smtp.remote-ip=95.215.58.93
Received: from mta1.migadu.com (out-93.mta1.migadu.com [95.215.58.93])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5411606A95B
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 08:47:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5411606A95B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aZ/qKBhl
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=vxgqiZ0okcZF28/Y6ng3hoY+gPOQ7Ju8Td5h/EbU8As=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793695663; v=1; x=1794300463;
 b=aZ/qKBhlKEc2WXQLYiCL3Yy8XT146ylvR7IJx0CfEBuBYqUSNrxd51Y1kNTNkFqLB+dEug7G
 GdeizSkTbDL/1Uir2Qv+3/UnT/7NUSUiKeMUifbYjyK4dUGWycHEfs1k3Y4r40S9/l9OHOcFH9D
 n8N6xmgJo2YzgOI46a4gbYDM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d3cf5bf9ecc66116;
	Tue, 03 Nov 2026 08:47:43 +0000
X-Mizu-Trace-ID: d3cf5bf9ecc66116
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 2/3] KVM: arm64: Skip empty IPA ranges when destroying stage-2 page-tables
Date: Tue,  3 Nov 2026 08:47:41 +0000
Message-ID: <20261103084742.1302597-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103084742.1302597-1-fuad.tabba@linux.dev>
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
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

The page-table walker steps over an empty entry in one go, but
kvm_stage2_destroy() starts a new walk for every block-sized chunk of
the IPA space. Tearing down a VM that requests a 52-bit IPA then takes
2^27 walks with 16K pages (2^22 with 4K), however little it maps.
crosvm requests the host's limit.

After destroying each chunk, look up the entry at its start and, if it
is empty and larger than a chunk, skip its whole range. The lookup reads
fields that hold the mapping tree on a pKVM stage-2, so this depends on
the previous patch keeping pKVM out of stage2_destroy_range(). For the
same reason, call kvm_pgtable_stage2_destroy_range() directly rather
than through KVM_PGT_FN().

Fixes: 4ddfab5436b69 ("KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 42977cf8a7f5d..10b425a0141be 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1010,9 +1010,20 @@ static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
 	u64 next;
 
 	do {
+		kvm_pte_t pte;
+		s8 level;
+
 		next = stage2_range_addr_end(addr, end);
-		KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
-							     next - addr);
+		kvm_pgtable_stage2_destroy_range(pgt, addr, next - addr);
+
+		/*
+		 * The walk freed every table it emptied, so skipping an empty
+		 * entry here doesn't leave anything behind.
+		 */
+		if (!kvm_pgtable_get_leaf(pgt, addr, &pte, &level, 0) && !pte &&
+		    level < KVM_PGTABLE_MIN_BLOCK_LEVEL)
+			next = __stage2_range_addr_end(addr, end, kvm_granule_size(level));
+
 		if (next != end)
 			cond_resched();
 	} while (addr = next, addr != end);
-- 
2.47.3

