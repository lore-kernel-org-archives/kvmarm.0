Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0227319BA7
	for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 18:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EfUH45hl"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2c50305c5c4so69789291fa.1
        for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 11:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698690013; x=1699294813; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EYDArYAPbuwvLuQnLMgYzD5G3hQJ3JuyTKb70j8k5kM=;
        b=EfUH45hl8xb+tt6MfPFNN/evgM8P68l0+gtXMjcTHwmG4jREySyxXF1kpwtmuK1+BP
         sr8RvlgP6Man+EXm/EElkg5Ag77LPyEeZ7+xoXgdnA7Ix6/pQe3bkMcWvqUqjS0i9xaN
         YYYofVmwiYXariLpDKLyktKnEcu6PpP/8W5oOCMR/X5J8bO6XeV2d7hahfNVkxmC8erd
         UpxQfyIjmfDAODyag286HVugI7mwZh6vKmtuPAIsNunl7AZlHoMh00uqz6sWVTzYKEAl
         eZSk8f0JPja98bjVoSbfIcND9iR8xMLZ0esFYKYOSPdzTRN/ZP/4xKvq5NIDGefVQzO/
         jZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698690013; x=1699294813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYDArYAPbuwvLuQnLMgYzD5G3hQJ3JuyTKb70j8k5kM=;
        b=EJovvv0Ge5SembV3QchbizpcQ0IFyxIRVEAxS1uHagmZG1+H87pCHAobmE8Zdmg6vA
         wpxMaqiu2TkCc4UUFXPKYcbr8run4u61+x2aDc1WizFjzoXfL4v+3uPLj73Y9cecyopJ
         nlOzTC2hN5RGzKEQKeegTjTQOVPcNKQm7L+DzfS+ynrHo5UB6mBIP49uMIIa5MwaBXHz
         isc7vcfDJcY3sCpPvsO+9cpdN3S1IYyuO2gkycC+uiKc1sviuB5Upnugvte/LJPGtuz+
         C+v+MqyIkr9NNcx+e3YiexZa2mFypHh8NTcPNrtK8PtgxIMmHoOkIYuA8JgS+w39FRxh
         3qwQ==
X-Gm-Message-State: AOJu0YyNneDq0lkv++/AKOM1HG1X0Wt8goMgrtpupTe9dqqPIWYQLZud
	ucx16q/6vU2z5vjShwQScv/UYGVR4lD2PTkfXgJZpQ==
X-Google-Smtp-Source: AGHT+IGWQtTaV5Bzkdlkn1e/3Zt5UNsfNX/Ijo670f/udb747Y9rnFPe4I+UgnAkk/OF+ECMZnUUXa4ItRfh9V5jdaA=
X-Received: by 2002:a05:6512:10cb:b0:507:aaa9:b080 with SMTP id
 k11-20020a05651210cb00b00507aaa9b080mr9836391lfg.33.1698690012887; Mon, 30
 Oct 2023 11:20:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-4-seanjc@google.com>
 <ZT_fnAcDAvuPCwws@google.com>
In-Reply-To: <ZT_fnAcDAvuPCwws@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 30 Oct 2023 11:19:43 -0700
Message-ID: <CALzav=cjq_MbJgi3DMytVWwZLFxEPi1dp7YiBYRBw-sRf2+BLw@mail.gmail.com>
Subject: Re: [PATCH v13 03/35] KVM: Use gfn instead of hva for mmu_notifier_retry
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 30, 2023 at 9:53=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2023-10-27 11:21 AM, Sean Christopherson wrote:
> > From: Chao Peng <chao.p.peng@linux.intel.com>
> >
> > +void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t =
end);
>
> What is the reason to separate range_add() from begin()?

Nevermind, I see how it's needed in kvm_mmu_unmap_gfn_range().
