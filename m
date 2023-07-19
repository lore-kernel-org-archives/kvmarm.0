Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA1314008
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 14:15:12 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5634dbfb8b1so588742a12.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 07:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689776112; x=1692368112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZpT1srfgRytmcGt7uikxVNkA3BifxPUMvb756SCoWfo=;
        b=j6O4A4Kn8RrMiTsmWugcLoaBmDhdEOi6nm13D61dQWbrv/4yDEEVo/KZUz/JqdfsPo
         ZnKg9K95Lj7ZE2/dyLjlrZe55VZWZdtTVn9fgyfdtCrw5ElGnLLq/Qm5V23hi657OpUr
         Ebqn7DpgmWmZ6MQquOf5BjnPEIp0JeTMJYNB26HnYKqlFJQ9PECoKhiIFC6MpAGppjwD
         QEmzIJjuF0aS8nAXfMaVCs/HL9rulvVWCoWXejxaQyjwn7Vpfe71Kirx4tiYJoYvfJy1
         s3tsizGDD9BtrGq0rYlfmNI7dH4xGaeqfoCnPAOEbyXtpSJtpl3/bu64M8d1b+aFanZ/
         4psA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689776112; x=1692368112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZpT1srfgRytmcGt7uikxVNkA3BifxPUMvb756SCoWfo=;
        b=eBw/P0l5Fg/awLB7a6K89ZdTYv+QHmI/HP4RVDZAoRT0fQnUUbhEigiNxT8zZwflpr
         m0XDFoD1islapCRAP0PIz9XyFvzWfXhfuvsk/W7EPYg5AhC1OXRfaqKDfBWHVKNjP053
         dRf/2EXJ3nFjI2OXZ60RbIAbjHnhNpWxiapJ7ZL1p4jpAbLL5nAI99+WzAoEyZLW9UID
         rQgPlLh8nkLcwgpkEhg9tOws5Mi5FX5YSfqjp91SZHI43U0ifzniS/g+/Pk/gDe5GgTi
         VYZWu82etLmCF0FJpsQ9FSG5TKWljHy6fZ7252WMrQ6J7C7VXevatKhaAvdp21s9lJQ0
         5+rQ==
X-Gm-Message-State: ABy/qLZ1K8oMOG2JxzsRC6hZlvlhOtz65cJS1Na4b6xLAKRWEqf33Gix
	Fc6LHFEFlRgHL8rNU1Guww5cSaD/zwc=
X-Google-Smtp-Source: APBJJlG/y4qA2BEDL4k7hIJJKli+sdbNpvQf/prgfQp/iya4mlyKn4vdU0WvDm35KgLLUXfLwfwgiDZvoZw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e812:b0:1ae:6895:cb96 with SMTP id
 u18-20020a170902e81200b001ae6895cb96mr14210plg.5.1689776111918; Wed, 19 Jul
 2023 07:15:11 -0700 (PDT)
Date: Wed, 19 Jul 2023 07:15:09 -0700
In-Reply-To: <20230719073115.vuedo2cf3mp27xm4@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-6-seanjc@google.com>
 <20230719073115.vuedo2cf3mp27xm4@yy-desk-7060>
Message-ID: <ZLfv7aRq5W52ezek@google.com>
Subject: Re: [RFC PATCH v11 05/29] KVM: Convert KVM_ARCH_WANT_MMU_NOTIFIER to CONFIG_KVM_GENERIC_MMU_NOTIFIER
From: Sean Christopherson <seanjc@google.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
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
	Jarkko Sakkinen <jarkko@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, Vlastimil Babka <vbabka@suse.cz>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 19, 2023, Yuan Yao wrote:
> On Tue, Jul 18, 2023 at 04:44:48PM -0700, Sean Christopherson wrote:
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 90a0be261a5c..d2d3e083ec7f 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -255,7 +255,9 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
> >  #endif
> >
> > -#ifdef KVM_ARCH_WANT_MMU_NOTIFIER
> > +struct kvm_gfn_range;
> 
> Not sure why a declaration here, it's defined for ARCHs which defined
> KVM_ARCH_WANT_MMU_NOTIFIER before.

The forward declaration exists to handle cases where CONFIG_KVM=n, specifically
arch/powerpc/include/asm/kvm_ppc.h's declaration of hooks to forward calls to
uarch modules:

	bool (*unmap_gfn_range)(struct kvm *kvm, struct kvm_gfn_range *range);
	bool (*age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
	bool (*test_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
	bool (*set_spte_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);

Prior to using a Kconfig, a forward declaration wasn't necessary because
arch/powerpc/include/asm/kvm_host.h would #define KVM_ARCH_WANT_MMU_NOTIFIER even
if CONFIG_KVM=n.

Alternatively, kvm_ppc.h could declare the struct.  I went this route mainly to
avoid the possibility of someone encountering the same problem on a different
architecture.
