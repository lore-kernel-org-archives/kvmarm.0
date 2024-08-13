Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A1019D07B
	for <kvmarm@lists.linux.dev>; Tue, 13 Aug 2024 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723559219; cv=none; b=DPdFjxwELKfxBa3jDLzR/e0A//DAt63wY6Y8qXeISExViO7WcITwZwzoxCJU3nmJi2NsfBncmU5uGImCCH4eKLZsl47kzFaBfzalDWmGmuqTJp1xbSIsEop+mK+1ZZ0tO3vdumLyp+bePgU0K2AioG8FUtyJlfhYJRR1s98VD7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723559219; c=relaxed/simple;
	bh=nDFtrRLCiIpry9mS1jdG2ZuIuLH24n/ueW+EVQCN18s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R8I0vphviPUjX3T71+RP5sPFJOp7tG/dVwxf36rpDVNq3Rn5ntR0xRI7qMCRakmRKEakM521DNHEZciet0AVFKkxzzjr1mvz4B0Y3BdwceriLO7vLw9fzjmMq6stPs035KMTULVK7Gs029hr1FNNSkh4HfWfI03Tp2Qn9z0hz3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BkI0Jkir; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BkI0Jkir"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6886cd07673so129133917b3.3
        for <kvmarm@lists.linux.dev>; Tue, 13 Aug 2024 07:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723559217; x=1724164017; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nlePOXAg16VujwWpQo53FC8BTqwskF/Ge2QXUD/85QE=;
        b=BkI0JkiraL7hnqosr82uRktwFJ7vkweL4xGO6dAw4eIYPYpR4Xh2VJcojbeW5xd6ey
         E/f5LIbegNI74VCZ3oovTOoQTR0TFS/H494AuC2H3xzU6hKfs1O6z0s/bWoOEgrDhanM
         CaPmx7yJjbgPBkTwuFNKelh+1o3tEAnJhPqPUd2BKkzthLqG6bcE9PAcK8ns1CSsXBSP
         w5QtQ1LRa+m4W5Hmx+fdWPcOSM3jJl4AMLp4OCPX1hwqi1jZoaaXjEqa6uyITYEpIzN4
         kh5OrPzbO1oG+B8FBRHeW8PJFObd6IUMzKGN3sPzKsl1ChsLqfVWindywAxIlLyfeNFJ
         kxfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723559217; x=1724164017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nlePOXAg16VujwWpQo53FC8BTqwskF/Ge2QXUD/85QE=;
        b=F2C4AFm8CVulpgTzttrcveGCOSyaA8ZkPODWg29Va7xHFGzpYCJL8434OZ/mexCHLs
         9qVZYpIQqv+Hx77gOAt5j9SCxt2Spm312mGRZaCFubdJXlqFceCdMnIZ1FcBpe460eAk
         ijxEK+FA+Vflz1ti239RCBScm7hXYgpJrIo2IY4n0LSXMjaLR8+lG13NHVw8jQ2574iH
         O3bFEPUB/2vPyiFIYUaJMj0aGUbFhKs18RIBrYp7QgYlVzv5dpG5/xMbmOpt9JUlA/n3
         bxJjl8fQPrsjnWDh483HncUoDU2rFwUvMLDEab/jCWy9jy14kmAuk0JbjPcv/uO89336
         TCQw==
X-Forwarded-Encrypted: i=1; AJvYcCWIbvKVx5SQ+siglGZuvC7+Ld1Jorfgi7Y7PMWCZk2DyNqdI0FrKHV6s+ksKudfq0l8UVugWlhFk5fqS+1CAsTrFDjSHkFO
X-Gm-Message-State: AOJu0Yzz2GHPiVhR55NGawcunD1y/jYxL44zcWiqgoJYR8R9o2Ywu/o1
	906wgwfOl+0q3ZcT90voPUbxLc8e8NwUvemgo01ic+VPxdNazVIwvU7iULNojEPAjGm1Wa74FqE
	h7w==
X-Google-Smtp-Source: AGHT+IEEvTWXYJINBxGMayHtOBEQqp7u1QCGe3ozNbbkvySjfSWo9grl4aqe1MPeA+og7VSh05yZ5yELEz4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:185:b0:e03:2f8e:9d81 with SMTP id
 3f1490d57ef6-e113c909013mr7713276.0.1723559217266; Tue, 13 Aug 2024 07:26:57
 -0700 (PDT)
Date: Tue, 13 Aug 2024 07:26:55 -0700
In-Reply-To: <yq5aikw6ji14.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com> <20240809205158.1340255-4-amoorthy@google.com>
 <yq5aikw6ji14.fsf@kernel.org>
Message-ID: <ZrtskXJ6jH90pqB2@google.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Perform memory fault exits when
 stage-2 handler EFAULTs
From: Sean Christopherson <seanjc@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anish Moorthy <amoorthy@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 12, 2024, Aneesh Kumar K.V wrote:
> Anish Moorthy <amoorthy@google.com> writes:
> 
> > Right now userspace just gets a bare EFAULT when the stage-2 fault
> > handler fails to fault in the relevant page. Set up a
> > KVM_EXIT_MEMORY_FAULT whenever this happens, which at the very least
> > eases debugging and might also let userspace decide on/take some
> > specific action other than crashing the VM.
> >
> > In some cases, user_mem_abort() EFAULTs before the size of the fault is
> > calculated: return 0 in these cases to indicate that the fault is of
> > unknown size.
> >
> 
> VMMs are now converting private memory to shared or vice-versa on vcpu
> exit due to memory fault. This change will require VMM track each page's
> private/shared state so that they can now handle an exit fault on a
> shared memory where the fault happened due to reasons other than
> conversion.

I don't see how filling kvm_run.memory_fault in more locations changes anything.
The userspace exits are inherently racy, e.g. userspace may have already converted
the page to the appropriate state, thus making KVM's exit spurious.  So either
the VMM already tracks state, or the VMM blindly converts to shared/private.

> Should we make it easy by adding additional flag bits to
> indicate the fault was due to attribute and access type mismatch?

Like above, describing _why_ an exit occurred is problematic when an exit races
with a "fix" from userspace.  It's also problematic when there are multiple
possible faults, e.g. if the guest attempts to write to private memory, but
userspace has the memory mapped as read-only, shared (contrived, but possible).
Describing only the fault that KVM's see means the vCPU will encounter multiple
faults, and userspace will end up getting multiple exits

Instead, KVM should describe the access that led to the fault, as planned in the
original series[1][2].  Userpace can then get the page into the correct state
straightaway, or take punitive action if the guest is misbehaving.

	if (is_write)
		vcpu->run->memory_fault.flags |= KVM_MEMORY_FAULT_FLAG_WRITE;
	else if (is_exec)
		vcpu->run->memory_fault.flags |= KVM_MEMORY_FAULT_FLAG_EXEC;
	else
		vcpu->run->memory_fault.flags |= KVM_MEMORY_FAULT_FLAG_READ;

That said, I'm a little hesitant to capture RWX information without a use case,
mainly because it will require a new capability for userspace to be able to rely
on the information.  In hindsight, it probably would have been better to capture
RWX information in the initial implementation.  Doh.

[1] https://lore.kernel.org/all/ZIn6VQSebTRN1jtX@google.com
[2] https://lore.kernel.org/all/ZR4N8cwzTMDanPUY@google.com
