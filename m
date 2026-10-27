Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793118075;
	b=HwAXEzsCr7R4awF8yP0P5QeGZH4SnSETUXsg2NYmy/3ZKylEoyE42PRA1NukBgZMlIuj
	 Wk97BrSrJXw/pP9NMGZU8rJ4kmjxCs+00bHi03JAzwLPTOucM1jR1fRrfpVgPrtFiY2BH
	 oiGNyLkrkmxq1qWIh8gZ476DbVfjJIQzjMipBHslZ1rmgOzoFXs00X8qJomY2PRGWKrMw
	 lWiqjBZUaswVK8hPWmv+gH8P52tHZxo+UIm7+YMQO/H/0ZFBSyPfaa/3pTBB8hr0cRae3
	 rFhff/riAaBoHjh1B7zerpaDuULMMY2Q/sGmvxrtgzjS8+Ga4BKqXpga5LCd+uI1VxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793118075;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=PxRb990Xj/uwND6b4fXh9A/3T5i+xI2zB08D/68nqZA=;
	b=hqO4lyI11Bjvr/+j/sRoZ/IWJlKWiqPIolVwFChl30cDRDPXP/jdenYUjS0SdGPV83Kh
	 PmQdojlvDT99U43ARKNgZY3xmgXaj1Obv4rwFRvg0Ou2DXrvpNxVhUPubshgfiLg7psT6
	 gkymLmUBhXoZ48lChZZ91Bf9Pc4jkkGN/vuNOY9DaW1FPDdyWfEyQkJU99Z1Z+iBo1acG
	 mUfFDPKa4QaC9ggIrVD65+VMxJ+zjDvrzu0TcdTigv2Tg8IROxlK6wALTDj9i8XcqajAt
	 LYZaq8nmGcqyEVoMKVhYZqOOKj6WmPl/dURSrYrkGfR55wrvsok53o0hoxxXco9Gj0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=OsE63lTW;
	arc=none smtp.remote-ip=209.85.221.173
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F976606A320
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 16:21:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F976606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=OsE63lTW
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5eac4855401so49000e0c.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 09:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793118073; x=1793722873; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PxRb990Xj/uwND6b4fXh9A/3T5i+xI2zB08D/68nqZA=;
        b=OsE63lTWxQaw7nqE6T/Dwz8uaDWiBINZ5YD03OSKwm/8iblKeBSVZu5ostn4DRGUT6
         Amh7mCOp4r+QF/ocaGJTIRjoUMcSDa29DLR63kxeLHGg3EBThXrEAM6O/gSPTJWgT7tB
         xoIXL4mhc1kYBjqDlPvcu8eFHHhE2euwaO9qv7IUm8vIE8UwmkS8KEpDkKBbMTulW4xw
         ZUmOuo4x8ZUdsmpSInIgOPFRITIPGqfdbHK4unf8yPSUktFizgLXCqbLvMnEU4rPSkaa
         fVYb1et1HEtEq+4wcKRsjlSLGmfthujW+VlkJs5RMGlN9ldzCfO+bUvQkkhRv2xChAhr
         wkCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793118073; x=1793722873;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PxRb990Xj/uwND6b4fXh9A/3T5i+xI2zB08D/68nqZA=;
        b=vEsE5BFeXUajEzuKvg9qyIR7I3xo+rACmcNBvVjQ4cLWs3kip4iQW8KDfG58HlGQd4
         68GBj0mTmS7jtYAurXxMMaHLKDoRiZAaD2sPLpmI/8kx1n0lYGFSbjCQZPerP93VdHLU
         hmRU4dsMmtTbsn7gnGPBT718v4DdxOBInozPRtAX2NCM7tBDEo63xbCtqLqGBHUt9ZqJ
         2AhC5a4mb8Onp8NpXJvTZ9gv8oMYhracolWIunh3aZCEjyzKY6JufgiYNqHhZEbwgzrS
         hMqZQek13hQ8t8D7UVSRBFheSZf0F2MA5n7XV5VueXIvg2w3oeQOyiC1nu3Hc0IEzz9+
         U7Iw==
X-Forwarded-Encrypted: i=1; AKwUvByNmJOMIwoOJd60PCgoQDqHUjOu7xRaUfc9i57jrxQGArhqydqiqBA774aoii9NpSS+LlTnA9Y=@lists.linux.dev
X-Gm-Message-State: AFq9FYKMCxehTXJ9KsT9SlQ4DzbUIIqu+zSAAOlHE0KihANDtMNyX2Mj
	4ww1kkgseusHLWseHWza9JnwOL5leTN+2dj4Ba6QkpAE0UIdjECE1oX21HDrFyR3XMk=
X-Gm-Gg: AYBFou04faB58tyFSkeTcQLU8C/YiTVLK/iUysfu5vn1LDZisTi/3kxpfBkOJYx/Anr
	MP+w5+IjLuOEx9C8ZNSHQ1DmcOMhW7d1h+EZJc5JdhX7t1XRA+899LHl25rnTgfWT15r86XYkfd
	DPH57IoPoL2A/np3wWxD0epPmNgYNbvhyA7jLlzdC09pHA1pnzDUHCkqzyAEG9quf+gO3Db3jkf
	4PDM3/CbYpLePLQF33psfK56wk97URryQU5PSh5g6P42VfnCBsRj6ClkymSyvg+SvPe2vwFaRm4
	sDT2CnoBeR7YS4oSyuPWBdwMQHNrXi9WCl2O9ka6wupWd8SMc1FZsJervPWFcS8RhE/hHxrK3tJ
	0vkYoEux3Kf6AW+LpEedEHFthCBLAWOjiaj7DW8hEWAy/zXAeM8zNG7rOZRdh9a01kM+cePHLFj
	p9fHrbp9Q3qsO4/0JpS8YVKdwPlt9+vWfR9AEquhEBi/zprLRut4JIO7W+gYDoqk9sTVBrRd8BJ
	m+EB1svRM80y8jL1Sy2Q8Ras0wWXlaicga1h4cLMhGYI5SlzrLw9KNlwKOGvuLime6g0IjB4I/w
	s+zQi6TpON9ZwN6cqtyUwsZnYzgUPsisLd8l4R30Gar1Gq16mYXQOq/7q8xEt5VpGM28NWiQozh
	viCf/d5nssxoyR8bLWx54OLPzgN1Jgg==
X-Received: by 2002:a05:6122:1352:b0:5c9:c60e:3a40 with SMTP id 71dfb90a1353d-5ec232e48ecmr4515149e0c.18.1793118073126;
        Tue, 27 Oct 2026 09:21:13 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec4a5f26c7sm304662e0c.9.2026.10.27.09.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 09:21:12 -0700 (PDT)
Date: Tue, 27 Oct 2026 12:21:11 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, tarunsahu@google.com,
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <auDPd6tjzACQVszf@google.com>
References: <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
 <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
 <at-8vkVpN2SF3XgB@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at-8vkVpN2SF3XgB@google.com>

On 10-26 20:49, David Matlack wrote:
> I still think it's not advisable to define name##_wrap since anyone
> could accidentally start using it on the incoming path and we wouldn't
> notice at first (especially since same kernel Live Update tests would
> keep working totally fine). I also don't think asserting the combined
> size buys us anything. The header size is just a function of the
> number of features, and what we are trying to protect against is
> structs embedded in the payload changing size.

Fair point.

> 
> So I would just do:
> 
>   /* Marks struct name as a KHO serialized payload with a kho_ser_hdr. */
>   #define DECLARE_KHO_SER(name, payload_size) \
>           static_assert(sizeof(struct name) == (payload_size))
> 
>   DECLARE_KHO_SER(luo_memfd_ser, 16);

My main requirement is that DECLARE_KHO_SER() in include/linux/kho/abi/ 
must be enforced by the compiler rather than being just a bare 
static_assert() that someone could forget to add. Since kho/abi/ headers 
contain both versioned structs and unversioned sub-structs, it must be 
mandatory to declare versioned structs in kho/abi/ with their 
static_assert size check before the kho_ser_*() helpers can be used on 
them.

So, how about adding enum names like this, that are going to be required 
in accessor functions later:

#define DECLARE_KHO_SER(name, payload_size, nr_feats)             \
    static_assert(sizeof(struct name) == (payload_size),          \
                  "struct " #name " size mismatch");              \
    enum {                                                        \
        __KHO_SER_SIZE_##name = (payload_size),                   \
        __KHO_SER_NR_FEATS_##name = (nr_feats),                   \
    }

> Plus helpers that allocate and initialize the header and return the
> payload as a typed pointer. Both the outgoing and incoming paths find
> the payload the same way, by computing its offset from the header,
> rather than through a struct with a fixed payload offset:
> 
>   /* outgoing */
>   hdr = kho_ser_alloc(luo_memfd_ser, LUO_MEMFD_NR_FEATS);
>   ser = kho_ser_payload(hdr, luo_memfd_ser);
> 
>   /* incoming */
>   hdr = phys_to_virt(args->serialized_data);
>   ser = kho_ser_payload(hdr, luo_memfd_ser);

These would become, where without enum, the init would fail:

#define kho_ser_init(buf, name)                                     \
      __kho_ser_init(buf, __KHO_SER_SIZE_##name,                    \
                          __KHO_SER_NR_FEATS_##name)

And payload can also check the existance of DECLARE_KHO_SER, using 
(expr1, expr2):

#define kho_ser_payload(hdr, name)                                  \
      ((void)__KHO_SER_SIZE_##name,                                 \
       (struct name *)__kho_ser_payload(hdr))

We can also add an optional kho_ser_alloc(name) to allocate, init, and 
preserve.
