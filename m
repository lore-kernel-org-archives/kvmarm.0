Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C04394EB0
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 14:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789394501; cv=none; b=ARMLw9uJqOK3nUvmsNEpicBxyCvWtRGKdeQxLzh9uXDx9ZikcJfnWDIxbxByUlYG69fszjETlhZqix5if46SV44UUAowYGST5TwImXF1AlyF+lPjQ0kSXg1ix3WDrOJPev1wVyHDRlyj0OkN6p1p8mwtuHbnqf3GkjOixRs/p1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789394501; c=relaxed/simple;
	bh=aXjrtqiXJoA/LX+vo9ztIrGq5juji/Jt2LOumdsvJdA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I4GoqSI/El+WCkhG2WkUXOk5uz1L831gPe3+GfAVmvJ+T50QeDiRewmhHAMGV2+S+4zaNFQAkNffyqJKc7KEssC3CXuNtI84UwAtAFgZvoZ5c6TGPNEv5hsLdnhvuZvWB6l7qy02+TmyVlI46oWIoIQz/337hDmmVwjN4CPyUfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fVykSPJd; arc=none smtp.client-ip=91.218.175.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fVykSPJd"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=aXjrtqiXJoA/LX+vo9ztIrGq5juji/Jt2LOumdsvJdA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789394496; v=1; x=1789999296;
 b=fVykSPJddqrG6m3pCmfdaAbO0aiteOb+PmvQgr5DrObbPol+wqHf5GtXj7MOdsim/fJaJwS0
 5QXpJ2wH8TvUZ0Lvk8slbbIe9jxMXU3qRhmE6IuMYPCQpDXpGJpp0ujGikwvLgzd0ySAHrRxopa
 nmumSMxY3p+1lmEfmNrIf3ec=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7c56a09e8806736b;
	Mon, 14 Sep 2026 14:01:36 +0000
X-Mizu-Trace-ID: 7c56a09e8806736b
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so8172e87.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:01:31 -0700 (PDT)
X-Gm-Message-State: AFuF++k2ttmXt+vwUFH7ZqaxDE3z4GTv12bNBCA2wKrI4K3OrVaTub6C
	dD0WAODfqELN1Ct/EuW7LBqeQx1SoOoApzHq+hmx46ychZwrXeAYIGQoQEs/xfOe0fGthru1PaB
	6vMwAHfMtRilmByvqhHXuqn/61XLgEkrwsnEoBsv7
X-Received: by 2002:a05:6512:118a:b0:5b6:4ad:d6ba with SMTP id
 2adb3069b0e04-5b8af7bc5c0mr67742e87.15.1789394490822; Mon, 14 Sep 2026
 07:01:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914113338.159227-1-fuad.tabba@linux.dev> <20260914113338.159227-4-fuad.tabba@linux.dev>
 <20260914130152.F0D5F1F000FF@smtp.kernel.org>
In-Reply-To: <20260914130152.F0D5F1F000FF@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 15:00:54 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzHZTdjKUucBvZKDbxHAcnOHMBZxJRevA+GiWQDP83pOQ@mail.gmail.com>
X-Gm-Features: AcwNN1XihQ6L_5NZ9k6Ku9xDFQszoCROVzbsUjq5p0JBwaP6L9c0nu0dTTIBf6E
Message-ID: <CA+EHjTzHZTdjKUucBvZKDbxHAcnOHMBZxJRevA+GiWQDP83pOQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/18] KVM: arm64: Pin the host vCPU before adjusting
 its PC under pKVM
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Sep 2026 at 14:01, <sashiko-bot@kernel.org> wrote:
[...]
> If a userspace process creates a VM and a memory slot, and then immediately
> deletes it via KVM_SET_USER_MEMORY_REGION with a zero memory size before
> the first KVM_RUN, this triggers kvm_arch_flush_shadow_memslot().
>
> This unconditionally calls kvm_tlb_flush_vmid_range(), which issues an HVC
> call that ends up in handle___kvm_tlb_flush_vmid_range():

With pKVM enabled that path doesn't get there.

[...]
> Since this is the exact same sequence described in the commit message (a host
> pointer unmapped at EL2 being dereferenced before the first run), should we
> also pin the mmu pointer around these TLB flush operations?

The handlers are unvalidated, but under pKVM the host owns no guest
stage-2, so none of the kvm_s2_mmu hypercalls has a valid caller
there. Rather than pin, I'll send a separate patch that rejects them
when protected mode is enabled.

Cheers,
/fuad
