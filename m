Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DBE2D03D
	for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 14:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BiZyNcOd"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-40c39e936b4so45667775e9.1
        for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 06:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1702476173; x=1703080973; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8CNgTMGbobolB1r9w8VNb165BlBAplPuvdaxYrWog0=;
        b=BiZyNcOdWm5GCZQdThwIvW6Ng+RTMmwQc3P+H0nCksYjm+yNZQA7RSra5vNIekxTo5
         2Xysoz5Fx5dowIdxW7uCaFhuaAYrITXVqNNYvJJwX2tM7m7nSs9AZaebVnsPktjCmRYL
         TxV44gkp2iFt3srKGjvTqMULS4L5lOeLSgkDIzSO3/VZ5KZMlKvt3lkosoZTo4syK9cq
         GUEkjvMBleutXV8KpMZeTAL09tA7sjnqPxS7sBa5MFS/psykizX4yAaxSY63fWg7Sipu
         1hhIU5T0NY8G69UJU0MPmpHDRHuj/zJbwJpGdUVFf61yZm2IjlgbqBbYyszIu0vbjGa5
         Fqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702476173; x=1703080973;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8CNgTMGbobolB1r9w8VNb165BlBAplPuvdaxYrWog0=;
        b=I3KJFAUYr35+MO/xGyZmfGmlqxgm+OD45jt6t7mFZHA5iBpqnrSkZ5yqV8zVxHh9ZI
         iE627aWQ6wi+2GlpOPCvM6YOzEu0G65bQ0HO91BGm8UtJc7KhHc/VXNC8aPTnnnDqeyF
         tvz9kjqf5/U2eDoR2+ow4hQFS0EPnOZG5WbGWLNGaITxt7kibKRhdCfdCz9itC6JzzOR
         IqHv9rMRYZVwNQavopAB378wngtmZqaiqJyVFJ/UYFANShX2Un5hObsJOuzoFgHu/hBp
         Orb3bXafw5zvZlEJSJVnnF18nhnMUnDnvoUsaYplCs+T8ABlrL5AkEjbJkiCougd+9TF
         XBSg==
X-Gm-Message-State: AOJu0Yx+ihuTsIGYrrSALBejjRBddwDWGvFqEoP3sTnXPAU78qI3gjoR
	U4z8Gl5q/rYWBiP2/IRqihY2TA==
X-Google-Smtp-Source: AGHT+IHHe1VYvYeZf/3ceduRCoWvVbIdH20JSg3fNMXtxhw7fHkTGIiZ2b27mL7MboW3CuD0I846lA==
X-Received: by 2002:a05:600c:2483:b0:40c:3314:5be0 with SMTP id 3-20020a05600c248300b0040c33145be0mr1879277wms.295.1702476172702;
        Wed, 13 Dec 2023 06:02:52 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id fm14-20020a05600c0c0e00b00407b93d8085sm22968185wmb.27.2023.12.13.06.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 06:02:52 -0800 (PST)
Date: Wed, 13 Dec 2023 15:02:51 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Jisheng Zhang <jszhang@kernel.org>, 
	Samuel Holland <samuel@sholland.org>, Minda Chen <minda.chen@starfivetech.com>, 
	Sean Christopherson <seanjc@google.com>, Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>, 
	Vipin Sharma <vipinsh@google.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
	Thomas Huth <thuth@redhat.com>, Aaron Lewis <aaronlewis@google.com>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v4 05/11] tools: riscv: Add header file vdso/processor.h
Message-ID: <20231213-9d5ad03bed3056007c6e714d@orel>
References: <cover.1702371136.git.haibo1.xu@intel.com>
 <7b633cc441f5133608597463301fef122f5174d3.1702371136.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b633cc441f5133608597463301fef122f5174d3.1702371136.git.haibo1.xu@intel.com>

On Tue, Dec 12, 2023 at 05:31:14PM +0800, Haibo Xu wrote:
> Borrow the cpu_relax() definitions from kernel's
> arch/riscv/include/asm/vdso/processor.h to tools/ for riscv.
> 
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/arch/riscv/include/asm/vdso/processor.h | 32 +++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 tools/arch/riscv/include/asm/vdso/processor.h
> 
> diff --git a/tools/arch/riscv/include/asm/vdso/processor.h b/tools/arch/riscv/include/asm/vdso/processor.h
> new file mode 100644
> index 000000000000..662aca039848
> --- /dev/null
> +++ b/tools/arch/riscv/include/asm/vdso/processor.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __ASM_VDSO_PROCESSOR_H
> +#define __ASM_VDSO_PROCESSOR_H
> +
> +#ifndef __ASSEMBLY__
> +
> +#include <asm-generic/barrier.h>
> +
> +static inline void cpu_relax(void)
> +{
> +#ifdef __riscv_muldiv
> +	int dummy;
> +	/* In lieu of a halt instruction, induce a long-latency stall. */
> +	__asm__ __volatile__ ("div %0, %0, zero" : "=r" (dummy));
> +#endif
> +
> +#ifdef CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE
> +	/*
> +	 * Reduce instruction retirement.
> +	 * This assumes the PC changes.
> +	 */
> +	__asm__ __volatile__ ("pause");
> +#else
> +	/* Encoding of the pause instruction */
> +	__asm__ __volatile__ (".4byte 0x100000F");
> +#endif
> +	barrier();
> +}
> +
> +#endif /* __ASSEMBLY__ */
> +
> +#endif /* __ASM_VDSO_PROCESSOR_H */
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
