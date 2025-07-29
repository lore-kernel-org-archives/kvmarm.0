Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E181921E0B2
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 23:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753830514; cv=none; b=qnSqQAOsaTYv172QQ4E761+Vu2WC/S6OzHcnx9Bs0U/BKix3rxLFJNlscLtoldKCYOVNjJO6S0j6QgSB0vui38Ti/C/b8zb//TuMwtPGyhb14hwOAMpO4g38chYqcZwoqpP+fiD3P4tHhWRSGIR2tCg4c8khmfbwFt857wbttWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753830514; c=relaxed/simple;
	bh=0qJxsC49CDR508iKW1WBl6QLhRYxBufKIgrL6bgW4pc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YEbZQqWm8NK50BMDIib3I7YQVMj+gIGSYbpOVbWoo2P2hiyVxZv1WSqpxxbBUon1mAHqdOgQL16JoThNfTdvaleN6x19VVozYJwqyvkWfFhXpFp1/FeA80vLioLnYFEROK2IJ4aodFpCYAkG6lg0vEjmY6HwJrqFJdOm6r5Zv04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zhJLO7lH; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zhJLO7lH"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-237f8d64263so3707995ad.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 16:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753830512; x=1754435312; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LqZ3rHUmVe6G0p0/31oKw+qMwbPcZALS7DvYpljMN9M=;
        b=zhJLO7lHiphn2NzOsgHmoAVgsVt/Drssik5uRAFPm4oVpkojN5rGx4i+wg0xRm0VoY
         uWH1D6HAUU5ATaq08aZXcanY7RInWdiEr5zSqGCBiiTGuggWwp/+HiSOT3XhObqOL5sM
         88nX4CBM0c3DJgK3omEy1l4h8s4ifztAZIYfev5IH4Mn8kDfByDohe9oDQvExpfquX6l
         qwp6CHIb3aX3c/1R272z4cCxJv8tT3J9tquXfXrKmm16AKLW+Uj01Afh1ztx/vSXxOBx
         hEGRhY7W9Y+xEJmmoqep6yKtVGCjEoxrQfP5YcOI62CZvDcOxfRqFTyV9GLifQELsBOV
         eEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753830512; x=1754435312;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LqZ3rHUmVe6G0p0/31oKw+qMwbPcZALS7DvYpljMN9M=;
        b=Ibuwz7zN1Ch4wBSVzOPUkml7qbBfNjorTgpfCKRw4EG21/XrDMSN7HQA+8masu2vLV
         w7aAaXMn13kSDzxKDHVSV52ksKnf2vuld8ZdFKt8m8lCEF4W6WqMOi2P9+oTgyL/0CLb
         dPvb1UQTvPEy3toR/zHHWv9mfrWRLytGz7HdR2f/Htf4u2AQwmmfPJxjuPi8WPJeVvvv
         xl7kT+oy+xTwI5Vceph5X2mBMceKnEfepUJy3rsQdczHbEuRKNHh8hl2OAoF2JfSJcTK
         m+KLkCuRGOrmG+On6ICBCfTW/afum8UNIvIk6aGVA4ryXNSS4dSv5ji17t20nKZpRMRc
         mQTw==
X-Forwarded-Encrypted: i=1; AJvYcCV7PVEYs0ps+tW4OIZ/JyhejWQOlVecnKC+G7x4Ozs69ASsVjbApKPU+JhCCRB408X2StZTXeI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUKKYLq7FFuQXAAlRE25S7B293WgTtqLdvr9WGme8VVJzlpaSh
	PFKIR38oKef9MgupcW606zA5m8RXPOqX7it9tqhDtk/anWaZRC3HRQ6RY1E+gXXq9rusSecSMAq
	Q0eh8xg==
X-Google-Smtp-Source: AGHT+IEyEA4YX1TwqE1OHkPIShxbjzy59E1nb5MsO32y1ZAQO9ZQMLAuLwnLMldTTuOlaQTIYiJv0rnX0uU=
X-Received: from pjpo16.prod.google.com ([2002:a17:90a:9f90:b0:31f:1dad:d0a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc45:b0:240:3915:99d8
 with SMTP id d9443c01a7336-24096b2f983mr14218495ad.47.1753830512332; Tue, 29
 Jul 2025 16:08:32 -0700 (PDT)
Date: Tue, 29 Jul 2025 16:08:30 -0700
In-Reply-To: <e45806c6ae3eef2c707f0c3886cb71015341741b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729193341.621487-1-seanjc@google.com> <20250729193341.621487-3-seanjc@google.com>
 <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
 <aIlRONVnWJiVbcCv@google.com> <e45806c6ae3eef2c707f0c3886cb71015341741b.camel@intel.com>
Message-ID: <aIlUbpQlYqaSO6wr@google.com>
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	Adrian Hunter <adrian.hunter@intel.com>, "maz@kernel.org" <maz@kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-07-29 at 15:54 -0700, Sean Christopherson wrote:
> > > The vm_dead was added because mirror EPT will KVM_BUG_ON() if there i=
s an
> > > attempt to set the mirror EPT entry when it is already present. And t=
he
> > > unaccepted memory access will trigger an EPT violation for a mirror P=
TE
> > > that is already set. I think this is a better solution irrespective o=
f
> > > the vm_dead changes.
> >=20
> > In that case, this change will expose KVM to the KVM_BUG_ON(), because =
nothing
> > prevents userspace from re-running the vCPU.=C2=A0
>=20
> If userspace runs the vCPU again then an EPT violation gets triggered aga=
in,
> which again gets kicked out to userspace. The new check will prevent it f=
rom
> getting into the fault handler, right?

Yes?  But I'm confused about why you mentioned vm_dead, and why you're call=
ing
this a "new check".  This effectively does two things: drops kvm_vm_dead() =
and
switches from EOI =3D> EFAULT.  _If_ setting vm_dead was necessary, then we=
 have a
problem.

I assume by "The vm_dead was added" you really mean "forcing an exit to use=
rspace",
and that kvm_vm_dead()+EIO was a somewhat arbitrary way of forcing an exit?

> >  Which KVM_BUG_ON() exactly gets hit?
>=20
> Should be:
>=20
> static int __must_check set_external_spte_present(struct kvm *kvm, tdp_pt=
ep_t
> sptep,
> 						 gfn_t gfn, u64 old_spte,
> 						 u64 new_spte, int level)
> {
> 	bool was_present =3D is_shadow_present_pte(old_spte);
> 	bool is_present =3D is_shadow_present_pte(new_spte);
> 	bool is_leaf =3D is_present && is_last_spte(new_spte, level);
> 	kvm_pfn_t new_pfn =3D spte_to_pfn(new_spte);
> 	int ret =3D 0;
>=20
> 	KVM_BUG_ON(was_present, kvm);

Yeah, I don't see how that can be reach in this scenario.=20
