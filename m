Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.126
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794845370;
	b=bR1oHT7uZv35eiM09Y/8b5Q98E5Z7tq/XwZE+ywt9GBSR5rqFyS1XAL+QxucqlrxEJY4
	 s/nxp8GcYI2UGOB8EGl6A1qSIZkHKHu5q1VBTho7yIDInNSu06hooP2LRB99yLFq48JQg
	 J40SGnAX0xElZLEdhtVsrf+s7LcusfZzyrHWE5xi2cV5SvNOc3jGgkmSLzmjG5q0qwhHs
	 lZFLxBs1OVBwRF40uprSmXfOF0lzMt08w8myxV9WrBsfLV9sSOh0aS/hBdqMw6laEvc6h
	 9wlvcBP/VJ8P2MUscGMi7LFU3IewE7oZ1Qi0l/qmfvCgDlZsGHm3ThNq11Ocb2niHww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794845370;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=xuWJrrizIQaSrZTQFgUO3V0HL4ic1BmuoACdN3FzMhU=;
	b=2dBuAsYmfrNiQWghYqHNKGdEgQy8YUJ7DVY5f4srM99KBzCKyGZKyUjPYM6O4krxsf6S
	 nvA2wYzZV7S2gePWuV4ct3jM+DYrhFppbOdk5aF9RatEsNs/ESlIJBhjnmq2GInik6eIP
	 ge0V/cfVuUFqlKmHHXhvJlUqhPyx0cOCiG4ic/b/WHgQve402TzEKX5d8JjkzSl1Ojkjg
	 H8RQXoKJCscqFl9g234/Va6xbVD6Ls+Dvs0EKeGtggxo6wXj3gb2DP2C+1zbGMERNF4+M
	 KC2ojFr+Wlm1sLeWdpIrmCOm5rzEDPhvVOWMKUJl8oBC0WJPp6JxKq9/ExkIOoND3Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=U0kna3NM;
	arc=none smtp.remote-ip=91.218.175.126
Received: from mta0.migadu.com (out-126.mta0.migadu.com [91.218.175.126])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B676606A322
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 16:09:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B676606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=U0kna3NM
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=xuWJrrizIQaSrZTQFgUO3V0HL4ic1BmuoACdN3FzMhU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794845368; v=1; x=1795450168;
 b=U0kna3NMwIP0yu9sqJFhrpm2vr144awdm4FaRl/JloNBV3+PnZOxa8uRg5tpTZVFpT82km4w
 RXe7enmqkg0iwArMBg5yWCDGzVBCQGWjAXMdLoOMLh5wV3t6g2KEv9c5zaYytTSdm9Be1LUk0W8
 nVQR3+uDXSIjVjz8FSblmi0Y=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3e4d4f8f7922116a;
	Mon, 16 Nov 2026 16:09:28 +0000
X-Mizu-Trace-ID: 3e4d4f8f7922116a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so12525e87.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 08:09:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFsrodfKVEquA8O0YX1CQB0AzpQE8mzw4X+b0tioNrcWmyRtzseLib/OfLhSSBhdaRfRSl/icg=@lists.linux.dev
X-Gm-Message-State: APuU4Z/vLdIwcNdlQwwbGjFuSICZqaHU4LhDRk9Lq2DDceZpmF1zYrQk
	nGcnVLARWH3nhLsI9XdA5yTPqkvGtvMWtD6YXEZn9q6ue3jc5a0JC41i+JBEwiUFnkPrdjJNhst
	AGjRJeuWRqOKGWTU8vhlNlfKhGeNtKx2Mb2ppbvOh
X-Received: by 2002:a05:6512:1304:b0:5c1:4cc8:2f22 with SMTP id
 2adb3069b0e04-5c17e4b9f86mr221482e87.8.1794845363481; Mon, 16 Nov 2026
 08:09:23 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261110110724.3614412-1-fuad.tabba@linux.dev>
 <20261110110724.3614412-2-fuad.tabba@linux.dev> <avM81YcTBTJ8zCMX@seanjc-mac.roam.internal>
 <CA+EHjTz-Nb-g9YQKX2fKk61hC2BfzXfmUHv=2j+eZ18YuTv2Eg@mail.gmail.com>
In-Reply-To: <CA+EHjTz-Nb-g9YQKX2fKk61hC2BfzXfmUHv=2j+eZ18YuTv2Eg@mail.gmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 16 Nov 2026 16:08:47 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyqJfGS+5UajX=RYTAG-qfhZ-vmGi=1SixXydWhwGHLUA@mail.gmail.com>
X-Gm-Features: Aa3M54pa7DZ_uBY7ynCUhZPG35ZaG2vJ1bC6E24f7r2YagR26_2vzli-PPKoWqQ
Message-ID: <CA+EHjTyqJfGS+5UajX=RYTAG-qfhZ-vmGi=1SixXydWhwGHLUA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's dirty
 ring is full
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Tue, 10 Nov 2026 17:18:22 +0000, Fuad Tabba <fuad.tabba@linux.dev> wrote:
[...]
> > Eh, I vote to just use kvm_dirty_ring_check_request(), I don't see any harm in
> > clobbering vcpu->run->exit_reason.
>
> Will do.

After taking a closer look, the clobber is problematic on arm64, where
KVM_RUN completes a pending MMIO exit only if run->exit_reason is
still KVM_EXIT_MMIO. If a pre-fault stops on a full ring after an MMIO
exit, the helper overwrites exit_reason, so the next KVM_RUN doesn't
complete the exit and the guest repeats the MMIO access. The ring can
be full at that point if the pre-fault dirties pages, or with NV, if
the stage-2 walk for the MMIO access does.

I don't think changing how arm64 completes an MMIO exit should be in a
fix for stable, so should I keep testing kvm_dirty_ring_soft_full()
directly in v2, or do you have another suggestion?

Cheers,
/fuad
