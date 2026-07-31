Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B267436D9E7
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 21:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534206; cv=none; b=aV100y2YGNjkEMJb8zC6ywMQklO7+GV00fRY/gqz3mmqJcak8LeO75iKdhbZ+tddJJCgDp1nLBnScMQwG8eYr4LofUGt0AOun3225llQhVEDbSWceXqK4DulD97Dfc7WJgNl0dxMFOlQPIt657Wjnp41gSElp3r2FbVWkZ8txGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534206; c=relaxed/simple;
	bh=nzrToUxADQg3ISbTQ57EyAk3zEt54JaUbcb/JjsNdNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MI1/X6fbUz00bXAlvB2PIwVf5e//ZEebQo5a8zKs6KnL8GzHx0mqB5xCtp8TL+fPR3qr9uSxRlc938Kstu9En2HuYOT7F3qKkqsTf7g6gAfLCYH/U5zZr5wFVnPPPeYdHAdWN6t5fg2HlAVVbQm9eVSox9E3a2nHDZ0TIh6rRrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X4fN3hI0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4fN3hI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBA31F01560
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 21:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785534205;
	bh=Ijj4vdGluIomNxLmquFU6pFVXzJ7ScyjET2Aj3N8QSA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X4fN3hI0eISr4yL7s8jIga4xCyftseWBmBZzcaOoyYE5MbI29mtKq1/FILmpMlhcV
	 nH22vmKiUBCmGokVAYhvZjvWdUwEGuIEwVneCx849AX36zIuEY7W91cTz80KEEMS24
	 JaMLR0QsJaqTiOt4jDKbfmJox7wnK7MseTB2MhfxHu+QnH79//4ITl58reAMYxSUs2
	 QXFBklaEIdF5Ge8MnDHBVggpqeGUMSbN9DHNNINEAl8axXBDYOUEQ28xKT4oKDQ3NO
	 v8V/rNrAZCwfU3yi7FcfyKnLAR/gjT+EyoGkuTbJ2ICQo+DBzFZnSJcY8AME6ve0To
	 jnhpsje7PEptw==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c167bda216fso216903366b.2
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:43:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqDpq7w04LZNkPzpw5w75MfQYLCJ566mC5/mbjrmmF7E29J7ecrPA6aJeE+00x4Luw6si7f6k0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLQjYuakRkgBpvOTsBowLayIRV9ClGhtCUyo+aexfwZBIOgYRT
	cj4uM6Y4YU32jS5sGWRVFrRCvkd2mxqMKgEHYKIBbfm6RA1ciowpiACXN3J9aP9KjHdQhBwzwtU
	i/n8K3u8JZhxi8TXzh66bGbM+0p8l2j8=
X-Received: by 2002:a17:907:5c7:b0:c16:9bd:39cb with SMTP id
 a640c23a62f3a-c1fe83c9c78mr65074866b.52.1785534204316; Fri, 31 Jul 2026
 14:43:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com> <CAO9r8zO-eCz-4Gpa_FUjRKPaDj82PP7et7KON4S5QfhRU2J-Ug@mail.gmail.com>
 <am0Wkak_vhy1n_xu@google.com>
In-Reply-To: <am0Wkak_vhy1n_xu@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 31 Jul 2026 14:43:12 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNmjinr53exDSwVKooosz1w2=4qexRF88u21AFwUpfFJQ@mail.gmail.com>
X-Gm-Features: AUfX_mxmaz6udCEjo0Ly-CUEkoOgpG40UmqWTnodi_oXGgnlaAp6cc87pxxAuL4
Message-ID: <CAO9r8zNmjinr53exDSwVKooosz1w2=4qexRF88u21AFwUpfFJQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] KVM: selftests: Add more syscall wrappers, fix hardware_disable_test
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	David Hildenbrand <david@kernel.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 2:41=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jul 31, 2026, Yosry Ahmed wrote:
> > On Fri, Jul 31, 2026 at 12:56=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > Third time's a charm.  Sorry for the spam.
> > >
> > > Buried in the middle of this is a fix for the hardware_disable_test w=
here
> > > it can end up with a runtime of multiple minutes when running a preem=
ptible
> > > kernels on a large NUMA system.  Turns out my analysis/guess in v1 wa=
s wrong;
> > > the problem isn't direct CPU contention, it's that letting the worker=
s do any
> > > amount of "real" work on any CPUs leads to pthread_create() slowdowns=
 from
> > > the perspective of the caller.
> >
> > How long does the test take to run with this series?
>
> Less than 5 seconds if nothing else is running.  ~12 seconds if I run it
> concurrently with mmu_stress_test using default settings, and ~25 seconds=
 if I
> run it on an overloaded system (naively running all selftests in parallel=
).

Cool, I will stop skipping it after this series lands then :)
