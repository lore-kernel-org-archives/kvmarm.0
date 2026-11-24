Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558579;
	b=lCPQrfIH5WB4DYShjLuaBJ0rB/6r7Jg5QlN0e+lM9RgtXHb+RwEJX7347BxPDONMwbKQ
	 PlPGc2BHM8T8gQitHMeE1NkOwZiaULzOswreh27W8kY0O0dirHEMcmNRNSUmonSiCz5oi
	 E+sAPvstOmTIEfsr/Egql93+YkDKWu6/01EtwfMOUAPuhRl+VhLXTXhVO0nw7sI9i5YaG
	 tItsolPo8vLCMcUHVOemF8ZEqg6q78PCb86wE36WdXT2S+5tzI5MCInmZjk2LX+EnTgnR
	 dIobBknAfSi1C7XVspi6M/ycfNCh1aOjrceg2N9wngXyJsQiW8gD5Ct2cZpD/c7Oa+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558579;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=oIkNeebV3bBNTky3/G9aQsRRQo/i+uLeVgZIMqhznFQ=;
	b=G65BROWbzD11Fu3DPd9XlgSESdyKI1xmB/Us0GExI0zQizBBr9VqK4EwzczocxtOQNZc
	 JlDh2c2r7Ukia1BqYxurqeHv9xI7rveXzpZ5rQDg006CSD4ZFP6bEr/d1K26UDj84CvJi
	 MTzfE2E7tNnbgYo6ejmPOBR1OrYF6/hoQUiMQlfMJ1oVApGuuUh7mttk+Z3qFejm1gWXA
	 EUn/dgapE1sBwLgT0DewB35r36VwI31OEsX8tea0V2IdRCh0k+9KBrHeWjgPF4f6lJSbZ
	 pJ/0XVGrgbSWfHUV8igw5HEqjamlZwFivg5SF+wZDlVSFB0hs1zX4kELZZHPhbtlbSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fEUiioa6;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DB6606A326
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:16:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4DB6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fEUiioa6
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4cbf700ddccso3754313b6e.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 14:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795558578; x=1796163378; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oIkNeebV3bBNTky3/G9aQsRRQo/i+uLeVgZIMqhznFQ=;
        b=fEUiioa6HMwZg8X+RpcD1qE32b8z5wesLGDNfSSMfzcrv3GURIlRff2IZLu53Jc5l/
         GMsbCYbBVB4d/fBCrYFmYW3gb+YRTp1qlI6RA7T9RFRYES5rPGAjADQXR5TP+z24lF01
         u3wHo2TeWoT/MwGYfEFXzCKKpGCjEyyznm0onW7BnjX0l+WDENm9imgUuANb2uqMQQ1m
         hNTAkYaDdY+Dv7fVWrHVurDibbIMXZnU2+gMf82HmvIUfuRqtj/Ghk91NXbdwwAyfAGq
         ohUSdAB7mSuHuY0uFOAO5sjiKIRVOYW8hzXEX659zJlhq2Tdwj5FCgSpbIgfMsdZ3sj6
         0XNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795558578; x=1796163378;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oIkNeebV3bBNTky3/G9aQsRRQo/i+uLeVgZIMqhznFQ=;
        b=RUvNcuiWK6h3dD033/1thk6A1Mcsh+DJngI5VavuKrB4MYIw71TKV6u+YnWRWDHh/m
         zD1xZjfqALl+LBSHDh3V3Ot//bo9SPy4iRrxQVBgZ0TGOV7nw5gZWflEX6Rv0RsFpf7G
         nKz8nKLwIja9CyJNRKNNWtsniJ91YZTrxah9k2gXIKS+fTHjW7KSRFgard40RZCtcSUB
         uM6qN31rqNKa1ey7TPAowGOJlCTpEhk8R6KXjI3Ki1of8mfIqAy+VGz8eSULTW3K5all
         zdwgHpuSYwLPUOYRCZbArLmhuO5Y4uL2K5lk6E1HZ+DYKD5nn44/ncHNDIF2Undb6jDI
         pzQw==
X-Forwarded-Encrypted: i=1; AL+hErECZIlSVgEyCnVcK3eS6+qKKgNIp9O21klUlMG/mWnb4csyhn7i+JqRR4ZQOvKfnvdTERxcq8c=@lists.linux.dev
X-Gm-Message-State: APuU4Z87prEMLjqNnEjUsv3/5SICkiTOw7qdiIqve56gJgAIVZ4dowbI
	CmNKLrOzzoupTKvO10hVvxWkboVwbvWBxpFOWA3odBWS3r5Cc+TxAQop7G8abLLvj2zYrXbST8R
	N6K5GirIMZchUv6SXGdpMLCsFbQ==
X-Received: from jaaq28.prod.google.com ([2002:a05:6638:c01c:b0:61d:1a3b:cb30])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:180e:b0:572:61c7:bee2 with SMTP id 5614622812f47-57a06a1a79bmr18783520b6e.1.1795558577535;
 Tue, 24 Nov 2026 14:16:17 -0800 (PST)
Date: Tue, 24 Nov 2026 22:16:16 +0000
In-Reply-To: <87a4my7yhg.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261123232647.3733149-1-coltonlewis@google.com>
 <20261123232647.3733149-2-coltonlewis@google.com> <867bi2z87n.wl-maz@kernel.org>
 <20261124202215.3731849-1-coltonlewis@google.com> <87a4my7yhg.wl-maz@kernel.org>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261124221616.4155034-1-coltonlewis@google.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: nv: Discard undersized TTL hints in compute_tlb_inval_range()
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Steffen Eiden <seiden@linux.ibm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Dan Carpenter <dan@pereq.eu>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Nov 2026 20:42:19 +0000, Marc Zyngier <maz@kernel.org> wrote:
> On Tue, 24 Nov 2026 20:22:15 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:
> > [1] only catches TTL hints smaller than host PAGE_SIZE. It does not
> > catch a hint that is >= PAGE_SIZE but smaller than the mapped block,
> > such as a 4kB L3 hint on a 2MB block on a 4kB host.
>
> Why do you think this makes *any* difference? The hint passed by the
> guest is utter bollocks, and the best thing would be to not invalidate
> anything. It's just too invasive to do elegantly.

Architecturally [1] is fine for the TLB, and before guest_s2_mappings
landed in v7.4-rc1 clearing the block was harmless. The problem with [1]
is a host memory leak in kvm_pgtable_stage2_unmap_tracked():

1. L2 faults in a 2MB block. kvm_s2_fault_map() installs a 2MB block PTE
   and kvm_record_guest_s2_mapping() inserts a 2MB
   struct kvm_guest_s2_mapping into both interval trees.
2. L1 runs TLBI IPAS2E1IS with a 4kB L3 TTL hint (4kB == PAGE_SIZE, so
   [1] returns 4kB).
3. kvm_pgtable_stage2_unmap(..., SZ_4K) clears the entire 2MB block PTE.
4. kvm_remove_guest_s2_mappings(..., SZ_4K) skips removing the 2MB entry
   because a 4kB range does not enclose it.
5. L2 touches the address again, faults because the PTE was cleared, and
   allocates another 2MB tracking entry.

Looping steps 2-5 lets an L1 guest leak one struct kvm_guest_s2_mapping
per iteration until a larger unmap or VM teardown (I measured 832kB of
slab_unreclaimable growth over 8192 iterations) and turns later TLBIs on
that range into linear walks under write_lock(&kvm->mmu_lock). Patch 2
avoids exact duplicates for the same (nested, canonical) pair, but
remapping the nested IPA to different canonical IPAs still leaves each
stale entry behind.

If you prefer not to touch compute_tlb_inval_range() beyond [1], another
option is keeping [1] as-is and dropping the cleared tracking entry in
kvm_remove_guest_s2_mappings() when a partial overlap leaves no valid
mapping beneath it (zero cost on valid hints).
