Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DE82D2495
	for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810325; cv=none; b=tG0dkjYYTklej3IUxnZDZMc3z2srlBXEserSGrqonrfhe+v3BnGHWfZy839OnRKM94DaQT6oDEfs4h2DqM0t5xDKr0C78+35Cz0Cbh6c/isRIDlDwjS9GKOuxFut7PyZLup58O6Qp2mQmaeZOPh8C+7DU9Oc5F5ULD4v2mHki9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810325; c=relaxed/simple;
	bh=A9jLbSqY15I9mE6Eiis2TaQufr1DSCVgPVJbTstp0dI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=En6it9cKIL7pyMkQA+LOv5hDYaAnLZ+WRQJgQk/31Rn7/L99GdtUK2e4rPxtRVAqWZxG/5IpUmzDcvgRWuxkaW6H8LXd/g9Mu34D5DHip0fptvN+rwT/yaVaLMK0IVN7lb/JN1P4U3W36DkeY8ueBzjw4lUz6Tu00421mJlPnXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AE091692;
	Thu, 25 Sep 2025 07:25:15 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DA603F694;
	Thu, 25 Sep 2025 07:25:21 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v3 10/10] arm64: add EL2 environment variable
Date: Thu, 25 Sep 2025 15:19:58 +0100
Message-Id: <20250925141958.468311-11-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250925141958.468311-1-joey.gouly@arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This variable when set to 1 will cause QEMU/kvmtool to start at EL2.
---
 arm/run | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arm/run b/arm/run
index 858333fc..2a9c0de0 100755
--- a/arm/run
+++ b/arm/run
@@ -59,6 +59,10 @@ function arch_run_qemu()
 		M+=",highmem=off"
 	fi
 
+	if [ "$EL2" = "1" ]; then
+		M+=",virtualization=on"
+	fi
+
 	if ! $qemu $M -device '?' | grep -q virtconsole; then
 		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
 		exit 2
@@ -116,6 +120,9 @@ function arch_run_kvmtool()
 	fi
 
 	command="$(timeout_cmd) $kvmtool run"
+	if [ "$EL2" = "1" ]; then
+		command+=" --nested"
+	fi
 	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
 		run_test_status $command --kernel "$@" --aarch32
 	else
-- 
2.25.1

