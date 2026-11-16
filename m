Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794849107;
	b=HXpSD2zFI6wASk4vlQLyv8iqo5mzZh9Prgwy8cGuE4XTOY4NY9FgmRaAehu2lYU+C66C
	 KDvS/WvqgnpW32zZ+rBTtEz1jwyLvPj+0itLDmRN0nQsgzzGKDZUHUw3KivSnPaSGYFjZ
	 1m9YmHosGm9l01n3yAgeAwlodLA543lBV91GG/FiVP3GaJXbzwouRT/LI+BULEGXlRMRA
	 LgtmELxvpf0MvZaheN12rbI8fWP6DynHnKkZDkOlt43te1tdxFnTdsZCl8n0NVQyh2MbL
	 V1You5Xv24p8hBW7ofEX/NaWnq+Ikwt/hDA/goyLAIkDi2iD+cpz6NV3Rq+G2XophiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794849107;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=XSh28i+VhSML98fbPpvhJzYzMwMr+W1AdTaomqWNWcI=;
	b=yJja0ZeHnRJnO50bjVM0ukZtS48fxweqXYmUWthlDcEOVAQqGCSzfLsrf8HlBjeQfnQH
	 ITd8AqAOE2SA0LfsOPPoBkj2uHuJUQYek1B427MJGOeC6SH6qKwCGAcOJjKrp0t2XfTs3
	 MbKkO82vJhwvSu1JmyOjlXse05CSXV0sICH+q+G3rPa0JiOtr1P8U53u1FLRK0Djld9b5
	 6BolbIABH+0a0mJwbSlMMhmm5x012AyljSU/29vYYSOdbNMYwoaE35WK3NiZOdd48CFgl
	 Gw7hrpg+EoGcZ2Y6KI2QN67NSvD7bxpWLmjaXzBFLJmRTRXOJjJXTYjp8+/ND76ixrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=T6XbDHqs;
	arc=none smtp.remote-ip=209.85.210.197
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0017606A329
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 17:11:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0017606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=T6XbDHqs
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a06750c74fso3442266b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 09:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794849106; x=1795453906; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XSh28i+VhSML98fbPpvhJzYzMwMr+W1AdTaomqWNWcI=;
        b=T6XbDHqslsmUTLd5aae0swE1vPHUBzYqGh51RtosLPuQNKpPfQ8zsouL2xmI5iPST8
         X0nJssogTFQVYzjzQs0SvjNdGTTJ9CZWML8X8CydCAhtHcqP2DYJ7osINrMo3EBZgi2B
         dpj7OHC9l1J3y2pgj0puW1FqeWoXYKWStIBGb6KHA4C+s3cNQ4yR1HqGc4GsZzcn+n4x
         5wi+PYMiBgbYyvC6hNPkczXyOU5dO8JaqBN2O5TITJ4X8Pj01HhW2BrLloRcHqVeS3CF
         2znDk8acIcwQl5LC64rYJ+XjIN9AftO8qz7/KKY0i4AayKVtTi4aNpawfaI9I8PVHxN2
         JtQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794849106; x=1795453906;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XSh28i+VhSML98fbPpvhJzYzMwMr+W1AdTaomqWNWcI=;
        b=bSDX/kQmAl4TIf+qhLP/aA5xaTfxNzrxDDFoAsAWEGYukST9hdj1QZL+NcyCczxn6M
         G3QEt9GH+IxYKoDaxhwLqCNExlKvt+hThabzO3huHpsjwRzvJDBp2c1MnFzUXayDf8CX
         ymsHmu19qC1LFtSbJdAbIUmHqmWYkuTOqo7winS4/j/5GgOsioNVSYI2gRvx5xBrLvkK
         qKNr5lRUHOk5CclwgtOTJT+jq1wFaQH2F7q3CM138G+QGeWH5wzpAN7/hA70h8Gzjsfc
         NPbL/N+ibgV2EfrOIL2+EKX3ZbVVzzr8v1uzUUxM4dB0b4q01UPAdhcvmT17SGHhOgo+
         IGbQ==
X-Forwarded-Encrypted: i=1; AL+hErH6cH21C3zviF90kWay57JAiB75Gh3HIOf5J4vcx22rf6XGTW4+3J/ea4GLxKvI/4m/+r3l+1E=@lists.linux.dev
X-Gm-Message-State: APuU4Z8Pz8YHinG7/UAziyCyYK/7YJoBETQiAoIkXNHgPt0zoenFpIWv
	XIwUJgp7yIY8nA49PIoCJNBFLrYXJ4j5ocffnET26TGJoBpKK+gUErNMfSXrsD41114dqgr1vyV
	2K5okgQ==
X-Received: from pffi16-n2.prod.google.com ([2002:a05:6a00:c290:20b0:8a2:1bc3:8884])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1a87:b0:89f:9ea6:1ddb
 with SMTP id d2e1a72fcca58-8beb619b3e6mr9177875b3a.23.1794849105715; Mon, 16
 Nov 2026 09:11:45 -0800 (PST)
Date: Mon, 16 Nov 2026 09:11:44 -0800
In-Reply-To: <CA+EHjTyqJfGS+5UajX=RYTAG-qfhZ-vmGi=1SixXydWhwGHLUA@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110110724.3614412-1-fuad.tabba@linux.dev>
 <20261110110724.3614412-2-fuad.tabba@linux.dev> <avM81YcTBTJ8zCMX@seanjc-mac.roam.internal>
 <CA+EHjTz-Nb-g9YQKX2fKk61hC2BfzXfmUHv=2j+eZ18YuTv2Eg@mail.gmail.com> <CA+EHjTyqJfGS+5UajX=RYTAG-qfhZ-vmGi=1SixXydWhwGHLUA@mail.gmail.com>
Message-ID: <avs5UD79FB_DG1Vs@seanjc-mac.roam.internal>
Subject: Re: [PATCH 1/2] KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's dirty
 ring is full
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 16, 2026, Fuad Tabba wrote:
> Hi Sean,
> 
> On Tue, 10 Nov 2026 17:18:22 +0000, Fuad Tabba <fuad.tabba@linux.dev> wrote:
> [...]
> > > Eh, I vote to just use kvm_dirty_ring_check_request(), I don't see any harm in
> > > clobbering vcpu->run->exit_reason.
> >
> > Will do.
> 
> After taking a closer look, the clobber is problematic on arm64, where
> KVM_RUN completes a pending MMIO exit only if run->exit_reason is
> still KVM_EXIT_MMIO. If a pre-fault stops on a full ring after an MMIO
> exit, the helper overwrites exit_reason, so the next KVM_RUN doesn't
> complete the exit and the guest repeats the MMIO access. The ring can
> be full at that point if the pre-fault dirties pages, or with NV, if
> the stage-2 walk for the MMIO access does.

Wouldn't that require userspace to do KVM_PRE_FAULT_MEMORY after KVM_RUN with a
KVM_EXIT_MMIO return?  If so, userspace gets to deal with the fallout of being
stupid.

> I don't think changing how arm64 completes an MMIO exit should be in a
> fix for stable, so should I keep testing kvm_dirty_ring_soft_full()
> directly in v2, or do you have another suggestion?
> 
> Cheers,
> /fuad
> 
