From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm/pmu: fix probe on AArch64-only
 machines
Date: Thu, 8 Dec 2016 17:00:10 +0100
Message-ID: <20161208160010.42ymgo6tt3jq7xba@kamzik.brq.redhat.com>
References: <20161208152315.28752-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161208152315.28752-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: wei@redhat.com, cov@codeaurora.org, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 08, 2016 at 04:23:15PM +0100, Andrew Jones wrote:
> The spec for ID_DFR0_EL1 says "In an AArch64-only implementation,
> this register is UNKNOWN." Indeed ThunderX just returns zero when
> that register is read. That means we can't rely on a non-zero
> value to determine if we can test the PMU. As the pmu-version is
> only needed by ARM/AArch32, then if we're running AArch64 code,
> we can return true from pmu_probe() even when pmu-version is zero.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> ---
> Applies on top of not-yet-merged
> https://lists.gnu.org/archive/html/qemu-devel/2016-12/msg00811.html
> ---
>  arm/pmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index a39dae43c99e..a0597c5b7806 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -37,6 +37,7 @@
>  
>  static unsigned int pmu_version;
>  #if defined(__arm__)
> +#define is_aarch64() (false)
>  #define PMCR         __ACCESS_CP15(c9, 0, c12, 0)
>  #define ID_DFR0      __ACCESS_CP15(c0, 0, c1, 2)
>  #define PMSELR       __ACCESS_CP15(c9, 0, c12, 5)
> @@ -95,6 +96,7 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>  	: "cc");
>  }
>  #elif defined(__aarch64__)
> +#define is_aarch64() (true)
>  static inline uint32_t get_id_dfr0(void) { return read_sysreg(id_dfr0_el1); }
>  static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
>  static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
> @@ -265,7 +267,7 @@ bool pmu_probe(void)
>  	if (pmu_version)
>  		report_info("PMU version: %d", pmu_version);
>  
> -	return pmu_version;
> +	return pmu_version || is_aarch64();

Hrm, to keep the probe useful for aarch64, I guess I should look at
ID_AA64DFR0_EL1. Will spin a v2 with Wei's [offline] suggestion to
introduce a get_pmu_version() function.

>  }
>  
>  int main(int argc, char *argv[])
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
