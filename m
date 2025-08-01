Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38A323AD
	for <kvmarm@lists.linux.dev>; Fri,  1 Aug 2025 16:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754066662; cv=none; b=uwc+5Ae1FMvqIiP3o1Q9qffWr3wAr9bH7fnDaRu0gWJubcX217icoc9RFG8nCUS0MTmRIiVg6dVqdpygBp9M08wDKXP9/0svVo+EYupbDLr6fsxVr3mDnBa1Ayy7HsyL45qMEHAKa3C/zVRr6bZxc0LyoIMcNNYGepy6Y4MmrwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754066662; c=relaxed/simple;
	bh=igrMx6iFIDdFmFIB8l2bfoLXUmpgB2zic38Ft4a8CSI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nz3lZHGHWqppcP/vYXb7S6ZD4tH8thefV0DT7YesJye9SlUdrZKBE2y1Z0/HO/HgYmv9gojIPbS+eAa6i1OAwxZdJouuFqwl8w+eY+VyDrfBaHty45bBGmvzo99sZdYfl+GACBx0hClk7pplIZbWKb5aAJ4xJKU74MZ4hg01mNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2P7SdGz3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2P7SdGz3"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31ed9a17f22so2955452a91.0
        for <kvmarm@lists.linux.dev>; Fri, 01 Aug 2025 09:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754066660; x=1754671460; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cmFw3mXH/exEQe+/QLbl03MUiMl4ucnB+5XoLqj1sUc=;
        b=2P7SdGz3+tsIO6ygNmHKBAdEni9QeHMCPFvMHxbvChVxLW99ebm5qRsBTHwCdVT3d2
         k1b5R9meVJUNOYiU7unHlr2hNm+CU8HqeKoUyRl1QrgDsXjQVu50EGHNTsfUQbl5tR4p
         8k+4TgQc5L37FOjvXAAIvjd2ZspsAK9zQXKDNqJa1CKuv5Hpw8/TsgrhfCk1Tg+9uLIH
         trwQ9KpgargQaq/nv8kHo1RCau0rGZsP2QjvhbzMjM4jEwp2w2gaZ120enDt4Kzuyn/y
         ZQgnSkF69nVOS3r5o7FiUFVTspWbhNiBchzITNO0txXE9DzYoSXdUa5sqlsYWtsKJoZF
         LvDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754066660; x=1754671460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cmFw3mXH/exEQe+/QLbl03MUiMl4ucnB+5XoLqj1sUc=;
        b=p3ShNU9yG1jz9PjDHMOiJMA+r8iFStJvmB54MUSlw2YskP/S4qjki7KGdGqUbCYLfE
         vwXjjIJNL5fKFAY4CxwDzOqGdSR31pMwPHs3zPcJ3qy4sQ8RCms4ZzNaMT+i8AhcO8x0
         jZHwtVzOWS2p+xFYc14mrj6bH/J721SRJrOxsRIjTbH75/ac7R8Gk29Odc3SJMjRbLAD
         dETlVOYfzbSq1mcvZRNN0C62YVcsGe5LLR74UVflYbj44F9VLaUlR/b6MfcDYqnti/2C
         DakGrEtxzbJo3PRB0njzRQFyMMsq1UHhvFMtV2vY8OaPmmknAGXNWP8lNKhFQOzB34HV
         nDEA==
X-Forwarded-Encrypted: i=1; AJvYcCVZQLmrUJUW2djsxwzYR9ULqefkLRHtT1U/EMxFjdmJaOy2TnoZfPQPyjiKQkoysQxfaYpm/Xk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDT/n8vBTACGBz1UMMkEacmhFFcg793oD8Gf+ilDWD8JwtX8gt
	tOJcxeaMFrYcKH0Wif1eLgEvjCC+k3/pbzNqoETL6gypLUSD6c079B+4lzgqVOI7lN4TKNVnVhi
	FXl+cEQ==
X-Google-Smtp-Source: AGHT+IHTCPWlBsVY++6yRHnsFzrU+E4U0uWTRC0q7DUxzgBPU0wzo6RMGy3C5kq+eZLK/o+LJzUMjGasNMs=
X-Received: from pjf12.prod.google.com ([2002:a17:90b:3f0c:b0:311:462d:cb60])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1812:b0:311:da03:3437
 with SMTP id 98e67ed59e1d1-321162b44b8mr568364a91.27.1754066660052; Fri, 01
 Aug 2025 09:44:20 -0700 (PDT)
Date: Fri, 1 Aug 2025 09:44:18 -0700
In-Reply-To: <b27f807e-b04f-487d-be13-74a8b0a61b42@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729193341.621487-1-seanjc@google.com> <20250729193341.621487-6-seanjc@google.com>
 <b27f807e-b04f-487d-be13-74a8b0a61b42@intel.com>
Message-ID: <aIzu4q_7yBmCIOWK@google.com>
Subject: Re: [PATCH 5/5] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Nikolay Borisov <nik.borisov@suse.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

+Chao

On Fri, Aug 01, 2025, Adrian Hunter wrote:
> On 29/07/2025 22:33, Sean Christopherson wrote:
> > +static int tdx_terminate_vm(struct kvm *kvm)
> > +{
> > +	if (kvm_trylock_all_vcpus(kvm))
> > +		return -EBUSY;
> > +
> > +	kvm_vm_dead(kvm);
> > +	to_kvm_tdx(kvm)->vm_terminated = true;
> > +
> > +	kvm_unlock_all_vcpus(kvm);
> > +
> > +	tdx_mmu_release_hkid(kvm);
> > +
> > +	return 0;
> > +}
> 
> As I think I mentioned when removing vm_dead first came up,
> I think we need more checks.  I spent some time going through
> the code and came up with what is below:
> 
> First, we need to avoid TDX VCPU sub-IOCTLs from racing with
> tdx_mmu_release_hkid().  But having any TDX sub-IOCTL run after
> KVM_TDX_TERMINATE_VM raises questions of what might happen, so
> it is much simpler to understand, if that is not possible.
> There are 3 options:
> 
> 1. Require that KVM_TDX_TERMINATE_VM is valid only if
> kvm_tdx->state == TD_STATE_RUNNABLE.  Since currently all
> the TDX sub-IOCTLs are for initialization, that would block
> the opportunity for any to run after KVM_TDX_TERMINATE_VM.
> 
> 2. Check vm_terminated in tdx_vm_ioctl() and tdx_vcpu_ioctl()
> 
> 3. Test KVM_REQ_VM_DEAD in tdx_vm_ioctl() and tdx_vcpu_ioctl()
> 
> [ Note cannot check is_hkid_assigned() because that is racy ]
> 
> Secondly, I suggest we avoid SEAMCALLs that will fail and
> result in KVM_BUG_ON() if HKID has been released.
> 
> There are 2 groups of those: MMU-related and TDVPS_ACCESSORS.
> 
> For the MMU-related, the following 2 functions should return
> an error immediately if vm_terminated:
> 
> 	tdx_sept_link_private_spt()
> 	tdx_sept_set_private_spte()
> 
> For that not be racy, extra synchronization is needed so that
> vm_terminated can be reliably checked when holding mmu lock
> i.e.
> 
> static int tdx_terminate_vm(struct kvm *kvm)
> {
> 	if (kvm_trylock_all_vcpus(kvm))
> 		return -EBUSY;
> 
> 	kvm_vm_dead(kvm);
> +
> +       write_lock(&kvm->mmu_lock);
> 	to_kvm_tdx(kvm)->vm_terminated = true;
> +       write_unlock(&kvm->mmu_lock);
> 
> 	kvm_unlock_all_vcpus(kvm);
> 
> 	tdx_mmu_release_hkid(kvm);
> 
> 	return 0;
> }
> 
> Finally, there are 2 TDVPS_ACCESSORS that need avoiding:
> 
> 	tdx_load_mmu_pgd()
> 		skip td_vmcs_write64() if vm_terminated
> 
> 	tdx_protected_apic_has_interrupt()
> 		skip td_state_non_arch_read64() if vm_terminated

Oof.  And as Chao pointed out[*], removing the vm_dead check would allow creating
and running vCPUs in a dead VM, which is most definitely not desirable.  Squashing
the vCPU creation case is easy enough if we keep vm_dead but still generally allow
ioctls, and it's probably worth doing that no matter what (to plug the hole where
pending vCPU creations could succeed):

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d477a7fda0ae..941d2c32b7dc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4207,6 +4207,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 
        mutex_lock(&kvm->lock);
 
+       if (kvm->vm_dead) {
+               r = -EIO;
+               goto unlock_vcpu_destroy;
+       }
+
        if (kvm_get_vcpu_by_id(kvm, id)) {
                r = -EEXIST;
                goto unlock_vcpu_destroy;

And then to ensure vCPUs can't do anything, check KVM_REQ_VM_DEAD after acquiring
vcpu->mutex.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c07dd423458..883077eee4ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4433,6 +4433,12 @@ static long kvm_vcpu_ioctl(struct file *filp,
 
        if (mutex_lock_killable(&vcpu->mutex))
                return -EINTR;
+
+       if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu)) {
+               r = -EIO;
+               goto out;
+       }
+
        switch (ioctl) {
        case KVM_RUN: {
                struct pid *oldpid;


That should address all TDVPS paths (I hope), and I _think_ would address all
MMU-related paths as well?  E.g. prefault requires a vCPU.

Disallowing (most) vCPU ioctls but not all VM ioctls on vm_dead isn't great ABI
(understatement), but I think we need/want the above changes even if we keep the
general vm_dead restriction.  And given the extremely ad hoc behavior of taking
kvm->lock for VM ioctls, trying to enforce vm_dead for "all" VM ioctls seems like
a fool's errand.

So I'm leaning toward keeping "KVM: Reject ioctls only if the VM is bugged, not
simply marked dead" (with a different shortlog+changelog), but keeping vm_dead
(and not introducing kvm_tdx.vm_terminated).

Thoughts?

[*] https://lore.kernel.org/all/aIlzeT+yFG2Tvb3%2F@intel.com
