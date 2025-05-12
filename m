Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D5A255F57
	for <kvmarm@lists.linux.dev>; Mon, 12 May 2025 07:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747036538; cv=none; b=ZeDkb+B5j+19cvPdvqKSiT/d4Gi+PzpNPNWKe6UVlbGEii7r/EZ9eE8M4XlZPLrSkiwnp6xx03F5/aUV5iKc94mi3xY0uqEqQ84AqVqLSgKXYVmi+Z/1QGjZc/KfG+PgwjZB+KliICe4GTm0WFI4HNfBoArd9lQUZ+A5mpPdBJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747036538; c=relaxed/simple;
	bh=7GONjaD7jFf6DraAUB8mWndfQEMMogoPdAMOxswMWYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Du3EV0jT2LgGHicG2MsL6abV173OJEMkPYlFleWNP3Q4m28rgCLMng/ESCjpopDXlbVzzOkfq07iTl78jsVFyyghrjWfqwivo9XHyWw4jcR+CS2o9BcdNGSLNSgHUHH96lQYrseLA6yXvRppN6hBi4nUxnKT8nQSPQIvUyZghcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dbPnMfpj; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dbPnMfpj"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a0b9303998so2030532f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 12 May 2025 00:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747036534; x=1747641334; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JVmeoRs8wht6ScX85zDxCRxMqcg4xq84fv5EF0eHPpo=;
        b=dbPnMfpj5/JDeykwNZbft24mPPHAQpN4d7I5yjuCYOWJ8QlMU+RCIRVAk327chJ2cA
         fp/AEZYjOHbd21c9trC22ZeMZEOfoauIc0tb4v9yHziKFezeta5cjl4YmAcmsih5gBPz
         oZ9h2/IHzZu/YTn5cptYJPa/hIpXGMR7HBMpOZXreieGdS4gMPcRQDymf3HUDXfp6OFP
         hc7Gutp3EEVhoTWI+z06NUzSIPV0jUkkZtGT9LCvwaGzxqlRTv73j9pxuGwNGytTKiW+
         ZdrgQIkCZpURMUZKbrbAK08/s+9I+H8ZcvVz1L67JW7FeX3WQKV55CceRiGywW5G+iqy
         6fHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747036534; x=1747641334;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JVmeoRs8wht6ScX85zDxCRxMqcg4xq84fv5EF0eHPpo=;
        b=PfY3n78hwlG0GqSjUNYwNxKqN6JTcKQtSsmrGj0bBnD2aeZMAnulBabIA8sTIWPLL7
         17H8sJOKCVPAMhl1KUiT+T3R8gcb0OoCqjyUaNfl+5cWvzkYNZS/DfXDpiw9XzYIn95R
         zoLptt8mZfl//38lMnfrhr+8ZnRS/5KjPXSaaG5IdHoxrW49JqKfmoeCiQO7VwJyLxcg
         OVPxyKDikJkpw+THezh2W7CVZXP3ouBKUxgm2eK+AALEP8rAI1oBdDQQYqE3r3ufWD7G
         26WjwNqkxbOfRgElrmbqL4OSO2SxfUFO34BQIuWBC2yhm17ZBwXwLUflYM1svajzyHsY
         01KA==
X-Forwarded-Encrypted: i=1; AJvYcCUHtECpN/I2WrUwcXW4XZWDB7lxfLZ8PLWLTPQPB3pOfabupbmeCMjPVHl3UjNsVbpOFjrav8g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxfoJqyuMI0K3KgqbhHko8n876BQooWeMWGP7zg00mgjKueanY
	s9N8MHkYRdSkF6r2o/SIHt9+o/WdwLuXLzSkE5vutE59IQeuDtanHgmixvTwHA==
X-Gm-Gg: ASbGncuDLtzXQc6NNpO+79y2Fg+RabvdEx1atKNM6R07Ba7n3ZckakToqsfF0UIsQF0
	cdW7bhIBzc9qi7lDY3UbZ+tb8h1hL5mvimjTqEPFk1qQXd+knM3ModCQNDIfaZV526+nZYGh/Wr
	Ui2ZPaPxMK/mr5hpG50Yn80OIOffqC3TdZe2/R9OjqiScAEz2nrh+d85zohzq5qFRwwlXD5rybh
	VEIXscsYDOuGKspR0H4WPjIg58J+ETlJaSpf8DrreRVXZkoGI0xP7haU9MA0bfyWyMlCBL0Wsmu
	zmTGoDpnGHX/6n3vK0FJXkPK/CZT+69+En7G8CqUZDKdEFqaGPcn2MkFD6iroOmzEbOm8UFyxlq
	5E+U7i+c6v0VhOYx/RkRCzG96Iq4=
X-Google-Smtp-Source: AGHT+IHRngy7dyfSblPZg3kx1M0V69ixjtLKeGbM3AJ71FSYb+70+rHci10V2fws5C9DeqNnhr+dvQ==
X-Received: by 2002:adf:e612:0:b0:3a1:f724:eb15 with SMTP id ffacd0b85a97d-3a1f724eb66mr7737749f8f.2.1747036534388;
        Mon, 12 May 2025 00:55:34 -0700 (PDT)
Received: from google.com (218.131.22.34.bc.googleusercontent.com. [34.22.131.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58f2f65sm11745987f8f.55.2025.05.12.00.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 00:55:34 -0700 (PDT)
Date: Mon, 12 May 2025 08:55:30 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, kernel-team@android.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 05/24] tracing: Add events to trace remotes
Message-ID: <aCGpchGnvyFpWk2y@google.com>
References: <20250506164820.515876-1-vdonnefort@google.com>
 <20250506164820.515876-6-vdonnefort@google.com>
 <20250509154735.530d4a37@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250509154735.530d4a37@gandalf.local.home>

On Fri, May 09, 2025 at 03:47:35PM -0400, Steven Rostedt wrote:
> On Tue,  6 May 2025 17:48:01 +0100
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > diff --git a/include/linux/trace_remote_event.h b/include/linux/trace_remote_event.h
> > new file mode 100644
> > index 000000000000..621c5dff0664
> > --- /dev/null
> > +++ b/include/linux/trace_remote_event.h
> > @@ -0,0 +1,23 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef _LINUX_TRACE_REMOTE_EVENTS_H
> > +#define _LINUX_TRACE_REMOTE_EVENTS_H
> > +
> > +struct trace_remote;
> > +struct trace_event_fields;
> > +
> > +struct remote_event_hdr {
> > +	unsigned short	id;
> > +};
> > +
> > +#define REMOTE_EVENT_NAME_MAX 29
> 
> 29 is a particularly strange number. It's not even divisible by
> sizeof(short). This will leave a hole in the remote_event structure.
> 
> Should it be "30" to plug up that one byte space between name and "id"?

Ha yes 30 is what it should be!

> 
> -- Steve
> 
> > +struct remote_event {
> > +	char				name[REMOTE_EVENT_NAME_MAX];
> > +	unsigned short			id;
> > +	bool				enabled;
> > +	struct trace_remote		*remote;
> > +	struct trace_event_fields	*fields;
> > +	char				*print_fmt;
> > +	void				(*print)(void *evt, struct trace_seq *seq);
> > +};
