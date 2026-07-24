Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A56D93CFF68
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 18:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784919298; cv=none; b=oQBWbM9KdAryrPvXlzG8qPrtFrLTs43u3O1BTogUcnsV+7Ith8AUoZy0PZ4Rnd+fXVEwdM9IToQKbyjiEOcosm6WAc2ECoJNxQFoe1pRK9c/ETuVwFH2rUDjUSJdQmi8jrCxmZaFHQ6SWxjhYNBLe1wRt6cAgL5vAVksULP0OWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784919298; c=relaxed/simple;
	bh=gSfRHphoobs3FjVjS72N5dOppPN+9Oy9JjWdfUQiYk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Meqo3pUtl29ViBvdKtI6X5iuCBP60ZEiAdSS3CJVmV6tEcOdiEqmDxbW2RcsuQib5PoOk21EIGgQAE0DBAIE1YJlwAF4jWG77kM4z75b86FmZmkG4q/0B7AmRNeogRCXguvHEB3XQ00tYAyMGO+GljPS7UDTjhYYuNdmRuWN6v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QM5RKC8Q; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QM5RKC8Q"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1B581684;
	Fri, 24 Jul 2026 11:54:51 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5144A3F66F;
	Fri, 24 Jul 2026 11:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784919295; bh=gSfRHphoobs3FjVjS72N5dOppPN+9Oy9JjWdfUQiYk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QM5RKC8Q7q4tqPKjgYKjRsAe2jI1PdkmQIBw7RbVKHBLKyYmVw4u6JC3c7a6W8tHv
	 HF87AYKM3MGaAR23HBposi+OkYcSeemna1ANgGsrx39+1UeMKXOcGePa5yc5zIOaPT
	 OdHgbGZah4bVcJiRL2J2PyCbxM5dW0CfnsbafQ4I=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Matt Fleming <matt@codeblueprint.co.uk>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Sashiko AI <sashiko-bot@kernel.org>
Subject: [PATCH v2 2/2] KVM: arm64: ptdump: Flush the last region
Date: Fri, 24 Jul 2026 19:54:31 +0100
Message-ID: <20260724185431.2990395-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724185431.2990395-1-weilin.chang@arm.com>
References: <20260724185431.2990395-1-weilin.chang@arm.com>
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
expects ptdump_state.range[] to be initialized to the range of the
address space, so also do that.

Also change the second marker's start address to ULONG_MAX so we never
cross it. This avoids dumping redundant marker names (which are NULL),
and advancing beyond the end of the marker array.

Fixes: 7c4f73548ed1 ("KVM: arm64: Register ptdump with debugfs on guest creation")
Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/kvmarm/20260630122758.891011F00A3A@smtp.kernel.org/
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/ptdump.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index c9140e22abcf..222577163d2b 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -130,7 +130,7 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm_s2_mmu
 	}
 
 	st->ipa_marker[0].name		= "Guest IPA";
-	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
+	st->ipa_marker[1].start_address = ULONG_MAX;
 
 	st->mmu				= mmu;
 	return st;
@@ -148,18 +148,26 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 	};
 
+	guard(write_lock)(&kvm->mmu_lock);
 	st->parser_state = (struct ptdump_pg_state) {
 		.marker		= &st->ipa_marker[0],
 		.level		= -1,
 		.pg_level	= &st->level[0],
 		.seq		= m,
+		.ptdump		= {
+			.range = (struct ptdump_range[]){
+				{0, BIT(mmu->pgt->ia_bits)},
+				{0, 0}
+			}
+		}
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

