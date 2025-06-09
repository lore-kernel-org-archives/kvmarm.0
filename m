Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5A1280334
	for <kvmarm@lists.linux.dev>; Mon,  9 Jun 2025 07:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749452800; cv=none; b=npuc8i7XVMDOYDW0F6N6ryvA8mMESdQnJLLhE1Z/DBl0unsmDWtGRMnE4AuKXgXO3L1r53lj/DOEJ2sELvTO8QCHc2q46B3C9J+ZFqJvqnVEbTn4zIodXYxogBgvhDmPRviytdUcXFyI1LBzyfNeUrYyA8vNimoaYHGpIzVJ3ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749452800; c=relaxed/simple;
	bh=/nYlTVFkGT0OGtHTSp/hNQUXe1GD1QSrgJLAsAVqlnE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CAbqMSWQO6hhtbbhVlvzVqfBTBIBm1CIUW+ni0vtLJ6nXdugOIJaaqTczH+pfq42KnrBOy05ZRnKmMTd4thDg6dOuORV1e2KTEIYd2FDz2EebO1riGAplCi5zUtwr7M77Eb8PhNRQ+Lr68DbEjK8/bAKITh8Vqyl3IHAmh6lUKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AH4n8uWR; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AH4n8uWR"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-47e9fea29easo510621cf.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Jun 2025 00:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749452798; x=1750057598; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=njmwY/aoE2EHkI0yhj8tKMubAoBenpVg25f6lK/8keo=;
        b=AH4n8uWRye8dSpeHTATtaIfsvwlAd1rUryINCPEbqe5YkEeBLLREDoFFV/eG+AHJYP
         7qMbmFMgnQfWOl4LWS8J6doi4RiVfRWiI2aMNikWq9BYijD+Bnh+wJZRFSw+uVIqchlP
         uVA6pzvWggdq79HZjRw24fnHNJxGx4Y1iv6KNFkiVoo+gCxsz98U1I9O4D5NwJTAU6id
         ly47qtz8j8WmKT/Qh3ieXIcQV3tS2zWcxmg/Q1Ce59FSnUF7PZyGPdbZp+jsi6EnNbBc
         cWUNwoq93z5x0f+o9bseAwkb6/mcKNjsc78uRsZchrCI/VuCFQZr31qoMBAxg82ki5eD
         P3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749452798; x=1750057598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njmwY/aoE2EHkI0yhj8tKMubAoBenpVg25f6lK/8keo=;
        b=flNiKPgge18fcBluR1YFvo/3qSvkkobEYe+MHZFX0suLvTgakDCIBH0SrRVwqg8/Gj
         RAON9zRhp5Za4g09V+x2+yKq41P72nzKDiKJEa+MVMxtqD9JK7JcaGD8i8F1AufHlOSD
         9+6RFr7wxh1ddf5yob2Otm0hlkJTi4nzRiT7YTpRS4B7PeLO+Y4gVTycPC5eK5HEjT9T
         fn06R7efou0YR+fInDusBD3w0Yo+pnJPIRaAiPvYnkGOapux7pE6ZI/vxvWMPxi9ftu8
         6CahhEbFC5eU0Jso1kuAJuLXRQA7CAzJrUsyNfWgMrSaRcXxYnkbTWQDmLXsw/vVnJsS
         YH+A==
X-Forwarded-Encrypted: i=1; AJvYcCXVVKs8Zc8KPhSRdMXdpMqV7s1TPghIZAsLTEqe6yNl6PhgcQwrwqCjK7B/PCvnukVTzikVylQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqjKM2vtTAG0Rw6YkxUGaMGrLLijWRcMtykS+wpwI2urDSg0uU
	ZhkrDheTAKpNJiH/o1Wq8NZrRCi658ArPRv056ohIz32i3tZImccoaVnevaYaTKoa6dW8Do9Vkp
	6yiR/6fKGml0n7fqHq9gsDzirQ5M/wFrcz7V4afsp
X-Gm-Gg: ASbGncvpI+fUk/iKsUbsdggR3CA71qqj5Vd9yIpyQXIeImedGq/B0IUWb+wHFH6gnm8
	kwrIGBQdjsxzl4BM1/iwpqht40OkC19UWkOWTLtJyCi6XA7m6F0f/TVlxy17KG32cqwQfHF0yfZ
	u42GBIGolxiul4hYtkOml/bjn6IQeK+oPW6DqC/Dxhmza69ueOpFmzTQ==
X-Google-Smtp-Source: AGHT+IGchZ7SLhMAZ8W5hxY3EegUp7fjwAy75x4g922pGqe4NGnjJFDVi+3Q9Wgft0rlGl/fT20Fa5nQRkS1NNQ9g2g=
X-Received: by 2002:a05:622a:309:b0:494:b06f:7495 with SMTP id
 d75a77b69052e-4a6efa728a3mr5651671cf.24.1749452797818; Mon, 09 Jun 2025
 00:06:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-19-tabba@google.com>
 <df4bfc32-d395-4f0b-8664-5c65e05f5af0@redhat.com>
In-Reply-To: <df4bfc32-d395-4f0b-8664-5c65e05f5af0@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Jun 2025 08:06:01 +0100
X-Gm-Features: AX0GCFtgC2aghzzNsqRBIEjFjyqySUxgD1FLhPdmCAmQ5m2-5RHKx5fP1W3VLwk
Message-ID: <CA+EHjTxoBSpcLUVDhSq=0dmvP9znKqPRtN-mDZ2YTP+6un8NVA@mail.gmail.com>
Subject: Re: [PATCH v11 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
To: Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 9 Jun 2025 at 00:44, Gavin Shan <gshan@redhat.com> wrote:
>
> On 6/6/25 1:38 AM, Fuad Tabba wrote:
> > Expand the guest_memfd selftests to include testing mapping guest
> > memory for VM types that support it.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   .../testing/selftests/kvm/guest_memfd_test.c  | 201 ++++++++++++++++--
> >   1 file changed, 180 insertions(+), 21 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> > index 341ba616cf55..1612d3adcd0d 100644
> > --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> > +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> > @@ -13,6 +13,8 @@
> >
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>


Thanks for the reviews!
/fuad
