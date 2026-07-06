Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3C3389111
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 21:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783373555; cv=none; b=Qvlwc3GqEoQEO1TH5bml6/YGR4u4mk6dW89+pVkB8t/JSb8M3IXZuyI2reMZj5n3hoHPtkZ30nsSPCrkQdJe4kPbVlQc/EsQB7ffIodS52kGnV9l2jW1rG/VHUocfzYhlXftbjDqJc9qzYvJFxH/Qn3ngEUpqD069B4Zb1wT574=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783373555; c=relaxed/simple;
	bh=/dYMC4TsSnaaozbxuhxnl8PamyI6atTK96Kpm82VMT8=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ibTPRYIlxHGXOSZYRAJUCXX/q1Xt9iO5pA/HuH4ODY/XkhFI8qu1i0R9Qz4dKmdd4VXG2ULlI7rcCNJlbZXNOHQHGl+EdsjVskR5c8U4UTSzE+7TUBlGyIDXkLB7qK9vMFc4ERcI1I7NZtrneobWTOnSA12TR33rAcfWdmjl/2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J8LSqoL1; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J8LSqoL1"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7eb89852728so1726511a34.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 14:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783373553; x=1783978353; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MXM42XRsNruvqY2Vgb884XDt0as+6A4qsiGUbLElGzc=;
        b=J8LSqoL1DbfAGhh2PHiuy1+MQoZE+6hZ1SuRnbSKEIPzvrCdFtsoD6KV3xVmV/V2gT
         xgMEdEgpQ8ft+ITe0/pOaWvjV08B5jyW1sLR3Lj6gDMSMie/otN2WL2gl43qEPoR0X2W
         tgwmSlXOdzTXh9qsLhEeAdW1cdrbGdG66lp7BRNV7zSiirvrMLrCuNrLXmu9wi7VF9+S
         G8kq/aYBkvcmVonpt5aBVpwFggOM++U7U7slAMp3QhaLzb1kgp6b3wDenRIbRVYLT4ay
         kJ3PMPB14PT9CZWvV0N+zANrEvjZdLksU04bpgAos1QCamjDd+V6DGYl2PdlSL0pEJnX
         iVlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783373553; x=1783978353;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MXM42XRsNruvqY2Vgb884XDt0as+6A4qsiGUbLElGzc=;
        b=J5TaEn2qN6Qc0zrKmm+vRhtyfPhsWgUxx1kNwDVLA40qBnEMaKe4tY5RkkwCYyEUT5
         QlFh++jR3ddTJF6JpnMX5HIUJiK2hBprS2i3rAE5FXYjOory9hb9pbBFA4CjidTJ9jsy
         hbmx6NPn67jNbyEGEYetVSV3Ng9qIXnvE+WvJPN2Q8eMJk6W/UHzBEdk0fraDepCRDse
         A3uSWYCFUBKyH+4iWBRp9MkgWOug6TRWs/Fw5/H/Yu2pXfxO0N88ehQjqHp8huTCBs50
         M9kzjzhHMjpRAzy3x+7R3OZLK7fJ2ugu2+53mbabjnXNk7pHfDFBwNhym24C/dIZN+pp
         UEnA==
X-Forwarded-Encrypted: i=1; AFNElJ/TnQIYGHZDitqrZQBtwn1KpJw6CU+uVn+4Q9siuPZRNeBl/zG386USCAhPV+DSZkwguENE0/Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWYazGW8Nu8Y5wD+JENggotfR8fqFEsS6gPB8EsdaEPRS1hqU2
	KFIDt6ydDu2dEipa5ay8KnVrxb7ad9l8TT9EC4sK/elC+3z8s07bXm+JPsoX8Aq+RMaLmG73VF6
	+GIj6iA5IA98y40oUaeQ9JNdGzA==
X-Received: from iljr8.prod.google.com ([2002:a05:6e02:1088:b0:503:bc46:aeaf])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:178d:b0:6a2:92a3:d1e7 with SMTP id 006d021491bc7-6a3554fa67amr1473951eaf.3.1783373552699;
 Mon, 06 Jul 2026 14:32:32 -0700 (PDT)
Date: Mon, 06 Jul 2026 21:32:32 +0000
In-Reply-To: <akWqXBJrJ1n34BQ5@kernel.org> (message from Oliver Upton on Wed,
 1 Jul 2026 17:01:32 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnto6gj6byn.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 0/5] Backport ARM64 VHE boot fixes to 6.6.y
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: stable@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mizhang@google.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oupton@kernel.org> writes:

> Circling back around...

> On Wed, Jul 01, 2026 at 04:23:21PM -0700, Oliver Upton wrote:
>> The subject prefix should be "[PATCH 6.6 0/5]" so people know right up
>> front where this is going.

>> On Wed, Jul 01, 2026 at 08:43:37PM +0000, Colton Lewis wrote:
>> > This series backports VHE CPU boot fixes to the 6.6.y stable branch.
>> >
>> > These fixes are already present in the 6.12.y stable branch (and
>> > newer), but are missing in 6.6.y. They are required to enable booting
>> > L1 guests with nested virtualization enabled (kvm-arm.mode=nested).

>> It's a bit worse than this. The architecture retroactively made
>> FEAT_E2H0 an optional feature, there are now implementations in the wild
>> that do not support the feature.

>> > Without these patches, a 6.6.y guest boots with HCR_EL2.E2H
>> > incorrectly configured (because it misses VHE-only detection or early
>> > initialization), causing early boot hangs/trap loops.
>> >
>> > Conflict resolutions:
>> > - Patch 4 (KVM: arm64: Initialize HCR_EL2.E2H early) had conflicts in
>> >   arch/arm64/kvm/hyp/nvhe/hyp-init.S due to differences in state
>> >   initialization. Resolved by extracting EL2 state initialization into
>> >   __kvm_init_el2_state.
>> > - Patch 5 (arm64: Revamp HCR_EL2.E2H RES1 detection) had conflicts in
>> >   arch/arm64/include/asm/el2_setup.h. Resolved by using raw msr hcr_el2
>> >   instead of the missing msr_hcr_el2 macro.
>> >
>> >
>> > Marc Zyngier (4):
>> >   arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
>> >   arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is
>> >     negative
>> >   arm64: Fix early handling of FEAT_E2H0 not being implemented
>> >   arm64: Revamp HCR_EL2.E2H RES1 detection
>> >
>> > Mark Rutland (1):
>> >   KVM: arm64: Initialize HCR_EL2.E2H early

> Please go through and correct all of the SHA1s for the cherry-picks,
> smells like some LLM just hallucinated some bits given how close they
> are to the real deal.

That is what happened. Sorry about that. I thought I double checked
those but I missed at least one.

> I also want to see that all KVM modes have been tested (nVHE, hVHE, VHE,
> protected) before this gets picked up. Overall though taking this to
> stable seems like the right thing to do.

I'll make sure to test all those modes.

> Any reason why you've only done 6.6? The kernel was first aware of
> E2H=RES1 as far back as 5.13.

My reason for only doing 6.6 is when I tried to boot an L1 nested guest
with these patches on 6.1 I ran into another boot hang I haven't yet
debugged, and I didn't see the point in applying to 6.1 or earlier if
it's not enabling the behavior we want.

> Thanks,
> Oliver
