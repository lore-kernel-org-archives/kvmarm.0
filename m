Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3553C28E8;
	Fri, 27 Jan 2023 11:41:09 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8BAC165C;
	Fri, 27 Jan 2023 03:41:50 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 329813F64C;
	Fri, 27 Jan 2023 03:41:06 -0800 (PST)
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
Subject: [RFC kvmtool 28/31] arm64: realm: Enforce virtio F_ACCESS_PLATFORM flag
Date: Fri, 27 Jan 2023 11:39:29 +0000
Message-Id: <20230127113932.166089-29-suzuki.poulose@arm.com>
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

For realms, force the F_ACCESS_PLATFORM flag to ensure DMA-APIs
are triggered for virtio in Linux

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/kvm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index a4664237..1f3a0def 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -5,6 +5,7 @@
 #include <linux/byteorder.h>
 #include <linux/cpumask.h>
 #include <linux/sizes.h>
+#include <linux/virtio_config.h>
 
 #include <kvm/util.h>
 
@@ -237,5 +238,10 @@ void kvm__arch_enable_mte(struct kvm *kvm)
 
 u64 kvm__arch_get_virtio_host_features(struct kvm *kvm)
 {
-	return 0;
+	u64 features = 0;
+
+	/* Enforce F_ACCESS_PLATFORM for Realms */
+	if (kvm->cfg.arch.is_realm)
+		features |= (1ULL << VIRTIO_F_ACCESS_PLATFORM);
+	return features;
 }
-- 
2.34.1

