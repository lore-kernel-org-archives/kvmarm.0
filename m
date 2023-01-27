Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E6B28E8;
	Fri, 27 Jan 2023 11:40:29 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC9521758;
	Fri, 27 Jan 2023 03:41:10 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3E5DB3F64C;
	Fri, 27 Jan 2023 03:40:26 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: suzuki.poulose@arm.com,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Steven Price <steven.price@arm.com>,
	Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-coco@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [RFC kvmtool 14/31] arm64: Add configuration step for Realms
Date: Fri, 27 Jan 2023 11:39:15 +0000
Message-Id: <20230127113932.166089-15-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127113932.166089-1-suzuki.poulose@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Realm must be configured before it is created. Add the
step to specify the parameters for the Realm.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/realm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arm/aarch64/realm.c b/arm/aarch64/realm.c
index 3a4adb66..31543e55 100644
--- a/arm/aarch64/realm.c
+++ b/arm/aarch64/realm.c
@@ -2,6 +2,29 @@
 
 #include <asm/realm.h>
 
+
+static void realm_configure_hash_algo(struct kvm *kvm)
+{
+	struct kvm_cap_arm_rme_config_item hash_algo_cfg = {
+		.cfg	= KVM_CAP_ARM_RME_CFG_HASH_ALGO,
+		.hash_algo = kvm->arch.measurement_algo,
+	};
+
+	struct kvm_enable_cap rme_config = {
+		.cap = KVM_CAP_ARM_RME,
+		.args[0] = KVM_CAP_ARM_RME_CONFIG_REALM,
+		.args[1] = (u64)&hash_algo_cfg,
+	};
+
+	if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &rme_config) < 0)
+		die_perror("KVM_CAP_RME(KVM_CAP_ARM_RME_CONFIG_REALM) hash_algo");
+}
+
+static void realm_configure_parameters(struct kvm *kvm)
+{
+	realm_configure_hash_algo(kvm);
+}
+
 void kvm_arm_realm_create_realm_descriptor(struct kvm *kvm)
 {
 	struct kvm_enable_cap rme_create_rd = {
@@ -9,6 +32,7 @@ void kvm_arm_realm_create_realm_descriptor(struct kvm *kvm)
 		.args[0] = KVM_CAP_ARM_RME_CREATE_RD,
 	};
 
+	realm_configure_parameters(kvm);
 	if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &rme_create_rd) < 0)
 		die_perror("KVM_CAP_RME(KVM_CAP_ARM_RME_CREATE_RD)");
 }
-- 
2.34.1

