Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F6E1C6A0
	for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 22:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yVkj0y5T"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d99ec34829aso4546193276.1
        for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 15:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698703558; x=1699308358; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1IwVDVsbZSN9+qsHUIXJ8IN4aMaIP7o7r0dMzi80JWo=;
        b=yVkj0y5TfOSQoePqHTSx+vjwqRuCFqdzcr6X2kDqGdBKewL7piHotBbdhBgfBvKtCj
         BNXeg4KUU23iuMTZCuL776QTFw1GmB0gLbUd3MVwrjVeY63Rb0dWd5nJiPg6IiZ3BOns
         AyPDpBba/i5XX0kV7SJNBpf/zTzcyGrQmLhJD+IzZru0rW5BxklnXls+TJfxNiWeiEmr
         rBGx8yv1zLuLJSm10CVlnemBgOhg1nyCTEzBqKintSOKBx74CM7WVGHSwL/EQY9EpaEH
         twj8cLoAP2mGm4FdQelJVA7WhijAZ+4GnbbeYj2jy35NkaZOGU6jmuVZBTF4N9pM8Vds
         naZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698703558; x=1699308358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1IwVDVsbZSN9+qsHUIXJ8IN4aMaIP7o7r0dMzi80JWo=;
        b=IHZcZhuVIsl2Rmq9ZbKi780ucgikAx+co1MrexLUa1fGQqqUtnGmfWZYLAvNYpXohl
         REW6V+XEV06m+R2DgRXIK0YUkH1rUwxJIXHXPVzkBBKb9/qGALQsL3OYJsf8uC3CAHlM
         obd66Cz25+0Vebyb4hPVFuWDabkJMY9FnwUW3mKZKD+d/NqLMah/ngHi7gt1y6mX4zZY
         AO0PAgujqiPAPdVaFgMxa4W1eKOL8BlCL4UdtOwhli3GMC3H6/gxTYAgA1/m2vQD0L0R
         dpAKlhEiMNoBUE3Z5y9V4ulCVK+J76600FB63mSdPiUvwTM2nsAyUghJUYdbhM4bR0y+
         Sp+Q==
X-Gm-Message-State: AOJu0YxYg2ktbothmIyv0PEbtGkPl0r2nevS3kyllkhpWvnU0Pn5NCz9
	FzDcrI5w3bTIFD2ZiEMMT6Ms7GPVd0s=
X-Google-Smtp-Source: AGHT+IEdUnGiaB+HWnyvBXIWgJEvc4p4Jj6o8XAknp5F2BcjElHvOjmW/sQ9BadeZP3HZD1+EeGEwSi+J0Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b108:0:b0:d99:3750:d607 with SMTP id
 g8-20020a25b108000000b00d993750d607mr203752ybj.8.1698703558464; Mon, 30 Oct
 2023 15:05:58 -0700 (PDT)
Date: Mon, 30 Oct 2023 15:05:56 -0700
In-Reply-To: <ZT_ViJOW1p4TN_fI@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-14-seanjc@google.com>
 <ZT9lQ9c7Bik6FIpw@chao-email> <ZT_ViJOW1p4TN_fI@google.com>
Message-ID: <ZUAoxCZJnpPGWjpu@google.com>
Subject: Re: [PATCH v13 13/35] KVM: Introduce per-page memory attributes
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
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
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 30, 2023, Sean Christopherson wrote:
> On Mon, Oct 30, 2023, Chao Gao wrote:
> > On Fri, Oct 27, 2023 at 11:21:55AM -0700, Sean Christopherson wrote:
> > >From: Chao Peng <chao.p.peng@linux.intel.com>
> > >
> > >In confidential computing usages, whether a page is private or shared is
> > >necessary information for KVM to perform operations like page fault
> > >handling, page zapping etc. There are other potential use cases for
> > >per-page memory attributes, e.g. to make memory read-only (or no-exec,
> > >or exec-only, etc.) without having to modify memslots.
> > >
> > >Introduce two ioctls (advertised by KVM_CAP_MEMORY_ATTRIBUTES) to allow
> > >userspace to operate on the per-page memory attributes.
> > >  - KVM_SET_MEMORY_ATTRIBUTES to set the per-page memory attributes to
> > >    a guest memory range.
> > 
> > >  - KVM_GET_SUPPORTED_MEMORY_ATTRIBUTES to return the KVM supported
> > >    memory attributes.
> > 
> > This ioctl() is already removed. So, the changelog is out-of-date and needs
> > an update.
> 
> Doh, I lost track of this and the fixup for KVM_CAP_MEMORY_ATTRIBUTES below.
> 
> > >+:Capability: KVM_CAP_MEMORY_ATTRIBUTES
> > >+:Architectures: x86
> > >+:Type: vm ioctl
> > >+:Parameters: struct kvm_memory_attributes(in)
> > 
> > 					   ^ add one space here?
> 
> Ah, yeah, that does appear to be the standard.
> > 
> > 
> > >+static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
> > >+					  struct kvm_gfn_range *range)
> > >+{
> > >+	/*
> > >+	 * Unconditionally add the range to the invalidation set, regardless of
> > >+	 * whether or not the arch callback actually needs to zap SPTEs.  E.g.
> > >+	 * if KVM supports RWX attributes in the future and the attributes are
> > >+	 * going from R=>RW, zapping isn't strictly necessary.  Unconditionally
> > >+	 * adding the range allows KVM to require that MMU invalidations add at
> > >+	 * least one range between begin() and end(), e.g. allows KVM to detect
> > >+	 * bugs where the add() is missed.  Rexlaing the rule *might* be safe,
> > 
> > 					    ^^^^^^^^ Relaxing
> > 
> > >@@ -4640,6 +4850,17 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> > > 	case KVM_CAP_BINARY_STATS_FD:
> > > 	case KVM_CAP_SYSTEM_EVENT_DATA:
> > > 		return 1;
> > >+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> > >+	case KVM_CAP_MEMORY_ATTRIBUTES:
> > >+		u64 attrs = kvm_supported_mem_attributes(kvm);
> > >+
> > >+		r = -EFAULT;
> > >+		if (copy_to_user(argp, &attrs, sizeof(attrs)))
> > >+			goto out;
> > >+		r = 0;
> > >+		break;
> > 
> > This cannot work, e.g., no @argp in this function and is fixed by a later commit:
> > 
> > 	fcbef1e5e5d2 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
> 
> I'll post a fixup patch for all of these, thanks much!

Heh, that was an -ENOCOFFEE.  Fixup patches for a changelog goof and an ephemeral
bug are going to be hard to post.

Paolo, do you want to take care of all of these fixups and typos, or would you
prefer that I start a v14 branch and then hand it off to you at some point?
