Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16A147127A
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785948711; cv=none; b=eJfN5sj+jiJfDc+8bKIN0OTOK9R61FWkR5aIS/Tou9owPF7P3Mdrur16T3Zr1vXmUWHbw791qwQU9bWh1C+J9jc/n1unFQYK5uSPI/SVqf18OAmgIqRQyn7SUb8gnJTGqhtBNIDV5tekLebDTC6eh3/Le+S/zueuIlw7+oF4FmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785948711; c=relaxed/simple;
	bh=icvrJSGpdYUNnT9Ydyn8XbeMIq0CEpuZVgm64o2M0J8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PeRqGRFGMxe94O8MBtR6LjuB+w1TRzg90NBZTgCSMYora0mfAEObeBtj9pbyrGpG/Z1+0PLvbud+6nJxmzhp0IcuSq/P94ENI4NJmUnbCC7vYXpMF6DIZ1QjeAQdJ5jJlYQwBm0hvwwwW6j0a1sstvwseYv6TGu6mRSq6JfCYeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O1GREuj6; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O1GREuj6"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84a3514f912so1977361b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 05 Aug 2026 09:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785948709; x=1786553509; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jrqhku8KyxeiISShmwJpJXHc7/raRYshoO3CpoShleo=;
        b=O1GREuj6QTbZGfIY2WrcnUl8by/6Klfq2BLcPV068uoZZYVHhlbQAk+351q++K7aa9
         pgrDegZSC8qCG6RNz6rH5y97HLCc/ySRZJxjyhkbMlyCsl7rY14+QM60MzzXpY/vmYyL
         KGtaqM4xMaG2y/tOKo9m++FX697ebYSWWQ9jvq11MVsccm4k1UMLoUr9ybA97aZd29wJ
         H7bece5/46HIeXrj1TMfl9j3nkgsnAn7MeNvBi3i9lb41HL8syB46BeuN3TzB/CrePGK
         CfpY/BZev5dvIaLRrYQdHj4WH71rlrlDKD7IaDZktFoo2l2Rv2DuyYAVNPKO4jEvyHYQ
         RZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785948709; x=1786553509;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jrqhku8KyxeiISShmwJpJXHc7/raRYshoO3CpoShleo=;
        b=l577czTcB+x/VPnhoFmWSyaLIulfsGPeUaYJ1tJJPcj7tmLcuNVgZeM2ZfWzORV4e+
         S/j3jeMJO8yViDyJs5ptfxhlvCCqmxhOBgky6tERsFyvsVGMZQ4jihboe13GMdBqIk0k
         ye5V37MM+KIJXDIMfVkLOpo/CD4sBtdHnNW7KygtLxG8t/RS/Axoqwii6fJ56Cba1CD4
         mZFGAzGuazf7EWpk2x0Z3pHBePU+tt5Ukw2ol3hwN6R3U6SP4uo9pjVlxG1xQTh45mSI
         t+djQeaONaby+4VE7CdJIzYNa+zzId58SBoTCB0QudGx6rXmBk/M1Zy9df+9DZ1jx7VX
         Mqmg==
X-Forwarded-Encrypted: i=1; AHgh+RqMdJWI+NijtUL9rp2IPrPfgyUHUp16bLHnWemV7qhaw7iwGfME85EitjAa7LfZ//x3R81a0cE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yww/h9/J/o6FWPxh6zlRlDN7Rl4h+DwYYPC2X9QMGREy7iRL1oE
	k9vuc4mvOq2goRwWr38Js0uE8v34fTchXSj6clq0CSeTdo2yy6eb79E88fjgw1u69/1DqKhWbFK
	LOjqrCQ==
X-Received: from pghr18.prod.google.com ([2002:a63:e512:0:b0:c92:dd1e:dc3c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:99b:b0:848:76c4:fba9
 with SMTP id d2e1a72fcca58-84f2dff77c0mr8958464b3a.7.1785948708769; Wed, 05
 Aug 2026 09:51:48 -0700 (PDT)
Date: Wed,  5 Aug 2026 09:46:10 -0700
In-Reply-To: <20260731195612.2697986-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
Message-ID: <178594833919.3639358.12902044577496582719.b4-ty@google.com>
Subject: Re: [PATCH v3 00/12] KVM: selftests: Add more syscall wrappers, fix hardware_disable_test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	David Hildenbrand <david@kernel.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 31 Jul 2026 12:56:00 -0700, Sean Christopherson wrote:
> Third time's a charm.  Sorry for the spam.
> 
> Buried in the middle of this is a fix for the hardware_disable_test where
> it can end up with a runtime of multiple minutes when running a preemptible
> kernels on a large NUMA system.  Turns out my analysis/guess in v1 was wrong;
> the problem isn't direct CPU contention, it's that letting the workers do any
> amount of "real" work on any CPUs leads to pthread_create() slowdowns from
> the perspective of the caller.
> 
> [...]

Applied to kvm-x86 selftests2, thanks!

[01/12] KVM: selftests: Add a KVM syscall wrapper for sched_setaffinity()
        https://github.com/kvm-x86/linux/commit/f766bf3d0ac8
[02/12] KVM: selftests: Set threads CPU affinity before doing work in hardware disable test
        https://github.com/kvm-x86/linux/commit/2887da61c42d
[03/12] KVM: selftests: Pre-set threads affinity in hardware disable test when possible
        https://github.com/kvm-x86/linux/commit/496779b54943
[04/12] KVM: selftests: Return the target CPU from pin_task_to_random_cpu()
        https://github.com/kvm-x86/linux/commit/8de0e85f654e
[05/12] KVM: selftests: Extract picking of random CPU from cpu_set_t to separate API
        https://github.com/kvm-x86/linux/commit/d58cc7bbc5a0
[06/12] KVM: selftests: Affine threads to random CPUs in hardware disable test
        https://github.com/kvm-x86/linux/commit/563416ea9ae4
[07/12] KVM: selftests: Drop unreachable, dead code from hardware disable test
        https://github.com/kvm-x86/linux/commit/bb0e7d84c4be
[08/12] KVM: selftests: Add KVM syscall wrapper for pthread_create()
        https://github.com/kvm-x86/linux/commit/5171573ce7cb
[09/12] KVM: selftests: Add KVM syscall wrappers for pthread_{cancel,join}()
        https://github.com/kvm-x86/linux/commit/bc9143135bf3
[10/12] KVM: selftests: Add helper APIs to cancel+join pthreads
        https://github.com/kvm-x86/linux/commit/939b20e5f35e
[11/12] KVM: selftests: Add KVM syscall wrappers for pthread_{g,s}etaffinity_np()
        https://github.com/kvm-x86/linux/commit/83b5065f3e1c
[12/12] KVM: selftests: Clean up global constants in hardware disable test
        https://github.com/kvm-x86/linux/commit/1039496ae75d

--
https://github.com/kvm-x86/linux/tree/next
