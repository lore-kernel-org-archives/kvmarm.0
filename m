Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBCB253B59
	for <kvmarm@lists.linux.dev>; Mon,  8 Dec 2025 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765217282; cv=none; b=nDW2L5ZDAJn6q4UmqOFTXMucws5LQ+3Ir7bfV6eM+K3M1ycySzGcKj7QYw1Iz9+guC/pqHzPJ4+DWARJ9NmZ7DG2ITXw7BIWh9ScmBT2d3MbPGfI8L0NOMq9H7Uz4ymZ0f/bdS9YrM2vpY1IZ+WG11+BKVHUvMMA8a46QIWynW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765217282; c=relaxed/simple;
	bh=9iufsu/WFJNy0WogHro7btB7qYSuDu2TmGiNlbbFqhw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vEuxv5mLo0XmxY4bhzyiyHkOfCdukJFI1cN4q6RG4FcCDSqNBcibGcQf7udoILCOJjLdzRf4jtDBrwJU8eefv+/FqckP8SXB74+4TEL+ns67ZsBv0PsSN1OdCrLwd4hiB6zQV8MQGtOHAMLiT/toKPS6DN00n7GSKbHGtH+PB34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q6UtX9l/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q6UtX9l/"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3436d81a532so8559499a91.3
        for <kvmarm@lists.linux.dev>; Mon, 08 Dec 2025 10:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765217279; x=1765822079; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SF6h5hGtRuMyBRglBJmpKQuSrVGlyuxXyhedVebSd6M=;
        b=q6UtX9l/Yk/bUyXLAATGqRikGquo/zO/sN086Pd8eJNbKHzAkyEb463OgoJZ1dWPby
         Wyk7K4/EKk7DHagDCCbaXxJ9wguwpdz7QeEnSnW0DoglLNZ2kqiw1/jK9TdCBAuWR4Zb
         hc+fMiCnn7o8z1M9u/DbnwZRV+kj1Q0ldlIpsyrbQ6rbpSXBIUbPcltXnKI3/leu+kc+
         NRFmRRvSD2kL/SMqRs3mTW2/BDmBoqhistLav3FLJHVTVh0L2SdLkHozSZmfZtudr4sX
         ZegkaYRT+VBMx429L/O6DZxcIMnyxZFfi3A+74I4dJmEaWlSBY2NEMqSmyG7GJAHsHyK
         sIhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765217279; x=1765822079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SF6h5hGtRuMyBRglBJmpKQuSrVGlyuxXyhedVebSd6M=;
        b=abIB4JYzQxCzrkaKH+qekCThWRInKLJ31PeX108KS2Ne9nZ6XIjWvKLGRTZkuudMOX
         6RVEwSGcxTyE4G+Ce9hnWo+c3ceBT6iBr3KVenhovnRsVwIAVxLUBDNONPbdDwe3GfGD
         VW3HpFCWYKanDKmvlXWQ+mCiw1hBZ5xTevE+LBqAJclKLTHok6K3mueQyl4bzLeG59q8
         myk4PnG2gauZBmqhpdamLmHx7aPVEcsCV54V+MDd3Ur6MQZ8HGp8/5tEX710PE6eHa34
         LgR22E37Cin/XSwGAMay7uQ51AwkmsNk5EQAZMx7cIdpp3VIGCBfzlx+9KOWbW3q7vCN
         VELA==
X-Forwarded-Encrypted: i=1; AJvYcCVnZzcl3vBNVQvq7mJM4UPSWvcFlQl2s7BO9sVlT7qF/Ycs7X2mStQoVj7NyjtSNrKBn6+XQ+4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDAswqVau638QaQKAleZNm0FFez6tGV0zeaQ80t9qcHnunJ6jr
	JcNUy/DVXgeKlrdNNolo8dTSVS2Lsygq1TpK2gC2N3rU0CPsyXdf8wd8ox2DCJ+v1I8K1Z09Lq8
	dBk/k4A==
X-Google-Smtp-Source: AGHT+IH3HhOiXlRek80ArMNgo8utGCkumZ6GCHftobZYLKaRSJ46MkO0EFccaQp1M2wj9T7xKajFvZIZ67U=
X-Received: from pjbfs21.prod.google.com ([2002:a17:90a:f295:b0:343:6849:31ae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2787:b0:349:8a8b:da5c
 with SMTP id 98e67ed59e1d1-349a24f2f71mr7253927a91.11.1765217279160; Mon, 08
 Dec 2025 10:07:59 -0800 (PST)
Date: Mon, 8 Dec 2025 10:07:57 -0800
In-Reply-To: <20251208115156.GE3707891@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com> <20251206001720.468579-5-seanjc@google.com>
 <20251208115156.GE3707891@noisy.programming.kicks-ass.net>
Message-ID: <aTcT_QcQaqyHV_S-@google.com>
Subject: Re: [PATCH v6 04/44] perf: Add APIs to create/release mediated guest vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 08, 2025, Peter Zijlstra wrote:
> On Fri, Dec 05, 2025 at 04:16:40PM -0800, Sean Christopherson wrote:
> 
> > +static atomic_t nr_include_guest_events __read_mostly;
> > +
> > +static atomic_t nr_mediated_pmu_vms __read_mostly;
> > +static DEFINE_MUTEX(perf_mediated_pmu_mutex);
> 
> > +static int mediated_pmu_account_event(struct perf_event *event)
> > +{
> > +	if (!is_include_guest_event(event))
> > +		return 0;
> > +
> > +	guard(mutex)(&perf_mediated_pmu_mutex);
> > +
> > +	if (atomic_read(&nr_mediated_pmu_vms))
> > +		return -EOPNOTSUPP;
> > +
> > +	atomic_inc(&nr_include_guest_events);
> > +	return 0;
> > +}
> > +
> > +static void mediated_pmu_unaccount_event(struct perf_event *event)
> > +{
> > +	if (!is_include_guest_event(event))
> > +		return;
> > +
> > +	atomic_dec(&nr_include_guest_events);
> > +}
> 
> > +int perf_create_mediated_pmu(void)
> > +{
> > +	guard(mutex)(&perf_mediated_pmu_mutex);
> > +	if (atomic_inc_not_zero(&nr_mediated_pmu_vms))
> > +		return 0;
> > +
> > +	if (atomic_read(&nr_include_guest_events))
> > +		return -EBUSY;
> > +
> > +	atomic_inc(&nr_mediated_pmu_vms);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(perf_create_mediated_pmu);
> > +
> > +void perf_release_mediated_pmu(void)
> > +{
> > +	if (WARN_ON_ONCE(!atomic_read(&nr_mediated_pmu_vms)))
> > +		return;
> > +
> > +	atomic_dec(&nr_mediated_pmu_vms);
> > +}
> > +EXPORT_SYMBOL_GPL(perf_release_mediated_pmu);
> 
> These two things are supposed to be symmetric, but are implemented
> differently; what gives?
> 
> That is, should not both have the general shape:
> 
> 	if (atomic_inc_not_zero(&A))
> 		return 0;
> 
> 	guard(mutex)(&lock);
> 
> 	if (atomic_read(&B))
> 		return -EBUSY;
> 
> 	atomic_inc(&A);
> 	return 0;
> 
> Similarly, I would imagine both release variants to have the underflow
> warn on like:
> 
> 	if (WARN_ON_ONCE(!atomic_read(&A)))
> 		return;
> 
> 	atomic_dec(&A);
> 
> Hmm?

IIUC, you're suggesting someting like this?  If so, that makes perfect sense to me.

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c6368c64b866..fa2e7b722283 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6356,7 +6356,8 @@ static int mediated_pmu_account_event(struct perf_event *event)
 
 static void mediated_pmu_unaccount_event(struct perf_event *event)
 {
-       if (!is_include_guest_event(event))
+       if (!is_include_guest_event(event) ||
+           WARN_ON_ONCE(!atomic_read(&nr_include_guest_events)))
                return;
 
        atomic_dec(&nr_include_guest_events);

> Also, EXPORT_SYMBOL_FOR_KVM() ?

Ya, for sure.  I posted this against a branch without EXPORT_SYMBOL_FOR_KVM(),
because there are also hard dependencies on the for-6.19 KVM pull requests, and
I didn't want to wait to post until 6.19-rc1 because of the impending winter
break.  Though I also simply forgot about these exports :-(

These could also use EXPORT_SYMBOL_FOR_KVM():

  EXPORT_SYMBOL_FOR_MODULES(perf_load_guest_lvtpc, "kvm");
  EXPORT_SYMBOL_FOR_MODULES(perf_put_guest_lvtpc, "kvm");


> I can make these edits when applying, if/when we get to applying. Let me
> continue reading.
> 
