Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9338415AE5
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 13:55:07 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-59c15767524so66874747b3.0
        for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 06:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695218106; x=1695822906; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0APReAt4bNnnd5kx+NahuCYj0tgbUgwxY6/xmv3q1x8=;
        b=ws4TiFrp8aT1HOp6RcAm4shLsQr7hokhhDoKnJMblVIONMmvzFmtORdD2WVvdFRamG
         Wv6ymOYvUzd5fK5GlYUdmko9gAdHl520tpExAogPkZdd76g7NYJES1J+ZMCPS8gVjtFj
         +Xpbi7myu88q4UZp06RC4XKkFyqfDfwZ5AMReScHJIZZ0r7kOrUpmd/Dv2EVKmJMnKwM
         Fe+JrqjzBmCqqpdVR0teDYH8DaG6cyCsujffeAqXL6XOQ19CEg2FEttX/AbrUxS10+Md
         oEWdQoWmlaeT6mtdI1a1yiTXW5KkycL/x4VUcqK5BHJBRVgqpgowTUjLZz9C25klCK0Y
         GG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695218106; x=1695822906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0APReAt4bNnnd5kx+NahuCYj0tgbUgwxY6/xmv3q1x8=;
        b=PirMg0FDel9My4aHIex6JA2tHGdFXqyqIfipScgi772g8OsL2ndZJhOjnePM0Hf118
         cbblsXyCkn6Oq2I3PPnAnH0UNbgUvEliE0F84WidNyWXhVWgUva3hXPWe9ut214XDNs/
         KKzx1oQ/P6i9OU8xcAIC/J4QoshShvgQhkwSJ7cjnjtXFT7Ml56rI0RNLf5SxBUegUAK
         sYSBcbcdz9GwiZ5H+2JOKeTWvM795yi47RKbuVM21LYSWDPjNgL0EKX/qvlNYh/baTcp
         dSm5oM2rnOeZIFrETNt4zPfyakjKBXYCipQ5ghenh7c7/55DkJv/CUw2Xr+qh5JjUlw3
         ykCg==
X-Gm-Message-State: AOJu0YysXbTsKvEO0IlRHS3jbrCvFODU0KTxbq0MvXoaG32fawMJfE33
	XDiH3jX/EubUIVUFIzlPuPmD4gZxU0A=
X-Google-Smtp-Source: AGHT+IHuQ24Hy0wlZqpKThD2hndi3rYWapG+J/d1L/ai4z7W/k7rmZdxNg2zwHr4zmYKJTJyjaSKmjFgB/U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae57:0:b0:59b:ee27:bbe9 with SMTP id
 g23-20020a81ae57000000b0059bee27bbe9mr35901ywk.9.1695218106527; Wed, 20 Sep
 2023 06:55:06 -0700 (PDT)
Date: Wed, 20 Sep 2023 06:55:05 -0700
In-Reply-To: <ZQqMBEL61p739dpF@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-3-seanjc@google.com>
 <ZQqMBEL61p739dpF@yilunxu-OptiPlex-7050>
Message-ID: <ZQr5uXhV6Cnx4DYT@google.com>
Subject: Re: [RFC PATCH v12 02/33] KVM: Use gfn instead of hva for mmu_notifier_retry
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@intel.com>
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
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 20, 2023, Xu Yilun wrote:
> On 2023-09-13 at 18:55:00 -0700, Sean Christopherson wrote:
> > +void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +	lockdep_assert_held_write(&kvm->mmu_lock);
> > +
> > +	WARN_ON_ONCE(!kvm->mmu_invalidate_in_progress);
> > +
> >  	if (likely(kvm->mmu_invalidate_in_progress == 1)) {
> >  		kvm->mmu_invalidate_range_start = start;
> >  		kvm->mmu_invalidate_range_end = end;
> 
> IIUC, Now we only add or override a part of the invalidate range in
> these fields, IOW only the range in last slot is stored when we unlock.

Ouch.  Good catch!

> That may break mmu_invalidate_retry_gfn() cause it can never know the
> whole invalidate range.
> 
> How about we extend the mmu_invalidate_range_start/end everytime so that
> it records the whole invalidate range:
> 
> if (kvm->mmu_invalidate_range_start == INVALID_GPA) {
> 	kvm->mmu_invalidate_range_start = start;
> 	kvm->mmu_invalidate_range_end = end;
> } else {
> 	kvm->mmu_invalidate_range_start =
> 		min(kvm->mmu_invalidate_range_start, start);
> 	kvm->mmu_invalidate_range_end =
> 		max(kvm->mmu_invalidate_range_end, end);
> }

Yeah, that does seem to be the easiest solution.

I'll post a fixup patch, unless you want the honors.
