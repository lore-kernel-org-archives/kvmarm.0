Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FA01531E8
	for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 11:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763638583; cv=none; b=eRzNUhvxDCzHfOhh7wR66T+saZUkXUuxLHMQJgwEjsNF1JQO0s6LbTaca6vOaq41tgHybwtvRpKSfVkEPkoG5DlPWfvUvgISuyFgmoH0bDxXTkAV2ujZX96Xs/IaGc/8JAKQ/fvbbB8cYdlGivqd8tIEvii4FOKzKLZnMuAVDdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763638583; c=relaxed/simple;
	bh=F+0N4wMzGmWADzwl/vFuA6k8UEcvJMDKp1Ep/I+CU2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GwowaKah6WQN0NoJ7VGWR2r0EglqtpP3NcwSjJ0G69TccERwoX1qdxbZVYWHg6FwyywkGzYa4LxJ9rO866rsxNRrZ22GmxDwYpXRQKGm5DeaU8mUyMMD+viHnqQSlDYhJI9wKd8CgwRjt3YXy4QhPlkYSHvpvY7xiEUC79IwT80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lq8en3f6; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lq8en3f6"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477b5e0323bso9757625e9.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 03:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763638580; x=1764243380; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TPlzmXt4DNVBdqLVvxiBIWu8Rl4FZ4bDuiyypGx7MuQ=;
        b=Lq8en3f67tz+ZrCxmAx5vKzyeQYWRib827qf/94cXV5pjsg7SgMv1Czs5ZZGAZM7rF
         /reavl4KO14f3q0bqut/z0Dn24g3nof+T8ELbs3VBlTSfKrZn5a9rJipAIVpPHf4R5ms
         geRuGOCDMRXA0VJpuVJP4LBuB2wKOR8t0pMK0ydjL/noad79Ln9rd9gR4K09Yigp8OiL
         DdKbo3+N6Zugd2OsYQ1v1U274qIwZ9X5/qXrdS+Q0YJkuR6in4VKCP748LKocaOT+JcK
         l0fe75i56AZN7d7fGh0Qn2Euhs8/39+Z3WI8wMXJaegPaoil0xYyf6Or69OVdzYrYMmP
         Kmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763638580; x=1764243380;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPlzmXt4DNVBdqLVvxiBIWu8Rl4FZ4bDuiyypGx7MuQ=;
        b=JhxFRvQ9c+jpHrm7ki01JLHO5ezoCBBmTPK5p0uDmBCzUO6U+sKK3JPkFh17F1Agj3
         CZLY7Ly5FjpMi4F5qU/gquDVLpbcfJeozUN2gs728LJMfbvqyMvBVNommpzDPHX9sp87
         RnuRd/DWyNyLCZh+P9aNtkSubgBZkBTU0KAQdl2Oza6s4XSeqldhw2eunUvEqiDvNUZL
         e0RnpCrsBFJwD0K2FUMfJ/50f4b5H2hDT9nIhwkRemgQppSPMMHaymz62fCsdsmu6d+S
         6mMPwuz4PQqYFovJKND52z03Zuax26yDmQmWUYiRnMge6rx172lzPvO8/WuFl+Pn36TZ
         SU7g==
X-Forwarded-Encrypted: i=1; AJvYcCXXBy42T/qZAcRii5yHuG+JxMUJwUZO3v4X0qBjcRTTSYQD+X91MbLlqtj8k0vV0zlx0cVOmE4=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywmo7+e265PfCdSU9x9WlTX6WxFmoy6kmbtc2Mommvm2sVIjB1o
	AQvhZz/FMtTLU9n1lSpe6yAnLLXvEBM5G+UgVfvDfC94i+0tbuvMOxvqZQTcroemGg==
X-Gm-Gg: ASbGnctsvLKJwIYMySYeTPrmlk7CyXDVN6s8eLpwlhle22oNcCmVtL+JUAPNheyN/0T
	6d+rduKDCmJz5698DhGnz54XrBn4bCaueAuvLMvzqgSwWAHriUSqKxi61uYpiGwlphnNAowq73Y
	V03CljnupP+ZKxMaWtbZ3Kulsg0e6f61PF3JdQ03JvUgcCqtX6GiiIq+gmLuof3yTAdD3OdGJrb
	IZqdtv0cbdO9/lMBMEZiFxfXcqnaJli7FkBNxdsh+GBRjYTpi4MrAlo2ScN2uIVOJ6HU9cJ/qxb
	tT9huHAVQ0nmnTBxEv+vRwJa6jJSBUAA2nFAwSK72orkjV4j9Wu56UjvCRYj06G5tgN2AaDiapM
	Rk861EA0BL2psS1kdGAXL04+P+C4jbKlWtXmY0P0RhWH+acHrAikfCEzkDAlYhoRNgOaqLVIeYP
	fXTZH1H7tNIWyASKOA38Cf0iWx3qxSiJywtRRIbTupOeMhiiE83A==
X-Google-Smtp-Source: AGHT+IGcOCRDUWPkVUZ7ncQTNFf+q64GbtuEHTlJs5oKc83ztKfhHnrQKRpzLVqerrPSrM7dBJtv3A==
X-Received: by 2002:a05:600c:2e4c:b0:477:9890:4528 with SMTP id 5b1f17b1804b1-477b9ea31e9mr14670485e9.2.1763638580134;
        Thu, 20 Nov 2025 03:36:20 -0800 (PST)
Received: from google.com (120.54.38.34.bc.googleusercontent.com. [34.38.54.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477a9e1b657sm60238005e9.17.2025.11.20.03.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 03:36:19 -0800 (PST)
Date: Thu, 20 Nov 2025 11:36:16 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>, g@google.com
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 20/28] KVM: arm64: Add clock support for the pKVM hyp
Message-ID: <aR79MCNlAKP1H-PQ@google.com>
References: <20251107093840.3779150-1-vdonnefort@google.com>
 <20251107093840.3779150-21-vdonnefort@google.com>
 <86cy5erprc.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cy5erprc.wl-maz@kernel.org>

[...]

> > +/* Using host provided data. Do not use for anything else than debugging. */
> > +u64 trace_clock(void)
> > +{
> > +	struct clock_data *clock = &trace_clock_data;
> > +	u64 bank = smp_load_acquire(&clock->cur);
> > +	u64 cyc, ns;
> > +
> > +	cyc = __arch_counter_get_cntpct() - clock->data[bank].epoch_cyc;
> 
> I can only imagine that you don't care about the broken systems that
> do not have a monotonic counter, and that will happily have their
> counter swing back and forth?

I haven't used the _stable() variant for the affected devices... Hum this will
not be trivial from the hypervisor. I'll see what I can do.

> 
> Also, you may want to document why you are using the physical counter
> instead of the virtual one. I guess that you don't want CNTVOFF_EL2 to
> apply when HCR_EL2.E2H==0, but given that you never allow anything
> else for pKVM, this is slightly odd.

You mean I might as well use __arch_counter_get_cntvct() as CNTVOFF_EL2 will
always be ignored in the pKVM case?

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
