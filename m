Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71C6826ED48
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136473; cv=none; b=q8q/S4BTmUsso1rRldeOQ6MY+FsB5Q9VkfTsYTbvXv1kr1FxAgqtweRtD9Hbkaeu2I5zltZnKO45S4xvxkPF+zFNeK7/Q6IFDW45lho/drBvVxevpv2MZ3Uel8CqvnJdNJjiPti71z4Yvh36WRtwZd6NHdlsGI41tMpfvOJFEsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136473; c=relaxed/simple;
	bh=KB5Qx5rJNl9cq9xVgYeGggng4pcB6xcwDGSOUWXSns8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqAqhXiJx+5UxByPLOsIvXafzoDQJ7+JS/GD7la6RTbbcM/F0+OdZ4PtowlLVsk7T9SfO+Z1spc0yP8NF9RUbn17g50PgCUnqTVaJEYXEfkvDSYwwnzUh00FRxDD4J7xl95Vm/XNAPxjmZaafBrWCjHf1VFdGOiEX95xzY+04PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A0E61BC0;
	Fri, 14 Nov 2025 08:07:44 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B02873F5A1;
	Fri, 14 Nov 2025 08:07:49 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 07/35] HACK! KVM: arm64: Disable SPE virtualization if protected KVM is enabled
Date: Fri, 14 Nov 2025 16:06:48 +0000
Message-ID: <20251114160717.163230-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For RFC only.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/spe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index cf902853750f..7e38f7d9075b 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -24,6 +24,10 @@ void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
 {
 	struct arm_spu_entry *entry;
 
+	/* TODO: pKVM support */
+	if (is_protected_kvm_enabled())
+		return;
+
 	guard(mutex)(&arm_spus_lock);
 
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-- 
2.51.2

