Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D9D78286
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040124; cv=none; b=pnSC4YpLZd2jDsI9IZWs5iVXR3CArgtsczaXhQ38J21T2Yy6uaQ9F99x+KbnW0QQIjlTbUvZN4OPZQ4Mz+HinTfsCyC2lsGU0tjLQxBgy8rOv5makFo1U9r4JHoee6HMCT2OPIrCMBO97e2DJJS0lfeDu64rFUY+yaVLe1XtZeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040124; c=relaxed/simple;
	bh=qIZZqXvSK2dTj4OOR4TWFpTBy0obASFjlIhXZsvJN6c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SNrtlk9SXdAOjOn0RtX+WUQWNRbj0CH/ZMiu/jqzstJ/nUzlGGlXEv7CHaYODDo5itOMATMpdT69PXxcLaGir7l7ldrsZ+MyYcouUnypWbWHIL2VFPpNk2EBnz93J8zzP+PLyJG1pbA6T45u6tLJxe89an7skQ10czaqqDwjuPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZHl+O+4U; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZHl+O+4U"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e035f7b5976so2499967276.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 07:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723040122; x=1723644922; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ghOIw54hCGsAyiOMfVcHm566iY09Y1oNz8lmYYBe4I=;
        b=ZHl+O+4UbtKWe6EDj1q2hm9N9U0m85yldB1Chh1GgQt409TY3GmW0FcT04Xy/XdAGV
         Jfgln5eICZO0ggQsNDw13fOIUtN63O2o2yOh+neyTrBrFzJ3Qx8g1ufEFWIP08Zh5TMj
         61IzCuyAPWnMZDUVONV64rUDo7iDa6RUOBO1Eet7Uk5OpT0ZpiSCI/BySf6P4QSLmwTn
         ttEkttmohPdLcnCM1WCBPEWwf/Asg86wx9PuE6HBHP59wfPhZ8hSjA9bK7ZWMe4rPde0
         ng4e1IOgQP4V/YsWQm509yPy85d92cVapa+sg8EZ5DsPgYOEIL3dAysQ9PWj+5CjqaJ6
         BRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723040122; x=1723644922;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3ghOIw54hCGsAyiOMfVcHm566iY09Y1oNz8lmYYBe4I=;
        b=jLafEO9dtKPar2a2ADVhfg+3+RRa0Pb59mXYqszA5SsiUsUeu3yEeTXBGAxgTO1PN5
         3qDG8xG6AnRMcgsDAGr6GMNRg7rWspB1JYjQwzbn9XCKPcRt7464ZeTiITnG+420Agpt
         sDbiyVankZyhGSr4uQXQdUaoBXaur9Na0AvI1LLC6OJe+3xdaJsZC3dSs0zk8vNsKdWP
         b2T0eKMy6YxVMnSJzyxYM4kYoQRyOAEGGQULB7nsrTDQzzInJXbhy7zvEr+kgDKn23HZ
         k5tiSravHWQ2Zo9cdhzin7g89ZTkBUP0BhhS+qFNwTfzIuXP7Rt0F7H1ExQWwscrDQL7
         MsuA==
X-Forwarded-Encrypted: i=1; AJvYcCVE+dXgE9ARj6DNmoctztgLttgSk69zESLS/eJvTPI6Qa8rHgYw0RK21IvIwGKQribXKWt9CKGho5tN2X8/XDngccpCKqmy
X-Gm-Message-State: AOJu0YzZEulRZF/wsUizYmrQPdsl32Q3388PzUcAFe+19L/FlYUxbg8m
	p00/jA7fBzj4GC1tVzoQ1ZKdtwBwEPx0PJpc0M6jrNAS3lpPTxLhasaarGMXIQ5zMKIGIagZ7p5
	4Zw==
X-Google-Smtp-Source: AGHT+IHbb3RmkB6VOeVJulhq/I4ys0iHpE5UZAynZajDuk/K2bUNwVgItbr4ODKjVBtTOTYTX55osDs7Uq8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1895:b0:e0b:af9b:fb94 with SMTP id
 3f1490d57ef6-e0e87c88673mr5767276.6.1723040118246; Wed, 07 Aug 2024 07:15:18
 -0700 (PDT)
Date: Wed, 7 Aug 2024 07:15:16 -0700
In-Reply-To: <ZrJ9DhNol2pUWp2M@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com> <20240802224031.154064-3-amoorthy@google.com>
 <ZrFXcHnhXUcjof1U@linux.dev> <CAF7b7mouOmmDsU23r74s-z6JmLWvr2debGRjFgPdXotew_nAfA@mail.gmail.com>
 <ZrJ9DhNol2pUWp2M@linux.dev>
Message-ID: <ZrOBdBBAQZ55uoZt@google.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Declare support for KVM_CAP_MEMORY_FAULT_INFO
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Anish Moorthy <amoorthy@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 06, 2024, Oliver Upton wrote:
> On Tue, Aug 06, 2024 at 11:14:15AM -0700, Anish Moorthy wrote:
> > On Mon, Aug 5, 2024 at 3:51=E2=80=AFPM Oliver Upton <oliver.upton@linux=
.dev> wrote:
> > >
> > > The wording of the cap documentation isn't as relaxed as I'd
> > > anticipated. Perhaps:
> > >
> > >   The presence of this capability indicates that KVM_RUN *may* fill
> > >   kvm_run.memory_fault if ...
> > >
> > > IOW, userspace is not guaranteed that the structure is filled for eve=
ry
> > > 'memory fault'.
> >=20
> > Agreed, I can add a patch to update the docs
> >=20
> > While we're at it, what do we think of removing this disclaimer?
> >=20
> > >Note: Userspaces which attempt to resolve memory faults so that they c=
an retry
> > > KVM_RUN are encouraged to guard against repeatedly receiving the same
> > > error/annotated fault.
> >=20
> > I originally added this bit due to my concerns with the idea of
> > filling kvm_run.memory_fault even for EFAULTs that weren't guaranteed
> > to be returned by KVM_RUN [1].
>=20
> This sort of language generally isn't necessary in UAPI descriptions. We
> cannot exhaustively describe the ways userspace might misuse an
> interface.

I don't disagree in general, but I think this one is worth calling out beca=
use
it's easy to screw up and arguably the most likely "failure" scenario.  E.g=
. KVM
has had multiple bugs (I can think of four off the top of my head) where a =
vCPU
gets stuck because KVM doesn't resolve a fault.  It's not hard to imagine u=
serspace
doing the same.
