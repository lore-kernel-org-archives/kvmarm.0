Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795147224;
	b=5LGHq5G+xNKJ480eoid5b1YyQktXxxVcvqKtxzyU9YcNmlhUi1bLywPP0cQZZLLrvO/T
	 0ro7vl0mAqj1K6T9qCFQCBTHt4hVkod7Q5rgfZAsHzVJrd/ZLpaHZrQK0+bc+g/3PcpOy
	 vBk/j1HqWaX13Dm6RIuH3i8FE8jgIdYS985fkXBmvVeo0LByj4hW6Z4yidMfmu34C4bRV
	 nXAwWC7fcnA94aHILalO5A4uUQQwo96hAZeO5/JvNPURzkh2rhrNE35z2Cw9srlFX3ip3
	 dajVxzZpWbqis/PusTp7knSxCZNpdiP9M0vtNKHkMKW6cDhXGlfwMcYQ0S2cWtxYG/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795147224;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=K98FROqv30LP4AMm6nG2V0NGt/4i9m8U/QmIKGR/nHA=;
	b=Ci22iYSPyfwCLDDnFnrMDjoH9os2ZTp5gRw4xv5klGunW3TcN8/Od4w6xPOBWZ4SuZ4X
	 dF7KiAGsOdJ05wQsJzw7HORRoFIXLqWZeQPtSYGIpwznkfoIqHTrBKpVfBo62CSnhgEgA
	 yAIIoDhHawfWVJhQCZixxHEX4LXkinK6a5eRHHw8cukfVnYTBDcxX3/6rxBvsFdHJrf5y
	 uUCpGECQDArOdZlrvWyB8iDbuBoSe+50KCPtNGj+7WTuxNaLaD3UaKx8JHxwNPQTkKQkP
	 iXhn3s0edx49GG6b4a0VgYMR1PrfL/ogR7jpnPKkhLdF9lUaM9NHKUR7oyiUNUWifDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Zxf/yV9a";
	arc=none smtp.remote-ip=209.85.208.70
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D626606A325
	for <kvmarm@lists.linux.dev>; Fri, 20 Nov 2026 04:00:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D626606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Zxf/yV9a
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6b5654ad27fso298371a12.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 20:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795147223; x=1795752023; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K98FROqv30LP4AMm6nG2V0NGt/4i9m8U/QmIKGR/nHA=;
        b=Zxf/yV9aaHa2VV29USdqQ5n9t9Guir4IrounD0aY1RI7xjEo8exCh6WyN2v2S7oYX4
         dEVSUxvMnO+XtBgUETzkInEiRpMOM2ytqqIwIy6PLC+5WaqAk9P19AqSd7VCzjGqqabe
         2i4TbuC32GrkrMcT2u7ZdzmgWebIr7If7okkxbCFnBAuPlJyMM0laFntEs/sbAvyInkw
         8uVHtlMKNR6w5lD3g2pzhMR3G2ARnfXXB8a0/7u2Ip327GOmujUUd9GsAghdmyXNakvR
         uM7ioTrUIXIm9RcLzGwNgstIz757Mt0owRz4eMU0PdTkv/DDfs3BNM7WyQd6HmmUUTDu
         CJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795147223; x=1795752023;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K98FROqv30LP4AMm6nG2V0NGt/4i9m8U/QmIKGR/nHA=;
        b=I7zmpO/m6EASMzkVo7x3p4MZ9eACrbxPVv/tD+XY4Q5R+jAFk9Z8RqfvFeyIvhTX9a
         ogsnsmguEdl1mXLsJNtfBMXu5vBWsRKHMld7z/xbLmO9T7vuonkUOTeb5ctw90ISnEcX
         bE4uadNqdou75embldLyhVn6XKSPLFCYvwEMbyP3oQSDuyt0/+mjvN7ih9tP483wG7o/
         CJ9ZgQ8nwiyJ+JLnJJbqbOzs5WEMRz86OwYV/4dMp/puOjhX8vZ4tE8Z5FxAd5m3kYlA
         ECEX8N5hs4fxC1G02JvTe4BDDA9pFc7J7SBWqhhkZYaee+ZqrTQJzHleTgKBOIzx77st
         rYGg==
X-Forwarded-Encrypted: i=1; AL+hErEve3gqIepVN5g+YXLds/Yb1/uf7A5gjaUPjXF+blbubqGrKiWlHlo18LJSaSXWhfzA2AKM83E=@lists.linux.dev
X-Gm-Message-State: APuU4Z/qvsiPshZo52+NgSmq44yoNobIR5l/ueQ+/iFK7I9AUJ1UvJT0
	TLJx+M0Q/DDWCS4bJowhfJqkRrVVHAUjXA/o9no8owRkTzdStIgULVtXaaEbvzkBZe+cb9ce7Km
	C1cOlbQTdJTXorkIcug==
X-Received: from edeg3.prod.google.com ([2002:a05:6402:5643:b0:6b8:a08a:8bad])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:501c:b0:6b8:afbd:64e6 with SMTP id 4fb4d7f45d1cf-6ba37edaf1cmr1021371a12.42.1795147222675;
 Thu, 19 Nov 2026 20:00:22 -0800 (PST)
Date: Fri, 20 Nov 2026 04:00:21 +0000
In-Reply-To: <20261115203421.38c206b35f5b12e6@chrisdown.name>
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
 <DMRMLZSZ0LAZ.D4P70QWX0IHB@soleen.com> <9huz5wy4tufo.fsf@tarunix.c.googlers.com>
 <20261115203421.38c206b35f5b12e6@chrisdown.name>
Message-ID: <9huzmrr4f8yy.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI compatibility
From: tarunsahu@google.com
To: Chris Down <chris@chrisdown.name>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org, 
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Chris Down <chris@chrisdown.name> writes:

> Hi Tarun,
>
> tarunsahu@google.com writes:
>>Techinically this is just for readability.
>>
>>WDYT?
>
> It doesn't help readability in the generated docs, though. kernel-doc
> splits the parameter list on the comma inside the macro, so
> kho_preserve_vmalloc() comes out as
>
>      int kho_preserve_vmalloc (void *ptr, DECLARE_KHO_SER_HDR(kho_vmalloc# *fhdr))
>
> and the struct memfd_luo_ser and struct luo_session_ser definitions in the
> ABI docs end up with a member like
>
>      DECLARE_KHO_SER_HDR(kho_vmalloc folios_fhdr;
>
> I'd go with Pasha's suggestion and use struct kho_ser_hdr directly. The
> pointer can then say which payload follows it with a comment.

Okay that works. Thanks Chris, I will update it.

~Tarun

>
> Chris
