Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793971811;
	b=3t/ty0dWhFzE/g2LCVbJRH/xbBemk8ZciLWM6pcenZNFZXrp50Tfrfb6wvnv9rgcw7Yq
	 fcAtOTFo+hGfD+WA86ED+o1V75LH+EeoauD9QN2wNzxpDM9P8twTvfSyZaIcWU0wtbWtg
	 pG4wqhglCc5mjceWhirvWTG/WNmJX0Ytwf9AAVM3IxYKRCDh9O8zH8MI/LtPtYmyvH+4w
	 qVhz1SlY00viEwg1qCLJXGyLV/nHcfMIBR+dAYUia1uXLKdvezeMPF35fcB2AWVb22HuH
	 n+P5m4prrCmrA2aOjIL6mPdfIvZ8KEzG1+P3JyJMt1uzZ8PblV7oyavXEsBhN+NiaGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793971811;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=e/3XraEN+4mKAfyytUe7hFO8nk3KHRIKouz+zhkXDN0=;
	b=eng9i9wM+6gD80puHhxS2pz1F7LaXAghJgd/5RQdjSuxRuzDNXAEbUTULzHf4MoF+6Ks
	 zvipUOmraiKUssDCwVqb8TCp3rCpUVa2W4w872z+v7SUtHX7Qr6JENiUAEaJlcQJYA4pH
	 nVjxhcLWueVlYFCFnIDKb5wH+KB1mCK6MhtUeYYQiozrUrB9A4UZgtPTVMUd0fodd20sL
	 8Sww5Cet6SsIBVzKxwm7EoSNcxisoZKglip+2Q0/NaLNsUkCy1mW0VQ7MoFnodhEjkFa1
	 IdMnRFJI8gcuY/1EM7CpiNijeCvfKnNDwz8iRhM/Ye+tmiqkV1Nu6FmG05STugQ1n5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XN36poyH;
	arc=none smtp.remote-ip=95.215.58.135
Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91288606A33D
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 13:30:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91288606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XN36poyH
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=n4Vsow1U4/zPQT8BxxJgvfPhA9r/J78hKay9DbA/hws=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971808; v=1; x=1794576608;
 b=XN36poyHustH0MlLVgJjXZJY36PK5Gt1ynzAroBdRznA0OKgtvf3zjkFWf42BQx8BDrA+Lrs
 Ow9mVDR8pw8AytTAbYHfi+CytMkJvgYEMza3tUep7pUU++ky2ddpoxZXJC4pPZLlsdVWsFznv/A
 rkFpCDxVanGpoRtHkiItslXo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f286758a8028908b;
	Fri, 06 Nov 2026 13:30:08 +0000
X-Mizu-Trace-ID: f286758a8028908b
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
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 2/2] KVM: arm64: Resume a pKVM stage-2 teardown at the next mapping
Date: Fri,  6 Nov 2026 13:30:00 +0000
Message-ID: <20261106133000.453240-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106133000.453240-1-fuad.tabba@linux.dev>
References: <20261106133000.453240-1-fuad.tabba@linux.dev>
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

pKVM keeps a VM's stage-2 mappings in an interval tree, and
pkvm_pgtable_stage2_destroy_range() releases the ones in its range.
stage2_destroy_range() still calls it for every block-sized chunk of the
IPA space. As pKVM gives every VM the host's IPA limit, a teardown with
LPA2 makes 2^27 calls with 16K pages (2^22 with 4K), however little the
VM maps.

Return the address of the next mapping instead, or S64_MAX when none is
left (U64_MAX would read as an error), so that the teardown skips the
space between mappings. No mapping crosses a chunk boundary, as pKVM
maps at most PMD_SIZE, so the next one starts at or above the end of the
range. A VM without a handle doesn't have anything mapped, so return
S64_MAX for it straight away.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pkvm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index d0a6308008512..ef36875e25610 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -504,9 +504,10 @@ s64 pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
 	pkvm_handle_t handle = kvm->arch.pkvm.handle;
+	struct pkvm_mapping *mapping;
 
 	if (!handle)
-		return addr + size;
+		return S64_MAX;
 
 	if (pkvm_hyp_vm_is_created(kvm) && !kvm->arch.pkvm.is_dying) {
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_start_teardown_vm, handle));
@@ -518,7 +519,9 @@ s64 pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 	else
 		__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
 
-	return addr + size;
+	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr + size, U64_MAX);
+
+	return mapping ? gfn_to_gpa(mapping->gfn) : S64_MAX;
 }
 
 void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
-- 
2.47.3

