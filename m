Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94A121342
	for <kvmarm@lists.linux.dev>; Mon,  6 Nov 2023 16:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M1E9Poiu"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-66d122e0c85so30000186d6.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Nov 2023 08:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699287466; x=1699892266; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUV8zKIdpTV0f8ZMhx633GQ2l+XRSBNMcsvYJoEfTx4=;
        b=M1E9PoiuA015zlsEswebMhtkTDHnxds8M7AVlPtVRL1SNSPgLubhhgd+Mtlq09kFRO
         GzhMxyv7f0X9igWsdXica5Snl6WQyAyNxCgHxkPkm5QPYB2ZYpPvqAcfoLJlTubDc9Yb
         qdIyD3gUVhKqKh0OVGr5LtaWW8MkRG6JluRIrLJRUJMU/QQ/+QkBGRfBTg7XYk2H0n9y
         dRDQs4KrHBvdQxBSJMVpszXtGLE17exqIjafGYLZz/t+dLAfYauhAea+ogoBKazQU1Iw
         kWO+TDic/lS55QCGZlWJ8aCVEjjeeKpu10WPTFDurBjtik/wNciKlxke/3H8jBXNFLg4
         QcuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699287466; x=1699892266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lUV8zKIdpTV0f8ZMhx633GQ2l+XRSBNMcsvYJoEfTx4=;
        b=eBs1cKT0Vw5adIOzsjkf4n9hLhNKtxQCK7UDxsNVXE8dnOg9PHYns6qByq56h0rZaK
         urnQxvg0HbWvvgGg5IxdsJxtg123b1zoyMgG/dZq/XucuY0OWxfUwW3vJHtsbPpOrljb
         vpqSM3qCu6zeJ0HOG+m1gs4g5OFHdPrdNB0uAokF+8O1gIVy4Y+Wu5dXMt8TTUi+bJZ2
         Q+rVZXBQ0kUszW5AQxw4ZZz659b/lkfRtd2BFJ06Zu0nj0wfegEdXADty3CB1fw8uBM8
         M8uMB+LG9vPYe1UDyjQro3w+eOtBxinOxNhTiEq2tRZhjUSNDqExGekMnVTiGZDDC8Th
         o+Zw==
X-Gm-Message-State: AOJu0YxA5vgJabBUa+iTx1hlTGO0b+6H+3H3YR4E6UFKGQEeMLzBQnWv
	FjWReKdqCmGv3Tt5itvRDsOj7If9e/DFPhapCA2QTQ==
X-Google-Smtp-Source: AGHT+IFFqaeUa+zb1fqYMH2SBG8qERPcG1V2EKOvlLONFWJF+9JT7SC3ACnaIHdf6fX4zUtKFZJjWCRYHGHhXFDqHvM=
X-Received: by 2002:ad4:5c83:0:b0:670:9f8d:f7be with SMTP id
 o3-20020ad45c83000000b006709f8df7bemr44676404qvh.13.1699287465633; Mon, 06
 Nov 2023 08:17:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-28-pbonzini@redhat.com>
 <CA+EHjTxz-e_JKYTtEjjYJTXmpvizRXe8EUbhY2E7bwFjkkHVFw@mail.gmail.com> <ZUkOgdTMbH40XFGE@google.com>
In-Reply-To: <ZUkOgdTMbH40XFGE@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 6 Nov 2023 16:17:09 +0000
Message-ID: <CA+EHjTzc4zwN1atU1mSnbi3Lvb0c83MATQSk1uSWxae2iKi0aw@mail.gmail.com>
Subject: Re: [PATCH 27/34] KVM: selftests: Introduce VM "shape" to allow tests
 to specify the VM type
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
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 4:04=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Nov 06, 2023, Fuad Tabba wrote:
> > On Sun, Nov 5, 2023 at 4:34=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.c=
om> wrote:
> > >
> > > From: Sean Christopherson <seanjc@google.com>
> > >
> > > Add a "vm_shape" structure to encapsulate the selftests-defined "mode=
",
> > > along with the KVM-defined "type" for use when creating a new VM.  "m=
ode"
> > > tracks physical and virtual address properties, as well as the prefer=
red
> > > backing memory type, while "type" corresponds to the VM type.
> > >
> > > Taking the VM type will allow adding tests for KVM_CREATE_GUEST_MEMFD=
,
> > > a.k.a. guest private memory, without needing an entirely separate set=
 of
> > > helpers.  Guest private memory is effectively usable only by confiden=
tial
> > > VM types, and it's expected that x86 will double down and require uni=
que
> > > VM types for TDX and SNP guests.
> > >
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > Message-Id: <20231027182217.3615211-30-seanjc@google.com>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> >
> > nit: as in a prior selftest commit messages, references in the commit
> > message to guest _private_ memory. Should these be changed to just
> > guest memory?
>
> Hmm, no, "private" is mostly appropriate here.  At this point in time, on=
ly x86
> supports KVM_CREATE_GUEST_MEMFD, and x86 only supports it for private mem=
ory.
> And the purpose of letting x86 selftests specify KVM_X86_SW_PROTECTED_VM,=
 i.e.
> the reason this patch exists, is purely to get private memory.
>
> Maybe tweak the second paragraph to this?
>
> Taking the VM type will allow adding tests for KVM_CREATE_GUEST_MEMFD
> without needing an entirely separate set of helpers.  At this time,
> guest_memfd is effectively usable only by confidential VM types in the
> form of guest private memory, and it's expected that x86 will double down
> and require unique VM types for TDX and SNP guests.

sgtm
/fuad
