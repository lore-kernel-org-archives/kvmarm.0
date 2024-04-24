Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1163716C69A;
	Wed, 24 Apr 2024 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713977609; cv=none; b=HZ7JUVKZxBH5F+gXzYTEmv0RGd0AV+mi3OZOc20L9fGafs8cJ8BdqEcfMh/9B1QJIGix9c45dZJtZDEOcqwIOuJMbjOGYRf2tl6BUvpP9OsHF8LjmU+xN3wCUhJZoFUgnQdW3+NjOE6/MB2B+E8hf7cwtSCKvWGQCvHaniBISpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713977609; c=relaxed/simple;
	bh=WPwWr2WPh76sy9Su1xu+shcXvVuaFuGEoKD6YmP9p5o=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g7AJGOa5BA9XJduYx17mz6hLXGd7QNakmrPjTk5KHpWfHPJ5D6Z22OZP9zreGFX5YsiXyzjJZypyiHQecUVTqS8IDRd//lg/TShvkp5SkxiriTNUxj1MttXLfvTLa3pwgn/+J/FmJCJNMOMBTNyxEEglFB9IbxizJrYztkuQdQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VPlRb3lD4z6D94P;
	Thu, 25 Apr 2024 00:53:15 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 6FF8D1406AE;
	Thu, 25 Apr 2024 00:53:24 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Wed, 24 Apr
 2024 17:53:23 +0100
Date: Wed, 24 Apr 2024 17:53:22 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra
	<peterz@infradead.org>, <linux-pm@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linux-acpi@vger.kernel.org>,
	<linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Miguel Luis
	<miguel.luis@oracle.com>, James Morse <james.morse@arm.com>, Salil Mehta
	<salil.mehta@huawei.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <linuxarm@huawei.com>, <justin.he@arm.com>,
	<jianyong.wu@arm.com>
Subject: Re: [PATCH v7 04/16] ACPI: processor: Move checks and availability
 of acpi_processor earlier
Message-ID: <20240424175322.00002b8a@Huawei.com>
In-Reply-To: <CAJZ5v0igyOYnqAWRVeC0JrsFSDaZAaia8SLnWi0LV2OS2z9-DQ@mail.gmail.com>
References: <20240418135412.14730-1-Jonathan.Cameron@huawei.com>
	<20240418135412.14730-5-Jonathan.Cameron@huawei.com>
	<CAJZ5v0igyOYnqAWRVeC0JrsFSDaZAaia8SLnWi0LV2OS2z9-DQ@mail.gmail.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Mon, 22 Apr 2024 20:56:55 +0200
"Rafael J. Wysocki" <rafael@kernel.org> wrote:

> On Thu, Apr 18, 2024 at 3:56=E2=80=AFPM Jonathan Cameron
> <Jonathan.Cameron@huawei.com> wrote:
> >
> > Make the per_cpu(processors, cpu) entries available earlier so that
> > they are available in arch_register_cpu() as ARM64 will need access
> > to the acpi_handle to distinguish between acpi_processor_add()
> > and earlier registration attempts (which will fail as _STA cannot
> > be checked).
> >
> > Reorder the remove flow to clear this per_cpu() after
> > arch_unregister_cpu() has completed, allowing it to be used in
> > there as well.
> >
> > Note that on x86 for the CPU hotplug case, the pr->id prior to
> > acpi_map_cpu() may be invalid. Thus the per_cpu() structures
> > must be initialized after that call or after checking the ID
> > is valid (not hotplug path).
> >
> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > ---
> > v7: Swap order with acpi_unmap_cpu() in acpi_processor_remove()
> >     to keep it in reverse order of the setup path. (thanks Salil)
> >     Fix an issue with placement of CONFIG_ACPI_HOTPLUG_CPU guards.
> > v6: As per discussion in v5 thread, don't use the cpu->dev and
> >     make this data available earlier by moving the assignment checks
> >     int acpi_processor_get_info().
> > ---
> >  drivers/acpi/acpi_processor.c | 78 +++++++++++++++++++++--------------
> >  1 file changed, 46 insertions(+), 32 deletions(-)
> >
> > diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processo=
r.c
> > index ba0a6f0ac841..ac7ddb30f10e 100644
> > --- a/drivers/acpi/acpi_processor.c
> > +++ b/drivers/acpi/acpi_processor.c
> > @@ -183,8 +183,36 @@ static void __init acpi_pcc_cpufreq_init(void) {}
> >  #endif /* CONFIG_X86 */
> >
> >  /* Initialization */
> > +static DEFINE_PER_CPU(void *, processor_device_array);
> > +
> > +static void acpi_processor_set_per_cpu(struct acpi_processor *pr,
> > +                                      struct acpi_device *device)
> > +{
> > +       BUG_ON(pr->id >=3D nr_cpu_ids);
> > +       /*
> > +        * Buggy BIOS check.
> > +        * ACPI id of processors can be reported wrongly by the BIOS.
> > +        * Don't trust it blindly
> > +        */
> > +       if (per_cpu(processor_device_array, pr->id) !=3D NULL &&
> > +           per_cpu(processor_device_array, pr->id) !=3D device) {
> > +               dev_warn(&device->dev,
> > +                        "BIOS reported wrong ACPI id %d for the proces=
sor\n",
> > +                        pr->id);
> > +               /* Give up, but do not abort the namespace scan. */
> > +               return; =20
>=20
> In this case the caller should make acpi_pricessor_add() return 0, I
> think, because otherwise it will attempt to acpi_bind_one() "pr" to
> "device" which will confuse things.
>=20
> So I would make this return false to indicate that.
>=20
> Or just fold it into the caller and do the error handling there.

The bios bug mentioned in reply to patch 14 (DSDT entries for non existent =
CPUs
that have no _STA entries) showed me that we need to know if this succeeded
(I'd not read this at that point).

I'll make it return a bool to say this succeeded and in both call sites
return 0 if not to deal with the bios bug here.  Making sure not to clear
the per_cpu() structures unless this we get past that call.  If we do
and arch_register_cpu() fails we need to clear these two IDs.

Doing so means that acpi_processor_hotadd_init() is side effect free and
hence we can return in acpi_processor_get_info() which avoids the
need to clear pointers when we don't have a valid pr->id to do it with.

So fully agree we need to bail out properly if this fails.

Jonathan
