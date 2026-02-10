Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365BC3859EA
	for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 15:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738863; cv=none; b=oxQyyQe4lsJCO+qFRajEgbyNREXSSx02G43Fxt2aYMcE5xVf8XbAwTP2H2M11ezfbCNZlHmmXZWfQhipgcg96EQYPGv3iQs66/XouCOBGEsI6COccDkZrkMgyYClAJ+KDvx3UvcICB7XZXtT3l/wudZrYFJYWCf0W/2OCucDxeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738863; c=relaxed/simple;
	bh=ST2OYSUr/9BOxuSHmo6m8vzlEriASf+JxzHewy/ojBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEJgus44t60uV33No0ZOZnIteQ1JkxDEJ8hbgkO+BuCK4Ig7uMFK3qkBh5xtoifi/hAQeuujR6ZZEqYRitM3MZ6UjT989B/sQMuyZ3aDlGU17w1cki1ttvgtelGDNBpMCX5H4euvcG7t4uk6fIy7PRsu2FsVZ38l2rPgKfsYBek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D37Z44fg; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D37Z44fg"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-482f454be5bso57610785e9.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 07:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770738860; x=1771343660; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uXRC/tAwqGKh/o1ifn7jOx1oKAbcp0FPsYzrynQiNbU=;
        b=D37Z44fgdUUcZJHJkkPQIgAu7rGAC+QerGqHUCdM3ITS3rCAxiJ5SiuA7/aelZcTJs
         oy2+yhbsPgIwA9Sh5Dl0enAWChPY0rckUTNomTpIQsrbVLmr2Y5ujamVOkWl+IJ9MP2f
         Re1A1wYEch7P3S7GR9one8FqkU7+KPtVSG64oS/T+revBBoj/1Ncz8okShxWC/YwCDdO
         Z0F+RVeejO02/IdlaKZ7Yqjeqm0X43+DXe2HAmqlg2FiX5X2AXWgstUI7X8P4Ur+QPO9
         aws/FPXN4q+axcf92MNLik3i8Z2rTigBw1CatGDtARcZUXhPFOVTkwPh/gqd8/vC0Gh4
         R/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770738860; x=1771343660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uXRC/tAwqGKh/o1ifn7jOx1oKAbcp0FPsYzrynQiNbU=;
        b=XBQq0zHoHyH3zB6qqtgIAa9/W6TEROzJG6g6fK6kU1bC+J5MjXTN9XZVwZu+4GE+58
         LDY75DeZ8WxWTrPOuD077iJ6Qdm5k5ReB0ar3hdmYaOkE0HJG3Bskj2vTacP3Y98T0i0
         MCXmcZEy4mc3LC2pLxq7kFLdf5Jqs/LYcesqExjgeHbmQE79x8CU/RPKW9iprcNa2IgZ
         WLwK/FLK22gCljG6Af2DCkD2lywuiJ34S9qPIWDKWdB+bR0+3b5PFggX00yFZf+zRCXZ
         Ygfzq2cDQTkEj5CFtkMPZVFUUroELxjlxwnh3T2XEEDgGGY4EfDDKj03soUzC1RZ3a6c
         8zCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjBr9Tc+iaDmvcw5YUS/sf6kaDnC3ysMRpd0NO/+7u+P+dcdkvVp38swwnHClf/e2FE8amEQk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDgUulobAqTXM/vC2jGSs2NT2gXhNHUHCA9ZqWCGGKuVBWTM4w
	q9B5QTP89wvXj+Wp9zyc8YNpmK6UKQjD98JDNoR73IDFQyuTc2hGgo5VxUDleeGUcQ==
X-Gm-Gg: AZuq6aJTPEM5DDjqBxhyjBJToRtRXV5oMuRWSkr+kQQj6X0uCNlafkNnKeiRGm9hXkv
	Ikwl9NOj8Rj1GaZHqpd/ctm9Su2wDef7CkDFeJbNjbKsciL4S43WsAI04DfwVZdthIdUNLbWT3t
	WaltPs7uNIcPaukfE7oP6Jb3oPlHHfiElln4V7D8BNOgxeJVZ1/uypd9T20Q2MsZXUJBT2dGgLh
	JrO2MHIoDpleuT5POY5wiFgBitNQcwLTE3gkK31tNsQk5MolyV/eupZmUavoqf2LbrZ6opfDzqv
	sE016NUFHvEJqao94qCTPa47XZeiBRptUbOoickEOkM96mMkZBv6ZbFTV09MaMvIiVhfYI7r2rM
	g3JNof/2FBff0xs4D+Nn/d9ecMGntUz5HLmZrPXTRWDhbyS4OQ3oN1LDj6Ljci7312rYCCBF406
	9Tr7PvkHdqAFxmTLsZHGV4sAb0lYjI39MxUz/R1DdJLY7xUCLcPzEjeM5B6+5ywIxLK+k=
X-Received: by 2002:a05:600c:3b8b:b0:477:a289:d854 with SMTP id 5b1f17b1804b1-48350511771mr44119235e9.5.1770738860235;
        Tue, 10 Feb 2026 07:54:20 -0800 (PST)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d5ebd34sm71526575e9.7.2026.02.10.07.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 07:54:19 -0800 (PST)
Date: Tue, 10 Feb 2026 15:54:16 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 15/30] tracing: selftests: Add trace remote tests
Message-ID: <aYtUqOw8SdX7gqZT@google.com>
References: <20260131132848.254084-1-vdonnefort@google.com>
 <20260131132848.254084-16-vdonnefort@google.com>
 <20260205124208.2ed7cff8@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205124208.2ed7cff8@gandalf.local.home>

On Thu, Feb 05, 2026 at 12:42:08PM -0500, Steven Rostedt wrote:
> On Sat, 31 Jan 2026 13:28:33 +0000
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > Exercise the tracefs interface for trace remote with a set of tests to
> > check:
> > 
> >   * loading/unloading (unloading.tc)
> >   * reset (reset.tc)
> >   * size changes (buffer_size.tc)
> >   * consuming read (trace_pipe.tc)
> >   * non-consuming read (trace.tc)
> > 
> > Cc: Shuah Khan <skhan@linuxfoundation.org>
> > Cc: linux-kselftest@vger.kernel.org
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> This still fails:
> 
> === Ftrace unit tests ===
> [1] Test trace remote buffer size	[PASS]
> [2] Test hypervisor trace buffer size	[UNSUPPORTED]
> [3] Test hypervisor trace buffer reset	[UNSUPPORTED]
> [4] Test hypervisor consuming trace read	[UNSUPPORTED]
> [5] Test hypervisor non-consuming trace read	[UNSUPPORTED]
> [6] Test hypervisor trace buffer unloading	[UNSUPPORTED]
> [7] Test trace remote reset	[PASS]
> [8] Test trace remote consuming read	[FAIL]
> [9] Test trace remote non-consuming read	[FAIL]
> [10] Test trace remote unloading	[PASS]
> 
> I added this patch and the two failed tests now pass:
> 
> diff --git a/tools/testing/selftests/ftrace/test.d/remotes/trace.tc b/tools/testing/selftests/ftrace/test.d/remotes/trace.tc
> index 081133ec45ff..dfc954a6a380 100644
> --- a/tools/testing/selftests/ftrace/test.d/remotes/trace.tc
> +++ b/tools/testing/selftests/ftrace/test.d/remotes/trace.tc
> @@ -106,8 +106,10 @@ test_trace()
>      echo 0 > trace
>  
>      for cpu in $(get_cpu_ids); do
> -        echo 0 > /sys/devices/system/cpu/cpu$cpu/online
> -        break
> +        if [ -f /sys/devices/system/cpu/cpu$cpu/online ]; then
> +            echo 0 > /sys/devices/system/cpu/cpu$cpu/online
> +            break
> +        fi

Hum weird, I have changed it in v11 to 

echo 0 > /sys/devices/system/cpu/cpu$cpu/online || return 0

That doesn't work? Because I would simply stop the test there if we can't
offline the CPU.


>      done
>  
>      for i in $(seq 1 8); do
> diff --git a/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc b/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
> index d28eaee10c7c..146f0a9fe311 100644
> --- a/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
> +++ b/tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
> @@ -102,8 +102,10 @@ test_trace_pipe()
>      echo 0 > trace
>  
>      for cpu in $(get_cpu_ids); do
> -        echo 0 > /sys/devices/system/cpu/cpu$cpu/online
> -        break
> +        if [ -f /sys/devices/system/cpu/cpu$cpu/online ]; then
> +            echo 0 > /sys/devices/system/cpu/cpu$cpu/online
> +            break
> +        fi
>      done
>  
>      for i in $(seq 1 8); do
> 
> -- Steve
