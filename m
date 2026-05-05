Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050ED1F5847
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 20:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778012082; cv=none; b=tv8za/fnacxNE389IG28F2I0d4cDZZ/NDDa4UC3SAuueuzZ2ecG/Iv5+6HARZ5or/WDdo0rIoeYBtrohx/YBmq9zLwRc39pTECV1UGfxFMsXFBNQeQmNgbiMmZXK3NCpWbSI5kDnnDQeahaVaQVAcZ/h8INYK5Xs02yaeLnOjOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778012082; c=relaxed/simple;
	bh=fZNJP1E6FO2fjwXHd8ye8evSEUx0JyrqYT2u92kU9L8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OVHAEtgoPe/KLSjFZh763+KbxjwqHSJlhXmsNgaXW8onicNt0Vc5gRYV1RFFIuB051CKmRK8Z06vQwR3dNmQTfwlY4sGMc0NIZ4hiQVTKWex/h/ffA13Pz+R7PxhZKr3JNVYkVjSVBx+0y14oEcv769GeNobX0Sb8wiSw/5RFTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LmlGucw3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LmlGucw3"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ba6fe41283so4863305ad.1
        for <kvmarm@lists.linux.dev>; Tue, 05 May 2026 13:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778012080; x=1778616880; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FOAwuyt3rtVWRkmVcOSIKCDRqR2NsdJAT4GPMkewjlg=;
        b=LmlGucw3rnod/jr9EndHoTivH/A+e4rgEpdx7SMicJOEaxPHQeEQZul8CZmY64nbzY
         PMH2UJGIJ35L1FNk6Ix5wFy9DkGwAd2PQCVXDrF3CSoOd7STiMD+d2l1pTypAvjiZr1+
         udCvX4uQaz9adwqKis+NRAG70TJ8+MREUm0x1ySGDlohGKS5VeWMjjIzIPduMMiBYPgM
         EDuIaGB1W9K9C5UA3M2GX41NR22lw48TqZQT/X9skZ/mcXvig1SaVM/O7Ti4MoLj0bLz
         Db4GZEZ7HjJMdCLK78NdzxhzrkrADhApKdUMJ7pGG385uj5yql9LTRlrWo1VBLHpl7VX
         cmrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778012080; x=1778616880;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FOAwuyt3rtVWRkmVcOSIKCDRqR2NsdJAT4GPMkewjlg=;
        b=h1nafHgfiMArhGQQQPUZqb7oQjI8eWK53xsTRA5FLSzcLTPrRt73as0m1Xd/iwf0VJ
         Z5YvrNEZo0TVGVgE3RxakO5hulKmxcYK5BiZafqGDOztvWLWXQkcdv1wC1okSPbFmyyi
         yD1SmMkjAz3X0e5xY2FvAs0kvBs9DQIcVeyhHZRELZQ8Ez/vahJXe8E9wcyqa5axJ4UK
         nA0s/xMa9yTZKwPczlWCpjtDoUfH6j6Zj1htDZBd0AmUy/BO5LmkggYQluBv+efbQ97C
         1MNimq2hxTsYnLrz/NOtEX9FDSiufMJ0Y/1bGOTbSrdffEBngLq5u2ssHYn+rCehNdGu
         XdFA==
X-Forwarded-Encrypted: i=1; AFNElJ/g5WoH2WD4JFlag+IQweVhudialQ2aq/Ru7mGICtNQoOjHLFl44k6ka+IngXLIkBy71Wsy/wU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhK/DLRH1kWWRXdfB98RrrKoP3G2XkCzedvl9pDVJc5xGZpPPI
	mBomvL0/123aMxbOZlpYe3gb8m1bIcJBlfjfkqgovbfWHclawVntJED/3rrIlC9KcHOfxhkWqRR
	zXMFSkQ==
X-Received: from pgmt3.prod.google.com ([2002:a63:2243:0:b0:c73:fc44:8bb5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9c:b0:39f:27ab:2454
 with SMTP id adf61e73a8af0-3aa5ab17b2bmr365628637.49.1778012080089; Tue, 05
 May 2026 13:14:40 -0700 (PDT)
Date: Tue, 5 May 2026 13:14:39 -0700
In-Reply-To: <afo0Er7R4MnMP0MB@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504224213.1049426-2-jthoughton@google.com>
 <20260504231048.1184273-1-jthoughton@google.com> <afohshVlK9YcBk-f@google.com>
 <CADrL8HX223b3YS8aHr7b=AZZ2J5ga+-SwLQX9Rs9Ep=rMM5wUA@mail.gmail.com> <afo0Er7R4MnMP0MB@google.com>
Message-ID: <afpPr-a00an1v6mZ@google.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Grab KVM MMU write lock in kvm_arch_flush_shadow_all()
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: chenhuacai@kernel.org, gshan@redhat.com, jhogan@kernel.org, 
	joey.gouly@arm.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mips@vger.kernel.org, loongarch@lists.linux.dev, maobibo@loongson.cn, 
	maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com, ricarkol@google.com, 
	shahuang@redhat.com, stable@vger.kernel.org, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, zhaotianrui@loongson.cn
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 05, 2026, Sean Christopherson wrote:
> On Tue, May 05, 2026, James Houghton wrote:
> > On Tue, May 5, 2026 at 10:05=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > There are more issues.  kvm->arch.mmu.split_page_cache can be freed b=
y
> > > kvm_arch_commit_memory_region(), which holds slots_lock and slots_arc=
h_lock,
> > > but not mmu_lock.
> >=20
> > Thanks. I also noticed that kvm->arch.mmu.split_page_cache is
> > documented as being protected by kvm->slots_lock; we should be holding
> > it here. But we cannot take it here because we are already holding the
> > KVM srcu lock.
> >=20
> > > IMO, the handling of kvm->arch.mmu.split_page_cache should be reworke=
d.  I don't
> > > entirely get the motivation for aggressively freeing the cache.  The =
cache will
> > > only be filled if KVM actually does eager page splitting, so it's not=
 like KVM is
> > > burning pages for setups that will never use the cache.
> > >
> > > Maybe I'm underestimating how many pages arm64 needs in the worst cas=
e scenario?
> > > (I can't follow the math, too many macros).  But if KVM is configurin=
g the cache
> > > with a capacity that's _so_ high that the "wasted" memory is problema=
tic, then we
> > > probably should we revisit the capacity and algorithm.  E.g. if KVM i=
s splitting
> > > from 1GiB =3D> 4KiB in a single pass (I can't tell if KVM does this o=
n arm64), then
> > > we could break that into a 1GiB =3D> 2MiB =3D> 4KiB sequence.
> >=20
> > I'm not sure I've fully understood the point you're making, but I
> > *think* we can just drop the
> >     kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
> > line from kvm_uninit_stage2_mmu(). It will get freed when the VM is
> > destroyed anyway.
>=20
> It's not that simple.  KVM arm64 allows userspace to reconfigure the capa=
city of
> the cache via KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE.  kvm_vm_ioctl_enable_ca=
p()
> currently allows userspace to do that so long as there are no memslots.
> __kvm_mmu_topup_memory_cache() will (rightly) yell and fail if it's calle=
d with
> the "wrong" capacity, so we'd need to sort that out.
>=20
> The other issue is that it's not clear to me what happens for large "chun=
k" sizes.
> If KVM is splitting from 1GiB (or whatever huge-hugepage sizes are suppor=
ted on
> arm64) all the way to 4KiB, e.g. to optimize against break-before-make, t=
hen the
> capacity of the cache could be significant, e.g. MiB of memory or worse. =
 My read
> of things is that purging the cache when dirty logging is disabled is a g=
uard
> against consuming too much memory when the chunk size is large.

If we go down the "let's simplify things" path, one way to simplify the han=
dling
of KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE would be to disallow changing the chu=
nk size
once the cache has been used.  That would allow deferring teardown of the c=
ache
until VM destruction.

diff --git arch/arm64/kvm/arm.c arch/arm64/kvm/arm.c
index 176cbe8baad3..671f7ac5e31d 100644
--- arch/arm64/kvm/arm.c
+++ arch/arm64/kvm/arm.c
@@ -165,7 +165,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
                 * To keep things simple, allow changing the chunk
                 * size only when no memory slots have been created.
                 */
-               if (kvm_are_all_memslots_empty(kvm)) {
+               if (kvm_are_all_memslots_empty(kvm) &&
+                   !kvm->arch.mmu.split_page_cache.capacity) {
                        u64 new_cap =3D cap->args[0];
=20
                        if (!new_cap || kvm_is_block_size_supported(new_cap=
)) {

