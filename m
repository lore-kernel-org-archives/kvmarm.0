Received: from mta0.migadu.com (out-147.mta0.migadu.com [91.218.175.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CC8516177
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 13:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983961; cv=none; b=n7RQ+Wt4zDiyB45XDURPRd+DltUN0auQdXpsdT+y7LgProuYRecxAZ6q13gSyXJ7GogsAnXTuZZytqgvY4DdHHB9lMP17sT64O7qY88yGGIXDGOpgzKXc4ejMM9ydI+uTe6HptvIly5Dd71DP29jY7K1YKPo2phvIYGAHGrbqPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983961; c=relaxed/simple;
	bh=aTzHnXwYVJUGpYRSUlHI4kXeHhU4f+c16/CqGgZrLhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZaVq2/ZXwo5rFsTs199MYIHrDbBEG9dI65IQreZLj9r8rjQGSanu+tzo8oje8n3obXTIwabYFfmb0RTO5SbRwXWd5kyLYWKvUuSbW/pXm7Wn40NCcGyi4iCMdxFi45MxEfEB2k/VOs5JRGK7A6xxiVo1UkQvgIcJ0sTjN2fhpAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M/BY9o5p; arc=none smtp.client-ip=91.218.175.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M/BY9o5p"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=aTzHnXwYVJUGpYRSUlHI4kXeHhU4f+c16/CqGgZrLhs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791983950; v=1; x=1792588750;
 b=M/BY9o5pTZdwRgLG4GhWM1KJom92wOZpSxktJH4eAzRRVSSzTFxt9mMb27K5eceyEhMPsJ4+
 KgRzhpK1U9nWU9kJngNglvcc6+qPx9TVPGcT8vLtoj50EHgtFLftAFukER8qXTWIPctlpPkV38v
 CI6v0ldKQ8OMHA3YSoy7tTCA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 34c5f16cd57e26ce;
	Wed, 14 Oct 2026 13:19:10 +0000
X-Mizu-Trace-ID: 34c5f16cd57e26ce
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5bcf03d95b8so28635e87.0
        for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 06:19:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzwpkS49NP4Nv6axzohdQoMvSeLS2MffMwmKFL+yJA8NvczFojrjbhVsmIct8QlgoPxsUt4tWw=@lists.linux.dev
X-Gm-Message-State: AFq9FYLHIKzue99xaMILpXoCZ4MLm0Jpf387YK33vjkxgp5fWPzefcVm
	wDdqQuneTnuHp7Z6hV8BksrqUa4A1dCI7BEFyzVPCVFYimzFH3tLMXfb6NWd56zUZggf/o0XpMX
	TK1qx0HqGmrpAyQO1iThEmv62VLN5FidBb7yQuBu3
X-Received: by 2002:a05:6512:1352:b0:5bc:f0ab:1f39 with SMTP id
 2adb3069b0e04-5be35a3ccc9mr104769e87.2.1791983945579; Wed, 14 Oct 2026
 06:19:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260605153248.2412064-1-weilin.chang@arm.com> <20260605153248.2412064-2-weilin.chang@arm.com>
In-Reply-To: <20260605153248.2412064-2-weilin.chang@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 14 Oct 2026 14:18:29 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwK092o8YZjV0vzBDLSY=cesOvhqj39zDd1MF-toOVTwA@mail.gmail.com>
X-Gm-Features: AclHuK-D4V7-XOOYkcs71Ak9kbmSkq3X3DlhkeEjLZk_QZspZkb75DxTMMqKDzg
Message-ID: <CA+EHjTwK092o8YZjV0vzBDLSY=cesOvhqj39zDd1MF-toOVTwA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Replace memslot_is_logging() with kvm_slot_dirty_track_enabled()
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, Leo Soares Passos <Leo.Bras@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Wei-Lin,

On Fri, 05 Jun 2026 16:32:47 +0100, Wei-Lin Chang <weilin.chang@arm.com> wrote:
> When checking whether a memslot has dirty logging enabled, the
> KVM_MEM_LOG_DIRTY_PAGES flag is the source of truth. Previously we were
> using memslot_is_logging() which only tests dirty bitmap and did not
> consider dirty ring. This was not detected because
> KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP was introduced together with KVM
> arm64 dirty ring, and users need to enable it to ensure dirty
> information is not lost for the case of VGIC LPI/ITS table changes.

I ran into the same bug while testing the arm64 KVM_PRE_FAULT_MEMORY
series, and then found that you'd already fixed it.

It might be worth mentioning the impact in the commit message: with
the ring and no bitmap, a logged memslot still gets block mappings, so
guest writes to most of a block are never logged and a migration can
copy stale memory. That would also make the case for a Cc: stable.

> Note that memslot_is_logging() also treats a memslot as not logging if
> KVM_MEM_READONLY is set, hence a memslot with both dirty logging and
> read only would be seen as not logging for memslot_is_logging(), but
> logging for kvm_slot_dirty_track_enabled(). This allows a read only
> mapping of size > PAGE_SIZE to be built when memslot_is_logging() is
> used, leading to a better read performance compared to
> kvm_slot_dirty_track_enabled(). However memslots that have both
> KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY set do not really make
> sense as dirty logging is essentially nop for a read only memslot, so
> this shouldn't affect real workloads much.

FWIW, I'd go with Leo's suggestion of keeping the KVM_MEM_READONLY
check, so those memslots keep their block mappings.

[...]
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
[...]
> @@ -2084,7 +2079,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>          * and a write fault needs to collapse a block entry into a table.
>          */
>         memcache = get_mmu_memcache(s2fd->vcpu);
> -       if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
> +       if (!perm_fault || (kvm_slot_dirty_track_enabled(s2fd->memslot) &&
>                             kvm_is_write_fault(s2fd->vcpu))) {

FYI, this no longer applies to kvmarm/fixes or kvmarm/next, where the
condition now ends in memslot_is_logging() ||
is_protected_kvm_enabled().

I tested the series on v7.3-rc7 (with that conflict resolved) in QEMU,
with dirty_log_test changed to back the memslot with THP. In ring-only
mode it fails on the first iteration without the series and passes
with it. I'll send the test change later.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
