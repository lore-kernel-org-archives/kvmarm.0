Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEA632A828
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 12:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757419832; cv=none; b=L4qmweCQCQw9XXV1UwiQ1GIL1LO3ekV5WGUvsvB46hdmfZmML9JRQozHbUsTYqXeaompSm8Q5ToQtzlq/tpTF4rzc7+5XijEs5Bc6Z81cmM3f8dj0yEnNYDmvHj6EpJ+jKNl1cuAfNAdqWrP9z4orfUse3+P6jVqk8GX/FIE3rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757419832; c=relaxed/simple;
	bh=POQ+KrDMZzWUCA/637U0YCLhbicOSpe5n5QI1q7mb84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLTUPAak61rqiOE2pJGtqEl8Xj3heuBn9AIBiwTRuG83LWkfht7TrNyZI3rISp/Nd7Wt42aDCoT3F2Nrz9yeAuhnmVxpZMM1Y4IPBx6UrXFCK00r1KHqmHH+jYHOG6MqK9OgiKjR9zbAv82UEOFiRo391XJ7oeMl3vFAlBKovPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dZ8ekFOo; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dZ8ekFOo"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45cb6180b60so35288805e9.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 05:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757419829; x=1758024629; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6WMhFn1C+Yx6W2wpeHv5vlp4fLrLgkTAzBM0vbXLgCo=;
        b=dZ8ekFOoE44xI6zqA0PBCtR1Sa7fwX6Q5eCRzEbsT+0HjwE6KeMCfRdJSMlQ5Lxl6L
         rzQH/b394Y2K48uZDzQA3h5bhhFTvuOPvglJX3yKXTTJQFDvEYi5RCImG45eWSMScA6P
         6By0nQR+3pVaHLL5ZjPXH2jI/mo3+sVzaiCbgDH+M+9pU3uaoZgAHXkiAPZ90Zbg0mz9
         8VLfeS2fz2oLKahc0yoFCoVfIlFqEbM0lttXOKV5ye0B5CPqZWT1cQRq0PRUAvzrlu6N
         EJnyPyT4XvT0Tm6/gydVgeEIzy6zOsG4LCHtQebqQzYMpxBrT5prAEWCFbpDCyKYoiTA
         OavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757419829; x=1758024629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WMhFn1C+Yx6W2wpeHv5vlp4fLrLgkTAzBM0vbXLgCo=;
        b=Q96aLUO5spSIH2Mb6IBjs9HaVG2VxOsdcyZ0kh5bVWFCl3ozNoCT1egumdIR7epUph
         hZrt0rfmHM8SVJC+9UPgMoB3678cwwwQJesh8AwCibnrvxeH8mOtuXmbX/fNLSSwOJcp
         +fcySJLyQzo6kOhrJ416zQZLdoikvtFTzb5GY2XX+Tu8sT+CWYu0RjfQa45Eh2Tc6kt6
         PZQsgt4eBHJoK3tbYUVYyJhi6BkVtwmjFxMiZvhKwXtGLwvOodB2LQojsfWGLXi4UNgY
         5xxnMfwmAj3AH1V1XtWNg8c3K7Y5eylJ3j6hzu0s2JQqDUMruvhGoZzgYgekOcYLd+vZ
         jBjg==
X-Forwarded-Encrypted: i=1; AJvYcCUCsvcXJ9PA8KJITWolXZaAWL3+2Y2IV2EIdXsNfyOTaqW6R/Og7e+egkLgAv4MN35hQPlC1Xs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYCWDtETRgyYuL+cWSNxHkwx6aJmzTkQHxULV6pmkNnz6SCqAd
	mDiF8W0Sv9LSR7mhqztg2fyqez8zvEIE375OuXstcNOJU0IFTHJGGRO8PX2O9N3hYg==
X-Gm-Gg: ASbGncsThre3aBQtm9QxulwtyvCTXBlxmqDLvXL77l3i+5NhzQXqNYEjwGIJT+N+kCl
	Ne3q+lF7MJL6avALMidRhMwkq7QOnhlVyrXShw6CS03MFFymQXnMJi0njmJmHpWxbzdfJQ5YTPE
	3TfSTW8Ud3jFQlm/J2es++W2VsEZOhBeRRV2xXolEg2VkUUqPc9ZoFAzZ0C7fLsoEumYIjuHCJi
	qF8xa4+K7N/sbkMaZgaAtmHNbJGKeoUcHEqCOJDFeGmjlJAQXEe6elPSP9Yq3y6Uw2naSUrbpCD
	1lgZ2ce2YSexLH4X6A6+gizOCBj9U03YAk8AAydMjIvoNdsZElTM64xDOMTLLD8Z9ZKoVE9N3a/
	s8F20HmheB4at5uqHD1MtvHip23zC1TLqLzfrnYh28LP29FctSk1G68QvvZjtG3HiNvfSTw==
X-Google-Smtp-Source: AGHT+IEC0Y6r4tWAAX1HWCsbBwXYE/aB19u5wg0kytabUISZq9YPIfqob+aeZg0wKmLtsUPhiNDWVA==
X-Received: by 2002:a5d:61c5:0:b0:3e7:17d4:38ad with SMTP id ffacd0b85a97d-3e717d43c09mr7390502f8f.55.1757419828720;
        Tue, 09 Sep 2025 05:10:28 -0700 (PDT)
Received: from google.com (211.29.195.35.bc.googleusercontent.com. [35.195.29.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd2304e16sm234800165e9.7.2025.09.09.05.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 05:10:28 -0700 (PDT)
Date: Tue, 9 Sep 2025 13:10:25 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 04/24] tracing: Add reset to trace remotes
Message-ID: <aMAZMaZJ1_Eny5Ku@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
 <20250821081412.1008261-5-vdonnefort@google.com>
 <20250908193757.079aae76@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908193757.079aae76@gandalf.local.home>

On Mon, Sep 08, 2025 at 07:37:57PM -0400, Steven Rostedt wrote:
> On Thu, 21 Aug 2025 09:13:52 +0100
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > @@ -400,7 +436,9 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
> >  	    !trace_create_file("buffer_size_kb", TRACEFS_MODE_WRITE, remote_d, remote,
> >  			       &buffer_size_kb_fops) ||
> >  	    !trace_create_file("trace_pipe", TRACEFS_MODE_READ, remote_d, remote,
> > -			       &trace_pipe_fops))
> > +			       &trace_pipe_fops) ||
> > +	    !trace_create_file("trace", 0200, remote_d, remote,
> > +			       &trace_fops))
> >  		goto err;
> >  
> >  	percpu_d = tracefs_create_dir("per_cpu", remote_d);
> > @@ -422,7 +460,9 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
> >  		}
> >  
> >  		if (!trace_create_cpu_file("trace_pipe", TRACEFS_MODE_READ, cpu_d, remote, cpu,
> > -					   &trace_pipe_fops))
> > +					   &trace_pipe_fops) ||
> > +		    !trace_create_cpu_file("trace", 0200, cpu_d, remote, cpu,
> > +					   &trace_fops))
> >  			goto err;
> >  	}
> 
> I wonder if we should name the file "reset" to not be confusing to users
> when they cat the file and it doesn't produce any output.

My idea was to keep the exact same interface as the rest of the tracing. I could
keep that /trace file for compatibility and add /reset?

"cat trace" could also just returns a text like *** not supported *** ?

> 
> -- Steve
