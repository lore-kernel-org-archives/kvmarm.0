Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C594C60;
	Fri,  3 Feb 2023 13:53:24 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E926F1FB;
	Fri,  3 Feb 2023 05:54:05 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.177])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2799B3F71E;
	Fri,  3 Feb 2023 05:53:20 -0800 (PST)
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
Subject: [RFC PATCH 21/32] LoongArch: Use the __weak version of arch_unregister_cpu()
Date: Fri,  3 Feb 2023 13:50:32 +0000
Message-Id: <20230203135043.409192-22-james.morse@arm.com>
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

LoongArch provides its own arch_unregister_cpu(). This clears the
hotpluggable flag, then unregisters the CPU.

It isn't necessary to clear the hotpluggable flag when unregistering
a cpu. unregister_cpu() writes NULL to the percpu cpu_sys_devices
pointer, meaning cpu_is_hotpluggable() will return false, as
get_cpu_device() has returned NULL.

Remove arch_unregister_cpu() and use the __weak version.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/loongarch/kernel/topology.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/loongarch/kernel/topology.c b/arch/loongarch/kernel/topology.c
index a86d51269b09..494044990ba9 100644
--- a/arch/loongarch/kernel/topology.c
+++ b/arch/loongarch/kernel/topology.c
@@ -21,13 +21,4 @@ int arch_register_cpu(int cpu)
 	return ret;
 }
 EXPORT_SYMBOL(arch_register_cpu);
-
-void arch_unregister_cpu(int cpu)
-{
-	struct cpu *c = &per_cpu(cpu_devices, cpu);
-
-	c->hotpluggable = 0;
-	unregister_cpu(c);
-}
-EXPORT_SYMBOL(arch_unregister_cpu);
 #endif
-- 
2.30.2

