From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests v8 02/10] arm/arm64: smp: support more than 8 cpus
Date: Thu,  8 Dec 2016 18:50:22 +0100
Message-ID: <20161208175030.12269-3-drjones@redhat.com>
References: <20161208175030.12269-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161208175030.12269-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peter.maydell@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

By adding support for launching with gicv3 we can break the 8 vcpu
limit. This patch adds support to smp code and also selects the
vgic model corresponding to the host. The vgic model may also be
manually selected by adding e.g. -machine gic-version=3 to
extra_params.

Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>

---
v8: in anticipation of get_mpidr() returning a u64 (patches will
    be in a future series), make sure we use that type everywhere
    get_mpidr is used
v5: left cpus a u32 for now. Changing to u64 requires a change to
    devicetree. Will do it later. [Andre]
v4: improved commit message
---
 arm/run                   | 19 ++++++++++++-------
 lib/arm/asm/processor.h   |  9 +++++++--
 lib/arm/asm/setup.h       |  4 ++--
 lib/arm64/asm/processor.h |  9 +++++++--
 arm/selftest.c            |  7 ++++++-
 lib/arm/setup.c           | 10 ++++++++++
 6 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/arm/run b/arm/run
index f1b04af614dc..1c40ab02eb57 100755
--- a/arm/run
+++ b/arm/run
@@ -31,13 +31,6 @@ if [ -z "$ACCEL" ]; then
 	fi
 fi
 
-if [ "$HOST" = "aarch64" ] && [ "$ACCEL" = "kvm" ]; then
-	processor="host"
-	if [ "$ARCH" = "arm" ]; then
-		processor+=",aarch64=off"
-	fi
-fi
-
 qemu="${QEMU:-qemu-system-$ARCH_NAME}"
 qpath=$(which $qemu 2>/dev/null)
 
@@ -53,6 +46,18 @@ fi
 
 M='-machine virt'
 
+if [ "$ACCEL" = "kvm" ]; then
+	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
+		M+=',gic-version=host'
+	fi
+	if [ "$HOST" = "aarch64" ]; then
+		processor="host"
+		if [ "$ARCH" = "arm" ]; then
+			processor+=",aarch64=off"
+		fi
+	fi
+fi
+
 if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
 	echo "$qpath doesn't support virtio-console for chr-testdev. Exiting."
 	exit 2
diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index c831749e04de..6b0d36b87817 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -40,8 +40,13 @@ static inline unsigned int get_mpidr(void)
 	return read_sysreg(MPIDR);
 }
 
-/* Only support Aff0 for now, up to 4 cpus */
-#define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
+#define MPIDR_HWID_BITMASK 0xffffff
+extern int mpidr_to_cpu(uint64_t mpidr);
+
+#define MPIDR_LEVEL_SHIFT(level) \
+	(((1 << level) >> 1) << 3)
+#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
+	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & 0xff)
 
 extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
 extern bool is_user(void);
diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index cb8fdbd38dd5..1de99dd184d1 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -10,8 +10,8 @@
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
 
-#define NR_CPUS			8
-extern u32 cpus[NR_CPUS];
+#define NR_CPUS			255
+extern u32 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
 extern int nr_cpus;
 
 #define NR_MEM_REGIONS		8
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index ed59ad25007b..48abf2c9e358 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -72,8 +72,13 @@ static inline unsigned int get_mpidr(void)
 	return read_sysreg(mpidr_el1);
 }
 
-/* Only support Aff0 for now, gicv2 only */
-#define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
+#define MPIDR_HWID_BITMASK 0xff00ffffff
+extern int mpidr_to_cpu(uint64_t mpidr);
+
+#define MPIDR_LEVEL_SHIFT(level) \
+	(((1 << level) >> 1) << 3)
+#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
+	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & 0xff)
 
 extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
 extern bool is_user(void);
diff --git a/arm/selftest.c b/arm/selftest.c
index 196164f5313d..750e90893141 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -312,9 +312,11 @@ static bool psci_check(void)
 static cpumask_t smp_reported;
 static void cpu_report(void)
 {
+	uint64_t mpidr = get_mpidr();
 	int cpu = smp_processor_id();
 
-	report("CPU%d online", true, cpu);
+	report("CPU(%3d) mpidr=%010" PRIx64,
+		mpidr_to_cpu(mpidr) == cpu, cpu, mpidr);
 	cpumask_set_cpu(cpu, &smp_reported);
 	halt();
 }
@@ -343,6 +345,7 @@ int main(int argc, char **argv)
 
 	} else if (strcmp(argv[1], "smp") == 0) {
 
+		uint64_t mpidr = get_mpidr();
 		int cpu;
 
 		report("PSCI version", psci_check());
@@ -353,6 +356,8 @@ int main(int argc, char **argv)
 			smp_boot_secondary(cpu, cpu_report);
 		}
 
+		report("CPU(%3d) mpidr=%010" PRIx64,
+			mpidr_to_cpu(mpidr) == 0, 0, mpidr);
 		cpumask_set_cpu(0, &smp_reported);
 		while (!cpumask_full(&smp_reported))
 			cpu_relax();
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 7e7b39f11dde..e52a25abd722 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -30,6 +30,16 @@ int nr_cpus;
 struct mem_region mem_regions[NR_MEM_REGIONS];
 phys_addr_t __phys_offset, __phys_end;
 
+int mpidr_to_cpu(uint64_t mpidr)
+{
+	int i;
+
+	for (i = 0; i < nr_cpus; ++i)
+		if (cpus[i] == (mpidr & MPIDR_HWID_BITMASK))
+			return i;
+	return -1;
+}
+
 static void cpu_set(int fdtnode __unused, u32 regval, void *info __unused)
 {
 	int cpu = nr_cpus++;
-- 
2.9.3

