Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2DF156C40
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 21:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736286412; cv=none; b=GEovop3sdrt0KTHWMaPCEgtBCW6uBNxwUltbxIx8+o6vHd1/LLPIMwqWvVAR8+2QqxNATN2KcRN0tioK9pfLujQ65HcjUYm4FhyAeUUP/z2qqpKOe7iQnxJ38vuT6R1abn7E4visuxq3cxhZIuPXuEjPn1XoDJ+Ia247gCEJlDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736286412; c=relaxed/simple;
	bh=XwudySMYgDFkEiNkXy9QyJPVs4ozERHAt/1oE7xfK+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WiwwpCcz1HxjcTc/LkAUJX+9vVwcBt1wpio9yrvMQxaJSbT7sAd8AmJBJIuSh9BF16C8wtFY2fvJfIvUyHhRozuO3HHMucN1mTkhF73ONN/3HxWM6DGiyNkAjf/Umszt7epnS11/rhB64zxvvolxW4wKHLpiFCZ1N9sslx4ag3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1of+Qzh1; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1of+Qzh1"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43623f0c574so110895245e9.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 13:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736286409; x=1736891209; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=45zDSr1nHXxJjlC8/IZ2CFZWXTQx1GFlSPewYhMnWhw=;
        b=1of+Qzh1Pgq9Y3i0q32NTH9qfzeJb8Itj3jh9mUbB52pllqJB0aRKxczAOXlAFui6C
         JJbnFk2cvjbpqlXm5qHvH3yc9cvpII2loVgM+J0uoSPcktvxg4N4lvTJU8lshqH8gsob
         24HlEYHSLZfkW/x0eEjQfTj4ioNLioQxYOBwe7AeuNojKj3ptY6vjKeNQqpCZcBz1pZA
         VlROEWRUrM6YHz4nEjmo42sN+CUdIMlSo83FqCDT0SQjTTmx2WXODWqzireXX7OGQYRq
         /pLxH66/IwMbh+pI9QKljvTIU9N54PfrLcpHT5+LcxZzhqpq8pkcEeSOP1ZzaRrCh0GJ
         88JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736286409; x=1736891209;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45zDSr1nHXxJjlC8/IZ2CFZWXTQx1GFlSPewYhMnWhw=;
        b=NXIxOLc8MFdRqtFfvi/MMFvVDmJ1gXfZ9pSwVdTUTVXdAerkS5vMmq0iL3sSXAHmN9
         RK+XM0nMOfU3NXNKY9StdypK1w2VKDgBl8hfEE5Y2qZ0C64nHR5RaPGMKqVKmuwj02QQ
         J2U+E9epQ+EYM4CuGoTCCzWNhBGkWqdG9OXs83pw2DyMeqLn+Hj1e0jj9tNfG8jcTc1n
         2jznYXml1pb/CY4fuM/gGzR8U/J9vTN7vvmtsTAUTceDB+V1EPVd4ppdi9hnhNy17dFu
         f7F05v7gj/zrtULhxwBIt3S/Yvizvv/6jKaaxsufyI0JqP5EWsy6htEcmyatyITyBcGa
         kCWw==
X-Forwarded-Encrypted: i=1; AJvYcCU23OvYz7ZbzzFpB391CTLWrY2qUld/moxsd3zQNegPtK5ImBHnVncrq2LiYdkMzAUKEhPFAAw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqqPkSTe95KGkQY8QWhb1tOcpL9DASycKiorpvDptHHrZur3Tf
	9PHKTKkH442jpgDmqT8xuzGhMtDlkOqX08aq0QHtemotSxxofeAldYSo4SFgPw==
X-Gm-Gg: ASbGncv7OeUbBPdb3a1rqpwc/75zDQHUGfE5M4hj1rfUXlOT+knRC4sK+aCzNpufGzI
	Qp1JwhxLNu81Q8KV8bdSX/5zOWarGRevIIaJs+rDUohIFbBV/9AiNCtzuoqVVOT1eP+NuFWIGbt
	PBVSvgpLh904J5ng27M7sEZ4daFTz/6mQLPo04ALPBm2C1Vi51mnb2VhnBRv/XCOGgmBiA8bWlE
	OJF/n+c9nddVHyqwFC9ONoUfpx5is6R2zXkkpeXksPvM+nvghLh+2M3iIscor6qU/O0YRf2vEvB
	8Mry6DA+B5MTeXc9
X-Google-Smtp-Source: AGHT+IE4xCpmNumMlx3DxfP6Vn9CkrrdyNZOyrwzPq8saTfgefufXF6XhwqYSJh/q7tze+l1CkakwQ==
X-Received: by 2002:a05:600c:1d14:b0:436:5fc9:309d with SMTP id 5b1f17b1804b1-436e26f6d80mr1746725e9.30.1736286408741;
        Tue, 07 Jan 2025 13:46:48 -0800 (PST)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2dc0bb7sm11425e9.16.2025.01.07.13.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 13:46:48 -0800 (PST)
Date: Tue, 7 Jan 2025 21:46:44 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, will@kernel.org,
	qperret@google.com, kernel-team@android.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] Tracefs support for pKVM
Message-ID: <Z32gxHCt363ye1Vv@google.com>
References: <20240911093029.3279154-1-vdonnefort@google.com>
 <20250107145439.5bd66362@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107145439.5bd66362@gandalf.local.home>

On Tue, Jan 07, 2025 at 02:54:39PM -0500, Steven Rostedt wrote:
> 
> Hi Vincent,
> 
> Are you still working on this series? I was expecting an update.

Yes I am! I had actually a new version ready just before christmas but I thought
I'd better wait for the new year before sending it so it does not get lost in
your mailbox :)

Hopefully I'll send it this week!

> 
> -- Steve
> 
> 
> On Wed, 11 Sep 2024 10:30:16 +0100
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > The growing set of features supported by the hypervisor in protected
> > mode necessitates debugging and profiling tools. Tracefs is the
> > ideal candidate for this task:
> > 
> >   * It is simple to use and to script.
> > 
> >   * It is supported by various tools, from the trace-cmd CLI to the
> >     Android web-based perfetto.
> > 
> >   * The ring-buffer, where are stored trace events consists of linked
> >     pages, making it an ideal structure for sharing between kernel and
> >     hypervisor.
> > 
> > This series introduces a method to create events and to generate them
> > from the hypervisor (hyp_enter/hyp_exit given as an example) as well as
> > a Tracefs user-space interface to read them.
> > 
> > A presentation was given on this matter during the tracing summit in
> > 2022. [1]
