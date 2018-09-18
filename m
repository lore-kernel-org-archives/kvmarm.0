From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests v3] arm/arm64: gicv3: support up to 8
 redistributor regions
Date: Tue, 18 Sep 2018 15:21:39 +0200
Message-ID: <1d33d6b7-6ee0-6f09-b0d4-2b092c8e6222@redhat.com>
References: <20180905113704.26412-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61ABF4A0CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 09:21:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8xS35Yy2g17R for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 09:21:43 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3636C49F89
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 09:21:43 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id n2-v6so2075080wrw.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 06:21:43 -0700 (PDT)
In-Reply-To: <20180905113704.26412-1-drjones@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/09/2018 13:37, Andrew Jones wrote:
> We need to support at least two redistributor regions in order to
> support more than 123 vcpus (we select 8 because that should be
> plenty). Also bump NR_CPUS to 512, since that's what KVM currently
> supports.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> Tested-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
> v3:
>  - add missing '++i' to the main loop in gicv3_set_redist_base
>    [Christoffer]
> v2:
>  - neater implementation by handling the number of redist regions
>    more generally [Peter]
> 
>  lib/arm/asm/gic-v3.h |  3 +++
>  lib/arm/asm/setup.h  |  2 +-
>  lib/arm/gic-v3.c     | 24 ++++++++++++++----------
>  lib/arm/gic.c        | 14 +++++++++-----
>  4 files changed, 27 insertions(+), 16 deletions(-)
> 
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 1dceb9541f62..347be2f9da17 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -49,8 +49,11 @@
>  #include <asm/smp.h>
>  #include <asm/io.h>
>  
> +#define GICV3_NR_REDISTS 8
> +
>  struct gicv3_data {
>  	void *dist_base;
> +	void *redist_bases[GICV3_NR_REDISTS];
>  	void *redist_base[NR_CPUS];
>  	unsigned int irq_nr;
>  };
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index b57ea13b9dd2..3215814603e4 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -9,7 +9,7 @@
>  #include <asm/page.h>
>  #include <asm/pgtable-hwdef.h>
>  
> -#define NR_CPUS			255
> +#define NR_CPUS			512
>  extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
>  extern int nr_cpus;
>  
> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> index 9b3fa5730478..feecb5e67caf 100644
> --- a/lib/arm/gic-v3.c
> +++ b/lib/arm/gic-v3.c
> @@ -9,17 +9,21 @@
>  void gicv3_set_redist_base(size_t stride)
>  {
>  	u32 aff = mpidr_compress(get_mpidr());
> -	void *ptr = gicv3_data.redist_base[0];
>  	u64 typer;
> -
> -	do {
> -		typer = gicv3_read_typer(ptr + GICR_TYPER);
> -		if ((typer >> 32) == aff) {
> -			gicv3_redist_base() = ptr;
> -			return;
> -		}
> -		ptr += stride; /* skip RD_base, SGI_base, etc. */
> -	} while (!(typer & GICR_TYPER_LAST));
> +	int i = 0;
> +
> +	while (gicv3_data.redist_bases[i]) {
> +		void *ptr = gicv3_data.redist_bases[i];
> +		do {
> +			typer = gicv3_read_typer(ptr + GICR_TYPER);
> +			if ((typer >> 32) == aff) {
> +				gicv3_redist_base() = ptr;
> +				return;
> +			}
> +			ptr += stride; /* skip RD_base, SGI_base, etc. */
> +		} while (!(typer & GICR_TYPER_LAST));
> +		++i;
> +	}
>  
>  	/* should never reach here */
>  	assert(0);
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 59273b1716d6..94301169215c 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -49,7 +49,7 @@ gic_get_dt_bases(const char *compatible, void **base1, void **base2)
>  	struct dt_pbus_reg reg;
>  	struct dt_device gic;
>  	struct dt_bus bus;
> -	int node, ret;
> +	int node, ret, i;
>  
>  	dt_bus_init_defaults(&bus);
>  	dt_device_init(&gic, &bus, NULL);
> @@ -66,9 +66,13 @@ gic_get_dt_bases(const char *compatible, void **base1, void **base2)
>  	assert(ret == 0);
>  	*base1 = ioremap(reg.addr, reg.size);
>  
> -	ret = dt_pbus_translate(&gic, 1, &reg);
> -	assert(ret == 0);
> -	*base2 = ioremap(reg.addr, reg.size);
> +	for (i = 0; i < GICV3_NR_REDISTS; ++i) {
> +		ret = dt_pbus_translate(&gic, i + 1, &reg);
> +		if (ret == -FDT_ERR_NOTFOUND)
> +			break;
> +		assert(ret == 0);
> +		base2[i] = ioremap(reg.addr, reg.size);
> +	}
>  
>  	return true;
>  }
> @@ -82,7 +86,7 @@ int gicv2_init(void)
>  int gicv3_init(void)
>  {
>  	return gic_get_dt_bases("arm,gic-v3", &gicv3_data.dist_base,
> -			&gicv3_data.redist_base[0]);
> +			&gicv3_data.redist_bases[0]);
>  }
>  
>  int gic_version(void)
> 

Queued, thanks.

Paolo
