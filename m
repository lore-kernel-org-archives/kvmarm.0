Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7E534DCD9
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 21:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769722763; cv=none; b=LheQA3XLXEESZ9DBjzXOqojnepObSa00tGdptMaOVqJxs8YX1ZXoC13Al7mUorTJp/wocuWkNGnVTwIg+mFkBfdO8DRa+X9hDGEaM86Xj22NWhhNQOEtI+5e3iusEqjEBn4U95Fh/Wi0fCbDEgOKqDrMwNlkNwwImrQRynrTAnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769722763; c=relaxed/simple;
	bh=FTzxGJtugdKjao+qMiaidJcp9/vBaAtySKq8E304Ljg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQDi4Jv7SVr7pqKPBvgKgybvemii8wGvjGsHxUBfqhwN5r59hhyV6PLCRGYpqSkwer6VSUK0Ax4D8WJkj9p7PbgQte/YrrJ5xLEo+ET87DznrRGTA2hC1nyQKrYuOmgwkXX5aQURHajyRRPQmFHrsc9Z/kBZqZgLSk5WuC/iJE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pEAYihDG; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pEAYihDG"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47edd9024b1so11944505e9.3
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 13:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769722761; x=1770327561; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D+w81DyXUE0b55CwrLCwC7XYX50M/2QX/b1Gp0d2KP4=;
        b=pEAYihDGk0LHFJOGhXwOcqKOXLZM5ird9gF5I35a/FxRDXszYJvmxp76mGvf3pPAHB
         u/8stu32J2xcK2c0IU0eLZjWIpE+Q/z5f2gxzNG16nvxS8H07bEC8/f/3zNAaC1gAxCK
         ZYQ2Wx6dDUrqDTNRcx5ZuZOr7DyuhYQJwBVKxvPHlNltmcP9CiCBUmauXKfwrdSokcok
         Nj6yB9LqcA65kqtJH6YElofOfQNVCvP1o1WWbJGrL9JdgeIPhHuo2hU6JHtGqrGpXJXL
         ZI0aWIdeTXkkQebmbbNz8KBUIQINoRASOCxW4f1r0LZ5nyPee2XC9LES5x23HF5oUhQ8
         losw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769722761; x=1770327561;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D+w81DyXUE0b55CwrLCwC7XYX50M/2QX/b1Gp0d2KP4=;
        b=ObBm7AuWK6Glz+fDihAd2PWz4pGWbLgg5d6DwIlD43qhKnFCDh8a5weAsZORaF1z4I
         i/BIqAUQAIyguL1LcO3gD9XUCtZzhMbDrVrCX+f6HcF5JefuWvgg3Ou5Fy5WWl29dzvZ
         rX6i0LFvkAoDm0vA1uXKe3zQlF/8FDroVQgc8kSbreX87qsxKwrTjFwAx4MqTOYXRqND
         1ywcLoLgBOrkXpofeoybS7ZPgGLvE/hquW2lKl+LmaDRwHwP+OcxUskd+0YD54pEZECw
         FNnaHe13vlOkGIrie+rraG5fq6yvJsoeyvuRn/Eu5FYxNhfSKh8LLLGFbg6nBI2mS6mW
         GlTA==
X-Forwarded-Encrypted: i=1; AJvYcCW2zPhEZry3x9QvHJEOwN3sYz/Uw3BjQpdjnvnSNiRvqBP8uOCV9tx7VQm0cr99JCsisJILCh8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmtukvsEKcWvT5YEKsN1GpoxoOBjtHiB2FzY/Oo0hodt6ec0vZ
	DVsWYqoBSXvzbvz3O00v+HvlNyAnsfO2xKgSEBWvVnVYr7ESTtGhEejS2EbySHRw8w==
X-Gm-Gg: AZuq6aL9tpyk+GORl9HpF1tAoyJEcoX5uL7gWc6CitQbiAVpsjRFhqvjjCOMxQo1/Fc
	Idw3+ATu9pHodgRtA8bgDSu4mVL2QbUY0gjq1EJpMR81pOMvowR7CvS+GqNFO6YrCsaD32HS1zH
	yaGKs1X9ivNsZSKZWyi0V+vDRzBk/eKqWy4Z3X6OeCuwWII3joz3VWTjtWeQcqsnDQjZj6NGIpf
	TA7wAFSe5lKikHOIRlmvOROixNveQDCZ28NjWl7hptgPzAOkbwMri7AMWNsOHutGBMnSDWQ826n
	Y75gAyz0L6dTv+4v6xSFElhxU2nyRWJIRNebDxZ9ELkEX9sw+vSqoIluGGQ7+5fmrUYmb6Y+5IO
	n74k1bAqUPr3+iF05RhyNjP/qCYcRFkgfBurXjeAf1p8IG0brMEu+U+veUE55ErJ+N1JaeFjLr+
	Rabka7dluF/biKM+Qefnir6hVfX52IdFvVEKktOBNHF/nLXG/RGA==
X-Received: by 2002:a05:6000:40c8:b0:431:104:6dc2 with SMTP id ffacd0b85a97d-435f3a674f5mr1361562f8f.8.1769722760913;
        Thu, 29 Jan 2026 13:39:20 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10edf62sm18781379f8f.13.2026.01.29.13.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:39:20 -0800 (PST)
Date: Thu, 29 Jan 2026 21:39:17 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 05/30] tracing: Introduce trace remotes
Message-ID: <aXvThRcUhuBreMPv@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
 <20260126104419.1649811-6-vdonnefort@google.com>
 <20260128153725.56e801c0@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128153725.56e801c0@gandalf.local.home>

[...]

> > +static ssize_t buffer_size_kb_write(struct file *filp, const char __user *ubuf, size_t cnt,
> > +				    loff_t *ppos)
> > +{
> > +	struct trace_remote *remote = filp->private_data;
> > +	unsigned long val;
> > +	int ret;
> > +
> > +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* KiB to Bytes */
> > +	if (!val || check_shl_overflow(val, 10, &val))
> > +		return -EINVAL;
> > +
> > +	guard(mutex)(&remote->lock);
> > +
> > +	remote->trace_buffer_size = val;
> 
> Should this be allowed to change when it is already loaded?

It would only be effective on the next unload/load. 

But now thinking more about it, this is probably not clear to a user and
returning -EBUSY when loaded might be a better solution?

> 
> -- Steve
> 
> > +
> > +	return cnt;
> > +}
> > +
> > +static int buffer_size_kb_show(struct seq_file *s, void *unused)
> > +{
> > +	struct trace_remote *remote = s->private;
> > +
> > +	seq_printf(s, "%lu (%s)\n", remote->trace_buffer_size >> 10,
> > +		   trace_remote_loaded(remote) ? "loaded" : "unloaded");
> > +
> > +	return 0;
> > +}
> > +DEFINE_SHOW_STORE_ATTRIBUTE(buffer_size_kb);
> > +
> 
