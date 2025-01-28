Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE1719CC05;
	Tue, 28 Jan 2025 10:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738060292; cv=none; b=X2Q6EkOJ6JqF0t2ySv/h3Lty+MAFzBFM/ldAkge3RABQ/Z23xlyAIONbYU5+S/Fi00YDLX8sNp/Aq4aKpuVzCnQoFAHrugec9Au8Sn3WxbnkWbzzPDhUDeF1tsEr0YBnzm7iwKEMaQl7GrWLzZej+WnemLBfe9FvHGbB6UGbCGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738060292; c=relaxed/simple;
	bh=H6SMlW4tY/dv7HZV8uwUnEiNFCo2HjcWfwj2mK+HPNg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=r9t1GHq+4uYaDWll0jPQD0FX9Bi9LXEvcQzDOl1tJvACdbw0MeXXfUuB2EaelmIF0ahmxmPGYVC5iZe2r/TzIcbEWOXKtUyDf5DtbDtypI+Ac3EJSiTCS117MX4TP04FF4Ldr2djOkXtjEeCMQLx7G1OyHnyAux5XvF5qSyAIB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j7XEAQDT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j7XEAQDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1EBC4CEE3;
	Tue, 28 Jan 2025 10:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738060292;
	bh=H6SMlW4tY/dv7HZV8uwUnEiNFCo2HjcWfwj2mK+HPNg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=j7XEAQDT/q4YR7UEVN2p/mLn9RtQkVY2foZWR9AwCE3nHgBuOJRF0tbfRs1y25VVy
	 SDi03wCHYZg87XJTCjIVLvPonP6CaRkNdXpR9So1+DbFDkjvEpJVtA7NI/wSYz1q2Z
	 lNk246Glj0e+W7JlFZbDXchAOCwvQpNSb9ybuzmjo0mNUf8bsXfZN0UXNmJhgt3Fns
	 4U8WEGVPEQpSV0oYr7sKxUc1Ptd8pj5V6gu5NwJDjS4DhxW/SG8hIJIUQcuZMyRBzX
	 zTvgPNc93F+ip+StPb1tZTBxEbgSv0MVQdMn8nHv64xIMmkhWxv2t4h/X2aI2hkAIP
	 DcIRzduyT3ieQ==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Peter Collingbourne <pcc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 5/7] KVM: arm64: MTE: Use stage-2 NoTagAccess memory
 attribute if supported
In-Reply-To: <Z4e04P1bQlFBDHo7@arm.com>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
 <20250110110023.2963795-6-aneesh.kumar@kernel.org>
 <Z4Fk58k8YptDkVgm@arm.com> <yq5amsfxtrlw.fsf@kernel.org>
 <Z4Vk5gTnd8o7VKWL@arm.com>
 <CAMn1gO4huP4D_1mFdC8FsmvHkaQn+hC02ULcfBuS30VDM9=9gA@mail.gmail.com>
 <Z4e04P1bQlFBDHo7@arm.com>
Date: Tue, 28 Jan 2025 16:01:18 +0530
Message-ID: <yq5afrl3cjrd.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Mon, Jan 13, 2025 at 12:47:54PM -0800, Peter Collingbourne wrote:
>> On Mon, Jan 13, 2025 at 11:09=E2=80=AFAM Catalin Marinas
>> <catalin.marinas@arm.com> wrote:
>> > On Sat, Jan 11, 2025 at 06:49:55PM +0530, Aneesh Kumar K.V wrote:
>> > > Catalin Marinas <catalin.marinas@arm.com> writes:
>> > > > On Fri, Jan 10, 2025 at 04:30:21PM +0530, Aneesh Kumar K.V (Arm) w=
rote:
>> > > >> Currently, the kernel won't start a guest if the MTE feature is e=
nabled
>> > >
>> > > ...
>> > >
>> > > >> @@ -2152,7 +2162,8 @@ int kvm_arch_prepare_memory_region(struct k=
vm *kvm,
>> > > >>            if (!vma)
>> > > >>                    break;
>> > > >>
>> > > >> -          if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
>> > > >> +          if (kvm_has_mte(kvm) &&
>> > > >> +              !kvm_has_mte_perm(kvm) && !kvm_vma_mte_allowed(vma=
)) {
>> > > >>                    ret =3D -EINVAL;
>> > > >>                    break;
>> > > >>            }
>> > > >
>> > > > I don't think we should change this, or at least not how it's done=
 above
>> > > > (Suzuki raised a related issue internally relaxing this for VM_PFN=
MAP).
>> > > >
>> > > > For standard memory slots, we want to reject them upfront rather t=
han
>> > > > deferring to the fault handler. An example here is file mmap() pas=
sed as
>> > > > standard RAM to the VM. It's an unnecessary change in behaviour IM=
HO.
>> > > > I'd only relax this for VM_PFNMAP mappings further down in this
>> > > > function (and move the VM_PFNMAP check above; see Suzuki's internal
>> > > > patch, unless he posted it publicly already).
>> > >
>> > > But we want to handle memslots backed by pagecache pages for virtio-=
shm
>> > > here (virtiofs dax use case).
>> >
>> > Ah, I forgot about this use case. So with virtiofs DAX, does a host pa=
ge
>> > cache page (host VMM mmap()) get mapped directly into the guest as a
>> > separate memory slot? In this case, the host vma would not have
>> > VM_MTE_ALLOWED set.
>> >
>> > > With MTE_PERM, we can essentially skip the
>> > > kvm_vma_mte_allowed(vma) check because we handle all types in the fa=
ult
>> > > handler.
>> >
>> > This was pretty much the early behaviour when we added KVM support for
>> > MTE, allow !VM_MTE_ALLOWED and trap them later. However, we disallowed
>> > VM_SHARED because of some non-trivial race. Commit d89585fbb308 ("KVM:
>> > arm64: unify the tests for VMAs in memslots when MTE is enabled")
>> > changed this behaviour and the VM_MTE_ALLOWED check happens upfront. A
>> > subsequent commit removed the VM_SHARED check.
>> >
>> > It's a minor ABI change but I'm trying to figure out why we needed this
>> > upfront check rather than simply dropping the VM_SHARED check. Adding
>> > Peter in case he remembers. I can't see any race if we simply skipped
>> > this check altogether, irrespective of FEAT_MTE_PERM.
>>=20
>> I don't see a problem with removing the upfront check. The reason I
>> kept the check was IIRC just that there was already a check there and
>> its logic needed to be adjusted for my VM_SHARED changes.
>
> Prior to commit d89585fbb308, kvm_arch_prepare_memory_region() only
> rejected a memory slot if VM_SHARED was set. This commit unified the
> checking with user_mem_abort(), with slots being rejected if
> (!VM_MTE_ALLOWED || VM_SHARED). A subsequent commit dropped the
> VM_SHARED check, so we ended up with memory slots being rejected only if
> !VM_MTE_ALLOWED (of course, if kvm_has_mte()). This wasn't the case
> before the VM_SHARED relaxation.
>
> So if you don't remember any strong reason for this change, I think we
> should go back to the original behaviour of deferring the VM_MTE_ALLOWED
> check to user_mem_abort() (and still permitting VM_SHARED).
>

Something as below?

From 466237a6f0a165152c157ab4a73f34c400cffe34 Mon Sep 17 00:00:00 2001
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Date: Tue, 28 Jan 2025 14:21:52 +0530
Subject: [PATCH] KVM: arm64: Drop mte_allowed check during memslot creation

Before commit d89585fbb308 ("KVM: arm64: unify the tests for VMAs in
memslots when MTE is enabled"), kvm_arch_prepare_memory_region() only
rejected a memory slot if VM_SHARED was set. This commit unified the
checking with user_mem_abort(), with slots being rejected if either
VM_MTE_ALLOWED is not set or VM_SHARED set. A subsequent commit
c911f0d46879 ("KVM: arm64: permit all VM_MTE_ALLOWED mappings with MTE
enabled") dropped the VM_SHARED check, so we ended up with memory slots
being rejected if VM_MTE_ALLOWED is not set. This wasn't the case before
the commit d89585fbb308. The rejection of the memory slot with VM_SHARED
set was done to avoid a race condition with the test/set of the
PG_mte_tagged flag. Before Commit d77e59a8fccd ("arm64: mte: Lock a page
for MTE tag initialization") the kernel avoided allowing MTE with shared
pages, thereby preventing two tasks sharing a page from setting up the
PG_mte_tagged flag racily.

Commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag
initialization") further updated the locking so that the kernel
allows VM_SHARED mapping with MTE. With this commit, we can enable
memslot creation with VM_SHARED VMA mapping.

This patch results in a minor tweak to the ABI. We now allow creating
memslots that don't have the VM_MTE_ALLOWED flag set. If the guest uses
such a memslot with Allocation Tags, the kernel will generate -EFAULT.
ie, instead of failing early, we now fail later during KVM_RUN.

This change is needed because, without it, users are not able to use MTE
with VFIO passthrough, as shown below (kvmtool VMM).

[  617.921030] vfio-pci 0000:01:00.0: resetting
[  618.024719] vfio-pci 0000:01:00.0: reset done
  Error: 0000:01:00.0: failed to register region with KVM
  Warning: [0abc:aced] Error activating emulation for BAR 0
  Error: 0000:01:00.0: failed to configure regions
  Warning: Failed init: vfio__init

  Fatal: Initialisation failed

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/kvm/mmu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 007dda958eab..610becd8574e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2146,11 +2146,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (!vma)
 			break;
=20
-		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
-			ret =3D -EINVAL;
-			break;
-		}
-
 		if (vma->vm_flags & VM_PFNMAP) {
 			/* IO region dirty page logging not allowed */
 			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
--=20
2.43.0


