Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792690630;
	b=h6/wAB/vua3/PhExMaP+qlrwVJ+Bncb/l4DVjUANPvtlwGiax7cr6kB1mhlYn2JN/NTc
	 SRlVwNTz4LEel7aKj7t1coTSFTNGaT8dH9L1OF88gh5NzRNgUnJg9CIcMrzUYJpM0hUfu
	 WuZT4JIsJR2520aRmb3i/q1/BsR/wDUqkKkpSv/leUVueczzlbwBKu27x89CwuEKKe0az
	 IzuXVcNmSQhuniHVY3f9fSjWDt1FqV0bwE7bQAu//UJoRdBCH9TkyPzCdbD0w2qX+BB+O
	 k0qzbT49qRfEec6Y7XPM21Gl7lF1CUv8R25UowF5po+1+p+U6ZF+ztkBXbSDgks9ZEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792690630;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=RWYyUno+6cx4LmdgSlbrF7AOPgBC6T6bh4Sekg6kVow=;
	b=3GVlPBSpiw9QdLJIVqGF1kabAbPxY5yixUeapzGhzARBJsZVFFJfoHfj8p4PrAfXugY+
	 tp8lWO23LOljlLEuORggI6HlDFQJOjeCXPiuRYa9c2PfwlbITHCXWlRybrxzqN3Mp+rYs
	 LKNNRVOg+n5QKoZLxICnSHY8jdOONbyhdieLUKkWQ7GgMS6ecF+SBuqbdhFCBrLW37g9A
	 2tjAN+mWRbOoxiffUTJjf3Quujxv5+a7hgp/YtCu2imHNE6bssGj7NONqW0HTD4de6vzO
	 lM3T/aS+PAIgOez0yChN+18PyyRM8Cf1tW0AcU1AgAvS9LL0awgbTqyQ0z0knu9KIlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EMEydMSd;
	arc=none smtp.remote-ip=91.218.175.52
Received: from mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA608606AB4C
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 17:37:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA608606AB4C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EMEydMSd
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Ipd1ZzuR29dZ4jyKrxs1oKJ1qWtxaGrUuphpRz/7Je4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792690626; v=1; x=1793295426;
 b=EMEydMSdKqUJgL654qc7t0SCYVaC6YxriMbhf54XCJS+vhT7xBGDPrem40ofTG1s1mj0uymj
 eB3yPLP7fbu/p/FtIrgg2mGU/LS4qwrTqBqS/bC8WGuFYaOcXb2d2EFKc8qxiCR+BT/xa7BeMvu
 KO23u/GodyYLVXd1lRcLAQ6w=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f2798876e70ae443;
	Thu, 22 Oct 2026 17:37:06 +0000
X-Mizu-Trace-ID: f2798876e70ae443
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
Subject: Re: [PATCH v2 3/4] KVM: arm64: pkvm: Reset GICv3 LRs in the hypervisor
Date: Thu, 22 Oct 2026 18:37:05 +0100
Message-ID: <20261022173705.3729666-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022140048.2522787-4-vdonnefort@google.com>
References: <20261022140048.2522787-1-vdonnefort@google.com> <20261022140048.2522787-4-vdonnefort@google.com>
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

On Thu, 22 Oct 2026 15:00:47 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
> After the host is deprivileged, pKVM can't trust the host for resetting
> the vGIC LRs whose value is architecturally UNKNOWN when the CPU boots
> or resumes. Add a blanket cover in the CPU_ON/CPU_SUSPEND path.
>
> Fixes: cdf367192766 ("KVM: arm64: Intercept host's CPU_ON SMCs")

Could you point this at 1025c8c0c6ac ("KVM: arm64: Wrap the host with a
stage 2") instead? The message relies on the host not being trusted, and
that starts there.

[...]
> diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
[...]
> @@ -213,6 +213,10 @@ static void __noreturn __kvm_host_psci_cpu_entry(unsigned long pc, unsigned long
>          write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
>          write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
>  
> +        /* We can't trust the host to reset those registers */

nit: "those registers" -> "the LRs".

With the Fixes: tag updated:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
