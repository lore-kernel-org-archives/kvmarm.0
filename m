Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB251CBEA6
	for <kvmarm@lists.linux.dev>; Fri,  6 Sep 2024 16:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725639290; cv=none; b=NIJ4EvsAI/e1ibaV6CYXHsiFGt/fA5/QAxQNqMkR0ENqFEeHzO720oD7LzsOaKWnt8vx8LPGIDvkSKUHXWcK985mVGlaLmXM5k4tsMtQaBu4/HxrWJYDxfhdRWKHsK498/GQBpFXaG3j+yCaYdgzJt4ycA+y3l6BTbw2j/BBy+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725639290; c=relaxed/simple;
	bh=d7Xo+RfZkvV5Im86rGD5nZcCUUCXRDcL9EuyMzVxPzQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m21fBxfkgqIU7JkpHY8Psdt+ongEFVpy9dP73Rzetx1TfrLryl7fpts43iE0R1o5qX4+02Efw9NWSDcjj/yGkR5l3MqljvGMYncBGSie+fRryXW7ekIa4WZqK+srEbACv/J2pS1Jg/cE7tOCuHG/ash0ZIMj7fXH34MTqUSeHks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LdPkfn5h; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LdPkfn5h"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42bba6a003bso56245e9.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Sep 2024 09:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725639287; x=1726244087; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d7Xo+RfZkvV5Im86rGD5nZcCUUCXRDcL9EuyMzVxPzQ=;
        b=LdPkfn5h1uPJuzmRIGt5ABP3mCV40qJ3u+SsgLUPklbQ5Ffgg9CyMWTpPaWAjYoGYZ
         m3JJypVHDHyIhhYKaK67oe+JfQ2FaB10wMPMD561r187/DnJdy45sAQ4V5g1uyVa3zVH
         kKBVla1PPVlaLJBBYnmIMR9EoI8p3HjH+IdB2vujXxZXH/Gc5WNf1mRk9Gne+nVorNB/
         La4vcmGeujx7ySWlLIJWbpTUaglMYgczsfMNHsDFVNlk2Squd/DQBapVQ46vp1eLwK54
         CRSrUJZ9p4YI2fpEpwXIIbHfLEruC+nCPgK1isENx6CqM7P74RqQo+HwPKylNWKzZCnR
         LNyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725639287; x=1726244087;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d7Xo+RfZkvV5Im86rGD5nZcCUUCXRDcL9EuyMzVxPzQ=;
        b=xFVGXDe7abKm49Jd7wD8v5zsKBrgFnN+N+a/PAGmbnD98jdwrQXtKfegTAxCOfVYC1
         JjfT/cEksf3WVeLuVIjqAJYmyIu327lfaQ/X6PcSRIvySDBmWf6T3swAELIM31KDSwZ7
         m5mpq9KvQ8pDaduvuH0JyQvDgfkkNB+cmnFiLsCklIL+ApoTkcYGhDH4BJGspbH1ycUc
         C/+ja4MAKbs9x0irIC1/PwecNZ+TKADiXFacyRwhfR2wulHHXiie4LOWHUzUJEmGuUDM
         7HpJAEQNwAg6c/eSMlAM7qq+K5kJQtRmnSjIJQIcSadbp9cULci0STzmjHCBXfpdjHjk
         VGEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxxWSYKbdIaXBdCM9dvCqx8B9xw0JEAcYmOyRduSDM9RBSHE1WEih5k8Xxh5tiMogA2jc0raE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz93NKIUgjFdEoI3/Ka3Z72z1lTVDQ54wqYKW4isGzn6Iwt9m8E
	SVFGq97qhwy01qThOVR+W4TIDZrwIVkKUir1zbHbqIyoxtNmGYh+2kY5UZC4ccL4nfJXlBn5QAO
	5l11x099ky8qkZXJ7FM8oDBP7m+dygOiM/Akl
X-Google-Smtp-Source: AGHT+IFv++mggnfzy5t3bb9fWZkEUp45jrBIXinNKhaV4bb3A0qs16A2pUmUqjVrnmxrsaDxzWbJOV3LKYwj01XAx2w=
X-Received: by 2002:a05:600c:1f0b:b0:426:6edd:61a7 with SMTP id
 5b1f17b1804b1-42ca0d73c41mr990575e9.7.1725639287225; Fri, 06 Sep 2024
 09:14:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
 <86a5iw3ri2.wl-maz@kernel.org> <fec60c7f-0cc3-44e2-8be1-09c120e8523e@sirena.org.uk>
 <ZowGFl/1AEuevh96@e133380.arm.com> <a3f2f13e-be22-4a09-a8a6-5faef818defe@sirena.org.uk>
 <CA+EHjTyCvG2KL=LPhbAf+Wo66QoC_EMk1xn+R9X-yKunHQ-JhA@mail.gmail.com> <Ztspjf0SHx7nz2lV@finisterre.sirena.org.uk>
In-Reply-To: <Ztspjf0SHx7nz2lV@finisterre.sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Sep 2024 17:14:09 +0100
Message-ID: <CA+EHjTyjVMw5CtEiLoZzvnnano94UGx_URhFBd7BRYm89K+XmQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] KVM: arm64: Fix underallocation of storage for SVE state
To: Mark Brown <broonie@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Sept 2024 at 17:10, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Sep 06, 2024 at 04:35:29PM +0100, Fuad Tabba wrote:
>
> > > > Can't pKVM just hide the non symmetrically supported VLs using ZCR_EL2,
> > > > just as regular KVM does for the guest?
>
> > > > (I may be making bad assumptions about pKVM's relationship with the host
> > > > kernel.)
>
> > > That's one for the pKVM people.
>
> > Yes, but that's not really the issue here, unless I'm missing
> > something else. The issue is that pKVM needs to store the host's SVE
> > state too, to be able to restore it. So hiding non-symmetrically
> > supported VLs for the guests shouldn't be relevant.
>
> If the host kernel is also running at EL1 and it's only the hypervisor
> running at EL2 then the hypervisor can control the VLs that the host
> kernel is able to access?

Yes it can. But do we want to impose limits on host VLs when running
pKVM that might not exist without pKVM?

Although AFAIK, such hardware doesn't exist in practice, the reason we
went down this rabbit hole from the beginning was to ensure that we
wouldn't run into problems if it were to happen.

Thanks,
/fuad
