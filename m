Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795466977;
	b=XhqscJXTb1zwFP39py+b1o1kMQQrsoqL/LfmdFlCzf7qXD4RLD6+jYz7W9LOCMtrDJkL
	 dgcauEQBbR/0tfr4NBmfpIrpm6bOnNa34ZQmsauEy+PKSAGjgbTeyfKU12hWVOK7WygSn
	 OIJLInGO7uppQKqsqjYGY25C1omEH6Ak0OTUySermjxQ0CrgHe5re16pvvIPXscbw6Bzk
	 6E/8RBMbTgqTQARDbjUD7vR2G1UHtyb4sAmgVzlLmEQQRhJzZ9T8Pb/2l6mEMCCI84LnN
	 5aJtnQQ+QC0O7pJv/JMd9E9+c+pn2Dfac9w7Z6DWY1yj9/QSDpt9Dip0gInVFu3QpHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795466977;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=nCuQjurNkBrhODlJsMeLvakirNJPuuoj5LNhLM7ENoU=;
	b=SONGkEJEoEwaXxDN/WIJWUax3A8oYmTSMlhq8822mW29232/fKLQXK98Nqm1kJsuIFKp
	 X9aljl3+l/Dt5SIVyv47EuuPfyW+BEx3apwCZqNcA2pvRZGYP1z3FWGV2brlIHoyFzSX1
	 MmWrX/osaQxcgk/HEArveaL/CMWYbItQT0XI/wDN4iAEhyJuJOxaccH4fDb6IlERuXiR8
	 sU3hhhau4mek499tXxN6IPVL6BPtdj3dUBPGSIX48eX+77c5mhSVEOLkuDttx8F5eOz6Q
	 jNC1q0mPjspYqJzNPtVx1vOLgS69br0Murs+9aJoiaNDfkCicPxf2qz+DoWZ4P4d6OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="O/3QUpj7";
	arc=none smtp.remote-ip=91.218.175.250
Received: from mta0.migadu.com (out-250.mta0.migadu.com [91.218.175.250])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605C7606A32E
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 20:49:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 605C7606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=O/3QUpj7
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=GslayrUh5jOBi24MwEsHAPtHoCFsndl70v3CwuOZjbo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795466973; v=1; x=1796071773;
 b=O/3QUpj79NN6szAzFo0J86znmfO39518t7kutEZ3jS+eaOk44Q4yM7ig0PvFg4zWFV6aH6m6
 Zerex8IPVjxiUnSmg5nBJM5BSkYcItnYL+f0/oi1F7t44MvBup3NHww+Tb2LmAE9xuSbKRxXu9U
 y2nPCL4aEJ46mqXUatlMPwoI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 98396ef65a17ebee;
	Mon, 23 Nov 2026 20:49:33 +0000
X-Mizu-Trace-ID: 98396ef65a17ebee
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so13213e87.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 12:49:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHAVRuSCeAAEdWOsz+Y60Ujv6Tkhswn8gStoIpbv4qz0HhV0WleX1qEyHMm0ah+NeNVpjeXOXY=@lists.linux.dev
X-Gm-Message-State: APuU4Z8JRMQBZfIa7RLpGaEe9VIeb/GieSGkgtX3Z9rzDvZgba29R2BG
	Im95jw3L/GM6EZAcc+pyLseU5VmD/NjEJJSGg7LrwAHE1dXGJ1kp77gPdw8zYBGC5VdY/Bfjm0L
	fkr7TLqIawpYC7Uho0ar+lw7fXJFG2eI77Rx+Mnxh
X-Received: by 2002:a05:6512:32c8:b0:5bf:b994:6598 with SMTP id
 2adb3069b0e04-5c21a1ebb99mr287911e87.6.1795466971954; Mon, 23 Nov 2026
 12:49:31 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com> <20261117174403.58762-22-vdonnefort@google.com>
In-Reply-To: <20261117174403.58762-22-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 23 Nov 2026 20:49:00 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzZkAf8+BGNH15TKCEYUyO=VFvGSeJg5hfaFoefNOTVpg@mail.gmail.com>
X-Gm-Features: Aa3M54r9cn_5IcZ4PEjyUKyB1amw4J-LOqeK80O8c1MAQXjvtC5KEKyQbMQd49U
Message-ID: <CA+EHjTzZkAf8+BGNH15TKCEYUyO=VFvGSeJg5hfaFoefNOTVpg@mail.gmail.com>
Subject: Re: [PATCH v4 21/23] KVM: arm64: Add PKVM_HYP_REQ_SPLIT
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com, weilin.chang@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Tue, 17 Nov 2026 17:44:00 +0000, Vincent Donnefort
<vdonnefort@google.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index c55b6d442d0e..58ca7ffa68e3 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
[...]
> +static int __pkvm_pgtable_stage2_split(struct kvm_vcpu *vcpu, phys_addr_t ipa, u64 size)
> +{
[...]
> +        ret = folio_add_pins(page_folio(pfn_to_page(mapping->pfn)), nr_pages);
> +        if (ret)
> +                goto unlock_mmu;
> +
> +        ret = kvm_call_hyp_nvhe(__pkvm_host_split_guest, gpa_to_gfn(ipa), size / PAGE_SIZE);
> +        if (ret) {
> +                for (int i = 0; i < nr_pages; i++)
> +                        unpin_user_page(pfn_to_page(mapping->pfn + 1 + i));
> +                goto unlock_mmu;
> +        }

Could you use unpin_user_folio() here, to mirror folio_add_pins()?

[...]
> @@ -765,6 +890,23 @@ bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
>          return !ret || ret == -EAGAIN;
>  }
>
> +static int pkvm_hyp_req_handle_split(struct kvm_vcpu *vcpu, u64 gfn, u64 nr_pages)
> +{
> +        phys_addr_t addr = ALIGN_DOWN(gfn << PAGE_SHIFT, PMD_SIZE);
> +        phys_addr_t end = ALIGN((gfn + nr_pages) << PAGE_SHIFT, PMD_SIZE);
> +
> +        while (addr < end) {
> +                int ret = __pkvm_pgtable_stage2_split(vcpu, addr, PMD_SIZE);

Could you drop nr_pages from the split request? Patch 22, the only place
that raises it, passes 1, so this loop runs once.

Cheers,
/fuad
