Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F204419580A
	for <kvmarm@lists.linux.dev>; Tue, 30 Jul 2024 11:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722340344; cv=none; b=bxI8r1Vbtva9pb+IFJ0Zyp4kEUTnYsP+ALW4oIU7SnT82kFkywJ6B2YYfUfTL6x42HnSjPQQWHnLA8eaWe8+ZpYAUai7je1GxyoP7BSVTzgxRia4SLYsZ28lXll4jKPE452uD6BUkXVIpRTcxLWel1mExqKQZ//yIgRt4ziwjQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722340344; c=relaxed/simple;
	bh=i5pqEBAzsxZVYdIgCz2pQRWHOKq/9I2sY7ExiVSJ1S0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dx8/O9hY3MYpYB1KILFDQ0Uf308jaI09f7xUg0KwPJikC1xOWau/ydAll41EP3/7nWBcMpVxg18yI3Ixv/LA4f0fTSwXwqvsdD0hGSvaB3ksoiH+c+8LWQDDmPNdfgHI8gmRs/lQgNJYJziy90rqLNB9c8M8y39g4AugE4rJDCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hf5X5npP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hf5X5npP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722340341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kBFBIKd1rJgOI9YcivSLfU1/eAHX+x0Dw4M+NCBYe5U=;
	b=Hf5X5npPCSB3TJunaCO7/yEglHaWSbpLOg7or/hkRqXSVOyYZtkyK6hgC1QIR1Kbxl8Vqh
	TAmCGanWbuTWf/HB4k3YG4ySXy0RM62Cu7nTnqsSuEzg/YyaEz/ndYnKnuOsKhnvfwY/CH
	HR23bPkVSPAn+IKNNdhRtEu0J5XT5X0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-bpjTB9HbOO6F8NBOpykE0Q-1; Tue, 30 Jul 2024 07:52:20 -0400
X-MC-Unique: bpjTB9HbOO6F8NBOpykE0Q-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5a7493ad70fso3349044a12.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Jul 2024 04:52:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722340338; x=1722945138;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kBFBIKd1rJgOI9YcivSLfU1/eAHX+x0Dw4M+NCBYe5U=;
        b=XPYo68xSbjwE1jWp6SSSTWvtYLdbZ81hpSmuDdeRpzFG5Rz0QF7OtjOSFmT2RUuThy
         zhpG58yLd2gJWaKFBQfla47iPLJhRzqTw4R08y0Ag20CcfJeJotyrK+jXnbFEqQpgjLf
         vcRu3jT6pA4tAOPYW+hoRhjPVJ6M06U2zF8pIDsbJnlHOqkBkxIs+pvp1MtXA7/kbOMf
         KVfzP1pVsxzSod84m/Wh1G8DFLqV7WMlvYEja4dxMRbEYvBB0qV3odqXiyHJuoP5oGqc
         VPeAb52onBGcEt26Dwq/GueynFfaW/ORUs8jvGuxBcAyClJN8Rrv6fp1EhKqPfosjUjO
         BHcg==
X-Forwarded-Encrypted: i=1; AJvYcCVZUL8gb8XQuDRwaHgbZnika6o7PY01/ivMJEFkTDpMS1jr194TViZWEKWvyVK65i6WdhGHMOw31uKQF8bDVSKCDnI6tpYw
X-Gm-Message-State: AOJu0YwWES/zu1bBJwehFxVD+W8lzhbSjhzsVi4P+HOV2bIDGTG7XbvK
	eJWK1OPV7CH+8YJvthdrEwadxyZp8cjZgaTR9jQgKbxVW/yUF6qlAcSuU3aWVqthqvVOSvwM6zY
	o/wvvTKEULMO4iXcPmCpfXM662OtH+JuLgvm3BnUPLRZ03mP2cPudxg==
X-Received: by 2002:a50:d742:0:b0:5a1:6c50:a35 with SMTP id 4fb4d7f45d1cf-5b022b8cd30mr5926689a12.37.1722340338221;
        Tue, 30 Jul 2024 04:52:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBJKwuTl3GcCc5YuDbeqMD1zDkMcs4VmkJUQMAj6w6PoPQ2QTlBUJ4IvJ66qrB4FTpUDSGzA==
X-Received: by 2002:a50:d742:0:b0:5a1:6c50:a35 with SMTP id 4fb4d7f45d1cf-5b022b8cd30mr5926669a12.37.1722340337692;
        Tue, 30 Jul 2024 04:52:17 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5b0044c72d4sm5211327a12.70.2024.07.30.04.52.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 04:52:17 -0700 (PDT)
Message-ID: <419ea6ce-83ca-413e-936c-1935e2c51497@redhat.com>
Date: Tue, 30 Jul 2024 13:52:15 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/84] KVM: Stop grabbing references to PFNMAP'd pages
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
 David Stevens <stevensd@chromium.org>
References: <20240726235234.228822-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/27/24 01:51, Sean Christopherson wrote:
> arm64 folks, the first two patches are bug fixes, but I have very low
> confidence that they are correct and/or desirable.  If they are more or
> less correct, I can post them separately if that'd make life easier.  I
> included them here to avoid conflicts, and because I'm pretty sure how
> KVM deals with MTE tags vs. dirty logging will impact what APIs KVM needs
> to provide to arch code.
> 
> On to the series...  The TL;DR is that I would like to get input on two
> things:
> 
>   1. Marking folios dirty/accessed only on the intial stage-2 page fault
>   2. The new APIs for faulting, prefetching, and doing "lookups" on pfns

Wow!

Splitting out prefetching makes a lot of sense, as it's the only one 
with npages > 1 and it doesn't need all the complexity of hva_to_pfn().

I've left a comment on the lookup API, which is probably the only one 
that can be simplified further.

The faulting API looks good as a first iteration.  Code-wise, 
kvm_resolve_pfn() is probably unnecessary at the end of the series but I 
can see why you had to restrain yourself and declare it done. :)

An interesting evolution of the API could be to pass a struct 
kvm_follow_pfn pointer to {,__}kvm_faultin_pfn() and __gfn_to_page() 
(the "constructors"); and on the other side to 
kvm_release_faultin_page() and kvm_release_page_*().  The struct 
kvm_follow_pfn could be embedded in the (x86) kvm_page_fault and 
(generic) kvm_host_map structs.  But certainly not as part of this 
already huge work.

Paolo

