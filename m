Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DE6168B1
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 04:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712030857; cv=none; b=L3cze71ey15AtBOv45tsaRJ1pOF5uQo9+K5EooYZKgqnTY4j54BWfgfs+jJa0WCPtE+IELl2kexpvhSJsvsMt20OVvP/rSaQR05KDKJaxuukHF/hFgVSqIjngsJ+2JQ8XbaQVXjJ+tuyzpmQnOehHT45l+11QVT/yFsQkzdQDOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712030857; c=relaxed/simple;
	bh=S5pOtFaXWTZ9drUl1IGdeRTY03Dh2DX28whh4K9thQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aX6FhHmNayLLckWE1bdnJByDwXSlfty3tD/VaPvhe313qmZYFOfmERSgYhFdahvvKXy3OglKKiQTXXoBV0sd4b0NuDvpdp21h4nR6uwjGBIahnC5on1SU9nNKHhBZz9w0uOTr5D93SNFhtDsTpFFv1Hw5qExEbmvEpGZfQEIBg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2epidrYW; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2epidrYW"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4154d38ce9dso246445e9.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Apr 2024 21:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712030854; x=1712635654; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZBWjXNV+ukFYBM6SnOc07suCYCDWH2HqRzY2rUjBLg=;
        b=2epidrYWhdD6tgoDlQDabbs736Y6ngqbnCvjKUck30qG9y3QU6wtOQNjF02v3qnHma
         jFA6WC5BGNRX3aGcixI6PGzP83Yk/D9fjNz3PGC49qrhZH7kkWcLOVQDyYNPV3KqYhWB
         NidU1kDZ91e1wKearBVxOtXE21HzQoYfaCG9bvvllT4KgXK2USu2O56i3rQ1t0nPeuZA
         4S/g688uzA0Gmb1fUgju8J/dWcd91f3G1eZGvsuFgnjG+/EgkNQsu1Q2q1Vyq0q5mkHZ
         jz1g//pfsfvqOmXCisV7Y0subSwBQPyK9XjiLwzkh5wCSLAiaSUnbB9I4DuuDNqsJ2FX
         9SKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712030854; x=1712635654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DZBWjXNV+ukFYBM6SnOc07suCYCDWH2HqRzY2rUjBLg=;
        b=HzzAc3ZrP7MkknUhHhzWbN94BnMgdEixw41ihClpBtKj8wNeEsQvrfXxPq0qAJH7lM
         qIGQoGHpXA5CgizE3PvKgGF0j5HWXDaBacF7E6LlsGGNINPQT+4M1jm2JdDsaeW4AL4z
         UxpxAH8vY9e+Qg3/dt+l8Z9TwtuYxG9XY536muacpNgO6v6IrpmdWlXnQHm7SchbKwK0
         o3Z7F545WP2iBqxYt3XV2sM8AEaEGeieLmBYRk+HKQg3VevchEd9u+qmEN0fk63DlnqI
         p0fiFhTkqdxdvOkZGWT0hE2JWuxChXnEvygDHY2iveoCernYEB7SJ/i4elCTIHLl/5DO
         87jw==
X-Forwarded-Encrypted: i=1; AJvYcCVXKux71lB/XsMyOEuLFjdCD7jMYn/VT2dHlrAQb8AO2YXfItQf5Hpv1LCaK+5fBwEP9yCLPAHu5tyxirU/pUF2m7nYuFAH
X-Gm-Message-State: AOJu0YweusmQ3vZGjMjuhF+rdt14v/SrO3suDYOhilMrC6oS4Pddchlo
	ETo3GFHky7GedqGxnxCoVU3xW9cTDCdMjwBfxnE/o0MWd107V+yKpW2YWYGFoOgltdQ7tZXGsQp
	emhqXnDlv5lUOBOxxZM0RAnv5CyokP6CPtIFt
X-Google-Smtp-Source: AGHT+IFySGf8Ru8vCkM5wQVTeOgNnN+X2acwQrfk019Ub2hqyb57NNeXzO4CL4BJZpMyCPNeydNs/OxpDN34ONprOII=
X-Received: by 2002:a05:600c:358d:b0:414:1ee:f375 with SMTP id
 p13-20020a05600c358d00b0041401eef375mr713615wmq.0.1712030854163; Mon, 01 Apr
 2024 21:07:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com> <20240401232946.1837665-7-jthoughton@google.com>
In-Reply-To: <20240401232946.1837665-7-jthoughton@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Tue, 2 Apr 2024 00:06:56 -0400
Message-ID: <CAOUHufaQ-g6L5roB-3K0GamuS3p9ACpPj9XM-NF67GgrjoTj_A@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] KVM: arm64: Participate in bitmap-based PTE aging
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 1, 2024 at 7:30=E2=80=AFPM James Houghton <jthoughton@google.co=
m> wrote:
>
> Participate in bitmap-based aging while grabbing the KVM MMU lock for
> reading. Ideally we wouldn't need to grab this lock at all, but that
> would require a more intrustive and risky change.
                       ^^^^^^^^^^ intrusive
This sounds subjective -- I'd just present the challenges and let
reviewers make their own judgements.

> Also pass
> KVM_PGTABLE_WALK_SHARED, as this software walker is safe to run in
> parallel with other walkers.
>
> It is safe only to grab the KVM MMU lock for reading as the kvm_pgtable
> is destroyed while holding the lock for writing, and freeing of the page
> table pages is either done while holding the MMU lock for writing or
> after an RCU grace period.
>
> When mkold =3D=3D false, record the young pages in the passed-in bitmap.
>
> When mkold =3D=3D true, only age the pages that need aging according to t=
he
> passed-in bitmap.
>
> Suggested-by: Yu Zhao <yuzhao@google.com>

Thanks but I did not suggest this.

What I have in v2 is RCU based. I hope Oliver or someone else can help
make that work. Otherwise we can just drop this for now and revisit
later.

(I have no problems with this patch if the Arm folks think the
RCU-based version doesn't have a good ROI.)
