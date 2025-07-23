Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFCC205AB6
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 09:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753262578; cv=none; b=S2hGoW59SLmNqeyoJfywKEqpxelk/z7yVKLxxQrPpX/vCagvvZ1++/4TcUlBQMNFSrK1v3YN3pj1e/V9IccisMtosQKJagjxe+xCbgFJiLjmaZ+QnKG6773SL39AQYjTG+Of4XWITEvVJVEongVz9hoRb20YeTO9v4dxlyMGVPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753262578; c=relaxed/simple;
	bh=vAA1Lv7W544jmjXnmOIpPcLBsrN3AE3t7Hfl5SQXlKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WKmteM4oQJxMKM0oF4eZJ4UulA8ZQdr8Uq/4Uh5ov4b0AzPkyhYgzAgv4VXxErX92Yh9hYn4AX8bN6wFE/nYZ0WT8RJt9jCHO3SMame/PBM1NdYDWHYqV1voXvZbAzIAbHgDvU5Wx2uKDpsnYuxOYmwR82/VyegHta+XIKmMLuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xvYl+QQp; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xvYl+QQp"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso349421cf.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 02:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753262576; x=1753867376; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1l9DC9s6bqSZlXl3hk+96usOVx+LGIZFtzxNIqVYEY=;
        b=xvYl+QQpQKxqHTrr5Y0KhxjbHHbqE0hCSlU6oIyV3w2yJP/NOeSmdmJKRUbvDwnDfT
         kAZlaUd6u9KPBV3V48nMgBiSUB6JfMeostZcqFSN4rFvcwBNbnzzbYLCjwI+gDn6GthC
         MOCpbS/N/ZzEc/UV2f/YXNCvtWfGkJhlQ0vvKhLCUbendJQdDtvQuB/E/YsmE9GOdvap
         5uuwp7VavlsUj5VDZdUfVTPQoI70NcuyFOsphWEg/4qWGRO5eUXWKMBrwi6TL+iWhJjn
         +xT1MfPW0+tXonXZss7HDB7eJd0KCzw4YPfSRIC1SblAyeIgnY0fSOcILJhp2kHbeC2G
         oebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753262576; x=1753867376;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q1l9DC9s6bqSZlXl3hk+96usOVx+LGIZFtzxNIqVYEY=;
        b=Kif51maMIPPp7e3A4/bXRA420P5voR8EaqG5AWBRf3Ywbda5gJDdq7rr5FOZxYcCLF
         tEAxsGCkGVLkc1XaUFv4UW+Ikk43QBADX7xvKtS78NHUQb6Y3kPUwBsq0DAQuZ09Vh3B
         Nge7NX/F1kFjB1N7ojIhvB92ruHdZ1ugaEde1WGomSw4pP3PslRz2hiYInGI8PbDy1PJ
         pJtXn8xKDmvOdYP3abC9TmlKgvVZD48cBXEw3Ze70DEXSMFMkFTyENm8pnZ8gOwKyGui
         ZfMms1n9igyyui6qSvi3rMCQ6WzGi8UXKOh/x1pJXrQX5taFnjfnNxosxIppyZRtg8pb
         icfg==
X-Forwarded-Encrypted: i=1; AJvYcCWy6cU2nrIC4+Clw7o8Na99R809mpr6iYeX1QSRQAql9ti6RUVyHkuK1TCU/FxLh94BXWSuczY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw83azbtTtNh3FRF0HcnMLRCP/l0OYlRjbvqwbiG7vky/iJATIo
	khZMQyvY4FxOQBDH5VlBUTsWcBmvoQr/oAwYiP8eG4TUCIeM1HcAZtUXhFeCsn+sjdwNaU0X9Sl
	kOXiBjoGTwIFxk281ZwD5xmZeCDSe5Vh1hNo626Qf
X-Gm-Gg: ASbGncum/9ulLkOwINeLy4W2oeT1+LJGj8vttCzwlusoChdlgpGXak8zDXNIK1BCAt4
	cCNtBRHkGN5z2/mA3hcOZU8yRhfCsjmY3YX4Kb+kDW4p2c/0t0LmYRO8FPw7To66cQzr1jVMXTR
	rE+sl5WTv4CtLDUhKyW76bUVMS983WH81kx4GVNouoECjNgXDQxhMWZTSMXGPNQZh/DrcM5mbIb
	h3L4R8qkGpU8EqR3t5LFCtFe1YnTzN9SEen
X-Google-Smtp-Source: AGHT+IHpGSWUb20Op9Qp28Uz72zppWmO/fpdDBu9sBC5ToKI3zBiTnA4LkrTZ+17aXYm0O7UQ4tqXYX6jHbEEiExdf0=
X-Received: by 2002:a05:622a:551a:b0:4a8:eb0:c528 with SMTP id
 d75a77b69052e-4ae6f066032mr2643391cf.15.1753262575605; Wed, 23 Jul 2025
 02:22:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com> <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
 <aH-1JeJH2cEvyEei@google.com> <CA+EHjTw46a+NCcgGXQ1HA+a3MSZD9Q97V8W-Xj5+pYuTh4Z2_w@mail.gmail.com>
 <aIAh3xkU52Z100xK@google.com>
In-Reply-To: <aIAh3xkU52Z100xK@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 23 Jul 2025 10:22:19 +0100
X-Gm-Features: Ac12FXy0a_zhWCTWrmc8iH91Uu03l4tlmUMT8pdCRl-WsFj9mim4tPfVNS6-H9U
Message-ID: <CA+EHjTy_82ADyf05-ySq-+901bT+W30EXm7t4ppvVAd5Eds40Q@mail.gmail.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Jul 2025 at 00:42, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > On Tue, 22 Jul 2025 at 16:58, Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > > > On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > > > > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > > > > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > > > > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > > > > > cleaner resting state (see the diff stats).
> > > > > >
> > > > > > So just so that I am clear, applying the diff below to the appropriate
> > > > > > patches would address all the concerns that you have mentioned in this
> > > > > > email?
> > > > >
> > > > > Yes?  It should, I just don't want to pinky swear in case I botched something.
> > > >
> > > > Other than this patch not applying, nah, I think it's all good ;P. I
> > > > guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
> > > > somewhere in a local tree of yours. There are quite a few conflicts
> > > > and I don't think it would build even if based on the right tree,
> > > > e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
> > > > rather an addition of an undeclared identifier.
> > > >
> > > > That said, I think I understand what you mean, and I can apply the
> > > > spirit of this patch.
> > > >
> > > > Stay tuned for v16.
> > >
> > > Want to point me at your branch?  I can run it through my battery of tests, and
> > > maybe save you/us from having to spin a v17.
> >
> > That would be great. Here it is:
> >
> > https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-basic-6.16-v16
> >
> > No known issues from my end. But can you have a look at the patch:
> >
> > KVM: guest_memfd: Consolidate Kconfig and guest_memfd enable checks
> >
> > In that I collected the changes to the config/enable checks that
> > didn't seem to fit well in any of the other patches.
>
> Regarding config stuff, patch 02, KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
> CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE, is missing a KVM_GMEM => KVM_GUEST_MEMFD rename.
>
> While playing with this, I also discovered why this code lives in the KVM_X86 config:
>
>   select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
>
> Commit ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module
> is requested") didn't have all the vendor netural configs depend on KVM_X86, and
> so it's possible to end up with unmet dependencies.  E.g. KVM_SW_PROTECTED_VM can
> be selected with KVM_X86=n, and thus with KVM_GUEST_MEMFD=n.
>
> We could punt on that mess until after this series, but that'd be a even more
> churn, and I'm not sure I could stomach giving acks for the continued addition
> of ugly kconfig dependencies. :-)
>
> Lastly, regarding "Consolidate Kconfig and guest_memfd enable checks", that needs
> to land before f6a5f3a22bbe ("KVM: guest_memfd: Allow host to map guest_memfd pages"),
> otherwise KVM will present a weird state where guest_memfd can be used for default
> VMs, but if and only KVM_GUEST_MEMFD happens to be selected by something else.
> That also provides a better shortlog: "KVM: x86: Enable KVM_GUEST_MEMFD for all
> 64-bit builds".  The config cleanups and consolidations are a nice side effect,
> but what that patch is really doing is enabling KVM_GUEST_MEMFD more broadly.
>
> Actually, all of the arch patches need to come before f6a5f3a22bbe ("KVM: guest_memfd:
> Allow host to map guest_memfd pages"), otherwise intermediate builds will have
> half-baked support for guest_memfd mmap().  Or rather, KVM shouldn't let userspace
> enable GUEST_MEMFD_FLAG_MMAP until all the plumbing is in place.  I suspect that
> trying to shuffle the full patches around will create cyclical dependency hell.
> It's easy enough to hold off on adding GUEST_MEMFD_FLAG_MMAP until KVM is fully
> ready, so I think it makes sense to just add GUEST_MEMFD_FLAG_MMAP along with the
> capability.
>
> Rather than trying to pass partial patches around, I pushed a branch to:
>
>   https://github.com/sean-jc/linux.git x86/gmem_mmap
>
> Outside of the x86 config crud, and deferring GUEST_MEMFD_FLAG_MMAP until KVM is
> fully prepped, there _shouldn't_ be any changes relatively to what you have.
>
> Note, it's based on:
>
>   https://github.com/kvm-x86/linux.git next
>
> as there are x86 kconfig dependencies/conflicts with changes that are destined
> for 6.17 (and I don't think landing this in 6.17 is realistic, i.e. this series
> will effectively follow kvm-x86/next no matter what).
>
> I haven't done a ton of runtime testing yet, but it passes all of my build tests
> (I have far too many configs), so I'm reasonably confident all the kconfig stuff
> isn't horribly broken.
>
> Oh, and I also squashed this into the very last patch.  The curly braces, line
> wrap, and hardcoded boolean are all superfluous.

Thank you for this. These patches look good to me.

I've tested them on x86 and arm64, and everything runs fine. I'll have
a closer look at them, and probably send v16 later today.

I know that it's probably too late for 6.17, but it would be great if
we could queue this for 6.18.

Cheers,
/fuad


> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 4cdccabc160c..a0c5db8fd72d 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -249,8 +249,7 @@ static bool check_vm_type(unsigned long vm_type)
>         return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
>  }
>
> -static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
> -                          bool expect_mmap_allowed)
> +static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags)
>  {
>         struct kvm_vm *vm;
>         size_t total_size;
> @@ -272,7 +271,7 @@ static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
>
>         test_file_read_write(fd);
>
> -       if (expect_mmap_allowed) {
> +       if (guest_memfd_flags & GUEST_MEMFD_FLAG_MMAP) {
>                 test_mmap_supported(fd, page_size, total_size);
>                 test_fault_overflow(fd, page_size, total_size);
>
> @@ -343,13 +342,11 @@ int main(int argc, char *argv[])
>
>         test_gmem_flag_validity();
>
> -       test_with_type(VM_TYPE_DEFAULT, 0, false);
> -       if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP)) {
> -               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP,
> -                              true);
> -       }
> +       test_with_type(VM_TYPE_DEFAULT, 0);
> +       if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
> +               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP);
>
>  #ifdef __x86_64__
> -       test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
> +       test_with_type(KVM_X86_SW_PROTECTED_VM, 0);
>  #endif
>  }
