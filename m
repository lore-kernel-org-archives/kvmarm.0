From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests RFC 05/15] arm/arm64: GICv3: add
 cpu count
Date: Tue, 6 Dec 2016 10:29:25 +0100
Message-ID: <20161206092925.mk4gwx7jbomzxsfz@kamzik.brq.redhat.com>
References: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
 <1480974406-29345-6-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1480974406-29345-6-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, pbonzini@redhat.com, alex.bennee@linaro.org, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 05, 2016 at 10:46:36PM +0100, Eric Auger wrote:
> Add a new cpu_count field in gicv3_data indicating the
> number of redistributors. This will be useful for enumeration
> of their resources such as LPI pending tables.

I'm fine with the additional state, but just curious, will it
ever be possible for gicv3.cpu_count != nr_cpus?

> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  lib/arm/asm/gic-v3.h | 1 +
>  lib/arm/gic-v3.c     | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index ed330af..039b7c2 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -58,6 +58,7 @@ struct gicv3_data {
>  	void *dist_base;
>  	void *redist_base[NR_CPUS];
>  	unsigned int irq_nr;
> +	unsigned int cpu_count;
>  };
>  extern struct gicv3_data gicv3_data;
>  
> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> index 6246221..9921f4d 100644
> --- a/lib/arm/gic-v3.c
> +++ b/lib/arm/gic-v3.c
> @@ -12,12 +12,14 @@ void gicv3_set_redist_base(size_t stride)
>  	void *ptr = gicv3_data.redist_base[0];
>  	u64 typer;
>  
> +	gicv3_data.cpu_count = 0;
>  	do {
>  		typer = gicv3_read_typer(ptr + GICR_TYPER);
>  		if ((typer >> 32) == aff) {
>  			gicv3_redist_base() = ptr;
>  			return;
>  		}
> +		gicv3_data.cpu_count++;
>  		ptr += stride; /* skip RD_base, SGI_base, etc. */
>  	} while (!(typer & GICR_TYPER_LAST));
>  
> -- 
> 2.5.5
> 
> 
