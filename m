Received: from out-113.mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C17DDF62
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 23:43:21 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1691019799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q6y1KaRBCfEhAMm1HIfWLDZ8Yvuk3D4O0G72vSLm3y4=;
	b=p6xIMzpUjpUCNKvdhM46H+Li4gbYlyh3t5vRdx1s8VodHhtcmK3+odUs3GJS+wWAO7yZU8
	C1PjDCDvTGYVQINXR6nKrhMbna8QWX3KkI/Kc4kKvMHu+lkTgxZCw8lm09c1V+oeEeWFJH
	PtFfHsOG1wnzFmTdl4kN3azVdyg2IoM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v3 04/17] arm: Stash kvm_vcpu_init for later use
Date: Wed,  2 Aug 2023 23:42:42 +0000
Message-ID: <20230802234255.466782-5-oliver.upton@linux.dev>
In-Reply-To: <20230802234255.466782-1-oliver.upton@linux.dev>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A subsequent change will add support for resetting a vCPU, which
requires reissuing the KVM_ARM_VCPU_INIT ioctl. Save the kvm_vcpu_init
worked out for later use.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/include/arm-common/kvm-cpu-arch.h | 2 +-
 arm/kvm-cpu.c                         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/include/arm-common/kvm-cpu-arch.h b/arm/include/arm-common/kvm-cpu-arch.h
index 923d2c4c7ad3..bf5223eaa851 100644
--- a/arm/include/arm-common/kvm-cpu-arch.h
+++ b/arm/include/arm-common/kvm-cpu-arch.h
@@ -11,7 +11,7 @@ struct kvm_cpu {
 	pthread_t	thread;
 
 	unsigned long	cpu_id;
-	unsigned long	cpu_type;
+	struct kvm_vcpu_init	init;
 	const char	*cpu_compatible;
 
 	struct kvm	*kvm;
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index a43eb90a7642..0769eef198ac 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -114,7 +114,7 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	/* Populate the vcpu structure. */
 	vcpu->kvm		= kvm;
 	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->init		= vcpu_init;
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
-- 
2.41.0.585.gd2178a4bd4-goog

