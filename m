Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E1C5C8EA;
	Wed, 22 Nov 2023 20:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-1d542f05b9aso30639fac.1;
        Wed, 22 Nov 2023 12:12:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700683935; x=1701288735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hRAUhzzHnP+XZxzQEXs8TfAKCs5HsmLQBIFGrTTFm+M=;
        b=v9gH9a4Pld9Ol6weZlhy/NKLHMlc1l6jpYO3QxI5EQqVZbhmFWSUEV77LmUznaGZlO
         6fxsCGO8ma4GZCrtudwPlWfG8ZCOFcWqlGcjgGVrMDfr0akiWkFOF566SAjS7xyPXU5v
         kqo2wIEGWFYYPHZdAPWui/DBvHZP7AxkpUtIUDaon2pyn0PAfJufHDBbjHci4iefKsRR
         tQIaPTpryfxGLiwbTvjGoI5/TIdqNXrtpPMxnKbf/x2p8hxqRPxsclgMUd7zTgdeLnZl
         Jgym6tv1RiCZ8snEXVsjuv30k0kpaBAAWl9jrnzfXsnBXc4ZU4tynGPYqgR/sJtuqWoG
         zV1A==
X-Gm-Message-State: AOJu0YzIZr3UmlHeVW5VyBoJjmOIHF9kJmGyodY0tqIe5u8td8OSS2iI
	EvecdIsqTpjMwPvqgyWwWSeRyEt3bNcTzPlZLzg=
X-Google-Smtp-Source: AGHT+IH/N9ldr6Rfz2HMts22gtDdEZrdomZQ3Wqdv4io0UUWkzkPpVzYdpFHz7cSkxilm43rTrV9+lWFNT1vpjiJ/R4=
X-Received: by 2002:a05:6871:a58b:b0:1ea:1510:d8df with SMTP id
 wd11-20020a056871a58b00b001ea1510d8dfmr3742289oab.4.1700683935194; Wed, 22
 Nov 2023 12:12:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZVyz/Ve5pPu8AWoA@shell.armlinux.org.uk> <E1r5R2m-00Csyb-2S@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1r5R2m-00Csyb-2S@rmk-PC.armlinux.org.uk>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 22 Nov 2023 21:12:04 +0100
Message-ID: <CAJZ5v0jbjykNooJ_PvkOjpE6hA0QFJUw+kpwYfNY7jOtkcPA0Q@mail.gmail.com>
Subject: Re: [PATCH 02/21] x86: intel_epb: Don't rely on link order
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: linux-pm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org, 
	linux-csky@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org, 
	Salil Mehta <salil.mehta@huawei.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com, 
	justin.he@arm.com, James Morse <james.morse@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 21, 2023 at 2:44=E2=80=AFPM Russell King <rmk+kernel@armlinux.o=
rg.uk> wrote:
>
> From: James Morse <james.morse@arm.com>
>
> intel_epb_init() is called as a subsys_initcall() to register cpuhp
> callbacks. The callbacks make use of get_cpu_device() which will return
> NULL unless register_cpu() has been called. register_cpu() is called
> from topology_init(), which is also a subsys_initcall().
>
> This is fragile. Moving the register_cpu() to a different
> subsys_initcall()  leads to a NULL dereference during boot.
>
> Make intel_epb_init() a late_initcall(), user-space can't provide a
> policy before this point anyway.
>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

and I'd suggest sending this separately to the x86 list.

> ---
> subsys_initcall_sync() would be an option, but moving the register_cpu()
> calls into ACPI also means adding a safety net for CPUs that are online
> but not described properly by firmware. This lives in subsys_initcall_syn=
c().
> ---
>  arch/x86/kernel/cpu/intel_epb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/intel_epb.c b/arch/x86/kernel/cpu/intel_=
epb.c
> index e4c3ba91321c..f18d35fe27a9 100644
> --- a/arch/x86/kernel/cpu/intel_epb.c
> +++ b/arch/x86/kernel/cpu/intel_epb.c
> @@ -237,4 +237,4 @@ static __init int intel_epb_init(void)
>         cpuhp_remove_state(CPUHP_AP_X86_INTEL_EPB_ONLINE);
>         return ret;
>  }
> -subsys_initcall(intel_epb_init);
> +late_initcall(intel_epb_init);
> --
> 2.30.2
>
>
