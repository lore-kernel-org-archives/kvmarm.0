Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.236
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502315;
	b=nzJtseK0jcQTjiEqoIqnvk2z4O2itmjN2gt67d8u+F8otQDQSrx4U9GwUWEUEcEtjyv1
	 /3Qnx8iJ9QevQbm4Moo2/0dK1G4YVdRW6PLuItDKizRovOOhmsYTOW2A6XjGsUJ0IihO0
	 GTslS+gBr5bqPA2koKYz7qn9xAg5cOu/S58ar9jVMjvff0wo1200axGfAmlLdggVi9pgp
	 fI2SCt0IFxlYWWiPHao1+oatArLJNCsb/EyjC97k16l/FER7HogBtHreZbsn6dmFJ5hJm
	 YNLFaqkxlpOd95BsWNflxzS4baN3qR98Y/oDbzx4ntGNTUQjX1s8dDbTznNpauv1blg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502315;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=zhQTHhRDxrb17zR175fyiocPa+1wRm/9Uxlolic7thk=;
	b=duhz++1y9Fan9/zLsElMXS73Mm4xTfpDifyATse8x2lLb+Rityh6BJUpNddasWabgV8x
	 6w7hM6HTGcZ1gnFYoWUBsOewjJr0wTSxP9DtXh8FC2Nx0sNiiTEFfDjBdkX2cKEHBhxaN
	 Mi6EuTTu6U1NKqkUAB2+9O7o2Ln2qIuzSC5U6+6P4ksBwREtTBT7ZkwctZ3xQEOvdGQJB
	 NiSC1gjRDh/t9MYDFbfpd2ZoWh+K8N0OjC8u2cNDB9LfA90FxlIGnJBGS39J4lBzkaZlY
	 eXcv8Od1V1Umu86x0Fbf+dnbZwdEsQE8Nw8seVZFvb2I+SEV57Q4NjGClQjh6pQsh+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HBbS2wsS;
	arc=none smtp.remote-ip=95.215.58.236
Received: from mta1.migadu.com (out-236.mta1.migadu.com [95.215.58.236])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4AF606A31C
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 13:18:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA4AF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HBbS2wsS
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3yy/71fTKQCgcgYM/XB0wovh4NMYwl9+gtTV2Y2B9rQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792502312; v=1; x=1793107112;
 b=HBbS2wsS9fHLsWUpvBznfbcwV33HnhT9lV/rESE1ThDnpyuoEUVw6eYCAMF2U4atRzjEmKU7
 ekR6SNgspeMaWQgrTQi85ZzdV/ktr+y470wRM1cs/LOrrZvSBK0S0c7Kk/Bfy7sNWfyvUW9IC5m
 L0CPqLR3wPgV6F2GYmP0F/+s=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4e6552e00614a072;
	Tue, 20 Oct 2026 13:18:32 +0000
X-Mizu-Trace-ID: 4e6552e00614a072
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so6863e87.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 06:18:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwlpMKQxDKGVSLzL/Ph8tzfRifPsVlaiUqgUp6WVMd6Ej3CNfvG0rP6ykC+kHn52hpnOTYuIro=@lists.linux.dev
X-Gm-Message-State: AFq9FYKdFEon+vjYFsR8LallD1uSvas7qYl/dCOwaQ2+HfW++CEA5ByC
	NQcWu6zERnK3xkTSYdvJelHhkKh1a/JNKZUfv7fpxGVkvI2hqEIsQQCowlHzeZg8lb1FQhtjkRY
	3dVBpB+8yRGyPRK+gS9/bg5lf5S5ZE5L73Oq8MM0q
X-Received: by 2002:a05:6512:10ca:b0:5b7:6707:e44c with SMTP id
 2adb3069b0e04-5be66f2d62fmr148849e87.12.1792502311357; Tue, 20 Oct 2026
 06:18:31 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261019132103.3836646-1-fuad.tabba@linux.dev>
 <20261019132103.3836646-4-fuad.tabba@linux.dev> <atdXdtXXTH-6DWVt@gremlin>
In-Reply-To: <atdXdtXXTH-6DWVt@gremlin>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 20 Oct 2026 14:17:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzH_GA=Vigd_nDXKDFAPCJStcANFFLeLXvsh3UqpjOpCQ@mail.gmail.com>
X-Gm-Features: AclHuK-euDF0wuuv5pnt6Njq_PrWwxGpuc1BgLKpLexvwAe-pbj6xoTqUlxrbHk
Message-ID: <CA+EHjTzH_GA=Vigd_nDXKDFAPCJStcANFFLeLXvsh3UqpjOpCQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Sanitise MTE tags when a permission fault
 installs a mapping
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Steven Price <steven.price@arm.com>, Yang Shi <yang@os.amperecomputing.com>, 
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Lorenzo,

On Tue, 20 Oct 2026 13:14:01 +0100, Lorenzo Stoakes (ARM)
<ljs@kernel.org> wrote:
[...]
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
[...]
> > @@ -2060,7 +2060,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
> >                  }
> >          }
> >
> > -        if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
> > +        if (mapping_size != perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
>
> So 'translation fault or permission fault if this will install a mapping' rather
> than 'translation fault' alone right?

Right.

> Just after this code you have:
>
>         if (mapping_size == perm_fault_granule) {
>                 ...
>         } else {
>                 ...
>         }
>
> So you could put
>
>                 if (!s2vi->map_non_cacheable && kvm_has_mte(kvm))
>                         sanitise_mte_tags(kvm, pfn, mapping_size);
>
> In the else branch? Seems neater and clearer.

Agree, I'll move it there in v2.

> Also I wonder if the !s2vi->map_non_cacheable && kvm_has_mte(kvm) check could be
> abstracted?
>
> E.g.:
>
> static bool is_mte_fault(const struct kvm *kvm,
>                          const struct kvm_s2_fault_vma_info *s2vi)
> {
>         return !s2vi->map_non_cacheable && kvm_has_mte(kvm);
> }
>
> Then could be:
>
>         if (is_mte_fault(kvm, s2vi))
>                 sanitise_mte_tags(kvm, pfn, mapping_size);

I'd rather leave that out: the fix doesn't change that part of the
condition, and it only appears twice.

Thanks,
/fuad
