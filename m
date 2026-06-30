Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E8F8409624
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 12:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782821495; cv=none; b=qW2kcUwp7sOAkwEYUdOaKHjp5xEsre+DF8QZ+NwySDJp3uMr6Vd+Z0/wF4QKXtjBsG4hd87FvzFaR7PnvOwJcI4juNQ6pcKP351YLFWRvLRoW4N40kt756cdwueaxQqozEj7nIAvm1CtEP5qwXqUe/2GDfCvR24sNgEWghOMBE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782821495; c=relaxed/simple;
	bh=28ACkWnLv7YMnNE//WvQjnBg78xe5Fk9GG40vt1q1ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuFxl9IWLYFKoDArmD8nvbTQEAo5PuvooTHvmtxERfg7Y6b7h+90vl9/WCftX9/LNsMaOtTB145BnQcXijL6XAcKP9oV88PAKOsN4nlSiJCDHugDUdKTf0/xnvWeWntO2Ifu8hOHgdqj0ss1c9s4/BBl0a4nQ3ko4DghWZzUl5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lZrVIQJ6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lZrVIQJ6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 477D9175A;
	Tue, 30 Jun 2026 05:11:28 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9032C3F905;
	Tue, 30 Jun 2026 05:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782821492; bh=28ACkWnLv7YMnNE//WvQjnBg78xe5Fk9GG40vt1q1ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZrVIQJ6KwfHxRbspsdaaFLL4JY31qpds++E7hrs7ib/D87PWWSl46Cl/vUvoe79u
	 18xndfqem2wOolzhzsVmMS8Ycd67tHewNOJlgE66vihKtlwBHMUM6LPAu8eiQ5hH02
	 z3luARonf6fMy44CZ0L0EyAVhcU06wWp8XTjZfyU=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Sebastian Ene <sebastianene@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 4/6] KVM: arm64: ptdump: Factor out initialization of kvm_ptdump_guest_state
Date: Tue, 30 Jun 2026 13:10:03 +0100
Message-ID: <20260630121005.1130996-5-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630121005.1130996-1-weilin.chang@arm.com>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extract the code for initializing kvm_ptdump_guest_state to allow
reusing the same instance for dumping multiple page tables.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/ptdump.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 752d8e0cd25c..0c9647666e65 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -112,6 +112,23 @@ static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
 	return 0;
 }
 
+static int kvm_ptdump_parser_init(struct kvm_ptdump_guest_state *st, struct kvm *kvm,
+				  struct kvm_pgtable *pgt)
+{
+	int ret;
+
+	ret = kvm_ptdump_build_levels(&st->level[0], pgt->start_level);
+	if (ret)
+		return ret;
+
+	st->ipa_marker[0].name          = "Guest IPA";
+	st->ipa_marker[1].start_address = BIT(pgt->ia_bits);
+
+	st->kvm                         = kvm;
+
+	return 0;
+}
+
 static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
 {
 	struct kvm_ptdump_guest_state *st;
@@ -129,17 +146,13 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
 	}
 
 	pgtable = kvm->arch.mmu.pgt;
+	ret = kvm_ptdump_parser_init(st, kvm, pgtable);
 
-	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
 	if (ret) {
 		kfree(st);
 		return ERR_PTR(ret);
 	}
 
-	st->ipa_marker[0].name		= "Guest IPA";
-	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
-
-	st->kvm				= kvm;
 	return st;
 }
 
-- 
2.43.0

