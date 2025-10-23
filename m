Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00041345CDE
	for <kvmarm@lists.linux.dev>; Thu, 23 Oct 2025 17:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761240440; cv=none; b=YzATFTOVqSt/UWRD7RpeVMg2iWubP8D9Q0ItX9mqTgtjO/rO+0LnBvGx6FZ4xuheCtvnwdtwdjB0QxZXUtqL4xqjJNBVtGAcqJxked+KOBEsoMED+0tAxFLfC8n8Mjo15jLlAb/+8OfuoQQnzkkrFIIRUu1a/xN1Ax73MRqTKNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761240440; c=relaxed/simple;
	bh=XVDzXI4Y1e4iRpQIyW9vAwBiWIuzXTa0TJZpBTTKBPM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PkTfcso34yaIeuYi+n4mPr+qIzX7+OFMqY9i/0e5NzlrKhfH/LDDifTjNAKss4le0gRDqGwRyaTkuIBCtGSqQAnyfFtsKg+HxfP8DIAg8yMH4xqaPX07+2GweEoKC87nvwRtdoWPfG+31cHX4NtKarCQay8M2XLZLT6VRBO/Trg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vm4K4HO7; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vm4K4HO7"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6ceba8968dso788175a12.2
        for <kvmarm@lists.linux.dev>; Thu, 23 Oct 2025 10:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761240437; x=1761845237; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PMd4YohbYBDUY30TTRBHmO9DyPvx8MjhdR/tVFXtYYI=;
        b=Vm4K4HO7DcQ0iNQGySj3ZZiyEVBaXX2tKHbXivZ9jVaAJZMqvv9j73XEu/45NghDI6
         rPY3VKN9oOQrHmIq+niTWsrzS2rQUvRxX2KqFyG5mvnDrBHNJGAydOsvUb00B9c7jyL8
         adlRs15lZu0LiCWzIgDWd57xwWVGPigJKsjwMey84eKc7m5ZrfcuDDghqq4BWRiRpWvb
         JcttsTHbeUNQ9ah/l06HIsJEDohAI0mzknxNw1DNOgYPeFe6nkOtqg5q2I+tnVALFh9L
         FD5hozTL4hO49Z0/9c7dhwbwPaqU2h5R4P7YXKj2tfa2kl3vmMeKpVlJdPFP8iOLGXWZ
         ZXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761240437; x=1761845237;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PMd4YohbYBDUY30TTRBHmO9DyPvx8MjhdR/tVFXtYYI=;
        b=M6UaYxjosFux9yecNYxlW0GUlhinGchpQ/6D+3/X5GHqvMAILKszrBk8SQ+7nv6sOz
         U3ikttc958LGZsq8+4uFqcCdT4ZHOPcaew+H8LJ5v92rifJ1ZB+c0qiMdCvpNrzSy04/
         404F7VLYRhpDAlq5G4TFgNqBF6OqKArgKjs1EigQZSaaitJfFo59VjsYVyMYkM0tY5xD
         HaXIS3mbUPMaXq7OgUkRivi+uqbtcnQQKQBe+EbwBxWaez9Ib73bFC7E/p3sUaygiBD9
         dI/ivIazyDXmoYVua3fxfb1VyPHJZ/Xm2cPAi/RoMcgCwQysAmxvW6H3awgzV6ZwMiHf
         w0Pw==
X-Forwarded-Encrypted: i=1; AJvYcCWzj/N/FYmWi0IVJtvwv0Z1cCi3sNpMnJs6zxHxK/TfL7TVARGXlopRuLpzXoaKDWb5hjxpu54=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdNvVmsQ1zRPq8DWUJldmMYWB2RdGYdAiWuEGlrWgwgu+THpc6
	EG/9dGAmNonp4BHGUuCM8BFBNALnqmJ5lxSy2bvzDLZH+CcQh2C4TXHSvP+3RL0nn51kIrUx7vF
	m9/mpUg==
X-Google-Smtp-Source: AGHT+IFjhG//1khxmFCKdE4+6wWu9+6PA/jOl4XyR0eCgR53v+ZECkEt8twGk0B4jVNQwQCsevpreYrKXxc=
X-Received: from pjuj5.prod.google.com ([2002:a17:90a:d005:b0:33b:a35b:861])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db11:b0:240:48f4:40f7
 with SMTP id d9443c01a7336-290cba4efc9mr387536115ad.39.1761240437319; Thu, 23
 Oct 2025 10:27:17 -0700 (PDT)
Date: Thu, 23 Oct 2025 10:27:16 -0700
In-Reply-To: <707a01ee36c28863bdc6a4444a5560e9a0b19597.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-15-seanjc@google.com>
 <707a01ee36c28863bdc6a4444a5560e9a0b19597.camel@intel.com>
Message-ID: <aPpldKdiQYYnl4uC@google.com>
Subject: Re: [PATCH v3 14/25] KVM: TDX: Bug the VM if extended the initial
 measurement fails
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"kas@kernel.org" <kas@kernel.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, 
	"zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Kai Huang <kai.huang@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-10-16 at 17:32 -0700, Sean Christopherson wrote:
> > WARN and terminate the VM if TDH_MR_EXTEND fails, as extending the
> > measurement should fail if and only if there is a KVM bug, or if the S-=
EPT
> > mapping is invalid, and it should be impossible for the S-EPT mappings =
to
> > be removed between kvm_tdp_mmu_map_private_pfn() and tdh_mr_extend().
> >=20
> > Holding slots_lock prevents zaps due to memslot updates,
> > filemap_invalidate_lock() prevents zaps due to guest_memfd PUNCH_HOLE,
> > and all usage of kvm_zap_gfn_range() is mutually exclusive with S-EPT
> > entries that can be used for the initial image.=C2=A0 The call from sev=
.c is
> > obviously mutually exclusive, TDX disallows KVM_X86_QUIRK_IGNORE_GUEST_=
PAT
> > so same goes for kvm_noncoherent_dma_assignment_start_or_stop, and whil=
e
> > __kvm_set_or_clear_apicv_inhibit() can likely be tripped while building=
 the
> > image, the APIC page has its own non-guest_memfd memslot and so can't b=
e
> > used for the initial image, which means that too is mutually exclusive.
> >=20
> > Opportunistically switch to "goto" to jump around the measurement code,
> > partly to make it clear that KVM needs to bail entirely if extending th=
e
> > measurement fails, partly in anticipation of reworking how and when
> > TDH_MEM_PAGE_ADD is done.
> >=20
> > Fixes: d789fa6efac9 ("KVM: TDX: Handle vCPU dissociation")
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
>=20
> Per the discussion in v2, shouldn't it go after patch 24 'KVM: TDX: Guard=
 VM
> state transitions with "all" the locks'? Otherwise it introduces a KVM_BU=
G_ON()
> that can be triggered from userspace. not a huge deal though.

Oh, right.  And then the changelog needs to be updated too.
