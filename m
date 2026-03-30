Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD7683DD517
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880666; cv=none; b=gNUjTuDE9QnYlPVDKgoDhnezYbyk0IO/mTCuNLasH6sJPmeJ3C0b6fpVvT1TyyukLdH9wj5DH+UYcrKyibMPgm5K0oR3Yo8eGishpezaq4jHMk5ooA/HMRb7rh11dPc42sS9fkNn4U7+cwnupuDBwoSAgDca1jsxqgz/8iTDRa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880666; c=relaxed/simple;
	bh=Jy09jgbBZ0NtLoWAppmx87IBHL6F4I7aPwJ9L2m2ZNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ryqh5r6oQAWrOWjohfSTV4844DvpHC1KwEOLKHLhW0rRaSIRUpEf2Gwfs62OXnAKY2DYcY2Xe9wg6wHiD7jyNy5q01lN6SVLQo3oGU35Z3SN3tY37S+sFG0Jt7gOjEenDb+ewaEeRwDQuJ9MZLQxxjr2xRAOXFpxK48akm7Qg4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lLoSujvW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lLoSujvW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9477F1D15;
	Mon, 30 Mar 2026 07:24:18 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D27E93F915;
	Mon, 30 Mar 2026 07:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880664; bh=Jy09jgbBZ0NtLoWAppmx87IBHL6F4I7aPwJ9L2m2ZNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLoSujvWdjcdeVH3MJFwEQNZF1GmFbwmlM9sV3xN/JwuBWQlY2ZT1KYYT6u6ax79Q
	 0Pzf215xeQkKISQt2wrudzaeHnhEQf9rPTKekU9wphV2QaVXVqkl8lB0s8y9/ewTPm
	 HIoqLK1/7+Q6wMQy3i8rl9vYvxJdZfuKAbeEA0cM=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v7 07/17] arm64: Stash kvm_vcpu_init for later use
Date: Mon, 30 Mar 2026 15:23:24 +0100
Message-ID: <20260330142334.3309961-8-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

A subsequent change will add support for resetting a vCPU, which
requires reissuing the KVM_ARM_VCPU_INIT ioctl. Save the kvm_vcpu_init
worked out for later use.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/include/kvm/kvm-cpu-arch.h | 2 +-
 arm64/kvm-cpu.c                  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm64/include/kvm/kvm-cpu-arch.h b/arm64/include/kvm/kvm-cpu-arch.h
index 1af394aa..2f189abc 100644
--- a/arm64/include/kvm/kvm-cpu-arch.h
+++ b/arm64/include/kvm/kvm-cpu-arch.h
@@ -17,7 +17,7 @@ struct kvm_cpu {
 	pthread_t	thread;
 
 	unsigned long	cpu_id;
-	unsigned long	cpu_type;
+	struct kvm_vcpu_init	init;
 	const char	*cpu_compatible;
 
 	struct kvm	*kvm;
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 94c08a4d..3d914112 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -194,7 +194,7 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	/* Populate the vcpu structure. */
 	vcpu->kvm		= kvm;
 	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->init		= vcpu_init;
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
-- 
2.43.0

