Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F514321B3
	for <kvmarm@lists.linux.dev>; Tue,  7 Nov 2023 17:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="M0IFeJBw"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1cc53d0030fso47330625ad.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Nov 2023 09:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1699379288; x=1699984088; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ywd9froD7aOGJqc09ImjtHrARMhZvSCpgT2M8r3eM5I=;
        b=M0IFeJBwiVQQPBAdHNhpUCFAvOxP04x0fNP8XmD6Tep2oy+KFEY4YY87uGHjYJcMm9
         H4u8M7ATab1H1DNsRnvOvtD+cBQd2U188hMziaJ1y44szgYo3zwFD3IJpMQXtBt5S1rY
         kA8vywsSlNj02rpyObPHwiXLYeD8JyFeV38kUNEAj0bD587sCDLBoWk2jUVqaAhXe0d+
         Uangvs869jQZNlmJ8OWFWnT5pgzsj6ZZDc5JKjrT6vtaVIW0k11W38UCm4xcf+SINQ+n
         s6P6VQyC0b/Fnq0qTkQFsoUQwU6Njz0LoLGyP2PSkZAt8TCl6dj2he1ffYQMWSa2IqjE
         g0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699379288; x=1699984088;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywd9froD7aOGJqc09ImjtHrARMhZvSCpgT2M8r3eM5I=;
        b=Yu3em8wvBMQzNK0TI+Bpqdz5wwOhKt641ypmE2RcsTDPgc5PgClgMbAV4Eu/uCni03
         rbqikeXNYDjpUiGnqklRUtSrBb8KDc1g47JWgUs+OnJjsf4KyHzwjakCw4J6dgmEmvVN
         bS02EvLxuUdENkGNiZnwTSuA0R2o3rYIUFbeHa0UDxU/GOW30pxsk+oqNiI1bSnuMn8t
         NUYPepM3podYHQx1dTSCnuE3TWcRGkocN0VTPTRphiEpiHmwGXu7Ss3qsjSsy85/PxPx
         lqDBshjMx8CXr6nCvGeICHjWeyeZ4VhRaleoQLO3qAS6kB40pt6TjpnyvGpKLyg5BTK6
         Oo9Q==
X-Gm-Message-State: AOJu0YxWA5lkf0HWcbIOzDAQCCgbPot+EwehcXN7bbekrU/kYX5OUXo3
	hB4N3N03nOU/9jIhE3mg/guW2A==
X-Google-Smtp-Source: AGHT+IE1O0IZeedx9DdABfISL9vUc/qLEJImXP8G88Ji0nXKSIqNVitCPYUEuOTU6Qgy+/VgBOwBhA==
X-Received: by 2002:a17:902:d4ce:b0:1cc:32df:8ebd with SMTP id o14-20020a170902d4ce00b001cc32df8ebdmr5416391plg.25.1699379288440;
        Tue, 07 Nov 2023 09:48:08 -0800 (PST)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id iy3-20020a170903130300b001c9dac0fbbasm115552plb.63.2023.11.07.09.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 09:48:07 -0800 (PST)
Date: Tue, 07 Nov 2023 09:48:07 -0800 (PST)
X-Google-Original-Date: Tue, 07 Nov 2023 09:47:58 PST (-0800)
Subject:     Re: [PATCH RFC 21/22] riscv: Switch over to GENERIC_CPU_DEVICES
In-Reply-To: <E1r0JMQ-00CTyb-Ee@rmk-PC.armlinux.org.uk>
CC: linux-pm@vger.kernel.org, loongarch@lists.linux.dev, linux-acpi@vger.kernel.org,
  linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
  linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org, linux-csky@vger.kernel.org,
  linux-doc@vger.kernel.org, linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org,
  salil.mehta@huawei.com, jean-philippe@linaro.org, jianyong.wu@arm.com, justin.he@arm.com,
  james.morse@arm.com, Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu
From: Palmer Dabbelt <palmer@dabbelt.com>
To: rmk+kernel@armlinux.org.uk
Message-ID: <mhng-6d9a28af-d626-410e-913f-33bc01890537@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Tue, 07 Nov 2023 02:31:06 PST (-0800), rmk+kernel@armlinux.org.uk wrote:
> From: James Morse <james.morse@arm.com>
>
> Now that GENERIC_CPU_DEVICES calls arch_register_cpu(), which can be
> overridden by the arch code, switch over to this to allow common code
> to choose when the register_cpu() call is made.
>
> This allows topology_init() to be removed.
>
> This is an intermediate step to the logic being moved to drivers/acpi,
> where GENERIC_CPU_DEVICES will do the work when booting with acpi=off.
>
> This patch also has the effect of moving the registration of CPUs from
> subsys to driver core initialisation, prior to any initcalls running.
>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> Changes since RFC v2:
>  * Add note about initialisation order change.
> ---
>  arch/riscv/Kconfig        |  1 +
>  arch/riscv/kernel/setup.c | 19 ++++---------------
>  2 files changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index eaa15a20e6ae..264aa466aec3 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -69,6 +69,7 @@ config RISCV
>  	select GENERIC_ARCH_TOPOLOGY
>  	select GENERIC_ATOMIC64 if !64BIT
>  	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
> +	select GENERIC_CPU_DEVICES
>  	select GENERIC_EARLY_IOREMAP
>  	select GENERIC_ENTRY
>  	select GENERIC_GETTIMEOFDAY if HAVE_GENERIC_VDSO
> diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
> index 0624f44d43ec..f8875ae1b0aa 100644
> --- a/arch/riscv/kernel/setup.c
> +++ b/arch/riscv/kernel/setup.c
> @@ -50,7 +50,6 @@ atomic_t hart_lottery __section(".sdata")
>  #endif
>  ;
>  unsigned long boot_cpu_hartid;
> -static DEFINE_PER_CPU(struct cpu, cpu_devices);
>
>  /*
>   * Place kernel memory regions on the resource tree so that
> @@ -295,23 +294,13 @@ void __init setup_arch(char **cmdline_p)
>  	riscv_set_dma_cache_alignment();
>  }
>
> -static int __init topology_init(void)
> +int arch_register_cpu(int cpu)
>  {
> -	int i, ret;
> +	struct cpu *c = &per_cpu(cpu_devices, cpu);
>
> -	for_each_possible_cpu(i) {
> -		struct cpu *cpu = &per_cpu(cpu_devices, i);
> -
> -		cpu->hotpluggable = cpu_has_hotplug(i);
> -		ret = register_cpu(cpu, i);
> -		if (unlikely(ret))
> -			pr_warn("Warning: %s: register_cpu %d failed (%d)\n",
> -			       __func__, i, ret);
> -	}
> -
> -	return 0;
> +	c->hotpluggable = cpu_has_hotplug(cpu);
> +	return register_cpu(c, cpu);
>  }
> -subsys_initcall(topology_init);
>
>  void free_initmem(void)
>  {

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
