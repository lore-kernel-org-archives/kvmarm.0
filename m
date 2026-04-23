Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78053A9619
	for <kvmarm@lists.linux.dev>; Thu, 23 Apr 2026 18:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776969286; cv=none; b=I/EJG4m4UMpVpsr6rvpgtRexVUEmMyhgjvgLWeS6nY6gUy+438469+12+P2Ll3iFuxgWJmDKKyVpkOoWjPff+wh6+3QUerSVSr/WPrVptbNQS0yNyHvQiGOT+4IT3o3BRjavDg8U0lTlpLILAk5yye6Qt3M0Z7Vs1vF7JpfTZkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776969286; c=relaxed/simple;
	bh=NVz1Kr0qE63FsLDj/oNYi6IFrc3n87HfsCTK8W+L2s8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W8z5ZhnwP8mT4Ar5W7PDHe0HoLfkqAhzvWdvr19Q/yQqXB7PrlmjgLT1k84yajw1a6nqukCJo3HQdrFiiX0a+bTd3P8f7xHK6mbjhC73d3LBiHii5hwyyOesqDNZz/Y8VzFBdkV8X/IjUfBzLERe6jBXQgw8bfCVIoanFeagBVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rFt0OqY5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rFt0OqY5"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f9aa52c92so7314306b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 23 Apr 2026 11:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776969283; x=1777574083; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NxrUD6qTbjo1W4xW1U0cuK75GKmXClrYS1Ro/7xiFY0=;
        b=rFt0OqY5AihKIW4uta6XW++c9SYfsF3k91vBbFDBamplaC9h8LrZ0vuE5a+wQW/MAP
         2HdVm4tz0t9cqOKAHZJv9M6zHweZj40RCiAhGpG3Raz+IeHY33BsrgErVBWWd/b+t50C
         8oTM1Ndt5+lmqkwmYe9bKBnGrBRfx9nIhkKwkfFQtYxc8V8en3Cr1DUtwme+jF91RA5T
         cdUuWE8R5+5B2OGe7O0NUTUCKArB0PkQlN5XoECjcLw0BXqaU6dZZ4chd1Y/mb7sQNOD
         +6JGcs1P8bzUlqQ++u6PYdwVnXCh5AzxCb+BAzGsZ6+HQsHGHm4nUWlfpI/oieZ2OuII
         oD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776969283; x=1777574083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NxrUD6qTbjo1W4xW1U0cuK75GKmXClrYS1Ro/7xiFY0=;
        b=p9NmRlPPAq8/0O5oOJTLsp2++1vbKHYl6IRzm5pW1ZKUGeeS3vWUX7FnO+otdnQ6VM
         vI8dCbHzN4y98Vy0wiJX9UxbQCIfnH9LYDPADa8n0I3jrXHuJ4Ac2n+NCWpadygCdaLg
         Lt5lb/mAb+2cGh9zJ3nl1Ubmz+wdkf+hUDhrIcuekyP4V8tMj08KrGaaMFGHMLhV+Zg+
         7QH3jbuvEej5VP/Q7hm8l+6KKAN3iyaosR9Emr7dTjVFmYOkRiLykN3uvfuYptYjLV9z
         sYwTpdmbSNC00s4kbCxb1bKR/0sCoGWwTeWBYDJ+aufNhJubALOsjGzbWI+H4GIgkzBO
         nRIw==
X-Forwarded-Encrypted: i=1; AFNElJ84AKrOz/PxUBSOAKZfg/M0UB8hWl/+pFcrXxj8QwhM8HoebsiH+B4C9QyKrcrqU42pmpStNKs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzikjByo90MiVGGOoyLKx7IKhZejFuZ3+9/k6Zpi+/fuMQRdhSG
	6JxAKGmW/OyT1hrZ5ptBNGDffAYeIwnHss2umc69fAGgI7+4WR/reNLNWgRyeqXXDJ19zuuGrJz
	9nTwTbg==
X-Received: from pfbif1.prod.google.com ([2002:a05:6a00:8b01:b0:82f:a396:2229])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3d16:b0:82a:79b8:2049
 with SMTP id d2e1a72fcca58-82f8c8c2a97mr30979563b3a.25.1776969282975; Thu, 23
 Apr 2026 11:34:42 -0700 (PDT)
Date: Thu, 23 Apr 2026 11:34:39 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <177696924512.540717.6991894985950292004.b4-ty@google.com>
Subject: Re: [PATCH v3 00/19] KVM: selftests: Use kernel-style integer and
 g[vp]a_t types
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 20 Apr 2026 14:19:45 -0700, Sean Christopherson wrote:
> David's series to renames types across all KVM selftests.  I'm going to apply
> this ~now in order to get it into -next ASAP.  Unless someone screams in the
> next few days, I'm going to send a pull request on Thursday, with the goal of
> getting this into -rc1 so that all architectures (and developers) can use the
> new types straightaway.
> 
> Fully tested on x86, and I verified a handful of tests generate identical
> code.  I tried to do the same for other architectures, but gcc at least doesn't
> seem to provide reproducible builds for other architectures.  E.g. on arm64 and
> LoongArch, a completely benign vaddr_t => gva_t rename would sometimes result
> in different offsets in the generated code.  But based on manual diffs from
> objdump, I'm fairly confident in the result.
> 
> [...]

Applied to kvm-x86 selftests_kernel_types (a few days ago, spaced on sending
"thanks").

[01/19] KVM: selftests: Use gva_t instead of vm_vaddr_t
        https://github.com/kvm-x86/linux/commit/5567fc9dcd7e
[02/19] KVM: selftests: Use gpa_t instead of vm_paddr_t
        https://github.com/kvm-x86/linux/commit/97dcda3fdce5
[03/19] KVM: selftests: Use gpa_t for GPAs in Hyper-V selftests
        https://github.com/kvm-x86/linux/commit/6d3494255ac0
[04/19] KVM: selftests: Use u64 instead of uint64_t
        https://github.com/kvm-x86/linux/commit/26f8453288d4
[05/19] KVM: selftests: Use s64 instead of int64_t
        https://github.com/kvm-x86/linux/commit/286e8903aed1
[06/19] KVM: selftests: Use u32 instead of uint32_t
        https://github.com/kvm-x86/linux/commit/0c3a8774692a
[07/19] KVM: selftests: Use s32 instead of int32_t
        https://github.com/kvm-x86/linux/commit/7b609187684d
[08/19] KVM: selftests: Use u16 instead of uint16_t
        https://github.com/kvm-x86/linux/commit/19d091492004
[09/19] KVM: selftests: Use s16 instead of int16_t
        https://github.com/kvm-x86/linux/commit/2540ebd60349
[10/19] KVM: selftests: Use u8 instead of uint8_t
        https://github.com/kvm-x86/linux/commit/6ec982b5a2c7
[11/19] KVM: selftests: Drop "vaddr_" from APIs that allocate memory for a given VM
        https://github.com/kvm-x86/linux/commit/85819fa0e3b9
[12/19] KVM: selftests: Rename vm_vaddr_unused_gap() => vm_unused_gva_gap()
        https://github.com/kvm-x86/linux/commit/48321f609a73
[13/19] KVM: selftests: Rename vm_vaddr_populate_bitmap() => vm_populate_gva_bitmap()
        https://github.com/kvm-x86/linux/commit/3fd995905b71
[14/19] KVM: selftests: Rename translate_to_host_paddr() => translate_hva_to_hpa()
        https://github.com/kvm-x86/linux/commit/4babae4ca10a
[15/19] KVM: selftests: Clarify that arm64's inject_uer() takes a host PA, not a guest PA
        https://github.com/kvm-x86/linux/commit/a662c4e03853
[16/19] KVM: selftests: Replace "vaddr" with "gva" throughout
        https://github.com/kvm-x86/linux/commit/014dfb7b9bf3
[17/19] KVM: selftests: Replace "u64 gpa" with "gpa_t" throughout
        https://github.com/kvm-x86/linux/commit/df079910f981
[18/19] KVM: selftests: Replace "u64 nested_paddr" with "gpa_t l2_gpa"
        https://github.com/kvm-x86/linux/commit/abc374191dc2
[19/19] KVM: selftests: Replace "paddr" with "gpa" throughout
        https://github.com/kvm-x86/linux/commit/dfd2a8b07c6c

--
https://github.com/kvm-x86/linux/tree/next
