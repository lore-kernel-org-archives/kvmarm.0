Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82121C02
	for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 17:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TiBIMGrm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698685279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ySiJbXtvuo/ap347BrtctuG5UsffPvyxiWszBOWPpzU=;
	b=TiBIMGrmPRqllEWCftZ4Qq3VZVIyUvi1o4+6Fh7imMt7BwGGlP8TBUTFF67cEZ7NLNWn4V
	m+4Zr1I47PRMRTeZHpuJhIMCopPzcauK+OawBdRNmVryzyq9uRoaz0R86UxUsGpzQ6XF74
	yAi16/UxKc74yvLNWJvhM88LGaA5oog=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-lYaUfvVMP3ea0_c2pmEPgA-1; Mon, 30 Oct 2023 13:01:08 -0400
X-MC-Unique: lYaUfvVMP3ea0_c2pmEPgA-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1e9f6006f9cso6468160fac.3
        for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 10:01:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698685266; x=1699290066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ySiJbXtvuo/ap347BrtctuG5UsffPvyxiWszBOWPpzU=;
        b=YSF4Q32oDRJjihFtOHXKeuC2+Sb7uPq5wkzqzqKSkESLo33I6ODybF55sRvr5jEKhm
         5PEdhF4V3vOJZoSYHrB+OqyNUpeYcbI+XZcXIqiWdSebbp32LxgRwGlK7OKKP+z2pazk
         D6JW6GHA9ObZXDBJrtUd+QUMEcx6Uz61IiS3eGxZ9bt3HuJ7Rd8DxkWoLMYLAeuRjZis
         mxPN9K77sRIeHNz3dapLUTnx6ZouS3y58lNaND70471FesxP9jxOM/HBrLga31QLG/WT
         EFnFaKS8ZlBfIbdM9FJIiaoyOTowai0GVkhMUky5KrfkrbnQbQkRbjYREOGunQauysB0
         GudA==
X-Gm-Message-State: AOJu0YyCrPmoNdG4zpmwWnXWEQ7/o/eXlSBwrWaYtteOul4hjtCvpLhr
	cYjowe8MUgOCrxBD7xhYk2yRI1RVr9+gW2bRWNbVT/7FOomcoy19o1AaViG1EyIOIGmHEL4b9Vm
	Kd0xatxFNJgLJMD1VHN6mn4RD4JObbjgg
X-Received: by 2002:a05:6871:5c45:b0:1ea:3f79:defb with SMTP id os5-20020a0568715c4500b001ea3f79defbmr14807552oac.52.1698685265965;
        Mon, 30 Oct 2023 10:01:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExUXzp0cSzQuFI/AWzKwhXt4UU+QvY8z/fyApz/M7sPoBiF5GZjJ7SszJVxAGAXDpAW5+AxTqFEaHAzsc1Bic=
X-Received: by 2002:a05:6871:5c45:b0:1ea:3f79:defb with SMTP id
 os5-20020a0568715c4500b001ea3f79defbmr14807416oac.52.1698685264406; Mon, 30
 Oct 2023 10:01:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-4-seanjc@google.com>
 <ZT_fnAcDAvuPCwws@google.com>
In-Reply-To: <ZT_fnAcDAvuPCwws@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 30 Oct 2023 18:00:49 +0100
Message-ID: <CABgObfYM4nyb1K3xJVGvV+eQmZoLPAmz2-=1CG8++pCwvVW7Qg@mail.gmail.com>
Subject: Re: [PATCH v13 03/35] KVM: Use gfn instead of hva for mmu_notifier_retry
To: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 30, 2023 at 5:53=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2023-10-27 11:21 AM, Sean Christopherson wrote:
> > From: Chao Peng <chao.p.peng@linux.intel.com>
> >
> > Currently in mmu_notifier invalidate path, hva range is recorded and
> > then checked against by mmu_notifier_retry_hva() in the page fault
> > handling path. However, for the to be introduced private memory, a page
>                           ^^^^^^^^^^^^^^^^^^^^^^^^
>
> Is there a missing word here?

No but there could be missing hyphens ("for the to-be-introduced
private memory"); possibly a "soon" could help parsing and that is
what you were talking about?

> >       if (likely(kvm->mmu_invalidate_in_progress =3D=3D 1)) {
> > +             kvm->mmu_invalidate_range_start =3D INVALID_GPA;
> > +             kvm->mmu_invalidate_range_end =3D INVALID_GPA;
>
> I don't think this is incorrect, but I was a little suprised to see this
> here rather than in end() when mmu_invalidate_in_progress decrements to
> 0.

I think that would be incorrect on the very first start?

> > +     }
> > +}
> > +
> > +void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t =
end)
> > +{
> > +     lockdep_assert_held_write(&kvm->mmu_lock);
>
> Does this compile/function on KVM architectures with
> !KVM_HAVE_MMU_RWLOCK?

Yes:

#define lockdep_assert_held_write(l)    \
        lockdep_assert(lockdep_is_held_type(l, 0))

where 0 is the lock-held type used by lock_acquire_exclusive. In turn
is what you get for a spinlock or mutex, in addition to a rwlock or
rwsem that is taken for write.

Instead, lockdep_assert_held() asserts that the lock is taken without
asserting a particular lock-held type.

> > @@ -834,6 +851,12 @@ void kvm_mmu_invalidate_end(struct kvm *kvm, unsig=
ned long start,
>
> Let's add a lockdep_assert_held_write(&kvm->mmu_lock) here too while
> we're at it?

Yes, good idea.

Paolo

