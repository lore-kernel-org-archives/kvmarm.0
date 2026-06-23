Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84BC385D7F
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 14:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782224735; cv=none; b=cTDzhKdX7RqOH0tCpr2FCGf971mSjM+MF3I8JF8n9fAgADw39x0rRGUBKHYFLf0hf2iL2Y7lGLF5LYIcZo/KJxhX3DBPGn69egN5XesUMlf1/gHYNWeEeXEfA4Da7PJWMC+JPbU9aa9x1+v+9o+GEAzwIRfFE8kVJLnB+Dgu+98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782224735; c=relaxed/simple;
	bh=fS10gyJD6hNVDlRCTCWqDlUxTE/CIecxG3GG47Iz4Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdJNL9Jifg7M+Cp4db379TYHJPiQk0bIzXQyuYmZDfZfew1WTEPRaJdZ6jpjcwS87x96jLpbhAwkKshWioIx37ZPcDQxn4bdSeS+x17X0IivWhgbgLfcZtGyjsPGqriK0DiC+n6Ml6IgDAVeELy6hlZKZMyto8J7O29BrdRB2G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qybuawIi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qybuawIi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97CF328FA;
	Tue, 23 Jun 2026 07:25:28 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D7913F632;
	Tue, 23 Jun 2026 07:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782224733; bh=fS10gyJD6hNVDlRCTCWqDlUxTE/CIecxG3GG47Iz4Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qybuawIiH4rO53oExfEHonQMUk6QW6NJ0OAPdfw6j/19po5bj0q9g4rkA7jwcZ1e1
	 l3C6DbUardHveWQwDovZqlkiUpPUPDBS4ORBbTWAFN7beN9dojQ3TaGCvKFKRxtO7a
	 QFMVKC8zbRqiQQtDErdFGijSLITt6U4RKXzqkxwo=
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
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 2/3] KVM: arm64: ptdump: Store both mmu and kvm pointers in kvm_ptdump_guest_state
Date: Tue, 23 Jun 2026 15:24:42 +0100
Message-ID: <20260623142443.648972-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623142443.648972-1-weilin.chang@arm.com>
References: <20260623142443.648972-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the nested case, the nested mmu could be freed when .release() is
called, e.g. another process closes the ptdump debugfs file after the VM
is destroyed. This causes a UAF when the nested mmu is accessed to reach
kvm for kvm_put_kvm(). Store the kvm pointer in kvm_ptdump_guest_state
so that it can be reached without going through the nested mmu.

Fixes: 204f7c018d76 ("KVM: arm64: ptdump: Make KVM ptdump code s2 mmu aware")
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/ptdump.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 2a6afe67646a..a089e87ea366 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -19,7 +19,12 @@
 #define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
 #define S2FNAMESZ		sizeof("0x0123456789abcdef-0x0123456789abcdef-s2-disabled")
 
+/*
+ * Nested mmus could be freed when .release() is called, so also keep the kvm
+ * pointer for kvm_put_kvm().
+ */
 struct kvm_ptdump_guest_state {
+	struct kvm		*kvm;
 	struct kvm_s2_mmu	*mmu;
 	struct ptdump_pg_state	parser_state;
 	struct addr_marker	ipa_marker[MARKERS_LEN];
@@ -133,6 +138,7 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm_s2_mmu
 	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
 
 	st->mmu				= mmu;
+	st->kvm				= kvm_s2_mmu_to_kvm(mmu);
 	return st;
 }
 
@@ -197,11 +203,10 @@ static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
 
 static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
 {
-	struct kvm *kvm = kvm_s2_mmu_to_kvm(m->i_private);
 	void *st = ((struct seq_file *)file->private_data)->private;
 
+	kvm_put_kvm(((struct kvm_ptdump_guest_state *)st)->kvm);
 	kfree(st);
-	kvm_put_kvm(kvm);
 
 	return single_release(m, file);
 }
-- 
2.43.0

