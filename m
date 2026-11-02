Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793633674;
	b=RRrw3XZEg4LPcgHicF/qwWHUKF5oUazOZgERzPBj6pdp/0qWATPucLkOoNGw3O1rCjVQ
	 IguagUQBRA0hEp38lN19ud+qh1YJT+wZ/471DXVy9O9tOVM+WHMBuYubAVCrHQPxHd+I5
	 3vPCym7p3nCOhYS1+QgOvEilKEVKiHRF/AJwPVwo72/sW5vag6pVxrWKVNHuJdoger+Uz
	 NaLngQLKhM6HfKDfPIzGgmpFMtF9mw3ZbIXPJsS5KFPiTadSIu+rVjQn7aCCkXyjLyCgQ
	 37VEHUXizCFEduZ7tyFqrvD/SUeEXc7Qeft41859nBsZwgF1ry7Ibv9MjKTK9WOEnZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793633674;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=s4vRCplgEoCQN3eUv6q9zSWbIbV1TXU7YJjG5+iZQYY=;
	b=FpLTALMEpBcym+FYQpW6CtNrpnKxJFVnMlrnCsnVysrBLhHsPosnr1TUddK4pUrXc3sz
	 Zgdy5S/fDQP68JCSo40aSsN9WDvNB9Yve7u9poU3ZC+4ri+DQjDTP00+g0+jrIE4Lg7CA
	 YCn2hf7a6RhZ1g3X+37ts0ARMq3ey7dAeTRLntuHSv/CiuuCvNUhA1bP/MJxZCoJcjgeI
	 pDD8UMtu43uMIdcY1aMlAzxNZ7tovPJWgFwGmAVhcEWqAD+bgARa5CjXsHuHbrZATKaep
	 SMlLbRv8Ge5ia1iKN4EjJabHVbXhL6wJUp5fKYjbePn/V7gvreNqqKdkAejIzLNMnwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QR1ITLYM;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9B6606B0E1
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 15:34:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE9B6606B0E1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QR1ITLYM
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ab926c236aso2513570a91.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 07:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633673; x=1794238473; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s4vRCplgEoCQN3eUv6q9zSWbIbV1TXU7YJjG5+iZQYY=;
        b=QR1ITLYMlwjWfqVET1Hk0MVx3g9IL26OGxn12XrSExpgj/bTRzrJHdSTjHgIswVjxT
         Yva/U6afi4Im4GifFv4sDN785bI2i1Kk8LTwnoJQ9KYgb20MHORq667E+PeK/K1deHkE
         96/PoqVLQwNk+YBRrY/me2xcBoQf/9iYXiB29+YPJn6FB3SpQvtiz+7RyF2dlxlwX57s
         1lVREpCZjb2LROHIW29AgElb9USoSmLcYAwGMbmYMM0OcL+pO+PYSXFpND5N8JvZSTBw
         XGVvoeA+xYF/Avi0unn8LcsF2ejM8APlXW3vVo+EzECrT9DWYgccNT9iBGdRpWYJnvTD
         7BYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633673; x=1794238473;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s4vRCplgEoCQN3eUv6q9zSWbIbV1TXU7YJjG5+iZQYY=;
        b=Lh5jcs08i2iCZ6DYhUxO5bn1ZATOWcHAEG/865+/KzNxH2sm+7ekt3rD5QxYLfGkRw
         Y29mBjji1SsTv7XZz4SKj/1AYf+xAmxcq5m58P6EjriX6eMsHy5bcj97TxNg/35oj4sf
         NVT8UCjRrwUXIsQJh6+wuHFAQ4fPAZEk06FPtA0/3FP2bxIjuIlrx2Uo4jQzKFoOXXqI
         LgT3JTFN2CIk+oVQuC2W13/CX+tpLK5MfHvi8XZ5fGB3q5ZUiwpAaVuvBbfx+fJB9qAO
         6FoyHpPXPGxXEH3sEtAc4DZUH8P6lJb3qUkN3RvrMWgEo4b68rSrvDelNQQEkH3Akodr
         vl4g==
X-Forwarded-Encrypted: i=1; AKwUvBwZNkNxoNUwKH6U1SJIsJZ1qicVf9sZ1aS0/gyftEK20JSb3Qv/hLOSaxJFyG4dDAJtPNc55jc=@lists.linux.dev
X-Gm-Message-State: APuU4Z8d6sQkOd6d6aFCOTZ0zH8aMDXkPfsgW4p7vN2xpnGkGdyolEmC
	dJ1/PV+oin0zBhf1GhhAU0uJjK4CmjclQOFY6yiLYmxBgcnvB/bYDc+laLgeLI0Z+xJ2VDA9fZq
	BpXOC/w==
X-Received: from pjso1.prod.google.com ([2002:a17:90a:c081:b0:3a8:211b:6c8b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2749:b0:3ad:43c1:7d41
 with SMTP id 98e67ed59e1d1-3ae897429b9mr7590262a91.33.1793633673063; Mon, 02
 Nov 2026 07:34:33 -0800 (PST)
Date: Mon, 2 Nov 2026 07:34:32 -0800
In-Reply-To: <20261102153228.240804-H-seiden@linux.ibm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261028190259.1819571-1-seanjc@google.com> <20261028190259.1819571-2-seanjc@google.com>
 <20261102153228.240804-H-seiden@linux.ibm.com>
Message-ID: <auitiPKnFueBJzPA@google.com>
Subject: Re: [PATCH 1/7] KVM: s390: Drop unused and unreachable kvm_arch_vcpu_should_kick()
From: Sean Christopherson <seanjc@google.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Stefan Teodorescu <fane@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 02, 2026, Steffen Eiden wrote:
> On Wed, Oct 28, 2026 at 12:02:53PM -0700, Sean Christopherson wrote:
> > Drop s390's kvm_arch_vcpu_should_kick() stub as the one and only call site
> > is wrapped with "#ifndef CONFIG_S390".
> 
> In the somehow near future I'll remove those #ifdefs and use the kick
> stuff for kvm_arm64. The native s390 KVM then must at least keep an
> (unused) symbol at hand. It seems that the compiler could not optimize
> those calls away. So let's keep it there so I do not have to re-add it
> soon.

Please read the rest of the series.  kvm_arch_vcpu_should_kick() goes away
entirely.
