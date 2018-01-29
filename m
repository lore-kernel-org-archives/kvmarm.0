From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 12/14] firmware/psci: Expose PSCI conduit
Date: Mon, 29 Jan 2018 10:04:49 +0000
Message-ID: <CAKv+Gu8RAzwpcGqrSxsegYnVgfFQCkYp+sgaPzm8906A4QMLCw@mail.gmail.com>
References: <20180126142847.31240-1-marc.zyngier@arm.com> <20180126142847.31240-13-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180126142847.31240-13-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jon Masters <jcm@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 26 January 2018 at 14:28, Marc Zyngier <marc.zyngier@arm.com> wrote:
> In order to call into the firmware to apply workarounds, it is
> useful to find out whether we're using HVC or SMC. Let's expose
> this through the psci_ops.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/firmware/psci.c | 26 +++++++++++++++++++++-----
>  include/linux/psci.h    |  7 +++++++
>  2 files changed, 28 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
> index 8b25d31e8401..570187e5d084 100644
> --- a/drivers/firmware/psci.c
> +++ b/drivers/firmware/psci.c
> @@ -59,7 +59,9 @@ bool psci_tos_resident_on(int cpu)
>         return cpu == resident_cpu;
>  }
>
> -struct psci_operations psci_ops;
> +struct psci_operations psci_ops = {
> +       .conduit = PSCI_CONDUIT_NONE,
> +};
>
>  typedef unsigned long (psci_fn)(unsigned long, unsigned long,
>                                 unsigned long, unsigned long);
> @@ -210,6 +212,20 @@ static unsigned long psci_migrate_info_up_cpu(void)
>                               0, 0, 0);
>  }
>
> +static void set_conduit(enum psci_conduit conduit)
> +{
> +       switch (conduit) {
> +       case PSCI_CONDUIT_HVC:
> +               invoke_psci_fn = __invoke_psci_fn_hvc;
> +               break;
> +       case PSCI_CONDUIT_SMC:
> +               invoke_psci_fn = __invoke_psci_fn_smc;
> +               break;

I get a GCC warning here about PSCI_CONDUIT_NONE not being handled.

> +       }
> +
> +       psci_ops.conduit = conduit;
> +}
> +
>  static int get_set_conduit_method(struct device_node *np)
>  {
>         const char *method;
> @@ -222,9 +238,9 @@ static int get_set_conduit_method(struct device_node *np)
>         }
>
>         if (!strcmp("hvc", method)) {
> -               invoke_psci_fn = __invoke_psci_fn_hvc;
> +               set_conduit(PSCI_CONDUIT_HVC);
>         } else if (!strcmp("smc", method)) {
> -               invoke_psci_fn = __invoke_psci_fn_smc;
> +               set_conduit(PSCI_CONDUIT_SMC);
>         } else {
>                 pr_warn("invalid \"method\" property: %s\n", method);
>                 return -EINVAL;
> @@ -654,9 +670,9 @@ int __init psci_acpi_init(void)
>         pr_info("probing for conduit method from ACPI.\n");
>
>         if (acpi_psci_use_hvc())
> -               invoke_psci_fn = __invoke_psci_fn_hvc;
> +               set_conduit(PSCI_CONDUIT_HVC);
>         else
> -               invoke_psci_fn = __invoke_psci_fn_smc;
> +               set_conduit(PSCI_CONDUIT_SMC);
>
>         return psci_probe();
>  }
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index f724fd8c78e8..f2679e5faa4f 100644
> --- a/include/linux/psci.h
> +++ b/include/linux/psci.h
> @@ -25,6 +25,12 @@ bool psci_tos_resident_on(int cpu);
>  int psci_cpu_init_idle(unsigned int cpu);
>  int psci_cpu_suspend_enter(unsigned long index);
>
> +enum psci_conduit {
> +       PSCI_CONDUIT_NONE,
> +       PSCI_CONDUIT_SMC,
> +       PSCI_CONDUIT_HVC,
> +};
> +
>  struct psci_operations {
>         u32 (*get_version)(void);
>         int (*cpu_suspend)(u32 state, unsigned long entry_point);
> @@ -34,6 +40,7 @@ struct psci_operations {
>         int (*affinity_info)(unsigned long target_affinity,
>                         unsigned long lowest_affinity_level);
>         int (*migrate_info_type)(void);
> +       enum psci_conduit conduit;
>  };
>
>  extern struct psci_operations psci_ops;
> --
> 2.14.2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
