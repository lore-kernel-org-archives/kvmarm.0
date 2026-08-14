Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44C5D3955D3
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 22:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786746338; cv=none; b=kLptygLmHJkPYMVKp6gM3OKdUGM73V9oPJcj53UGg7iXwB2lnHjZMIXe+5N4vJXCMWbsHNZ5lxzsr4k0P/VSw3d+jg/gEhG7TFF6Y/uL7vVyYq3I2UMYcWV8BZlzakTT9l12tzkG4Stj8Sc4ThAT0yN1jqSQi16FM+ijo7i8q/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786746338; c=relaxed/simple;
	bh=cp6X2PC6hanfxlcfE8eqlqn45EQleE/ymqq4QgCE/js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSZ7ciC3qFGX+8z/EEmMyJIjNzzo05UX2TFrHFWhnNVN+H0HbRe+nkdbSgysZjBq7L5RaWgT7spdaxP45lWCLeWF3jDojA4i/8iIO1vAhzNfW4BfHZ+SObIUIQ+mVRVO8Iz5PLKw6IASrKaRlRbT6zvr2pPfO+x9xWXa9x1JJr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DswiL5Bb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DswiL5Bb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 947F71BCA;
	Fri, 14 Aug 2026 15:25:28 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27B533F632;
	Fri, 14 Aug 2026 15:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786746332; bh=cp6X2PC6hanfxlcfE8eqlqn45EQleE/ymqq4QgCE/js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DswiL5BbdZ11TQuaCVj/2Ttu/yRoBmOzYsrGG+J87q8kO1QG0k4D1gECni9Fk5gnp
	 E6aMO2f2parjbXOfO8uutwt0oX5wXYYYQBeicWUj0eTZJ2Tq0BOjPlYNccLdIiKlVC
	 eqfEr6Dekto5DIjL/AaCCI+KqE79GCigeyWhto58=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Fleming <matt@codeblueprint.co.uk>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Sashiko AI <sashiko-bot@kernel.org>
Subject: [PATCH v3 2/2] KVM: arm64: ptdump: Flush the last region
Date: Fri, 14 Aug 2026 23:24:58 +0100
Message-ID: <20260814222458.584906-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814222458.584906-1-weilin.chang@arm.com>
References: <20260814222458.584906-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the stage-2 ptdump calls note_page() at each leaf entry visit.
This simply misses the output of the last region, because note_page()
only dumps output when it detects a change in level/prot, or when the
walk enters a next marker section. The last region in the guest IPA
space with the same level/prot is not dumped since there is no change
after it.

Call note_page_flush() to dump the final region. note_page_flush()
uses ptdump_pg_state.end_address to call the final note_page(), so also
provide the end address.

Also change the second marker's start address to ULONG_MAX so we never
cross it. This avoids dumping redundant marker names (which are NULL),
and advancing beyond the end of the marker array.

Fixes: 7c4f73548ed1 ("KVM: arm64: Register ptdump with debugfs on guest creation")
Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/kvmarm/20260630122758.891011F00A3A@smtp.kernel.org/
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/ptdump.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index c9140e22abcf..69899797dbad 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -130,7 +130,7 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm_s2_mmu
 	}
 
 	st->ipa_marker[0].name		= "Guest IPA";
-	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
+	st->ipa_marker[1].start_address = ULONG_MAX;
 
 	st->mmu				= mmu;
 	return st;
@@ -148,18 +148,21 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 	};
 
+	guard(write_lock)(&kvm->mmu_lock);
 	st->parser_state = (struct ptdump_pg_state) {
 		.marker		= &st->ipa_marker[0],
+		.end_address	= BIT(mmu->pgt->ia_bits),
 		.level		= -1,
 		.pg_level	= &st->level[0],
 		.seq		= m,
 	};
 
-	write_lock(&kvm->mmu_lock);
 	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
-	write_unlock(&kvm->mmu_lock);
+	if (ret)
+		return ret;
+	note_page_flush(&st->parser_state.ptdump);
 
-	return ret;
+	return 0;
 }
 
 static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
-- 
2.43.0

