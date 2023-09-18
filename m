Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4699F1F5EE
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 15:50:00 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d8153284d6eso5253756276.3
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 08:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695052199; x=1695656999; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sNXD76U7haNeW91VMZlpdLB8TVqFEiovhx95zes76gg=;
        b=rfr6F+5OCUOvPUK/RR7Kq8/OOpnpe9Yys6Zia//mq7UU90tcCZoqvLcAxFPFR9TL5O
         kKL3Qxt514wNncaCyOQorn9VTy/1JKTLncXEQlCveNPZpMS78iSo2MQ8dtV8b4KzhGiz
         G30czmQ69ENUT/m+WqEh5zX+EFcWrwlibbMQYE08i+5d5mSponB6pwmkLfrGMocKrJ8d
         jJao8m6pGLP8ghZ4OoD5FD9LnF/pjagcqi17MEZtCJ3Li5doQQkzkNQ9i0QLRywtyQfV
         a9eAusclcaQJWlh7X2npi9v00BQm8kQTdackr6/1O6jwsZl3PNxvsRbXwTcpTkMT/2K7
         vg/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695052199; x=1695656999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sNXD76U7haNeW91VMZlpdLB8TVqFEiovhx95zes76gg=;
        b=wwKRvzutIyQXfK5thVFuGiqzF37lxBswk5ncYU0sKYx0Ng9a17HWFYzrYEmKnLFYFw
         VoISGir/1xHUzpHMT1xqEykl84yr3YDoXlsE0Fs9H+99jwlcOM8efUkAgqpt43mfx7Wi
         u/mb/IpzP6OLskQ4UbRhIGkG5hXlsfphlwJZxjlKQu+vs2sBthKTs2wL/H8TKpZ7xrCA
         F5BuqAr40UM4PDM0C3TAPzSMNJP08fFcelqSkR3GfMEOuC6FPwNLLn4Ms8LhN11ISX4Q
         aCDL0g+X/DnR5EwMWOESKuMI6eOQSruE4cVAd5cGbkFMBD9N7Me4pjZXJxWxME8NYGcQ
         VrIg==
X-Gm-Message-State: AOJu0YyKbmsYEZDiB4o3CUEy+3mkth1Fo8l5rfsvfgHJJYrV8stO+I7B
	hdXYOwDKHtNmHzQKG4RNWkoUnYJtrUI=
X-Google-Smtp-Source: AGHT+IE1DPoRp0N2nDleDeL+nMknRqhKzdJCPwHMJrwMUBjkYLBNjcfJz91+ASKxJdGzFGGlGgloaP/fXoU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2411:0:b0:d81:78ec:c403 with SMTP id
 k17-20020a252411000000b00d8178ecc403mr192905ybk.12.1695052199184; Mon, 18 Sep
 2023 08:49:59 -0700 (PDT)
Date: Mon, 18 Sep 2023 08:49:57 -0700
In-Reply-To: <20230918152110.GI13795@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com> <20230916003118.2540661-6-seanjc@google.com>
 <20230918152110.GI13795@ziepe.ca>
Message-ID: <ZQhxpesyXeG+qbS6@google.com>
Subject: Re: [PATCH 05/26] vfio: KVM: Pass get/put helpers from KVM to VFIO,
 don't do circular lookup
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>, 
	Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 18, 2023, Jason Gunthorpe wrote:
> On Fri, Sep 15, 2023 at 05:30:57PM -0700, Sean Christopherson wrote:
> > Explicitly pass KVM's get/put helpers to VFIO when attaching a VM to
> > VFIO instead of having VFIO do a symbol lookup back into KVM.  Having both
> > KVM and VFIO do symbol lookups increases the overall complexity and places
> > an unnecessary dependency on KVM (from VFIO) without adding any value.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  drivers/vfio/vfio.h      |  2 ++
> >  drivers/vfio/vfio_main.c | 74 +++++++++++++++++++---------------------
> >  include/linux/vfio.h     |  4 ++-
> >  virt/kvm/vfio.c          |  9 +++--
> >  4 files changed, 47 insertions(+), 42 deletions(-)
> 
> I don't mind this, but Christoph had disliked my prior attempt to do
> this with function pointers..
> 
> The get can be inlined, IIRC, what about putting a pointer to the put
> inside the kvm struct?

That wouldn't allow us to achieve our goal, which is to hide the details of
"struct kvm" from VFIO (and the rest of the kernel).

What's the objection to handing VFIO a function pointer?

> The the normal kvm get/put don't have to exported symbols at all?

The export of kvm_get_kvm_safe() can go away (I forgot to do that in this series),
but kvm_get_kvm() will hang around as it's needed by KVM sub-modules (PPC and x86),
KVMGT (x86), and drivers/s390/crypto/vfio_ap_ops.c (no idea what to call that beast).

Gah, KVMGT doesn't actually need to call get/put, that can be handled by
kvm_page_track_register_notifier().

I am planning on making exports for sub-modules conditional on there actually
being submodules, so that's 2 of the 3 gone, but tackling the s390 crypto driver
is an entirely different story.
