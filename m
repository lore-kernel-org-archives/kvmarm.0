Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793722549;
	b=VvgUw0VaQwLN1eOYgjSaRtyKoZnr1fXC8kAzujCHp+gfyjZLfTT6fc5EVBwigUww34c5
	 d+a33ds80+qAZUOpb3BXiZ3vtVIiMUK61kihtPgnUp4r6oCWVUBThu8gBYsbpQdJKqv1W
	 P7x9LKStc6FBjIYNf9sO57JlW6UliDfPnfoA0e/goqoOS0H0TF1VredBNjrM11AeGUZLY
	 XIS9rx4UhI+Nam6Hu6WJg0BQTsL0v8YuxDx0hqUMLe3108jEd8jxdzH0KmVWANaiJ8DT9
	 do9kNlV+f09t2k0j/U0a+/CHZbe6nW477HuULM6WI9vLxvuj91Gar5+E4h1Fqkrk4HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793722549;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=ctm+OvOOdF3/eRDZQ9mCZGJ4OrDu4+sLjWj8shOpss4=;
	b=NPZOlMUTqyIX+2nwzpczJJl6hBwjoqkgHCaBUJyb9o17ySrHEF4/c7OP5Iqg8TXbMHgt
	 59KPauHW1WkMtlsnT/BTuuNlnOvraCMlJ3bjyF+IjvqwjsA3ve/XTcdd9zGr2ggQKHRHm
	 6d9FOeYrXtKcO3SQuWFXeubeotx6kX2lHr7hj0AiiPW+nwdoOKpxdeg3O1FKZbcybYjo0
	 /H9+fuoCDYiK7bfc6gFWCOksVtmf8jb4yd5WyaEjp410NNtqFYuzSeFx3Nv5CwFlnqJXE
	 VVk0RLxMvV0lJhHAYjtMNVW1xz/okdzniTDiOwQInnhLwwWz45zaXyENfAxP3fXezNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GyoqiHZS;
	arc=none smtp.remote-ip=91.218.175.240
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7337B606D835
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 16:15:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7337B606D835
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GyoqiHZS
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=K8R3zoPWS9GjOtmgfFeCE0/yDhy3x8tsootf9dJemic=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793722545; v=1; x=1794327345;
 b=GyoqiHZSrkruXfpO2HIlXwFGNkGLm8MXDd9Z52JL/ccM4wbkNxVlSWQaQ5Jn2MdinAoyesC1
 RuL4ASyrYzdT3iPgTAWErRdvuH/e/qtX0GNVt8bPHWv4av1xr0F/1czd5a8a7sKmDeHy3pS+YGI
 nUKrJ7rU1TavGq62fi24zVJQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b29b55da49a5f3c9;
	Tue, 03 Nov 2026 16:15:45 +0000
X-Mizu-Trace-ID: b29b55da49a5f3c9
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so8568e87.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 08:15:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzzpRhjL8mNE/6TIs8ND9wWxegmLVnKVXeN4sNXUnuCexxEjhPLkKRKGhN1HqahvtUXsSGpZLU=@lists.linux.dev
X-Gm-Message-State: APuU4Z+YSPXevz8xPIs+K9gkoVdJpl/7nZBT36hxWD0w9UiAiA/ZHycu
	UOcDDt3MaqpfGe60jCJa6d2mZPtYFaFkkzR9gbq1tHkBDupodd9RYeYC7uzsCwa16xR+h3/BnS0
	/KszqV8MP+C8v7/9hI4WHKnAO48PaqMofG/dYTUiC
X-Received: by 2002:a05:6512:1247:b0:5bf:f0b8:f896 with SMTP id
 2adb3069b0e04-5bff0b8fd75mr147439e87.0.1793722540055; Tue, 03 Nov 2026
 08:15:40 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
 <20261103084742.1302597-2-fuad.tabba@linux.dev> <aun1NJNtnOeSL4oc@google.com>
In-Reply-To: <aun1NJNtnOeSL4oc@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 16:15:03 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwCPHp_odMPJAJ8pfPtymtU5ia_RrH30DavFeiZqvhVAQ@mail.gmail.com>
X-Gm-Features: AclHuK9jF3GIRHTl9ZfS7oE87Qhpm2sxTx6SMNL-HGm4GrBCk1nlKw1LtRNf6Po
Message-ID: <CA+EHjTwCPHp_odMPJAJ8pfPtymtU5ia_RrH30DavFeiZqvhVAQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't walk the whole IPA space when
 destroying a pKVM stage-2
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Tue, 03 Nov 2026 14:52:36 +0000, Vincent Donnefort
<vdonnefort@google.com> wrote:
[...]
> > Walk the mapping tree once instead, and reschedule after passing each
> > mapping to the reclaim or unshare helper. The unshare helper can't
> > reschedule itself, as the map and unmap paths call it under the
> > mmu_lock. A failed unshare now leaves only its own mapping behind, not
> > the rest of its chunk.
>
> Not a problem now, but don't we make the device assignment story harder?

I don't think so. In Android, the host doesn't track the MMIO of a
device assigned to a protected guest. The hypervisor maps it into the
guest, and gives it back to the host in __pkvm_start_teardown_vm(),
before the host reclaims anything. So the walk this patch changes
shouldn't reach it.

>
> >
> > Fixes: 4ddfab5436b69 ("KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables")
>
> Isn't it an optimisation?

No, it fixes a regression: 4ddfab5436b6 replaced a single walk of the
mapping tree with the 2^27 lookups, as described in the commit
message.

[...]
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
[...]
> > @@ -513,10 +514,18 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
[...]
> > +        for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> > +                u64 start = __pkvm_mapping_start(mapping);
> > +                u64 end = __pkvm_mapping_end(mapping) + 1;
>
> __pkvm_mapping_* are rb-tree internals. I think it is better to use explicitly:
>
>   start = gfn_to_gpa(mapping->gfn);
>   end = start + (mapping->nr_pages * PAGE_SIZE)

Ack.

>
> Also, I wonder if we'd better WARN if the mapping isn't aligned with the
> destroyed range?

No need. The function's only caller passes the whole IPA space, so
every mapping is inside the range.

Cheers,
/fuad
