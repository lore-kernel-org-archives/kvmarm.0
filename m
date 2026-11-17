Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932285;
	b=3Bcpaavgxv/oVyhZt90o8hBR5Fn9wpGqcwnUSgmfY8gV6ofu81UTzpI05oC3kYz0+p0j
	 F6ail29nzpPHKvZD7CYM8i45TDyA7jdS50ODkErddlWLZ4nSA9YwKEecOtV8bWcnp4Bpw
	 1pcQKX/51TNcKed7VtSzrS52XIqGG2ep0cSY0Xb0py/BxocuJnJ+VnDJIfA5fAyvDUIGF
	 5mJpeBKwJQbTDU964f2N+1CGUAVs4j7reYW0PeJV0SVWdxZPHtiCXXwNMgqjpmhMrlrKz
	 H+nMh0pbZsfAGFWF8YqElmCuDDMr0yzmNnaJvf3CyL7jnareoqhcLC3lSEsR4xG2goQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932285;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=nVQSkvxSA2D4E7wBBlcWxeerY52SIX8ZzPPc0+UbW0Q=;
	b=uzacX1fowrOwqvJbbxdopqwpLa0lVigcOEU9+ovLINE08oNWmWmb2flTL73uJQb9t3ub
	 rse6BoR/fmqM663flMZTMQQZKZz8gMFAbVqTQq0kczWDYnBj03L/izSRvPjqY5njqJiJM
	 3XeOwae9D9LmN5pFPXDki5IHUmBzmGdu3y3/73zvEoEkuYaFEKNrr9GYKxdPfFud154Ei
	 MzQBLQUglFLnD6+x8tA3vdkrC+qL18YqyZZmhWhc6TBMOpJc2WyatI8eKhRZv3IJ1QJrP
	 vj/aZD7wXAcKVURLghqQM+ErGhA/xNG5Y7OYP3TJGi0ZToHCtTq5oXndO40Bf1K9yUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZtFmZjnh;
	arc=none smtp.remote-ip=91.218.175.145
Received: from mta0.migadu.com (out-145.mta0.migadu.com [91.218.175.145])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354EE606D821
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 16:18:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 354EE606D821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZtFmZjnh
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=6gwDumgKWifTcW7wg2iaB3gIO2cxXQFF5pgKIzED2/A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794932282; v=1; x=1795537082;
 b=ZtFmZjnh4kBx9rtbLJUBTQ99odrbwM5TmsIAzIc/k/J1WTn9M4F5V3/bgLsbdeZMD5qPpflo
 MukFzXnDXZ/7kciJG8hI6fS8bHKBv0x+aYgfhn2g2sTmKQKe1nKyysTy3UfcBPpx5A5SpQpVzdd
 yU5HPKJFtKH2W3y6uqHIq494=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e2b3ab80100ea967;
	Tue, 17 Nov 2026 16:18:02 +0000
X-Mizu-Trace-ID: e2b3ab80100ea967
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so11150e87.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 08:17:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFhbw7XvDdCRbkWdeOijRdocNpc2kRB+e0esoC6QepIj6gPbfLHbMh6VYwhpxLdzWJE1wSCrrE=@lists.linux.dev
X-Gm-Message-State: APuU4Z+V9bH/u7yqC15PHQ6337Ut0+B2hlQWJ1TkIbSTfQxkLgETQhIq
	jhIwXpyHuYef8+lI7lC9zYohOl0MiJQe9if0JzkLAEMH4E7Ca9TdjtI/UNja1i9kNI7/apPzGbw
	myguwzzBpNJqO+O8M2JP5a5T+Ow9JZL4HdZxC9TGY
X-Received: by 2002:a05:6512:3b93:b0:5c1:5bc5:f373 with SMTP id
 2adb3069b0e04-5c1a21bcf91mr172153e87.15.1794932276673; Tue, 17 Nov 2026
 08:17:56 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261111145758.217946-1-steven.price@arm.com> <20261111145758.217946-12-steven.price@arm.com>
 <c5ebf936-fbc6-4910-be59-9e89ff3a625e@arm.com>
In-Reply-To: <c5ebf936-fbc6-4910-be59-9e89ff3a625e@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 17 Nov 2026 16:17:20 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxz18a-8YcJPu7Vdib5xo4bLV-2CedLJxzh+76KuWG0YQ@mail.gmail.com>
X-Gm-Features: AclHuK9hGzky46Uw9aIIH7RYxIzDHZDA5jw0n1Qmc2z6Ij7OwGUMvY7c8hZrsUo
Message-ID: <CA+EHjTxz18a-8YcJPu7Vdib5xo4bLV-2CedLJxzh+76KuWG0YQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/12] KVM: arm64: CCA: Support runtime faulting of memory
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Kohei Enju <enju.kohei@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

(sorry for the resend, my email client mangled the first one)

On Mon, 16 Nov 2026 18:36:29 +0000, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
> On 11/11/2026 14:57, Steven Price wrote:
[...]
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
[...]
> > @@ -1791,12 +1799,18 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
> >           void *memcache = NULL;
> >           gfn_t canonical_gfn;
> >           int ret;
> > +        bool is_private = false;
> >
> > -        if (!perm_fault) {
> > +        if (KVM_BUG_ON(!kvm_slot_has_gmem(s2fd->memslot), kvm))
> > +                return -EINVAL;
> > +
> > +        if (!perm_fault || kvm_arch_has_private_mem(kvm)) {
>
> should this be s/kvm_arch_has_private_mem/kvm_vm_is_realm ? I dont think
> this would be required for pKVM yet ?
>
> Also, I wonder why pKVM doesnt need mmu cache pages with permission
> faults with gmem. They do for user_mem_abort().
> (may be because they assume Gmem is always single page ? in which case
> we could also have the same behavior)

gmem_abort() only maps single pages, so a permission fault there just
relaxes permissions and doesn't use the memcache. In user_mem_abort(),
a pKVM permission fault can map a block, and that uses the memcache.
So yes, the top-up on a permission fault here is only for Realms.

[...]
> > @@ -1817,13 +1831,35 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
> >           /* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
> >           smp_rmb();
> >
> > +        if (kvm_arch_has_private_mem(kvm)) {
>
> --8>--
>
> > +                switch (kvm->arch.vm_flavor) {
> > +                case VM_REALM:
> > +                        is_private = kvm_realm_is_private_address(&kvm->arch.realm,
> > +                                                                  s2fd->fault_ipa);
>
> Could we for now use
>                 is_private = private_ipa_fault(kvm, s2fd->fault_ipa);
>
> In other words use a wrapper for detecting if a given ipa is private or
> not ? May be something like:        kvm_ipa_is_private(kvm, ipa)? (choose ipa
> to make it explicit, it is arm64 thing).
>
> Where, pKVM could hook in its own check.
I'd keep the switch. pKVM can add its own case when it uses this path.

Cheers,
/fuad
