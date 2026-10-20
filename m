Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.205
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792501913;
	b=thH4WhafO4F9V60Geyg1cvfiF3UiHN3YA/QLQc6GJ5bVl0r1b0l3lIJIaU/g6UVs4qFQ
	 vP5GFXTdgTRuH5527vJ9hEmKk62al2bVUEdRHvGlBLRIymGc33oitkozwCJ1lUGspa6pa
	 MVYYWKD/CNulhtbxJoK9ynqIlOGtM+KVXMWP8r4brooiOkqbNm6FPQvOEjAopqkB9xV0g
	 cm+UVQUdZBLfs4meMHgg9JndWatNLofksWjmnqOgr88eI14Sv8T3C9unN2NQ50NSyjIeD
	 X5CXGSe45pkSq1kJiF09rj3KvRTib8DpB3gqLz88tBB6nuVsuo26OZ4pLVBnO9ouzPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792501913;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=/SUtRRL7fFOVx3xS2Q3jVLLMRlhIGOOjpBbDS0FruaY=;
	b=VhJcGil8juYR9xqMGuwVFcjocMdhXLegxVhWoK+nNdOQtQ5JlLnMydfb7X7U+XJwKIaD
	 LSTO4mm2V3VptUtKcANt0oMlxGv8wt+RD7fuUx7FRqWRT6/MvUVYvn1zHlp9pf5BjKeEV
	 /ehqizBJPoIACFoZgxE9hPHwpLC4KXK6XBqsfPhehg3HrS3uhGn7qRQJlgIQ8WuKuvoG3
	 8kttr8cwWLRD2LdgrO9uHrEr8k/g9LeyAvt8DKQleZSsua+cXQBtq1e1voB3ZIbOm//TR
	 k/txsOa8B1Jy2XBu29oxD0Vqzhp9w0sAX7gGGkGg9cHRkfUzQr6QpSUa4doqfNL+t0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=s4IzQ5+F;
	arc=none smtp.remote-ip=91.218.175.205
Received: from mta0.migadu.com (out-205.mta0.migadu.com [91.218.175.205])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68096606A31B
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 13:11:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68096606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=s4IzQ5+F
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=8VOtYkZ2466K3qFYYyJvUToJ0S8DZXQ+CH6HzzvGHMU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792501910; v=1; x=1793106710;
 b=s4IzQ5+FHeWTxBnPPXhvEE4gRPZTofORfrTlg6jchQNKsLjRUmqRMnfVOn88RjmHVvB7FQpB
 theM0rga7WyPyQyTbD2WXTyEEfYBEA81Rwrx1/2jTMFTE4UuRq1Q6ERZT9X3uq9PlwSNZRNzx7p
 aYTRSk+HETALW/h4bW3+tf+E=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 716be10f2f395814;
	Tue, 20 Oct 2026 13:11:50 +0000
X-Mizu-Trace-ID: 716be10f2f395814
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be58ad9600so8523e87.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 06:11:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw/5IjkKBnO+G5zYGVtUBCQNjOqXMoVkt8b1XR8v1cHC85gd52S4IsdGCfhINEtVUd6VnQpzqA=@lists.linux.dev
X-Gm-Message-State: AFq9FYLbXyFnfRoPae58MmWSprXmjMcrJyeaM2yKb46ATCj8GfJmcnmx
	mA9RzQiLAQqatR+JSVkYvSDqVJTMYXE+3yWLEHxCnH0UJhM+Glicn2h8VurRtgvYlMllRJKv5ax
	OVD5lKyQ67Z4Q5QfhR0cHD6jnEZRiwjx9JZt+EuEg
X-Received: by 2002:a05:6512:32d5:b0:5bf:6c49:434c with SMTP id
 2adb3069b0e04-5bf6c4946d8mr42776e87.10.1792501908190; Tue, 20 Oct 2026
 06:11:48 -0700 (PDT)
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
 <20261019132103.3836646-3-fuad.tabba@linux.dev> <atdWIpk9Qh8ngs-Y@gremlin>
In-Reply-To: <atdWIpk9Qh8ngs-Y@gremlin>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 20 Oct 2026 14:11:11 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwb9V+12siUswmUX0-jr=sidKdAJ+vht+HyqS0KgA6v6g@mail.gmail.com>
X-Gm-Features: AclHuK_VB8b2JJ7L3ieaAtlIC-DnIJuANGGUM1BoyrOPOd60UgfcMApklQSkE2I
Message-ID: <CA+EHjTwb9V+12siUswmUX0-jr=sidKdAJ+vht+HyqS0KgA6v6g@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Clear the whole hugetlb folio when
 storing MTE tags
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

On Tue, 20 Oct 2026 12:58:13 +0100, Lorenzo Stoakes (ARM)
<ljs@kernel.org> wrote:
[...]
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
[...]
> > @@ -1042,12 +1043,14 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
[...]
> > -                        if (folio_test_hugetlb(folio))
> > -                                folio_try_hugetlb_mte_tagging(folio);
> > -                        else
> > +                        if (!folio_test_hugetlb(folio))
> >                                  try_page_mte_tagging(page);
> > +                        else if (folio_try_hugetlb_mte_tagging(folio))
>
> Slightly awkward logic, testing a negative then the negative of the negative
> (i.e. else) plus folio_try_hugetlb_mte_tagging(), makes it a little harder to
> understand.
>
> With mte_clear_folio_tags() you can make life simpler:
>
>         if (folio_test_hugetlb(folio)) {
>                 if (folio_try_hugetlb_mte_tagging(folio))
>                         mte_clear_folio_tags(folio);
>         } else {
>                 try_page_mte_tagging(page);
>         }

Without the helper, the extra level of nesting takes the loop body
past 100 columns, so I'll switch to your version in the separate patch
that adds mte_clear_folio_tags() (see 1/3).

Thanks,
/fuad
