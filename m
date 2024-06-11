Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E4E1411ED
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 20:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718138389; cv=none; b=hA637JLJHm4CwvJVYhiTZOZtPft0g1pX9UzeWhT8XmzNvPUmX0f0Y4q073JNk2UvQb9AKmqbjSldkDKcsreeVDrI1BuRsqi57Sq0mtSmwmC7Pj76QfKGYb43Y5/+pkVkhk8WfA5ZhihNm//wWk9BbfR8vzqoyVQkwe8XxkpMVxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718138389; c=relaxed/simple;
	bh=Uwv7P+rpbL3D4lWasBXzA1FdWhb0FlRL25Aj/PT5ky8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RVfU/tGl9Bs65nkhaYxGXUxsxhjzmDDtnlGRbnMHG+WcXYCGjwVtF7iwAxN8SFUhjpmUZxViZXE+V1Vv/4eTU6Biiz20H/sJ/w1s9CACXhMkvjS8Wv+jFEKDP84flTjhZhfLEBK4fKpJu5u4akTson5v/rHJ1fnaLbWySWzNSM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=25FPgfVI; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="25FPgfVI"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42171fa0a32so23085e9.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 13:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718138386; x=1718743186; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uwv7P+rpbL3D4lWasBXzA1FdWhb0FlRL25Aj/PT5ky8=;
        b=25FPgfVIgQdzr/rA3V4/fegC0lMQGJ/A9tkaNQ+YFGhDdRV6ZDCDW8b46ssYlTpPUm
         KK7l8JHiO0RV35r4s19V+cJs+gjYvDVO19oPUn6AovI+xpqUqaI3wATbz173g6FjbXr7
         lUdMb6hYl8tZZjG8tiiPFsKgvegAqQTqSLzti//Rt+jMuf7co0uEGtCWPdmUjlr2TCeS
         UmpgjSBJYthowQlO2Bh8V0N/0M8tDr8G/PC4IBdN96acoTJX+qGMXey5O5UXIL5E1ajE
         VYx7E2Qtg80pKmxMy9tnOtASdQHzs4f022iZV5WnED4NwyKyoNMBSPnUpFk1C0zjfTeL
         G7dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718138386; x=1718743186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uwv7P+rpbL3D4lWasBXzA1FdWhb0FlRL25Aj/PT5ky8=;
        b=aFfTwBbckAH1Nw/o2NDOy0qVpJBI75pn6S4Q+I4pv+Mqt4pIBbYYizqJQSnXCXXLxy
         xl9qvfLLTxWaK/ZlCrPS6jw5M5Xv5kU0QxeISPJDbCtzJgjg4nqPUhfxYSN43Wfx/jeZ
         l45QzKYpuzpRpXi/Dlv/MuwCucDs0v6XlH9kVPwsFqvRLGhkicWwLsR89lNV549lEhEx
         +3TDzYakKZv0PClGxSGM73yORL9zphDpahVMGRA6cPN14mz63INRUWlKxiUNw/cdvsvj
         1GVJ5vcri9tHUNKiY9jMWAKAsBlbtfqoBfva3GpToRunqRyqkmSXygP+UIfbtk+Mqa4O
         8GHA==
X-Forwarded-Encrypted: i=1; AJvYcCUlidhn3t1lIRD3Gx2gSul7iBQ/elZis27chKcKqCN1rVSCJ2Im8sgSkoNJaCebQCiVr0nhd368mnm+Qvgy9j19CjRam8p2
X-Gm-Message-State: AOJu0YwHfQ2BfPIL7F802733FwrEoDEHGBSHjngkNoWcXvyDfyc6hRgF
	K2QP+6zwcd46cRqZhBvLsAfQBd4TQcE9szsfbGfCN/hHNsJu6G/yPAxAYKv2xEYBv9OuTqGPiFQ
	05mbhxkMe5QGdrE0F1MVCBEYQyaMhhIRRHK56
X-Google-Smtp-Source: AGHT+IH+CbdX5Jd916IabrKfbqeWvGCL7LL9WXw1sJsxc+uDAViKu6aEHqBlAMyLtMyJTX4kNPtqpJKHeoLv1yDsgn0=
X-Received: by 2002:a05:600c:3d0a:b0:41a:444b:e1d9 with SMTP id
 5b1f17b1804b1-42281b927b6mr453365e9.4.1718138385453; Tue, 11 Jun 2024
 13:39:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
In-Reply-To: <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
From: Yu Zhao <yuzhao@google.com>
Date: Tue, 11 Jun 2024 14:39:07 -0600
Message-ID: <CAOUHufbRhAXXNtvGaYiGM2jkhGAeiFR7n0kSUZJ3ixQen=d4LQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024 at 10:50=E2=80=AFAM James Houghton <jthoughton@google.=
com> wrote:
>
> On Mon, Jun 10, 2024 at 10:34=E2=80=AFPM Yu Zhao <yuzhao@google.com> wrot=
e:
> >
> > On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@goog=
le.com> wrote:
> > >
> > > This new notifier is for multi-gen LRU specifically
> >
> > Let me call it out before others do: we can't be this self-serving.
> >
> > > as it wants to be
> > > able to get and clear age information from secondary MMUs only if it =
can
> > > be done "fast".
> > >
> > > By having this notifier specifically created for MGLRU, what "fast"
> > > means comes down to what is "fast" enough to improve MGLRU's ability =
to
> > > reclaim most of the time.
> > >
> > > Signed-off-by: James Houghton <jthoughton@google.com>
> >
> > If we'd like this to pass other MM reviewers, especially the MMU
> > notifier maintainers, we'd need to design a generic API that can
> > benefit all the *existing* users: idle page tracking [1], DAMON [2]
> > and MGLRU.
> >
> > Also I personally prefer to extend the existing callbacks by adding
> > new parameters, and on top of that, I'd try to consolidate the
> > existing callbacks -- it'd be less of a hard sell if my changes result
> > in less code, not more.
> >
> > (v2 did all these, btw.)
>
> I think consolidating the callbacks is cleanest, like you had it in
> v2. I really wasn't sure about this change honestly, but it was my
> attempt to incorporate feedback like this[3] from v4. I'll consolidate
> the callbacks like you had in v2.

Only if you think updating the MMU notifier API is overall the best option.

As I said earlier, I don't mind not doing the extra work, i.e., the
bitmap/_fast_only parameters and the _FAST_YOUNG return value, as long
as we know where we win and lose, i.e., simplicity and regressions. I
would call all the potential regressions (the nested VM case, the
arm64 case and the memcached benchmark) minor, compared with what we
got from v2. But my opinion doesn't really matter much because I'm not
your customer :)
