Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1692F2E7F21
	for <kvmarm@lists.linux.dev>; Tue, 26 Aug 2025 18:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756234281; cv=none; b=ik1KaJR4HdgSz4jpb3uU+yL1dWadBlYLUhhOZiqrj+vpIv+WccFB00T4LM9YaNknnxB5oMPfUFGgzyvdbZy0o4Ch00fB+aCgExYWN3kZpNzGAWG1VPcCvsMTdMhS4pEokQAqLg2RlkDHl35/C04d5xTPnr3xgQwQLK84ptNbAYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756234281; c=relaxed/simple;
	bh=ePoQZSqtiQfljKx6DF9Tewo2GeYmeDzoRcxt1mAmdBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EybJD0E71DZLKV63lSfCbUKoxejt26bdFkknwyJ8uRzCOCC/8RgT3vTAwW7NFazEelpDi+GVK/TLbbvrr0Zpl/x6OyFUdtcctg5RQSWsPkpU77y6JV1qZsUOj8HyVmSIMIpzE00bKqlAmF6xemo5MhrQaKR3pLsr9w6cuhUwk9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sg3cesE9; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sg3cesE9"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-771e43782aaso2378163b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 26 Aug 2025 11:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756234279; x=1756839079; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wx/eP8ISZUfaNU5gsf9zfBk4G2Ojy7BXWA5HSbjb9W8=;
        b=sg3cesE9kEr5c/sBQmIFgxk4dOgzCAcglO9nTBY752/8FmXn1cBEI2DyoB2hSeGfP0
         ox+GD/kCCcXJs5WOFQeLhRY9Zu/mghGUK7lx0IJ5zBrx0ZNogg8PWzwYxCDynl+sECQb
         RzH16poTkiWZoxdXXyh5m+eO0QF6UYnTPY9Vb2+kNSIje3QYCi1TnfuFZHg+BbZMOQHb
         uNjJZ7892oMz+JsRzkCvw14PvJURcBfJVMcMbKfVrBOBBjcfw3/zeLL2WiPX5g+uwo5i
         P1kFyrYQ4z76Ms/KWdOuFgThXNCj8yQOj54FcYbD4V4UlYYTE81W9H91S9ATFKbeknpy
         vGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756234279; x=1756839079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wx/eP8ISZUfaNU5gsf9zfBk4G2Ojy7BXWA5HSbjb9W8=;
        b=Rd14n6LmDXPUBkBNIPwfOfK4VBe28RVlzgMMWhal52Djfa9B16rD9ZkHyYRvUSWT+t
         sUPallsI+LJIrl+I4E1MdLXqgQhs3f1b8Ndz/eMbbX97pksdPPQPO4NVehV2rO/prX2H
         Pt01xV5QxvPEbO3U4FNvUhUHyXgGbiOd8T1lAN6iY61tOSTCn9iiwwjpZk0BOwCuhTvG
         L2PcN9nwrM9Ne10tqm/S8nPpGOjpM5LGDc+prXvabWkb3QbVNTvfnMuIq9ttWrhvXZkV
         3kfeTvoCRyCQghYkf13TX6XSZKtLDKCU9c7CuK4KIoXflCVV4oBk0XveJ7fAQ3vujnJh
         SmAg==
X-Forwarded-Encrypted: i=1; AJvYcCWHvDq4ofUc0KH0May8JrBwhvqWeG4otrSXBNqs83V+pIPTTLvtktE25q8pKQfnsFm934el024=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz93y2RzrTizhXg2tmkDgL23oRq554KKlFXF+D/xPLa3ef5IEHY
	wUKPncvnHCfG15J3XVarp1qHvgsmNwDwmjioLq4xWgYyhYo7E1WN8K7UjznR0XBBXY01fIt0ZOZ
	6d5DRCg==
X-Google-Smtp-Source: AGHT+IGKYZgVuKPCFTi5OK6fXT9HPNRtj+Ry3+8K8iNH2BVKAfyRecdTfCXVWb0y2y273V0KC9Ad4c4jfQ0=
X-Received: from pfhh22.prod.google.com ([2002:a05:6a00:2316:b0:76e:839a:7a08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e01:b0:748:e9e4:d970
 with SMTP id d2e1a72fcca58-7702fa091a4mr19565624b3a.1.1756234279349; Tue, 26
 Aug 2025 11:51:19 -0700 (PDT)
Date: Tue, 26 Aug 2025 11:51:18 -0700
In-Reply-To: <aKzX152737nAo479@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250825155203.71989-1-sebott@redhat.com> <aKy-9eby1OS38uqM@google.com>
 <87zfbnyvk9.wl-maz@kernel.org> <aKzRgp58vU6h02n6@google.com> <aKzX152737nAo479@linux.dev>
Message-ID: <aK4CJnNxB6omPufp@google.com>
Subject: Re: [PATCH] KVM: selftests: fix irqfd_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Sebastian Ott <sebott@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 25, 2025, Oliver Upton wrote:
> On Mon, Aug 25, 2025 at 02:11:30PM -0700, Sean Christopherson wrote:
> > On Mon, Aug 25, 2025, Marc Zyngier wrote:
> > > On Mon, 25 Aug 2025 20:52:21 +0100,
> > > Sean Christopherson <seanjc@google.com> wrote:
> > > > Is there a sane way to handle vGIC creation in kvm_arch_vm_post_create()?  E.g.
> > > > could we create a v3 GIC when possible, and fall back to v2?  And then provide a
> > > > way for tests to express a hard v3 GIC dependency?
> > > 
> > > You can ask KVM what's available. Like an actual VMM does. There is no
> > > shortage of examples in the current code base.
> > 
> > Right, by "sane" I meant: is there a way to instantiate a supported GIC without
> > making it hard/painful to write tests, and without having to plumb in arm64
> > specific requirements to common APIs?
> > 
> > E.g. are there tests that use the common vm_create() APIs and rely on NOT having
> > a GIC?
> 
> Instead of stuffing a GIC in behind vm_create(), I'd rather we have a
> specific helper for creating a VM with an irqchip. There's tests in
> arm64 that rely on all this generic infrastructure and also need to
> select / dimension a GIC appropriately for the test.

I've no objection to arm64 providing an API for tests that need a specific GIC
configuration (I think it's a great idea), but I don't think that needs to be
mutually exclusive with having the common APIs instantiate _a_ GIC by default.

What if we use a global flag with thread local storage (because paranoia is
basically free, I think) to communicate that the test wants to create a v3 vGIC?

E.g.

---
static __thread bool vm_wants_custom_vgic;

void kvm_arch_vm_post_create(struct kvm_vm *vm)
{
	if (!vm_wants_custom_vgic) {
		<setup default vgic>
	}
}

struct kvm_vm *vm_create_with_vgic_v3(uint32_t nr_vcpus, void *guest_code,
				      uint32_t nr_irqs, struct kvm_vcpu **vcpus)
{
	TEST_ASSERT(!vm_wants_custom_vgic, "blah blah blah");
	vm_wants_custom_vgic = true;
	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus)
	vm_wants_custom_vgic = false;

	vgic_v3_setup(vm, nr_vcpus, nr_irqs);
}

struct kvm_vm *vm_create_with_one_vcpu_and_vgic_v3(struct kvm_vcpu **vcpu,
						   void *guest_code,
						   uint32_t nr_irqs)
{
	struct kvm_vcpu *vcpus[1];
	struct kvm_vm *vm;

	vm = vm_create_with_vgic_v3(1, guest_code, nr_irqs, vcpus);

	*vcpu = vcpus[0];
	return vm;
}
---

> The majority of selftests don't even need an irqchip anyway.

But it's really, really nice for developers if they can assume a certain level of
configuration is done by the infrastructure, i.e. don't have worry about doing
what is effectively "basic" VM setup.

E.g. x86 selftests creates an IRQCHIP, sets up descriptor tables and exception
handlers, and a handful of other "basic" things, and that has eliminated soooo
much boilerplate code and the associated friction with having to know/discover
that e.g. sending IRQs in a test requires additional setup beyond the obvious
steps like wiring up a handler.
