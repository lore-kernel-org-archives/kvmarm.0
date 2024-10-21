Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4654A1FB3D0
	for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 18:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729537072; cv=none; b=PnTb+v+KV4LSclOnsHnTkpd8iZ0DhbNpFOUcfprN+dw7HTh8i7mIgeb/Luy97Q7veRZCw+Z8z71VZozw+2Huqa6MCFuZ65uGYG/2WnNRi6i4HSAOKvLjXN1j1bi5JqQftyYYMKXgWynY4CoF4/NCUhH2ickYKzu4/WF5r2x3VB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729537072; c=relaxed/simple;
	bh=eiuskN0Rqd2YRzqsihlK78NQBES1kITJct33unB+ED8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lp40YpWjW8FlU/fnsXjrRKkjuf+/+hCzzjpZFqyXfzHX7t5jqxSeCm+/aWAxj5Qezh3F3Nl0BiMySq6+cAmQ+Q1CEDo0uTLTZA4irvKVq0HlDDdB0PUY5kMlB6YW/mLe78pSN/jdFrQ7fqXDTFndUpVreGkp7FY9gRLAQ/zMCt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZvPB1qI8; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZvPB1qI8"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7db9418552fso4133873a12.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 11:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729537065; x=1730141865; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TRc3VGGNkUkUR9ifA4nNeX0hRZiSdlXeerhUJQ+tYBo=;
        b=ZvPB1qI8j5i6QpdEtv4vSLQ/HUdXc9xYAGQZt6MCvI1whHkNGhefI5q1SU2Vrgl9gn
         wAze4IqeFCo+ozC/hF6Hi+r7P63sCR2VlW5f7ucdMZ49OibQ9hMkntGXYzre2VKfaVSW
         amSgQBLTED2PPl6dL1JP2JeEkhLOVGm4hBFVPqzkvhU8JrqIfn/jwxXtJxuulKYOzCvs
         Sz5xmTm9YWrKVnGx2aWv6nniSa8q2I0RSzHdguaxrCma3WSKBbdmXpYdiKKr3nApZRKx
         42XKIjqGzT/AWe5PXS+AiXP2TxglLf12FLgm2Bxuzd97wU/GuberGAOC4IVlpFfmIb5i
         nDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729537065; x=1730141865;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TRc3VGGNkUkUR9ifA4nNeX0hRZiSdlXeerhUJQ+tYBo=;
        b=nCE3HXjMfsLC6jWqzm4zY+OMdMrvkdaHR75yi88Ikid5z9f1Ekj4ntd/Mac3sq2ZhX
         eLjSLHxHp1UrUmoyFKx0hVsHfbhKnDQWPW+U8rWcbdzdDZols5a9tXASTQjPIQnQ+eoU
         UVxaTmEL3scyN+OcMwcLnyeUWAFVwNHVtcEyw9VUaTtGOPrc7oDHHKQMu0sgMOlNqDZ3
         rkMLvkhp8aHjnt98Fn/24g5j+8tRkwD9LNa9vZd3+wgoWKJl9KkOESTFG1BMh9UwBFtM
         9TB+gDrfBUfNg2Ig4oSYXbantNm8qaXjP7FJ5kxEIAWM6l7dzw3/AQECgVmBjGBbSHCB
         xZzQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4vRcEcfT+9KV2BJRL2Ir7x4F/d7rZRQvHDOWjG26S/kFrN2RnTHnTkhvf2uoGuzIfekaZscc=@lists.linux.dev
X-Gm-Message-State: AOJu0YziZudvQyY340hCYcFy5OxfzvtToFt5p8Q701uqwSMd4biLq7Bg
	sNaZooL8otoGDY6T3jo/NwS6W24O3fGz5gb1tLOnISHXLBgck99fCwis+PYg8scioYKFYPm4yhK
	Nag==
X-Google-Smtp-Source: AGHT+IHRYlBrX6M+NH4TUGVEqm9BFtB7q+VVhXD5EoRBvSsXa42IiMZxJc+hXyxs+ZPnB8HLQQfXC/cdu0E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:3858:0:b0:7e9:f93c:22b9 with SMTP id
 41be03b00d2f7-7eacc895cf2mr12508a12.10.1729537064143; Mon, 21 Oct 2024
 11:57:44 -0700 (PDT)
Date: Mon, 21 Oct 2024 11:57:42 -0700
In-Reply-To: <ZxYrYe/WN8XoB+fI@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com> <20241010182427.1434605-52-seanjc@google.com>
 <ZxYrYe/WN8XoB+fI@yzhao56-desk.sh.intel.com>
Message-ID: <ZxakJr_jWkU-Y54e@google.com>
Subject: Re: [PATCH v13 51/85] KVM: VMX: Use __kvm_faultin_page() to get APIC
 access page/pfn
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	David Stevens <stevensd@chromium.org>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024, Yan Zhao wrote:
> On Thu, Oct 10, 2024 at 11:23:53AM -0700, Sean Christopherson wrote:
> > Use __kvm_faultin_page() get the APIC access page so that KVM can
> > precisely release the refcounted page, i.e. to remove yet another user
> > of kvm_pfn_to_refcounted_page().  While the path isn't handling a guest
> > page fault, the semantics are effectively the same; KVM just happens to
> > be mapping the pfn into a VMCS field instead of a secondary MMU.
> >=20
> > Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---

...

> > @@ -6838,10 +6840,13 @@ void vmx_set_apic_access_page_addr(struct kvm_v=
cpu *vcpu)
> >  		vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
> > =20
> >  	/*
> > -	 * Do not pin apic access page in memory, the MMU notifier
> > -	 * will call us again if it is migrated or swapped out.
> > +	 * Do not pin the APIC access page in memory so that it can be freely
> > +	 * migrated, the MMU notifier will call us again if it is migrated or
> > +	 * swapped out.  KVM backs the memslot with anonymous memory, the pfn
> > +	 * should always point at a refcounted page (if the pfn is valid).
> >  	 */
> > -	kvm_release_pfn_clean(pfn);
> > +	if (!WARN_ON_ONCE(!refcounted_page))
> > +		kvm_release_page_clean(refcounted_page);
> Why it's not
> if (!WARN_ON_ONCE(!refcounted_page)) {
> 	if (writable)
> 		kvm_release_page_dirty(refcounted_page)
> 	else
> 		kvm_release_page_clean(refcounted_page)
> }
>=20
> or simply not pass "writable" to __kvm_faultin_pfn() as we know the slot =
is
> not read-only and then set dirty ?

__kvm_faultin_pfn() requires a non-NULL @writable.  The intent is to help e=
nsure
the caller is actually checking whether a readable vs. writable mapping was
acquired.  For cases that explicitly pass FOLL_WRITE, it's awkward, but tho=
se
should be few and far between.

> if (!WARN_ON_ONCE(!refcounted_page))
> 	kvm_release_page_dirty(refcounted_page)

Ya, this is probably more correct?  Though I would strongly prefer to make =
any
change in behavior on top of this series.  The use of kvm_release_page_clea=
n()
was added by commit 878940b33d76 ("KVM: VMX: Retry APIC-access page reload =
if
invalidation is in-progress"), and I suspect the only reason it added the
kvm_set_page_accessed() call is because there was no "unused" variant.  I.e=
. there
was no concious decision to set Accessed but not Dirty.
