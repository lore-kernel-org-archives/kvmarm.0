Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AC87E10A
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706804903; cv=none; b=FwfVy6mVyi8T2MECzzBmvW52kkqf1O0NMnN8WBaa+fjSNixRu/6rBMWQHFyptj7RogHmg74S9QOv0PZbqCO5UQPhoKaEZai5YnV2F+kkEPkWXCW1mBe9DFrH3NTcwHudU7DZapaFrmDio1/lWHqLJXl60G5s3Li9PUMW6brqr5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706804903; c=relaxed/simple;
	bh=RQMfGk2sJ0rdt76vd4PcTcu/WBOV61LRsFVxlUgak2I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y+ZZLknrQVD2FTyioVo2NUxVebHcTYtj7Bd3f/VFl3ATiMlZdnscJEHguvehCJ5aSE+kpgxGTukfOljkMwNNzZptAp05BPYyUbpvNElYsQNivzSTv2/XKFmIdH1H3Qcawl8h+j1HAWhQSgDWYdYKupmw/Nbw1kKqSsl1kPXV1vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M0B6xMgC; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M0B6xMgC"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6531fa07fso1362709276.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 08:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706804900; x=1707409700; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bfEEknfYaN1apdI2sXi9cfWLVgQqiO/RJh7exSDt4iY=;
        b=M0B6xMgCDtnRrxVo1m7JAFcI23KgOIaUPGgY5dCHHueebX+X8Z6j777DCt8dnrM1I1
         RnT9jrwKJ0NvKPLmVmOAcuIz/ZtCtL1qVBufMpBHcqBekwweNfG3u9f9avSGmO5HWHgp
         0UGNDhZOwa7Q6fCIN5UT5XyTvbeKlP4vertnJXUMOLqF5ZscT08zlFpyNXQDSS6SXABD
         3URqCyFgmraj6mydP1N0o8+0DLH+Kxq9XGVMegpaTg+19xP/AUYQ3laDPIhRDLrSKCum
         hScfDkn0x8wwUxO4yEDMDlJA3MgGJHHfy8i2B2PWP6+zym0r/PgmuSUNYy59Fs1lpOJO
         Nt/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706804900; x=1707409700;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bfEEknfYaN1apdI2sXi9cfWLVgQqiO/RJh7exSDt4iY=;
        b=FhGdVKCLmJv3XM1E/fmjccuYS8Jr0lqir7bqcpEsMi+w7aFD5/CSN+B7/ZKaqVSNao
         P/V5bqAo1hyUX9/NL5NZrOg0oOhvFsBwZqNypJLKDDlDufPujtkpndYORP1SJZDjzTwQ
         cHrctdRD9Lf48MoOgBEv9JIvegvDzj2qfnSCYCfO4MTDrH7pZfrCWtXApDRBbkbZwilw
         tFHeQRw2sEle8VGY95zNrsBK83LCOpVLB1UxG4ME5rcx+Ev7vJkjFNVae3GodFrG5Hv/
         cYSj2Q0tVpGICURifIe8Yh4s75vo/JOTIBZMBJjndfubaKXCI+qlZOtyGDn5WVkYlocl
         QScA==
X-Gm-Message-State: AOJu0YxfzRfn60dHzDeR1AJ8GDJzPSN7MF6HxHYW65/JcFAtl44dR3L9
	RsAVVhlN9Zjq89UKfVOb/5k39+v71cXx8JKyv18LvdpgOhCgssTLq7cV3y1WOmZ2bx5fVkUKp48
	h7g==
X-Google-Smtp-Source: AGHT+IEM/kpoxGnS59af2IFUsnl8Hae3asOrNvlRUbSTpkZgi2SS0WuDgKjRP6lYwDZ8+IkSHWxZ1zIjAjs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2602:b0:dc2:3426:c9ee with SMTP id
 dw2-20020a056902260200b00dc23426c9eemr184460ybb.11.1706804900620; Thu, 01 Feb
 2024 08:28:20 -0800 (PST)
Date: Thu, 1 Feb 2024 08:28:19 -0800
In-Reply-To: <ZbrxiSNV7e1C6LO-@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
 <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
 <CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com> <ZbrxiSNV7e1C6LO-@linux.dev>
Message-ID: <ZbvGoz67L3gtnHhI@google.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Anish Moorthy <amoorthy@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 01, 2024, Oliver Upton wrote:
> On Wed, Jan 31, 2024 at 04:26:08PM -0800, James Houghton wrote:
> > On Wed, Jan 31, 2024 at 2:00=E2=80=AFPM Anish Moorthy <amoorthy@google.=
com> wrote:
>=20
> [...]
>=20
> > On that note, I think we need to drop the patch that causes
> > read-faults in RO memslots to go through fast GUP. KVM didn't do that
> > for a good reason[1].
> >=20
> > That would break KVM_EXIT_ON_MISSING for RO memslots, so I think that
> > the right way to implement KVM_EXIT_ON_MISSING is to have
> > hva_to_pfn_slow pass FOLL_NOFAULT, at least for the RO memslot case.
> > We still get the win we're looking for: don't grab the userfaultfd
> > locks.
>=20
> Is there even a legitimate use case that warrants optimizing faults on
> RO memslots? My expectation is that the VMM uses these to back things
> like guest ROM, or at least that's what QEMU does. In that case I'd
> expect faults to be exceedingly rare, and if the VMM actually cared it
> could just pre-populate the primary mapping.
>=20
> I understand why we would want to support KVM_EXIT_ON_MISSING for the
> sake of completeness of the UAPI, but it'd be surprising if this
> mattered in the context of post-copy.

Yeah, I let's just make KVM_EXIT_ON_MISSING mutually exclusive with
KVM_MEM_READONLY.  KVM (oviously) honors the primary MMU protections, so us=
erspace
can (and does) map read-only memory into the guest without READONLY.  As Ol=
iver
pointed out, making the *memslot* RO is intended for use cases where usersp=
ace
wants writes to be treated like emulated MMIO.

We can always add support in the future in the extremely unlikely event som=
eone
comes along with a legitimate reason for KVM_EXIT_ON_MISSING to play nice w=
ith
KVM_MEM_READONLY.
