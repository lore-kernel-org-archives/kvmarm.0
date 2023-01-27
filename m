Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6DF28E8;
	Fri, 27 Jan 2023 11:41:15 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A914E1691;
	Fri, 27 Jan 2023 03:41:56 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 08A9B3F64C;
	Fri, 27 Jan 2023 03:41:11 -0800 (PST)
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
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>
Subject: [RFC kvmtool 30/31] arm64: realm: inject an abort on an unhandled MMIO access
Date: Fri, 27 Jan 2023 11:39:31 +0000
Message-Id: <20230127113932.166089-31-suzuki.poulose@arm.com>
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

From: Joey Gouly <joey.gouly@arm.com>

For Realms, inject a synchronous external abort, instead of ignoring unknown
MMIO accesses.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/kvm-cpu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 90a15ae9..c96d75eb 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -155,4 +155,13 @@ void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 
 void kvm_cpu__arch_unhandled_mmio(struct kvm_cpu *vcpu)
 {
+	struct kvm_vcpu_events events = { };
+
+	if (!vcpu->kvm->cfg.arch.is_realm)
+		return;
+
+	events.exception.ext_dabt_pending = 1;
+
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_VCPU_EVENTS, &events) < 0)
+		die_perror("KVM_SET_VCPU_EVENTS failed");
 }
-- 
2.34.1

