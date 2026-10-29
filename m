Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793264064;
	b=oQVPDd3vadm55bDFkHLPO3WRm39SWKMQXiaKwospID+w0ZI7Dwdgb0ZPK7vNUxE8Bjjg
	 XnUoa8GTwfK+uobuGfOEF5nKwEx/jmcmfXbfG2CJNgQDGMAVgJIfJMlwBvdmnqA83z2vK
	 OZhFuBKb8dSlYS6q0vnS6DNNGM+K+EpHNr4X3a5BFtUv+7iTqq6vvcuQI5nA+j4jTTduy
	 f545fijJMbi//8FLV2S82jagsOOr7LLXu0vfsNZDvdQvzFPs5Suh9EXfGaw3p2hHIks9r
	 sPrHGCZxUMi8CoAKegZApexyVIN+V5413cFk8dFqKFXuC1kaYu4C2/ivY7+2X+1NOuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793264064;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kpm89XioXXnsTWzJsIlmeTzj5KiGn1VrgU9z1qz9vOk=;
	b=pxea7WiCgfNoII4eQMxNHOWAgyUCRk/MCNgU8wj667rOLrOtKuHuzDn04pZLB8vQlMf1
	 0Ziv/fsLSjV1PrgGc5nO+qF+SMWigEmn7KkOiX4+bHwI8H0HcwPZNHXp7jzE3zRRhQwA3
	 +3p9eO1Ty5OX/bgh1WgClvN/yGIpxqIvZnRKC662vFJcin5WPIGbK1aAwpArikQ97Ah1J
	 2ap9pzjeAztHdLHJJZTtDYVpQHvQ2RlqbdT3sMAb9f94wIFOWj902pdT5604d6JKsDhhb
	 szLnj0INIxxy8y5aFVziCMRoVOD+jMLVFhr/DdH9SKw3o83kmjVmZAhmcZth/cKUZUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="eff/UEkS";
	arc=none smtp.remote-ip=91.218.175.45
Received: from mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71CA606A31D
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 08:54:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A71CA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eff/UEkS
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ctrBwXQvS1M9yecPf1fWtqcUruy7KRm5Qjr3D6oimXs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793264060; v=1; x=1793868860;
 b=eff/UEkSgCt3RsVBav8UPUofePVEzgdIjPSZ3BT9y+e48I6KvqNEyKUd1hiRAJT9mpQenVeU
 PPzbLB0BBip6x06BBdkis5xmRzqwIEjQ2w3jX3wMHvYwyDsFC075ceyRjTcehEO0KI9Mayd74e5
 CclxNeni8WI0VW9Kh3vjYKEk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 615dd020fd29c127;
	Thu, 29 Oct 2026 08:54:20 +0000
X-Mizu-Trace-ID: 615dd020fd29c127
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: xuheng@cs.columbia.edu
Cc: maz@kernel.org,
	oupton@kernel.org,
	qperret@google.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Add an ISB after mapping a hyp fixmap slot
Date: Thu, 29 Oct 2026 08:54:14 +0000
Message-ID: <20261029085414.2279900-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028-fixmap-isb-v1-1-6c9f0f9cb810@cs.columbia.edu>
References: <20261028-fixmap-isb-v1-1-6c9f0f9cb810@cs.columbia.edu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Xuheng,

On Wed, 28 Oct 2026 23:02:10 +0000, Xuheng Li <xuheng@cs.columbia.edu> wrote:
[...]
> A litmus test of the same shape (map the slot, DSB ISHST, load through
> it) faulted on a Cortex-A72 in 2 out of 100M runs.  Arm's herd7 model
> with -variant vmsa also allows the fault, and forbids it once the ISB
> is added.

nit: it would help to have the litmus test itself in the commit message,
or as a commit note, so the herd7 claim can be checked. Here's the one I
ran (herd7 7.58, -variant vmsa): "Sometimes" as below, "Never" with an
ISB after the DSB, and "Never" without the ISB under -variant vmsa,ETS2.

	AArch64 fixmap-noisb
	{
	 [PTE(x)]=(oa:PA(x), valid:0);
	 0:X1=PTE(x); 0:X2=(oa:PA(x)); 0:X3=x;
	}
	 P0           ;
	 STR X2,[X1]  ;
	 DSB ISHST    ;
	 LDR W4,[X3]  ;
	exists (fault(P0,x))

FWIW, the result matches the ARM ARM (B2.3: without FEAT_ETS2, a DSB ST
doesn't order an earlier store before a later translation table walk),
and emit_pte_barriers() in arch/arm64/include/asm/pgtable.h has the same
dsb(ishst) plus isb() after making a kernel pte valid, for the same
reason.

[...]

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Tested in protected mode on QEMU, booting a protected and a
non-protected guest, and on an Apple M4 (nested virtualization),
booting a protected guest. No regressions.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
