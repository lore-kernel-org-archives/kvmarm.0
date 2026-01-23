Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776882EA75E
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 16:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769187084; cv=none; b=kduUi4AxcbiemcmRva/G9iQAmS7JxY61JNo5iIY1c6OOgRpTV5X9GzxYC89v+EysqZnbPtLzNhZf5iCOdEuHFFwvhPg0yk6o5IGUr0FjTgSgA/fRWHoxSuW/1dzqDySZwvz6Zju8Jz5uIgRQYwGMj6KKs86BP23dTf4zkH9F3hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769187084; c=relaxed/simple;
	bh=mFa+L/Yj2oCmIh1LOBHsTZosRWW1PLsvs2DpeCEWUoc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NHi3M1wlukHJvFXAuZc7UJVrDexfm2l9hbrQucwIAAyqeISQTo3g/2KdgqzCAE5KX8tPOY+Pxm9RAreRJRHXxksjtk1Q9sGUKpnM+mzC2SDcS79i9DCqKcqklXmDPTWmTH2+Feolv8m1pebqkPY1O3hANRyIEJGz6qWTxNsS/Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45C79168F;
	Fri, 23 Jan 2026 08:51:16 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F33C3F694;
	Fri, 23 Jan 2026 08:51:21 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v6 12/14] arm64: add EL2 environment variable
Date: Fri, 23 Jan 2026 16:50:51 +0000
Message-Id: <20260123165053.2250754-13-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260123165053.2250754-1-joey.gouly@arm.com>
References: <20260123165053.2250754-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This variable when set to y/Y/1 will cause QEMU/kvmtool to start at EL2.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/run               | 9 +++++++++
 scripts/arch-run.bash | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/arm/run b/arm/run
index 858333fc..2d5ee672 100755
--- a/arm/run
+++ b/arm/run
@@ -59,6 +59,10 @@ function arch_run_qemu()
 		M+=",highmem=off"
 	fi
 
+	if is_enabled "$EL2"; then
+		M+=",virtualization=on"
+	fi
+
 	if ! $qemu $M -device '?' | grep -q virtconsole; then
 		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
 		exit 2
@@ -116,6 +120,11 @@ function arch_run_kvmtool()
 	fi
 
 	command="$(timeout_cmd) $kvmtool run"
+
+	if is_enabled "$EL2"; then
+		command+=" --nested"
+	fi
+
 	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
 		run_test_status $command --kernel "$@" --aarch32
 	else
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 16417a1e..01cc1ff2 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -596,3 +596,8 @@ set_qemu_accelerator ()
 
 	return 0
 }
+
+is_enabled ()
+{
+	[[ "$1" == 1 ]] || [[ "$1" == Y ]] || [[ "$1" == y ]]
+}
-- 
2.25.1

