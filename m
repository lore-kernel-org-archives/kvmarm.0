Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767C828E8;
	Fri, 27 Jan 2023 11:40:06 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06F48165C;
	Fri, 27 Jan 2023 03:40:48 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7406D3F64C;
	Fri, 27 Jan 2023 03:40:03 -0800 (PST)
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
Subject: [RFC kvmtool 06/31] arm64: Check SVE capability on the VM instance
Date: Fri, 27 Jan 2023 11:39:07 +0000
Message-Id: <20230127113932.166089-7-suzuki.poulose@arm.com>
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

Similar to PVtime, check the SVE capability on the VM instance
to account for the different VM types and the corresponding support.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/kvm-cpu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index c8be10b3..da809806 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -150,13 +150,15 @@ void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init)
 	}
 
 	/* Enable SVE if available */
-	if (kvm__supports_extension(kvm, KVM_CAP_ARM_SVE))
+	if (kvm__supports_vm_extension(kvm, KVM_CAP_ARM_SVE))
 		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
 }
 
 int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
 {
-	if (kvm__supports_extension(vcpu->kvm, KVM_CAP_ARM_SVE)) {
+	struct kvm *kvm = vcpu->kvm;
+
+	if (kvm__supports_vm_extension(kvm, KVM_CAP_ARM_SVE)) {
 		int feature = KVM_ARM_VCPU_SVE;
 
 		if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_FINALIZE, &feature)) {
-- 
2.34.1

