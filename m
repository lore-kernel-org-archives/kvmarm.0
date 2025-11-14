Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FBA22068F
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 00:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081548; cv=none; b=t0dSGlVZqzZk+FmUnDryoqaA3CsCDvhNyR7MVspuEYOpS5m9ygyelEFD7f+nijE7ORaSmB5Tl9vqL/MBDtk544fzOOKmUiVgv/RXJciQxj1NFQrtWabIsAC4kH8Hdh62z9qv9hC3/daGb3jbOQ318mMAvqf942QucmmB/asqcwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081548; c=relaxed/simple;
	bh=48fvNpSUR/tSKUH5jpJzhHo460fRbXqe8GajHmRtJUs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WcXQsZFNIaoiril5iM+E3ExDg3WgTjlU6ffoQ+ZbNFIXAvHXE5/2PxVBjtCy1pF8PbVuf/lsV555hKBJoAm+B2rX8IWTVTxwQ6fNGTWf1C0o+ENPlFBaIsChSymerCQwrYttznFgjsCRepcMIgvps9LTB6mmoA9SZ6pibdcOEhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bbOlMFZb; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bbOlMFZb"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-bc4e9808b63so790552a12.1
        for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 16:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763081547; x=1763686347; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/TPA+SbvqNREHpFcNdmFscbiex0UCXC+hEdJT9/ovnQ=;
        b=bbOlMFZb7X4jSM6ME11Lnic75OY9Y7TetvCZtGO6H6SV9s+smOg7iHn6phiP/c/5DX
         HRIupQ1Tn6DCU/N6eFRHypBgdaXlcK/DY89M/VAoGwZI3Pmr1WhfnR3l8NXIuCWbzY4j
         dl/T8PzHZGVLSMuMclmyq1MPBjkQsBzG+wW1xAeGp89rXbwdG50L3JmqFokfDmigfOtE
         YmDDEL9HzwEznlWa82ipMh/vr88Z4opmSawCLPcQ02Hvf3CnQ2gJuD4nCT9s/SL9W0ua
         34709SIVTje3jIWnV9d10tYFVycTr049Bjv4f/GKkWs/rxwR1ppftkzF/0QLs8uoGs7F
         XqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763081547; x=1763686347;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/TPA+SbvqNREHpFcNdmFscbiex0UCXC+hEdJT9/ovnQ=;
        b=ilvPT8hpmXPF79PVP/7lfWezT033rQh8YrdXYXDAB5b22TqowoibPrzYN0DplUrVSk
         Vv6ybzSQ6HoMnQbY3ee57U+JVeMzi0sZbMJIOwX0kPH/UNluZiN8Ai+ouT4YAIRFjKut
         8J8APtPON2XMx9Y9F4fvomKNFvkprNBs2wUiwHFIIgopThewVNtVxWgLTNDqN6GisjIe
         wstYhoObULlRwArU76S8JFZIDcIKyFsMuH0Q4H+XCwXK5gUxlPFnWYncJkMFlhnGo6f2
         464BcdxTTFo3c7JHIiQZeUocgkbW3DaFHOnise0M/nEi45hW1OU67Sd7Bf9tYeBjQAme
         +xMg==
X-Forwarded-Encrypted: i=1; AJvYcCXxbgHnxK9GyOSU6sFrm69VEmpcAR0g+qyYkB8uSXoK3OQmtwN9RnF2/mVX/uoG/2k89aLIPqI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5UqyDEizGJDVRfDihPqfPEI8ZKRMOmJVdqiTKmS1QFNiWUD/P
	X3DDiTZV4P5Ol5Jgi1A/azw7//DSQZgQ9LFNT3Bjfj4DAROSaTACefvCFn9eMyW5+BHqYjQfqUJ
	FCu3ltA==
X-Google-Smtp-Source: AGHT+IGLVWzZcFvlcari672fVuzY1cTHp2qT0SnCsSIHeNMxH1YcSp/U/Uf2KDzI+67wEBxE6n1syvNyYxc=
X-Received: from plgz16.prod.google.com ([2002:a17:903:190:b0:296:18d:ea12])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c5:b0:295:2c8e:8e44
 with SMTP id d9443c01a7336-2986a76bc1dmr11720965ad.59.1763081546590; Thu, 13
 Nov 2025 16:52:26 -0800 (PST)
Date: Thu, 13 Nov 2025 16:52:25 -0800
In-Reply-To: <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com> <aBPhs39MJz-rt_Ob@google.com>
 <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com>
Message-ID: <aRZ9SQ_G2lsmXtur@google.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	James Houghton <jthoughton@google.com>, Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025, David Matlack wrote:
> On Thu, May 1, 2025 at 2:03=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > On Thu, May 01, 2025, David Matlack wrote:
> > > This series renames types across all KVM selftests to more align with
> > > types used in the kernel:
> > >
> > >   vm_vaddr_t -> gva_t
> > >   vm_paddr_t -> gpa_t
> >
> > 10000% on these.
> >
> > >   uint64_t -> u64
> > >   uint32_t -> u32
> > >   uint16_t -> u16
> > >   uint8_t  -> u8
> > >
> > >   int64_t -> s64
> > >   int32_t -> s32
> > >   int16_t -> s16
> > >   int8_t  -> s8
> >
> > I'm definitely in favor of these renames.  I thought I was the only one=
 that
> > tripped over the uintNN_t stuff; at this point, I've probably lost hour=
s of my
> > life trying to type those things out.
>=20
> What should the next step be here? I'd be happy to spin a new version
> whenever on whatever base commit you prefer.

Sorry for the slow reply, I've had this window sitting open for something l=
ike
two weeks.

My slowness is largely because I'm not sure how to land/approach this.  I'm=
 100%
in favor of the renames, it's the timing and coordination I'm unsure of.

In hindsight, it probably would have best to squeeze it into 6.18, so at le=
ast
the most recent LTS wouldn't generate conflicts all over the place.  The ne=
xt
best option would probably be to spin a new version, bribe Paolo to apply i=
t at
the end of the next merge window, and tag the whole thing for stable@ (mayb=
e
limited to 6.18+?) to minimize downstream pain.
