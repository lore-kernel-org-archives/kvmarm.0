Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3302456B6B
	for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 03:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717039704; cv=none; b=a6+h5Hm3JdVNYE2OeSb0x3dB3CLfFumlxv7smM0MY313C+tx8CCAHKSCiEQdZbASgT90UtX33EcxKB/UdbzWKc5MB+ZWwnDhIg99kLQEH+/eVInaG/fD748B3JCd3vk4Y3zoiCh8pUMETFX98WY72+/nBxMNXNyeffgtWqAG6nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717039704; c=relaxed/simple;
	bh=lj90chMb5O0KncpLqzXDubS3cuPfyVvzEjua9aYNaYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n3X3+tFmy0aBmPd2nDqQ6l2vS0m7Np48OUOF3p1QZmCHTkZGeSQAWOXpJwEtdQ0nj5LLRpJTEDp3aWxlPOs2bc5rORq1v5cXIm5xiIJKL0LY+AxuKDfguy22Ub4hb50OadCGBpOCUvi0JWbrTW8Km10tntW9vGAVv8q3H913/90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UDbDei3J; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UDbDei3J"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-43fe3289fc5so118431cf.1
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 20:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717039702; x=1717644502; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CyFUQdvGKe8UpOcfXmkz33OD4v6xcNcft6Wk6HjbLrw=;
        b=UDbDei3JQBT3nbXlViSGu7u4cMwlAO1yt9n7fIAyvNITqOj6PELQcB/qFs9MMaOYxS
         GsHKlrLIm3dJs82mfyMeuGD+1D/zNUXfaLbVHP0vHBlit0ly7dGuIiY7PWLKvr/8h24O
         Xv+FBACRsG1QbJLYEUaz4P12PK4AF51XMSkLn+NflgjPK0HvCpwrV1mUJ9pO/nWi5P8S
         s3euCphtp6YUy8xTDfVEozPn2NhJddBiaobtqOeQZ1NT79uQEpGCZ96d8X7eqer4GC94
         NGG7sykdI9U7cp0CpJNX2WYEcwba1VXXhme43K+b3l7bLikhHyba4zXvDXAl5TyUMQQp
         7NLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717039702; x=1717644502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CyFUQdvGKe8UpOcfXmkz33OD4v6xcNcft6Wk6HjbLrw=;
        b=kQhC0r6iwXgJwYGMft3EwqJOxVM84dCQVy6wsf3Y8TM/z9+GRhlKnwlXSlXZS8Hdye
         7n9kIqk2mqB2y9XL3gg76fwc7/zxNuhR9sJdJWRWp4YrLyftQCTItloCDnY30z3yKvnb
         unjbVgiViZJxrcMCSrPsoxGNxmiJTp0iIWDaQx3E3cHIlQtoxndTYiXrN92cJNbmjsg/
         zuQxYuC/JYIq8+0XSct8U0x8J1zFmKNR/+p3N59eYAEDJs+IaiulX7gAECDxrPR7Fd2R
         iU7Xfugvr7OsznR5YJf6ec/uw3xHnLww37aFtGSXreHO78I2J2Bu1fs2/f1gYf5v46Zg
         6BkA==
X-Forwarded-Encrypted: i=1; AJvYcCUz5DcUXeAsV5Obo5+cV0lLZ5NQaPqw477UZ4Tx2z5hAy3ODuEU2xGKiA8oFXAvzVJ58Wehjlia6cABVC4aINOYzKIRR/Ha
X-Gm-Message-State: AOJu0YwQbqGpXUNzk8Z0cYTtvjQPWIqdPH9VN8+RSwuWFuNIJFVNJIfQ
	Dx/Pg0l1zvpVGHatT/2Jb5ntcbyLmf6XzlCR1TrAqzP6iVRCgW5VbNl3r0nDfgfTOeBJbiD/rr8
	ePrxBXNavI4iBqLNlJZxOzSKSmQ0lCSIGU4uQ
X-Google-Smtp-Source: AGHT+IGBhNbFRaaD0WOEIsVSMflxCvd13kkSSK1hcGeX1B4TzLlXvTq7xC3rTsBmGx8uhqPHEIa2GYmfEXsD+JkYxAs=
X-Received: by 2002:a05:622a:90e:b0:43e:cb4:1d10 with SMTP id
 d75a77b69052e-43fe8e5f830mr1851431cf.14.1717039701993; Wed, 29 May 2024
 20:28:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
 <20240529180510.2295118-5-jthoughton@google.com> <ZlekYljG7KJwblUj@google.com>
In-Reply-To: <ZlekYljG7KJwblUj@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 29 May 2024 20:27:45 -0700
Message-ID: <CADrL8HVZxoO33F2UJBoTjF_SXpxyZmH=RTM5G3stgo_kRPjazA@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] KVM: Move MMU lock acquisition for
 test/clear_young to architecture
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Ankit Agrawal <ankita@nvidia.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2024 at 2:55=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, May 29, 2024, James Houghton wrote:
> > For implementation mmu_notifier_{test,clear}_young, the KVM memslot
> > walker used to take the MMU lock for us. Now make the architectures
> > take it themselves.
>
> Hmm, *forcing* architectures to take mmu_lock is a step backwards.  Rathe=
r than
> add all of this churn, what about adding CONFIG_KVM_MMU_NOTIFIER_LOCKLESS=
, e.g.
>
> static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notif=
ier *mn,
>                                                          unsigned long st=
art,
>                                                          unsigned long en=
d,
>                                                          gfn_handler_t ha=
ndler)
> {
>         struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
>         const struct kvm_mmu_notifier_range range =3D {
>                 .start          =3D start,
>                 .end            =3D end,
>                 .handler        =3D handler,
>                 .on_lock        =3D (void *)kvm_null_fn,
>                 .flush_on_ret   =3D false,
>                 .may_block      =3D false,
>                 .lockless       =3D IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_LO=
CKLESS),
>         };
>
>         return __kvm_handle_hva_range(kvm, &range).ret;
> }

Thanks Sean, yes this is a lot better. I will do this for v5.
