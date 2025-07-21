Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCB72E03F7
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 17:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753119198; cv=none; b=h0HhVZ1AAUUo87Ro9yHkmtWFPTGb4Z07dCmI3b80DbVD3YJTYJo6hvdePGYOekYNTH6wMYjAdSj1oXs1DT5+YyOLk5SSrL5sdHoby1MtZhiB0lMcYQ5rud6YBoyxbou4YxfiMSIujuGrQjKSSC/y2nc4TaT8ykBbpXMrWzZB8h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753119198; c=relaxed/simple;
	bh=mNDNOCM/MmTeG8bWN8KzikOsujHMksewTXy/RHZM/qE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PHqbZPJOYj6YxacpfDuZ0T0GfRHxhj2tBDDjNYPa1h7u51J4AUxLdChNhQC7ZCsb9lmoDvaqOSQr3iiYQwX+N/HDj7PP0S5a5/bcFrvrd7wn1tb2HsSkWqqZNF2Z0sGrQojMx3VJ7vU0X1AJ8tfc7VShB9XGbMOxlwNqoTsKs7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V4VRckvl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V4VRckvl"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3141f9ce4e2so6826229a91.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753119197; x=1753723997; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nZ4+t7dcQ2ZTieyIQcNf54MPM3Tf5VMEW4AFMPESUF4=;
        b=V4VRckvld4D5cpkY7hYXjGe2FiBzUENVrsC/TIWXdAm+TRBsIsIp5aYAoxpsgWA63c
         f7Y7WJ38WkDwviX1FkiJ00xgiQASrB515drXL/r6dbjGz27ySI5Pud6aeB/wRxGIDUhA
         rhK5mYHmZg7c4Stpku/HtVDYNZFxxiKp6sofDk6fDpBk/Cf3/Xc/cOVWMOs38D508APe
         VUsEcmtkoSg5x/hkYKtkgounkPPHUdOpxv/wwXroB54rzP2/C8ODAChhoTbbayYfWAqq
         pcZnEl6fE17T0o9GZ2ivtns1iMGmmMofm+iHddwunAe7gqqCDbXn23l9S1BS2lbypWsn
         +OcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753119197; x=1753723997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nZ4+t7dcQ2ZTieyIQcNf54MPM3Tf5VMEW4AFMPESUF4=;
        b=r2CAA11GI0AUrGVbCqoSZIivjo5jVUWeg27y3ApThlg30NCPgVnYuLYIamzRBiX10X
         94wi4VO4ILVyVryBxn+QeEJGNrPZi+BJqPILF1ZMfG4Pd182hwYIIIkJ54cAKTKLGqLY
         sQMSVyuZMY/O2cx4I9JF80XlYr/zwckCvVwnzLpaM+g7FocWwoh3fY2IAHUImLyxnhAx
         T4A8Mtc6mX8KO4c1+QqpLg/ny46uiJqXipmC/FYzkQuxfSSQNnDBWEWM6t6AQqUeYnIs
         lhYgp2bsvt/ReEgxHCbb+YioVeKhOB1BIc0Ruq8QQiBO7C2vj6oX9be4KM/K4g/QO7OL
         5PrQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1jt00KOq+bUu5+m3yBBeGBlNhmEGBj4jtzClIgi7bw13WyPPsXcFZONs4++sv2dnSi0Slads=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaLNkck6ALnkcJPAgmO4iKubTZMFbkXJh8fa38h5dY9w6+pQl1
	IrSmvDrcbC0VvRWSiES73K7lj6ckKzVZqBcpLXKicnETF6PcBNFlJSLG5ylyJx9rr1mXtFWYZhl
	Ff0SKFA==
X-Google-Smtp-Source: AGHT+IFwe3ukJO/AwYaZYv00wIRNUUpc+AWlcSl6+/xV7rqHjeFmT15UCVZr+TsQ5cn11BlfaXrHgArz1CM=
X-Received: from pjbrs12.prod.google.com ([2002:a17:90b:2b8c:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b06:b0:311:f2f6:44ff
 with SMTP id 98e67ed59e1d1-31c9f42400cmr34113055a91.17.1753119196635; Mon, 21
 Jul 2025 10:33:16 -0700 (PDT)
Date: Mon, 21 Jul 2025 10:33:15 -0700
In-Reply-To: <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
Message-ID: <aH552woocYo1ueiU@google.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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

On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > The below diff applies on top.  I'm guessing there may be some intermediate
> > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > series, and there is feedback relevant to future patches), but IMO this is a much
> > cleaner resting state (see the diff stats).
> 
> So just so that I am clear, applying the diff below to the appropriate
> patches would address all the concerns that you have mentioned in this
> email?

Yes?  It should, I just don't want to pinky swear in case I botched something.

But goofs aside, yes, if the end result looks like what was the below, I'm happy.
Again, things might get ugly in the process, i.e. might be temporariliy gross,
but that's ok (within reason).
