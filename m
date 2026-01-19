Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E046435A95D
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826825; cv=none; b=XP6kBq5x7bFdR1vvQZUoGsgKGIqeSfYrCO8n0stWbu+ZB9ijXVZiApQNyCdQYwsp3Gi0TEx87gLXJVgTGJIjKJ5/V/HA/vheHx0/TDH25tosEX/plC2IDbRf7gnW4aZqSzXU0oNpeQBuA//in1AQulJNnaLeNa/0Fgjp38eUXdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826825; c=relaxed/simple;
	bh=2+LcJX/Rz6JPf9TJu094PPQNVVu1RCDNwM5c6888gNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKATo2Tmg9B1u+NgF5cTZHp8S9oQSfLjdf8jJXWvFH9jQYevoSU/I3EJI+MtZOFKFxDOxgZomHHQvQbSIWErrM6j4XkhhpKCT0VHdEfUuPvmIdDM8y7oHsCehHwoFUOBPF4+ODdt+bzyp9Xmnb0aPUt/5cIQ5BooN/XFZZVOqTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5/fYxto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5/fYxto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD19C19424;
	Mon, 19 Jan 2026 12:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826825;
	bh=2+LcJX/Rz6JPf9TJu094PPQNVVu1RCDNwM5c6888gNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5/fYxtoldCQ+6jpqWI+TUncRicHcGvvEW6cySLqXPWLGNvL5E7t7y+T4yHBZoG61
	 BBNeTa3wQxOg1PFhx/2mqI6S/lmU0rGVZA8CzpUFrRoj8SzPw7Bgoy5Y4SJFaWMP7V
	 CBxE/FX0f+/CvYmxdTyxog9o0lShEA976/nzS4olfOFVPR1HP7GMnx9dUni6PVuSHf
	 QbfYVlLnv1lbbM0MqauSb6yIkCM11X+coDNbUSM2hKD3wXCtPF5RKZvSY9xiMmerSs
	 Hz227th363S+G1/qx0+uyyslaHARyGxHx54L9DscQi01cGYelRg82wEiHDosTWUHaH
	 5d8EX8IHYMrNA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 04/35] KVM: arm64: Rename __pkvm_pgtable_stage2_unmap()
Date: Mon, 19 Jan 2026 12:45:57 +0000
Message-ID: <20260119124629.2563-5-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding support for protected VMs, where pages are
donated rather than shared, rename __pkvm_pgtable_stage2_unmap() to
__pkvm_pgtable_stage2_unshare() to make it clearer about what is going
on.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/pkvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 7797813f4dbe..42f6e50825ac 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -322,7 +322,7 @@ int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	return 0;
 }
 
-static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 end)
+static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64 end)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
 	pkvm_handle_t handle = kvm->arch.pkvm.handle;
@@ -350,7 +350,7 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 	if (!handle)
 		return;
 
-	__pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
+	__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
 }
 
 void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
@@ -386,7 +386,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			return -EAGAIN;
 
 		/* Remove _any_ pkvm_mapping overlapping with the range, bigger or smaller. */
-		ret = __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
+		ret = __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
 		if (ret)
 			return ret;
 		mapping = NULL;
@@ -409,7 +409,7 @@ int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(pgt->mmu)->mmu_lock);
 
-	return __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
+	return __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
 }
 
 int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
-- 
2.52.0.457.g6b5491de43-goog

