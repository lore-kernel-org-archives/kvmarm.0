Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C382C4C60;
	Fri,  3 Feb 2023 13:53:34 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A19A11684;
	Fri,  3 Feb 2023 05:54:16 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.177])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3EFB3F71E;
	Fri,  3 Feb 2023 05:53:30 -0800 (PST)
From: James Morse <james.morse@arm.com>
To: linux-pm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-ia64@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Borislav Petkov <bp@alien8.de>,
	H Peter Anvin <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Len Brown <lenb@kernel.org>,
	Rafael Wysocki <rafael@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Salil Mehta <salil.mehta@huawei.com>,
	Russell King <linux@armlinux.org.uk>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 23/32] ACPICA: Add new MADT GICC flags fields [code first?]
Date: Fri,  3 Feb 2023 13:50:34 +0000
Message-Id: <20230203135043.409192-24-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230203135043.409192-1-james.morse@arm.com>
References: <20230203135043.409192-1-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the new flag field to the MADT's GICC structure.

'Online Capable' indicates a disabled CPU can be enabled later.

Signed-off-by: James Morse <james.morse@arm.com>
---
This patch probably needs to go via the upstream acpica project,
but is included here so the feature can be tested.
---
 include/acpi/actbl2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index b2973dbe37ee..9b1c15c56db3 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -1040,6 +1040,7 @@ struct acpi_madt_generic_interrupt {
 /* ACPI_MADT_ENABLED                    (1)      Processor is usable if set */
 #define ACPI_MADT_PERFORMANCE_IRQ_MODE  (1<<1)	/* 01: Performance Interrupt Mode */
 #define ACPI_MADT_VGIC_IRQ_MODE         (1<<2)	/* 02: VGIC Maintenance Interrupt mode */
+#define ACPI_MADT_GICC_CPU_CAPABLE      (1<<3)	/* 03: CPU is online capable */
 
 /* 12: Generic Distributor (ACPI 5.0 + ACPI 6.0 changes) */
 
-- 
2.30.2

