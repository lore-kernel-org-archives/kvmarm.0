Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794326017;
	b=GTnBRsNy+iAPjkFlPDM0KbIez1Jv/qiwpp9qGM91ahLApWx+9u+GNX7xfXtExDiQ1QfF
	 fj4gQ20c34JwH+n03ISvguu7eztMVKv4H6qka3jLOH3HYpL1A0Kk9sbI8vXc39R+HyWpD
	 Sp2qDtS37aMXJ/vKIV7xD4BEsFrlO61raNd7tKQ76tE9SXvm1qXNvwUj1/9O0QDzgDlNA
	 Ulf8f0fRb8fWBUNYxZVFKlRizEqVQeOAqlHbgX1xJZz91lbw4XyFVK5jMFvolJB++NONs
	 +4TuVo54GxA0k6O6fB+IHflq46ZElf4yVwesjLW5YjhbKFv1HDMnvAwuws7zf63BYcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794326017;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Mb0MdDBCZew5k3777cm9fQD62/5KwOz3NQ1SfeT9BE8=;
	b=4f7h9Xno/z3KrBXWfdaG90xU0a7ucBytx1QpSQiQQxibIii1IxUp2LrtT7G7ekv4HAH9
	 s2LckXU+vr5xLBl3QOqc8WcPB+nmuJdQq6ZrOe5hSwh0GMTarfQAp4qeNVhCzX28IvBj5
	 O9E4oAxJigjSwktoUW2BqCJvGy3dzaKapZEyYUTFiP/Psjb3Y5qZOzvac9V5jXG4GiRbK
	 44HkugNJRCSyC9aqzZz357bgI/76HuBmm9y35EqyuiaXumt4rj2piMu2I8gPTUorWd3pk
	 JUvmu09/Jn5tnKLAOU9IANlOvhV4Ehp79t0TUViG3292vlLD5JjKeV/sUNBpXTbxPQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GGFqRJiD;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D23606A321
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:53:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18D23606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GGFqRJiD
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a0688a43d3so1533147b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 07:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794326016; x=1794930816; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mb0MdDBCZew5k3777cm9fQD62/5KwOz3NQ1SfeT9BE8=;
        b=GGFqRJiDwOrCjKOO+E2Yppf7Dox5pIz7CcvtU2dcqgAQMjWPQN7F2OnH6tD0hTs8A0
         TICMx0fZngS1CKzo6mmlzm6eGsKDBpwI0BSYnjgSZCxegml5KyHnnlEawtWoKEH86N4t
         OVWqsj1aXoWwnOEj5bGZBtSRPJJR8OnCqmrCXi1t2msI+2nhxvcbyIRpzlTu8g+qyv8g
         bFJKN9ad2n2AP5GbtBQT3iVEm4u/WGwza0vWUiGQ9bAoYRd/8AzzRJ15JKExTOtI+upD
         AgQiwzeaE7WAp3BY52CISsLhfRLoHEa5jbicG9D7B2Aqgfa5X9IrHa3h8Z1ui5nr2DRg
         m6Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794326016; x=1794930816;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mb0MdDBCZew5k3777cm9fQD62/5KwOz3NQ1SfeT9BE8=;
        b=YihmSdOjfPLSBBXAzT1qV60WuDAPUG2SsiF7Y0Ji4nr38UoSull721E6emdb5pN6Qn
         7Ch8X7o7uEfvyC+p8WlAXWMyJ5PQH0cRGSgTQ29B3NdRT2HGchAMpk2eCmqKEjAVp7bx
         G/8BCVhS1Z8bUuY81U//8dCC0rjPXHOUMiOWXgX9eZVbYnVNhkjqJXpsvctvRXV3z8Tr
         znGh2T5vTJUA8VVIGlGrD+fKWXLKH9llRCZxkICON07ASQZIHOEKq10qp/Z71skL33+9
         Vj22ilYV1ZgnLTP7qZf4i2hovw1E7h7xt3RXUYAPfuuyG6vBeGpmPjqL6neCcCB4g1Wb
         2gJg==
X-Forwarded-Encrypted: i=1; AL+hErGVFyt6oOUn6KDYbYdMMEbCe/8xCg8wMxSyLMFV+3Lzeooc1XU1HhOv37waB65UkF44tapANNA=@lists.linux.dev
X-Gm-Message-State: APuU4Z9vKFsT1jSO7uoV0a846C3T9awE599GTXnwadmxLN5rQvucX7bE
	aq6C+E6+INOvH8T6pWlX9SjZzCFWEZVNUc46/fuI/dr/W/0/no+/AE/uyJb9AzSpdtnbs6NqL+5
	yxU1ugw==
X-Received: from pfwp56.prod.google.com ([2002:a05:6a00:26f8:b0:89e:861c:6b39])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2402:b0:899:3439:c8d5
 with SMTP id d2e1a72fcca58-8ba862ccf23mr3397440b3a.14.1794326016155; Tue, 10
 Nov 2026 07:53:36 -0800 (PST)
Date: Tue, 10 Nov 2026 07:53:35 -0800
In-Reply-To: <CA+EHjTxT_9NghyLSZmOOi_oQboQw-g+6z9WxwaF=-7RdaGbMNw@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110110724.3614412-1-fuad.tabba@linux.dev>
 <20261110110724.3614412-3-fuad.tabba@linux.dev> <avMoubwqgXbpflwM@gremlin> <CA+EHjTxT_9NghyLSZmOOi_oQboQw-g+6z9WxwaF=-7RdaGbMNw@mail.gmail.com>
Message-ID: <avM9_7aWUDJSL3Lq@seanjc-mac.roam.internal>
Subject: Re: [PATCH 2/2] KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a
 full dirty ring
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 10, 2026, Fuad Tabba wrote:
> Hi Lorenzo,
> 
> On Tue, 10 Nov 2026 14:38:27 +0000, "Lorenzo Stoakes (ARM)"
> <ljs@kernel.org> wrote:
> > On Tue, Nov 10, 2026 at 11:07:24AM +0000, Fuad Tabba wrote:
> > > Pre-fault more populated, dirty-logged pages than the vCPU's dirty ring
> > > holds, and check that each call stops before the ring overflows, that a
> > > retry returns ENOSPC without progress, and that the harvested entries
> > > are the pages in order. A read pre-fault can map a page read-only, or
> >
> > Are we asserting an invariant that prefaulting happens in address order
> > here?  Is that explicitly presumed in the prefault API, or just how it
> > happens to pan out?
> >
> > I wonder if we might decide for whatever reason in future to do things
> > differently there. Bit nitty I know, but wonder if it's asserting an
> > implementation detail?
> 
> Yes, the API doesn't guarantee an order. I'll assert that every page
> is reported exactly once instead.
> 
> [...]
> > > diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> [...]
> > > +static void test_pre_fault_dirty_ring(void)
> [...]
> > > +    /* Populate the pages, so that pre-faulting can map them writable. */
> >
> > Reviewed below, but I wonder how x86 could then read fault these?
> 
> KVM_PRE_FAULT_MEMORY is defined as a read fault, but x86 maps the page
> writable when the host page is, and marks it dirty, unless it falls
> back to access tracking (below). Populating the pages makes sure they
> aren't backed by the zero page.

Before we effectively solidify the behavior, I think we should have an explicit
discussion about the desired behavior of KVM_PRE_FAULT_MEMORY when dirty logging
is enabled.  E.g. the only reason I kept the existing behavior in my auto-prefault
series was because I couldn't think of a good reason to change it.  But we never
made a concious decision in the first place, i.e. we never considered what would
happen if prefaulting collided with dirty logging (as evidenced by this bug).
