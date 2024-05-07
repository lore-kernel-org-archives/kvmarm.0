Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DB216D319;
	Tue,  7 May 2024 19:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715108678; cv=none; b=PnhUYk+N96GAa2n7D0Ct4yoxtwbVpbcsV0l2e9L9biXsBzHToP2/mOST+Qo9dRE4h7q5tkqiDgo62YM5KpbeFGBW6tmDcTAVRDq+VfF3HmrmoyCKMbijDbpvv43YVWd9haKdZX7SdeU4C6jfp8nhi7EAf8tmw4QRMyEBXKKOVyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715108678; c=relaxed/simple;
	bh=3v76NM+jOrlOUryio/pQRGXKJKJHeafQ+gQHBREajTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ChO9E2P2xhOMK2fhqHoBVwt98ID8TZdKNNf8TfFuBihp/nOkMjylVYVuw2qI8uG1/aGezx3VwPYguK7D2+/hnUlGdxg+l3Hn47/8uSaSlPzz1DLOXUFktmFKp9T9UBr8mtX1iPec/oSoUI4CIfRlUSlrNTpGtvxDviMO9olois4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qJZ9H6FG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qJZ9H6FG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8806DC4DDE3;
	Tue,  7 May 2024 19:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715108678;
	bh=3v76NM+jOrlOUryio/pQRGXKJKJHeafQ+gQHBREajTk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qJZ9H6FGvaNa+rqavvwRSHCzNDyyK3G2iMcKCKAJuEMifCpF3lTIUYrHGKr/Qdy7j
	 78GoPsHwipvZKcprt9KOQCo59QlIeYk/lcKWYytWGbuMh7HMBCh27UQcKTUBUqjbkY
	 XwV85JmvVtH+PldEETQkXfVcJVK4PtHwab3ScELJ4/8CtkoaY5OYxw99EQnBBPIc3B
	 ePzvTZyr/oY8nvvMEOqkxfGR2TKRfkse//oF2v4WMfBpMo62lkPwn0mUGrRlGgsHmL
	 cqSmEbgFRmY1l4NuKt688kDXFmv2i6KR1cBtwYOqIi2HdEF6hd8eBsuTp4jRz1+Hah
	 Cse1iQrlmVuyA==
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5ac4470de3bso977770eaf.0;
        Tue, 07 May 2024 12:04:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVvzMmCP+uqi196X6rOfNt0pq5qntBawvcMFmjuGOFaToRVh0do0BpIsHo8p86kxT+dFrJ/l4FZkDmu9xVJivQab6qXrLokOxgbly6oO/TKwddNspjMke8kdr1ff/FuJtiQ
X-Gm-Message-State: AOJu0YxzYYzacbpqlzniD80bns0Vtzs+DrToKsj7azimgbPK0hB4u9TA
	DSW8mZBr9GtPWRoPDkpL6d5SxNYoZ4Y/9gGRgQtNrBls5ConUXRrICcXNiQwGAsBojwU8vx/gTO
	l3WKoaO6+eVUWfN+2ArMRlJkcCIk=
X-Google-Smtp-Source: AGHT+IHX8ldGBC21INOFFn8CQRUKzbcUlOKqwI+wLw8L16eaDNxHhHjLjt4/RM6CgqyFnp75RyfwMmK3VmDCdjKzPYU=
X-Received: by 2002:a4a:92c9:0:b0:5b2:f29:93f0 with SMTP id
 006d021491bc7-5b24caad9d2mr450076eaf.0.1715108677751; Tue, 07 May 2024
 12:04:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240430142434.10471-1-Jonathan.Cameron@huawei.com> <20240430142434.10471-7-Jonathan.Cameron@huawei.com>
In-Reply-To: <20240430142434.10471-7-Jonathan.Cameron@huawei.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 7 May 2024 21:04:26 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0g-Aenoj5H+pNPtoqTgV5U7K5RGNjdOnqobqxkyL5NMVQ@mail.gmail.com>
Message-ID: <CAJZ5v0g-Aenoj5H+pNPtoqTgV5U7K5RGNjdOnqobqxkyL5NMVQ@mail.gmail.com>
Subject: Re: [PATCH v9 06/19] ACPI: processor: Move checks and availability of
 acpi_processor earlier
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, linux-pm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-acpi@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org, 
	Russell King <linux@armlinux.org.uk>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>, 
	Salil Mehta <salil.mehta@huawei.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Hanjun Guo <guohanjun@huawei.com>, Gavin Shan <gshan@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, linuxarm@huawei.com, 
	justin.he@arm.com, jianyong.wu@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 30, 2024 at 4:27=E2=80=AFPM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> Make the per_cpu(processors, cpu) entries available earlier so that
> they are available in arch_register_cpu() as ARM64 will need access
> to the acpi_handle to distinguish between acpi_processor_add()
> and earlier registration attempts (which will fail as _STA cannot
> be checked).
>
> Reorder the remove flow to clear this per_cpu() after
> arch_unregister_cpu() has completed, allowing it to be used in
> there as well.
>
> Note that on x86 for the CPU hotplug case, the pr->id prior to
> acpi_map_cpu() may be invalid. Thus the per_cpu() structures
> must be initialized after that call or after checking the ID
> is valid (not hotplug path).
>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

One nit below.

> ---
> v9: Add back a blank line accidentally removed in code move.
>     Fix up error returns so that the new cleanup in processor_add()
>     is triggered on detection of the bios bug.
>     Combined with the previous 2 patches, should solve the leak
>     that Gavin identified.
> ---
>  drivers/acpi/acpi_processor.c | 80 +++++++++++++++++++++--------------
>  1 file changed, 49 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.=
c
> index 16e36e55a560..4a79b42d649e 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -183,8 +183,38 @@ static void __init acpi_pcc_cpufreq_init(void) {}
>  #endif /* CONFIG_X86 */
>
>  /* Initialization */
> +static DEFINE_PER_CPU(void *, processor_device_array);
> +
> +static bool acpi_processor_set_per_cpu(struct acpi_processor *pr,
> +                                      struct acpi_device *device)
> +{
> +       BUG_ON(pr->id >=3D nr_cpu_ids);
> +
> +       /*
> +        * Buggy BIOS check.
> +        * ACPI id of processors can be reported wrongly by the BIOS.
> +        * Don't trust it blindly
> +        */
> +       if (per_cpu(processor_device_array, pr->id) !=3D NULL &&
> +           per_cpu(processor_device_array, pr->id) !=3D device) {
> +               dev_warn(&device->dev,
> +                        "BIOS reported wrong ACPI id %d for the processo=
r\n",
> +                        pr->id);
> +               return false;
> +       }
> +       /*
> +        * processor_device_array is not cleared on errors to allow buggy=
 BIOS
> +        * checks.
> +        */
> +       per_cpu(processor_device_array, pr->id) =3D device;
> +       per_cpu(processors, pr->id) =3D pr;
> +
> +       return true;
> +}
> +
>  #ifdef CONFIG_ACPI_HOTPLUG_CPU
> -static int acpi_processor_hotadd_init(struct acpi_processor *pr)
> +static int acpi_processor_hotadd_init(struct acpi_processor *pr,
> +                                     struct acpi_device *device)
>  {
>         int ret;
>
> @@ -198,8 +228,16 @@ static int acpi_processor_hotadd_init(struct acpi_pr=
ocessor *pr)
>         if (ret)
>                 goto out;
>
> +       if (!acpi_processor_set_per_cpu(pr, device)) {
> +               ret =3D -EINVAL;
> +               acpi_unmap_cpu(pr->id);
> +               goto out;
> +       }
> +
>         ret =3D arch_register_cpu(pr->id);
>         if (ret) {
> +               /* Leave the processor device array in place to detect bu=
ggy bios */
> +               per_cpu(processors, pr->id) =3D NULL;
>                 acpi_unmap_cpu(pr->id);
>                 goto out;
>         }
> @@ -217,7 +255,8 @@ static int acpi_processor_hotadd_init(struct acpi_pro=
cessor *pr)
>         return ret;
>  }
>  #else
> -static inline int acpi_processor_hotadd_init(struct acpi_processor *pr)
> +static inline int acpi_processor_hotadd_init(struct acpi_processor *pr,
> +                                            struct acpi_device *device)
>  {
>         return -ENODEV;
>  }
> @@ -316,10 +355,13 @@ static int acpi_processor_get_info(struct acpi_devi=
ce *device)
>          *  because cpuid <-> apicid mapping is persistent now.
>          */
>         if (invalid_logical_cpuid(pr->id) || !cpu_present(pr->id)) {
> -               int ret =3D acpi_processor_hotadd_init(pr);
> +               int ret =3D acpi_processor_hotadd_init(pr, device);
>
>                 if (ret)
>                         return ret;
> +       } else {
> +               if (!acpi_processor_set_per_cpu(pr, device))
> +                       return -EINVAL;
>         }

This looks a bit odd.

I would make acpi_processor_set_per_cpu() return 0 on success and
-EINVAL on failure and the above would become

if (invalid_logical_cpuid(pr->id) || !cpu_present(pr->id))
         ret =3D acpi_processor_hotadd_init(pr, device);
else
        ret =3D acpi_processor_set_per_cpu(pr, device);

if (ret)
        return ret;

(and of course ret needs to be defined at the beginning of the function).

>
>         /*
> @@ -365,8 +407,6 @@ static int acpi_processor_get_info(struct acpi_device=
 *device)
>   * (cpu_data(cpu)) values, like CPU feature flags, family, model, etc.
>   * Such things have to be put in and set up by the processor driver's .p=
robe().
>   */
> -static DEFINE_PER_CPU(void *, processor_device_array);
> -
>  static int acpi_processor_add(struct acpi_device *device,
>                                         const struct acpi_device_id *id)
>  {
> @@ -395,28 +435,6 @@ static int acpi_processor_add(struct acpi_device *de=
vice,
>         if (result) /* Processor is not physically present or unavailable=
 */
>                 goto err_clear_driver_data;
>
> -       BUG_ON(pr->id >=3D nr_cpu_ids);
> -
> -       /*
> -        * Buggy BIOS check.
> -        * ACPI id of processors can be reported wrongly by the BIOS.
> -        * Don't trust it blindly
> -        */
> -       if (per_cpu(processor_device_array, pr->id) !=3D NULL &&
> -           per_cpu(processor_device_array, pr->id) !=3D device) {
> -               dev_warn(&device->dev,
> -                       "BIOS reported wrong ACPI id %d for the processor=
\n",
> -                       pr->id);
> -               /* Give up, but do not abort the namespace scan. */
> -               goto err_clear_driver_data;
> -       }
> -       /*
> -        * processor_device_array is not cleared on errors to allow buggy=
 BIOS
> -        * checks.
> -        */
> -       per_cpu(processor_device_array, pr->id) =3D device;
> -       per_cpu(processors, pr->id) =3D pr;
> -
>         dev =3D get_cpu_device(pr->id);
>         if (!dev) {
>                 result =3D -ENODEV;
> @@ -470,10 +488,6 @@ static void acpi_processor_remove(struct acpi_device=
 *device)
>         device_release_driver(pr->dev);
>         acpi_unbind_one(pr->dev);
>
> -       /* Clean up. */
> -       per_cpu(processor_device_array, pr->id) =3D NULL;
> -       per_cpu(processors, pr->id) =3D NULL;
> -
>         cpu_maps_update_begin();
>         cpus_write_lock();
>
> @@ -481,6 +495,10 @@ static void acpi_processor_remove(struct acpi_device=
 *device)
>         arch_unregister_cpu(pr->id);
>         acpi_unmap_cpu(pr->id);
>
> +       /* Clean up. */
> +       per_cpu(processor_device_array, pr->id) =3D NULL;
> +       per_cpu(processors, pr->id) =3D NULL;
> +
>         cpus_write_unlock();
>         cpu_maps_update_done();
>
> --
> 2.39.2
>
