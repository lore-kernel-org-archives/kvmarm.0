Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D567B28EF;
	Fri, 27 Jan 2023 11:40:54 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68CBE1595;
	Fri, 27 Jan 2023 03:41:36 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D6C173F64C;
	Fri, 27 Jan 2023 03:40:51 -0800 (PST)
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
Subject: [RFC kvmtool 23/31] arm64: Specify SMC as the PSCI conduits for realms
Date: Fri, 27 Jan 2023 11:39:24 +0000
Message-Id: <20230127113932.166089-24-suzuki.poulose@arm.com>
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

From: Christoffer Dall <christoffer.dall@arm.com>

This lets the VM use the RMM implementation for PSCI.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/fdt.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index 762a604d..c46ff410 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -208,7 +208,14 @@ static int setup_fdt(struct kvm *kvm)
 		_FDT(fdt_property_string(fdt, "compatible", "arm,psci"));
 		fns = &psci_0_1_fns;
 	}
-	_FDT(fdt_property_string(fdt, "method", "hvc"));
+
+
+	if (kvm->cfg.arch.is_realm) {
+		_FDT(fdt_property_string(fdt, "method", "smc"));
+	} else {
+		_FDT(fdt_property_string(fdt, "method", "hvc"));
+	}
+
 	_FDT(fdt_property_cell(fdt, "cpu_suspend", fns->cpu_suspend));
 	_FDT(fdt_property_cell(fdt, "cpu_off", fns->cpu_off));
 	_FDT(fdt_property_cell(fdt, "cpu_on", fns->cpu_on));
-- 
2.34.1

