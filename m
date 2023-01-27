Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032827B;
	Fri, 27 Jan 2023 11:30:21 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A7AD1691;
	Fri, 27 Jan 2023 03:31:03 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E86A3F64C;
	Fri, 27 Jan 2023 03:30:19 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev
Subject: [RFC PATCH 15/28] KVM: arm64: Handle realm MMIO emulation
Date: Fri, 27 Jan 2023 11:29:19 +0000
Message-Id: <20230127112932.38045-16-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127112932.38045-1-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MMIO emulation for a realm cannot be done directly with the VM's
registers as they are protected from the host. However the RMM interface
provides a structure member for providing the read/written value and
we can transfer this to the appropriate VCPU's register entry and then
depend on the generic MMIO handling code in KVM.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/mmio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 3dd38a151d2a..c4879fa3a8d3 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/rmi_smc.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
@@ -109,6 +110,9 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 			       &data);
 		data = vcpu_data_host_to_guest(vcpu, data, len);
 		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
+
+		if (vcpu_is_rec(vcpu))
+			vcpu->arch.rec.run->entry.gprs[0] = data;
 	}
 
 	/*
@@ -179,6 +183,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	run->mmio.len		= len;
 	vcpu->mmio_needed	= 1;
 
+	if (vcpu_is_rec(vcpu))
+		vcpu->arch.rec.run->entry.flags |= RMI_EMULATED_MMIO;
+
 	if (!ret) {
 		/* We handled the access successfully in the kernel. */
 		if (!is_write)
-- 
2.34.1

