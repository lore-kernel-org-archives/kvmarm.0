Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E39511CAA
	for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 21:05:30 +0000 (UTC)
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-5735a879147so3672736eaf.3
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 14:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694811929; x=1695416729; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yleJC+7YBNlUjlYVNZzM9vt9cQFuPW3G+hVjyHJnwaw=;
        b=ZzGYPmW4h6IRzd5JFykSRNIGHirfJB/iF9zOlgSl6t0f2xBasPis2yxBlUuKYuOrRP
         7034XroAZCK1K986fJyPDmT0XfN0VfCXnmr+De5fq2EYS3nlVx3I+OokrutGdkunPSzB
         i0SIPLvgbIUVwbD1o9VDOE2HbpOHOKLjfgdbIZS38zmDndX0P1pTDi7SF5jeSELRTEev
         pGOWDTmKgLi2qsvqmQyRflswi5P+OdceucMBhLZXDmpdlyMRYNZQo8u6G2E7cQD3Rciw
         dpsePKmLHYbV3ETeN7Hxz8wKld96Y03mI9sI+GD/Zcrd/FMm0Se1z2nbftuiM3TUp+oj
         8kMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694811929; x=1695416729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yleJC+7YBNlUjlYVNZzM9vt9cQFuPW3G+hVjyHJnwaw=;
        b=E1J/Dfdu+FoppYya2X1iy0qiIJdeOxhC1ZS40YP7GrHVCffk01JBkQwz+Hkx/FOb60
         +fFQFiUxLmRWe8iXZfQaaElfjYK/hayQVK6HPkJP/TQiseIRRTrjUXJWIOUA1MIXNP1u
         zIhWHPQfti5is15BacZ/FgXmmS3oPMVoU6MdfkPh5YpW5cJlyMKAHB5W8wfaplDTiNcV
         Ifh+DxbLJksDmwCn/cmIha8mGhvtltBD4dojw5mVc+ussNRjzar02BmgM759rSkRFmW0
         rolqfAIC1sS2Xg3wehZ/l50DI5dwl41pZFlJuu2Jer44Ot0sJU6cqKQKYaOfCRzVvTND
         xUdg==
X-Gm-Message-State: AOJu0Yw8fHrB039epIq8KkaNlCQpxk39yus5gcgb6Lu1OJ+ksQSChw8Y
	a3ZlOmNDbFnlPX1dbh/DVPwC2Of/y+Q=
X-Google-Smtp-Source: AGHT+IF9PpTOkzcgimAJrduyF4qwfWt2KP5EbzIhLTMy/s4gm21Ep/5FIgTjRytGlNZlubXZjpDBAQBvLB0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a4a:2c02:0:b0:571:1762:7718 with SMTP id
 o2-20020a4a2c02000000b0057117627718mr908496ooo.1.1694811929595; Fri, 15 Sep
 2023 14:05:29 -0700 (PDT)
Date: Fri, 15 Sep 2023 14:05:27 -0700
In-Reply-To: <d4166c97-6ab3-89a2-eb12-f492f7521f69@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-2-seanjc@google.com>
 <d4166c97-6ab3-89a2-eb12-f492f7521f69@intel.com>
Message-ID: <ZQTHF3J+6FXwRx98@google.com>
Subject: Re: [RFC PATCH v12 01/33] KVM: Tweak kvm_hva_range and hva_handler_t
 to allow reusing for gfn ranges
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 15, 2023, Xiaoyao Li wrote:
> On 9/14/2023 9:54 AM, Sean Christopherson wrote:
> > Rework and rename "struct kvm_hva_range" into "kvm_mmu_notifier_range" so
> > that the structure can be used to handle notifications that operate on gfn
> > context, i.e. that aren't tied to a host virtual address.
> > 
> > Practically speaking, this is a nop for 64-bit kernels as the only
> > meaningful change is to store start+end as u64s instead of unsigned longs.
> > 
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   virt/kvm/kvm_main.c | 34 +++++++++++++++++++---------------
> >   1 file changed, 19 insertions(+), 15 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 486800a7024b..0524933856d4 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -541,18 +541,22 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
> >   	return container_of(mn, struct kvm, mmu_notifier);
> >   }
> > -typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
> > +typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
> 
> Is it worth mentioning the rename of it as well in changelog?

Meh, I suppose.  At some point, we do have to assume a certain level of code
literacy though :-)
