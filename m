Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E411199A5
	for <kvmarm@lists.linux.dev>; Wed,  8 Nov 2023 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l6cxZwmD"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5844bc378feso3849486eaf.0
        for <kvmarm@lists.linux.dev>; Wed, 08 Nov 2023 09:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699462842; x=1700067642; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1LRS4MOzwpv79nEdyxX9W+Fzi/lnfht07XTGfi+1KqQ=;
        b=l6cxZwmDVwdUoEuIpz2D6UbTfnn5pCndEOirBvTZfzcXY54s95uMQfU41iuiP3EBWq
         sgSB7Nk4G3fclQfopISpJ5PU62TwrkqenQ2GEypFGwW1uJvQ0oWiN3aIfs7sj902oQPV
         0bAoBTPg9voZd003qUGxPKZ9+QmrULjz5mg+ELilzECbtPeY3SsVi2CtNeCTfpZdGMXs
         rl9FLuXE8+vGQz2tawFxnO+h6nooycYMIklpH1cAuujBxF+nknA4rp0+DNGAyhworUCk
         xV9j/kx2ixQnwilsZKrIL6Bicu+1IJRg3qV4FKDer3GsugyZh0pbTsdXEccNyibxbVmY
         FLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699462842; x=1700067642;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1LRS4MOzwpv79nEdyxX9W+Fzi/lnfht07XTGfi+1KqQ=;
        b=Ljhz9EW8YuoQkng2ljGY99yA+D43rkUP+lo5eZ/mvqgcSVx4+MhJFPWpQ3V65hTBWz
         1CsGnLaJdXLy69ENDffur8E41eUscoyKga8nr6wivJCu3eKA6jwBxFGfAUOss+OVojc1
         gcdUL+fAStXuJG8wNx7VrA6w7ggLvXINPKpVVhwhQ+nOSyRFZ7m8ibbehFoYTRVbC+ht
         LzV/QegHmPRQmRtQCvi+616nWgXxj+9tMR6Gf2UzQhx32wfaduEjs1oKjSqIj6vjf1Qh
         oXBs47Wae8ZV9Be2f+IHwxZ3r1g7ms15K8Enixt1VKwGgINSz80Njr2sCJjEfib91qXl
         dVWg==
X-Gm-Message-State: AOJu0Yw0JwlVpYrED8ZhkaV8hV8I7/fx5rAXvuAnOda4D/n9g4ZllAnq
	n63Cbf2vaUz4rurAdegsm+JHk8c5yXEFyWEwmBiW1g==
X-Google-Smtp-Source: AGHT+IFUowk4ELsOivnzaXxc0QlUV4Wvcfh03Hm5SSyMQjwcPTJCFQB+7xIvrXwxFUaSBNJXJhJv8dNqTjB0k78gAdI=
X-Received: by 2002:a4a:bd87:0:b0:589:df75:2d83 with SMTP id
 k7-20020a4abd87000000b00589df752d83mr1373195oop.1.1699462842423; Wed, 08 Nov
 2023 09:00:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-28-pbonzini@redhat.com>
In-Reply-To: <20231105163040.14904-28-pbonzini@redhat.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 8 Nov 2023 09:00:00 -0800
Message-ID: <CAF7b7mrGYuyjyEPAesYzZ6+KDuNAmvRxEonT7JC8NDPsSP+qDA@mail.gmail.com>
Subject: Re: [PATCH 27/34] KVM: selftests: Introduce VM "shape" to allow tests
 to specify the VM type
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
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

This commit breaks the arm64 selftests build btw: looks like a simple overs=
ight?

$ cd ${LINUX_ROOT}/tools/testing/selftests/kvm
$ CROSS_COMPILE=3Daarch64-linux-gnu- ARCH=3Darm64 make
# ...
aarch64/page_fault_test.c: In function =E2=80=98run_test=E2=80=99:
aarch64/page_fault_test.c:708:28: error: incompatible type for
argument 1 of =E2=80=98____vm_create=E2=80=99
  708 |         vm =3D ____vm_create(mode);
         |                            ^~~~
         |                            |
         |                            enum vm_guest_mode
In file included from include/kvm_util.h:10,
                 from aarch64/page_fault_test.c:14:
include/kvm_util_base.h:806:46: note: expected =E2=80=98struct vm_shape=E2=
=80=99 but
argument is of type =E2=80=98enum vm_guest_mode=E2=80=99
  806 | struct kvm_vm *____vm_create(struct vm_shape shape);
