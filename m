Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CF828B3FA
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 23:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753227747; cv=none; b=s59RTFb4BfU9qGPN/pRwJNFv1N2waoYcHKZQSKvDcfzVNjZJSNlqf3ay+WUKjujG0OuMYzaHTH4tk7JH0gbVPDSl117xaXAhD6jI42AMVQMJ39D5hEOOYqxT8dPY/wteEf5MNy7rloPZfNVm39uoKEqerLFpbPxBBSddx6LyzRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753227747; c=relaxed/simple;
	bh=KmdfdNUxjHfIoxf80hBqYjQ/1GKN1PEjgM/hjTKhDHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C1T6YCX+iqDhj1g8M8j1IljXXO12t33chijJgWZg6Z2nl3nUETwxCD8xbecb9iUbvTGhvrRJ0hKYHeMJjl80TnlTgI8wlXeEBeNBnonbkQaxJRLnEMjwlP9oHtSD/z2ClEloGdi+5GT9jJJqWuIJaKMS8tm/HfM9dXicuowBKCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iRWVP3ZM; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iRWVP3ZM"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31bc3128fcso7907648a12.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 16:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753227745; x=1753832545; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C4436MwwaaGsBQYuGwPP46zP65nxhOyA9XxeTVRWwmU=;
        b=iRWVP3ZMaraYHDGQWCuBwsTXxOrEqrBFy+tllVFHODiHabj/RUoioItzwz31YQGDfa
         7hL1WjafmyhhC4Bv0p0s2U/TkogT4/p0Yn2uHpKbVGW0Hw3RdBIqU9BN7PXkvjKtVdy+
         044XfLLjs8XDnWSQ2o1SDXsmpyzKk0wNKKcdaxOpt9lbOnm6yOfXwTJy9YnZ0ESfrZ/f
         dbCBzI9yK1hzngtX6gGxHCr+Obx98yVp+y1eHuqiSh8wySMLkTmf4p/H6q3pPmG1bUPD
         DUAj906l5yEoTCeSgK7CMZ2LPKkgYZTy/RaRp68PWU3Bc18lDhE09o4nCW1IXplAxZBJ
         co6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753227745; x=1753832545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C4436MwwaaGsBQYuGwPP46zP65nxhOyA9XxeTVRWwmU=;
        b=HzNMNhTEFC0fo3OzlJiRqX+CE7NH0DJLiOMhm5K4e4KW8Sb1Bd5SRTv9Crpe0EV/uB
         8AEm8zqDRMFi2ZntN49B5Evf3UO1s6j+DfbYbvs46rFVHRz+rc1Fv0/Rodvo9MPZxrjY
         y3rHE887cH4W5dAOfgKp9GdmAd0fVL/yMMWxUMKmIXJebwiMWzA6jB6eIgbOl4/VgQ1m
         I9uJpMnhEgUn0ub0fCIPs26+eNbvaiyF4A2YHmZj282dIM8jLNQ7USlbLCPl54a1312d
         DsI7Vj5L6ftst3LCaUiPPlZ5/U2EDKwkbnMd2yofj0c/O5X4Jy8srm6Vl1rzSaBn5yrL
         94Dw==
X-Forwarded-Encrypted: i=1; AJvYcCXifDXysRQpB06tQWICxGGG86nhQEh5z2AV1J2jvmeTK+IVpStu1rVxMEf3UzBC5Udc2ltqDSQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYRLN6o30+t6t9CZuxUcsRnQTuXtVlyV+7zK2hf0ZwPkiRsUIg
	0skkO5eQlLYonFyd9KnNHm3vEgz4C5a27H9OL0Nz22pfp4vhI2rIYTlwBAE/vwVrfJL4X9H1ypg
	NmNVM3w==
X-Google-Smtp-Source: AGHT+IHLrCrcEJh1eqR+2A2CsgZBx82DgvNUPV5JtUfEsyEi8WO/Hm3qnM3XnGuN+OWhk9ivI2YtpAQwcFU=
X-Received: from plbjx8.prod.google.com ([2002:a17:903:1388:b0:234:c2e4:1e08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf09:b0:235:ecf2:393
 with SMTP id d9443c01a7336-23f981de13dmr10817305ad.53.1753227744705; Tue, 22
 Jul 2025 16:42:24 -0700 (PDT)
Date: Tue, 22 Jul 2025 16:42:23 -0700
In-Reply-To: <CA+EHjTw46a+NCcgGXQ1HA+a3MSZD9Q97V8W-Xj5+pYuTh4Z2_w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com> <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
 <aH-1JeJH2cEvyEei@google.com> <CA+EHjTw46a+NCcgGXQ1HA+a3MSZD9Q97V8W-Xj5+pYuTh4Z2_w@mail.gmail.com>
Message-ID: <aIAh3xkU52Z100xK@google.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
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
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 22, 2025, Fuad Tabba wrote:
> On Tue, 22 Jul 2025 at 16:58, Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > > On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > > > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > > > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > > > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > > > > cleaner resting state (see the diff stats).
> > > > >
> > > > > So just so that I am clear, applying the diff below to the appropriate
> > > > > patches would address all the concerns that you have mentioned in this
> > > > > email?
> > > >
> > > > Yes?  It should, I just don't want to pinky swear in case I botched something.
> > >
> > > Other than this patch not applying, nah, I think it's all good ;P. I
> > > guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
> > > somewhere in a local tree of yours. There are quite a few conflicts
> > > and I don't think it would build even if based on the right tree,
> > > e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
> > > rather an addition of an undeclared identifier.
> > >
> > > That said, I think I understand what you mean, and I can apply the
> > > spirit of this patch.
> > >
> > > Stay tuned for v16.
> >
> > Want to point me at your branch?  I can run it through my battery of tests, and
> > maybe save you/us from having to spin a v17.
> 
> That would be great. Here it is:
> 
> https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-basic-6.16-v16
> 
> No known issues from my end. But can you have a look at the patch:
> 
> KVM: guest_memfd: Consolidate Kconfig and guest_memfd enable checks
> 
> In that I collected the changes to the config/enable checks that
> didn't seem to fit well in any of the other patches.

Regarding config stuff, patch 02, KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE, is missing a KVM_GMEM => KVM_GUEST_MEMFD rename.

While playing with this, I also discovered why this code lives in the KVM_X86 config:

  select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM

Commit ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module
is requested") didn't have all the vendor netural configs depend on KVM_X86, and
so it's possible to end up with unmet dependencies.  E.g. KVM_SW_PROTECTED_VM can
be selected with KVM_X86=n, and thus with KVM_GUEST_MEMFD=n.

We could punt on that mess until after this series, but that'd be a even more
churn, and I'm not sure I could stomach giving acks for the continued addition
of ugly kconfig dependencies. :-)

Lastly, regarding "Consolidate Kconfig and guest_memfd enable checks", that needs
to land before f6a5f3a22bbe ("KVM: guest_memfd: Allow host to map guest_memfd pages"),
otherwise KVM will present a weird state where guest_memfd can be used for default
VMs, but if and only KVM_GUEST_MEMFD happens to be selected by something else.
That also provides a better shortlog: "KVM: x86: Enable KVM_GUEST_MEMFD for all
64-bit builds".  The config cleanups and consolidations are a nice side effect,
but what that patch is really doing is enabling KVM_GUEST_MEMFD more broadly.

Actually, all of the arch patches need to come before f6a5f3a22bbe ("KVM: guest_memfd:
Allow host to map guest_memfd pages"), otherwise intermediate builds will have
half-baked support for guest_memfd mmap().  Or rather, KVM shouldn't let userspace
enable GUEST_MEMFD_FLAG_MMAP until all the plumbing is in place.  I suspect that
trying to shuffle the full patches around will create cyclical dependency hell.
It's easy enough to hold off on adding GUEST_MEMFD_FLAG_MMAP until KVM is fully
ready, so I think it makes sense to just add GUEST_MEMFD_FLAG_MMAP along with the
capability.

Rather than trying to pass partial patches around, I pushed a branch to:

  https://github.com/sean-jc/linux.git x86/gmem_mmap

Outside of the x86 config crud, and deferring GUEST_MEMFD_FLAG_MMAP until KVM is
fully prepped, there _shouldn't_ be any changes relatively to what you have.

Note, it's based on:

  https://github.com/kvm-x86/linux.git next

as there are x86 kconfig dependencies/conflicts with changes that are destined
for 6.17 (and I don't think landing this in 6.17 is realistic, i.e. this series
will effectively follow kvm-x86/next no matter what).

I haven't done a ton of runtime testing yet, but it passes all of my build tests
(I have far too many configs), so I'm reasonably confident all the kconfig stuff
isn't horribly broken.

Oh, and I also squashed this into the very last patch.  The curly braces, line
wrap, and hardcoded boolean are all superfluous.

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 4cdccabc160c..a0c5db8fd72d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -249,8 +249,7 @@ static bool check_vm_type(unsigned long vm_type)
        return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
 }
 
-static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
-                          bool expect_mmap_allowed)
+static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags)
 {
        struct kvm_vm *vm;
        size_t total_size;
@@ -272,7 +271,7 @@ static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
 
        test_file_read_write(fd);
 
-       if (expect_mmap_allowed) {
+       if (guest_memfd_flags & GUEST_MEMFD_FLAG_MMAP) {
                test_mmap_supported(fd, page_size, total_size);
                test_fault_overflow(fd, page_size, total_size);
 
@@ -343,13 +342,11 @@ int main(int argc, char *argv[])
 
        test_gmem_flag_validity();
 
-       test_with_type(VM_TYPE_DEFAULT, 0, false);
-       if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP)) {
-               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP,
-                              true);
-       }
+       test_with_type(VM_TYPE_DEFAULT, 0);
+       if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
+               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP);
 
 #ifdef __x86_64__
-       test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
+       test_with_type(KVM_X86_SW_PROTECTED_VM, 0);
 #endif
 }
