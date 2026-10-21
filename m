Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.229
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580828;
	b=qpoGe69ckRUowu5TO05tI4a8eKp0rfp4PrOfhcUPQHNaFZVFIPTf46xiIMciuEzTLhEd
	 JA2PLyWx91cbwYzuWbacBXF2gTgjcVKk2zvRtccOFRFkcDJLCCNy7JBmcBu4jqg/j8GD3
	 2FfSxtZZfQQVmEKmfZn2tpctUSyBAehZ5GZZdg+9mu3h/IACgPpQxbE+ER2VKI/q8JieM
	 XgxYxvlH9QnOdgU4Gbeij1SIgkslK3kUu+6BKD/gviNtxghpOJLIw3ROVphHPlL7DhHKb
	 b1mvch8Peol4qGSnPztROB3UfAOSCAHnCz3CIUFybtNJe137GAYoUV4tWhEopY8AXGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580828;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=/Lx6DShk9reJacpbaAFxTHNuqC347ivhuY9XrUZ9h1Q=;
	b=Nnca5xjCL5hqusglPukYqLnCOtuxyG4QHdmU8JdJ0uwg98G0yNl4QoyUEvuiQvOjDPUj
	 CZhn0fFoLpA7sDJia8w17sJv3HTyv219TZslqsK094frfsO8F5NA+QANTzf9Orcw4Z7Lb
	 eThVqdROCgnF5GWyOl9nrZ+d/2z6m0+yHL3QF+FQ4eTpyvSqHXM/PKGTOn3maNBXYwM/9
	 lD2p96vzEpKxU85q46vNMzGZC7xCzFQwjMXvgy/uRsA6OueHtFw6GZ2fb8f5VKKYV1wMS
	 JibrRHsCUZ+5wFaHSyCbYm5niU+vrLj43RvUlIbVkOY1/GAlc/jQ0wlLqGhINaDp34A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eWdl5Unh;
	arc=none smtp.remote-ip=91.218.175.229
Received: from mta0.migadu.com (out-229.mta0.migadu.com [91.218.175.229])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5624D606A31E
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 11:07:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5624D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eWdl5Unh
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=S4bD+01K5/KhrqQzm+KUd+2uczOY+o8D7HdNxOh0FzY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792580825; v=1; x=1793185625;
 b=eWdl5Unh0QbJSum1DTWrzU1OMHs8bda11JkV+h6l6Da8OvokmBxGo1PhZy5KN67+4V2/I4kY
 gNhAOMFoznERIl+V2tAzu0/supNaU3ILKAUx1Wz+Zuih7ZCLE1vtzbJGvEsORoi33IUlAE7fvij
 4pxhHsCB0gsJvE5KAcf2PMCM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b5ddc05ed2452df9;
	Wed, 21 Oct 2026 11:07:04 +0000
X-Mizu-Trace-ID: b5ddc05ed2452df9
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Price <steven.price@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: arm64: Fix stale MTE tags reaching a guest
Date: Wed, 21 Oct 2026 12:06:56 +0100
Message-ID: <20261021110700.493315-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
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

Hi folks,

Changes since v1 [1]:
  - Added patch 4, mte_clear_folio_tags(). (Lorenzo)
  - Moved patch 3's sanitise_mte_tags() call into the
    kvm_pgtable_stage2_map() branch. (Lorenzo)
  - Patch 1 loops with folio_page() rather than reusing page, and its
    comment now matches patch 2's. (Lorenzo)
  - Collected Reviewed-by from Lorenzo on patches 1-3. (thanks!)

Three fixes for hugetlb and THP pages that reach an MTE guest without
their tags cleared, so the guest can read whatever tags the pages'
previous owners left.

The first clears the whole of a hugetlb folio before marking it tagged,
rather than only the pages being mapped. The second does the same when
KVM_ARM_MTE_COPY_TAGS copies tags into a page. The third sanitises when
a permission fault installs a THP block, and runs the VM_MTE_ALLOWED
check on permission faults too. A VMM that maps guest memory with
PROT_MTE isn't affected, as faulting that memory into its mapping clears
the tags first. QEMU and kvmtool map it without.

The fourth is a cleanup: it factors out the first two patches'
folio-clearing loop into mte_clear_folio_tags(), which mte_sync_tags()
now uses too.

I have a reproducer that reads the previous owner's tag from 511 of 512
pages in each case. With this series applied, it reads none.

Based on Linux 7.3-rc3 (fd73f4a665989; also applies to kvmarm/next
dd0bc00e3e920 with a three-way merge).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261019132103.3836646-1-fuad.tabba@linux.dev/

Fuad Tabba (4):
  KVM: arm64: Clear the whole hugetlb folio when sanitising MTE tags
  KVM: arm64: Clear the whole hugetlb folio when storing MTE tags
  KVM: arm64: Sanitise MTE tags when a permission fault installs a
    mapping
  arm64: mte: Add mte_clear_folio_tags()

 arch/arm64/include/asm/mte.h |  4 ++++
 arch/arm64/kernel/mte.c      | 15 ++++++++++-----
 arch/arm64/kvm/guest.c       | 11 +++++++----
 arch/arm64/kvm/mmu.c         | 13 ++++++-------
 4 files changed, 27 insertions(+), 16 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.47.3

