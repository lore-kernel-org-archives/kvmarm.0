Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB77218633
	for <kvmarm@lists.linux.dev>; Tue, 19 Dec 2023 11:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hwhvdbfH"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-40c32bea30dso47965e9.0
        for <kvmarm@lists.linux.dev>; Tue, 19 Dec 2023 03:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702986463; x=1703591263; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WKYUS8nd9z/w82LwXMjmDphAjvYpl6ryuYSpgDd10Z4=;
        b=hwhvdbfHGZA8SWWRDDYrUr/G5u4Ser7EM68B8IUYDDWpD6xYcKwurt4FqF55IbVRrL
         DWqOz7yE1jijwK08TolxHtWhYClUzYvaKHKV0vG/TIm1I3f1PW19o0o22BLHfjY9mzbr
         YUxJK1/ryF6QRi9Dyqy4mphRVurHSVlwxaE+Jj3NkjA1KkcncOT8P1fbZMWB7dkGncCP
         44maCoXjrP/sunRbsI7xFfqrD4DaGrv20oEmi/qxwge6M6052+b4XzSDfO6G8ww8NeU0
         epj0WmQq9G+nX7f2uFk5w7fvumRuuW13lraGmo4i5dIV1MNI89upvd1GDNzCs97cEZY6
         ZMHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702986463; x=1703591263;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKYUS8nd9z/w82LwXMjmDphAjvYpl6ryuYSpgDd10Z4=;
        b=ZcodAQCRTdx5BqjGLevnefV/smyMIy7yQvPkzzwzY8Pj5YSmcTIzwOCvbL1wWCspgL
         m/mXofUMcVtJO4A1q1oTBNiJJ3CkJUMMQSbqDeqiT+8KRttn6drf2e5Wl/IWenmJioxz
         d18WvA0O34VO04ViZUt801wHseITM+fk36UMddE8XYVWf92uC2Ifg3ubAWUtiy4duspS
         OOFus5i0gAbQXsXMkzr0lOfsREayDlIXJgTv+YznNuagb0oAJG/1CS+ujDNDGSONkvHd
         cz0hAx9yvz5nPOYexwIBuoqwRYazZYgTTkPmeO6BncpdkUJ3FlLFacl0rAdCHKQU65gm
         WBnQ==
X-Gm-Message-State: AOJu0YwdQ7C+0SRDcBUXL5PHhFwlGxN/LHhcCmiJchP1+VFRO3LUEPGB
	5StJDZS6uMPMmBFPg5fU1sZG1N/Fd4tx
X-Google-Smtp-Source: AGHT+IHuJBXW+M/1WdVf9NpQ6RzHQn7JcJLP1l/MFWfAJ2aC36CcAsttwAa+T6KS3V/tlBWUunX8qQ==
X-Received: by 2002:a05:600c:3ba8:b0:40d:2bc7:e9b with SMTP id n40-20020a05600c3ba800b0040d2bc70e9bmr36857wms.4.1702986462970;
        Tue, 19 Dec 2023 03:47:42 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id y15-20020a056000108f00b003366464cae9sm6662436wrw.100.2023.12.19.03.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 03:47:42 -0800 (PST)
Date: Tue, 19 Dec 2023 11:47:40 +0000
From: Sebastian Ene <sebastianene@google.com>
To: will@kernel.org, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com,
	mark.rutland@arm.com, akpm@linux-foundation.org, maz@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	vdonnefort@google.com, qperret@google.com, smostafa@google.com
Subject: Re: [PATCH v4 02/10] KVM: arm64: Add ptdump registration with
 debugfs for the stage-2 pagetables
Message-ID: <ZYGC3F_UJB8U_wuD@google.com>
References: <20231218135859.2513568-2-sebastianene@google.com>
 <20231218135859.2513568-4-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218135859.2513568-4-sebastianene@google.com>

On Mon, Dec 18, 2023 at 01:58:52PM +0000, Sebastian Ene wrote:
> While arch/*/mem/ptdump handles the kernel pagetable dumping code,
> introduce KVM/ptdump which deals with the stage-2 pagetables. The
> separation is necessary because most of the definitions from the
> stage-2 pagetable reside in the KVM path and we will be invoking
> functionality **specific** to KVM.
> 
> This registers a wrapper on top of debugfs_create_file which allows us
> to hook callbacks on the debugfs open/show/close. The callbacks are used
> to prepare the display portion of the pagetable dumping code.
> Guard this functionality under the newly introduced PTDUMP_STAGE2_DEBUGFS.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/Kconfig      | 13 +++++
>  arch/arm64/kvm/Makefile     |  1 +
>  arch/arm64/kvm/arm.c        |  2 +
>  arch/arm64/kvm/kvm_ptdump.h | 18 +++++++
>  arch/arm64/kvm/ptdump.c     | 96 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 130 insertions(+)
>  create mode 100644 arch/arm64/kvm/kvm_ptdump.h
>  create mode 100644 arch/arm64/kvm/ptdump.c
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 83c1e09be..0014e55e2 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -71,4 +71,17 @@ config PROTECTED_NVHE_STACKTRACE
>  
>  	  If unsure, or not using protected nVHE (pKVM), say N.
>  
> +config PTDUMP_STAGE2_DEBUGFS
> +       bool "Present the stage-2 pagetables to debugfs"
> +       depends on PTDUMP_DEBUGFS && KVM
> +       default n
> +       help
> +         Say Y here if you want to show the stage-2 kernel pagetables
> +         layout in a debugfs file. This information is only useful for kernel developers
> +         who are working in architecture specific areas of the kernel.
> +         It is probably not a good idea to enable this feature in a production
> +         kernel.
> +
> +         If in doubt, say N.
> +
>  endif # VIRTUALIZATION
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index c0c050e53..190eac175 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -23,6 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>  	 vgic/vgic-its.o vgic/vgic-debug.o
>  
>  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
> +kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
>  
>  always-y := hyp_constants.h hyp-constants.s
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e5f75f1f1..ee8d7cb67 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -40,6 +40,7 @@
>  #include <asm/kvm_pkvm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/sections.h>
> +#include <kvm_ptdump.h>
>  
>  #include <kvm/arm_hypercalls.h>
>  #include <kvm/arm_pmu.h>
> @@ -2592,6 +2593,7 @@ static __init int kvm_arm_init(void)
>  	if (err)
>  		goto out_subs;
>  
> +	kvm_ptdump_register_host();
>  	kvm_arm_initialised = true;
>  
>  	return 0;
> diff --git a/arch/arm64/kvm/kvm_ptdump.h b/arch/arm64/kvm/kvm_ptdump.h
> new file mode 100644
> index 000000000..98b595ce8
> --- /dev/null
> +++ b/arch/arm64/kvm/kvm_ptdump.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +//
> +// Copyright (C) Google, 2023
> +// Author: Sebastian Ene <sebastianene@google.com>
> +
> +#ifndef __KVM_PTDUMP_H
> +#define __KVM_PTDUMP_H
> +
> +#include <asm/ptdump.h>
> +
> +
> +#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> +void kvm_ptdump_register_host(void);
> +#else
> +static inline void kvm_ptdump_register_host(void) { }
> +#endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
> +
> +#endif /* __KVM_PTDUMP_H */
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> new file mode 100644
> index 000000000..5816fc632
> --- /dev/null
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -0,0 +1,96 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +//
> +// Debug helper used to dump the stage-2 pagetables of the system and their
> +// associated permissions.
> +//
> +// Copyright (C) Google, 2023
> +// Author: Sebastian Ene <sebastianene@google.com>
> +
> +#include <linux/debugfs.h>
> +#include <linux/kvm_host.h>
> +#include <linux/seq_file.h>
> +
> +#include <asm/kvm_pkvm.h>
> +#include <kvm_ptdump.h>
> +
> +
> +struct kvm_ptdump_register {
> +	void *(*get_ptdump_info)(struct kvm_ptdump_register *reg);
> +	void (*put_ptdump_info)(void *priv);
> +	int (*show_ptdump_info)(struct seq_file *m, void *v);
> +	void *priv;
> +};
> +
> +static int kvm_ptdump_open(struct inode *inode, struct file *file);
> +static int kvm_ptdump_release(struct inode *inode, struct file *file);
> +static int kvm_ptdump_show(struct seq_file *m, void *);
> +
> +static const struct file_operations kvm_ptdump_fops = {
> +	.open		= kvm_ptdump_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= kvm_ptdump_release,
> +};
> +
> +static int kvm_ptdump_open(struct inode *inode, struct file *file)
> +{
> +	struct kvm_ptdump_register *reg = inode->i_private;
> +	void *info = NULL;
> +	int ret;
> +
> +	if (reg->get_ptdump_info) {
> +		info = reg->get_ptdump_info(reg);
> +		if (!info)
> +			return -ENOMEM;
> +	}
> +
> +	if (!reg->show_ptdump_info)
> +		reg->show_ptdump_info = kvm_ptdump_show;
> +
> +	ret = single_open(file, reg->show_ptdump_info, info);
> +	if (ret && reg->put_ptdump_info)
> +		reg->put_ptdump_info(info);
> +
> +	return ret;
> +}
> +
> +static int kvm_ptdump_release(struct inode *inode, struct file *file)
> +{
> +	struct kvm_ptdump_register *reg = inode->i_private;
> +	struct seq_file *seq_file = file->private_data;
> +
> +	if (reg->put_ptdump_info)
> +		reg->put_ptdump_info(seq_file->private);
> +

Call single_release here.

> +	return 0;
> +}
> +
> +static int kvm_ptdump_show(struct seq_file *m, void *)
> +{
> +	return -EINVAL;
> +}
> +
> +static void kvm_ptdump_debugfs_register(struct kvm_ptdump_register *reg,
> +					const char *name, struct dentry *parent)
> +{
> +	debugfs_create_file(name, 0400, parent, reg, &kvm_ptdump_fops);
> +}
> +
> +static struct kvm_ptdump_register host_reg;
> +
> +void kvm_ptdump_register_host(void)
> +{
> +	if (!is_protected_kvm_enabled())
> +		return;
> +
> +	kvm_ptdump_debugfs_register(&host_reg, "host_page_tables",
> +				    kvm_debugfs_dir);
> +}
> +
> +static int __init kvm_host_ptdump_init(void)
> +{
> +	host_reg.priv = (void *)host_s2_pgtable_pages();
> +	return 0;
> +}
> +
> +device_initcall(kvm_host_ptdump_init);
> -- 
> 2.43.0.472.g3155946c3a-goog
> 
