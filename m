Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9FF366811
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769723422; cv=none; b=fsTJ2revD0bs/YNN6rbHZ85ss1jF2G8XRAi77Sk2ZVh2caNP0m9bMbCSSKWoopaPH7gNVFcEBjFBJJuMRu35zZoLt4akUmMpTqeY1WWTCNF47W7q0iLpD4xiKRn7vCCY1Jcd3cL0Y4GJNi/OaP/em7vYervGOVo5v3K/F+a5Cyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769723422; c=relaxed/simple;
	bh=QJB1a5gNqpH6jrHMpEyj+87Z5mH93GBioJQvzPUVeY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7KdQ2boLxYqFpItOEA8IVmLccyYErvxshhtY7anWheVaw91sY955u6t6iOR72KGKACLKJq6ioaVflXgGxM7qttEu7jdmk8cbwrvlS7EKvAqic6H4ym9EpBotLgSZtnqwvQQTXAaoyp1V9w7Hw/wg18LBt/yh856scyc1UVW7kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OkmlazdY; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OkmlazdY"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42fed090e5fso1199522f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 13:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769723419; x=1770328219; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c+SMixISY32I4TNkZ6inO6uSY2SNlSvt1Krp91cY5JE=;
        b=OkmlazdYkMs48b3g7SBRpvjQFlBEm+W7eqtxk04NhpE8RedxVaIcTV2q/SFFXMmSj9
         iTA4Mi9q9pMjF0bVq/SAE2o5Yko4JYiZJgOclKNuBgoz+jqyhLhDoo3rkWrm0k6UYuls
         YXp5cQqcDwuI/tjcQ2oVKs0T9kZHq+O4KVqNUC8KdxJiZox3C9KclnHRLuIQCchvjRDX
         33dmt96nOvOf17wz886xIK+uySeQFnSrLC0JPd9IMDUFJJWHfHw0ySEt9/ouG0vYlzB8
         6LRjiHfE4BiTQrt/a4Tx4uiMQREm6cJClzD+tTKLKA3tkz8o6yHc19JUhw+TdJP1sykR
         AP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769723419; x=1770328219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c+SMixISY32I4TNkZ6inO6uSY2SNlSvt1Krp91cY5JE=;
        b=gq++S+sXnwgvUUhveF1pigE5n7PKPJIiMCYoIwFAK7/HgCRXpx7yVaIw+3pragsCs6
         nTZT8vdx1KgqGv39bwKRnAcOwDPe14wZC3K4DG2zA8tmGoNFU2liDE4KAfGSQllyOaGk
         Du7GJEUAuO9V0y/eYXvpTZLOSI4A174SstdeZQf+1ZAqLqsCaY2rzsDKdkyIhV8BjtSQ
         e0oA2M7b346xLHs45wKPrMfpT3seHHkPtlkfSUMhcdZNLsjzocR6/WiqIXQIjAtxIMtp
         c8BkjCeKZNg4nYuSKiiYKWdqbi8wpjJYNRrww0RC42NdexXAh1uRy6g7AO+dGxA4t6og
         gvGg==
X-Forwarded-Encrypted: i=1; AJvYcCVX3sdLIIKnCpxzox2mInOtGJv2JubEKrRoCNGfzzlcgDAO1fpTdf57e4bmMidAvVjzz32Jgyg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzz9qNjKNLNo66zOS89jA+9Rx1HRzVOPiuiWLQOiX0X2CO9Xzbt
	Gj76bXmouXmLS9Ig7hdEGXl4dSwGGS01vHzfLux5AKigA/URRF2A6Ag+8qNg9ATHrQ==
X-Gm-Gg: AZuq6aJokRIfrLJ5r82Wq/RFTyS4hsxbxhBX9dfgw8YMC5/xhxdbOZKGi2u0lPlFzH/
	Z3VRdBtILcysXT6pkyZBK7ZXYMzZ70Om+Z0s157N0FujNycgZnVAtwmJltRW5HlEK7BLgVUlU0Q
	ZuQiY0g8TtDub5b+yZDHHlk7O4hnSKGp4qY4+SMcAnLPhRRkqUcdjpm26ZMvIuY676kcB7R8bHn
	Rnga3xGVq/yOl2AKBedF1eKRQChu+DV9Jrq6iEOwH4M1LNzOSZ+OSrQ9TSazsTnbnBcmkuoOsgX
	DMG9TNnyJc/e9rxt2Xt+7KzLXkdIc88CgqvpVI2Gpc1t+TCcFvFRuM33nopPscKbenkkErUcZ/U
	JbMSIRedWazeKpbZX4mD2iZROh2zA7SlkcUvB4pYe/x4va7zhliKlcTkFYrBK6DZ92pUPoZ1aAX
	7hlMl//0Vz121NJVb5Mep35tuSunaSRbcsH39ZnUoEF6zRWO6vRQ==
X-Received: by 2002:a05:6000:26ca:b0:435:e3c6:554d with SMTP id ffacd0b85a97d-435f3abb4e6mr1226168f8f.52.1769723419386;
        Thu, 29 Jan 2026 13:50:19 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e1322f40sm16938883f8f.34.2026.01.29.13.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:50:19 -0800 (PST)
Date: Thu, 29 Jan 2026 21:50:16 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 14/30] tracing: Add a trace remote module for testing
Message-ID: <aXvWGDEx6kMQWyoe@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
 <20260126104419.1649811-15-vdonnefort@google.com>
 <20260129113452.190d4d79@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129113452.190d4d79@gandalf.local.home>

> 
> Where was the cpus_read lock taken?

I am pretty sure that's leftover of when I was reading some CPU mask :-(

> 
> > +	cpus_read_unlock();
> > +
> > +	return ERR_PTR(ret);
> > +}
> > +

[...]

> > +static ssize_t
> > +write_event_write(struct file *filp, const char __user *ubuf, size_t cnt, loff_t *pos)
> > +{
> > +	struct remote_event_format_selftest *evt_test;
> > +	struct simple_rb_per_cpu *cpu_buffer;
> > +	unsigned long val;
> > +	int ret;
> > +
> > +	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	guard(mutex)(&simple_rbs_lock);
> > +
> > +	if (!remote_event_selftest.enabled)
> > +		return -ENODEV;
> > +
> 
> You want a guard(preempt)(); here...
> 
> > +	cpu_buffer = *this_cpu_ptr(&simple_rbs);
> 
> Otherwise this triggers:
> 
>  BUG: using smp_processor_id() in preemptible [00000000] code: bash/1096
>  caller is write_event_write+0xe0/0x230 [remote_test]
> 
> -- Steve

Ha, of course! And also for a per-CPU ring-buffer, that is way better to make
sure we actually do all the writing from the same CPU even though in that case
the simple_rbs_lock protect us.

> 
> > +	if (!cpu_buffer)
> > +		return -ENODEV;
> > +
> > +	evt_test = simple_ring_buffer_reserve(cpu_buffer,
> > +					      sizeof(struct remote_event_format_selftest),
> > +					      trace_clock_global());
> > +	if (!evt_test)
> > +		return -ENODEV;
> > +
> > +	evt_test->hdr.id = REMOTE_TEST_EVENT_ID;
> > +	evt_test->id = val;
> > +
> > +	simple_ring_buffer_commit(cpu_buffer);
> > +
> > +	return cnt;
> > +}
> > +
