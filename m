Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6695C3C345B
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645108; cv=none; b=COPz8/vSUmBtRpVl+xCxXZPFtjO5Z3V3EsV/JdRZq+X2XXJvyDxmjXuOKuEHtQ34J8s/4twolH+5wVoJpPjyEQAvNufo1lMQ0CQee5USPy4edMS/QYthXaVQjTv9xzzdFZqMSzucRwyXWqiYMIOuVapc1GO55OYgGey9NX9E4+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645108; c=relaxed/simple;
	bh=n4QKpHTlKIbKxoVyb8jomzE98FcpdhxCxXybOaeTddY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C12JrV5PIRQmQWbksmIE2Df0GG+9J//rj1Eix60qCXqrWT0HErfR6+bhbHvIYXAhZfZXb1w8qkn0dUMfsakPuLIE0EBZdHPbw+SHNmZa4mTctNY69DffXvsyLTbm/W+/rJOcOcAaI5bC5CA5jwBVwKRKrhmY/+EgXkVJKRjqjQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YhClDYmW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YhClDYmW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AB672C1C;
	Fri,  1 May 2026 07:18:20 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF50F3F7B4;
	Fri,  1 May 2026 07:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777645105; bh=n4QKpHTlKIbKxoVyb8jomzE98FcpdhxCxXybOaeTddY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YhClDYmWmp6O5MaEN5QwnO5JBVi0bDYByAXkKn7fiDuCzxz0ob/7DxW/wZ/xIYLCA
	 gkfwAy+hNWKVA8+B1KyQrqGix+V7kPyXloob1Ckrt+kuUQUF9cqYRo97BQpFH4JqxS
	 BESkBXabNRE0Q6XJjUxIEpPESEi0NcjJgVMHTsOU=
Date: Fri, 1 May 2026 15:18:16 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	mark.rutland@arm.com
Subject: Re: [PATCH] KVM: arm64: Handle permission faults with guest_memfd
Message-ID: <afS2KDp6zEo3zSvP@raptor>
References: <20260430132351.280766-1-alexandru.elisei@arm.com>
 <CA+EHjTwZ=yFx_NEyw5YEiGqCjsfM=QotHgsCUVQmWDr6cNKLZw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwZ=yFx_NEyw5YEiGqCjsfM=QotHgsCUVQmWDr6cNKLZw@mail.gmail.com>

Hi Fuad,

On Thu, Apr 30, 2026 at 03:48:21PM +0100, Fuad Tabba wrote:
> Hi Alexandru,
> 
> On Thu, 30 Apr 2026 at 14:24, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >
> > gmem_abort() calls kvm_pgtable_stage2_map() to make changes to stage 2. It
> > does this for both relaxing permissions on an existing mapping and to
> > install a missing mapping.
> >
> > kvm_pgtable_stage2_map() doesn't make changes to stage 2 if there is an
> > existing, valid entry and the new entry modifies only the permissions.
> > This is checked in:
> >
> > kvm_pgtable_stage2_map()
> >   stage2_map_walk_leaf()
> >      stage2_map_walker_try_leaf()
> >        stage2_pte_needs_update()
> >
> > and if only the permissions differ, kvm_pgtable_stage2_map() returns
> > -EAGAIN and KVM returns to the guest to replay the instruction. The
> > assumption is that a concurrent fault on a different VCPU already mapped
> > the faulting IPA, and replaying the instruction will either succeed, or
> > cause a permission fault, which should be handled with
> > kvm_pgtable_stage2_relax_perms().
> >
> > gmem_abort(), on a read or write fault on a system without DIC (instruction
> > cache invalidation required for data to instruction coherence), installs a
> > valid entry with read and write permissions, but without executable
> > permissions. On an execution fault on the same page, gmem_abort() attempts
> > to relax the permissions to allow execution, but calls
> > kvm_pgtable_stage2_map() to change the existing, valid, entry.
> > kvm_pgtable_stage2_map() returns -EAGAIN and KVM resumes execution from the
> > faulting instruction, which leads to an infinite loop of permission faults
> > on the same instruction.
> >
> > Allow the guest to make progress by using kvm_pgtable_stage2_relax_perms()
> > to relax permissions.
> >
> > Fixes: a7b57e099592 ("KVM: arm64: Handle guest_memfd-backed guest page faults")
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >
> > Lightly tested on an Orion O6 board, without pkvm, and without nested
> > virtualisation.
> >
> > Doesn't apply cleanly on top of a7b57e099592, I can send a patch for that if
> > needed.
> >
> >  arch/arm64/kvm/mmu.c | 24 +++++++++++++++++-------
> >  1 file changed, 17 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index d089c107d9b7..dff58de7703b 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1576,6 +1576,7 @@ struct kvm_s2_fault_desc {
> >  static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >  {
> >         bool write_fault, exec_fault;
> > +       bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
> >         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
> >         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> >         struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
> > @@ -1587,10 +1588,12 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >         gfn_t gfn;
> >         int ret;
> >
> > -       memcache = get_mmu_memcache(s2fd->vcpu);
> > -       ret = topup_mmu_memcache(s2fd->vcpu, memcache);
> > -       if (ret)
> > -               return ret;
> > +       if (!perm_fault) {
> > +               memcache = get_mmu_memcache(s2fd->vcpu);
> > +               ret = topup_mmu_memcache(s2fd->vcpu, memcache);
> > +               if (ret)
> > +                       return ret;
> > +       }
> 
> memcache is now uninitialized when perm_fault, and only read in the
> !perm_fault branch below. It's safe today, but initializing it to NULL
> would silence any defensive analyzer and keep things robust against
> future churn.

Sure, I'll initialise memcache to NULL.

> 
> >
> >         if (s2fd->nested)
> >                 gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
> > @@ -1631,9 +1634,16 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >                 goto out_unlock;
> >         }
> >
> > -       ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> > -                                                __pfn_to_phys(pfn), prot,
> > -                                                memcache, flags);
> > +       if (perm_fault) {
> > +               /* Preserve the software bits from the existing table entry. */
> > +               prot &= ~KVM_NV_GUEST_MAP_SZ;
> 
> Can you please phrase it the same way as the existing comment in
> user_mem_abort, as that phrasing more precisely describes the
> rationale? i.e.,

Of course.

> 
>    /*
>     * Drop the SW bits in favour of those stored in the
>     * PTE, which will be preserved.
>     */
> 
> > +               ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms(pgt, s2fd->fault_ipa,
> > +                                                               prot, flags));
> 
> nit: args wrapped inside KVM_PGT_FN() is inconsistent with the rest of
> the file (and with the else-branch immediately below). Every other
> call site uses name-only inside the macro. Both expand the same way,
> but it's better to stick to the convention.

This was a typo on my part, thanks for catching it.

> 
> > +       } else {
> > +               ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> > +                                                        __pfn_to_phys(pfn), prot,
> > +                                                        memcache, flags);
> > +       }
> >
> >  out_unlock:
> >         kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
> 
> With these fixed:
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks!

Alex
