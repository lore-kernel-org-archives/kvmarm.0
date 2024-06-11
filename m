Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83733171648
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 05:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718084056; cv=none; b=ouDRaHG0MED1abqg0j1A95Gs1rvuhkLf7q9BeFEE2ZDM88xBDPGUIfvlhMTIYSM3ArVTLCBm5yEvSVthU51IQDxGCX9qDTGK7FpvPa7Cd65kxc02/Gi5ejeSTRFjm5SKVpwl3/Mcy08O0/ArQMYWhuqpKhUgig1g6SShTPt2ofs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718084056; c=relaxed/simple;
	bh=fR3uqfswqgPixvWJU+uzJF8SnpIWyc4DS1G+kRb9LI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=boQ/GaOsEG7SpycY7GqnkwETCf5g39IQQFPrm8eVciKWgZ1vTAlU2dHZtGBr8qHg7vKYRCe0WCpl1yI42OCKvAO+ieTIYjeYcTRG74zU2t4xgOSmB5sfHu0id7tyiaun/CVJT99JpwRB4FpZkaR1c0+a60fxcW72ZK4yzAp6oVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NjWclLCz; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NjWclLCz"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42175bce556so24705e9.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 22:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718084052; x=1718688852; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fR3uqfswqgPixvWJU+uzJF8SnpIWyc4DS1G+kRb9LI0=;
        b=NjWclLCzQFciemXjWmQhCknhMBz9gfkJ19GHi7CCl34vIEAYXg1EpHIIjZ/wHFZA1z
         uKNAY9le3pppvndjdCgTHCKnrq6NmOJzAI6IqF9CJpn+UAHmIATt0ESb8dou2e3twsgg
         FJxjzlbpZvlWq9CTf4uOGmzDmq56EA0dZh20vV3u7/4rbuBNRAAN2fj/ydr/WY0rNCrw
         NFaT/jQ0GZTQn19/kw0V1R/HDk1hvnIfhab+XIbY2c1Pg1dWh/iPXVvwfi+Bm9/zVm+i
         VMVoRM9dw9vDWFYk9b36tGar8F/+Vfm7AKuD1vm2yAeWigzYa8EiwP4JpHTKbSO/x0sn
         4iVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718084052; x=1718688852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fR3uqfswqgPixvWJU+uzJF8SnpIWyc4DS1G+kRb9LI0=;
        b=a86o1vuIKvNgLMBIcbCvzaysQDMrhQMUQwGFfgmM/Y1UjL4FczKZ8hPObcf4Q5xheQ
         0FAkiMn/hm9e4SWsezg2Xc5VPKdFcPqkIzV45IGSuRSlhPhQ+J1xCqEVNtEbhaCHpOZ+
         gLUCcWWdr0DZyWvQS97FymEK67r6tfq/WlhP8wX5sFP7NSWZxthnQ6U1VEIzJVE210ss
         ZzQ8OuIOxN3h+N2SsT3Vff7bsgePhjwrwMbWuH5ZQy0VTB/U05XmJ2erdO+bkifhAizg
         qMxiBmzOrAD/M7F+dArVTr4jWfamIYtjsqFHOiGwq9LrX1MeIZ8R5ViEkZCh+VBQvLO2
         rPiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxX37Gj8EI1j55jzHislcA6l0vNYX9593Z4TJ+CFZjkemAoDvak7ckBKWq9PXudBSBDhceQ6JXVGy+aOCoxUopxwFrcsVC
X-Gm-Message-State: AOJu0YzNyCbOa1JHW/eo4J2M/C40vVQmmD3UuejniUVu4BWU2O7wIpqJ
	Pn+JLD21KiKzq7nZAni/1tirWvhTCj347gyDBUe3UZ70YWOLqYv4rQj/C5dbng/dPI86N8sDlRL
	B/2b7I1hllERnrXVvn5BG3X+dJbEHBqGrKlAO
X-Google-Smtp-Source: AGHT+IHhYq94AypC29YgE3hVmYacjlUkNo/Qo9+rQA77kfA5hlq20npia7gDojAiEDcXg8++4JZWIpCmeIjETKxk4OA=
X-Received: by 2002:a05:600c:4e49:b0:41c:ab7:f9af with SMTP id
 5b1f17b1804b1-42251e64c22mr651355e9.3.1718084051642; Mon, 10 Jun 2024
 22:34:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com> <20240611002145.2078921-5-jthoughton@google.com>
In-Reply-To: <20240611002145.2078921-5-jthoughton@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Mon, 10 Jun 2024 23:33:34 -0600
Message-ID: <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
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

On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> This new notifier is for multi-gen LRU specifically

Let me call it out before others do: we can't be this self-serving.

> as it wants to be
> able to get and clear age information from secondary MMUs only if it can
> be done "fast".
>
> By having this notifier specifically created for MGLRU, what "fast"
> means comes down to what is "fast" enough to improve MGLRU's ability to
> reclaim most of the time.
>
> Signed-off-by: James Houghton <jthoughton@google.com>

If we'd like this to pass other MM reviewers, especially the MMU
notifier maintainers, we'd need to design a generic API that can
benefit all the *existing* users: idle page tracking [1], DAMON [2]
and MGLRU.

Also I personally prefer to extend the existing callbacks by adding
new parameters, and on top of that, I'd try to consolidate the
existing callbacks -- it'd be less of a hard sell if my changes result
in less code, not more.

(v2 did all these, btw.)

[1] https://docs.kernel.org/admin-guide/mm/idle_page_tracking.html
[2] https://www.kernel.org/doc/html/latest/mm/damon/index.html
