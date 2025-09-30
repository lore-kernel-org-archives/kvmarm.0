Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578B73081A6
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245263; cv=none; b=jtQk3NHG4g0P8WJcwUg0hiM+IV78x+i1kfN1FDAcrFy5dgrRfhqbsxeib0zJyAIGh/AzId0hgX+L8+1q5jb5btbAZgyiZE8CbQoO8c10Jfmu5GGpnGedPrh8FW4VVVpR+m10d3SrlStTvw98G7bFZ+5BTS2s/A/FHBozMgcTBMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245263; c=relaxed/simple;
	bh=F2Pg/8PlsKKDveTJhSAGQt0MF4T4X1RzRHH7BD2p+5c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W83zEtXscHSi3RL5h1Wz1zkRFJHtsH//VDVomDjFurKZQsdNbzOHAtx5TRcsdTd4ikldfliLTtQX9bUx0q8Aq5g1z/9yHLN1qovpLYxreuRoEQ51nSUCS6VSy8IdDNnpgHZZ5rBMOSVLAWbLDM02PYn0WECIdL2RWYUHRjJ16rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w2xZgR7/; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w2xZgR7/"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-277f0ea6ee6so76802475ad.0
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 08:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759245261; x=1759850061; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9rncmOGQUGwo1DfmFhY7VVo4DMzXg+cQESVF65y7v48=;
        b=w2xZgR7/xA4xp7SkawGO6cAj0iFSkqG16hweNvB7XI2AwRqeiOHtzIAOVVAIonfHqS
         RNSvihth1UdsjGZ8h0xOGwTecGeydPwbJr9IYVdbA7803ZeUGcwd7BJTWIT8E780t2IA
         39voxGd/tDbsRFwFgCh0u1NB6JfGHRgPkUuzLmyThmI2GkjlXpkbEwPI6+lIt48zLjnS
         5f5jbFVXxzdbflSWlQGZxj6+DcVZbkKnTgTJI2imDNNZNuUO+t0nOIdsWOldghGhaRdI
         r9JfHouJRnQfzg89lU5SMHVleMLXuFe36tXZ2/5S5kALKWdGPsQO4z1JG3PyFnjVJdUn
         KD+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759245261; x=1759850061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9rncmOGQUGwo1DfmFhY7VVo4DMzXg+cQESVF65y7v48=;
        b=X9YflAd1NKx6xDADDZRoTnMBrYVxMEPAikF4BPEGxOpXhqDun6hnFYxpL3DYQ0CIms
         67DzsOBWBqveX/OMkpp+dVkeRrmJGcgEag/AT4xrbtH8PgacRK/4Ptd7sKjTZ46ChbhA
         oEHravVFvGWaCGRNhHSNWaVTcxB2437q9YNoWAq1lhzy6xRZg16Gvw/IQVRqVmmi3cec
         w3JSb+3haEX0wK5cmgnBfnEgURpMLAP6pDUIFPyxND6HlaGpQLzNCHu7natnRSw6CKI9
         tOqVcPRhtattozNCrFWF3YNVTecrBlQb0CZDXDiqgFTU0C98XM9j3Ay/OAEVortJAljV
         KYxA==
X-Forwarded-Encrypted: i=1; AJvYcCWEGgG1cqPhN4oOkNnvP8aDmqvCp35yEaXrrOsW2ESDDd7AMsg+HtyoaEOi9eaUUcfk5ymPhDs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyE2B/P25BtWuue8Y87LKe441dZiQ96f6Ig0bRS/6eBKCIkRYzE
	UEr3ys1it/RdNm37DtypeR0VqZ46Gbhc9xgZaUALmOxX3oYLsgsSZjwBHL0DrgDnwIIBWMLIXXN
	PT86FWw==
X-Google-Smtp-Source: AGHT+IHQg6BTPI7i+AA/h/5N2kHeRUWEdP58zEE6EeWucPxFQt666vw4B3U2LZ7e4nNYE+79vfzOKIe7mTg=
X-Received: from plei20.prod.google.com ([2002:a17:902:e494:b0:268:cfa:6a80])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c2f:b0:267:cdb8:c683
 with SMTP id d9443c01a7336-28e7f2dcbb3mr1325795ad.27.1759245260716; Tue, 30
 Sep 2025 08:14:20 -0700 (PDT)
Date: Tue, 30 Sep 2025 08:14:19 -0700
In-Reply-To: <aK4cAPeGgy0kXY98@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250825155203.71989-1-sebott@redhat.com> <aKy-9eby1OS38uqM@google.com>
 <87zfbnyvk9.wl-maz@kernel.org> <aKzRgp58vU6h02n6@google.com>
 <aKzX152737nAo479@linux.dev> <aK4CJnNxB6omPufp@google.com>
 <aK4J5EA10ufKJZsU@linux.dev> <aK4cAPeGgy0kXY98@google.com>
Message-ID: <aNvzy5-lj3TBLT3I@google.com>
Subject: Re: [PATCH] KVM: selftests: fix irqfd_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Sebastian Ott <sebott@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="us-ascii"

+Naresh

On Tue, Aug 26, 2025, Sean Christopherson wrote:
> On Tue, Aug 26, 2025, Oliver Upton wrote:
> > On Tue, Aug 26, 2025 at 11:51:18AM -0700, Sean Christopherson wrote:
> > > On Mon, Aug 25, 2025, Oliver Upton wrote:
> > > > The majority of selftests don't even need an irqchip anyway.
> > > 
> > > But it's really, really nice for developers if they can assume a certain level of
> > > configuration is done by the infrastructure, i.e. don't have worry about doing
> > > what is effectively "basic" VM setup.
> > 
> > The more we pile behind what a "basic" VM configuration is the less
> > expressive the tests become. Being able to immediately grok the *intent*
> > of a test from reading it first pass is a very good thing. Otherwise I
> > need to go figure out what the definition of "basic" means when I need
> > to write a test and decide if that is compatible with what I'm trying to
> > do.
> 
> Eh, I don't buy that argument, not as a blanket statement.
> 
> The existence of code doesn't always communicate intent, e.g. the _only_ instance
> I can think of where doing more setup by default caused problems was a few crusty
> x86 tests that relied on an int3 to cause SHUTDOWN due to lack of an IDT.  OMG was
> I increduluous when I figured out what those tests were doing.
> 
> And in that case, _not_ doing the "basic" setup hid the intent of the test.  Aside
> from the fact that deliberately triggering SHUTDOWN was completely unnecessary in
> those tests, IMO forcing such a test to use vm_create_barebones() would better
> capture that the test is doing something odd, i.e. has unusual intent.
> 
> And explicitly doing something doesn't necessarily communicate the intent of the
> test.  E.g. the intent of the irqfd_test is to verify that KVM_IRQFD assign and
> deassign behaves as expected.  The test never generates IRQs, i.e. doesn't actually
> need an IRQCHIP beyond satisfying KVM's requirements for KVM_IRQFD.
> 
> There are undoubtedly other tests that have similar "intent".  E.g. the in-progress
> mediated PMU support for x86 requires an in-kernel local APIC, and so tests like
> pmu_counters_test.c, pmu_event_filter_test.c, and vmx_pmu_caps_test.c will need
> to instantiate an IRQCHIP.  None of those tests actually touch the local APIC in
> any way, e.g. don't generate PMU interrupts, so creating an IRQCHIP is once again
> nothing more than a means to an end, and not indicative of the test's main intent.
> 
> I think the use of vgic_v3_setup() in dirty_log_perf_test.c is also a case where
> the existence of code fails to communicate intent.  Without the comment in
> arch_setup_vm() to explain that having GICv3 somehow reduces the number of exits,
> I would be very confused as to why the test cares about GICv3.
> 
> I agree there's a balance to be had in terms of doing too much.  Unfortunately in
> this case, it sounds like the fundamental problem is that the balance is simply
> different for x86 versus arm64.  Having an in-kernel local APIC is tables stakes
> for x86, to the point where I'm looking for any excuse to have KVM create a local
> APIC by default.  But for arm64, there's tremendous value in having tests do the
> lifting.
> 
> > vm_create_with_irqchip() is delightfully unambiguous.
> >
> > > E.g. x86 selftests creates an IRQCHIP, sets up descriptor tables and exception
> > > handlers, and a handful of other "basic" things, and that has eliminated soooo
> > > much boilerplate code and the associated friction with having to know/discover
> > > that e.g. sending IRQs in a test requires additional setup beyond the obvious
> > > steps like wiring up a handler.
> > 
> > That simply isn't going to happen on arm64. On top of the fact that the
> > irqchip configuration depends on the intent of the test (e.g. wired IRQs
> > v. MSIs), there's a bunch of guest-side initialization that needs to
> > happen too.
> > 
> > We can add an extremely barebones GIC when asked for (although guest
> > init isn't addressed) but batteries are not included on this architecture
> > and I'd rather not attempt to abstract that.
> 
> What about providing an API to do exactly that, instantiate and initialize a
> barebones GIC?  E.g.
> 
> 	void kvm_arch_init_barebones_irqchip(struct kvm_vm *vm)
> 
> Hmm, then we'd also need
> 
> 	void kvm_arch_vm_free(struct kvm_vm *vm)
> 
> to gracefully free the GIC, as done by dirty_log_perf_test.c.  Blech.  Though
> maybe we'll end up with that hook sooner or later?
> 
> All in all, I have no strong preference at this point.

Oliver, any thoughts?  This is causing noise in people's CIs, i.e. we should land
a fix sooner than later, even if it's not the "final" form. 
