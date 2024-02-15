Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9C6136983;
	Thu, 15 Feb 2024 19:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708024963; cv=none; b=Xk848vipwbAYZFm2H+ycK1ZupeXk0/q1JuwHxNHuEowpq69h2KQ4IH17Cn+qTm9k3woIc0XjQT89KO/vU+Z43nAnVD+wYn9bUvTQoBx+P67wCvNgiRR+FTMc7BLUPjN4Frx6SRCFRFZ/4gr4JjabuNU7r+BQfQbGRkUhEAPZS/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708024963; c=relaxed/simple;
	bh=gCJhOtMnRU8UWRkUPUSVOlRb9/TApbJfHXnwR2CW2HQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NmGPgXXC4zRaPFVcF0GYC39c6mcnrKAExCMOxLeCU0Ep87Z0fWuwPuT7q2Z5Ygh9m7BTDUP5Gf8Z1yCUb5O4WxIR1c/zPJT53Q7OtuhIiBfffGl3FpuqW4raU3jeT8PlodfSJ1bS+loNQ/4LvSNX24kAmosOqUhnmfEEsRTYdfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6e2b466d213so194848a34.0;
        Thu, 15 Feb 2024 11:22:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708024960; x=1708629760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=atg7WI78HsTq5644XbnZluXts4d5OR/FFe0QfcIw1Ag=;
        b=gPlLuLTbaoPZxFKlJWWz7toR9IlO4bgR1QVIBOrBwEuGG6Uc+OSORVq/751qHVlwVs
         BLp6DRtI22/Fh7ekCZ2GwBo5ZfN3tJ35jQvUv86tyPj2OAXYuUy5HTj4Ou/Ixu2tBQZU
         Uu05Pj2qGmdLjejy0E0lmDNZ7v4xWZYnPKliUAwZtP47UKyXDsPSqSn9rAARLMvFxAY4
         kLyp7ewd5masDhYYlHVDHYD8DFAeastZWCx1z/G7YTX5eXWbqWqiYCFq880OCMukFQn+
         NIj+PfQ+6Xk8EiYgWJIMOl7/+Tw/nsD1sa79xg7+5OxtWQj+TSX/kJsqN2ZDTN3DNMo9
         Uung==
X-Forwarded-Encrypted: i=1; AJvYcCWi7bioNAck/46Q1wF5YffwuJZ1H46iKIAojCNSi/vmKAh3+6vKV/994DmtnLOQjEN8XaZJTtFJ+MEqUZxqYEVWovzb5v2URRL0UC7IzBG6phbbufgetm/Vt54Z8kZig02C
X-Gm-Message-State: AOJu0YxIMCD21gzer8Sv3pA3Zq5f3xJI1sbHcziuHIJtzibMToz3HvbP
	gQzPwOT3gdC0vtDxNfm9/EaZdVdLLLzaDNGv7m9HTyON4oA0SpekRSOttBmGwOT3vmHBsrlXY8L
	MuMSfBK8KpaTQhvuvf6TVtoH297A=
X-Google-Smtp-Source: AGHT+IGH9nzxfJPZ0b9LL7NeSQVmLFmBC+x3c+fnaZmT/Dcf6w2GoSt64Z11xwqZfq7drVdSJDbhPxjptv1uaDnhYPo=
X-Received: by 2002:a05:6820:1f8d:b0:59c:d8cd:ecee with SMTP id
 eq13-20020a0568201f8d00b0059cd8cdeceemr110694oob.1.1708024960621; Thu, 15 Feb
 2024 11:22:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Zbp5xzmFhKDAgHws@shell.armlinux.org.uk> <E1rVDmU-0027YP-Jz@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1rVDmU-0027YP-Jz@rmk-PC.armlinux.org.uk>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 15 Feb 2024 20:22:29 +0100
Message-ID: <CAJZ5v0iiJpUWq5GMSnKFWQTzn_bdwoQz9m=hDaXNg4Lj_ePF4g@mail.gmail.com>
Subject: Re: [PATCH RFC v4 02/15] ACPI: processor: Register all CPUs from acpi_processor_get_info()
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: linux-pm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org, 
	acpica-devel@lists.linuxfoundation.org, linux-csky@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-ia64@vger.kernel.org, 
	linux-parisc@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com, justin.he@arm.com, 
	James Morse <james.morse@arm.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 5:50=E2=80=AFPM Russell King <rmk+kernel@armlinux.o=
rg.uk> wrote:
>
> From: James Morse <james.morse@arm.com>
>
> To allow ACPI to skip the call to arch_register_cpu() when the _STA
> value indicates the CPU can't be brought online right now, move the
> arch_register_cpu() call into acpi_processor_get_info().
>
> Systems can still be booted with 'acpi=3Doff', or not include an
> ACPI description at all. For these, the CPUs continue to be
> registered by cpu_dev_register_generic().
>
> This moves the CPU register logic back to a subsys_initcall(),
> while the memory nodes will have been registered earlier.
>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Miguel Luis <miguel.luis@oracle.com>
> Tested-by: Vishnu Pajjuri <vishnu@os.amperecomputing.com>
> Tested-by: Jianyong Wu <jianyong.wu@arm.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> Changes since RFC v2:
>  * Fixup comment in acpi_processor_get_info() (Gavin Shan)
>  * Add comment in cpu_dev_register_generic() (Gavin Shan)
> ---
>  drivers/acpi/acpi_processor.c | 12 ++++++++++++
>  drivers/base/cpu.c            |  6 +++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.=
c
> index cf7c1cca69dd..a68c475cdea5 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -314,6 +314,18 @@ static int acpi_processor_get_info(struct acpi_devic=
e *device)
>                         cpufreq_add_device("acpi-cpufreq");
>         }
>
> +       /*
> +        * Register CPUs that are present. get_cpu_device() is used to sk=
ip
> +        * duplicate CPU descriptions from firmware.
> +        */
> +       if (!invalid_logical_cpuid(pr->id) && cpu_present(pr->id) &&
> +           !get_cpu_device(pr->id)) {
> +               int ret =3D arch_register_cpu(pr->id);
> +
> +               if (ret)
> +                       return ret;
> +       }
> +
>         /*
>          *  Extra Processor objects may be enumerated on MP systems with
>          *  less than the max # of CPUs. They should be ignored _iff

This is interesting, because right below there is the following code:

    if (invalid_logical_cpuid(pr->id) || !cpu_present(pr->id)) {
        int ret =3D acpi_processor_hotadd_init(pr);

        if (ret)
            return ret;
    }

and acpi_processor_hotadd_init() essentially calls arch_register_cpu()
with some extra things around it (more about that below).

I do realize that acpi_processor_hotadd_init() is defined under
CONFIG_ACPI_HOTPLUG_CPU, so for the sake of the argument let's
consider an architecture where CONFIG_ACPI_HOTPLUG_CPU is set.

So why are the two conditionals that almost contradict each other both
needed?  It looks like the new code could be combined with
acpi_processor_hotadd_init() to do the right thing in all cases.

Now, acpi_processor_hotadd_init() does some extra things that look
like they should be done by the new code too.

1. It checks invalid_phys_cpuid() which appears to be a good idea to me.

2. It uses locking around arch_register_cpu() which doesn't seem
unreasonable either.

3. It calls acpi_map_cpu() and I'm not sure why this is not done by
the new code.

The only thing that can be dropped from it is the _STA check AFAICS,
because acpi_processor_add() won't even be called if the CPU is not
present (and not enabled after the first patch).

So why does the code not do 1 - 3 above?

> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 47de0f140ba6..13d052bf13f4 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -553,7 +553,11 @@ static void __init cpu_dev_register_generic(void)
>  {
>         int i, ret;
>
> -       if (!IS_ENABLED(CONFIG_GENERIC_CPU_DEVICES))
> +       /*
> +        * When ACPI is enabled, CPUs are registered via
> +        * acpi_processor_get_info().
> +        */
> +       if (!IS_ENABLED(CONFIG_GENERIC_CPU_DEVICES) || !acpi_disabled)
>                 return;

Honestly, this looks like a quick hack to me and it absolutely
requires an ACK from the x86 maintainers to go anywhere.

>
>         for_each_present_cpu(i) {
> --
