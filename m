Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5924C60;
	Fri,  3 Feb 2023 13:52:05 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 575A815A1;
	Fri,  3 Feb 2023 05:52:47 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.177])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 885F23F71E;
	Fri,  3 Feb 2023 05:52:01 -0800 (PST)
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
Subject: [RFC PATCH 03/32] drivers: base: Use present CPUs in GENERIC_CPU_DEVICES
Date: Fri,  3 Feb 2023 13:50:14 +0000
Message-Id: <20230203135043.409192-4-james.morse@arm.com>
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

The four ACPI architectures only create sysfs entries using register_cpu()
for present CPUs, whereas GENERIC_CPU_DEVICES does this for possible CPUs.

Only two of the eight architectures that use GENERIC_CPU_DEVICES have a
distinction between present and possible CPUs.

To allow all four ACPI architectures to use GENERIC_CPU_DEVICES, change
it to use for_each_present_cpu().

The following architectures use GENERIC_CPU_DEVICES but are not SMP,
so possible == present:
 * m68k
 * microblaze
 * nios2

The following architectures use GENERIC_CPU_DEVICES and consider
possible == present:
 * csky: setup_smp()
 * hexagon: compare smp_start_cpus() and smp_prepare_cpus()
 * parisc: smp_prepare_boot_cpu() marks the boot cpu as present,
   processor_probe() sets possible for all CPUs and present for all CPUs
   except the boot cpu.

um appears to be a subarchitecture of x86.

The remaining architecture using GENERIC_CPU_DEVICES is openrisc,
where smp_init_cpus() makes all CPUs < NR_CPUS possible, whereas
smp_prepare_cpus() only makes CPUs < setup_max_cpus present. After this
change, openrisc systems that boot with max_cpus=1 would not see other
CPUs present in sysfs. This should not be a problem as these CPUs can't
be brought online as _cpu_up() checks cpu_present().

Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/base/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 4c98849577d4..cf6407c34ede 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -500,7 +500,7 @@ static void __init cpu_dev_register_generic(void)
 #ifdef CONFIG_GENERIC_CPU_DEVICES
 	int i;
 
-	for_each_possible_cpu(i) {
+	for_each_present_cpu(i) {
 		if (register_cpu(&per_cpu(cpu_devices, i), i))
 			panic("Failed to register CPU device");
 	}
-- 
2.30.2

