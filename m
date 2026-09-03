Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAD34DF4C7
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 15:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788450879; cv=none; b=ukUxr80YtZLa4gp++wgnATG+o0eB5s3PjQs6Zqh3aEHBnQPuJr+DcFtrnT29PEoYf1rmJ5hTCrmu/ouhgQpLNur/xN+Oo4KgcBrJ+yF4m7BfDzj5hKiz32Otz4cWoCo5w/YLQ0jkzauSXdhDdPbXsi/dzSYripcbu5QZE4/b+jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788450879; c=relaxed/simple;
	bh=Kk2AD3UOwPSnwmgTVWy6P/2K5EFdMfMyACv+LM8k68Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M81C3tbdQvjzhkFhRvppvrYZp9jfvRgVa5/evCAXD9AtFespe5ryh1m+5kVZ9wy09JCXO8XwfmuJ/1MrtTHrcOwgsbUz/82IuXdKZNPFnFZzDCb/CCP+Bhc5Bp21gkvBUQESyDAbcTKLdlFWouIO0ZZs3/2eYauiHFyYeIqs1Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gh08Vkr+; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gh08Vkr+"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d54187d8b0so68898075ad.0
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 08:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788450878; x=1789055678; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8mGifk9h8LIddg9L9JpNR126tGysvi+0g41edfZ4g+M=;
        b=gh08Vkr+TiqZIdjXe+oPd4Db7E+mKTiahH7Rkh6MBlaTNZpbuMTpjmub4kj8wvyfeP
         Nn0jatxOxtzHiYYEa+sBMk6/4xRV0jdYUo6Bm/XnAfuT7/I52NRQtCnLmRqS/7gse2hC
         c9ycjqKX9BQHcvADgsTWWqRX5PW97eitt6Nux3zMmPWMPbbpaVbIyQ1IPNg1YhxNFdXh
         b9/sisLovUbjtE4lM5yAtZ+rCqg6ga3+l3veFMczkXEoW4a2quWxp4DYbwB3EQomeaLx
         KPFu1XhNjFuzeLSisrRhKM+RHP5vnRDG9tGELetA8mX0LqfKMlyTrMmG+Fy4HO7Qwe19
         642g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788450878; x=1789055678;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8mGifk9h8LIddg9L9JpNR126tGysvi+0g41edfZ4g+M=;
        b=akOF6elYRtHUpjRR5jxueblG/M9wzdgKu9DSguER753X+AzIcXzDp/uIghLfukzc/A
         PvmN9/owFkuSlBwBxpA3XqN2M9FMwiDk63Y+r6tuJSh7xVEJTtXZ5RetKta+XIRAx8Um
         ciLHWapChH1mIXYIzOGyyi9YnIkocIKmIwCF/Gf6PpC5NbhJvCQyWd0SuorCmi2noATr
         Fndk2/hDlBV86QFBcnaseGhXg0wZAywIYXuSbSakOTMxISwJ4Pp8fWBmHtQ3af9Q/Ygx
         40iP58uLrK6T4YcXqEz8WHqjgCudWE5ADq1AgJARfas9uqMupBDlW24bca62I0Sn+TiQ
         fgMA==
X-Forwarded-Encrypted: i=1; AKwUvBxYRvxKmKtUIRASYENuHOaXQ/OlygRI0HbG8p5yZPj10adiGC8PMc6JLFZoZID2bHQze0Iv4Yk=@lists.linux.dev
X-Gm-Message-State: AFuF++mCzcz0nOISu8IriUstvsAIEOjcSL6UDdrdlkNGGQLpxxB9VcHv
	b56G1x4TyVlY2lXNTiwxVLfyHmwDYuzZiOPj3qlJSwSSbJwMuDHMhOxFeQPgMyTRJSqrUylu0p2
	EhNXbxg==
X-Received: from pgp23-n2.prod.google.com ([2002:a05:6a02:62d7:20b0:cb2:563f:d136])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7d02:b0:3d3:ae50:97cb
 with SMTP id adf61e73a8af0-3da35f9b1e3mr1317921637.24.1788450877399; Thu, 03
 Sep 2026 08:54:37 -0700 (PDT)
Date: Thu, 3 Sep 2026 08:54:36 -0700
In-Reply-To: <19d4feb1-d703-4c62-8622-a6d5e9d6394c@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260831144802.834315-1-seiden@linux.ibm.com> <20260831144802.834315-3-seiden@linux.ibm.com>
 <apdweRfqt4dTxcU9@google.com> <20260902075028.231001-D-seiden@linux.ibm.com>
 <aphLXQL1H2zYZgTi@google.com> <20260903114241.33034-C-seiden@linux.ibm.com>
 <apmEi1NmOUvmUBFP@google.com> <apmFClPZ2WcDINmT@google.com>
 <apmIGgMEN8w-kQAm@google.com> <19d4feb1-d703-4c62-8622-a6d5e9d6394c@redhat.com>
Message-ID: <apmYPMMPCNzK9ZEA@google.com>
Subject: Re: [PATCH v7 02/23] KVM: Make device name configurable
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
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
	Suzuki K Poulose <suzuki.poulose@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 03, 2026, Paolo Bonzini wrote:
> On 9/3/26 16:45, Sean Christopherson wrote:
> > > > Actually, thinking about this more, what I've proposed here, plus the pattern of
> > > > #define-ing macros in arch-specific kvm_host.h files, should suffice.  For things
> > > > like __KVM_HAVE_ARCH_VM_FREE, it absolutely makes sense to #define the macro in
> > > > kvm_host.h since it's very directly tied to an arch callback.  Whereas with KVM_MIO
> > > > and KVM_ASYNC_PF, because they enable compilation of C files, it makes sense to
> > > > define them in Makefiles.
> Ugh, defining CONFIG symbols in Makefiles sucks.

Sure, but IMO wrapping entire files in an #ifdef that comes from an arch header
sucks more.  And technically, these aren't CONFIG symbols.

> I don't want KVM to be the. one that does things differently *once more*.

Too late :-D

arch/arm64/kvm/hyp/nvhe/Makefile:ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMIO__
arch/arm64/kvm/hyp/vhe/Makefile:ccflags-y := -D__KVM_VHE_HYPERVISOR__

And I think there's value in deliberately being different, because CONFIGs are
kernel-wide things, whereas the thingies in question are KVM-local macros.  I.e.
IMO, having the behavior stand out is a good thing.

> I'd prefer to stub out the contents of the .c files instead.
