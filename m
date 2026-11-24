Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795513465;
	b=dY3opmwr0A0M282D3oTNC7g1SQ20LjNx4P16gsyWf8IaxbuImdC/GBkt5757LNI7Aqv/
	 f/p2xUqgNiK6IGdEBxIvtaeQ88B5HVdkJ7BiRYRl0/yzHHi+N6aLs11sfpB8cqgBp0lSA
	 vs90b1qIhQM/0xfM6KQr3+fDd1xDus6MUtoAGS5/Q3iyzM/IhAldKc0M5cLfFvzQXHn7F
	 owHh/nEdZl/QqDHwQeT5zWBxEYb9undfmZa9FXmUcsAqtZMwgLR6q/so4Ai5sVI6MTTPq
	 AMTVPKl0xlECtZMtHhlMhCXW2aDVWspFKknUTvGPj+S3PF2Mkh0L7RyjPFB5sAwfKtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795513465;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=t2pMZHTPWQHTXaMIuwvZv4SwKto2BO2qab0ldpAoWoc=;
	b=T69icLEJ2+mtRKJowF1cHS2nMJTbXSD7hVMA3lYJjKCD/eSHuKM72hGJVxfMdXvmuRhQ
	 cLlxvUzYLLvOnQ3MKBPYnmR5wMOKDi9DL+Jwm9VrCcOWjVGlG0Rn4SXCSjl+VWOddMqpN
	 Z3CDP765/qPor8zR+kb/SIIRoLMRNKQoikQxXooKDZqTcjFyapigI/7zV+D3xqa6moA0G
	 Y1RtCI3DpNUrasyHzJ8XelUUqpwklccgu/GdeHLreY3RPiZ2z/Mz8CpUQjYwHInyD9D/n
	 pcgGhHvE4fPDYgH+2eA8CfY5uZ77rdO/jH8jPV4A4fXZB7XpILzlSUhQkUcIEgRmlBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tcc81SHn;
	arc=none smtp.remote-ip=91.218.175.155
Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67852606A6AC
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 09:44:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67852606A6AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tcc81SHn
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=t2pMZHTPWQHTXaMIuwvZv4SwKto2BO2qab0ldpAoWoc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795513462; v=1; x=1796118262;
 b=tcc81SHngnUZu2BwMqJZpcOvHE0fcrLU6Rr1jcxJnosGkwmCvSOG7FCgVVvsJvkAWYMywRuI
 c8WS2OM2T4u3gQ0tZmFfU50BhZTbSlS3wFuMqbipu+RwgajemwGmnOpOBHSmIyZsWvlOUl+M21m
 PUbH7VDpidN4tq/qv4HFXFn8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0cf8cee370bf1985;
	Tue, 24 Nov 2026 09:44:22 +0000
X-Mizu-Trace-ID: 0cf8cee370bf1985
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c00d7ac49dso16232e87.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 01:44:22 -0800 (PST)
X-Gm-Message-State: APuU4Z+etc4zzSicoX5ixJOMSj4dPaEq7rMP4T/WRGo4rrHyV/4Gv0d4
	AJyOtvFkPOIr1RBeQlwHjJbeZh1t4g/YatZhiWUq7bwnAue5bmrlU2aG3ALD8PwI/+TAXp8Cofy
	zRhX/igq1JniJXIC9TMNNs15MUCuZGxAyFn+J6qcL
X-Received: by 2002:a05:6512:1282:b0:5c1:a880:e5b9 with SMTP id
 2adb3069b0e04-5c1fbb1e9acmr387548e87.7.1795513461120; Tue, 24 Nov 2026
 01:44:21 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261123192457.8700-1-maz@kernel.org>
In-Reply-To: <20261123192457.8700-1-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 24 Nov 2026 09:44:00 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyton41ATTfGNDdF7KU0_9xvGuPx_EP=TeA7n8cMuA-2g@mail.gmail.com>
X-Gm-Features: Aa3M54pK544jqTysiDZQ3nSJIC4yYFvop17y-HAYPW-8_pI4HirsHCc0nJyGc48
Message-ID: <CA+EHjTyton41ATTfGNDdF7KU0_9xvGuPx_EP=TeA7n8cMuA-2g@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Convert GIC idreg sanitisation to the
 confic framework
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 23 Nov 2026 19:24:54 +0000, Marc Zyngier <maz@kernel.org> wrote:
> Having started adding some sanitisation code in the idreg department
> with ID_AA64MMFR3_EL1.S1P[IO]E, I'm back with some more and trying to
> wrestle the GIC into submission...
[...]

Tested on QEMU, booting protected and non-protected guests on pKVM,
nVHE and VHE hosts, and running the set_id_regs, vgic_init and no-vgic
selftests on the nVHE and VHE hosts. Also ran the vgic_v5 selftest on
FVP, with and without GCIE_LEGACY.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
