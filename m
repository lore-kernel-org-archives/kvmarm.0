Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAEB224B0D
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 17:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765301837; cv=none; b=mc4Y3ODYEQ3+rDgjpPQf71qzOJQ85fyeRcN7LbLbg+pd/dGMUgNh4AI53x835qETAi8yifhdmdpTerI+rc+SOhp+1JlhZD0TUkV0JfOwaBMQgca6H3gMfm0LVQtELT+X/xXuVHCitc2mI0aEYWRrRPkjdVUujVEST7+kcnbIn4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765301837; c=relaxed/simple;
	bh=HizTlmZQbI6tmGG3q1gw6CHs59oQallkQuLPYHyLpHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hKSQQD6PvAZtwYrG2u/Hj2RT+29n6VyaTAyfm8qenEZvKKcVIcpVygvCtheMgX3J7H1H774wByiSFqm02iJOVUQagc0bkbl3TU+38LuMRJWwALFbYBXvMkSonDLmTnZXVt5l5woDTes38PqyTOZxeFilVldEMWV7iqk1Rk01ZYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pl6u2y27; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pl6u2y27"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3437f0760daso11280204a91.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 09:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765301835; x=1765906635; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RSI8Pxf1Wt9ews+8G0JZ3VLNAwMte4kHmIud1VFkk60=;
        b=Pl6u2y27+WkjJNXaGpLz8jvygoVd9Fj5Pjd1cSU7O3ntD3ZdVa0ULP18NvYsTd15By
         E7OHYVcrjegbXbFoY5+2T/4ztqSBNhy1txK0UwECAhf9SCVGqVY1yfPTc85oyptpM1qJ
         cTTP2Z/VMKKA+EtT7aLLg8Tz4GT1ltIDS7u4ErbdSxRiesSS8KYPfIImx9CpWcztO1wI
         iWoSgQ37cau4vhFkTodQB6LBLm2jY0Q8He2PNwgaSUyZYFOyUCDfItF0N+r14YIN0Eff
         nzP8I+3XPfdxlGCb1Cqdk419pRyCmjotE4chYELi+4Q0f63EQWkI1Aw9kLqFLGBs4RUH
         UFlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765301835; x=1765906635;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RSI8Pxf1Wt9ews+8G0JZ3VLNAwMte4kHmIud1VFkk60=;
        b=pVHdNhkiFwxFf0XTcTo1lL6vMOIDCDivdG3wstIz/4HluV/9Zrwzxjp1+DYAUBwxsh
         RXmUnaQzJ721ZqnHP3+zIo00KnVc1QTDQP6fUgp9ZpBU08uOSYFtbZ7WxJA3EXTlzk9o
         3QvCbNhCYOia9g7vhd++IxOl2exnB1zrbd2Zmp0vIOUrDicwNNSe34Jd4q+zhLnYQUS8
         4+ME890CkIVYKSM2R8svZYKsnrTrAOCEnU0QomZV2ZzeT6IzCImBc+J6wXRIyQ+vvs/G
         M+Ezo2/ttToEE5vhqHtiJnjq6GKiVvnJZaR1uUempjwI9s8B4g38e8Up7jAA9JO1hyBg
         7rbA==
X-Forwarded-Encrypted: i=1; AJvYcCUDTvqBPNcwREQcY0t2LngqwdRg26dFth03TacblWoyAKCDfoAZaEMekmXalTU+J3SpE0na0IM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0EYi0yzg9F3AkYMjRf5d0fh5P0yBnPFaUIqPvzijgnuH/4NMV
	V/9eV/RwqL9uMk1caOXeDpaLGxot/AtIgiq7nGbarbZF0FtwetLshgqOb2TNT12Ah6XacEsvACx
	hQRRO+g==
X-Google-Smtp-Source: AGHT+IFtEkvOBWBmPhAZp6fiQBmIeByIj1WwkTuM0S6f9ba1kbmIBgBTopqxljhwYNgNIix+N66SAv3Sd14=
X-Received: from pjbnh9.prod.google.com ([2002:a17:90b:3649:b0:343:6cb7:a68e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a8b:b0:343:f509:aa4a
 with SMTP id 98e67ed59e1d1-349a260a9d0mr9559247a91.36.1765301834531; Tue, 09
 Dec 2025 09:37:14 -0800 (PST)
Date: Tue, 9 Dec 2025 09:37:13 -0800
In-Reply-To: <2440b9bf-a2a1-4f66-94b2-71f47d62f3db@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com> <20251206001720.468579-38-seanjc@google.com>
 <2440b9bf-a2a1-4f66-94b2-71f47d62f3db@linux.intel.com>
Message-ID: <aTheSQb9fhXmZKw6@google.com>
Subject: Re: [PATCH v6 37/44] KVM: VMX: Dedup code for removing MSR from
 VMCS's auto-load list
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2025, Dapeng Mi wrote:
>=20
> On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> > Add a helper to remove an MSR from an auto-{load,store} list to dedup t=
he
> > msr_autoload code, and in anticipation of adding similar functionality =
for
> > msr_autostore.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 31 ++++++++++++++++---------------
> >  1 file changed, 16 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 52bcb817cc15..a51f66d1b201 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1040,9 +1040,22 @@ static int vmx_find_loadstore_msr_slot(struct vm=
x_msrs *m, u32 msr)
> >  	return -ENOENT;
> >  }
> > =20
> > +static void vmx_remove_auto_msr(struct vmx_msrs *m, u32 msr,
> > +				unsigned long vmcs_count_field)
> > +{
> > +	int i;
> > +
> > +	i =3D vmx_find_loadstore_msr_slot(m, msr);
> > +	if (i < 0)
> > +		return;
> > +
> > +	--m->nr;
> > +	m->val[i] =3D m->val[m->nr];
>=20
> Sometimes the order of MSR writing does matter, e.g., PERF_GLOBAL_CTRL MS=
R
> should be written at last after all PMU MSR writing.

Hmm, no.  _If_ KVM were writing event selectors using the auto-load lists, =
then
KVM would need to bookend the event selector MSRs with PERF_GLOBAL_CTRL=3D0=
 and
PERF_GLOBAL_CTRL=3D<new context (guest vs. host)>.  E.g. so that guest PMC =
counts
aren't polluted with host events, and vice versa.

As things stand today, the only other MSRs are PEBS and the DS area configu=
ration
stuff, and kinda to my earlier point, KVM pre-zeroes MSR_IA32_PEBS_ENABLE a=
s part
of add_atomic_switch_msr() to ensure a quiescent period before VM-Enter.

Heh, and writing PERF_GLOBAL_CTRL last for that sequence might actually be
problematic.  E.g. load host PEBS with guest PERF_GLOBAL_CTRL active.

Anyways, I agree that this might be brittle, but this is all pre-existing b=
ehavior
so I don't want to tackle that here unless it's absolutely necessary.

Or wait, by "writing" do you mean "writing MSRs to memory", as opposed to "=
writing
values to MSRs"?  Regardless, I think my answer is the same: this isn't a p=
roblem
today, so I'd prefer to not shuffle the ordering unless it's absolutely nec=
essary.

> So directly moving the last MSR entry into cleared one could break the MS=
R
> writing sequence and may cause issue in theory.
>=20
> I know this won't really cause issue since currently vPMU won't use the M=
SR
> auto-load feature to save any PMU MSR, but it's still unsafe for future u=
ses.=C2=A0
>=20
> I'm not sure if it's worthy to do the strict MSR entry shift right now.
>
> Perhaps we could add a message to warn users at least.

Hmm, yeah, but I'm not entirely sure where/how best to document this.  Beca=
use
it's not just that vmx_remove_auto_msr() arbitrarily maniuplates the order,=
 e.g.
multiple calls to vmx_add_auto_msr() aren't guaranteed to provide ordering =
because
one or more MSRs may already be in the list.  And the "special" MSRs that c=
an be
switched via dedicated VMCS fields further muddy the waters.

So I'm tempted to not add a comment to the helpers, or even the struct fiel=
ds,
because unfortunately it's largely a "Here be dragons!" type warning. :-/
