Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE53428CF40
	for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 11:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752663949; cv=none; b=gbsyyaj7wPrWqFW8YsM/Ja2HQHB1K5Vkm6GP/A8MR/wX2VmyImKNM0+8JU1bIZEOAmt9KWEi9ECgpnsvlDYDCPdNZ612OFnpLg6lvTZUrhxdyGfXuODG4uGrxJJ4PVeivxif98ByVvzZB6B7FmtygxN/y713g2EkNqGX3cCGP4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752663949; c=relaxed/simple;
	bh=Q0um87P4/3R8smq76yisAQlQe7fLie4Eoep5/bLrQas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n8wRxqIXNzccoPxyWHCmnuW3YAuOJALeniksJ1e/FyK/fzHtNpmFj7WydIxgP8UaVUhK9HKIsOunQxCnMuU+QxhLjT2KexflXinc4qoA0OKwG/yi045ySaFKumWS4WQqbErpqcCqeIVobDgmP0BmwVMxv2f9N8bHqDa1zkY4PgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tu72Fpfd; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tu72Fpfd"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ab86a29c98so410221cf.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 04:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752663947; x=1753268747; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0um87P4/3R8smq76yisAQlQe7fLie4Eoep5/bLrQas=;
        b=Tu72Fpfd012I6QwYa/hkrCL2uHwbDYW75ZEkbfRRp7s7D23aYgfHf3p6pCDEIPCWmr
         bvVjrqSinYfkruMIKt31SYf4bNYxUZIHGmLY8Foe8c0TzLCO00pZWeJnGLnwqYZmMASA
         /bonYwT0TyutQ1eKE/VTGSU077YTZmZ/zuBKZfR3+MAxlbYRM7Cmjt/fr4cBKKR7yyqW
         oUyhAGYwXQU84etw1vWyTc6M0JKUavfiJL/w3AWYkHI666/q1EVzUgN0ScqRCvHIGAmp
         /SGwgl009p9ZEKVs6RVSxSy+JXLwoNfgjhgJK6NHZCJTXnmFR/5WThs8KpqqKTz2lbGM
         yQtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752663947; x=1753268747;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q0um87P4/3R8smq76yisAQlQe7fLie4Eoep5/bLrQas=;
        b=NmrpyheKu2hzKd6HO1ulZTir3/DMGBMYRZuNjcyxvJyoLOyWRJW/WHIGtYrPu6OkDg
         +MR8Ea20HSt4AciRBnT046lOdsLjhk3SfaM1p/1PBKsvJul3a2am2V4cPGRmtQPi1kgW
         rPgkjdt7cZcicI8QIwbtOJ8ouU68c6fRO6Wh1NrrQYmo3BXeNHoFUdwfkqOPxAeQy/rG
         Cmx30qxL5MZIRjnoS06PAuPzUwSrWWTG7Ko2tFhaFH18zaG4qCOQlL0YOEdpjx54hmAH
         zbPm0yRUv2HH1rU9sW/eq26gtGWsn4CH8rn5d2vl4GMF+CztXqDrWuEBBQFEmU9Ejcd2
         Qvtg==
X-Forwarded-Encrypted: i=1; AJvYcCUodz8i7bdEnIohNJ4llourAURwiJmWcqnax50+dtgutc0QXKQ5nay7IUMTQ0UfStevhGJYU/4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYTyy/+KTJzEsWf0D2Ju4bSka5wEtYtTOt3RUqJZCxLKD5bCsK
	6tNd39yz3DWij9jft7+iAwSJL9nWnokDT8cxczWiURt3CpxI6RLsHqlMnXTe6l17f9nbrHVkw7C
	5BV3au/ctLHHKJYfpoovX64IE79cSnR1sijCZzMam
X-Gm-Gg: ASbGncucqaozgXvT6j3h8eTzFtnGeMCj5QkKVY9hrpIJWACd0FMJ6T76SkJ6wZiBOe0
	4hJqv0cy6pwVy07XX5ZEW8TEIovAL6vikwytautuyBjI3PD+x7pk42auXrHONmXzwoArMLW3clc
	YHYPSt7F1NvviFb4pme1re7XqzTQpUMlJg9qWnH56sbaNOemxyW6l9Th99FDXUwcrefPKG4QgDw
	iRSIjDgMqGCYLSs6MnqpGKkzr5pFsTLehom
X-Google-Smtp-Source: AGHT+IG34MfGj/Zl62zVn178UZKzeSI18O6et/oIgJa6CLuO77Ce5w+YXMKKyouWv/4JvQ+6pdezBz48FGUKIecZjcI=
X-Received: by 2002:a05:622a:1aa0:b0:4a9:b6e1:15a with SMTP id
 d75a77b69052e-4ab954d8746mr2391171cf.24.1752663946223; Wed, 16 Jul 2025
 04:05:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-3-tabba@google.com>
 <a4091b13-9c3b-48bf-a7f6-f56868224cf5@intel.com> <CA+EHjTy5zUJt5n5N1tRyHUQN6-P6CPqyC7+6Zqhokx-3=mvx+A@mail.gmail.com>
 <418ddbbd-c25e-4047-9317-c05735e02807@intel.com> <778ca011-1b2f-4818-80c6-ac597809ec77@redhat.com>
 <6927a67b-cd2e-45f1-8e6b-019df7a7417e@intel.com>
In-Reply-To: <6927a67b-cd2e-45f1-8e6b-019df7a7417e@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 16 Jul 2025 12:05:09 +0100
X-Gm-Features: Ac12FXwLnudqPBETDUTkvUad_Ou8IyTTedPM6CDydpNfw0kKmZr9XGnTtqO-hwY
Message-ID: <CA+EHjTz7C4WgS2-Dw0gywHy+zguSNXKToukPiRfsdiY8+Eq6KA@mail.gmail.com>
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

On Wed, 16 Jul 2025 at 12:02, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/16/2025 6:25 PM, David Hildenbrand wrote:
> > On 16.07.25 10:31, Xiaoyao Li wrote:
> >> On 7/16/2025 4:11 PM, Fuad Tabba wrote:
> >>> On Wed, 16 Jul 2025 at 05:09, Xiaoyao Li<xiaoyao.li@intel.com> wrote:
> >>>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> >>>>> The original name was vague regarding its functionality. This Kconfig
> >>>>> option specifically enables and gates the kvm_gmem_populate()
> >>>>> function,
> >>>>> which is responsible for populating a GPA range with guest data.
> >>>> Well, I disagree.
> >>>>
> >>>> The config KVM_GENERIC_PRIVATE_MEM was introduced by commit
> >>>> 89ea60c2c7b5
> >>>> ("KVM: x86: Add support for "protected VMs" that can utilize private
> >>>> memory"), which is a convenient config for vm types that requires
> >>>> private memory support, e.g., SNP, TDX, and KVM_X86_SW_PROTECTED_VM.
> >>>>
> >>>> It was commit e4ee54479273 ("KVM: guest_memfd: let kvm_gmem_populate()
> >>>> operate only on private gfns") that started to use
> >>>> CONFIG_KVM_GENERIC_PRIVATE_MEM gates kvm_gmem_populate() function. But
> >>>> CONFIG_KVM_GENERIC_PRIVATE_MEM is not for kvm_gmem_populate() only.
> >>>>
> >>>> If using CONFIG_KVM_GENERIC_PRIVATE_MEM to gate kvm_gmem_populate() is
> >>>> vague and confusing, we can introduce KVM_GENERIC_GMEM_POPULATE to gate
> >>>> kvm_gmem_populate() and select KVM_GENERIC_GMEM_POPULATE under
> >>>> CONFIG_KVM_GENERIC_PRIVATE_MEM.
> >>>>
> >>>> Directly replace CONFIG_KVM_GENERIC_PRIVATE_MEM with
> >>>> KVM_GENERIC_GMEM_POPULATE doesn't look correct to me.
> >>> I'll quote David's reply to an earlier version of this patch [*]:
> >>
> >> It's not related to my concern.
> >>
> >> My point is that CONFIG_KVM_GENERIC_PRIVATE_MEM is used for selecting
> >> the private memory support. Rename it to KVM_GENERIC_GMEM_POPULATE is
> >> not correct.
> >
> > It protects a function that is called kvm_gmem_populate().
> >
> > Can we stop the nitpicking?
>
> I don't think it's nitpicking.
>
> Could you loot into why it was named as KVM_GENERIC_PRIVATE_MEM in the
> first place, and why it was picked to protect kvm_gmem_populate()?

That is, in part, the point of this patch. This flag protects
kvm_gmem_populate(), and the name didn't reflect that. Now it does. It
is the only thing it protects.

Cheers,
/fuad
