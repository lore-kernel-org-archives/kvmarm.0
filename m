Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.166
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792690568;
	b=xAI9dae0b8BBk0iLEarr99Tt3nEZITzHuRQzwhrd7eSF0+GtDMwWblqos7vvgqkx5pc/
	 L3RzexvEzNp2rGnJpWXmGM172GVoj36cyXM8rNGyzVaDFt9gEkFQlet3inf2Rp7XZm/A9
	 Pcj7HQr42RJdN/FkyCkaQOYxNpig33o9Jld4yrds1HTVo0/tQrmM3w7Tb4dDtaMdFSR3h
	 lpnS86RmdY/mnAPE5/KrU+fWOWRYOkym2TsFZr7Tm2m3fmGtEyV3bvU6q7UQAzH5Trj+B
	 a5JFnqcRkQOehhlLgaAp9Y86053wZa208u2l1AK2gBM5qwMOtqS+SGj6RpyPD9zRlpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792690568;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hBlZ3c+WCK6g74zPRkfoYcj+pK7tXKqrk+Hh3m5wzfY=;
	b=G6nFpz66Z3Z0m+rITDpYl+viRJbif4DAXan/qET+Va/rDd1WLzLZPxi+8cYseD9M1Tgh
	 qIjiHROi927IlfEoWRvIp4qlONwtSQ2re9KKguC3g3ybYD1ifbwgwg9CgclAOFFFYBZbP
	 7ob9eJsyfpviSnWqbezbtbXGAy+uPwc9iEoXc0wFBQj+0JHOAuDJp141/BVg0PIE1PT10
	 1+FM2Cik6sZchkVH0znZVbxWKd/HzC3viUpTuos4MqPZIdytERJ/DJ6X1kxyg0eCNJX6o
	 kaUggSd4JQZtTJrZjilEgPJO6umrcpzEUuLsB+qjgderZ/MAICcEEReRDgaVQBSi8Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eJRDyeEZ;
	arc=none smtp.remote-ip=95.215.58.166
Received: from mta1.migadu.com (out-166.mta1.migadu.com [95.215.58.166])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EF9606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 17:36:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89EF9606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eJRDyeEZ
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=vtTv8LAxxMmX1s5o/Nzyb3tJPXKEsK73smIwOCpMdG8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792690565; v=1; x=1793295365;
 b=eJRDyeEZRmjwooQ2RKr7rRnYSBSS/FzZTlqVAwTRjaR5lJrlqaWX7p1nl8bc5YJbVNhOjFGC
 /K4LmK0urrqBdIfNPHbntxdb2RHonlcf0vqY8OokjuuNx0DDHm5QRWZNPbONfPTnLO/X67z0Vv0
 F1DLmXRPwlu9U7sNjWiYuoXM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7c15b67925d49db3;
	Thu, 22 Oct 2026 17:36:05 +0000
X-Mizu-Trace-ID: 7c15b67925d49db3
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	tabba@google.com
Subject: Re: [PATCH v2 2/4] KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
Date: Thu, 22 Oct 2026 18:36:04 +0100
Message-ID: <20261022173604.3710390-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022140048.2522787-3-vdonnefort@google.com>
References: <20261022140048.2522787-1-vdonnefort@google.com> <20261022140048.2522787-3-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Vincent,

On Thu, 22 Oct 2026 15:00:46 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
> The vGIC LRs are architecturally UNKNOWN when the CPU boots or resumes.
> However, in protected mode, only the used ones are reset, because the
> HVC __vgic_v3_init_lrs() is never called:

Could you say here what happens to a guest when an LR isn't reset, as I
asked on v1? Without this series, on QEMU changed to leave a pending
vINTID 100 in the top LR at CPU reset, the guest warns "Unexpected
interrupt (irqnr 100)". With only the EOI bit set there, the npVM
doesn't print anything in 150 seconds, since the maintenance interrupt
is asserted on every entry. With that in the message, could you also
bring back the Cc: stable you had on v1?

[...]
> Then, cpu_hyp_init() is only called from init_subsystems and
> kvm_arch_enable_virtualization_cpu(). Remove the kvm_hyp_initialized
> gate: when pKVM is enabled, the cpu_hyp_reset() will just return an
> error while for other modes, we already know kvm_hyp_initialized is
> false at this point.

In init_subsystems(), only the CPU that ran do_pkvm_init() returns an
error here. The others are still on the hyp stub, which returns 0 for
HVC_RESET_VECTORS, so they go through the full init. Could you reword
this part?

[...]
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
[...]
>  static void cpu_hyp_reinit(void)
>  {
> -        cpu_hyp_reset();
> -        cpu_hyp_init_context();
> -        cpu_hyp_init_features();
> +        if (!cpu_hyp_reset()) {
> +                cpu_hyp_init_context();
> +                cpu_hyp_init_features();
> +        } else {
> +                if (WARN_ON(!__this_cpu_read(kvm_hyp_initialized)))
> +                        return;
> +        }

Could you make this "} else if (WARN_ON(...)) {", as elsewhere in
arm.c?

> +
> +        /*
> +         * Even if the hypervisor didn't allow resetting the vectors we can
> +         * reset what we have access to.
> +         */

nit: "what we have access to" is the LRs, so I'd name them.

With the above addressed:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
