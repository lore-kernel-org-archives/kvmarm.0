Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32C12EE98E
	for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 12:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670495; cv=none; b=Eg/JZhZVBpgikwQF7drF195S+hW1lVRzWiLj1CVLOLYJPDYUbt7/KvKRp5S4yP69eZoxvPQnjH68+UDPWRnGcLr6clDXzBlcxPGT28yp8yex80MUIj6o3wzYstlfggWRB8O7G6ykHf+w6hEwePmIdiHHJU9jCKwTaVk7v+4wIHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670495; c=relaxed/simple;
	bh=AAemU8l07qLqvOU5KWKHhv6y1M/uqASoO8wNBjzSk0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AFtfvWK/e/+6AfpYpNKGgSZ7AxHyjLEWO/JIu4feYzH0a3/pnlfiDEweJiNG9/YkUjnGW6ftRwwDf9/6laTitdIGzyvtfG7POtDHhiQMmi56yRE2rclubLX3od25Ntq5dxSHcN2N1yNCAnASP4muJrDV3JXTv6zdqudDCQbAGZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uy7VolTO; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uy7VolTO"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ab3855fca3so192411cf.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 05:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752670493; x=1753275293; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j8ldmZ55jy5ZaXuomv0Qov+zBm2r6aMGVRc2HGPVpC4=;
        b=Uy7VolTOggnRLzdgAm7ueje/aWvWJmy6RsfTQVJGz7DR+Cv9JWM7xjIWfrZRKVcnGS
         gu6VBq7FoW4BJsMrXqJHvhYjCr7MXZdJxNONlQmhN56TG0rw69dLK+2/jkNmPXqNxvXW
         YtSBrFzJGl19fnT5A6URK3uTdsQuFDaICrvI1has0Tmc+/BfQxd85h9AhFL8hP+BHif/
         imvEPYlq/3w3NZwwUYdjnFz7OC7/gI12S7NihRkgtn7rf+9Ahy2uD+E49zoK/m3Af953
         AlBN4INNUXpxuc4Cv/XSUy9/Pu1rvYv0SxDJFjZzIsfI18JbRBS1n9IONLt/72rUfaGp
         PYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752670493; x=1753275293;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j8ldmZ55jy5ZaXuomv0Qov+zBm2r6aMGVRc2HGPVpC4=;
        b=vf0AprVKT6y9IhDteUARkOwOfBSBAmMVRsibwk2imG3UZ7eWWNFuBouMOMzEBzlXrY
         6BnbWgjBjUKEtuEkf4aaExMy83e1rxiKmuuoryfNpIQerC8WVO89gOQWCG6K/FwubjdN
         KOPsJDTwG6sGdWBYSHjImXeXLptWM4kn8k700zeTq7iFY9sfNfaZB9fmKTvQJuKsvy+B
         19hYBwCzXrmvnGJDaKPErcDT0uj6/SQKgJAEUFyTj7jgc9ok1dCPNq9iRZHTYRQ+BZTK
         zRsfRjPhf9QDDo0QPDKAf2/VP0vlwxlYReLI4+Fin8l2kDpZUslheB82W/mzOt0xUQRe
         RT7w==
X-Forwarded-Encrypted: i=1; AJvYcCWnyWXptO9dvIrqzRLPGKF6jngdkJcJQNaozp4C8ol16liN+t/Ue0Myd0JM5oC00tBZBy1Vw+w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxD3Qd65lvJB1L5PMTtPvDErpvcpDD0TcdsjOM366cd56FBvsyN
	qUbqXHCrDBrhIsI7XSZTs1QTbF4gWbLgaFK5kMQMXAAFEcp6fQp99VOIgA4CrAIRe8aAdCgfoeT
	zgejNObWZkO7nk+pQ9A5kQXYucC+3ma7uVxuKSFU8
X-Gm-Gg: ASbGnct6H8s3ye2HjHm7W2JY9f8QpNPx6qxyo4onASOYTJ7vqlYpN6WKNY7SjXYj0bf
	NgXIYCktfYkg5ueFz2b796FlbXUaJ6dS2pL8FSyItdJpNIUihxJParO/0OnEI/nhBd+q5YOBHz0
	iv9YdK4xo1YWs3U8uHdJObt5G+7+M4sqrRd/7ZH7MPaO0ARuX5FjBO0th2qGLd4MRsSa8vQ1xsa
	0wOVeMdb7qjPb+eYU5cV4mf6cOY6qXRwNU=
X-Google-Smtp-Source: AGHT+IG5QZXwMh/pWZ7YvuTyEUvPla3aSmPB5N9IHixBAAJw9oVvqZOIDmKNLn+4MKe74P7oCrt5WimSbibRGo5z6oU=
X-Received: by 2002:a05:622a:1aa0:b0:4a9:b6e1:15a with SMTP id
 d75a77b69052e-4ab954d8746mr2689661cf.24.1752670492218; Wed, 16 Jul 2025
 05:54:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-3-tabba@google.com>
 <a4091b13-9c3b-48bf-a7f6-f56868224cf5@intel.com> <CA+EHjTy5zUJt5n5N1tRyHUQN6-P6CPqyC7+6Zqhokx-3=mvx+A@mail.gmail.com>
 <418ddbbd-c25e-4047-9317-c05735e02807@intel.com> <778ca011-1b2f-4818-80c6-ac597809ec77@redhat.com>
 <6927a67b-cd2e-45f1-8e6b-019df7a7417e@intel.com> <CA+EHjTz7C4WgS2-Dw0gywHy+zguSNXKToukPiRfsdiY8+Eq6KA@mail.gmail.com>
 <47395660-79ad-4d22-87b0-c5bf891f708c@redhat.com> <fa1ccce7-40d3-45d2-9865-524f4b187963@intel.com>
 <f7a54cc4-1017-4e32-85b8-cf74237db935@redhat.com> <CA+EHjTzOqCpcaNU4caddh6N3bCO0GvrOoZ+rMApdRh4=+BEXNA@mail.gmail.com>
 <c8b74572-3ed3-4a93-8433-1207e59f56e7@intel.com>
In-Reply-To: <c8b74572-3ed3-4a93-8433-1207e59f56e7@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 16 Jul 2025 13:54:15 +0100
X-Gm-Features: Ac12FXyFhk5Ea2iRIAOGi8JPKWZm4iBDcstyagLqnmugwx2wsA5Hot8K1UY8_ZA
Message-ID: <CA+EHjTzjxGqkaUkGvsUn+GXgKxUh3nsajRSbVmOszsLcAqVzcA@mail.gmail.com>
Subject: Re: [PATCH v14 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

Hi Xiaoyao,

<snip>
> Not really the same result.
>
> The two-step patches I proposed doesn't produce the below thing of this
> original patch. It doesn't make sense to select
> KVM_GENERIC_GMEM_POPULATE for KVM_SW_PROTECTED_VM from the name.

I think I see where you're going. That said, other than in the
configuration files, in all the actual code, the purpose of
KVM_GENERIC_PRIVATE_MEMis to guard  kvm_gmem_populate(). So
I disagree with you, and I think that this should be one patch that
fixes the name. That said, I agree with you regarding:

-       select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
+       select KVM_GENERIC_MEMORY_ATTRIBUTES if KVM_SW_PROTECTED_VM
+       select KVM_GMEM if KVM_SW_PROTECTED_VM

Cheers,
/fuad
