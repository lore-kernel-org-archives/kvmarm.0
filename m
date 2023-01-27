Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A5428F0;
	Fri, 27 Jan 2023 11:40:57 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B9CB1762;
	Fri, 27 Jan 2023 03:41:39 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B8BF43F8D6;
	Fri, 27 Jan 2023 03:40:54 -0800 (PST)
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
Subject: [RFC kvmtool 24/31] arm64: Don't try to debug a realm
Date: Fri, 27 Jan 2023 11:39:25 +0000
Message-Id: <20230127113932.166089-25-suzuki.poulose@arm.com>
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

Don't read the register values for a running realm, because they don't
reflect the actual hardware state of a realm. And don't try to read realm
memory, because that will promptly lead to kvmtool being killed.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/kvm-cpu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 32fa7609..a29a3413 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -250,6 +250,9 @@ void kvm_cpu__show_code(struct kvm_cpu *vcpu)
 
 	reg.addr = (u64)&data;
 
+	if (vcpu->kvm->cfg.arch.is_realm)
+		return;
+
 	dprintf(debug_fd, "\n*pc:\n");
 	reg.id = ARM64_CORE_REG(regs.pc);
 	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
@@ -274,6 +277,11 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 	reg.addr = (u64)&data;
 	dprintf(debug_fd, "\n Registers:\n");
 
+	if (vcpu->kvm->cfg.arch.is_realm) {
+		dprintf(debug_fd, " UNACCESSIBLE\n");
+		return;
+	}
+
 	reg.id		= ARM64_CORE_REG(regs.pc);
 	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
 		die("KVM_GET_ONE_REG failed (pc)");
-- 
2.34.1

