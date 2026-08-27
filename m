Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475BD477E38
	for <kvmarm@lists.linux.dev>; Thu, 27 Aug 2026 13:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787838305; cv=none; b=b9P5c1yYzf6g8LaFvikTPa645iMYnc6i0gwh37vkpWOv5QtGnu0ckFBdTQfFdzHJl3v7WfpdoXTX87f/bzxab2XVF1C8aFcKetJGNzqLAaWTqc63UcinNwesaOA0ekw/Gmz+0PPxDhpF/MOwZOnaTAwplGvpmAUBYVsiUUgPOEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787838305; c=relaxed/simple;
	bh=ilfcpqGhMAw8LbFI4W31+iK74ySKtrAzBZKjNb2ZM+I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WGwE6mF+OCiMhFIA9DtfzIz8B9xviT1CSA5oRmg6nfL24xSKSPsR3AVM5m0D5twXOQ+p5KXWGcId71JtCZBennG7VeBgqzFaYR9Nf0nymTTZjCv3eL99lAlFbr7JKrUCDBja8Z+yByo1pDdQRBW1X556/gP8HsNe7OpCJUdeKKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wh9dn0eH; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wh9dn0eH"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cee1ec30f2so29702005ad.3
        for <kvmarm@lists.linux.dev>; Thu, 27 Aug 2026 06:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787838295; x=1788443095; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nNAW6+hrn+16rrcmMbrTH4xe0eQT0GEx+FDl+aEbt18=;
        b=wh9dn0eHV8XfablhdGx+kPSiMqI+7z4y2KxCuFCgTAjfmgbE8MOpiAHfU2OQNhlDu9
         OijBkda8vjzLSkqXvmE3tT2i+fLz/Bizbp28mdzPz/nbes1wC9EhD26iJ4NBejj8y1r2
         QMCSDmPWA6L3lim+X842qOz7UiSAvrGfSnBmqn+yK3VvI/HSylpO1fXhUIfDtLsFNfOq
         yujJMeT0+hUrP3Y5PVHwV9V8BuSNPuljiIRna2Rou/T8iK9/+hKXXxzdjZ8LcTMIg5pq
         1VuPFdEGFt0vxVKLM5J2YPzgmA0WwpTNA5Y5GjsKz/rJ6N3jPDNSTlwO/ZA4Qik/zYSA
         8log==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787838295; x=1788443095;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nNAW6+hrn+16rrcmMbrTH4xe0eQT0GEx+FDl+aEbt18=;
        b=O+m6VLVRQy7Uh3wsJtn5i/GtaysB+Io/FPL6THsQT3HgRiLsUwO7TFEXL6Q5m+4hZ+
         oAWmghACNEc0uY1uxP2OZh0oNFjY0aOI+evyzmD4BHkjGE4h262nGz8Zid50/GVZTJgv
         VWfinA0xVwPb8JpYAoXMaYClOc+upaziYOygNLyZpo9AwhuZ7REjEQVG1k0xPutClh9r
         ALlVORc9AnmkxFV0nNB73uFDD3TuuunkfF5TZHBAdmrey6f/xPeKLj7XMtv4Ev1bjtCC
         iMlfFAIAC1eigr80lN2MPoNoP6uNyImEO5F6jfWmn+v+iL9UwYiap3dhdZM5jCz4xJAW
         tELQ==
X-Forwarded-Encrypted: i=1; AHgh+RoXXTlaM6ZG6AQMgYvkWC34c9RbgEkDs+UylzcwjGI2cPcaMkDsvJ33/4AXb9DUzYEOFfNzry0=@lists.linux.dev
X-Gm-Message-State: AFuF++lnMROJ6VFbSf/R/fA7pBTNEEH1EygFLwv2oiU5IrFLsQYX3FtY
	EvY/IQE1QcPlS4oaV6chbDdkbknu3WrfEgsnvC1GjxkTwlo3TmPfRql7QOg4Tls+76xBJ9RTioS
	7S8mlpg==
X-Received: from plq8.prod.google.com ([2002:a17:903:2f88:b0:2cc:611f:4a53])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf0f:b0:2cf:ca89:499d
 with SMTP id d9443c01a7336-2d707ac86ccmr283750715ad.7.1787838293974; Thu, 27
 Aug 2026 06:44:53 -0700 (PDT)
Date: Thu, 27 Aug 2026 06:44:53 -0700
In-Reply-To: <de6deb5a-5ce8-2acf-01b8-9d597b2e3769@loongson.cn>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com> <20260826230511.972824-3-seanjc@google.com>
 <20260826232224.782021F000E9@smtp.kernel.org> <ao946gGsIkSkEwAs@google.com> <de6deb5a-5ce8-2acf-01b8-9d597b2e3769@loongson.cn>
Message-ID: <apA_Vfl0Rqyk0Ii1@google.com>
Subject: Re: [PATCH 02/20] KVM: selftests: Bump the minimum GPA for page
 tables to 0x200000
From: Sean Christopherson <seanjc@google.com>
To: Bibo Mao <maobibo@loongson.cn>
Cc: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org, 
	Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026, Bibo Mao wrote:
> On 2026/8/27 =E4=B8=8A=E5=8D=887:38, Sean Christopherson wrote:
> > +LoongArch folks (question below for you)
> >=20
> > On Wed, Aug 26, 2026, sashiko-bot@kernel.org wrote:
> > > > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools=
/testing/selftests/kvm/include/kvm_util.h
> > > > index 5a7a455b53875..70906a0d1003c 100644
> > > > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > > > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > > > @@ -175,7 +175,7 @@ static inline struct userspace_mem_region *vm_g=
et_mem_region(struct kvm_vm *vm,
> > > >   /* Minimum allocated guest virtual and physical addresses */
> > > >   #define KVM_UTIL_MIN_VADDR		0x2000
> > > > -#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
> > > > +#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x200000
> > >=20
> > > [Severity: High]
> > > Does bumping the minimum GPA to 0x200000 cause the guest page tables =
to overlap
> > > with the VGIC redistributor on ARM64?
> >=20
> > This is definitely a Marc/Oliver question.  FWIW, I didn't see failures=
 on arm64,
> > but I also have no idea if the hardware I was using supports the v3 tes=
ts, so
> > it's entirely possible this is a real and obvious problem.
> >=20
> > > In tools/testing/selftests/kvm/arm64/vgic_init.c:subtest_v3_redist_re=
gions(),
> > > the redistributor is hardcoded to be placed at the same address:
> > >=20
> > >      addr =3D REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
> > >      kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > >                          KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
> > >=20
> > > Because KVM maps the redistributor over memory, wouldn't the hardware=
 MMU's
> > > stage-1 page table walk attempt to read page table entries from an em=
ulated IO
> > > region?
> > >=20
> > > This seems like it would cause a stage-2 fault that KVM cannot handle=
 for a
> > > stage-1 page table walk, leading to an infinite exception loop.
> > >=20
> > > Additionally, does starting allocations at 0x200000 severely reduce t=
he
> > > available memory in memslot 0?
> > >=20
> > > In tools/testing/selftests/kvm/lib/kvm_util.c:vm_nr_pages_required(),=
 memslot 0
> > > is sized to be just slightly larger than 2MB:
> > >=20
> > >      nr_pages =3D 512;
> > >      /* Account for the per-vCPU stacks on behalf of the test. */
> > >      nr_pages +=3D nr_runnable_vcpus * DEFAULT_STACK_PGS;
> >=20
> > Ugh, right, because this doesn't change the base of the memslot.
> >=20
> > Why does LoongArch use 0x200000 instead of 0x180000 as the base?  I swi=
tched the
> > common macro purely because I thought it would be the path of least res=
istance,
> > but maybe "fixing" LoongArch to use KVM_GUEST_PAGE_TABLE_MIN_PADDR is e=
asier?
> It is no limitation on LoongArch with physical address, the common addres=
s
> 0x180000 is ok. Originally it is to add huge page on VM side in future, i=
t
> seems that it is VA address macro KVM_UTIL_MIN_VADDR rather than PA addre=
ss
> for page table for huge page purpose.

Nice!  In that case, I'll replace this with a patch to switch LoongArch to
KVM_GUEST_PAGE_TABLE_MIN_PADDR.

Thanks!
