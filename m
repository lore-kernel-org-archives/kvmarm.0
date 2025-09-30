Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD45A28640F
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 19:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759260588; cv=none; b=VV83GwlCd7z/PbvKAnofICA2Feo4y9J+PoCY8fPzKwLP+ELAsMt9xuCo+b2I+bWU/ctdWDkY2HlIuMohDicrM5XHivfJmsxXg9hhbroyDnD8Q+OeTuw/5dyHq+uV1fLll6KGASmVst1oWARlbaNxNVoqJ0VvjEfEWZGCeH7B2bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759260588; c=relaxed/simple;
	bh=P+qZ2fZAEXfL436ybjprlYZc2AIijh26vuzV2ZNtQnk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KqlyVT23H+sFXmDl1GWlWFKxQ2J2ScpGNLUGtOKWf2OV/Ag7xQ+9YqoFROqLDlDwCd9f3L7MLbgnO5kf54vyhpQlXHZ7q0vN2EBHuEw0A7Bk4sl24FrgEjRnouJqKqLd/p7/BiDqwOIXZ+a+6j1dHhnkz05kt3lOLJm2AHja3kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mmclva2V; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mmclva2V"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-286a252bfc2so1872475ad.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 12:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759260586; x=1759865386; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bRnlDy13lHDP7WqEGAF8ErlJ5mSCGwAed5lppIb8Dzg=;
        b=mmclva2V8lwTBrCIRVXdMtCm/3QQjqX/vscWvagg+IyuXIZgRyTCBDCa7wsP5/DpH7
         JtRNZJMNFFXrBi9fOBIJS/KxRh/tJsOeqSLuo5w5LYrP+ZYlUmF+yrzaD+F/cv8B7ni0
         hBjsEiZBLqbKY5RMM2BoQqRQsMsESXoGjV5HiTd3uk5Ih6cv40A3f9JdLTeg7x6QeatM
         ki3FZ3rDfPCOyYFybGVf28Kts/FcZwTQLuO4NaFDe/VYMDj4PRfWKbcHPWqIXX9YUGye
         8NUmdZYsLnGNcyXp7ZdISAhWkTEIe0rmFiDHsrcmIOZPQ/ii3qDCdktvTEd91TJKi0/r
         biow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759260586; x=1759865386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bRnlDy13lHDP7WqEGAF8ErlJ5mSCGwAed5lppIb8Dzg=;
        b=i4nBN3mEL5iOjh4Lj+yqMdQHiGY78xNhgmd2DWx6th7GmiU6sWXQrgORys1CttOQCb
         R5n87ik4GmuVYivmVZf1zZNiu7bOCxKDb1MI/9mJeKa5Ah2hCNkx/ZjX9rVXj+KxxId4
         tprt58BfvSBPYgD6YxlHcSV706GTnz7b1xT+korJHGCvOhRuaJQZxQVPs6NJaZL2kVdx
         UwO4ZR41nez89uWFDXMFM4ywhMIuYnInemAoh7MrO+cIZLa6I+y5QMtDnlwT10qi7lzc
         NueVWt957NbDOLS51FW2UC4r38ia/S4choIPY0jewlDzxYj4Xe3+VAMDu6XsIau6g2ZY
         iOEg==
X-Forwarded-Encrypted: i=1; AJvYcCXd9uWdYF0aA+wRTo8XSNX9qheZy9R7cYwVN2I3OLx6IXmfi936SMiJ8x1yxfBEYPzlq527Kt8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzX7OUA09JViXjGIg7PJPNsL9IMlMstRhVfIFrPmMRlBpqQB2ip
	OzsFNL86dBSpO5l0ILZClnMjBeAjOFlo5ft1T6j2ROp6reQGnTo/TQlpoFJcRyzCwNXgGzm5OVi
	bXuVwOw==
X-Google-Smtp-Source: AGHT+IF5F3WIQ14BvXYYKK8coAqeR7NqeKnM/sNLJDk+1DZxPsJu3iO33ShTmyn79EL/jVws/rkPw3b2Mhs=
X-Received: from pjvi5.prod.google.com ([2002:a17:90a:dc05:b0:329:ccdd:e725])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f647:b0:269:aba9:ffd7
 with SMTP id d9443c01a7336-28d1713873fmr61157175ad.25.1759260586135; Tue, 30
 Sep 2025 12:29:46 -0700 (PDT)
Date: Tue, 30 Sep 2025 12:29:44 -0700
In-Reply-To: <aNwgyhZO0BXQVExn@linux.dev>
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
 <aNvzy5-lj3TBLT3I@google.com> <aNwgyhZO0BXQVExn@linux.dev>
Message-ID: <aNwvqAEZG9ustuDo@google.com>
Subject: Re: [PATCH] KVM: selftests: fix irqfd_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Sebastian Ott <sebott@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 30, 2025, Oliver Upton wrote:
> On Tue, Sep 30, 2025 at 08:14:19AM -0700, Sean Christopherson wrote:
> > > What about providing an API to do exactly that, instantiate and initialize a
> > > barebones GIC?  E.g.
> > > 
> > > 	void kvm_arch_init_barebones_irqchip(struct kvm_vm *vm)
> > > 
> > > Hmm, then we'd also need
> > > 
> > > 	void kvm_arch_vm_free(struct kvm_vm *vm)
> > > 
> > > to gracefully free the GIC, as done by dirty_log_perf_test.c.  Blech.  Though
> > > maybe we'll end up with that hook sooner or later?
> > > 
> > > All in all, I have no strong preference at this point.
> > 
> > Oliver, any thoughts?  This is causing noise in people's CIs, i.e. we should land
> > a fix sooner than later, even if it's not the "final" form. 
> 
> The lack of a default VGICv3 wound up getting in my way with some
> changes to promote selftests to run in VHE EL2, cc'ed you on that series
> since I wound up walking back my gripes here :)
> 
>   https://lore.kernel.org/kvmarm/20250917212044.294760-1-oliver.upton@linux.dev

Hah!  I saw the series but didn't read the cover letter. :-)

> That's now in Paolo's tree as of this morning. With that said, I think
> irqfd_test needs a bit more attention (below).
> 
> Thanks,
> Oliver
> 
> >From 4d0a035fb7e6cead74af4edb24fbcfdec076d321 Mon Sep 17 00:00:00 2001
> From: Oliver Upton <oliver.upton@linux.dev>
> Date: Tue, 30 Sep 2025 10:53:14 -0700
> Subject: [PATCH] KVM: selftests: Fix irqfd_test for non-x86 architectures
> 
> The KVM_IRQFD ioctl fails if no irqchip is present in-kernel, which
> isn't too surprising as there's not much KVM can do for an IRQ if it
> cannot resolve a destination.
> 
> As written the irqfd_test assumes that a 'default' VM created in
> selftests has an in-kernel irqchip created implicitly. That may be the
> case on x86 but it isn't necessarily true on other architectures.
> 
> Add an arch predicate indicating if 'default' VMs get an irqchip and
> make the irqfd_test depend on it. Work around arm64 VGIC initialization
> requirements by using vm_create_with_one_vcpu(), ignoring the created
> vCPU as it isn't used for the test.
> 
> Fixes: 7e9b231c402a ("KVM: selftests: Add a KVM_IRQFD test to verify uniqueness requirements")

Reported-by: Sebastian Ott <sebott@redhat.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Acked-by: Sean Christopherson <seanjc@google.com>
