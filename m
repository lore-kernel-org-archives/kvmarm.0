From: Wei Huang <wei@redhat.com>
Subject: Re: [PATCH kvm-unit-tests v2 2/2] arm/pmu: don't run tcg tests
Date: Fri, 9 Dec 2016 10:51:44 -0600
Message-ID: <33dc3758-2d3f-c207-8df2-46785af7c47e@redhat.com>
References: <20161208170549.8793-1-drjones@redhat.com>
 <20161208170549.8793-3-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161208170549.8793-3-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: cov@codeaurora.org, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu



On 12/08/2016 11:05 AM, Andrew Jones wrote:
> The TCG PMU is barely implemented for ARM and not at all implemented
> for AArch64. Let's not bother running the TCG-only tests yet. We'll
> likely move them to a new TCG-only unittests.cfg at some point before
> re-enabling them too.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

It is always safe to disable TCG tests, as proposed in this patch.
However I don't think we need it because PMU will behave correctly after
your PATCH 1:

1. Under TCG AArch32 mode, get_pmu_version() returns 2. This is
acceptable for pmu-tcg-icount-1 and pmu-tcg-icount-256. We should allow
the tests to proceed.
2. Under TCG AArch64, get_pmu_version() returns 0. pmu-tcg-icount-1 and
pmu-tcg-icount-256 will skip because pmu_probe() returns FALSE. As long
as there isn't an error, most people will be OK to see SKIP message.

Thanks,
-Wei

> ---
>  arm/unittests.cfg | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 044d97c9e73d..65f9c4c0b9eb 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -65,15 +65,15 @@ file = pmu.flat
>  groups = pmu
>  
>  # Test PMU support (TCG) with -icount IPC=1
> -[pmu-tcg-icount-1]
> -file = pmu.flat
> -extra_params = -icount 0 -append '1'
> -groups = pmu
> -accel = tcg
> +#[pmu-tcg-icount-1]
> +#file = pmu.flat
> +#extra_params = -icount 0 -append '1'
> +#groups = pmu
> +#accel = tcg
>  
>  # Test PMU support (TCG) with -icount IPC=256
> -[pmu-tcg-icount-256]
> -file = pmu.flat
> -extra_params = -icount 8 -append '256'
> -groups = pmu
> -accel = tcg
> +#[pmu-tcg-icount-256]
> +#file = pmu.flat
> +#extra_params = -icount 8 -append '256'
> +#groups = pmu
> +#accel = tcg
> 
