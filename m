Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3908428F2;
	Fri, 27 Jan 2023 11:39:52 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A44601576;
	Fri, 27 Jan 2023 03:40:33 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1E5433F64C;
	Fri, 27 Jan 2023 03:39:49 -0800 (PST)
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
Subject: [RFC kvmtool 01/31] arm64: Disable MTE when CFI flash is emulated
Date: Fri, 27 Jan 2023 11:39:02 +0000
Message-Id: <20230127113932.166089-2-suzuki.poulose@arm.com>
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

CFI Flash file image cannot be mapped into the memory of the
guest if MTE is enabled. Thus disable MTE if flash emulation
is requested.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/kvm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 54200c9e..5a53badb 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -145,6 +145,12 @@ void kvm__arch_enable_mte(struct kvm *kvm)
 		return;
 	}
 
+	if (kvm->cfg.flash_filename) {
+		kvm->cfg.arch.mte_disabled = true;
+		pr_info("MTE is incompatible with CFI flash support, disabling");
+		return;
+	}
+
 	if (kvm->cfg.arch.mte_disabled) {
 		pr_debug("MTE disabled by user");
 		return;
-- 
2.34.1

