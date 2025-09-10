Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9482566D2
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 09:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757497681; cv=none; b=TzdvbywNrL0XYkha/aWpXDmlCfnWOWYXW/eeaAe3ADxPPp6un/cUlXUKjH09i3dQX0uL6zqXRcuGdEYCJ99rgkA18HGvF9utnRBqi7BPlHUwaaCWALi7VkTVr0rhuY4FiEvWfZ0R87M8/YUvbEfdsUiTkpyRXTeJiLNCWo4cIqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757497681; c=relaxed/simple;
	bh=0V31LUAQineHaHR+Zk1fa1rB++gkt0nxE0bE4w2NcJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/WEqh6r4lOMrgi36Z8/G7OpRc0G8W0LiFcFVtkTWWxeWVnwy/Jo2h3JjUPPbKvdZbAqDYtbYqu9Xs08WN72z/l4zaLLHj+wEAR+5YazYWCGGFzXoHQmJ1tJXOOFMsDVqppFr/NA/uvCY0VAZ5MqcbGfu2P24yux3jBBPH8j2o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m2mkdFAx; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m2mkdFAx"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45dd513f4ecso40979355e9.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 02:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757497678; x=1758102478; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uvtu3uafbueZeizVaV/6mc7Nfku5GeAYQMpYTXLT+4o=;
        b=m2mkdFAxVwHMCtKTF++oQ7bAnV1k4VbYzx57uCuvKa6I5BV+odx2zSxmwL0Q809gss
         Zu1UrSK+rrF0uKnlX9P00dPQcA+R+TTeRRXbNn/dJWV+x28lT9W7WhPZyuSk8HPdfNJk
         rVOrmblXAiiiLKca8JNUbq5iFCQYpExiHMgzcwXQGZOGYY/iJdWBLhR7S88+KdjnN+tk
         3nXyBfTS3hLbma1NjK3O4Ds1uRQtd0X98458kDM2ocPYGR1KG4dyNMRzF7LJQeKMYivo
         /t4DnPEn7bVWRvikcsfdNZuWgxvyUzE3/5DSFkfUkFqxk+BHBLufsFrZvOTfAbp4swhj
         XCOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757497678; x=1758102478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvtu3uafbueZeizVaV/6mc7Nfku5GeAYQMpYTXLT+4o=;
        b=mRvHa8/WV14PSiVMyMa4cVG3AE4oGKQgoFNiCqVD19K2QU5VXyyozchl/Y5Utg8Mz9
         T8aNtQTSDqEFqtZibtkpH3kN+w0GxBwri13nwbyFmWAN1Bmp79zMsivOi41RPZkXXQfZ
         aTN6ypgup4s+iNtdieZJ7leMv3ZCjiROSV4yKVgonwC1TPvBc9b/eF3NG+svkmPw9fCb
         1cqfbI8I39VHwdT/OumCh+AZpktkATHFQETjSfwMUE5/Ca3MBkcrVdcU5phx7gOXxZut
         4PrPuAgLGS31xoxszMlonV90heVRd13raNXDzCvsT32eD2D5fINX5Pmsp1+qwVu/74IB
         MlWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWa847zihQZslo9yZJ0DPRJQkKjG8YKiZCZCm2IHopO7zrIX8cOTL1/OxzAza/3k7yGKIcz8tU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2DNjIgNKKCpdEYvYEe0+Yy3MzOoyUCwKvEX2FMso/JrVgRhTJ
	lP+eGQxnX8fD0ixR6UktjacBX3Grkav5Y+VmCIzoJsgRgRqjvcLKpMaZSvflyZlQGw==
X-Gm-Gg: ASbGnctk2Pk1Y62yMWwQq6cehxerDMfu7fU1ZBVexdNLj4xwi+FfqdZWIKqpbe0cN5G
	Xb+U6Byp4/1DH43iRA9cvSEbOzMAQ4ipu6TlZYYyP508QPuZbYVMNUJMUfdTKBBq7wPuHQ+RMaO
	JOwcfVFKyHLFjVTnssEx/lFAXuOn5J0sM+HZ6YHyxwDcVZpaj+4AcHK64sPpKx9PBHqp1quKQco
	haPqsUpFRWZQbl/yRMxj6uJxFkazb+fg+bkv192mu81OZkDq2cgd4TF8wVW1oaLhtEYiJNx0J3p
	WE9LY3y+MpOPEgqDFSsRjPOy5rHcqVCrJ7xqcfrEpLPXL3eVnAe0P5lGWxtvkhea2BAfnktnzyJ
	+XVrg8t0q1Qs8e9fTyOvJXNJfN7X/nkcQNK1hyTIsoTbwITOkjbLrEJC3WKmQKMjj394PvJoS2R
	r2Nopg
X-Google-Smtp-Source: AGHT+IFWWYfR8ORYSi5S/6yVLRSE1Vl7ci8b3o8skMEhA51akRxc13pv3ScUUN6gVKKYUtaBgf3yww==
X-Received: by 2002:a05:600c:8b43:b0:45d:d718:3b9e with SMTP id 5b1f17b1804b1-45ddde92627mr142163035e9.10.1757497677772;
        Wed, 10 Sep 2025 02:47:57 -0700 (PDT)
Received: from google.com (211.29.195.35.bc.googleusercontent.com. [35.195.29.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e752238832sm6017788f8f.31.2025.09.10.02.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 02:47:57 -0700 (PDT)
Date: Wed, 10 Sep 2025 10:47:54 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 10/24] tracing: Introduce simple_ring_buffer
Message-ID: <aMFJSlbHRsvzYKaF@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
 <20250821081412.1008261-11-vdonnefort@google.com>
 <20250909182644.092b3e85@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909182644.092b3e85@gandalf.local.home>

[...]

> > +static struct ring_buffer_event *
> > +simple_rb_reserve_next(struct simple_rb_per_cpu *cpu_buffer, unsigned long length, u64 timestamp)
> > +{
> > +	unsigned long ts_ext_size = 0, event_size = rb_event_size(length);
> > +	struct simple_buffer_page *tail = cpu_buffer->tail_page;
> > +	struct ring_buffer_event *event;
> > +	u32 write, prev_write;
> > +	u64 time_delta;
> > +
> > +	time_delta = timestamp - cpu_buffer->write_stamp;
> 
> The remote buffers never get preempted do they?
> 
> That is, it doesn't need to handle different contexts like the normal
> kernel does? (normal, softirq, irq, NMI, etc).

No, luckily, we don't need to support any of that.

> 
> -- Steve
> 
> > +
> > +	if (test_time_stamp(time_delta))
> > +		ts_ext_size = 8;
> > +
> > +	prev_write = tail->write;
> > +	write = prev_write + event_size + ts_ext_size;
> > +
> > +	if (unlikely(write > (PAGE_SIZE - BUF_PAGE_HDR_SIZE)))
> > +		tail = simple_rb_move_tail(cpu_buffer);
> > +
> > +	if (!tail->entries) {
> > +		tail->page->time_stamp = timestamp;
> > +		time_delta = 0;
> > +		ts_ext_size = 0;
> > +		write = event_size;
> > +		prev_write = 0;
> > +	}
> > +
> > +	tail->write = write;
> > +	tail->entries++;
> > +
> > +	cpu_buffer->write_stamp = timestamp;
> > +
> > +	event = (struct ring_buffer_event *)(tail->page->data + prev_write);
> > +	if (ts_ext_size) {
> > +		event = rb_event_add_ts_extend(event, time_delta);
> > +		time_delta = 0;
> > +	}
> > +
> > +	event->type_len = 0;
> > +	event->time_delta = time_delta;
> > +	event->array[0] = event_size - RB_EVNT_HDR_SIZE;
> > +
> > +	return event;
> > +}
> > +
