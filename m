Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DDD1D523
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 15:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JoiUmzjw"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5b87150242cso891409a12.0
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 08:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698940317; x=1699545117; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n3KS4TORQ08dXaJsqxd4Pb+jR6Q6AdhcH6h0cpJ7xRs=;
        b=JoiUmzjwD3fCDNzgjWI2o4JxYeVY7hI3v2Ib5xWs6IiV3dbPag/7heg9OfTXjyvDof
         dym4tiValS9gE2fCrFuLf2E862yR07ny/oqdBwoWxd5mzPqcPnJMNxIH+aO5aTk1R19j
         FGmXZhbvilhBhnkidH+QSYBdpAoXpKKVWQCGVHQwVi1HPOzwfuu26hidt722Flly8HZb
         7LxMbTXRNPsvikT4ph0toReLLoOpDYa0Pe5hNaQk74N3nRUb2MQtJhFML4vG1Q0g5/rB
         5XCzLLifkY4G2bqo36Nuxvf91FZ1HsyzMsCmtHL4SdSvPDREI0LmI818dAosMjQcz76V
         a67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698940317; x=1699545117;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n3KS4TORQ08dXaJsqxd4Pb+jR6Q6AdhcH6h0cpJ7xRs=;
        b=KRYbUzSaTYEoGdyMG17bzDgKXmIlRwmBkGh+WghjjHl24ujcTZ+GPs7fcH4rhOXFVR
         q8YGEtY8Vlc3cDCEtQ+fKrrPt/rCP8n4Oc07DK9kqKrKRwZ/bUjPy0JFJIBgc941niYy
         7d2VMFFTKvpQls3do66yonGtNvTGJh8DdclCX/xliUOrDELljgeLYN45bRnW48+4TUWB
         Q50gCthCjDjo7zRsjiVrFenCVzscLozZcTWAOWZDflsB3VFg0fE5uqhWVQiQRE1ouP7K
         MW46iXjhgInH6NyKFcRVScPAEaphyhGTIk0dwl2WchULIWX68RUNqc4PRI5JL58v601D
         FThw==
X-Gm-Message-State: AOJu0Yw02BTrJd9LWgXZKGSSkUEtSpGT952UZWd81uWBnUYNwGRUexKY
	yUFYSHWs8OrTmWxqQrIiNlMIixKE284=
X-Google-Smtp-Source: AGHT+IFDcwl4s8UdqmTM5rWncqnvjP5M1c0a+jaZEj3IxvzEAcY13jClAPWsClQownnFGH/6j2HG46oUm7Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:efd1:b0:1c6:2b9d:570b with SMTP id
 ja17-20020a170902efd100b001c62b9d570bmr344133plb.7.1698940317130; Thu, 02 Nov
 2023 08:51:57 -0700 (PDT)
Date: Thu, 2 Nov 2023 08:51:55 -0700
In-Reply-To: <33686031-c1df-4ef5-a6ac-1aab7f5c656e@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-10-seanjc@google.com>
 <482bfea6f54ea1bb7d1ad75e03541d0ba0e5be6f.camel@intel.com>
 <ZUKMsOdg3N9wmEzy@google.com> <33686031-c1df-4ef5-a6ac-1aab7f5c656e@intel.com>
Message-ID: <ZUPFmwWjPFlXRlPi@google.com>
Subject: Re: [PATCH v13 09/35] KVM: Add KVM_EXIT_MEMORY_FAULT exit to report
 faults to userspace
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"brauner@kernel.org" <brauner@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>, "willy@infradead.org" <willy@infradead.org>, 
	"anup@brainfault.org" <anup@brainfault.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, "mic@digikod.net" <mic@digikod.net>, 
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "david@redhat.com" <david@redhat.com>, 
	"tabba@google.com" <tabba@google.com>, "amoorthy@google.com" <amoorthy@google.com>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, 
	"yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>, "qperret@google.com" <qperret@google.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, Yilun Xu <yilun.xu@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "jarkko@kernel.org" <jarkko@kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Wei W Wang <wei.w.wang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Xiaoyao Li wrote:
> On 11/2/2023 1:36 AM, Sean Christopherson wrote:
> > > KVM_CAP_MEMORY_FAULT_INFO is x86 only, is it better to put this function to
> > > <asm/kvm_host.h>?
> > I'd prefer to keep it in generic code, as it's highly likely to end up there
> > sooner than later.  There's a known use case for ARM (exit to userspace on missing
> > userspace mapping[*]), and I'm guessing pKVM (also ARM) will also utilize this API.
> > 
> > [*]https://lore.kernel.org/all/20230908222905.1321305-8-amoorthy@google.com
> 
> I wonder how this CAP is supposed to be checked in userspace, for guest
> memfd case? 

It's basically useless for guest_memfd.

> 	if (!kvm_check_extension(s, KVM_CAP_MEMORY_FAULT_INFO) &&
> 	    run->exit_reason == KVM_EXIT_MEMORY_FAULT)
> 		abort("unexpected KVM_EXIT_MEMORY_FAULT");
> 
> In my implementation of QEMU patches, I find it's unnecessary. When
> userspace gets an exit with KVM_EXIT_MEMORY_FAULT, it implies
> "KVM_CAP_MEMORY_FAULT_INFO".
> 
> So I don't see how it is necessary in this series. Whether it's necessary or
> not for [*], I don't have the answer but we can leave the discussion to that
> patch series.

It's not strictly necessary there either.

However, Oliver felt (and presumably still feels) quite strongly, and I agree,
that neither reporting extra information shouldn't be tightly coupled to
KVM_CAP_EXIT_ON_MISSING or KVM_CAP_GUEST_MEMFD.

E.g. if userspace develops a "standalone" use case for KVM_CAP_MEMORY_FAULT_INFO,
userspace should be able to check for support without having to take a dependency
on KVM_CAP_GUEST_MEMFD, especially since because KVM_CAP_GUEST_MEMFD may not be
supported, i.e. userspace should be able to do:

	if (!kvm_check_extension(s, KVM_CAP_MEMORY_FAULT_INFO))
		abort("KVM_CAP_MEMORY_FAULT_INFO required for fancy feature XYZ");


