From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v3 03/10] arm/arm64: smp: support more than 8 cpus
Date: Fri, 15 Jul 2016 15:00:34 +0200
Message-ID: <1468587641-7300-4-git-send-email-drjones@redhat.com>
References: <1468587641-7300-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1468587641-7300-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/run                   | 19 ++++++++++++-------
 arm/selftest.c            |  5 ++++-
 lib/arm/asm/processor.h   |  9 +++++++--
 lib/arm/asm/setup.h       |  4 ++--
 lib/arm/setup.c           | 12 +++++++++++-
 lib/arm64/asm/processor.h |  9 +++++++--
 6 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/arm/run b/arm/run
index a2f35ef6a7e63..2d0698619606e 100755
--- a/arm/run
+++ b/arm/run
@@ -31,13 +31,6 @@ if [ -z "$ACCEL" ]; then
 	fi
 fi
=20
-if [ "$HOST" =3D "aarch64" ] && [ "$ACCEL" =3D "kvm" ]; then
-	processor=3D"host"
-	if [ "$ARCH" =3D "arm" ]; then
-		processor+=3D",aarch64=3Doff"
-	fi
-fi
-
 qemu=3D"${QEMU:-qemu-system-$ARCH_NAME}"
 qpath=3D$(which $qemu 2>/dev/null)
=20
@@ -53,6 +46,18 @@ fi
=20
 M=3D'-machine virt'
=20
+if [ "$ACCEL" =3D "kvm" ]; then
+	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
+		M+=3D',gic-version=3Dhost'
+	fi
+	if [ "$HOST" =3D "aarch64" ]; then
+		processor=3D"host"
+		if [ "$ARCH" =3D "arm" ]; then
+			processor+=3D",aarch64=3Doff"
+		fi
+	fi
+fi
+
 if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
 	echo "$qpath doesn't support virtio-console for chr-testdev. Exiting.=
"
 	exit 2
diff --git a/arm/selftest.c b/arm/selftest.c
index 196164f5313de..2f117f795d2dc 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -312,9 +312,10 @@ static bool psci_check(void)
 static cpumask_t smp_reported;
 static void cpu_report(void)
 {
+	unsigned long mpidr =3D get_mpidr();
 	int cpu =3D smp_processor_id();
=20
-	report("CPU%d online", true, cpu);
+	report("CPU(%3d) mpidr=3D%lx", mpidr_to_cpu(mpidr) =3D=3D cpu, cpu, m=
pidr);
 	cpumask_set_cpu(cpu, &smp_reported);
 	halt();
 }
@@ -343,6 +344,7 @@ int main(int argc, char **argv)
=20
 	} else if (strcmp(argv[1], "smp") =3D=3D 0) {
=20
+		unsigned long mpidr =3D get_mpidr();
 		int cpu;
=20
 		report("PSCI version", psci_check());
@@ -353,6 +355,7 @@ int main(int argc, char **argv)
 			smp_boot_secondary(cpu, cpu_report);
 		}
=20
+		report("CPU(%3d) mpidr=3D%lx", mpidr_to_cpu(mpidr) =3D=3D 0, 0, mpid=
r);
 		cpumask_set_cpu(0, &smp_reported);
 		while (!cpumask_full(&smp_reported))
 			cpu_relax();
diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index f25e7eee3666c..d2048f5f5f7e6 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -40,8 +40,13 @@ static inline unsigned int get_mpidr(void)
 	return mpidr;
 }
=20
-/* Only support Aff0 for now, up to 4 cpus */
-#define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
+#define MPIDR_HWID_BITMASK 0xffffff
+extern int mpidr_to_cpu(unsigned long mpidr);
+
+#define MPIDR_LEVEL_SHIFT(level) \
+	(((1 << level) >> 1) << 3)
+#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
+	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & 0xff)
=20
 extern void start_usr(void (*func)(void *arg), void *arg, unsigned lon=
g sp_usr);
 extern bool is_user(void);
diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index cb8fdbd38dd5d..c501c6ddd8657 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -10,8 +10,8 @@
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
=20
-#define NR_CPUS			8
-extern u32 cpus[NR_CPUS];
+#define NR_CPUS			255
+extern u64 cpus[NR_CPUS];
 extern int nr_cpus;
=20
 #define NR_MEM_REGIONS		8
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 7e7b39f11dde1..b6e2d5815e723 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -24,12 +24,22 @@ extern unsigned long stacktop;
 extern void io_init(void);
 extern void setup_args_progname(const char *args);
=20
-u32 cpus[NR_CPUS] =3D { [0 ... NR_CPUS-1] =3D (~0U) };
+u64 cpus[NR_CPUS] =3D { [0 ... NR_CPUS-1] =3D (~0U) };
 int nr_cpus;
=20
 struct mem_region mem_regions[NR_MEM_REGIONS];
 phys_addr_t __phys_offset, __phys_end;
=20
+int mpidr_to_cpu(unsigned long mpidr)
+{
+	int i;
+
+	for (i =3D 0; i < nr_cpus; ++i)
+		if (cpus[i] =3D=3D (mpidr & MPIDR_HWID_BITMASK))
+			return i;
+	return -1;
+}
+
 static void cpu_set(int fdtnode __unused, u32 regval, void *info __unu=
sed)
 {
 	int cpu =3D nr_cpus++;
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 9a208ff729b7e..7e448dc81a6aa 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -78,8 +78,13 @@ static inline type get_##reg(void)				\
=20
 DEFINE_GET_SYSREG64(mpidr)
=20
-/* Only support Aff0 for now, gicv2 only */
-#define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
+#define MPIDR_HWID_BITMASK 0xff00ffffff
+extern int mpidr_to_cpu(unsigned long mpidr);
+
+#define MPIDR_LEVEL_SHIFT(level) \
+	(((1 << level) >> 1) << 3)
+#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
+	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & 0xff)
=20
 extern void start_usr(void (*func)(void *arg), void *arg, unsigned lon=
g sp_usr);
 extern bool is_user(void);
--=20
2.7.4

