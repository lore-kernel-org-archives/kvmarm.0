Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04332FDEDB
	for <kvmarm@lists.linux.dev>; Mon,  5 May 2025 23:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487570; cv=none; b=KTVdrKarldNHelCEB7smMk+hRC6jnAIvzl2+ZZRHO4FwMK9nm77YPeUiFp9kx6tOxKUYFLUCYaSM7eKuOBETHO8BuFVvP8cgaJu4Eo6E3P7Ll8OzSHpWuLS4iubzOA8lsS25Hv2F4B37WuZJ+8oqDhKCSG4K14oKaaNclHWqIfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487570; c=relaxed/simple;
	bh=67P+5bX4ZawhTisUQZfcMBazv8K4XrXqC8MXBSwhID8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KdW+kXjhMi6XkM5H6Hy2XR6zbtVK9piAW/dszAFgVTQjtD1kV4WalMy6LtW6MPM2xMyJRSJBaEZk8uTgJe6ZBkQV5cbdZ9e3d07PoALzdzIIfKbjKW2ujDBgNj8eDmcfjb1vUVhWZWQMqJLEyUXaNfVKdg4xt2Rs+rJDYctq+HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SvbeP95d; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SvbeP95d"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7395095a505so3443223b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 05 May 2025 16:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746487568; x=1747092368; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W4cNJ7zUGr7tO+W7VEbJ8gglNZQhXjP3xsTkrEaO8DE=;
        b=SvbeP95dzJ48BuJKP6oxAXSfzFXyqFY4bqUThvdHrVRsl9XQ5DdRiTdxC+oYD218dw
         kNBcl2mNnkf4ycxAdy/WL/PJaY2lke3EhpBs/joBiLibwABHoP/IGPef28yS4xqsBlg2
         0dfKkuNWOrgcUmeMfFJw6LumO+YjOYTq58+Dw5SI1RKRGSSOwuJoBz5Jfgzqssxs51J1
         G3XYc49HD2qmFOaJYev1BwIVbHOxeZHzFqzHhzWQlCb7jZ75W+Ov53qHV1ANvcfbWtif
         wal45+t3OMT4yRTIB9njZk3ER3brXz9g0tjVB0lF8i3TDFrnUiZrEZ+9wLR3voDFv4SR
         pe3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487568; x=1747092368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W4cNJ7zUGr7tO+W7VEbJ8gglNZQhXjP3xsTkrEaO8DE=;
        b=Ou6NHGN/DjOCOyVs9DEs1AfSu+3MA/jLBXCXYajj+vpqoUn0LDBbDlJUIeuzNvubOQ
         zIzoOqCupT/THJ1SIGKEqBOMPbM4zBIKbe2aP7o0rz3ICz13A/IUfnh8Di5WT3YlTwXN
         am7HZNQl1DyWctG36qC0nOPBuDUjyd4BJ7C7hDc174AG4qmJOu45uXemMtnZsSnR+5pZ
         eZ91wNY9Nh/E3b6DU/oGHcAs679sqorWcd9D1/x7Z/mHi7UZsL3Pha8QIEsvDNVYN6k4
         4GcWe0i9nuwUn4R5IeaClX3Y9VwkA38rJNX1bk0EiicAJXcRz5Q5ofBXQysblo7OWzzG
         KzFg==
X-Forwarded-Encrypted: i=1; AJvYcCVWjyLhFOhU0rWyzjwZ0+W3srsJbgTC/pYc3lJltOQXOyBK/35HeSbjzrWv38vTIDR7J7lG2vA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCcxrYlMMSN7zhTemrx0kCuZmLjATDndnHs41rsgiBZdDCs1Hr
	+/i4UdvpK6I6O6iUbkuDRVimUpAZ9IihWyXR6C1cGtwUBgPORp2o0VAppmXONCHtmRZ3fz86/o6
	tfw==
X-Google-Smtp-Source: AGHT+IFs82iZrMFUBe/Um77R6mZCtOyNM2zzn8fFKGEUvfFdFbOehTmWdf7D5nF7WYhoGzjYDtAoO24FpnA=
X-Received: from pfoc5.prod.google.com ([2002:aa7:8805:0:b0:73c:6d5:ce4c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:600d:b0:736:2d84:74da
 with SMTP id d2e1a72fcca58-740919e16d9mr1113768b3a.10.1746487567641; Mon, 05
 May 2025 16:26:07 -0700 (PDT)
Date: Mon, 5 May 2025 16:26:06 -0700
In-Reply-To: <20250505194836.GB1168139.vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250222005943.3348627-1-vipinsh@google.com> <20250222005943.3348627-3-vipinsh@google.com>
 <aBKWmRDBrjeZhAW0@google.com> <20250505194836.GB1168139.vipinsh@google.com>
Message-ID: <aBlJDjBe3LXT8mbK@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Create KVM selftest runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, May 05, 2025, Vipin Sharma wrote:
> On 2025-04-30 14:31:05, Sean Christopherson wrote:
> > Printing the timestamps to the console isn't terrible interesting, and IMO isn't
> > at all worth the noise.
> > 
> > The PID is nice, but it needs to be printed _before_ the test finishes, and it
> > needs to track the PID of the test.  If getting that working is non-trivial,
> > definitely punt it for the initial commit.
> > 
> > And presumably INFO is the level of logging.  That needs to go.
> > 
> 
> Instead of removing timestamp, I can just print HH:MM:SS, I think it
> provides value in seeing how fast runner and tests are executing.

I can probably live with that. :-)

> > I think we should also provide controls for the verbosity of the output.  E.g. to
> > skip printing tests that pass entirely.  My vote would be for a collection of
> > boolean knobs, i.e. not a log_level or whatever, because inevitably we'll end up
> > with output that isn't strictly "increasing".
> > 
> > Adding a param to disable printing of passed tests is presumably trivial, so maybe
> > do that for the initial commit, and then we can work on the fancier stuff?
> 
> You mean some command line options like:
> 	testrunner --print-passed --print-failed
> 	testrunner --print-skipped
> 	testrunner --print-timeouts
> 	testrunner --quiet

Ya, something like that.

> I can provide few options in the first commit, and then later we can
> extend it based on usages.

+1 

> > A not-quite-mandatory, but very-nice-to-have feature would be the ability to
> > display which tests Passed/Failed/Skipped/Timed Out/Incomplete, with command line
> > knobs for each.  My vote is for everything but Passed on-by-default, though it's
> > easy enough to put a light wrapper around this (which I'll do no matter what), so
> > my preference for the default doesn't matter all that much.
> > 
> > That could tie into the above idea of grabbing keys to print such information on-demand.
> > 
> 
> This will be very involved feature, lets punt it to a later versions, if
> needed.

Sounds good.

> > The runner should have an (on-by-default?) option to abort if the output directory
> > already exists, e.g. so that users don't clobber previous runs.  And/or an option
> > to append a timestamp, e.g. $result.yyyy.mm.dd.MM.SS, so that all users don't end
> > up writing the same wrapper to generate a timestamp.
> > 
> > Having a no-timestamp + overwrite mode is also useful, e.g. when I'm running in
> > a more "interactive" mode where I'm doing initial testing of something, and I
> > don't care about
> > 
> 
> We can provide user an option like:
> 	testrunner --output result_TIME
> 
> then internally runner will replace TIME with the current time?

Why overload --output and then have to do more parsing?  I assume adding options
is easy, so presumably --append-timestamp would be just as easy to add.

> If user doesn't provide _TIME then we can overwrite the directory
> provided.

I don't see any reason to tie those two together.  Again, on the assumption that
adding options is mechaincally easy, I'd much rather have --overwrite or whatever.

In general, so long as it doesn't meaningfully increase complexity, make the
interface as flexible as possible so that the runner has a decent chance of being
able to handle whatever use cases people come up with, without needing constant
tweaking and churn.
