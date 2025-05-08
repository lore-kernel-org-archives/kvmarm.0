Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AE723E325
	for <kvmarm@lists.linux.dev>; Thu,  8 May 2025 09:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746695447; cv=none; b=lgkyQeCZ1k6G97av9YdmjyC6KohtLaaaXiMMMF9B7sSz7I9RJJvCPRM34Prnc8LdT/SLGrRbNWo9gcTCdGY5UwOJvlrcLPIoYJ+ir9Mc+hXmAtK9xzll9Xux+9VZnQmRhq/21zE4sxPN1Ah42rMa+a0b3DY/ro5WOJrfmsFZn3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746695447; c=relaxed/simple;
	bh=LmiasClNLNII0WBPSAYz+34LkkofdgOSbO+b2cSkmPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IAbCZsQIo/GmdAgtDIffECRu/DPYhoragLf+u+3i0H1myXo2ToV/zZIK0Ojol0egKa0m4ro6bwTwLHtXhks69tOqR7w9lh4qQe8y6U7W/S4LBp+kosOS259MOnsW9AWbAOCIrALpMn5b814RawLNsK6rD7Kwvaxu7OTHA+cUkPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WnzkwQcg; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WnzkwQcg"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so7808375e9.3
        for <kvmarm@lists.linux.dev>; Thu, 08 May 2025 02:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746695444; x=1747300244; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l6UyUXCpgr0WUFmw2sPhx8dNtCUTskL7HDMmKzVGhcM=;
        b=WnzkwQcg8xodE2/sEzBScdNb25wGYcN38mTYP7UxPrUR22rrIXd1bZGO8VjFGAfjB8
         rfU0it5OueOQcoutgTE+c+fimBD82IxzQhDr+rcFaP2KBOlMy+NFpu6uFlpQn6u/zueM
         0j24CgqGM6YycMnceyUuYurjkqZwxjq55mRDoizYIkI8cQ333UbyDWCDJccXqyWTY/88
         E8yiCDtkOOmxV4b6T/V4TNJyGOb32HVVGYVA/QLUQMQxiHl70ZuIsBmtybafWCuO5fFO
         Rh6zQ5FreYN1IRXTK3lwsuG2f+WSOx7yj1keIrqdzaKTCA5QHMghqaiQ0D+yyl4n9/k0
         gVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746695444; x=1747300244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6UyUXCpgr0WUFmw2sPhx8dNtCUTskL7HDMmKzVGhcM=;
        b=xCdNaksr4v6a1uMRLWkwiuf5Kq9Jt/vx8WPBm1lBTDmqIHGvYLXK3RGACXRmsuDTAl
         3JFv0FCKVTSBK7d6c7i/miHbQGtYA/JUqC9c4QaR1aF0/7jSvSGJSiNg+zjOPRrTgxH4
         ePZrByjdAQCWHm7HHUDICy9fww84UKAF0lUVtaH1GO10msCUKU8/xMAPBU4eV2ZHZVrf
         yajPcM9TEhxcqkVJWne5zIFncD2d69oZq+wfwXjEby5Tt9P/ldXNZUyxOgKmLYyylQU8
         yzLyVQQhDX3F5TgYF5IpipDWzcIg9EmRDp6RWhxSUhjcqqB7koysx3q0dSS6TY8pk3PN
         UUuQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+FotnTSlcWGIO1WE/y4IQxczFdGvorEQzFiIdGM1MztB5BwCm/G3hPj78Ju0ZgZ1dZX0a7K4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQydRwDkvF82E+6UvIrgPUgqftsghuv2ek1kS2nwd7kO8A1LEl
	VkLnS41/6akiGxHBQf5HWMloHDVtC0UxSZFNfwCewv9ECx5ltBpYSnHn763M9A==
X-Gm-Gg: ASbGnctP9fEgD+I99oV1iZbqqUPXefOEibpDoLZ+rUsg0KPr8Ipbe+OBup5x1r7ztBx
	J8G9xYqdFmNgatPdG4kGgc+oOP48148EzlMKZ1YQ2gTtwHrteWiR6tzrsxoqG9NP/e4buiLs+93
	kqMwg91l1HzfqJ3YIldDJ6jyOYU+lDrQBI+oq6S5/ayxeHQhJF6F7oDE6jiB/4LFJQVPkbUDuXJ
	SLaT8iENJagVEouEBYeDwscQYrIsffQyQzetkzeCwyLCqnCL6FHHF7hJSBidUdtQFGp6F7IRYt1
	ecJK5VHzib2BlJxrpGoyijBTeuOj5S7DJf3f3Dss6zZr0YENoENYAy7WIQlYAVzBWdRVV8MpQHP
	qz4xt4imHP0HxAGSI
X-Google-Smtp-Source: AGHT+IFE0UJOTPADB0ayGWYTFGEaXRl7J0a4Js+PxgbBt0NVKKxXiHCD9XRls03Gxp9z/i+BfiucLQ==
X-Received: by 2002:a05:600c:cca:b0:43c:f5fe:5c26 with SMTP id 5b1f17b1804b1-442d02e284emr25519055e9.4.1746695444305;
        Thu, 08 May 2025 02:10:44 -0700 (PDT)
Received: from google.com (24.204.140.34.bc.googleusercontent.com. [34.140.204.24])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3af15bsm30152975e9.30.2025.05.08.02.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 02:10:43 -0700 (PDT)
Date: Thu, 8 May 2025 10:10:40 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, kernel-team@android.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/24] ring-buffer: Introduce ring-buffer remotes
Message-ID: <aBx1EBa6QFH7dmqs@google.com>
References: <20250506164820.515876-1-vdonnefort@google.com>
 <20250506164820.515876-2-vdonnefort@google.com>
 <20250507194722.263a8d1e@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507194722.263a8d1e@gandalf.local.home>

On Wed, May 07, 2025 at 07:47:22PM -0400, Steven Rostedt wrote:
> On Tue,  6 May 2025 17:47:57 +0100
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> 
> > diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> > index 56e27263acf8..c0c7f8a0dcb3 100644
> > --- a/include/linux/ring_buffer.h
> > +++ b/include/linux/ring_buffer.h
> > @@ -248,4 +248,67 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
> >  		    struct vm_area_struct *vma);
> >  int ring_buffer_unmap(struct trace_buffer *buffer, int cpu);
> >  int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu);
> > +
> > +#define meta_pages_lost(__meta) \
> > +	((__meta)->Reserved1)
> > +#define meta_pages_touched(__meta) \
> > +	((__meta)->Reserved2)
> 
> Hmm, I wonder if this would be worth adding to the user interface?

Would trace-cmd have any use for those fields? That said, even if it does not at
the moment, it would mean the meta-page has a single version between
kern/user-space and hyp/kern which is probably better?

I can add an additional patch in this series to extend the meta-page.

[...]
