Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2109D217F44
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731009397; cv=none; b=oZIhc2hZge3L1+JwramXx7lQIKG/efOR+tFmKo04tNjrbqvAN2CwpNvG2JPNPpNWE+aGrMbALNsHbkGmQS1MnIqAESJ0FA5TgM4Lji7pCEoAAmlT42OQIB+BebDjcp7VIZRShUU0PSzE4ODXbvSRQBfd9SVPwd1o2MnUOvraCB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731009397; c=relaxed/simple;
	bh=s9PQaqYy7gUAKaokyD0EQQVp3ndmKgWBymJlUQ5NQT4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=urzvTl7iRESKNAvhmbWOom+4z+CzmzMFU9KBQfAq/euJdAjULW7Me+WgOA7FQ6YH/0tXImKpPv1mafAqi/hWBKxgdXnMpSX+Rqdu29dyCoo/ONXXpyL+872SsXQJeH3SO7x4XYWEw0greRPhEhIvL2gtdxn9XARbsY07C+A3GGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N0f/4bNU; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N0f/4bNU"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e59dc7df64so17539777b3.1
        for <kvmarm@lists.linux.dev>; Thu, 07 Nov 2024 11:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731009394; x=1731614194; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zBP9cQn+CUeDWqPutci2y0fBryOwyk4gwuh+LOyRfGQ=;
        b=N0f/4bNUG9KI/jxgWY/WQP8oRa6PBFaRPNjA5Ckg+rgdNqMHp8nRb3BJog4eJVoRoy
         RyXVBZj14J0rFO7AX1sYCIdOFUdGd4YAw6RUDh0bc+FzOxfjvFYBaOeiWkTTVXPwoxyQ
         keRxkoTzZV7UPgcq8Z40kh3SjDW5LpeD3KG6x4kBmEEh85MzN8d4kOCP+jloOGF6Box4
         zoAKizyLjmLf5hzyPOFTD7MPQdNAi5AWWeb5KiJg7Z0K7ncwaxgKyf6bhpWZCsBvuhkg
         GEkS2UOkZ/9qIhPcwlV7ZQlHFIno5PFMmo765gYv62/MFQTL6FOHFPqndDqcB0hKHY9J
         NX4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731009394; x=1731614194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBP9cQn+CUeDWqPutci2y0fBryOwyk4gwuh+LOyRfGQ=;
        b=lDF8PMV44KBSwwSqLiqgEvSjdZx7yujxa4G7hGszENFkR/QgY8jEqsaaZeI9vT9HR0
         ai1j9+qdXv/jA4wx8VJqogm2+NRmFGvKNTFy8fVOuBPN/npRQ/aIT1BV5X+Eut3TRLf3
         6gGc9FcP+0quPXx/A7dai+R8dD1cGdo4ojCi+cugEPSfFjVp7h8ztjTs4PT7j20zmTDt
         QkqJR04Z4HU3PcayEclaSqhU3ECoVkjCvIllgXKTNxRK1HI2FrH5C1BKCBDyiR6mlAnI
         0jd6laP2hCDjIlrU1jnn2RnNQ5hNOrfTOOyY52GsZhq8kyJNYLQl7XBIWJQ55eP8Kf/x
         gxMg==
X-Forwarded-Encrypted: i=1; AJvYcCXXoAZC1A0G4ELsNGM5IN41DeP+dCUc+/8pwEWA/mgvXXTvE4UrP3pCUA8jiWNbAJpZ+isimhg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGSmsY9mErze/opSpcHU8qNKbBWBUHGH3o3Wpp72GQ9cf0sZaC
	+9spo2ktV0WumJpHHaSiVFMYegpAqTEbVZnyResag4FXb/tT6cBCBNgWZ09BYXEWeFXN2DLXz2G
	a2Q==
X-Google-Smtp-Source: AGHT+IHGhu8mNxNsq1le3Y88bQEMRwpMbJOW7Gcai6EHqyvmqmAaHws+50k8OfTLl4697j16Z9tv7t+ZxG8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a0d:ef05:0:b0:6ea:881b:b545 with SMTP id
 00721157ae682-6eade535166mr647b3.4.1731009394112; Thu, 07 Nov 2024 11:56:34
 -0800 (PST)
Date: Thu, 7 Nov 2024 11:56:32 -0800
In-Reply-To: <Zy0QFhFsICeNt8kF@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241107094000.70705-1-eric.auger@redhat.com> <20241107094000.70705-3-eric.auger@redhat.com>
 <Zyz_KGtoXt0gnMM8@google.com> <Zy0QFhFsICeNt8kF@linux.dev>
Message-ID: <Zy0bcM0m-N18gAZz@google.com>
Subject: Re: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, broonie@kernel.org, 
	maz@kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	joey.gouly@arm.com, shuah@kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 07, 2024, Oliver Upton wrote:
> On Thu, Nov 07, 2024 at 09:55:52AM -0800, Sean Christopherson wrote:
> > On Thu, Nov 07, 2024, Eric Auger wrote:
> > > In case a KVM_REQ_VM_DEAD request was sent to a VM, subsequent
> > > KVM ioctls will fail and cause test failure. This now happens
> > > with an aarch64 vgic test where the kvm_vm_free() fails. Let's
> > > add a new kvm_vm_dead_free() helper that does all the deallocation
> > > besides the KVM_SET_USER_MEMORY_REGION2 ioctl.
> > 
> > Please no.  I don't want to bleed the kvm->vm_dead behavior all over selftests.
> > The hack in __TEST_ASSERT_VM_VCPU_IOCTL() is there purely to provide users with
> > a more helpful error message, it is most definitely not intended to be an "official"
> > way to detect and react to the VM being dead.
> > 
> > IMO, tests that intentionally result in a dead VM should assert that subsequent
> > VM/vCPU ioctls return -EIO, and that's all.  Attempting to gracefully free
> > resources adds complexity and pollutes the core selftests APIs, with very little
> > benefit.
> 
> Encouraging tests to explicitly leak resources to fudge around assertions
> in the selftests library seems off to me.

I don't disagree, but I really, really don't want to add vm_dead().

> IMO, the better approach would be to provide a helper that gives the
> impression of freeing the VM but implicitly leaks it, paired with some
> reasoning for it.

Actually, duh.  There's no need to manually delete KVM memslots for *any* VM,
dead or alive.  Just skip that unconditionally when freeing the VM, and then the
vGIC test just needs to assert on -EIO instead -ENXIO/-EBUSY.

---
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 7 Nov 2024 11:39:59 -0800
Subject: [PATCH] KVM: selftests: Don't bother deleting memslots in KVM when
 freeing VMs

When freeing a VM, don't call into KVM to manually remove each memslot,
simply cleanup and free any userspace assets associated with the memory
region.  KVM is ultimately responsible for ensuring kernel resources are
freed when the VM is destroyed, deleting memslots one-by-one is
unnecessarily slow, and unless a test is already leaking the VM fd, the
VM will be destroyed when kvm_vm_release() is called.

Not deleting KVM's memslot also allows cleaning up dead VMs without having
to care whether or not the to-be-freed VM is dead or alive.

Reported-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6b3161a0990f..33fefeb3ca44 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -720,9 +720,6 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	rb_erase(&region->hva_node, &vm->regions.hva_tree);
 	hash_del(&region->slot_node);
 
-	region->region.memory_size = 0;
-	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
-
 	sparsebit_free(&region->unused_phy_pages);
 	sparsebit_free(&region->protected_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
@@ -1197,7 +1194,12 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
  */
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot)
 {
-	__vm_mem_region_delete(vm, memslot2region(vm, slot));
+	struct userspace_mem_region *region = memslot2region(vm, slot);
+
+	region->region.memory_size = 0;
+	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
+
+	__vm_mem_region_delete(vm, region);
 }
 
 void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,

base-commit: c88416ba074a8913cf6d61b789dd834bbca6681c
-- 


> > Marking a VM dead should be a _very_ rare event; it's not something that I think
> > we should encourage, i.e. we shouldn't make it easier to deal with.  Ideally,
> > use of kvm_vm_dead() should be limited to things like sev_vm_move_enc_context_from(),
> > where KVM needs to prever accessing the source VM to protect the host.  IMO, the
> > vGIC case and x86's enter_smm() are hacks.  E.g. I don't see any reason why the
> > enter_smm() case can't synthesize a triple fault.
> 
> The VGIC case is at least better than the alternative of slapping
> bandaids all over the shop to cope with a half-baked VM and ensure we
> tear it down correctly. Userspace is far up shit creek at the point the
> VM is marked as dead, so I don't see any value in hobbling along
> afterwards.

Again, I don't disagree, but I don't want to normalize shooting the VM on errors.
