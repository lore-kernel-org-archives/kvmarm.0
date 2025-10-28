Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D6A1E1A17
	for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 00:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761611387; cv=none; b=BV7rzzTWAf0w61VNmB/WIG8otYC4zvGvYA3yvEHjVq8YgOygNQEEdUXZTfYSGi/ToTiBQfXvYdvgQcS8Sl2W+ZmB2gWRA3VuPzET0Wb7gPFTJ0QuPanRG97bnx6V1UWKfZjgUsv5MQo5AO0BD/6Yqswmy0dIkwvgTfAuMU21/4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761611387; c=relaxed/simple;
	bh=qyo5vYPBXQcSiICdjzpbw4YoCeaDaAVfCf6SQjhOYiM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pp7u0Ycv8k4OPCxnEYd4aWXFIDiz0UDqMVjwP5G4Cm/F0PdawmYMzROfG7MqrJlXGJTRCJZdjpNHTxfX2KF4Cy0c1+zXHnCQgdiiBA+h+3Vzvd3mtcoZX9mhxBC4X1t4FJpKU53MejMk84p8xWtkqO7l3sGvmqwM74sPdroO+WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ItOS988E; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ItOS988E"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33baf262850so4831654a91.0
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 17:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761611384; x=1762216184; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3fZq3tbinLN9iV6tR9wh+L1TcJJLRbds3pWQbE4SVPQ=;
        b=ItOS988Eyy5FQEAEIKgERADi2ctK2M6Zn7iRYVK+5rpuzUVcpteufnhreQL0EoQqhx
         swAvPJ1N4Na1uAswSaSPKDbWxybh1w5clrHRitXdakBsm89n36+Bjxaei4ToW90YbCs2
         O7GT0nNxvsvsOGdHdqrYIPW6/JPNiNHNLVxkMTLgX+ejqJCZE+JoZlSQRbbvcEub0s97
         FSSHAzKBCz+B4UYhrRO0+h+5oRcl9UCMvFQPCNV638259/ESpskaFWRIM9ftrUNFUxdI
         EucP8w81eQnVjSL4vr1MWonxS/5sQI1NU0XU0UdAnbH52YTadfe/ZC1YCrXbBDr5/d7e
         dvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761611384; x=1762216184;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3fZq3tbinLN9iV6tR9wh+L1TcJJLRbds3pWQbE4SVPQ=;
        b=ELujvGVf1Qh3gZSYHf8+ik//iTuoFJ5wbxT7hjCerDRMvUcKd+H0N3vHu5H7onjnnS
         2AlBFm8DdKUQMgpt21BxGSH4VHyfFFkY33k/XmDyehN7tNeiOpYJDyIzdvAQssiImPLm
         GnIWrUjfHK25we5HpXKJgCeRAF/p7L/5vizI7eXBVCeTYWt7b4zujUCyn7z/eiu0vQ1T
         mgz02myoRxEcJz1D2eftDs5WbVRjo9YBkJdCkiqa2ac/0jx5fKRramkROS3L6ZkNgVIp
         X7Yrufp81Ui3/fvCqwtOvFsOQVVrm1xQ87fiHolGmzSJbiMK6OKmS1XjEU+mC9jlTWy6
         s5uA==
X-Forwarded-Encrypted: i=1; AJvYcCWtN620R58pw6a1dUw/MrDFIOWi8RH7CQyiNWDgShR04rpvF4yC2pC9FS/N6Ylaea8U5LVOIks=@lists.linux.dev
X-Gm-Message-State: AOJu0YwvOvVvZPoZULHYQ1euoCd9iA8m7qb926rOwwZRQiGun2FahMLr
	LBVhacqk3GDmyo21jvyP3ppNvutwoBNwYTZVLYEkzwKeO0oIhuEr2XEhoCl+qUcCgsgzWWaNDCA
	CrvZaoA==
X-Google-Smtp-Source: AGHT+IEcbPffJX+DPzKHtANj5YoID2qTNS+wCvJIhOFTengBDdmvUTitjaF5SaOhKDAJ4Iu3BAJZiOrVVlg=
X-Received: from pjqc14.prod.google.com ([2002:a17:90a:a60e:b0:33b:51fe:1a77])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d0f:b0:33e:30e8:81cb
 with SMTP id 98e67ed59e1d1-34027a0775bmr1898674a91.13.1761611384405; Mon, 27
 Oct 2025 17:29:44 -0700 (PDT)
Date: Mon, 27 Oct 2025 17:29:42 -0700
In-Reply-To: <59ae9957-88a8-4777-9bd2-196e8b4eb8ac@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-14-seanjc@google.com>
 <5dea4a3d-c7b7-48f0-b2d5-7597e0cd5f00@linux.intel.com> <aPuqYz3ly5a3__mf@google.com>
 <59ae9957-88a8-4777-9bd2-196e8b4eb8ac@linux.intel.com>
Message-ID: <aQAOdiSUktmAJKsw@google.com>
Subject: Re: [PATCH v3 13/25] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025, Binbin Wu wrote:
>=20
>=20
> On 10/25/2025 12:33 AM, Sean Christopherson wrote:
> > On Fri, Oct 24, 2025, Binbin Wu wrote:
> > >=20
> > > On 10/17/2025 8:32 AM, Sean Christopherson wrote:
> > > > Fold tdx_mem_page_record_premap_cnt() into tdx_sept_set_private_spt=
e() as
> > > > providing a one-off helper for effectively three lines of code is a=
t best a
> > > > wash, and splitting the code makes the comment for smp_rmb()  _extr=
emely_
> > > > confusing as the comment talks about reading kvm->arch.pre_fault_al=
lowed
> > > > before kvm_tdx->state, but the immediately visible code does the ex=
act
> > > > opposite.
> > > >=20
> > > > Opportunistically rewrite the comments to more explicitly explain w=
ho is
> > > > checking what, as well as _why_ the ordering matters.
> > > >=20
> > > > No functional change intended.
> > > >=20
> > > > Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> > >=20
> > > One nit below.
> > >=20
> > > [...]
> > > > +	/*
> > > > +	 * If the TD isn't finalized/runnable, then userspace is initiali=
zing
> > > > +	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the numbe=
r of
> > > > +	 * pages that need to be mapped and initialized via TDH.MEM.PAGE.=
ADD.
> > > > +	 * KVM_TDX_FINALIZE_VM checks the counter to ensure all mapped pa=
ges
> > >  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0^
> > >  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Nit: Is pre-mapped better?
> > Yeah, updated (and then it gets deleted a few commits later :-) ).
> Oh, right, nr_premapped will be dropped later.
>=20
> Since the whole nr_premapped will be dropped, do we still need a cleanup =
patch
> like patch 12 which will be dropped finally?

We don't strictly "need" the cleanups, but IMO intermediate cleanups are of=
ten
worth doing even if they get thrown away, soo that the code is in a (hopefu=
lly)
better state when the "big" functional change comes along.  I.e. if code 'X=
' is
easier to understand than code 'Y', then theoretically/hopefully X=3D>Z is =
also
easier to understand than Y=3D>Z.
