Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.164
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793002217;
	b=0S7cJbSeV6b/P1SyUvI6w2CVjolTtuvx0tNxcEvyR5FCigBUObx937by9wMdytw2nyql
	 dxateYM5+I2nQFlFj/kvWKcye0q5LEj7vv+IJnvzfWhBwNgOiFh4QT8lOJ94/vRU/wDZo
	 c5OKZOickCv34OUo03KxuQsibzr4COD+VljgLD8UOwHYekMZrQ7b9UIDGP6SRV5EY8BB8
	 rLeXMMp5UHtMG38Dug6C1jCRdAgkZi8TC9TqwXXCG1eGaBJrSBKXFX51klqNU0nv3Tkk3
	 +glGEXMFe0wWNth+kJ1wdsOfZbUjP4prT5Go8gsp8UBFt7R7UKSldLJ7aPxUER8xd2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793002217;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=SU/p59HmrY1l63uWO1J6fBGj9iSaP1sfb4BVk3OH0dM=;
	b=Vx3it4liRarEOxLOmiIEjhSjCq+s7rP1HP9pD8AJ5DRfbZggn3pciexFR6nC0kieM3kx
	 T8b/nf8FL4sgqleizKCRtWt/yS3RedCC0YgJc0LHUHHP6y/12Ad+1O9k+wYJW1FAM2t6I
	 HFnon43wyWCVrtU83L+7aqVvwauCRT9TXCsiAlBvL2plhyJXHfcMQi3DRbBbmYq/ptAWi
	 gRAwiPCoz9HpPrchnCR1SKhfjz3qpvbN/NltVgbZM5KfOWedGdkE2nYJc1a0ju+A9aTrx
	 WkGJgCuqmYfMLctOW/Mgaj2GKhb48lXBLHnCZFqpoz/P6SnZbbo/YYYoRWFQZ3PcBfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IKwTMNBB;
	arc=none smtp.remote-ip=95.215.58.164
Received: from mta1.migadu.com (out-164.mta1.migadu.com [95.215.58.164])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FDB606A31B
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 08:10:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47FDB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IKwTMNBB
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=SU/p59HmrY1l63uWO1J6fBGj9iSaP1sfb4BVk3OH0dM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793002214; v=1; x=1793607014;
 b=IKwTMNBBdmWKpHjheWFZJq3uoV7qkN5IJyqGvLMCMrt2zioAB6uMFBPi2vX2+2Gr5Tmhbhaz
 cdxhhMvpy4OMKaP7NC/afC66OZxjD46mNCWm5bnTvaTqSFK4xkrEOOlO7+GEbS5ibtyGdutm3ag
 LF+mfpd2UFcbdEBJmRANHNjM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8a91e0dbf356b706;
	Mon, 26 Oct 2026 08:10:14 +0000
X-Mizu-Trace-ID: 8a91e0dbf356b706
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so8552e87.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 01:10:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwZ4YOpTN2skEVyY9/zwEzkWPrsCKkrDtmL9Bt11IP+XlZul+0QtNLBZI+2ye3BBLC5zwtNfY8=@lists.linux.dev
X-Gm-Message-State: AFq9FYIeGn8rRWgmJ0VZdbdEdpIMzzcqY6khzU/9KIMmjqMrvHtyB2nx
	sM+JLl3/cMu1DDcv4ocqjIujYaegPaMzfESbnCDrgdZHW5UNkss81xRNTKmXlfQsUtrgkbe3CZs
	dBg5MCjjfNxdgk+gGLUUTxAk7GMZzRTl9o1h1ekQ2
X-Received: by 2002:a05:6512:3f03:b0:5bf:a28a:f2d9 with SMTP id
 2adb3069b0e04-5bfb79dafd3mr111700e87.4.1793002210084; Mon, 26 Oct 2026
 01:10:10 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261026012128.2270251-1-sashal@kernel.org>
In-Reply-To: <20261026012128.2270251-1-sashal@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 26 Oct 2026 08:09:33 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzF5PsNt+riasW-SK-nhkLYh3kojMFyCEqs372-Mficnw@mail.gmail.com>
X-Gm-Features: AclHuK9ieRbKRZ3vlLRpK7x9lOVSGw-njZY_CzO5qLbrpHOtyOHbR5m8v7LhEMQ
Message-ID: <CA+EHjTzF5PsNt+riasW-SK-nhkLYh3kojMFyCEqs372-Mficnw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: selftests: Skip unwritable ID fields in
 the failed-run test
To: Sasha Levin <sashal@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Mark Brown <broonie@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sasha,

On Mon, 26 Oct 2026 01:21:28 +0000, Sasha Levin <sashal@kernel.org> wrote:
> test_idreg_frozen_after_failed_run() checks that changing a feature ID
> register after a failed first KVM_RUN is rejected with -EBUSY, and does
> so for every field of every register in test_regs.
[...]

I tested v2 on the FVP AEM model configured with no AArch32 at any EL
and with PMUv3, under nVHE: set_id_regs fails on ID_DFR0_EL1_PerfMon
without this patch and passes with it. It also passes on QEMU (which
supports AArch32 at EL0) under VHE, nVHE and pKVM.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
