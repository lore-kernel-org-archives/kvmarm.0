Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E180BD53E;
	Fri, 12 Apr 2024 18:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712946654; cv=none; b=oX9CWxw6OPgeZ+SvTf4SQ3EjarXDMlXaCLfrrts0gLg9YLOLPmfYSeSGLThMDZ2cbdLsaZEj/z+t9QiufjiOZcnRD7rRDFbjJnTDjvhfQAjgWxygzLoK8SsvVUeFf0OR1Tf/tgMYysyFUobUZPhNlFLXLvkAp4PR2hOEU1EavPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712946654; c=relaxed/simple;
	bh=PjJ0r1jv+Gy40inFGbGqF8OvINrRwJDv/80NI2l5XUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ob0vKW4xECMJ/+B/uGvV40f3JnGFPnUcXnjWoUnp/kjrMG7X4+b+B4F0FdNiznKELJ93pOC7fNJeEVBCQ0AYQtbUEXOQSmS6jEN7Bxc/u4Y0UCOCCgSinb9QkMJSlAca4ujV53hD8ZMHrkgSO7bkWq/faSEmoYaFFjwpQ0syU0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQQWusNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQQWusNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732F4C32786;
	Fri, 12 Apr 2024 18:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712946653;
	bh=PjJ0r1jv+Gy40inFGbGqF8OvINrRwJDv/80NI2l5XUc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZQQWusNG6ExBvY436QlvONSgQH5kbBgDfbHpEXf21tXhje42q0jreHJC9+TdiOZTb
	 /AEVXF46pkLyBL0qmtps6lIkaCDRZE06wX4rAI9ukziCq86KHNjF+ssi2wG5/ccvIw
	 z19wt8wvGtJ8ZjwjOfLaLcex6/4MwD1lfR6DDBFkZ5fsnZiWIJN++FbgCcL7ko1EwI
	 9btL93ZH4JI9iDwfPNB9Y7u2Tc9fw5RxLDg/eqbtvcoFWufEQBMk1DExUfDwCFJtww
	 C7jYNeF52ysH7D2f2zo8BxxoyzRfqvk9xpAkNeCFmpKFwgtuNH//JHaOqaPCClC0fq
	 2nJ877KMWCiDg==
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-22ed9094168so239880fac.1;
        Fri, 12 Apr 2024 11:30:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVOcMrqPwkhI7XSAKWKmdT5JDQlqDE82eLap96bYYWwym95Wnvg54cke3dDJ+vkqK/pH/IuULb1uMvfsKkZ5qhCKeMdLdJnUp3rGzub9bqR6i5PXhoS7C/VfF+jXKWNYAVr
X-Gm-Message-State: AOJu0YxFypF5dceW5e9TehD8654ioljrfvyazi+1p+BE0vIfrHPA711R
	o6SIbt1pUW02MVfDmli9rk5x2pVkKZEHzvVBwQ5ga4SLvuIO+0bPnUYh3wen09hRHkfgd09L1L0
	ssh+cQbmEPGSWFkV5M904KjBGDo4=
X-Google-Smtp-Source: AGHT+IFDKbKacACQlXu+Vha1dYER/o7zLL0gXJIc6Jg1rU5tcmimRio9VrXjAKDGAGecTYjA8A0m0vMnHNM03elbI48=
X-Received: by 2002:a05:6871:612:b0:229:ee6d:77da with SMTP id
 w18-20020a056871061200b00229ee6d77damr3536849oan.2.1712946652664; Fri, 12 Apr
 2024 11:30:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240412143719.11398-1-Jonathan.Cameron@huawei.com> <20240412143719.11398-4-Jonathan.Cameron@huawei.com>
In-Reply-To: <20240412143719.11398-4-Jonathan.Cameron@huawei.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 12 Apr 2024 20:30:40 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0gNvy2e=hOGQQ2kLpnrDr8=QGBax-E5odEJ=7BA8qW-9A@mail.gmail.com>
Message-ID: <CAJZ5v0gNvy2e=hOGQQ2kLpnrDr8=QGBax-E5odEJ=7BA8qW-9A@mail.gmail.com>
Subject: Re: [PATCH v5 03/18] ACPI: processor: Register deferred CPUs from acpi_processor_get_info()
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-pm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, x86@kernel.org, Russell King <linux@armlinux.org.uk>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Miguel Luis <miguel.luis@oracle.com>, 
	James Morse <james.morse@arm.com>, Salil Mehta <salil.mehta@huawei.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linuxarm@huawei.com, justin.he@arm.com, 
	jianyong.wu@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 12, 2024 at 4:38=E2=80=AFPM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> From: James Morse <james.morse@arm.com>
>
> The arm64 specific arch_register_cpu() call may defer CPU registration
> until the ACPI interpreter is available and the _STA method can
> be evaluated.
>
> If this occurs, then a second attempt is made in
> acpi_processor_get_info(). Note that the arm64 specific call has
> not yet been added so for now this will never be successfully
> called.
>
> Systems can still be booted with 'acpi=3Doff', or not include an
> ACPI description at all as in these cases arch_register_cpu()
> will not have deferred registration when first called.
>
> This moves the CPU register logic back to a subsys_initcall(),
> while the memory nodes will have been registered earlier.
> Note this is where the call was prior to the cleanup series so
> there should be no side effects of moving it back again for this
> specific case.
>
> [PATCH 00/21] Initial cleanups for vCPU HP.
> https://lore.kernel.org/all/ZVyz%2FVe5pPu8AWoA@shell.armlinux.org.uk/
>
> e.g. 5b95f94c3b9f ("x86/topology: Switch over to GENERIC_CPU_DEVICES")
>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Miguel Luis <miguel.luis@oracle.com>
> Tested-by: Vishnu Pajjuri <vishnu@os.amperecomputing.com>
> Tested-by: Jianyong Wu <jianyong.wu@arm.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Joanthan Cameron <Jonathan.Cameron@huawei.com>
> ---
> v5: Update commit message to make it clear this is moving the
>     init back to where it was until very recently.
>
>     No longer change the condition in the earlier registration point
>     as that will be handled by the arm64 registration routine
>     deferring until called again here.
> ---
>  drivers/acpi/acpi_processor.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.=
c
> index 93e029403d05..c78398cdd060 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -317,6 +317,18 @@ static int acpi_processor_get_info(struct acpi_devic=
e *device)
>
>         c =3D &per_cpu(cpu_devices, pr->id);
>         ACPI_COMPANION_SET(&c->dev, device);
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
> --

I am still unsure why there need to be two paths calling
arch_register_cpu() in acpi_processor_get_info().

Just below the comment partially pulled into the patch context above,
there is this code:

if (invalid_logical_cpuid(pr->id) || !cpu_present(pr->id)) {
         int ret =3D acpi_processor_hotadd_init(pr);

        if (ret)
                return ret;
}

For the sake of the argument, fold acpi_processor_hotadd_init() into
it and drop the redundant _STA check from it:

if (invalid_logical_cpuid(pr->id) || !cpu_present(pr->id)) {
        if (invalid_phys_cpuid(pr->phys_id))
                return -ENODEV;

        cpu_maps_update_begin();
        cpus_write_lock();

       ret =3D acpi_map_cpu(pr->handle, pr->phys_id, pr->acpi_id, &pr->id);
       if (ret) {
                cpus_write_unlock();
                cpu_maps_update_done();
                return ret;
       }
       ret =3D arch_register_cpu(pr->id);
       if (ret) {
                acpi_unmap_cpu(pr->id);

                cpus_write_unlock();
                cpu_maps_update_done();
                return ret;
       }
      pr_info("CPU%d has been hot-added\n", pr->id);
      pr->flags.need_hotplug_init =3D 1;

      cpus_write_unlock();
      cpu_maps_update_done();
}

so I'm not sure why this cannot be combined with the new code.

Say acpi_map_cpu) / acpi_unmap_cpu() are turned into arch calls.
What's the difference then?  The locking, which should be fine if I'm
not mistaken and need_hotplug_init that needs to be set if this code
runs after the processor driver has loaded AFAICS.
