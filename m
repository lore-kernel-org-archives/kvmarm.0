Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99222629F
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 14:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yLumXxe+"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40907b82ab9so5308765e9.1
        for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 06:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700663819; x=1701268619; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u5S0ovat1Ld2/p/rdzb9E9NFKi5bx+S+NSv6XEPWCA8=;
        b=yLumXxe+ne3rdP34h1OwqnGhVNWhvDxZGPX3BaPJeuEY06B/SP5TtUKFELOnmnV9Gf
         z8BYqjT3N44BrqfvJbR8hxSlzTa2UoN4DVV4/JsQhF/L2zNXh3ZuF6fxE4x527gZEL8Z
         yPEE8U3TWxqbkrMBaTUheVAvGlgs88bqcLrWVufWBKB++ViL1z0pVWuUMs3B8tVvX2AP
         HqV9cKuNq3LbjPAtPk9BarXQFYX/bE4TZNW6ssb+uGMloMkAEzpuXUZLAzOA5ziTIPeT
         akNmJVBo/SzMKlF8Nnx31BUKK24CLT3raOmclXlUAIziUpMN3DqtmCewXVTRdyT7c6Lw
         Mh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700663819; x=1701268619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5S0ovat1Ld2/p/rdzb9E9NFKi5bx+S+NSv6XEPWCA8=;
        b=PBA0bn36eIqZ98f6IRBbljOXpikSqO+0Qpwguz95x8mJ25XsCOwW7FbAqKbA4bPNoH
         Kd9FcqD6+wqeWQE3BD6O+2J8YjJjOA5qRUXu1zGtILOu6d7gmz36MYKesJLvHUNRF+C1
         IynY+dgMiToMeB2xk0CeYmICuOm4MGM5SNrdlrPBh0raJXQaCK1kYtcXoZk7YaaVuM9y
         2YQ6wJBBxbs4nxFf9SYe7Xz/UBf7DdrhTJgOk0M8uKI5r9W3eSRfFayMImvvgMWWH6J8
         nSoyqYACw5kAjc9phkgl7lxiWuAL4rjGFruHcREmTd4LwhAPF5DULpHQ8mE9g/Ok7QMZ
         sxcg==
X-Gm-Message-State: AOJu0YyD1CRkjBjXBnDi/ywmaIL14/xqWgXcoNW5lx/Mog2DEMvuLJq5
	WuNelu+lSI1qCegchtq5RXFxTw==
X-Google-Smtp-Source: AGHT+IGyi7J+6h3rxcZ1JVou4fsnecYhJwWBZMFmSSMHEMqUjB8YcptrGlhNGF3SydnM1LCIg+pqew==
X-Received: by 2002:a5d:47af:0:b0:332:d504:c10a with SMTP id 15-20020a5d47af000000b00332d504c10amr549068wrb.19.1700663818745;
        Wed, 22 Nov 2023 06:36:58 -0800 (PST)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id i13-20020a5d584d000000b00332cb0937f4sm7730008wrf.33.2023.11.22.06.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Nov 2023 06:36:58 -0800 (PST)
Date: Wed, 22 Nov 2023 14:36:54 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: will@kernel.org, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com,
	mark.rutland@arm.com, akpm@linux-foundation.org, maz@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	qperret@google.com, smostafa@google.com
Subject: Re: [PATCH v3 05/10] arm64: ptdump: Add hooks on debugfs file
 operations
Message-ID: <ZV4SBp-8Y9lLItrh@google.com>
References: <20231115171639.2852644-2-sebastianene@google.com>
 <20231115171639.2852644-7-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115171639.2852644-7-sebastianene@google.com>

On Wed, Nov 15, 2023 at 05:16:35PM +0000, Sebastian Ene wrote:
> Introduce callbacks invoked when the debugfs entry is accessed from
> userspace. This hooks will allow us to allocate and prepare the memory
> resources used by ptdump when the debugfs file is opened/closed.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/include/asm/ptdump.h |  7 +++++
>  arch/arm64/mm/ptdump_debugfs.c  | 53 +++++++++++++++++++++++++++++++--
>  2 files changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> index 1f6e0aabf16a..9b2bebfcefbe 100644
> --- a/arch/arm64/include/asm/ptdump.h
> +++ b/arch/arm64/include/asm/ptdump.h
> @@ -20,9 +20,16 @@ struct ptdump_info {
>  	const struct addr_marker	*markers;
>  	unsigned long			base_addr;
>  	void (*ptdump_walk)(struct seq_file *s, struct ptdump_info *info);
> +	int (*ptdump_prepare_walk)(void *file_priv);
> +	void (*ptdump_end_walk)(void *file_priv);
>  };
>  
>  void ptdump_walk(struct seq_file *s, struct ptdump_info *info);
> +
> +struct ptdump_info_file_priv {
> +	struct ptdump_info	info;
> +	void			*file_priv;
> +};
>  #ifdef CONFIG_PTDUMP_DEBUGFS
>  #define EFI_RUNTIME_MAP_END	DEFAULT_MAP_WINDOW_64
>  void __init ptdump_debugfs_register(struct ptdump_info *info, const char *name);
> diff --git a/arch/arm64/mm/ptdump_debugfs.c b/arch/arm64/mm/ptdump_debugfs.c
> index 7564519db1e6..3bf5de51e8c3 100644
> --- a/arch/arm64/mm/ptdump_debugfs.c
> +++ b/arch/arm64/mm/ptdump_debugfs.c
> @@ -7,7 +7,8 @@
>  
>  static int ptdump_show(struct seq_file *m, void *v)
>  {
> -	struct ptdump_info *info = m->private;
> +	struct ptdump_info_file_priv *f_priv = m->private;
> +	struct ptdump_info *info = &f_priv->info;
>  
>  	get_online_mems();
>  	if (info->ptdump_walk)
> @@ -15,7 +16,55 @@ static int ptdump_show(struct seq_file *m, void *v)
>  	put_online_mems();
>  	return 0;
>  }
> -DEFINE_SHOW_ATTRIBUTE(ptdump);
> +
> +static int ptdump_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +	struct ptdump_info *info = inode->i_private;
> +	struct ptdump_info_file_priv *f_priv;
> +
> +	f_priv = kzalloc(sizeof(struct ptdump_info_file_priv), GFP_KERNEL);
> +	if (!f_priv)
> +		return -ENOMEM;
> +
> +	memcpy(&f_priv->info, info, sizeof(*info));

That doesn't look right. Why would reading the file need a copy of that?

Also, that is a lot of "priv" it's hard to understand which is which.

I suppose you need have the description of the pgtable which is created at the
same time as the debugfs entry is registered.

And you have (or not) the snapshot of the pgtable, which is created only on the
file open.

> +
> +	ret = single_open(file, ptdump_show, f_priv);
> +	if (ret) {
> +		kfree(f_priv);
> +		return ret;
> +	}
> +
> +	if (info->ptdump_prepare_walk) {
> +		ret = info->ptdump_prepare_walk(f_priv);
> +		if (ret)
> +			kfree(f_priv);
> +	}
> +
> +	return ret;
> +}
> +

[...]
