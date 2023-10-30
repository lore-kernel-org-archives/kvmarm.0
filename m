Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D051C23C3
	for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 22:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0dwNFwP1"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6b2018a11e2so5038136b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 15:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698703932; x=1699308732; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g8DEvtikhnQyn+T5K55cZjm1cs6/IKtx/WCyiBBil5U=;
        b=0dwNFwP1lbNvd42qtmDeI0BJSqJf40xYCCH9Nqxtz6raeQyufFyqp4SNN3GKtK8/BR
         taUzoB2hXZfb+42E4pf867jxo6KnxNXA6a1FkSmvdVkMOHCPXf/KRSx+USBjMD6JtIcN
         dmuyefPh3p/MW1WS3Lb5FuExYZtor8YTZylB+RWzUJXPl3ECT5y+Bwei+8PN3YEXMEFU
         gBVa2BqFtzbpdbWJ69Ctzj2hbcE/L97L0bS/TqBYUpSa9EPaaOS3BVrh+vkPBoKTv8ju
         fBfVjF0vXtZG9vdguOJI2dLvLuceWfIaZe1YnH86ASXFhTz0ua+D/jZmvA6DfEVdk7LB
         20yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698703932; x=1699308732;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g8DEvtikhnQyn+T5K55cZjm1cs6/IKtx/WCyiBBil5U=;
        b=UbRHnl+C7f7w88TBFFvvBDS0sQnS3XQfRrB2E9inandLqs2fFFhZBokF4LSKGoAc8L
         ljPy572d/pqQwYYeeGNskvJ5YG0QQYZWJahsb7X0VwokA9RN7zttKvyiFi5bT70o24l4
         gih95Sh9j1HGKMNmE5JJQwjBHNMjuCdUfHRBeqGe2tgQh/u+WTXlbRmIclTkU3HoCAu4
         KqJsFLMz7E7R+VqL+VSvZBJW2vA1NvpjVeEuEX0UT6pusXvddbzv78V3DBTIe+eCmHAf
         Zghoba//L+e/YyR9rnDRn1QO37gl3ac5YgC6PJ0dx+ZDVyJgND2SI7odRvKpFqfSNTv3
         4SkA==
X-Gm-Message-State: AOJu0YzQ1g/KOrDAso+HujWEhvRirHWyJ6YBNbHyojA1OoAQZ+UnEld3
	kt1xYx3xHK9YEfLR38ZB/sakXDnxNjA=
X-Google-Smtp-Source: AGHT+IGGcxVYGAYGv3uCrE8wHX1TR4p8IURd9gUNgfJNwa+fo9vdIR8HGGPD/6eLST5HVrX+Zf4WM1nECms=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1755:b0:68e:24fe:d9a with SMTP id
 j21-20020a056a00175500b0068e24fe0d9amr205380pfc.2.1698703932137; Mon, 30 Oct
 2023 15:12:12 -0700 (PDT)
Date: Mon, 30 Oct 2023 15:12:10 -0700
In-Reply-To: <ZUARTvhpChFSGF9s@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-9-seanjc@google.com>
 <211d093f-4023-4a39-a23f-6d8543512675@redhat.com> <ZUARTvhpChFSGF9s@google.com>
Message-ID: <ZUAqOn_zjvM4hukK@google.com>
Subject: Re: [PATCH v13 08/35] KVM: Introduce KVM_SET_USER_MEMORY_REGION2
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
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
> On Mon, Oct 30, 2023, Paolo Bonzini wrote:
> > On 10/27/23 20:21, Sean Christopherson wrote:
> > > 
> > > +		if (ioctl == KVM_SET_USER_MEMORY_REGION)
> > > +			size = sizeof(struct kvm_userspace_memory_region);
> > 
> > This also needs a memset(&mem, 0, sizeof(mem)), otherwise the out-of-bounds
> > access of the commit message becomes a kernel stack read.
> 
> Ouch.  There's some irony.  Might be worth doing memset(&mem, -1, sizeof(mem))
> though as '0' is a valid file descriptor and a valid file offset.
> 
> > Probably worth adding a check on valid flags here.
> 
> Definitely needed.  There's a very real bug here.  But rather than duplicate flags
> checking or plumb @ioctl all the way to __kvm_set_memory_region(), now that we
> have the fancy guard(mutex) and there are no internal calls to kvm_set_memory_region(),
> what if we:
> 
>   1. Acquire/release slots_lock in __kvm_set_memory_region()

Gah, this won't work with x86's usage, which acquire slots_lock quite far away
from __kvm_set_memory_region() in several places.  The rest of the idea still
works, kvm_vm_ioctl_set_memory_region() will just need to take slots_lock manually.

>   2. Call kvm_set_memory_region() from x86 code for the internal memslots
>   3. Disallow *any* flags for internal memslots
>   4. Open code check_memory_region_flags in kvm_vm_ioctl_set_memory_region()
>   5. Pass @ioctl to kvm_vm_ioctl_set_memory_region() and allow KVM_MEM_PRIVATE
>      only for KVM_SET_USER_MEMORY_REGION2
