Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7D14E56ED
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 15:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788450519; cv=none; b=pSQYeWYzgwradkemq3V6zZnVKDySuMCJ4IABNVeYPHQ7zkW4/OJZGvRAVdBTtlygHy2Z10a5yB86XqX/1A/IEIiIx5Ml+mmeFPjc91cXPvLvrxDlbKOQUNAo/pq+6zKdZicPxonziU+iO5YKmt+7FdM49i7FHZzgzWd6KBAkfaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788450519; c=relaxed/simple;
	bh=qKmRoYSbK4pggjfQTTrO8FbbOoauwacbfUdwqi26JN8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DHPU9cVdW6VBAEyZuAezu0mawX3eJCUeOj9v5YR1F9jjbpemtsqMTydlg6UofublW7ogd0pCh4BUzNAduFIOxN0dJw3OHzcJXPDKWAcHiMioG6Nl+b5xMs8lfMuwDuetgGqUrtGvSsMvBSVOWsvc5o/qawyZ+ps/KDls+wavJgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=enWrIO3x; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="enWrIO3x"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d001671a54so43861975ad.2
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 08:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788450517; x=1789055317; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PmHR9VMSgZvTyS5Rd9T+V8oik7z2Cr4I+UuO+iaoSDc=;
        b=enWrIO3xo4Cvr1dwGYY2WZVMLsKERP6EutDSzJEwNqrYBffc3LKULpy0r1fmRExR2I
         1f6FnF20ZeDp2NKpSciJrbT3ZMzP0cBHvCnrvVLJ2TiQ6V3oY+NlMUsB2c+JyOorut6m
         NLWEW0nQc+Dp6Wf1x3p8gFoe5tHtMosskOpbPVhNw8Sraml3NWNhs8hgbjlkBwpa0Hem
         gSt0CEq6qVeRkClpzxm9m9SmnSJJua1Ay4AFSLfpg5AlhavJjojeWYlqFXvrmJ4XLpRK
         5+Whfc5cI3yEWSHuXv1EyvIX54eLcDrsTPImVL3JUIcX4uY9I8dajW7xdlHBDgzZVDeR
         vgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788450517; x=1789055317;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PmHR9VMSgZvTyS5Rd9T+V8oik7z2Cr4I+UuO+iaoSDc=;
        b=Qjj+A63koVnM6riHPoseaX2WSpn573gaEhMfjNH88IKnCzrs1glMSMvsEOOClP8B0F
         Y+NQ37KEoOniSQbE6ojaCU46aXn1ib+iKlY4N71RQnzTAZJbL0zxrfyE3T4/Lkzeiqh/
         YOcBkJ+WpADXvdcFR+mECQR1psMsn1I4f9YoaXRbiJgZkspZ59A/PdfvSvlNJD0PiUcg
         Nxb4VSF+coZnAAQvPyurI6PHuqcjDZ9O5euURE75GmcnZzdilXqg4sQ0AEFdLkZkEdYH
         pMY0bdjlXgu1ZM+MMHMObNeudIxwjXlU1MlPRl3uiisFu69atSfgVK4izdae6XpRawEF
         8T5w==
X-Forwarded-Encrypted: i=1; AKwUvBx4oeu42nZAlP9TBU/o865t0ot2Fd8Xp9jPXgqf7s5pEUy4dn4C7dIl2b91LnCD7nBHAOKbMcs=@lists.linux.dev
X-Gm-Message-State: AFuF++mvY5qv3v1HhFnOQ+CEhF5grnKiyyM581YEtSHa7vb6vqveQpU3
	Y/S/CL/7dpy2DhY8RVlUqn238eBcppOW7LqVlAjikADpgHD5C9hRtXozvaaoW7IdX4YJWNUEAn2
	K0WfCeg==
X-Received: from plce19.prod.google.com ([2002:a17:902:f1d3:b0:2d9:2fc7:bb3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f78c:b0:2c9:df1b:e948
 with SMTP id d9443c01a7336-2daec5dfa20mr199165855ad.4.1788450516176; Thu, 03
 Sep 2026 08:48:36 -0700 (PDT)
Date: Thu, 3 Sep 2026 08:48:35 -0700
In-Reply-To: <20260903114241.33034-C-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260831144802.834315-1-seiden@linux.ibm.com> <20260831144802.834315-3-seiden@linux.ibm.com>
 <apdweRfqt4dTxcU9@google.com> <20260902075028.231001-D-seiden@linux.ibm.com>
 <aphLXQL1H2zYZgTi@google.com> <20260903114241.33034-C-seiden@linux.ibm.com>
Message-ID: <apmW0xFe7zgzheGe@google.com>
Subject: Re: [PATCH v7 02/23] KVM: Make device name configurable
From: Sean Christopherson <seanjc@google.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Grapentin <gra@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Friedrich Welter <fritz@linux.ibm.com>, Fuad Tabba <tabba@google.com>, 
	Gautam Gala <ggala@linux.ibm.com>, Hariharan Mari <hari55@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Hendrik Brueckner <brueckner@linux.ibm.com>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Nico Boehr <nrb@linux.ibm.com>, 
	Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 03, 2026, Steffen Eiden wrote:
> On Wed, Sep 02, 2026 at 09:14:21AM -0700, Sean Christopherson wrote:
> > On Wed, Sep 02, 2026, Steffen Eiden wrote:
> > > On Tue, Sep 01, 2026 at 05:40:25PM -0700, Sean Christopherson wrote:
> > > > On Mon, Aug 31, 2026, Steffen Eiden wrote:
> > > > > Allow KVM implementations to choose alternative device names. This is
> > > > > especially useful for architectures providing multiple KVM
> > > > > implementations simultaneously. Architectures providing multiple KVM
> > > > > implementations must compile the KVM common code once per
> > > > > implementation and mange symbols.
> > > > 
> > > > What about tracepoints?  Or do those show up as "kvm" and "kvm-arm64"?
> > > 
> > > Yes, I want them to show up as kvm and  kvm-arm64.
> > > 
> > > Thanks for pointing that out - I just noticed that I forgot to switch
> > > the trace system to kvm-arm64 for the common tracepoints in
> > > trace/events/kvm.h
> > > I only did it for the arch-local traces in PATCH 21.
> > > 
> > > I would just do the following:
> > > 
> > > diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> > > index b282e3a86769..5d4f8a0693a3 100644
> > > --- a/include/trace/events/kvm.h
> > > +++ b/include/trace/events/kvm.h
> > > @@ -5,7 +5,11 @@
> > >  #include <linux/tracepoint.h>
> > > 
> > >  #undef TRACE_SYSTEM
> > > +#ifdef KVM_S390_ARM64
> > 
> > Side topic, I recommend choosing a macro name that doesn't have a near-collision
> > with CONFIG_KVM_S390_ARM64.  This *looks* like a typo, i.e. it looks like you
> > forgot the CONFIG_ prefix.  Especially since the macro is defined in the Makefile
> > and won't show up with e.g. "git grep -w KVM_S390_ARM64". E.g. KVM_S390_BUILD_ARM64
> > or something?
> 
> Interesting. The name was deliberately chosen to be similar. But I
> see that it could be confusing.
> 
> I am not totally happy with KVM_S390_BUILD_ARM64 but I cannot find a
> better name either.

Y'all need to pick *one* method.  KVM_S390_MANAGES_S390_GUEST was already added
by a07276d5d188 ("KVM: s390: gmap: Make storage keys optional"), and then this
series effectively adds another macro to provide the inversion of that, except
they're not even tied together.
