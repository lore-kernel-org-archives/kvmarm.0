Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D312327A462
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 16:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753200127; cv=none; b=puOZG7+R4fmeI3O67gB/DVc0cQEzLXN6lwGTr5SmBJHrDGTbkqW+Lv8BnBaa1nSkBqlCK5YvU4UZ8rx53NNLPROz5W9khDY53MdWiNdMk2DzcAZQBhtt7noziXxUsjx9mRx0Lit5UKaz710pbUSF2GV7MG187Uti8jhm+wQaSc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753200127; c=relaxed/simple;
	bh=9LyYeLmky4Pxwkj3LVEv54HpdyvuC1ah0EvaCPHukc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T1P2BwkOAOBEe+Ph/p+sKLZJxh1NvBy8YN3owMxDE/5U32Sr+i0DPN3yJPbZIxzhBwNcq9mmGVYTowUZ8Z72g02tPmdIFnwoogUgzuGuNpHX0IUTviZjV03uFrtCLUFSgc7slu7Rd49HjBC/MswHyREPdSRfMX2ZPcQB06FMYUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AqVwC+nL; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AqVwC+nL"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso226611cf.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 09:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753200125; x=1753804925; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zJ5oDalvHQQyRD506B9hQPa7CZetF/bu3rVEuMz2nko=;
        b=AqVwC+nLGp9rQAQxUJ2hqFUMTLdc16K/TyNObQbJEFx6YNIebBAV2GmA9LEaJD5baF
         WU4DvBpHHVVHWc+ZMwwtchbLpwq7j0LcBYaz8YXJh2HbNZRvxBJFJU7CwIPmpL2hMuJn
         Z7TuEqoCPGEhI2PhcJ7/hoPKE8200vGynw+kRBU9/1G9NhPJ2ws6P+IuWjLh7HSO9Q54
         afAZv5wVlhj82DJqmffVFdVFlA/f7Cp2AuYqCRAHVB5n0aynBFoIDx0jlXFr9s0pqXf8
         0OnAaAX24bfYjVSiJVgF59is38QE/TmzWTVR6gSy7EDYxaMnL2vochyWnQSk5kgyL60t
         auDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753200125; x=1753804925;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zJ5oDalvHQQyRD506B9hQPa7CZetF/bu3rVEuMz2nko=;
        b=o74/fzk4QScNBfgUleklTNE829etTI9e2k949fBiL2Xmu7RMZlSkaBrw93OpbQjBkA
         vHMiCNIiiozADRQsAgfhua+ZmsaKtzsQaTvnUy1PqpBlmyRLv84GrJ4a1cwHcAI+5+0f
         S+EcggqgnQvKKY7lvR/tg50tPLIKnMRLKMHoLUheLc8rliJQz2m7/JDCtmz/wJ9WA4AZ
         4Q4vSjLQcrzxXHARwBtKXRARahdvLlwYKUjDUHNSYgBxdse1DTAlKjB2A8nPxmCNxM+d
         2DZFGjQMc2s9JvUlMtkAEaZsXVMla+1JBSCrhwdxUej/U++iZHgm2XIpTBDD5hHdQi4b
         4mpg==
X-Forwarded-Encrypted: i=1; AJvYcCWQPVB+b8iHnaFM2zYA9VD4Q6/5PKUKyYfwqObSzMO1lHQCRnxuyIQbnp8N7l8tIK4A28bzT8I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9Nhr5CQQFaBvY/AiW34DKLtkvstq/bHQ9KX3D9knPqYOHtTix
	R/bdqeAL7Y/u7WgcL3lEV8Y4JfEFVM7g14KWLw/JFtNQ5pQvQ9rdclgjILaRsedI4E7mJ/s3Gku
	z+cjkMynzs8CEUmKOOv761Fttu2GfHHi/uK58+PLZ
X-Gm-Gg: ASbGncvL4raQoB4AVPhoL6MIBPhbLJxZftQdLjMPq916S6LYpyLwvRCrZaL6PNjDyEH
	riZ8+hazqJxcnf50VCE9epwUZxbuYZ+fCyOu0PoanCH+HaVM5LZMlFnJD6XzEfsZCOtSSsoqD8C
	0JN95K6b+G1D360Z0JyyDAgniX0StfyP4/KVaoulI8Xk/nlE8tQPpxNH+iU41oTqXLeyNPKR0qn
	BmoG+WeCJZJSrfCWg==
X-Google-Smtp-Source: AGHT+IHz1Md5CvjkMr0v63+zalLU7h1VJHuKRRiw/5Kb9EG5psNH9QWi7eZC9q9jEanCdF+aUxZTXQqWhAN+64R/RQ8=
X-Received: by 2002:ac8:628c:0:b0:494:4aa0:ad5b with SMTP id
 d75a77b69052e-4ae5cc6db00mr4063241cf.2.1753200124082; Tue, 22 Jul 2025
 09:02:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com> <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
 <aH-1JeJH2cEvyEei@google.com>
In-Reply-To: <aH-1JeJH2cEvyEei@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 17:01:27 +0100
X-Gm-Features: Ac12FXztwmXhhi72jh3H00X5S1zdW7e0Z4aKDTPt7mq7MLiUgNVB0JPJsFGM4PY
Message-ID: <CA+EHjTw46a+NCcgGXQ1HA+a3MSZD9Q97V8W-Xj5+pYuTh4Z2_w@mail.gmail.com>
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

On Tue, 22 Jul 2025 at 16:58, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > > > cleaner resting state (see the diff stats).
> > > >
> > > > So just so that I am clear, applying the diff below to the appropriate
> > > > patches would address all the concerns that you have mentioned in this
> > > > email?
> > >
> > > Yes?  It should, I just don't want to pinky swear in case I botched something.
> >
> > Other than this patch not applying, nah, I think it's all good ;P. I
> > guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
> > somewhere in a local tree of yours. There are quite a few conflicts
> > and I don't think it would build even if based on the right tree,
> > e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
> > rather an addition of an undeclared identifier.
> >
> > That said, I think I understand what you mean, and I can apply the
> > spirit of this patch.
> >
> > Stay tuned for v16.
>
> Want to point me at your branch?  I can run it through my battery of tests, and
> maybe save you/us from having to spin a v17.

That would be great. Here it is:

https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-basic-6.16-v16

No known issues from my end. But can you have a look at the patch:

KVM: guest_memfd: Consolidate Kconfig and guest_memfd enable checks

In that I collected the changes to the config/enable checks that
didn't seem to fit well in any of the other patches.

Cheers,
/fuad
