Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04574EA370
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788453218; cv=none; b=hmp3dLxZan6OY6Ip+p7gxdCKFXx3zjzG6A+W2Gu3Jd0Auk5r8A6i96JTj6kFIGQzK8e7Zr3THGjjMD2YGEVzlp9vrIthywk/dJ4o/OGjZUr98i3LuwZxPbj2/7nnMtjorFX83tsKAgRPufhrcSc4Jn9boYOLV2BbQddoOYanxtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788453218; c=relaxed/simple;
	bh=J9DTYWyQiUh6lX22wglRoT5QWIUixAxZgYaHJuhSa4k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EFPQWuqXfwx5LpYHmdE9Ebbl5JgePaWV2AJv+8lcus+l0iDTcsQyevR+o+FRpcU4mYjobSNuVdLyN5su6o/uMPCIxflh3iNc7xbFsNXltXwRO3+fMXYrsI+R+MDwr/Wu2rrdO9znI+x8hFED65pQfhP8vd3gWW5VTluYixtqJII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lprgHt0M; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lprgHt0M"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d7443e0f0bso168615ad.1
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 09:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788453216; x=1789058016; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yud1zWjg0T0unucnpCnDX+16TCQDlpqp9KH31E+tKFs=;
        b=lprgHt0MdhZ2L5UBKnrsRtDi1Robz+BgkeEtwiOaGnv1nPnDIfsaLbMR4ltdms/1Dp
         D3hfxFWbBy2i5K6vGHjsAQLQjm8mUSFCxIRTnHszw68CpFhPnlgTjgyt5W2oY35rORKg
         S7UQA7jg7Eao9fZinMY7trcxG8mBYioGVO1lebry29423EULoQJgnmiO+luPkdwHMq1Y
         Q4aRBJoCnAD1ysw/5vFLfxqOLCdRWMH/rfS9UursPIFwd4lGJFBFsFVL50epEOmBVsos
         9WMJD8iPt9+N62GtZIvS7BPAKd2gxnWxsV7JINW/KjYg5m6dSXjFlJxuNzWVFYa0iQTM
         yTEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788453216; x=1789058016;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yud1zWjg0T0unucnpCnDX+16TCQDlpqp9KH31E+tKFs=;
        b=QJtgmX1Ly6yqdxOT14DADTi3MXBsDSlJ7yMndoTupeCR0w9lNG4MEMJ+JLplRhROCu
         rIBSd19dIAVTacTGYL2Gk9Tf6ymmaW6rld9UukE8kG7Ji0+8+Ksu1EEbv8/oHyYqb8eU
         IT7otLb9hLBfF1+ghXqp0ZhX2mR8k38GU2VuIfDOfcrvKxYOKsH2effHfdp+EKne8sk2
         RKQdH29wnAYOlUUECCNF7XSGLR/KlKlEbUmdmY0qWCeSiuu9tc4lUcVXfChHFw5Xc2u+
         +4Uo2fyb3Z/v1CdnP15JnjvEHe8UrxyQcsBSGclwyrRS4QSVugVZG7RTCNnmcohAzHyn
         2OGA==
X-Forwarded-Encrypted: i=1; AKwUvBxXbLTUpu+OuVPawWpfLYVuUv5c1b4ZD3AkctlmWWHzbEZsWocVZ5s9wJpqvGyNKp+ajAfr3hs=@lists.linux.dev
X-Gm-Message-State: AFuF++nmm6HDO2TbVbL08gth1n+giVW8f5BTOeE3Sfalqh1qZtMGbxQh
	ic9b2NmMf4WLNbbyiPwuRm2Xzft+K4fFALYVWDyyJlU21KUvrwBpDJLqRKdgM3kG+xl8/ITOR7p
	LiK5MvQ==
X-Received: from plcl4.prod.google.com ([2002:a17:902:e2c4:b0:2ca:ceab:34a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:9cf:b0:2d8:d4d1:313a
 with SMTP id d9443c01a7336-2db12634535mr3213635ad.17.1788453215940; Thu, 03
 Sep 2026 09:33:35 -0700 (PDT)
Date: Thu, 3 Sep 2026 09:33:35 -0700
In-Reply-To: <20260903154317.246414-A-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260831144802.834315-1-seiden@linux.ibm.com> <20260831144802.834315-24-seiden@linux.ibm.com>
 <aphMx5hsoXwIpNjt@google.com> <20260903083857.33034-B-seiden@linux.ibm.com>
 <apmHrnxRLl9BuVhn@google.com> <20260903154317.246414-A-seiden@linux.ibm.com>
Message-ID: <apmhX8H-WUc3U4_N@google.com>
Subject: Re: [PATCH v7 23/23] KVM: s390: arm64: Add KVM_S390_ARM64 Kconfig and Makefile
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
> On Thu, Sep 03, 2026 at 07:43:58AM -0700, Sean Christopherson wrote:
> > And FWIW, while it might seem daunting, from my perspective it's not actually that
> > much churn to do things "right".  Provide KVM_S390_NATIVE, and then have KVM reflect
> > the "weakest" of S390_NATIVE vs. S390_ARCH.  I.e. make KVM=m if either of the "real"
> > KVMs will be a module.  That requires some creative shenanigans, but it's not hard,
> > just weird.
> 
> FYI the first versions of this series had a 3 configs approach very
> similar to yours. 
> 
> IIRC it was not so much the churn we have in (upstream) kernel code but
> more on the distro side and to everyone building the kernel in their
> favourite architecture (s390 :))

How many people are running distro kernels on s390 hardware?  And how many distros
actually change the default KVM settings, e.g. to build KVM as a module instead of
baking it into the kernel?  My guess is "not many" and "almost none", i.e. the
actual impact on downstream users is likely miniscule.

> Suddenly the KVM config changed its behaviour (effectively becoming a noop)

Not really, because "KVM" itself is inaccessible (well, unless someone is hand-
editing .configs or generating them by script, but that's their own fault).
E.g. upgrading to a new kernel will explicitly prompt the user to choose for both
KVM_S390_NATIVE and KVM_S390_ARM64 (or whatever they get called).

> I am starting to think that having no separate config option for arm on
> s390 might be the easisest way. Just KVM and guard both modules behind
> it. It reduces the config space bloat and I do not see a reason why somoeone
> should only compile one KVM module but not the other. kvm-arm64 won't
> load if you do not have the hardware anyways.

Because there may be an unforseen need down the road?  Smushing things together
after the fact is generally easy, pulling things apart without breaking everything
is usually much, much harder.

> But I am not opposed to the x86 approach. Just thinking loud.
> 
> Anyways, I am off for vacation expect a reduced reply frequency from my
> side :) 

Enjoy your holiday!
