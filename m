From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 14/18] firmware/psci: Expose SMCCC version through psci_ops
Date: Thu, 1 Feb 2018 21:17:25 +0000
Message-ID: <CAKv+Gu9Fpmc+Q2iQ-EoJ0TYkzh1nh59XQthuzh9Q9W+66pHSZg@mail.gmail.com>
References: <20180201114657.7323-1-marc.zyngier@arm.com> <20180201114657.7323-15-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180201114657.7323-15-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 February 2018 at 11:46, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Since PSCI 1.0 allows the SMCCC version to be (indirectly) probed,
> let's do that at boot time, and expose the version of the calling
> convention as part of the psci_ops structure.
>
> Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/firmware/psci.c | 19 +++++++++++++++++++
>  include/linux/psci.h    |  6 ++++++
>  2 files changed, 25 insertions(+)
>
> diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
> index e9493da2b111..8631906c414c 100644
> --- a/drivers/firmware/psci.c
> +++ b/drivers/firmware/psci.c
> @@ -61,6 +61,7 @@ bool psci_tos_resident_on(int cpu)
>
>  struct psci_operations psci_ops = {
>         .conduit = PSCI_CONDUIT_NONE,
> +       .smccc_version = SMCCC_VERSION_1_0,
>  };
>
>  typedef unsigned long (psci_fn)(unsigned long, unsigned long,
> @@ -511,6 +512,23 @@ static void __init psci_init_migrate(void)
>         pr_info("Trusted OS resident on physical CPU 0x%lx\n", cpuid);
>  }
>
> +static void __init psci_init_smccc(u32 ver)
> +{
> +       int feature;
> +
> +       feature = psci_features(ARM_SMCCC_VERSION_FUNC_ID);
> +
> +       if (feature != PSCI_RET_NOT_SUPPORTED) {
> +               ver = invoke_psci_fn(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0);
> +               if (ver != ARM_SMCCC_VERSION_1_1)
> +                       psci_ops.smccc_version = SMCCC_VERSION_1_0;
> +               else
> +                       psci_ops.smccc_version = SMCCC_VERSION_1_1;
> +       }
> +
> +       pr_info("SMC Calling Convention v1.%d\n", psci_ops.smccc_version);

This is a bit nasty: you are returning the numeric value of the enum
as the minor number, and hardcoding the major version number as 1,
while the return value of ARM_SMCCC_VERSION_FUNC_ID gives you the
exact numbers. I assume nobody is expecting SMCCC v2.3 anytime soon,
but it would still be a lot nicer to simply decode the value of 'ver'
(and make it default to ARM_SMCCC_VERSION_1_0 if the PSCI feature call
fails)


> +}
> +
>  static void __init psci_0_2_set_functions(void)
>  {
>         pr_info("Using standard PSCI v0.2 function IDs\n");
> @@ -559,6 +577,7 @@ static int __init psci_probe(void)
>         psci_init_migrate();
>
>         if (PSCI_VERSION_MAJOR(ver) >= 1) {
> +               psci_init_smccc(ver);
>                 psci_init_cpu_suspend();
>                 psci_init_system_suspend();
>         }
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index f2679e5faa4f..8b1b3b5935ab 100644
> --- a/include/linux/psci.h
> +++ b/include/linux/psci.h
> @@ -31,6 +31,11 @@ enum psci_conduit {
>         PSCI_CONDUIT_HVC,
>  };
>
> +enum smccc_version {
> +       SMCCC_VERSION_1_0,
> +       SMCCC_VERSION_1_1,
> +};
> +
>  struct psci_operations {
>         u32 (*get_version)(void);
>         int (*cpu_suspend)(u32 state, unsigned long entry_point);
> @@ -41,6 +46,7 @@ struct psci_operations {
>                         unsigned long lowest_affinity_level);
>         int (*migrate_info_type)(void);
>         enum psci_conduit conduit;
> +       enum smccc_version smccc_version;
>  };
>
>  extern struct psci_operations psci_ops;
> --
> 2.14.2
>
