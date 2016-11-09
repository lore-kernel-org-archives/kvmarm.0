From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH v4 03/11] arm/arm64: smp: support more than
 8 cpus
Date: Wed, 9 Nov 2016 11:12:03 +0000
Message-ID: <f5509dd7-594b-04c8-20b0-2986fe1bcc41@arm.com>
References: <1478636499-14339-1-git-send-email-drjones@redhat.com>
 <1478636499-14339-4-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 042EC401A1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2016 06:11:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MYIbZIEkdyGw for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2016 06:11:08 -0500 (EST)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91E5840199
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2016 06:11:08 -0500 (EST)
In-Reply-To: <1478636499-14339-4-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 08/11/16 20:21, Andrew Jones wrote:
> By adding support for launching with gicv3 we can break the 8 vcpu
> limit. This patch adds support to smp code and also selects the
> vgic model corresponding to the host. The vgic model may also be
> manually selected by adding e.g. -machine gic-version=3D3 to
> extra_params.
> =

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> =

> ---
> v4: improved commit message
> ---
>  arm/run                   | 19 ++++++++++++-------
>  arm/selftest.c            |  5 ++++-
>  lib/arm/asm/processor.h   |  9 +++++++--
>  lib/arm/asm/setup.h       |  4 ++--
>  lib/arm/setup.c           | 12 +++++++++++-
>  lib/arm64/asm/processor.h |  9 +++++++--
>  6 files changed, 43 insertions(+), 15 deletions(-)
> =

> diff --git a/arm/run b/arm/run
> index a2f35ef6a7e6..2d0698619606 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -31,13 +31,6 @@ if [ -z "$ACCEL" ]; then
>  	fi
>  fi
>  =

> -if [ "$HOST" =3D "aarch64" ] && [ "$ACCEL" =3D "kvm" ]; then
> -	processor=3D"host"
> -	if [ "$ARCH" =3D "arm" ]; then
> -		processor+=3D",aarch64=3Doff"
> -	fi
> -fi
> -
>  qemu=3D"${QEMU:-qemu-system-$ARCH_NAME}"
>  qpath=3D$(which $qemu 2>/dev/null)
>  =

> @@ -53,6 +46,18 @@ fi
>  =

>  M=3D'-machine virt'
>  =

> +if [ "$ACCEL" =3D "kvm" ]; then
> +	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
> +		M+=3D',gic-version=3Dhost'
> +	fi
> +	if [ "$HOST" =3D "aarch64" ]; then
> +		processor=3D"host"
> +		if [ "$ARCH" =3D "arm" ]; then
> +			processor+=3D",aarch64=3Doff"
> +		fi
> +	fi
> +fi
> +
>  if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
>  	echo "$qpath doesn't support virtio-console for chr-testdev. Exiting."
>  	exit 2
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 196164f5313d..2f117f795d2d 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -312,9 +312,10 @@ static bool psci_check(void)
>  static cpumask_t smp_reported;
>  static void cpu_report(void)
>  {
> +	unsigned long mpidr =3D get_mpidr();
>  	int cpu =3D smp_processor_id();
>  =

> -	report("CPU%d online", true, cpu);
> +	report("CPU(%3d) mpidr=3D%lx", mpidr_to_cpu(mpidr) =3D=3D cpu, cpu, mpi=
dr);
>  	cpumask_set_cpu(cpu, &smp_reported);
>  	halt();
>  }
> @@ -343,6 +344,7 @@ int main(int argc, char **argv)
>  =

>  	} else if (strcmp(argv[1], "smp") =3D=3D 0) {
>  =

> +		unsigned long mpidr =3D get_mpidr();
>  		int cpu;
>  =

>  		report("PSCI version", psci_check());
> @@ -353,6 +355,7 @@ int main(int argc, char **argv)
>  			smp_boot_secondary(cpu, cpu_report);
>  		}
>  =

> +		report("CPU(%3d) mpidr=3D%lx", mpidr_to_cpu(mpidr) =3D=3D 0, 0, mpidr);
>  		cpumask_set_cpu(0, &smp_reported);
>  		while (!cpumask_full(&smp_reported))
>  			cpu_relax();
> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> index f25e7eee3666..d2048f5f5f7e 100644
> --- a/lib/arm/asm/processor.h
> +++ b/lib/arm/asm/processor.h
> @@ -40,8 +40,13 @@ static inline unsigned int get_mpidr(void)
>  	return mpidr;
>  }
>  =

> -/* Only support Aff0 for now, up to 4 cpus */
> -#define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
> +#define MPIDR_HWID_BITMASK 0xffffff
> +extern int mpidr_to_cpu(unsigned long mpidr);
> +
> +#define MPIDR_LEVEL_SHIFT(level) \
> +	(((1 << level) >> 1) << 3)
> +#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
> +	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & 0xff)
>  =

>  extern void start_usr(void (*func)(void *arg), void *arg, unsigned long =
sp_usr);
>  extern bool is_user(void);
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index cb8fdbd38dd5..b0d51f5f0721 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -10,8 +10,8 @@
>  #include <asm/page.h>
>  #include <asm/pgtable-hwdef.h>
>  =

> -#define NR_CPUS			8
> -extern u32 cpus[NR_CPUS];
> +#define NR_CPUS			255
> +extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
>  extern int nr_cpus;
>  =

>  #define NR_MEM_REGIONS		8
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 7e7b39f11dde..b6e2d5815e72 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -24,12 +24,22 @@ extern unsigned long stacktop;
>  extern void io_init(void);
>  extern void setup_args_progname(const char *args);
>  =

> -u32 cpus[NR_CPUS] =3D { [0 ... NR_CPUS-1] =3D (~0U) };
> +u64 cpus[NR_CPUS] =3D { [0 ... NR_CPUS-1] =3D (~0U) };

This should be ~0UL.
Also I think the type should be unsigned long to match the types used
everywhere else.

>  int nr_cpus;
>  =

>  struct mem_region mem_regions[NR_MEM_REGIONS];
>  phys_addr_t __phys_offset, __phys_end;
>  =

> +int mpidr_to_cpu(unsigned long mpidr)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < nr_cpus; ++i)
> +		if (cpus[i] =3D=3D (mpidr & MPIDR_HWID_BITMASK))
> +			return i;
> +	return -1;
> +}
> +
>  static void cpu_set(int fdtnode __unused, u32 regval, void *info __unuse=
d)

I guess this needs to be extended as well, including
dt_for_each_cpu_node() to cope with 64-bit reg properties in the CPU
node (where the upper word is not 0).
But this is not really crucial atm, so can be fixed in a follow-up patch.

Cheers,
Andre.

>  {
>  	int cpu =3D nr_cpus++;
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 9a208ff729b7..7e448dc81a6a 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -78,8 +78,13 @@ static inline type get_##reg(void)				\
>  =

>  DEFINE_GET_SYSREG64(mpidr)
>  =

> -/* Only support Aff0 for now, gicv2 only */
> -#define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
> +#define MPIDR_HWID_BITMASK 0xff00ffffff
> +extern int mpidr_to_cpu(unsigned long mpidr);
> +
> +#define MPIDR_LEVEL_SHIFT(level) \
> +	(((1 << level) >> 1) << 3)
> +#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
> +	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & 0xff)
>  =

>  extern void start_usr(void (*func)(void *arg), void *arg, unsigned long =
sp_usr);
>  extern bool is_user(void);
> =
