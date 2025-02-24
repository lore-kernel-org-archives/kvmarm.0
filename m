Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C622638AC;
	Mon, 24 Feb 2025 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740415455; cv=none; b=d4P7G8S+3mG0WHlwzAKi4N2UqsSa25LNlvuSTsLczwt4wZwYAIw4+Yi2ot4fVY5swKiFAoGN1/Si0qyj+RejRMJr2ExDkQRJ0P2AYVSbhBEjWS9ANedPlf5saOb/lZ4MbQSA6bNPUXasvHKoC5NTnApspbjrWPvPmeTmeuvWpBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740415455; c=relaxed/simple;
	bh=4vKvW2vFq+jrpSt/7ZJtCDqcqBjO57UWmfG8VBjnp4w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AH1ia3RaKYwNbSu9c+hZijURZlpYUwyayZbofZcdzw1CmpkUVrTPk5aiYGSyYmTzk0Inh054oCpOxQ7Q1J6D/ZjyMmUz1ED2AbWPxAfew6LumiBEoj2WH+TRebu5a3wlurogmzAkczRxhNNyZhtv6x49ij82c50N/tGr5hh+Loc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZ7jqDjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZ7jqDjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C53C4CEDD;
	Mon, 24 Feb 2025 16:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740415454;
	bh=4vKvW2vFq+jrpSt/7ZJtCDqcqBjO57UWmfG8VBjnp4w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=MZ7jqDjMd3WvUU1/RcIHisfmhUcs1edC2t626orE53nxLw28kguAHrLHsvodaRhs2
	 E/8lRSn420GmHzSRZNH8rpOrg2+19BOFGjArEsgvuAlzhJlNq6fvSDnAM93RFETdPS
	 JGGG+aYy1RdGW0138Zygtad/aB9dr/F77w46aDoK3tqRm6uiJbuxqstoD9rXmzeFqX
	 k92cfA0rs6YofrMmEYvpq6mI/qRknhOZgrgM9W7u/X/+WZ0CnaCe8JoDsoULb3kjO3
	 qsrNsUQFv016c8/YcIwbik1nxzKMF0JqjDRvQdvE2R4PveKGKy9pi8J2lxP2qk5GTZ
	 CHtaBmEQr6JLQ==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH] KVM: arm64: Drop mte_allowed check during memslot creation
In-Reply-To: <86jz9fqtbk.wl-maz@kernel.org>
References: <20250224093938.3934386-1-aneesh.kumar@kernel.org>
 <Z7xSfVME4z2ComUm@arm.com> <86ldtvr0nl.wl-maz@kernel.org>
 <Z7yElHKrJGn8XuPS@arm.com> <86jz9fqtbk.wl-maz@kernel.org>
Date: Mon, 24 Feb 2025 22:14:06 +0530
Message-ID: <yq5aseo3gund.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Marc Zyngier <maz@kernel.org> writes:

> On Mon, 24 Feb 2025 14:39:16 +0000,
> Catalin Marinas <catalin.marinas@arm.com> wrote:
>>
>> On Mon, Feb 24, 2025 at 12:24:14PM +0000, Marc Zyngier wrote:
>> > On Mon, 24 Feb 2025 11:05:33 +0000,
>> > Catalin Marinas <catalin.marinas@arm.com> wrote:
>> > > On Mon, Feb 24, 2025 at 03:09:38PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> > > > This change is needed because, without it, users are not able to use MTE
>> > > > with VFIO passthrough (currently the mapping is either Device or
>> > > > NonCacheable for which tag access check is not applied.), as shown
>> > > > below (kvmtool VMM).
>> > >
>> > > Another nit: "users are not able to user VFIO passthrough when MTE is
>> > > enabled". At a first read, the above sounded to me like one wants to
>> > > enable MTE for VFIO passthrough mappings.
>> >
>> > What the commit message doesn't spell out is how MTE and VFIO are
>> > interacting here. I also don't understand the reference to Device or
>> > NC memory here.
>>
>> I guess it's saying that the guest cannot turn MTE on (Normal Tagged)
>> for these ranges anyway since Stage 2 is Device or Normal NC. So we
>> don't break any use-case specific to VFIO.
>>
>> > Isn't the issue that DMA doesn't check/update tags, and therefore it
>> > makes little sense to prevent non-tagged memory being associated with
>> > a memslot?
>>
>> The issue is that some MMIO memory range that does not support MTE
>> (well, all MMIO) could be mapped by the guest as Normal Tagged and we
>> have no clue what the hardware does as tag accesses, hence we currently
>> prevent it altogether. It's not about DMA.
>>
>> This patch still prevents such MMIO+MTE mappings but moves the decision
>> to user_mem_abort() and it's slightly more relaxed - only rejecting it
>> if !VM_MTE_ALLOWED _and_ the Stage 2 is cacheable. The side-effect is
>> that it allows device assignment into the guest since Stage 2 is not
>> Normal Cacheable (at least for now, we have some patches Ankit but they
>> handle the MTE case).
>
> The other side effect is that it also allows non-tagged cacheable
> memory to be given to the MTE-enabled guest, and the guest has no way
> to distinguish between what is tagged and what's not.
>
>>
>> > My other concern is that this gives pretty poor consistency to the
>> > guest, which cannot know what can be tagged and what cannot, and
>> > breaks a guarantee that the guest should be able to rely on.
>>
>> The guest should not set Normal Tagged on anything other than what it
>> gets as standard RAM. We are not changing this here. KVM than needs to
>> prevent a broken/malicious guest from setting MTE on other (physical)
>> ranges that don't support MTE. Currently it can only do this by forcing
>> Device or Normal NC (or disable MTE altogether). Later we'll add
>> FEAT_MTE_PERM to permit Stage 2 Cacheable but trap on tag accesses.
>>
>> The ABI change is just for the VMM, the guest shouldn't be aware as
>> long as it sticks to the typical recommendations for MTE - only enable
>> on standard RAM.
>
> See above. You fall into the same trap with standard memory, since you
> now allow userspace to mix things at will, and only realise something
> has gone wrong on access (and -EFAULT is not very useful).
>
>>
>> Does any VMM rely on the memory slot being rejected on registration if
>> it does not support MTE? After this change, we'd get an exit to the VMM
>> on guest access with MTE turned on (even if it's not mapped as such at
>> Stage 1).
>
> I really don't know what userspace expects w.r.t. mixing tagged and
> non-tagged memory. But I don't expect anything good to come out of it,
> given that we provide zero information about the fault context.
>
> Honestly, if we are going to change this, then let's make sure we give
> enough information for userspace to go and fix the mess. Not just "it
> all went wrong".
>

What if we trigger a memory fault exit with the TAGACCESS flag, allowing
the VMM to use the GPA to retrieve additional details and print extra
information to aid in analysis? BTW, we will do this on the first fault
in cacheable, non-tagged memory even if there is no tagaccess in that
region. This can be further improved using the NoTagAccess series I
posted earlier, which ensures the memory fault exit occurs only on
actual tag access

Something like below?

modified   Documentation/virt/kvm/api.rst
@@ -7121,6 +7121,9 @@ describes properties of the faulting access that are likely pertinent:
  - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
    on a private memory access.  When clear, indicates the fault occurred on a
    shared access.
+ - KVM_MEMORY_EXIT_FLAG_TAGACCESS - When set, indicates the memory fault
+   occurred due to allocation tag access on a memory region that doesn't support
+   allocation tags.
 
 Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that it
 accompanies a return code of '-1', not '0'!  errno will always be set to EFAULT
modified   arch/arm64/kvm/mmu.c
@@ -1695,6 +1695,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
+			kvm_prepare_tagaccess_exit(vcpu, gfn << PAGE_SHIFT, PAGE_SIZE);
 			ret = -EFAULT;
 			goto out_unlock;
 		}
modified   include/linux/kvm_host.h
@@ -2489,6 +2489,16 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline void kvm_prepare_tagaccess_exit(struct kvm_vcpu *vcpu,
+					      gpa_t gpa, gpa_t size)
+{
+	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
+	vcpu->run->memory_fault.flags = KVM_MEMORY_EXIT_FLAG_TAGACCESS;
+	vcpu->run->memory_fault.gpa = gpa;
+	vcpu->run->memory_fault.size = size;
+}
+
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
modified   include/uapi/linux/kvm.h
@@ -442,6 +442,7 @@ struct kvm_run {
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+#define KVM_MEMORY_EXIT_FLAG_TAGACCESS	(1ULL << 4)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
