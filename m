Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477FA3491FF
	for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 13:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761140103; cv=none; b=mylY+IYm+n94d4IqlCdUM0TZuw7HR5Pmd8WnDwpdBGFhNCJnEidlGQJFvE86qKdsJuVqysHQfjf2pSYWd2Rwr756JFVNqjZlZGcxtmHd7+693tRTOVUzm6eOHzzraL+MbXco96461PixtwOg6bhWvX/BG/p56eLKgoulTsvXfuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761140103; c=relaxed/simple;
	bh=P/jJZi6wFb66bekaSvMaZLe+ieWiyPItoJP4R0D2lH0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qX6XEdbuBVu7W0GCXTPMMy792HMItT/cqZ6EeUc8vtLSCILlGvJrghf6/C5dgxys4g7eo7DlpQAC0AmKaU6qkbge+Vx4HqhigMg7vTqrG90HFCc0etj4tg/q7wnloHapZHKpZWjpcePOO55MCYmCkC9zIz+t8Lm4BwgnKWoDHXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LeX83Iuy; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LeX83Iuy"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2909e6471a9so48691725ad.0
        for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 06:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761140100; x=1761744900; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YxHQuFsg5Kfr7jrrcDt2mT4NtNRBUD2QnxLoV30c9fI=;
        b=LeX83IuyPhs5NgmboSb3pr4qyA+gqExopt0KpANQHij4vnCKdO978yH39Fo9RoISec
         /pCa0YYsES1XKbTSU3Efedx3GqBoL7fuMbsm5qRgaGMNEPz1jcHxx0lFl8Q0wMJNoV7J
         5MIKzW9goiFKr0iklNwvYZKMlbityH67X6S1/x8qrskBXt7rXeR3fXepCot8gGghRsWu
         OZsugVEkQnCCaELTCOTJ2gKbw6XNA1TKo/P4zaoS/2rflE+zV6L66FNEO4RLVOhGoG4e
         un4wTPE/lt6a1InzvHNw2Eurh4NhJVTzxRlIWuXwYF0Jv3c8qnB22lMpfLcZMnO0+Pp9
         zKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761140100; x=1761744900;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YxHQuFsg5Kfr7jrrcDt2mT4NtNRBUD2QnxLoV30c9fI=;
        b=ZU9BgeXUtQv3Tvypz6OV9M10Z+E6coQd77vke4BD8yFb6+1sUv3Awo/4CQHXntW0ui
         n65AD133nagqaDyRpdF4+NxcJulm6fcQyynxAWAptKSaDlUfthpqZ4KJ+7K3BHyaGm92
         ozuPpkhMf+JemHNtnxk+t6LaaAbQ9YvR3iP5/duEecNx6N+/aZA95koIpfHLdlehb64G
         oKZetJjGAMejgAFGnwR0jc4ZqMPZvWJL7TdX3n4NYBY8U1akvXVBTIQMLl05+K8lTpK+
         TBTB2Es22b0yK63stMnnbvpBqAvDVy6mcTH8HuzYLDbbIJSnadXdz6uqT/iP235nMjck
         QDug==
X-Forwarded-Encrypted: i=1; AJvYcCXY8tLjigGF1xOS8+lwz/mTDhZ38nDtJHUq6nTCci3vYE9NSBVzo83Xy1KYDkzDNTeI+dkKYGE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzF04B5gkKCCPNbTOF/Co11nU0MHIrc6epqiJNCkYMMob36Nlu4
	YD+R37l4jmcAmH2xqmnUG4MvrZ3Qvszk9Pv5RkYMIOnPiDhV0bN3H8BmqWCCsm+fawGlBzGRglm
	WUAHMuQ==
X-Google-Smtp-Source: AGHT+IH1RQJ8G1kfYBPyhHi3StRTn5+l8DQDdgnzTzZoa85vwP0rnpijVI5aQyp6jr9CwJyFxpPG4kTH9Yg=
X-Received: from pjsh4.prod.google.com ([2002:a17:90a:2ec4:b0:338:3e6b:b835])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e843:b0:290:b919:e5ac
 with SMTP id d9443c01a7336-290ca21633bmr258670265ad.30.1761140099881; Wed, 22
 Oct 2025 06:34:59 -0700 (PDT)
Date: Wed, 22 Oct 2025 06:34:58 -0700
In-Reply-To: <aPbL8NCPCfLHIB3w@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <10A5745B-411F-4EB3-A168-0BC6CA99FF4D@linux.dev> <aPbL8NCPCfLHIB3w@linux.dev>
Message-ID: <aPjdgqHlxFOyjSKT@google.com>
Subject: Re: RFC KVM: arm64: selftest: stage 2 mapping helpers
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Itaru Kitayama <itaru.kitayama@linux.dev>, kvmarm@lists.linux.dev, 
	Jim Mattson <jmattson@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

+Yosry and Jim

On Mon, Oct 20, 2025, Oliver Upton wrote:
> > +void virt_arch_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr);
> > +
> > +static inline void virt_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr)
> > +{
> > +	virt_arch_s2_map(vm, ipa, paddr);
> > +}
> 
> This is all going to be arm64-specific, no need for indirection through
> something pretending to be arch-generic.

I was going to ask about that.  Do we want to try and provide a generic interface?

Yosry (and Jim) are working on unifying as much of the AMD vs. Intel logic as
possible, and if my wishes come true, unifying stage-1 and stage-2 mapping code
as well.  I.e. if we envision any arch-agnositic tests that can do nested things,
now's the time.  E.g. running dirty logging tests in L2 maybe?
