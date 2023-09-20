Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6259741AB9
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 21:03:51 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1c4375c1406so1910575ad.1
        for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 14:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695243831; x=1695848631; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QFTXI1M20f8gmG6BvRAdcxEpoXePrbyr+CokqbvWBWc=;
        b=hdOxi9vpDQQNpQN1GvkSkDJmgddrXY3jHZW6oYl2MErNPecSsTdxIG9mWSJyU1X5Y/
         EgzcNtcKPV2AxVzZMb+uHzp9eRX5DCUDjp/TkB3nNT9JkFS3UXUtxUsijI+cl1s84SWe
         aM09glxzEaEo/LY4ZGRwnE+ll85rbSxwFGCNAEPoawGKHQLSSuMXmmsvWXTkxZPzSE63
         ntzpmkwyF7Wyl/PR/ualFk/qQ7+YKZjVok5t5ytTJjdzwxkYrRQzE7o3ss8gCdw3mMBA
         fgVrf1cHpXLqnQ5uxG1dKelZfQKpcS5akxxhPh7eiDbmQLSm8GwlTRSAydj4mWkPCeBD
         AnNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695243831; x=1695848631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QFTXI1M20f8gmG6BvRAdcxEpoXePrbyr+CokqbvWBWc=;
        b=hNhu92EKtvFq5AqXnGawUSW4kCWWyRbS98nXXo7OykQOztbsQLzz0U6ftfhJnYmyhN
         jSeEtnKsM4jeEaJtDDBwWX6A6L8L8FXtqO8psegoj1nSc+bhllmaRELRfN7B5iLjesdd
         BYutXZhncS3R1rnJL3HJqebAKXNTs8VkD14UU5Ze0l4z77a/5112c6GxGyed2LmyjrTK
         7K1oVC8dKkmmCZ2qOR3WtoSdpuez8i3OVNKQJKEEGH7dd6tDrQDplPI8Wvy9Ey/lqiAY
         a7MCFVtpIps8gNYQzfBjDpMOTN/QV5oSsukPHccYNLt9SoArV002eKUAZa0CJO9rU3Jb
         kZzg==
X-Gm-Message-State: AOJu0YzBqIVcXNXgEO6V5Fj8Lja+bknqMOZ57ZIIxUe9kmA1Hm98YCZC
	x7OuZpHZoF4Vx32eELjgbQ/bUhSUQMk=
X-Google-Smtp-Source: AGHT+IH5QBEwnaGAG6ouJVZQG2FiwG4z7ywKiDhgLSOOF+0VMXfLus6G3HR8pg7XpQjZrIgu3wnPZ1Tf/l8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c407:b0:1c3:411c:9b7c with SMTP id
 k7-20020a170902c40700b001c3411c9b7cmr51568plk.13.1695243830643; Wed, 20 Sep
 2023 14:03:50 -0700 (PDT)
Date: Wed, 20 Sep 2023 14:03:49 -0700
In-Reply-To: <d66795f8-e524-2912-4b71-92ca4ffe8807@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-12-seanjc@google.com>
 <d66795f8-e524-2912-4b71-92ca4ffe8807@linux.intel.com>
Message-ID: <ZQteNbPfx6P3r6B8@google.com>
Subject: Re: [RFC PATCH v12 11/33] KVM: Introduce per-page memory attributes
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 18, 2023, Binbin Wu wrote:
> 
> 
> On 9/14/2023 9:55 AM, Sean Christopherson wrote:
> > From: Chao Peng <chao.p.peng@linux.intel.com>
> [...]
> > +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> > +/*
> > + * Returns true if _all_ gfns in the range [@start, @end) have attributes
> > + * matching @attrs.
> > + */
> > +bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> > +				     unsigned long attrs)
> > +{
> > +	XA_STATE(xas, &kvm->mem_attr_array, start);
> > +	unsigned long index;
> > +	bool has_attrs;
> > +	void *entry;
> > +
> > +	rcu_read_lock();
> > +
> > +	if (!attrs) {
> > +		has_attrs = !xas_find(&xas, end);
> IIUIC, xas_find() is inclusive for "end", so here should be "end - 1" ?

Yes, that does appear to be the case.  Inclusive vs. exclusive on gfn ranges has
is the bane of my existence.
