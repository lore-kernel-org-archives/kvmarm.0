Received: from out-40.mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0371D2D242
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 22:18:02 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685139481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eu6GarTKeRfflcMAKkkjKhr+irb1TKgaVxp9hpyaxME=;
	b=IK9ZMmaW5p0DtFduOxXs0dCyOW83cZMrv1x0ts0jC8iaEV2FJ6eW2zhto7neW1FLqE+Aph
	iWaCF1jYLgdkv4x2JBHi2Wq03lD2yGapP/OKksExDMcGDLm9YD0Hf6r7VhFUYpt9xEAD4P
	upooHvnnoSb8nYTQHhO3UsORzJBizp8=
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
Subject: [PATCH kvmtool 19/21] aarch64: psci: Implement MIGRATE_INFO_TYPE
Date: Fri, 26 May 2023 22:17:10 +0000
Message-ID: <20230526221712.317287-20-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Let the guest know that our PSCI implementation is entirely oblivious to
the existence of a Trusted OS, and thus shouldn't care about it.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/psci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
index e32c47e6a2c9..c33e63bdc3ef 100644
--- a/arm/aarch64/psci.c
+++ b/arm/aarch64/psci.c
@@ -32,6 +32,7 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_CPU_ON:
 	case PSCI_0_2_FN_AFFINITY_INFO:
 	case PSCI_0_2_FN64_AFFINITY_INFO:
+	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -189,6 +190,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_AFFINITY_INFO:
 		affinity_info(vcpu, res);
 		break;
+	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+		/* Trusted OS not present */
+		res->a0 = PSCI_0_2_TOS_MP;
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.41.0.rc0.172.g3f132b7071-goog

