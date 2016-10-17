From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v3 03/10] arm/arm64: smp:
 support more than 8 cpus
Date: Mon, 17 Oct 2016 14:24:43 +0200
Message-ID: <20161017122443.2v5r5xtqhi7ekgmw@kamzik.brq.redhat.com>
References: <1468587641-7300-1-git-send-email-drjones@redhat.com>
 <1468587641-7300-4-git-send-email-drjones@redhat.com>
 <11a885eb-d43e-528e-235a-13358edc6ea6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6531409A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2016 08:14:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LELu9RjTaWEQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2016 08:14:31 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E383407AD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2016 08:14:31 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <11a885eb-d43e-528e-235a-13358edc6ea6@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 30, 2016 at 04:28:52PM +0200, Auger Eric wrote:
> Hi Drew,
> =

> Proper commit message?
> ... also selects the vgic model corresponding to the host

Sure

> > Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arm/run                   | 19 ++++++++++++-------
> >  arm/selftest.c            |  5 ++++-
> >  lib/arm/asm/processor.h   |  9 +++++++--
> >  lib/arm/asm/setup.h       |  4 ++--
> >  lib/arm/setup.c           | 12 +++++++++++-
> >  lib/arm64/asm/processor.h |  9 +++++++--
> >  6 files changed, 43 insertions(+), 15 deletions(-)
> > =

> > diff --git a/arm/run b/arm/run
> > index a2f35ef6a7e63..2d0698619606e 100755
> > --- a/arm/run
> > +++ b/arm/run
> > @@ -31,13 +31,6 @@ if [ -z "$ACCEL" ]; then
> >  	fi
> >  fi
> >  =

> > -if [ "$HOST" =3D "aarch64" ] && [ "$ACCEL" =3D "kvm" ]; then
> > -	processor=3D"host"
> > -	if [ "$ARCH" =3D "arm" ]; then
> > -		processor+=3D",aarch64=3Doff"
> > -	fi
> > -fi
> > -
> >  qemu=3D"${QEMU:-qemu-system-$ARCH_NAME}"
> >  qpath=3D$(which $qemu 2>/dev/null)
> >  =

> > @@ -53,6 +46,18 @@ fi
> >  =

> >  M=3D'-machine virt'
> >  =

> > +if [ "$ACCEL" =3D "kvm" ]; then
> > +	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
> > +		M+=3D',gic-version=3Dhost'
> > +	fi
> > +	if [ "$HOST" =3D "aarch64" ]; then
> > +		processor=3D"host"
> > +		if [ "$ARCH" =3D "arm" ]; then
> > +			processor+=3D",aarch64=3Doff"
> > +		fi
> > +	fi
> > +fi
> > +
> >  if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
> >  	echo "$qpath doesn't support virtio-console for chr-testdev. Exiting."
> >  	exit 2
> > diff --git a/arm/selftest.c b/arm/selftest.c
> > index 196164f5313de..2f117f795d2dc 100644
> > --- a/arm/selftest.c
> > +++ b/arm/selftest.c
> > @@ -312,9 +312,10 @@ static bool psci_check(void)
> >  static cpumask_t smp_reported;
> >  static void cpu_report(void)
> >  {
> > +	unsigned long mpidr =3D get_mpidr();
> >  	int cpu =3D smp_processor_id();
> >  =

> > -	report("CPU%d online", true, cpu);
> > +	report("CPU(%3d) mpidr=3D%lx", mpidr_to_cpu(mpidr) =3D=3D cpu, cpu, m=
pidr);
> >  	cpumask_set_cpu(cpu, &smp_reported);
> >  	halt();
> >  }
> > @@ -343,6 +344,7 @@ int main(int argc, char **argv)
> >  =

> >  	} else if (strcmp(argv[1], "smp") =3D=3D 0) {
> >  =

> > +		unsigned long mpidr =3D get_mpidr();
> >  		int cpu;
> >  =

> >  		report("PSCI version", psci_check());
> > @@ -353,6 +355,7 @@ int main(int argc, char **argv)
> >  			smp_boot_secondary(cpu, cpu_report);
> >  		}
> >  =

> > +		report("CPU(%3d) mpidr=3D%lx", mpidr_to_cpu(mpidr) =3D=3D 0, 0, mpid=
r);
> >  		cpumask_set_cpu(0, &smp_reported);
> >  		while (!cpumask_full(&smp_reported))
> >  			cpu_relax();
> > diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> > index f25e7eee3666c..d2048f5f5f7e6 100644
> > --- a/lib/arm/asm/processor.h
> > +++ b/lib/arm/asm/processor.h
> > @@ -40,8 +40,13 @@ static inline unsigned int get_mpidr(void)
> >  	return mpidr;
> >  }
> >  =

> > -/* Only support Aff0 for now, up to 4 cpus */
> > -#define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
> > +#define MPIDR_HWID_BITMASK 0xffffff
> > +extern int mpidr_to_cpu(unsigned long mpidr);
> > +
> > +#define MPIDR_LEVEL_SHIFT(level) \
> > +	(((1 << level) >> 1) << 3)
> can't we have level << 3?
> > +#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
> > +	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & 0xff)
> >  =

> >  extern void start_usr(void (*func)(void *arg), void *arg, unsigned lon=
g sp_usr);
> >  extern bool is_user(void);
> > diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> > index cb8fdbd38dd5d..c501c6ddd8657 100644
> > --- a/lib/arm/asm/setup.h
> > +++ b/lib/arm/asm/setup.h
> > @@ -10,8 +10,8 @@
> >  #include <asm/page.h>
> >  #include <asm/pgtable-hwdef.h>
> >  =

> > -#define NR_CPUS			8
> > -extern u32 cpus[NR_CPUS];
> > +#define NR_CPUS			255
> 256?

The kernel defines KVM_MAX_VCPUS as VGIC_V3_MAX_CPUS, which is
currently defined as 255. I was just being consistent.

> > +extern u64 cpus[NR_CPUS];
> maybe worth commenting the semantic of cpus[i]?

sure

> >  extern int nr_cpus;
> what about MAX_CPUS instead of NR_CPUS?

kernel uses NR_CPUS, I want to be consistent.

> >  =

> >  #define NR_MEM_REGIONS		8
> > diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> > index 7e7b39f11dde1..b6e2d5815e723 100644
> > --- a/lib/arm/setup.c
> > +++ b/lib/arm/setup.c
> > @@ -24,12 +24,22 @@ extern unsigned long stacktop;
> >  extern void io_init(void);
> >  extern void setup_args_progname(const char *args);
> >  =

> > -u32 cpus[NR_CPUS] =3D { [0 ... NR_CPUS-1] =3D (~0U) };
> > +u64 cpus[NR_CPUS] =3D { [0 ... NR_CPUS-1] =3D (~0U) };
> >  int nr_cpus;
> >  =

> >  struct mem_region mem_regions[NR_MEM_REGIONS];
> >  phys_addr_t __phys_offset, __phys_end;
> >  =

> > +int mpidr_to_cpu(unsigned long mpidr)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < nr_cpus; ++i)
> > +		if (cpus[i] =3D=3D (mpidr & MPIDR_HWID_BITMASK))
> > +			return i;
> > +	return -1;
> > +}
> > +
> >  static void cpu_set(int fdtnode __unused, u32 regval, void *info __unu=
sed)
> >  {
> >  	int cpu =3D nr_cpus++;
> > diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> > index 9a208ff729b7e..7e448dc81a6aa 100644
> > --- a/lib/arm64/asm/processor.h
> > +++ b/lib/arm64/asm/processor.h
> > @@ -78,8 +78,13 @@ static inline type get_##reg(void)				\
> >  =

> >  DEFINE_GET_SYSREG64(mpidr)
> >  =

> > -/* Only support Aff0 for now, gicv2 only */
> > -#define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
> > +#define MPIDR_HWID_BITMASK 0xff00ffffff
> > +extern int mpidr_to_cpu(unsigned long mpidr);
> > +
> > +#define MPIDR_LEVEL_SHIFT(level) \
> > +	(((1 << level) >> 1) << 3)
> what about level 3? the macro would fail fetching affinity level 3.
> =

> Thanks
> =

> Eric
> > +#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
> > +	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & 0xff)
> >  =

> >  extern void start_usr(void (*func)(void *arg), void *arg, unsigned lon=
g sp_usr);
> >  extern bool is_user(void);
> > =

>

Thanks,
drew
