Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5455D3164BC
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761588654; cv=none; b=Qj5B9dweheDTHxkGSYbU29Mpuk95ri2B0fYwYmk7DrY4Nycn2mqFID3ijTR4Y8rkhdoqZuV7NkmKcrbBOg+KRlo0tdmwTyv65wIggsP3e29QNcUYzdtL2tvyHGP4/fAuyLTfdA65UZ6b9sW6lceYox+MLvMArZ3RFgEgx3OLtLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761588654; c=relaxed/simple;
	bh=qWDqTHSGtqyDCU4AAlHRJ9mq1s1hvPRErQWu8I/AXzI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=besXoQUZaBo8GS3xm2VXQhcCfANbS6INj1lQk0ZunNDFX8ODKQOsofRFao5xdz+z18ZozcuyMpC6JknBfkbaeB8vLTh70lgQ5b5/QzNJ/Kngod0z6llQPRqNzkoby3gtnC6jcBe3BzwMxz5SVExPEUxhYrfW+y3+hmjsqYQ0gXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n/UcY+aD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n/UcY+aD"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33be01bcda8so4745970a91.2
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 11:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761588652; x=1762193452; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bO0HNahSQ0zli7kg4xL2kKu/rPaiGOzpKxwGHDcn9b4=;
        b=n/UcY+aDiO8os7b7iCkKQaWa80L6NIP9SAjhOueZ+cwT27yfSzXKhF7RDUr5dPAHD+
         9eivBb+adkNuwSlo6vQ47cn3wJWjPhjofOGfp4ZyYtV98AwO9fknhygJAXqmvEYl7uJe
         76m4gITYZOpTJkCgV+0nspJrmaSupS/ofxjwmm45M6YG/8agXoq4NNrLzxHTF/yzwCwS
         TlmeuEYQrAyS5/xeuq56eJP6QUHpWC/Vg1bsObwvY0irX7Wuakuh82u5ce30lC0WUj7r
         uo9wJX70EbgiUxd0VSXBXW6kYohd7WeGmkRgRafkXqT0mja7Xpl7hUP2NSi5/TjwlC9n
         VVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761588652; x=1762193452;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bO0HNahSQ0zli7kg4xL2kKu/rPaiGOzpKxwGHDcn9b4=;
        b=wXryRzABazrDHLwmk/g+kx2BcyrSe9RIs5ytEP/VBvYf3uxXYNJDV2PmuomngZH6dH
         HBQeKO3QkwB6co15SPC2e8qTJv6MIDv6gjuPcHhkp4w92wVx4us0YVXrxMLLcTQljpkc
         JwHMMkeYmt+vkG11QduMLONtFlYJyNL9jMUdHDfO+M29zMFlpyG/2mFtkWeSGy9vnegS
         P/wd6wLay4uEhNiHpVPIkqSVh8lKF/CIpcKSO+SWG9vEeAOMvypEAiLXG3FUntM8J/UA
         c68xVvf5oFXsjxcI0UBNmcWdgA4tHdgIw/1hiT7xdXbtUgfXYni8Qhz5C9qVEXCIfUus
         ls0A==
X-Forwarded-Encrypted: i=1; AJvYcCUGE0HzQfFJCqM7FfJZZ0jhX4mnvxtl93ifSA4GZeC1EYWN7WGWbQqgwiv5kjCRc6bjv7NhY24=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw04FJOPK86VfTs15poRyfCvTRIirRp9MXXi6S9D6ZoYWRIlQL7
	+nc7TwbozOGSGnGV5bXz9zXGqpA7wIPdQTgl+IeikS3IoyLNrGljaIS+6/nsoxy1Y5dULh16WPF
	qKW9Ikw==
X-Google-Smtp-Source: AGHT+IFYM0pQ56UGeUzsOnJj3+Ow3Uhx6HMXZ6WjKUcRvfRsyB3bsUItowqHfr7m0JixZWoiV89rDaaCMlA=
X-Received: from pjbrs15.prod.google.com ([2002:a17:90b:2b8f:b0:33b:51fe:1a73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f81:b0:32e:52aa:3973
 with SMTP id 98e67ed59e1d1-340279e5fc5mr862252a91.8.1761588651707; Mon, 27
 Oct 2025 11:10:51 -0700 (PDT)
Date: Mon, 27 Oct 2025 11:10:50 -0700
In-Reply-To: <77d8a0d9541ce3fc2b2c76b58add50d152b52e39.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-25-seanjc@google.com>
 <aPtOtzGLigbY0Vqw@yzhao56-desk.sh.intel.com> <aPuv8F8iDp3SLb9q@google.com>
 <aP86sdBZxXm5I17f@yzhao56-desk.sh.intel.com> <77d8a0d9541ce3fc2b2c76b58add50d152b52e39.camel@intel.com>
Message-ID: <aP-1qlTkmFUgTld-@google.com>
Subject: Re: [PATCH v3 24/25] KVM: TDX: Guard VM state transitions with "all"
 the locks
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"x86@kernel.org" <x86@kernel.org>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, Vishal Annapurve <vannapurve@google.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "maz@kernel.org" <maz@kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "anup@brainfault.org" <anup@brainfault.org>, 
	Kai Huang <kai.huang@intel.com>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, "zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Ira Weiny <ira.weiny@intel.com>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, "kas@kernel.org" <kas@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025, Rick P Edgecombe wrote:
> On Mon, 2025-10-27 at 17:26 +0800, Yan Zhao wrote:
> > > Ugh, I'd rather not?=C2=A0 Refresh me, what's the story with "v1"?=C2=
=A0 Are we now on
> > > v2?
> > No... We are now on v1.
> > As in [1], I found that TDX module changed SEAMCALL TDH_VP_INIT behavio=
r to
> > require exclusive lock on resource TDR when leaf_opcode.version > 0.
> >=20
> > Therefore, we moved KVM_TDX_INIT_VCPU to tdx_vcpu_unlocked_ioctl() in p=
atch
> > 22.
> >=20
> > [1] https://lore.kernel.org/all/aLa34QCJCXGLk%2Ffl@yzhao56-desk.sh.inte=
l.com/
>=20
> Looking at the PDF docs, TDR exclusive locking in version =3D=3D 1 is cal=
led out at
> least back to the oldest ABI docs I have (March 2024). Not sure about the
> assertion that the behavior changed, but if indeed this was documented, i=
t's a
> little bit our bad. We might consider being flexible around calling it a =
TDX ABI
> break?
>=20
> Sean, can you elaborate why taking mmu_lock is objectionable here, though=
?

It's not, I was just hoping we could avoid yet more complexity.

Assuming we do indeed need to take mmu_lock, can you send a patch that appl=
ies
on top?  I'm not planning on sending any of this to stable@, so I don't see=
 any
reason to try and juggle patches around.

> Note, myself (and I think Yan?) determined the locking by examining TDX m=
odule
> source. For myself, it's possible I misread the locking originally.
>=20
> Also, I'm not sure about switching gears at this point, but it makes me w=
onder
> about the previously discussed option of trying to just duplicate the TDX=
 locks
> on the kernel side.

Please no.  At best that will yield a pile of effectively useless code.  At=
 worst,
it will make us lazy and lead to real bugs because we don't propery guard t=
he *KVM*
flows that need exclusivity relative to what is going on in the TDX-Module.

> Or perhaps make some kind of debug time lockdep type thing to document/ch=
eck
> the assumptions in the kernel. Something along the lines of this patch, b=
ut
> to map the TDX locks to KVM locks or something. As we add more things (DP=
AMT,
> etc), it doesn't seem like the TDX locking is getting tamer...

Hmm, I like the idea, but actually getting meaningful coverage could be qui=
te
difficult.
