Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCC32DC348
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 09:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753176621; cv=none; b=SVdrOkahMyczypIsbXinUzcE6YsKFHGRh6N9lAKXId23WHzhnAwHTI7nI2MC5OI6ZVWWgRqrpZ+xMJphzoBU0tbkn2qO8FowndpRWTX4gv7mGex/e0yRLqcWul4x6pl4olpofYU3wjFUk4QoBsTlZuuJIuxA4x/D1WaSK6ouLcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753176621; c=relaxed/simple;
	bh=NZOwWDer9kFTaMnL2fjpUdAJbg9zTprfuYL3AUD+ssQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mfizt+mvSlbkbSZ1yr96Z3YkfQE4pHZM4PMl/PZBTWcu7eIsa/L/GOSGUYuHdEB/3w4bJLVsts2OeejhPxbFd1XX4UvR5xL+QnuxOxwlNW8fwHA7WWMeeP6yCrJEHT5uznF2spoO+tVJSBdIN7V82AjreYEzzWRXrZ5QsIsGlTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c4/oKmQ/; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c4/oKmQ/"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ab86a29c98so276361cf.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 02:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753176619; x=1753781419; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tJ3NUgk3lgCY61pzl+Ni6KBJ9PADbvzhkTcNBzb1Rl0=;
        b=c4/oKmQ//ON1897tDGLpWV+e4VapJt5E2M9ZW1OIdUayTpndoAmStMXvNfC93peh+P
         Qa87wVMrbVaJU9DSn/SRDEExrE/Wbyg29EXyslOdFC9zRHOIesUTqbcs2AJXHKOUH9K3
         kWWjz875Utxd80rvoxnr9Ff34v5ayi0lCD3kY/hXY7VfZhiqhqrwpZEWY4Z2DZmo+wgc
         RO/GksVp9EpV1bk5pedaiTiVqqSA2ZaKPneiU6G0rE0DVSYqI+Dk8YFGK9OtNmHIwNzh
         suvcJQ91QRkpppHGCM1keDDzlik4zKTriEB89ShDpjGDUqtLrHxQoVLDWR+kTH/iu2rM
         XuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753176619; x=1753781419;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJ3NUgk3lgCY61pzl+Ni6KBJ9PADbvzhkTcNBzb1Rl0=;
        b=jVoHcITbf7k447tOUf08R2xElNLLjtW1QjMEiDEPq2JFhic+WKoijJpeyBHcolKFTr
         tGycLlNNjpHyLPouVspE2ckXdlfNi+pXGqku75n491fkzRV9Pavzpjj1dgM9Jbs78WMx
         sbqmJq1/J/tQfnJoD5uQvWOr1SHddawxgS5et6V9fUvj9PKVgdNP96NywDNfV5LmBx4k
         lb72jpQzTyXAzOJgfie6zi9TphTIM+ceGwaUYsZIiVCVWhAsXT3e9Vl+5J7wGjgaqLrf
         LifrbThj4Gs1CiPRjsqD+608FFQksRr/Hx/qRYnkJ4g/NFsGmFtN/yNxxW4fQ3SFnsU7
         14Sg==
X-Forwarded-Encrypted: i=1; AJvYcCVLTbtddpN5sbOp76OKLjsymtleuIxS0eae4HalwD/VVDbhKJgL55DZSIpi4kBLZc1hhtUPap0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDbT44sM+xpeRzG/Od5NuLu5PrrEuI2zH7lis76CnvK97NLfUU
	TnkWl/BMccvw8dtSCfNnbPhq7Ob/3tjaWT4M/oGiKyxCc+5kMmxk0V/F62FZuUconsxKgyu/E5k
	JDMfaN7DdR2kPeAA+UXjof2XrY6S7ZzMHmW9hPaJ6
X-Gm-Gg: ASbGncubaY9v9QgVVjtLc2c3bu34+e5T2mSEThjJcutXGL8zfzF/gYQSnzGS/WObBRz
	ZSjijTEWRXCCNesSN4VJ62bitvtAWTSeXhd+Gnk2hIk+qizi3xr8dn4BpblfHfGHWCViDnuAunk
	qlaM+hSnfXQ5o1kpHhAlHDY5vCNkw3iY71LUQbM+IgjVg6wh0ZCRRsVyhY5ZwUygYLQQN3Vp2EM
	1qf5je5BUu+t5Ik3Jp9At9oG2kFhy6NonWF
X-Google-Smtp-Source: AGHT+IHbd/BHMQdknwRTeYIHxdE5noPZ3kOvGg+B20+8ARSixzBI5h5DcNA/xdxCHeDrHowFoGGJAOmBsTNjOtbFr6w=
X-Received: by 2002:ac8:5707:0:b0:4a9:d263:dbc5 with SMTP id
 d75a77b69052e-4ae5cdcbf2fmr3451501cf.20.1753176618461; Tue, 22 Jul 2025
 02:30:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com>
In-Reply-To: <aH552woocYo1ueiU@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 10:29:42 +0100
X-Gm-Features: Ac12FXz-lwaWaACHfhK57yuAA5YnGjuXlhFfMAwyHrdRb3Dv43qkJ8E0aH-WQ58
Message-ID: <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"

On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > cleaner resting state (see the diff stats).
> >
> > So just so that I am clear, applying the diff below to the appropriate
> > patches would address all the concerns that you have mentioned in this
> > email?
>
> Yes?  It should, I just don't want to pinky swear in case I botched something.

Other than this patch not applying, nah, I think it's all good ;P. I
guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
somewhere in a local tree of yours. There are quite a few conflicts
and I don't think it would build even if based on the right tree,
e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
rather an addition of an undeclared identifier.

That said, I think I understand what you mean, and I can apply the
spirit of this patch.

Stay tuned for v16.
/fuad

> But goofs aside, yes, if the end result looks like what was the below, I'm happy.
> Again, things might get ugly in the process, i.e. might be temporariliy gross,
> but that's ok (within reason).
