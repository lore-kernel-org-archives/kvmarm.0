Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795216678;
	b=ow/MQheBtzOAAhJtyTqVhhsSyTIOcLJbMLWVnPedfW1BJwyPcWzF04yuPGX8XLz6xdg/
	 uzop/0AjWBM41gBH/T2bjEHQTfOXdrx7t6DltV3ad/QVFGDmaRa5++BnLlum9q0alOSuQ
	 OlH/aK0kbQObjhomUapR85kc/29ILFOZntedhWJXhcl57SBHMdkLFjh9HPldDXHupg8n8
	 fE11vmj72ebXjCZIM4I4M4Q31yPfG8ziv+s9eVOAaNUNr9Y/EXJZ9HKiF/Bjjv9gDlLyG
	 wvQ8ZElYrolymtLuckUI64cu6nDV88QdzPsb/2yNPhpYqqCo1vtRmqtkI17cRkqtqlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795216678;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=KaufFdBJJM6uHUO0RxAk0mis1hBr3eWXheXkcNAnmWQ=;
	b=nEC70yA23Nt5YcOd56Vd78qCCDM4sDsE6SKKzDPjjxPq0WghunAs+I4KSEPyAhZDw0av
	 ukFp4ajJG5puyg57/ghcW8NnlbOw2id4brN059g2knG5kFAHFGiUNBfZj0W5Yo3uaWAUk
	 0OulUYqj6makvpS6RofEcGhTWlEmSI/sWTzwSX66w0nbpcY4QoOa+RnXDMAeaeSWHIYpS
	 aEoPUv91KgjbjMd2EU7JIBF/wvkdDwVCYLGftTEJXbqvoh6w4kf7edtHmoyfT4034gi3o
	 Ww0q3+VLW+hzWHYfmug5dFJK2vwh6AKViIy0ABrNKGWEhmsk7XmUAfk2NsMeBu7cj6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=l6TXb0sx;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC7D606A68F
	for <kvmarm@lists.linux.dev>; Fri, 20 Nov 2026 23:17:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FC7D606A68F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=l6TXb0sx
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-54dbbf252cdso1709216b6e.2
        for <kvmarm@lists.linux.dev>; Fri, 20 Nov 2026 15:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795216674; x=1795821474; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KaufFdBJJM6uHUO0RxAk0mis1hBr3eWXheXkcNAnmWQ=;
        b=l6TXb0sxdRCbOu5ZpA35+CgCyMmaJBBxCwNHHcGGelIe1KEb6aMH99Ed/CLV3sjTwW
         F63ToCGZs3Dl1NCbc73X3YL8ssLwMpNqLEMlNPVs6aC35pdcGN/zm6eoEl4JWib5eBu9
         Z0E1S7ZCv8gb5uQz5Im4iqIKwIiEh4sbt/h43Q1dZgeC+ZzF6P/Ur+NoogPKAZCErLcY
         jPvz85UOIkKZKicf7RAH+AwS2heOE4kNIMHepPFo4k+Y7wSViMoUzvn80E+QJDkC7VsS
         dbMiO2CU6xO0QxUq8eQyaT9q1qgW9jGc/b/px8KEvFv0M7Bf8EDg3qWwrZ2Q3URPHiZM
         KWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795216674; x=1795821474;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KaufFdBJJM6uHUO0RxAk0mis1hBr3eWXheXkcNAnmWQ=;
        b=N4Hdo5pO5jNPBxRnXe+Uc1xcon4A9BVGf+YU6IMGYYTL2lawcqkbta0vmZtfnZKG29
         SK6k8J1Ow68vieZ8vloWHS/KiK1tJGlyJwH9pk4oIuBFsjJun8n+SX4JCZyoWz5vLiH1
         HD/DCVB+/p4uf8Eg7lSLqTOJBiAW7NCIlPURZIfp/r0tsNQwYZXIlflZJSzNVYeAa+wH
         3HfyiiZWLOlQUgFjCBxCsfDQ2ya867CYdBDWB0nc8It+i/Zc06kID8BM5ApmKwZXcArI
         wBjeXjE55cN7IiLhXko3IYo6qYg3poHFJrOM5ehDdPhoQ/IMGgv1gL2mv0+NzuN7N4Is
         6nmQ==
X-Forwarded-Encrypted: i=1; AL+hErEFp6Yf/QbBLEMuybEFxezJe4MOWM/90ZO6OT0zWOgAYdBOWJneD2jBhhRVVmWSwciWgMhlT5E=@lists.linux.dev
X-Gm-Message-State: APuU4Z/AIxfkz4hOU9Cwlk54MBq5eCaW2HSMA3NkXdOMrtMF40wWHZo6
	mluBfzAByyHx6OvxNN1CUuZgZEA/DIodhi3YC0qiDZgP3ffmTsB8eHmGQRQXaHbqSmnyDPB5oZK
	14KlP2F6h0Ke3V0bw8csoou9/Kw==
X-Received: from ilb26-n2.prod.google.com ([2002:a05:6e02:531a:20b0:53d:d5c4:1e46])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:c12b:b0:572:86c8:6b4c with SMTP id 5614622812f47-57a07d19c74mr5405322b6e.6.1795216674015;
 Fri, 20 Nov 2026 15:17:54 -0800 (PST)
Date: Fri, 20 Nov 2026 23:17:53 +0000
In-Reply-To: <iyfa5sagkdapb4plle575uhbxbmjdcxvbe35nnlxkqzfqnztqd@mmweqvqmil6x>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185105.626343-1-coltonlewis@google.com> <iyfa5sagkdapb4plle575uhbxbmjdcxvbe35nnlxkqzfqnztqd@mmweqvqmil6x>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120231753.1170879-1-coltonlewis@google.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix guest stage-2 mapping leak on
 sub-block unmap
From: Colton Lewis <coltonlewis@google.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Steffen Eiden <seiden@linux.ibm.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 20 Nov 2026 06:35:12 +0000, Wei-Lin Chang <weilin.chang@arm.com> wrote:
> > result, every sub-block invalidation followed by a re-fault leaks a
>
> Doesn't the block tracking node get leaked regardless of whether a
> re-fault happens?

Yes, the stale entry is left behind on the first TLBI. Re-faulting is
just what lets L1 accumulate additional entries.

> For this third paragraph can you improve it by stating how the problem
> is fixed upfront? The first two paragraphs describe the problem, then
> you started to talk about stage2_unmap_walker all of a sudden (which I'm
> not sure how much it helps), and the fix itself is not emphasised. The
> combination makes it pretty difficult to get what the patch is doing.

Agreed, the commit message was unclear. In v2 I will drop the
kvm_remove_guest_s2_mappings() approach in favor of ignoring TLBI
IPAS2E1 when the guest-supplied TTL is smaller than the mapped granule
(as Marc suggested), and rewrite the commit messages to be shorter and
clearer.

> > In addition, suppress exact-match duplicate insertions in
> > kvm_record_guest_s2_mapping() when concurrent faults or -EAGAIN retries
> > record an identical (nested, canonical) range on the same shadow MMU.
>
> I believe this is better split into its own patch, it's doing another
> thing.

Makes sense. I will split it into a separate patch in v2.

> > Fixes: 5491980c1a41 ("KVM: arm64: nv: Track guest stage-2 mapping removal")
> > Fixes: c2778d14cd2f ("KVM: arm64: nv: Track guest stage-2 mapping creation")
>
> Since there isn't a real bug in the original implementation do we need
> these tags?

Good point. I will drop the Fixes tag on the duplicate-avoidance patch
and point the TTL patch at the commit that added FEAT_TTL handling
instead.

> > +	scoped_guard(spinlock, &kvm->arch.guest_s2_tracking_lock) {
> > +		if (!guest_s2_mapping_exists(mmu, mapping)) {
> > +			interval_tree_insert(&mapping->nested,
> > +					     &mmu->guest_s2_mappings);
> > +			interval_tree_insert(&mapping->canonical,
> > +					     &kvm->arch.mmu.guest_s2_mappings);
> > +			mapping = NULL;
> > +		}
> > +	}
> > +
> > +	kfree(mapping);
>
> In my understanding kfree() can be called while holding locks, so we
> don't need the extra level of indentation.

Yes, kfree() is safe under the spinlock. I will keep guard(spinlock)
and call kfree() directly there.
