Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793122429;
	b=fPNXheD/gg2KkT6DqgZTql/Zjm3/YDBDgKEGcW2WF5IfQSjpQ8iEOYgdzuF2VGmDZqqU
	 EgG29oN9j/UyRbXwuqT1jIQZWfgrb352iACabZC7UMhovOha3LSfbA7i0lzpCUIVrSg0O
	 BGnau9qWGcLql/U3V74qtfnn4NqY1LP4zZzJ0wMUILBlW4Z1o7AI//Bw2oiuDIKln+cWW
	 UYB9uetXZufbfNI1OAP1GM65wSS4U7rzCQa8HsToTpknZ/T4nQ2r19ttpgOqLzvn/TAgZ
	 qRJgE8PLvGZWx3C7b1elm9w2O7aTbGT7CcoJiGhuzsVuQDpDGKEAtVOThiuj8P/iwqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793122429;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Glhm1d7B/bXe7XSf6a+44KZYpto2vUedcbuSuK5V4mM=;
	b=zCQ0dGDLJFes47Kvk/EGIvFKDdfkWTiwNnw1MdLCQp7ArIfmoRnaO2rlPyqmikTlvtdj
	 0g/mWwNaPbgdY4dwTDmlyf8jl8FAFNictW9yYg4xFA8r2Co/PMO5m5Jj7RSv+Z3HQZWqS
	 F/blpBkOTMsQ5a92NcbSwrrU+i6Xiaqcn9Cqa6pw8Ow4UdaVnRE7gznf2fhNUKhrNeA1P
	 o2bWfPoR2Fhzjx7YDbD4SsnCG6FbDOibFmxNBjGhE44lHLPvmhsd94LNx2pp/09tQmXrF
	 PhCC/4GoTe547UGab0ORUC8gCNVRjf+Whb8Pj7HNEmtvs6vY+tsAbQ+njE1SjlpX3Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Lqq6YJPG;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4180606A320
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 17:33:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4180606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Lqq6YJPG
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e8b20a899fso289455ad.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 10:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793122428; x=1793727228; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Glhm1d7B/bXe7XSf6a+44KZYpto2vUedcbuSuK5V4mM=;
        b=Lqq6YJPGw1nlMUaIu3xI5agiT0LzgP0B0KOx9FHXJzGsrL1xTNmyRdxUKpZ4oAf9yO
         h+zesyZovC2RlWtvw8Hje6D9FBqBIpY5lEMOnpJC/NWtYMlFM+iqkJrrdEhVPaw67UnB
         LheggtrVftDlF2ZaVxoMqi21sQ5/C+DcH/cnUN3Yq+PUuADh8UT7l3oQ/r/QJqZx5wzh
         5cOCbSl5Km8DvRgFNU5RLbndpr8GAR2HkEGTijJ5ccGa8Q73XFqz2K5Vl8RWvvPaps2D
         ILw6GjToISq07tk0h7/5AGdSW0hJAzxTGmcA0VbIq8tGTCZeX2A2w2ZnBLnjl8d+RmcJ
         J3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793122428; x=1793727228;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Glhm1d7B/bXe7XSf6a+44KZYpto2vUedcbuSuK5V4mM=;
        b=wiPCSsWRZ4FhuHddMHTnUt+Ik4na/0nKjaQiwqRhgU6Fi3v1bHL5TRWDxima1AIlBX
         4G5ELYooB1oH8Ae6dRjhLQ9Lnmkf8A0wt7F3og3fnB6RgVUTr+WGR68lZ/d+D2oOGPgI
         UsaWYiZc2ArH2S1+YRKDXQ/MwajBPLtE8/FieNiP1Rv9dwVcTlaFkaloLGhp8gVMupI/
         MxalML6EGy56JNTFEPCmcLoMZ0Opy8HUO2LlyEcS7Eag0RJxXKnvGufT4+OYkKYMP8Xp
         +uMgfv7HAVj/d4uvmy6Z+qK/jXBD9Tg69pNPO6laIyN1E6+Pk2v5C3GUIiCbXIYNOpkv
         MpeQ==
X-Forwarded-Encrypted: i=1; AKwUvBwgNXGPd1Q4WI0dXM3wo4WyhJH2cW0Kc+g2kNTwSPOObdTiPMHRhiPuy0mCMZ23IP2eVUS/KK8=@lists.linux.dev
X-Gm-Message-State: AFq9FYL6yoWCoLiHeZkbOmtH89wg7eXlFsgdBmYzmB3tB+dnQHkLJCsB
	xGdNtaNf15WndUYW/CZQaJYGBnRfJBerdJdkvi6Xed3QoLtlPWFelKsvMk5FW/m3AA==
X-Gm-Gg: AYBFou1S9zDxUjd9Jf3c0nh1DL0Nq9vMaXojiC2SqdmkbAhqMykkjPT8UeYHIISZvdV
	VtiICzkw4Mp9JSrLSa8CBJk2U8DzeeK6SmAVUmp5k2y0R+tV2O3FsIvgveoOz0hBuJrnPbg30CH
	JBpyW1SNYWc0DMovKTjvA1QLj/lYd/lpMp0N4e/FGYVcGnUfRYiUefsUQZ21LQIRb0dep2nDboq
	Ig4sMmQSpghnY0IKwpFz/R9GuGyb2SwxgfOjP/bbqO/yaghInIKXxUBxBxLYASJSlByfd8KMNLT
	B8bMvp4J/BBF89bPFSPFCvlhqMX78+8R1/85Jw/7UCVHr1ThVMqlKOCskSpIe4doVmDbeoOyot+
	Z7ewB/Sh18/aFq0A1BOOcUUBZOod6RuudnfCQAlnx03DSm3R2oFw2c1DpRzEgL9hgaibuwXy8UW
	x4pakhrp8HpUPsnQs7lfuJZpIVwt2liTy05stdik+mbBoIIZWzvVFqnxeQ6TXzWrpU51Fe7L5Qu
	gcu/bvlgaiY8Ku0s5qed6FfbdxfAczL8ONS5YgBYPX4bYVtf0hPg1RTJxIyzqQGQeK5ygBgCbrQ
	5zsHLNJl6xWt7eiOUxVWjWgj2ja8GwNgj5OZDUgpqLVqCGyX5TKEqos6EN023jOK4Q==
X-Received: by 2002:a17:903:3d0d:b0:2e9:5507:b52e with SMTP id d9443c01a7336-2eb005a6905mr454945ad.50.1793122427469;
        Tue, 27 Oct 2026 10:33:47 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6bddae0sm12585675ad.35.2026.10.27.10.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 10:33:44 -0700 (PDT)
Date: Tue, 27 Oct 2026 17:33:41 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>,
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>,
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
Message-ID: <auDgdUb3y_ricEq9@google.com>
References: <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
 <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
 <at-8vkVpN2SF3XgB@google.com>
 <auDPd6tjzACQVszf@google.com>
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
In-Reply-To: <auDPd6tjzACQVszf@google.com>

On 2026-10-27 12:21 PM, Pasha Tatashin wrote:

> My main requirement is that DECLARE_KHO_SER() in include/linux/kho/abi/ 
> must be enforced by the compiler rather than being just a bare 
> static_assert() that someone could forget to add. Since kho/abi/ headers 
> contain both versioned structs and unversioned sub-structs, it must be 
> mandatory to declare versioned structs in kho/abi/ with their 
> static_assert size check before the kho_ser_*() helpers can be used on 
> them.
> 
> So, how about adding enum names like this, that are going to be required 
> in accessor functions later:
> 
> #define DECLARE_KHO_SER(name, payload_size, nr_feats)             \
>     static_assert(sizeof(struct name) == (payload_size),          \
>                   "struct " #name " size mismatch");              \
>     enum {                                                        \
>         __KHO_SER_SIZE_##name = (payload_size),                   \
>         __KHO_SER_NR_FEATS_##name = (nr_feats),                   \
>     }

Sounds good. Since you're also on board with splitting required
and optional features [1], this would take both counts:

#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional) \
    static_assert(sizeof(struct name) == (payload_size),              \
                  "struct " #name " size mismatch");                  \
    enum {                                                            \
        __KHO_SER_SIZE_##name = (payload_size),                       \
        __KHO_SER_NR_REQUIRED_##name = (nr_required),                 \
        __KHO_SER_NR_OPTIONAL_##name = (nr_optional),                 \
    }

  DECLARE_KHO_SER(memfd_luo_ser, 16, MEMFD_LUO_NR_REQUIRED, MEMFD_LUO_NR_OPTIONAL);

The incoming path can also use __KHO_SER_NR_OPTIONAL_##name to validate
the incoming header only contains required features that it knows how to
handle:

#define kho_ser_validate(hdr, name) \
    __kho_ser_validate(hdr, __KHO_SER_NR_REQUIRED_##name)

> > Plus helpers that allocate and initialize the header and return the
> > payload as a typed pointer. Both the outgoing and incoming paths find
> > the payload the same way, by computing its offset from the header,
> > rather than through a struct with a fixed payload offset:
> > 
> >   /* outgoing */
> >   hdr = kho_ser_alloc(luo_memfd_ser, LUO_MEMFD_NR_FEATS);
> >   ser = kho_ser_payload(hdr, luo_memfd_ser);
> > 
> >   /* incoming */
> >   hdr = phys_to_virt(args->serialized_data);
> >   ser = kho_ser_payload(hdr, luo_memfd_ser);
> 
> These would become, where without enum, the init would fail:
> 
> #define kho_ser_init(buf, name)                                     \
>       __kho_ser_init(buf, __KHO_SER_SIZE_##name,                    \
>                           __KHO_SER_NR_FEATS_##name)
> 
> And payload can also check the existance of DECLARE_KHO_SER, using 
> (expr1, expr2):
> 
> #define kho_ser_payload(hdr, name)                                  \
>       ((void)__KHO_SER_SIZE_##name,                                 \
>        (struct name *)__kho_ser_payload(hdr))
> 
> We can also add an optional kho_ser_alloc(name) to allocate, init, and 
> preserve.

+1
