Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794577677;
	b=qSDFlLgBsgpKrSHhPPBebEAEZqUZPJwgXoceHhkaZglSzQwS1tq1LuM3TZp8NPf9N5Cp
	 O6m1M+b20MpijRplY/078FsJ4IHNzKK9JsBcfGVm9wqwjukDgTCG/uLFe2nQZycEIYjrw
	 3mDTz7CTrVSmxRieMpLdmOe+uNRDglJFSQa15YFiwLU0PxWyYdSi0HUaVvl6YxX+RMl5N
	 wYYcAR4QftC5hOaMduO7uq6cyPHMsWc3gGpVN77t/uZZX6Bf1p7kl5VGgQg3+R48KsWo5
	 lntieATFGwk0k2+EI3IhBHuhYlCj6TKswPGzAA6NswUQ9wSFIXrgMekvzYGxYxGy6yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794577677;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=1Ihy3Y1Ag1S58REu5bFFliNMMA5gpdpH88jS//LlU0Y=;
	b=cG3kU68gSQQZOMSVbEIDy/snhr3obZspdACjvWobg7UkzWqMRlGEzcxUpzNtzWfDQCWm
	 Jwn/rul1e7mnJpMLBhWhaP+RSewJRVCvRA2AZ7JGTilMENqU+LFkH0LcPiC71KpsxBhlt
	 KPDmyqDXa9v61+DxnHijrw16nQmZLtIw3MXuhKMhvUgGWp84uKL6mkMR36pmDQvjtiUSw
	 2pfwJ7iYqYLx4LFspZddPM9M2J+bc2zZxo6R3rF2QuB8NZqHaPcLz/EQXhzGyByl+iTTt
	 dYI14Fpxj/xFUdqD4zTQYslNV8pSkYK7UHuSQoV8FzkxzV0uQ4/WIHrEfD2L24I3KMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=i74Ooph0;
	arc=none smtp.remote-ip=209.85.215.198
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6DF606A33A
	for <kvmarm@lists.linux.dev>; Fri, 13 Nov 2026 13:47:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B6DF606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=i74Ooph0
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cdb90a6230cso503703a12.1
        for <kvmarm@lists.linux.dev>; Fri, 13 Nov 2026 05:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794577676; x=1795182476; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1Ihy3Y1Ag1S58REu5bFFliNMMA5gpdpH88jS//LlU0Y=;
        b=i74Ooph0lAeaXEwSm2PpNbYOcDPqplmbGEG4iNsA9vPYvfnifLwEdQrucZMyTroXwj
         bkSiCKYEIKQOulJbHiumExYpiTxa2cKWc5O7jZeL/+aNcL65TmPrGLjHo8lLNdSp1txZ
         OUyRc3qA9UURZVfdqvebrRA5dpU5xqG7a3HJmKJ047Kp3SV2ppTdy8bwL34i6UTZf4QS
         LEeml1LuzBK6via09f6Kb0uej7SZWntJ/c/8yWSrQ/EN1Xn0ciVxQ0wl9kbEevbtBBQf
         2YE55b1/hzNYdUdRb1xefH9kzrYjhxC1ptu/CfykGadT4xjvnLAX+Ud1lJE1jW2JtUp/
         q6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794577676; x=1795182476;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1Ihy3Y1Ag1S58REu5bFFliNMMA5gpdpH88jS//LlU0Y=;
        b=DaxEB08SK3Cx6SL2aoftqzF6v6Bau9QnIUNItfnzdNBDl6e1+O484GwgPWQidXkKz8
         Q7y7WsQymncrcylcz1BVFJc0sy8LDQWr8qFB3ggzXqCG/8FogqMmWgLbMXSzdfvpKx76
         gEaPNuyb4wMmjr+zolq/l5txudQO1ztgbti44FJsFL3YOyQmUcPB+nGNoCGi6T4CeZEo
         IRo6jBzoeXTS+bdL+L5mv/J2gu7wX0w0dHCX6aufQjxrH2H/uODZI5ZEVUaQADhnfiK/
         fjM/BsAeLzxT2V4mboSlPdNM17xrWsUzvq+vM4xKbN9TFnVWeM08pHOCbp0p269yojqz
         +KPw==
X-Forwarded-Encrypted: i=1; AL+hErGppEYoktRxInJsPwZFnRiasOh6JG0tohF7TtMVezoqPsSCpycicXiDYGe9/6Wv2wKZJOZnPpw=@lists.linux.dev
X-Gm-Message-State: APuU4Z8TvMbBTDdCbkbIoYbJqugUDsWfQfH5vnNP2qasyXzKKiZ5LmwN
	mn9u0uO1T2MGh/AqprrRU4MYq35vH603ZxrMvkK9UNrO2ukxVf8gyhgnWKwlO0vtBOR8PIKgfYf
	HtJFemA==
X-Received: from pgbda11.prod.google.com ([2002:a05:6a02:238b:b0:cd6:1a09:f41d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e212:b0:3e1:c6e6:d101
 with SMTP id adf61e73a8af0-3f7a76c2160mr2595125637.29.1794577676197; Fri, 13
 Nov 2026 05:47:56 -0800 (PST)
Date: Fri, 13 Nov 2026 05:46:18 -0800
In-Reply-To: <20261028190259.1819571-1-seanjc@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261028190259.1819571-1-seanjc@google.com>
X-Mailer: git-send-email 2.56.1.703.gf848ed807c-goog
Message-ID: <179441821375.80587.11807540842100479305.b4-ty@b4>
Subject: Re: [PATCH 0/7] KVM: Ensure WAIT requests actually wait
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Stefan Teodorescu <fane@google.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 28 Oct 2026 12:02:52 -0700, Sean Christopherson wrote:
> Fix a bug in where kvm_make_request_and_kick() won't actually wait if the
> kick races without another non-waiting kick.  The issue is that all of the
> conditional kvm_arch_vcpu_should_kick() implementations are missing this code:
> 
> 	if (req & KVM_REQUEST_WAIT)
> 		return mode != OUTSIDE_GUEST_MODE;
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/7] KVM: s390: Drop unused and unreachable kvm_arch_vcpu_should_kick()
      https://github.com/kvm-x86/linux/commit/20cf5e54a1bc
[2/7] KVM: Add a @force param to __kvm_vcpu_kick() for PPC backwards compatibility
      https://github.com/kvm-x86/linux/commit/0ee75a9dee9c
[3/7] KVM: PPC: Explicitly force IPIs when directly kicking vCPUs
      https://github.com/kvm-x86/linux/commit/2530231b023e
[4/7] KVM: MIPS: Rework kvm_arch_vcpu_should_kick() to use standard implementation
      https://github.com/kvm-x86/linux/commit/a8dabc687ddb
[5/7] KVM: Move kvm_arch_vcpu_should_kick() to common code as kvm_vcpu_should_kick()
      https://github.com/kvm-x86/linux/commit/7e52636d9c37
[6/7] KVM: Plumb the full request into __kvm_vcpu_kick()
      https://github.com/kvm-x86/linux/commit/5c430e211f4d
[7/7] KVM: Drop kvm_vcpu_should_kick() and use kvm_request_needs_ipi()
      https://github.com/kvm-x86/linux/commit/fd3dd4d9c186

--
https://github.com/kvm-x86/linux/tree/next
