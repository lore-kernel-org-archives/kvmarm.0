Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF30A4A6CE0
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451615; cv=none; b=VIVczV8e1TTHaAlAOSS9x9TtiBcAPOAkRpMG2xEyHl4djePm7grhx5G4tk793MihmUzKkWvdZNXN0uatQg6puhz7nEL/rY4yzeoSDQXwi1KtXFUCwVaGyslo+fS01ao7IAePed5iQtvOOyrJoVGnpTX6BxdrX5rLfi9kFO/Knxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451615; c=relaxed/simple;
	bh=IYyXPaD2XdK0iGsJ5jrFv2i/pbUyFXfVwjRaAB3XpoA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OppJrbYMxBu5HhSCUthk4IAI+ARqEa3VGzXaFpzj8pYoq/UXdTrB62ibOnMCHaUP0UxhLPIwS3LZlHt9dsPNBdjgFIbS10UBXr7yLi9IMegsnwKQt4dqI3d4xAd5vgRKR1Mmz6SYV4yE1ymfSoWTStynfrKl2vR2kyqj38ma7Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Grivi6js; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Grivi6js"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5ED751596;
	Thu,  3 Sep 2026 09:06:50 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 535C63F673;
	Thu,  3 Sep 2026 09:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451614; bh=IYyXPaD2XdK0iGsJ5jrFv2i/pbUyFXfVwjRaAB3XpoA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Grivi6jszekcIPalic01O2eraKmuo0GM5jNL3EGrS4orjaFKvo/NpHGcVVCkCSNil
	 YLviMhVFXECzDKHQkbu4NJJmIFbu8YmqraWj4UlPvJiEygjf1Sa+VqgtcFzhnAaRCe
	 yf+tBt5deD4uwh0kyIUW0CgUkzb1Giup1gIlju5c=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: [RFC PATCH v7 09/28] HACK! KVM: arm64: Enable SPE virtualization only in VHE mode
Date: Thu,  3 Sep 2026 17:06:04 +0100
Message-ID: <20260903160623.315525-10-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
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
 arch/arm64/kvm/spe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 97160d1fae81..00908aa2576b 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -22,8 +22,8 @@ void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu)
 {
 	struct spe_pmu_entry *entry;
 
-	/* TODO: pKVM support */
-	if (is_protected_kvm_enabled())
+	/* TODO: pKVM and nVHE support */
+	if (is_protected_kvm_enabled() || !has_vhe())
 		return;
 
 	guard(mutex)(&spe_pmus_lock);
-- 
2.43.0

