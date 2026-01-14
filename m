Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02993803C4
	for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 11:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391943; cv=none; b=j8qSSjyV4yFHfTZn0AamfHYmkpcJ6nYzv8fii6bd7/dGg4jVqn8wECPjbbwWThPbJchBCEIsKFxOWDtUNU2CF4VdIKxQ5UPPNk293nVQP9hlEWxKAifN8XjyrssUcnpUEjoWbPZ1/8T1pYa26vgVaFvgo00cNVxzi2bLbspucXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391943; c=relaxed/simple;
	bh=nlQMdrVSThnvwhQez/Y6PB7bSS/q3NpHDOMKF+TcAAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q1CpcPRUHx6IE1/VRhZ2V06Isb9E5K4tzdQmxbRc2JXfhElCqAXzsOfoXox9m8nP2/pR+JWVrcAPbOQ+1f3FYuzbjzhaLUDYNK1TEDtnbGyaE1lQ2/A2eKonJJ/+mdPCAddmM+ya/H1YfqzdHFbvPE5r5DMMCGfjDBONafGP2vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C491B1515;
	Wed, 14 Jan 2026 03:58:54 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45D563F632;
	Wed, 14 Jan 2026 03:59:00 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 11/11] arm64: add EL2 environment variable
Date: Wed, 14 Jan 2026 11:57:03 +0000
Message-Id: <20260114115703.926685-12-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260114115703.926685-1-joey.gouly@arm.com>
References: <20260114115703.926685-1-joey.gouly@arm.com>
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
 arm/run | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arm/run b/arm/run
index 858333fc..266ed1cf 100755
--- a/arm/run
+++ b/arm/run
@@ -59,6 +59,10 @@ function arch_run_qemu()
 		M+=",highmem=off"
 	fi
 
+	if [ "$EL2" == "1" ] || [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
+		M+=",virtualization=on"
+	fi
+
 	if ! $qemu $M -device '?' | grep -q virtconsole; then
 		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
 		exit 2
@@ -116,6 +120,9 @@ function arch_run_kvmtool()
 	fi
 
 	command="$(timeout_cmd) $kvmtool run"
+	if [ "$EL2" == "1" ] || [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
+		command+=" --nested"
+	fi
 	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
 		run_test_status $command --kernel "$@" --aarch32
 	else
-- 
2.25.1

