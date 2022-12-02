Received: from out-240.mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD0D4C8E
	for <kvmarm@lists.linux.dev>; Fri,  2 Dec 2022 19:26:25 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670007149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m5/0ZswNwgSJxP0pUMVY0+4NluAB70GQeaBLsW+AvoM=;
	b=BWVsnn8YRvzHQkRDkssOV+GGDtLI9N13an/VllrSUa7NSf5DViJNMvV5pDptDQuC0BvQvd
	v5RHoXV/YeZPcoDowAdvpr83VkUHJbAS76GbVtHvLA4FQ5kHZniQLDT1A0KGtcZewy4uaq
	rqVIQYOMD+MlfNaOJoXftx57B6fc2KU=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] KVM: arm64: Condition HW AF updates on config option
Date: Fri,  2 Dec 2022 18:51:56 +0000
Message-ID: <20221202185156.696189-7-oliver.upton@linux.dev>
In-Reply-To: <20221202185156.696189-1-oliver.upton@linux.dev>
References: <20221202185156.696189-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221202185156.YHrth-V6wZNnhsgVYwmdmuQ31szbCV802nDJ8W7yXOM@z>

As it currently stands, KVM makes use of FEAT_HAFDBS unconditionally.
Use of the feature in the rest of the kernel is guarded by an associated
Kconfig option.

Align KVM with the rest of the kernel and only enable VTCR_HA when
ARM64_HW_AFDBM is enabled. This can be helpful for testing changes to
the stage-2 access fault path on Armv8.1+ implementations.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 30575b5f5dcd..3d61bd3e591d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -606,12 +606,14 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 		lvls = 2;
 	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
 
+#ifdef CONFIG_ARM64_HW_AFDBM
 	/*
 	 * Enable the Hardware Access Flag management, unconditionally
 	 * on all CPUs. The features is RES0 on CPUs without the support
 	 * and must be ignored by the CPUs.
 	 */
 	vtcr |= VTCR_EL2_HA;
+#endif /* CONFIG_ARM64_HW_AFDBM */
 
 	/* Set the vmid bits */
 	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

