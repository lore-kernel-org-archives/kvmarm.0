Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ABE2931DD
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 19:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057320; cv=none; b=d1JGKcjphSOdnYyhrpXH7UT+/voLwgdO7RPunvzr40+n9pJChUmwATcm1vAkH0GxftvnzZdoh5MBJeH4NHTwzFsJApyBYAke8DjO2ipA41Jccj4IQGgT8gJCCUgM9dYvx1jujOvx+wx5/D4C/4f3m6gbQXZc0c7DH/zaRbD+DTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057320; c=relaxed/simple;
	bh=omY+XeqIxQR3XGclZjHyVvEQfVAPStHcPBHt1VCngx4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o6oaTMNsw1BLCsZgdO0Crq4smFC0ZMawH/Y6a48kJ0kiqaNiq7/FkYcuwcIrnJd16t0rATOxvyk8K4npDPf/ullpGTdEne2vQCBGIXHK1tzand/O8M+mOGWyQdW9MoM5q0mTC9/7Qlypw5vnRn7WHLCyvkNE7M1xg3UO9aU4uSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gG9GInTq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gG9GInTq"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-848568a6f62so8260757b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 12:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784057319; x=1784662119; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EBGhEX4vBKM8MPYzbmWcF5BLvWSJh5ejL+Gu8q+yPyk=;
        b=gG9GInTq0tr8WwoOhE/ISXsnGXaoSbKMHy5Par1OJnxN2+3ZsX2QPqpFqoHKOauup+
         HixsXp6t40WdYZDYYmONUPvEqcZQPdEsDs1d3Ee96osoXe6dFEO22BcFjQjIKGjgGmc0
         CDb8x+IQ17STSxDqK+wPr8hwihlLc2TXce8FBvN9KzoujA8PjSFIeMgPr3zS0tLrkPqk
         +l5YNu1WHpKESMdD7tX+/MVTOokVT0dUjc5AjSn6n5bcFBZRLwdEN2U7W8TC4MKUQqtA
         Vw4XS0ENsfDBK+PXWrUr4VegPa4JDVlkEr7v7ANTp+bozNJkibCbE9/APrz1Ij4ebKnT
         dm4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784057319; x=1784662119;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EBGhEX4vBKM8MPYzbmWcF5BLvWSJh5ejL+Gu8q+yPyk=;
        b=Bmc48O4nqWTpfs83nb6Iaof9ma9BXduiwrv+ONh4l/LevMPzjQQRYm2vDevtM2amQK
         jh1JqLKZrXSByjFzCF5b/dfq2VJ9V9a3TInIBCfCI8pV35IX1oa38DQdl1gO8hHpVN0F
         CXk/f5NnXTm2+XjW3hT+KsI5lwScFAbbsdNWSbPgYZKbzcEa81ie5J//2hgG3GrWq1Oo
         4ul7DtPM0gAungI028fmlQ+PVLBx+ns0PQ4e/QGWichkVnE1GLDHAz8a5ye2vGG4Cl0l
         SXRkwPQOhLe7gFpU6nRVqC6jtgfoUkC0v41XHV1fxunFBaHaYcgwntfXKHI/CUlwyOS9
         qqqw==
X-Forwarded-Encrypted: i=1; AHgh+RplqNs3VoikmZgQr744Fz6Iq/RNj/dVz5JjT7geMyR8g8aadNFlZd/e7pdou1c9zEjvc+r3F8U=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmuW1SUgD/E6qZos/BhllXHaMdFPnMlB2ZPwlQLuBD09rwBGiC
	0BpqXKJH7OwaXWteXCtY0cN04zQFxyX1pjqWX+oxr3GZMz4L1i+fsImeNn+ccRC7u3oMGipSo7E
	7alhyWg==
X-Received: from pfbfo5.prod.google.com ([2002:a05:6a00:6005:b0:848:40f5:a538])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c95:b0:848:3fe2:c88b
 with SMTP id d2e1a72fcca58-84a554fa556mr3829342b3a.6.1784057318776; Tue, 14
 Jul 2026 12:28:38 -0700 (PDT)
Date: Tue, 14 Jul 2026 11:41:17 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <178405411600.3133617.3225227983277758474.b4-ty@google.com>
Subject: Re: [PATCH v8 00/20] KVM: selftests: Add eventfd+VFIO IRQ test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 26 Jun 2026 14:35:13 -0700, Sean Christopherson wrote:
> David and Josh's series to add a selftest for verifying interrupt delivery
> via eventfd (via KVM_IRQFD), and also from a real device, wired up via VFIO.
> 
> Gory details in the patches, and in the v5 cover letter.
> 
> v8:
>  - Explicitly include <time.h>. [Sashiko]
>  - Use iova_allocator instea of hardcoding the IOVA. [Sashiko, David]
>  - Add a comment explaining why DMA needs to be allocated. [David]
>  - Probe /dev/vfio/vfio, not /dev/vfio. [Sashiko, David]
> 
> [...]

Applied to kvm-x86 irq_test, thanks!

[01/20] KVM: selftests: Build and link selftests/vfio/lib into KVM selftests
        https://github.com/kvm-x86/linux/commit/a262fc49e0aa
[02/20] KVM: selftests: Add macros to read/write+sync to/from guest memory
        https://github.com/kvm-x86/linux/commit/ac050f2adcdf
[03/20] KVM: selftests: Rename guest_rng to kvm_rng
        https://github.com/kvm-x86/linux/commit/e0bd29eddf7e
[04/20] KVM: selftests: Initialize the default/global pRNG during kvm_selftest_init()
        https://github.com/kvm-x86/linux/commit/bae85cd758fe
[05/20] KVM: selftests: Seed libc's RNG before using it to generate a seed for KVM's pRNG
        https://github.com/kvm-x86/linux/commit/5506feb24282
[06/20] KVM: selftests: Add helper to generate random u64 in range [min,max]
        https://github.com/kvm-x86/linux/commit/c772591d279e
[07/20] KVM: selftests: Add an irqfd send+receive (and later IRQ bypass) test
        https://github.com/kvm-x86/linux/commit/3ceab37ac973
[08/20] KVM: selftests: Add helper to get host IRQ from device MSI-X for IRQ bypass test
        https://github.com/kvm-x86/linux/commit/362cc0016249
[09/20] KVM: selftests: Add VFIO device support to eventfd IRQ test
        https://github.com/kvm-x86/linux/commit/3902e8b02dce
[10/20] KVM: selftests: Add a helper to set proc IRQ affinity for IRQ test
        https://github.com/kvm-x86/linux/commit/380b0e5e0e30
[11/20] KVM: selftests: Verify interrupts are received when IRQ affinity changes in IRQ test
        https://github.com/kvm-x86/linux/commit/197b0cd9ac66
[12/20] KVM: selftests: Add option to set empty routing between IRQs in eventfd IRQ test
        https://github.com/kvm-x86/linux/commit/ec333e3ace25
[13/20] KVM: selftests: Make number of IRQs configurable in IRQ test
        https://github.com/kvm-x86/linux/commit/38950af64a1c
[14/20] KVM: selftests: Verify non-postable IRQ remapping in IRQ test
        https://github.com/kvm-x86/linux/commit/25e268b76e77
[15/20] KVM: selftests: Add kvm_gettid() wrapper and convert users
        https://github.com/kvm-x86/linux/commit/4512b2776631
[16/20] KVM: selftests: Add kvm_sched_getaffinity() wrapper and convert users
        https://github.com/kvm-x86/linux/commit/76703ca0cbab
[17/20] KVM: selftests: Add a utility to pin a task to a random CPU, given a CPU set
        https://github.com/kvm-x86/linux/commit/26fd1fb4737a
[18/20] KVM: selftests: Verify vCPU migration during IRQ delivery in IRQ test
        https://github.com/kvm-x86/linux/commit/6b9470baea6c
[19/20] KVM: selftests: Make number of vCPUs configurable in IRQ test
        https://github.com/kvm-x86/linux/commit/0315713a1938
[20/20] KVM: selftests: Add xAPIC support in eventfd IRQ test
        https://github.com/kvm-x86/linux/commit/2708ecca4dbd

--
https://github.com/kvm-x86/linux/tree/next
