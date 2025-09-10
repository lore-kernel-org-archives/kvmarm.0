Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2373164A5
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 09:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757497513; cv=none; b=fCOFyzN3HK4YbZxicKK+o5BeDNMH/rOk9aZX6GyS/PB116VlBAiQZc/aJeIF+sPTmOGYZZAGQnOfQj0h5E51ObcofhDtDttvMCDYfNcuScpblB+POBJSfAqqi7HBRAPIHeI4Ci1r8VVuOwiWH1fPncBkIM1ujPPilC4g+u8ZGsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757497513; c=relaxed/simple;
	bh=GCwe8Dko3jDOXji8AdD72nwYCErq8l4yfDoJj7Gnt6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZFUV8k0tLALtn5FQ3vzutNfQF3tRvkyvKv8kZlwkjNGhFO9UsHtNcwwTt8blJiMVJDXdX/bkjURuNatv1z9mFyxyVpfPDuuFemP4QcbFZY/vQK4RBoVjmVddNgHNhMBa4MjGGlCdCCrpfLHS+kLWc3LNIutEpc/sFFQhMYBxSlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GRx4M8LQ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GRx4M8LQ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45deccb2c1eso15535905e9.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 02:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757497509; x=1758102309; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c1kBDy0sA3BYfIdWlr+hjUo0vDal9CsK0/fCdjzti6o=;
        b=GRx4M8LQs7TBj7cAR7Bl3w2braUPvSSPjxgmjI54SVjqCjqsxrQBPQuqfj2Ma1Q9FE
         LjNiHS1QPthAJh4fax9XPfAcbZutRvSGUdGkO4r8/DX24bGVKSufLw0pGQkxbp+lrLoW
         q+zfZtCnw8Hg+SkpAoB1BeQOf4D+xNooifeD0UyPkh+kbcFXlnyCP4nMjAqVB4hS2tOc
         zE8pq589VWXgdYg20HIUTRu3V0Z/QaowlrBxfEoyYk+iiQRawOGf/+5XDlOk+NrVCwr2
         pFS/zlDF2uoGaUNg6EZ0Abo0/hOfeJs41CyyTdtwKIEYbOjoREo5N55OFdl4AeJf7OPc
         bDrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757497509; x=1758102309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c1kBDy0sA3BYfIdWlr+hjUo0vDal9CsK0/fCdjzti6o=;
        b=eWP72R4oc6xUI4zjD7QCBTR6b0s3AeOYtv7676/4xF/EuF+S1E8OySpTSIkKx9fkB3
         N6DjiAPcfQ1b8kqA1pZ8oP8VNFUW8CvlLicRrGnKH3W/b3GuXW3Cbz6nShZExmXb67o9
         LNvFvPN8ZLxGlkw5dbLD6IzIuvfoe+37JEjVIpxe7b+Jwv2yALCPtu4IL3pIHaT/UB4L
         C/tub3Z/cphTDA/bRuU+oXGUP49qqWFFwnePwlu/6MHMmKnx27ha6irumPu2dwOKhtmF
         xhtvv4q407yzikOKRQdtEVHt64c5CMwPkdqyu6670nov5RB18N1NbknOCQ04OGfyWe2G
         TZzA==
X-Forwarded-Encrypted: i=1; AJvYcCUQOD4jcuJK/THweX3PGc8K2A81hJwj34V0Bw4J/+J4/gMiM9BdnO7Avm4AC0cMaz3o2o6fiUA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoVItXNXlTAZVkp86gJ/jtLaEovhsjuxH7XhusVfeElYaH53rk
	/Sw4miUud4Jhy5oNv7qmgtQd80jOg2w9lgIr35V9DoICRKIcbTv2RvLsnlHupJP4mw==
X-Gm-Gg: ASbGnctuqORVB971bIV2cL1LUtYJj8yVUW4vJhkIRtc3hccnkwyjbim45gJSqw3jMKr
	hddBl8Ww+KkJO5lUJt7LmEVOWu8HETp//Kk5ZoLrmqOqHF1EhyGP1dtP/j+MJuumjynma/27NBs
	/FH/Mw8P/hq5494JraVaXZP3WJvWlwAvYYxKUiy4oNQyjFDUt4zBaR+0Fq/hGf8L0756nDo9e2Y
	rNEJleL1TgckrEzdNT0DMtuuilXch0QUFI5MF313fRMKpLc2MXFrAQVk/QjmcO85mTUK1NUVNM1
	OkTeI9IgBDI3fJz293lsj+ZIebmt4BxSfOfBBZmTadU3ShAZPvdIc57cMICNaINE1DMPYAoTKm8
	FlPEpb9Xr4SYbaJoFgfuTKSkY1HWK05gjPtzgDWx/fIirYyaMEW0KvVf0Y6uje3dHD5OFZ+ycT0
	xwT6N8
X-Google-Smtp-Source: AGHT+IENXjSZ9eYxIcTPb1KA8MslU7Gkmmzo6eN91GvxyARG/yRPq8gJbKV+SVFiPMHX+dA+S+OktA==
X-Received: by 2002:a05:600c:3b1d:b0:45d:84ca:8a7 with SMTP id 5b1f17b1804b1-45dddeba3e5mr124414255e9.14.1757497509275;
        Wed, 10 Sep 2025 02:45:09 -0700 (PDT)
Received: from google.com (211.29.195.35.bc.googleusercontent.com. [35.195.29.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7532f90e6sm5750475f8f.6.2025.09.10.02.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 02:45:08 -0700 (PDT)
Date: Wed, 10 Sep 2025 10:45:05 +0100
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
Message-ID: <aMFIoY5yfQa2Mzgk@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
 <20250821081412.1008261-5-vdonnefort@google.com>
 <20250908193757.079aae76@gandalf.local.home>
 <aMAZMaZJ1_Eny5Ku@google.com>
 <20250909094028.3265b751@gandalf.local.home>
 <aMBSa29ev0BNgr5R@google.com>
 <20250909143948.420bfb1c@gandalf.local.home>
 <20250909145236.69192cd0@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909145236.69192cd0@gandalf.local.home>

On Tue, Sep 09, 2025 at 02:52:36PM -0400, Steven Rostedt wrote:
> On Tue, 9 Sep 2025 14:39:48 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > But anyway, I think it should work for the remote buffers too. Let me go
> > and fix the current iterator.
> 
> I thought it was broken but it isn't ;-) I did it properly, I just didn't
> look deep enough.
> 
> So yeah, look at the rb_iter_head_event() code. The ring buffer iterator
> has a copy of the event. It has:
> 
> 	if ((iter->head + length) > commit || length > iter->event_size)
> 		/* Writer corrupted the read? */
> 		goto reset;
> 
> 	memcpy(iter->event, event, length);
> 	/*
> 	 * If the page stamp is still the same after this rmb() then the
> 	 * event was safely copied without the writer entering the page.
> 	 */
> 	smp_rmb();
> 
> 	/* Make sure the page didn't change since we read this */
> 	if (iter->page_stamp != iter_head_page->page->time_stamp ||
> 	    commit > rb_page_commit(iter_head_page))
> 		goto reset;
> 
> It first checks before copying that the data it's about to copy hasn't been
> touched by the writer.
> 
> It then copies the event into the iter->event temp buffer.
> 
> Then it checks again that the data hasn't been touched. If it has, then
> consider the data corrupt and end the iteration. This is how the "trace"
> file works. I believe you could do the same for the remote code.
> 
> If we are gonna keep the "trace" file, let's make sure it's fully
> implemented.

I was more worry about the ring-buffer page order that can be reshuffled on each
swap_reader_page(), making the page links useless in the kernel. Ideally, the
meta-page would keep the page ID order somewhere.

Alternatively, we could walk all the buffer pages to read the timestamp and
re-create the order but that sounds quite cumbersome.

> 
> -- Steve
