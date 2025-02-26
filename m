Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453B9220683;
	Wed, 26 Feb 2025 16:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740588510; cv=none; b=VK/RWkrzyxuvJRdKzFgdf6fDcBS0PT/0LSaBgceiDDQ8Qpb+mEjkydDqeBtGf8zth4EgC4SIGBITQ3NggZCPltCodc9LyzKrl+mn8eRBK10TvxCJd+Xk5EuLg4iTw5HX50YmRt3bI41vzE8NOIquF+WsAsYgzshTXvGX0YwbiNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740588510; c=relaxed/simple;
	bh=V0eP11ys4UBKYIyVMcIalsuc1S5/rdawoXtavRMVxbM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Qv8BlkLOb0ZftI0Ci+du3is/QsEVLwsF0VbnEKBpXP+v3+oeWnWZh0sApIqRQF4ovZiENIv3RReAvmG2wSjeU9sS5GmW4lA45YfVlNxBX5UB/Ru357azQSPNdhS86EVaNRw+yzTzcbI/SQW4MFzGaPmSIhIbowdb5yVn0uk2jQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCdE1u/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCdE1u/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B430C4CEE4;
	Wed, 26 Feb 2025 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740588509;
	bh=V0eP11ys4UBKYIyVMcIalsuc1S5/rdawoXtavRMVxbM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=iCdE1u/srDnmbqcyqDr0YGZIETy/BcVLfqnaDFDiU4YHsBTfAlTZAZMCgKqhrZU5G
	 27NcKpuZp5El+JeuWaltK7Nra2rWzKQyV6KGA+tkhLs+EMA/gqZ27EoiK9xozIfo/z
	 ZRb9iqvGFPHcC8BziEzCHO7vN1r0zQsBlXHkWCleYRNcI4NquYihoX25X4mqPFund4
	 0RZrbqSI0MYF8XEGzXzOZkq6osEujIoaZpr79C9U4Q/wJv/sVleC/I+UzoFhJiaRce
	 DSc+qOEPzTweP1iV6OsIOINf0AL3Qr/5atJYGQbrP9v5j8T/ZIBWnaqCDFlyF26Ra3
	 ZH0fCN0sDb7+Q==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH] KVM: arm64: Drop mte_allowed check during memslot creation
In-Reply-To: <Z786ODqxlYNpj40l@arm.com>
References: <20250224093938.3934386-1-aneesh.kumar@kernel.org>
 <Z7xSfVME4z2ComUm@arm.com> <86ldtvr0nl.wl-maz@kernel.org>
 <Z7yElHKrJGn8XuPS@arm.com> <86jz9fqtbk.wl-maz@kernel.org>
 <yq5aseo3gund.fsf@kernel.org> <86ikozqmsl.wl-maz@kernel.org>
 <yq5a8qptauyl.fsf@kernel.org> <Z786ODqxlYNpj40l@arm.com>
Date: Wed, 26 Feb 2025 22:18:21 +0530
Message-ID: <yq5a1pvkbqju.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Wed, Feb 26, 2025 at 03:28:26PM +0530, Aneesh Kumar K.V wrote:
>> Marc Zyngier <maz@kernel.org> writes:
>> > On Mon, 24 Feb 2025 16:44:06 +0000,
>> > Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
>> >> >> On Mon, Feb 24, 2025 at 12:24:14PM +0000, Marc Zyngier wrote:
>> >> >> > > On Mon, Feb 24, 2025 at 03:09:38PM +0530, Aneesh Kumar K.V (Ar=
m) wrote:
>> >> >> > > > This change is needed because, without it, users are not abl=
e to use MTE
>> >> >> > > > with VFIO passthrough (currently the mapping is either Devic=
e or
>> >> >> > > > NonCacheable for which tag access check is not applied.), as=
 shown
>> >> >> > > > below (kvmtool VMM).
> [...]
>> >> >> > My other concern is that this gives pretty poor consistency to t=
he
>> >> >> > guest, which cannot know what can be tagged and what cannot, and
>> >> >> > breaks a guarantee that the guest should be able to rely on.
> [...]
>> >> What if we trigger a memory fault exit with the TAGACCESS flag, allow=
ing
>> >> the VMM to use the GPA to retrieve additional details and print extra
>> >> information to aid in analysis? BTW, we will do this on the first fau=
lt
>> >> in cacheable, non-tagged memory even if there is no tagaccess in that
>> >> region. This can be further improved using the NoTagAccess series I
>> >> posted earlier, which ensures the memory fault exit occurs only on
>> >> actual tag access
>> >>=20
>> >> Something like below?
>> >
>> > Something like that, only with:
>> >
>> > - a capability informing userspace of this behaviour
>> >
>> > - a per-VM (or per-VMA) flag as a buy-in for that behaviour
>>=20
>> If we=E2=80=99re looking for a capability based control, could we tie th=
at up to
>> FEAT_MTE_PERM? That=E2=80=99s what I did here:
>>=20
>> https://lore.kernel.org/all/20250110110023.2963795-1-aneesh.kumar@kernel=
.org
>>=20
>> That patch set also addresses the issue mentioned here. Let me know if
>> you think this is a better approach
>
> From the patch linked above:
>
> | @@ -2152,7 +2162,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kv=
m,
> |  		if (!vma)
> |  			break;
> |=20
> | -		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
> | +		if (kvm_has_mte(kvm) &&
> | +		    !kvm_has_mte_perm(kvm) && !kvm_vma_mte_allowed(vma)) {
> |  			ret =3D -EINVAL;
> |  			break;
> |  		}
>
> we also have the same ABI change every time FEAT_MTE_PERM is present.
> TBH, I'd rather have it from the start as per the patch in this thread,
> irrespective of FEAT_MTE_PERM. I'm fine, however, with better exit to
> VMM information though.
>

The patch also does:

#define kvm_has_mte_perm(kvm)					\
	(system_supports_notagaccess() &&				\
	 test_bit(KVM_ARCH_FLAG_MTE_PERM_ENABLED, &(kvm)->arch.flags))


That is it depends on userspace to drive the behavior and also relies on the
FEAT_MTE_PERM hardware feature. I was considering whether, if we're
introducing this capability, should we also include FEAT_MTE_PERM? since
adding FEAT_MTE_PERM would also require a capability to handle VM
migration

>
> If we don't want to confuse the VMMs, we could skip the
> kvm_vma_mte_allowed() check only for VM_ALLOW_ANY_UNCACHED and
> VM_PFNMAP vmas, maybe the latter only with FEAT_MTE_PERM. I don't think
> the VMM would get it wrong here since a VFIO mmap() would not support
> MTE anyway.

ok.

-aneesh
