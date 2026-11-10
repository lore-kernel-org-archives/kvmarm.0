Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794335150;
	b=049y97zw4eVzjLMknJbNBXd/AipDgcMdK1OUAGOc65PZMhrPIlBBqfC0cX1vXi1VLsEk
	 NzVpt2/4GRxF76FwPwqzI/8JffL9/J1aH4AP5tVl9Xdy2vpZP54zuBpDVelqNNMqRU2K1
	 8fN1sUK3I0UNW16BoUl3OOoYJyjk2Ca/i0lPh+kEo6tRPCEF62+LFGNvOSHlngJu3VZub
	 DgsuIfpRKwbVjlmW1cT3dnMdLgNJbnR762+nWIUtY/C45niLIt66HDIbsWZcokn7p1WnG
	 USsvSO4T/c5aCB3mPhvTvB4FqhZ2qf23IvA3CogAAhJzZm1fIJlYNuQOl9n9aSNuqyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335150;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=pg8+OEnjDNmIa2RbISOLY8VoGEN6y0ux1Fnyr8R7io4=;
	b=4lOJ1OGD5UkRnrGQ+Z8b2xdOy6iQTLF+xjsgf7gIuYnD7AguPhSiSUYBDH9YTJWKh3u+
	 fZXUAUsESbof32xMAWxDEXCRqBaBj2HXR6i/5bCg6F0pfBL5Xv6mB2DdTZJPRvq1Dcj40
	 YRJ2JgLQCcjQBpsOh1J+jazIFhoYS5hKoeDfDOeUY44boyi8HHKAUNOTzloDpZ4AWM9BH
	 YnhwWaCbBCFFHX8tmh/AUT7Nn4YAsaoTAMo3COWSGMA3V1fNXE+qJm2d6wStW0OVU9RU/
	 xUtoe7pCrMieCe4oUtOMNAMDn/25Ia5cCHDBejrEp6eak5XpxP4a6yjri+6yrScxq3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fql0BhI+;
	arc=none smtp.remote-ip=209.85.208.70
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D9B606A32A
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 18:25:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5D9B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fql0BhI+
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6b6723180baso2574328a12.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 10:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794335148; x=1794939948; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pg8+OEnjDNmIa2RbISOLY8VoGEN6y0ux1Fnyr8R7io4=;
        b=fql0BhI+Yui31ZQlbGpw1mYTyhPQnCObdzl7Bw/cE30dA3OlXhfAy6VIIMskgyDfuk
         hNY4HKKMAF0RZk95kS+vdFHWtgoJ/RXuBppdVPxruoU3oLP/v7rGmDKHSsMOa/epjba7
         noX9FZsl/0ChCkf+nkhIH1/YnWMstE8fC3HRnHWGziB0ML4M+97XquJ5lc4DZVCo9SNG
         rtNCtP8Qj66G7eI7X6VLyOJbJ9lBGlJclbdiXFsj3zLSNnCnwlEkQLZonlBwEOdt8LE3
         0heJKnc41mVb5qSMOJH6IWosmlQ1tViG2ohSAMY6BpW3KxkqVvhM2lEqeSe6dEhrGWuU
         PElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794335148; x=1794939948;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pg8+OEnjDNmIa2RbISOLY8VoGEN6y0ux1Fnyr8R7io4=;
        b=a1GixzXjMiAoRFLTp2QLdz3Ux55V/qASzeFNOzUxaYo3+2eS8UcQZWmv3+9xm15vLg
         U2Scu5gWLSKQmX/L1TqQHPGTWRCZBnjQxVQFqmRTR3TWf53wrD0GAI8fVUEvZygfU+eb
         SNI0OrLg+X1GoKq29WJfWrgQhP9Z+XFm6Fn7DJDMlHHYKc0uxZRcPHY3Vc1hLAinoe9b
         Kb01W8vtxCK7Y2ShzKrvS58fYP8HzrA6Gd/6+JFi9ou6d/XpRbtCxAikvLRF4CPquPCG
         ClBzEKva55/8eyzg2wz49Gsj5iHmVnvMiVnhUrT9nBpxPZG87MfQkkyu8OXSgPV2YnyG
         0HCQ==
X-Gm-Message-State: APuU4Z9ldcM1a3OvekS5laGgv2xrqgSgPF+TUOQStRtyEoNvByV62pBb
	ILuIL6iWzRkV3Ah4zDDbx9b+u+nD6lf8etN/mlRY1ovmFEg+nFfb6fpkDHh6lzMa3bCGXcralMD
	vZLsECNXUboFZBkIYLg==
X-Received: from edfg4-n2.prod.google.com ([2002:a05:6402:a244:20b0:6b5:813f:c569])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:13c5:b0:6b5:76be:be54 with SMTP id 4fb4d7f45d1cf-6b777829b2fmr85425a12.35.1794335147866;
 Tue, 10 Nov 2026 10:25:47 -0800 (PST)
Date: Tue, 10 Nov 2026 18:25:47 +0000
In-Reply-To: <DMRMLZSZ0LAZ.D4P70QWX0IHB@soleen.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-6-tarunsahu@google.com>
 <DMRMLZSZ0LAZ.D4P70QWX0IHB@soleen.com>
Message-ID: <9huz5wy4tufo.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI compatibility
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

"Pasha Tatashin" <pasha.tatashin@soleen.com> writes:

> On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:
>
>> +/**
>> + * DECLARE_KHO_SER - Register a serialized payload structure with KHO.
>> + * @name:         Structure tag name (e.g. luo_ser).
>> + * @payload_size: Compile-time expected size of struct @name in bytes.
>> + * @nr_required:  Total number of defined required features.
>> + * @nr_optional:  Total number of defined optional features.
>> + *
>> + * Size and 8-byte alignment are asserted under CONFIG_64BIT: KHO and LUO are
>> + * 64-bit only, while !CONFIG_KEXEC_HANDOVER stubs pull ABI headers into
>> + * 32-bit builds where u64 has 4-byte or 2-byte alignment.
>> + */
>> +#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)	\
>> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
>> +		      sizeof(struct name) == (payload_size),		\
>> +		      "struct " #name " size mismatch");		\
>> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
>> +		      __alignof__(struct name) == 8,			\
>> +		      "struct " #name " must be 8-byte aligned");	\
>> +	extern struct kho_ser_hdr __kho_ser_hdr_##name;			\
>
> Remove this extern.
>
>> +	enum {								\
>> +		__KHO_SER_SIZE_##name = (payload_size),			\
>> +		__KHO_SER_NR_REQUIRED_##name = (nr_required),		\
>> +		__KHO_SER_NR_OPTIONAL_##name = (nr_optional),		\
>> +	}
>> +
>> +/**
>> + * DECLARE_KHO_SER_HDR - Declare a feature header variable, field, or parameter.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + * @decl: Declarator (e.g. *fhdr, **out_fhdr, or * inside DECLARE_KHOSER_PTR).
>> + *
>> + * Declares @decl with type struct kho_ser_hdr while checking at compile time
>> + * that @name was registered with DECLARE_KHO_SER(), documenting which
>> + * serialized payload structure a feature header pointer belongs to.
>> + */
>> +#define DECLARE_KHO_SER_HDR(name, decl)	typeof(__kho_ser_hdr_##name) decl
>
> Remove DECLARE_KHO_SER_HDR, use kho_ser_hdr directly.


I added this, because wherever in the kernel a serialized struture is
preceded with kho_ser_hdr, it will only be called `struct kho_ser_hdr
fhdr` which does not display (to readers) that this declaration of
header variable is not alone, it also holds the serialized structure
after this variable.

Using this macro, it clearly explain, that "Hey, I am header to this
serialized struct and I am compiled time initalized using
DECLARE_KHO_SER for this serialized structure and my pointer holds
location to both feature header followed by serialized structure."

Techinically this is just for readability.

WDYT?

~Tarun

>
> -- 
> Pasha
