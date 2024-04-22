Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BD11552E7;
	Mon, 22 Apr 2024 19:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713812560; cv=none; b=L12ZjdBu7dOEBpEIfHmWXIDtwukKDzp0fniWuNF7xpX3ooPhdrclKbsemsbSUuWfBUbCkxh1bj+os3cEYWLZVu5S7NJ2I36zYIsNaUxfi2bHekAOfX6C12jAlux+7NhCVAgLxmLT61Bpq9eG3fSdwdWgvDJT6bJuZTsp/t2QzUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713812560; c=relaxed/simple;
	bh=uwpDPbgf4hD3XZs/0tjtjcf/q9ka6d5YskWsJ2GcPNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X5Kf3NY5px4OG/iI2xpab1saMgJctyppjE3dRHBA64ul2WvwTKrX19Hw6k+pdqCK1cEttCrRQ02rIKVMBZnJOtYevlq9vRaFtP3tOD/hnf6wQqddGyPsIRJu2fk1d58OuN1obixOt5EN2HnVJiJ7mlgqZtbLTVQfiW3YlnSbaS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ctph9V1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ctph9V1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392DAC32783;
	Mon, 22 Apr 2024 19:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713812560;
	bh=uwpDPbgf4hD3XZs/0tjtjcf/q9ka6d5YskWsJ2GcPNU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Ctph9V1F0lxikX25ulm8UsuLWR1hSY+8CiVXrSH+EoyGv8NlATirnqvMwq/iCGIbV
	 MrLbYryJ+VVyAlizPV6qyEltO4jzUEm1ibpqWQAb+CXwfseWWhGHStRK5GhN4hSgPR
	 7XOaqfF31/pAqCDrMBe2AT2q2jO4RrMzNshKvH2Nt2vv6gUcS+MiaYdbUWmJ0UXfiS
	 OSIzM4c68HiEIxFmvsL6VQ26j/mI/VYrA1REXhC2bLmpNSW2TLQ6s/ferikZK3ryqT
	 ZJtQAO65uUP2WL6GmNKBdiiFRrj++Rj7g//+qR5yvH1CVKy6Inmo41pxWQ4LFWU+n5
	 fONjygWgl5WNQ==
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5ac4470de3bso111499eaf.0;
        Mon, 22 Apr 2024 12:02:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWtpgWjKn9BU42Iig/U4QH/ZHZKbj0z4A7Z/bKPGR0gQt0M2uQuQlbLDp7QcPL8ThjZ83v1N9i36gcNRnNnnoWCeDiFgErpdsu40JgLQEU7OeAhAw/lKHAr3XzDMEMFEffv
X-Gm-Message-State: AOJu0Ywuyl2qDNdVti/AZtoN6OPyadxZrGe9HnpGpiMxcPnICBL5RqYo
	Yxym5nRT7l6JZ2PvbgCAXYFgxrwOVlXYLumUROxqAmfbqhroZZswZtuDaKr++vxLau9xvxj5Zta
	6VOE06Fp3w6w3170EtBF49NOUWLI=
X-Google-Smtp-Source: AGHT+IHfMJuggQNerMrgvKM5BuuCUjaZ4sXlArgCmyHHbceucLSf3gyNJ/n6QHdW+o0W+b3ed4Fd94BKproC4k9sVAM=
X-Received: by 2002:a05:6820:2884:b0:5aa:241a:7f4b with SMTP id
 dn4-20020a056820288400b005aa241a7f4bmr11678323oob.1.1713812559511; Mon, 22
 Apr 2024 12:02:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240418135412.14730-1-Jonathan.Cameron@huawei.com> <20240418135412.14730-7-Jonathan.Cameron@huawei.com>
In-Reply-To: <20240418135412.14730-7-Jonathan.Cameron@huawei.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 22 Apr 2024 21:02:28 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0hkQ0zTJ3ND5tWAKEJsfthQ-ve08eZpAHMx+9iVT2QQ4w@mail.gmail.com>
Message-ID: <CAJZ5v0hkQ0zTJ3ND5tWAKEJsfthQ-ve08eZpAHMx+9iVT2QQ4w@mail.gmail.com>
Subject: Re: [PATCH v7 06/16] ACPI: processor: Register deferred CPUs from acpi_processor_get_info()
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, linux-pm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-acpi@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org, 
	Russell King <linux@armlinux.org.uk>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>, 
	Salil Mehta <salil.mehta@huawei.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linuxarm@huawei.com, justin.he@arm.com, 
	jianyong.wu@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 3:57=E2=80=AFPM Jonathan Cameron
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
> not yet been added so for now this will be called for the original
> hotplug case.
>
> For architectures that do not defer until the ACPI Processor
> driver loads (e.g. x86), for initially present CPUs there will
> already be a CPU device. If present do not try to register again.
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
> commit 5b95f94c3b9f ("x86/topology: Switch over to GENERIC_CPU_DEVICES")
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
> v7: Simplify the logic on whether to hotadd the CPU.
>     This path can only be reached either for coldplug in which
>     case all we care about is has register_cpu() already been
>     called (identifying deferred), or hotplug in which case
>     whether register_cpu() has been called is also sufficient.
>     Checks on _STA related elements or the validity of the ID
>     are no longer necessary here due to similar checks having
>     moved elsewhere in the path.
> v6: Squash the two paths for conventional CPU Hotplug and arm64
>     vCPU HP.
> ---
>  drivers/acpi/acpi_processor.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.=
c
> index 127ae8dcb787..4e65011e706c 100644
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -350,14 +350,14 @@ static int acpi_processor_get_info(struct acpi_devi=
ce *device)
>         }
>
>         /*
> -        *  Extra Processor objects may be enumerated on MP systems with
> -        *  less than the max # of CPUs. They should be ignored _iff
> -        *  they are physically not present.
> -        *
> -        *  NOTE: Even if the processor has a cpuid, it may not be presen=
t
> -        *  because cpuid <-> apicid mapping is persistent now.
> +        *  This code is not called unless we know the CPU is present and
> +        *  enabled. The two paths are:
> +        *  a) Initially present CPUs on architectures that do not defer
> +        *     their arch_register_cpu() calls until this point.
> +        *  b) Hotplugged CPUs (enabled bit in _STA has transitioned from=
 not
> +        *     enabled to enabled)
>          */
> -       if (invalid_logical_cpuid(pr->id) || !cpu_present(pr->id)) {
> +       if (!get_cpu_device(pr->id)) {
>                 ret =3D acpi_processor_hotadd_init(pr, device);

Yes, this is what I thought it should boil down to, so

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

>
>                 if (ret)
> --
> 2.39.2
>
