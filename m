Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D9739DBE9
	for <kvmarm@lists.linux.dev>; Sun, 10 May 2026 14:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778424865; cv=none; b=boRGixh7gV3/SK9tn1Oc/U0VGtxXb8TcTSTocwr9D6J6Oz1I23VBO1M8Iq2++2x4vlEHm2jQS0UYhgJPjU6xxa9KGrNW6QkYP+bGunz+FNvzIzpctdr3gPnJrQgtP3yWg0hUzaxfJISiOembQXKTDuhFmK/j07bNMGqjPNIsPh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778424865; c=relaxed/simple;
	bh=uk0eSquGGjcstKJbba70+RhN+eJ4xKDzik20lhfjNtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F67R0hIztB62A4PIouX/n7P77LrCzekrQrzSOaCK6ScopqTehIbNXp8BPfEd7f/1jwOowOBU2Pp00D909nbFEaVLOlkzUndK/9BFRpmMDagHxBi/KJU3X5D9rNCQYF0l7aFIWlvfZeK/XHcxqqkt6n3HJl1hagFiCP2XkO0clYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q2eMloWX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q2eMloWX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36B1228FA;
	Sun, 10 May 2026 07:54:13 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25B0C3F836;
	Sun, 10 May 2026 07:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778424858; bh=uk0eSquGGjcstKJbba70+RhN+eJ4xKDzik20lhfjNtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2eMloWXtpOSzZYz4AQ44H/DWTx0bvACoXQ+WUgU/0tTPnrvVXDAzbhctBDWaPtGR
	 8QFnsqI7rU59xnQdcHSO/xiZQYE5mTE2ZpkYr/j3n5ehHOfnV2hro4Mi/9d+1QCjMk
	 EJ6ttFTf/V52tlfViLCFn2FZnvGeIjQzCnxa4FLg=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 2/5] KVM: arm64: Move shadow_pt_debugfs_dentry to reduce holes in kvm_s2_mmu
Date: Sun, 10 May 2026 15:53:35 +0100
Message-ID: <20260510145338.322962-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260510145338.322962-1-weilin.chang@arm.com>
References: <20260510145338.322962-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dentry pointer shadow_pt_debugfs_dentry was placed between two booleans
in kvm_s2_mmu, which created unnecessary holes in the struct. Move it so
the two booleans connect.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 851f6171751c..1a56d137df10 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -217,16 +217,16 @@ struct kvm_s2_mmu {
 	 */
 	bool	nested_stage2_enabled;
 
-#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
-	struct dentry *shadow_pt_debugfs_dentry;
-#endif
-
 	/*
 	 * true when this MMU needs to be unmapped before being used for a new
 	 * purpose.
 	 */
 	bool	pending_unmap;
 
+#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
+	struct dentry *shadow_pt_debugfs_dentry;
+#endif
+
 	/*
 	 *  0: Nobody is currently using this, check vttbr for validity
 	 * >0: Somebody is actively using this.
-- 
2.43.0

