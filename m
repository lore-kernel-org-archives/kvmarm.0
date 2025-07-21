Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13212D63F3
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753109236; cv=none; b=qulBxyS89HM/k3/wSIsdq2fPQQ44ib03jlh7qAIZdOgca9nKlYkzuOerRN6y8uqojxxUojp13v4RcOyjoNhOUjx378dKgaLemPfVPVnniP0xzgQGn9aRKkycw9Q6vXmtfFmjH7RV2iOCAoPDdr4ECD5teS5uxPyOX2q6dGkjFg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753109236; c=relaxed/simple;
	bh=HI2Eq1XFMFwBXQQOwsx0GY6/RMpiizz+jBnMiq7HC5k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Sz0HyelNUAWMuBB5aYqfGsYLFBoYCuGeTZzeUFsA2xgTwfQK0DE2yP207Nf+kL1/9Su6cY5eYxQGcAokDlZQswH1Zcl3g8mYpSz8O7QdJpUzN4HzM8sIUPoQTVAoCbJCJJOQ7K0/RfNn5oVSEYyACSdXI4JiFaN4EptJWxBYEyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2zxMLS5j; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2zxMLS5j"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235e1d70d67so40483365ad.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 07:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753109234; x=1753714034; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ffOtNEBmbjqizvgQ4vhm5l8UrMZzIYK2/Gg6fgZ0b+8=;
        b=2zxMLS5jMDJQH+nLLIEPZRiHCGKAYmtTp4iXVtwsLLPzFJmlf57DbKSJFn2hBgDicC
         fdOZeQT1EvwEotCw9wPg+G3oK91FJP6KZtddpoasQ1D+lHzP/Q6bzOo/rGJezPFbEf7A
         JFX8syzGFpxj9TeBIG/TD7OOwWx5V7kcSws7e4xYwNcdc7UfEYyxFc3DHnPYtQjqGYfB
         TPAbXuoQJMuQfByruLopgIpHQSVeW4g6FtDk8WcLS/aCe/MKJHsEtGczCtMen7meO8cd
         KRgeHCC03MQ7CXEf5b9IhJqTpZ6ZPZ/xEXijJvKAFbpQxtePYdvUbJdYTwnrL+BPhx5H
         s6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753109234; x=1753714034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ffOtNEBmbjqizvgQ4vhm5l8UrMZzIYK2/Gg6fgZ0b+8=;
        b=SmoNZCiA6dgsB+vgHs8YcV0pNd6+pNnjZiAYvl27p3FB/D/sfG0JTD7CDMf2C7fQbt
         WzFsGHRGLgditGMLwuPY5PH8AAwOwLHzwhQjsaCm1p+ZP7otQtlAf5y04V37Ak3h539v
         m0iKf2RqUcQsIT+efFKwqaTErWYH1QjKP+fV4Ve3VAS5Tdw8bojQPs+zPbDi7GV5Thg1
         f/Ob0RWg5955UeCgJ9RnNt5xOVhLbbMVpaCbMYSZbBFCvhaocA34bfqVMX/hIQryUe5h
         TnYCU0qMTB2Q7ogm2lyxLuB+SKHgvhD80Afny8SyMPUHnDJUWCdEJ4f9tdM0wWnHYRyO
         H+jw==
X-Forwarded-Encrypted: i=1; AJvYcCUD0jqJ0Yo1l0pZzSFRqx4N82U2LH0kp+ECVYujBykhiBpgIRDo2d7Y0nMZ2uwrNVD6IxFCqcM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxcj6JwFhFybvlsfulEU2ACk5+p5HYXBWIIISgr5L3N65Hh2iLe
	SVVpl8hh848V2wTD+zi3G1eZaNmmZo39rZWvDlEuLNZDSLFKSFR6pXCcqLk+kjwS6+a0arL4pTd
	8Bk0TTQ==
X-Google-Smtp-Source: AGHT+IGdzbBSF5af55nYsZY9Q+1tI4Xjkxsmb5nVNCaysEuaq1dpjZGyCGgJvydc4U55ykW3wDMcDR7ynNM=
X-Received: from pjp6.prod.google.com ([2002:a17:90b:55c6:b0:30e:5bd5:880d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e547:b0:235:eb71:a37b
 with SMTP id d9443c01a7336-23e25776833mr368910515ad.46.1753109233689; Mon, 21
 Jul 2025 07:47:13 -0700 (PDT)
Date: Mon, 21 Jul 2025 07:47:12 -0700
In-Reply-To: <ffb23653-058a-426e-9571-51784a77ad3d@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-4-tabba@google.com>
 <ffb23653-058a-426e-9571-51784a77ad3d@intel.com>
Message-ID: <aH5S8A4NJtusWgqe@google.com>
Subject: Re: [PATCH v15 03/21] KVM: Introduce kvm_arch_supports_gmem()
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
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
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 18, 2025, Xiaoyao Li wrote:
> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > -/* SMM is currently unsupported for guests with private memory. */
> > +/* SMM is currently unsupported for guests with guest_memfd private memory. */
> >   # define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)
> 
> As I commented in the v14, please don't change the comment.

+1, keep it as is.
