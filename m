Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917316;
	b=SFBkgmps1tnzhayBRZklSaHCxNOBOL1MLCaGUyRZarQ42OvXwxJTON+nTeudmeg8B2Nn
	 JuewsCFwygyvz7K++dAKq2W8D2oPbXwWgGmzHkrUn0fTPsR/QSFJdVpcvf0OFhoJOKPXj
	 PhGjOTw0QDArHRZcL7AJZ50/XFcLsz1B3J0yQKwvV8UBciS+MtMBnrp/6bnxYG+ta40yC
	 wITOalbRgi6h9Ym2dbLlVYBedAf5dlg6wLfphi7L4LHvJfwdkKJWDsStNXYelsIvEiD3e
	 XCF4ENg94oMDGp+oaIweqNfIlYMOIIt13yQduGn8UNrNf96XrgxzG/sasTi58Bj1GVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917316;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=Umtx2QekNJJOh/UY3thL10Al6ydHDa8XNgIJCQa01dk=;
	b=N+5ZKfi/V3BPs52fqCGofa1B9k6qfy3/yuyCdRaTq4QcWhtacolp6bEtZVoPGJXflxZ7
	 Cwh8yJDkHt/kVQnc3vgbWKco49Lst8vxsxvxdkzvQJ1b4V6WHN+3PJT8YfneWT2UqEmN5
	 GLQIzKh9wHEL4vC5kSTAFWMPxv04wSvSw9ZydOEnHaeIHiQy91i5Kdgd2RvYCJ29pwfFM
	 w7+cVPaqIQzWTJAOjLo62NxxUuUK/lDEjPsX4SOKc+dOiD0GFWZKnOuDVahii93VwC75x
	 isrVnQfq0WbZu1lRrdgJ4HPEBINcTan9dQYngJx0b9guof1FLpTDQs3ZqZcWNrqiY2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HwWbrWr5;
	arc=none smtp.remote-ip=91.218.175.51
Received: from mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C573E606A31B
	for <kvmarm@lists.linux.dev>; Sun, 25 Oct 2026 08:35:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C573E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HwWbrWr5
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Umtx2QekNJJOh/UY3thL10Al6ydHDa8XNgIJCQa01dk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917312; v=1; x=1793522112;
 b=HwWbrWr5kH39BlfikdLrFRyIbdJ1SbM/25MQ0oJN7Kxw2ZeucgCjJrW9BeMyajcuruWsvBXD
 UCCAlVmD2sJeqgj0zVacQGoE3ND93S850cPquuJy79YAKXFTU/bWuTf7/Q6YF9+dtyDBlBf0g2t
 rOrY2GFtgFC6soU5zT/EwhQw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id da69f8b779b306d2;
	Sun, 25 Oct 2026 08:35:12 +0000
X-Mizu-Trace-ID: da69f8b779b306d2
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so3997e87.1
        for <kvmarm@lists.linux.dev>; Sun, 25 Oct 2026 01:35:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwgn2e8nAHBzrjhKhtIIAQgrxG7/A6WhWI5/aAvP6EaZgsvvARZocxB43NonHvw2lGrzH8G+Qc=@lists.linux.dev
X-Gm-Message-State: AFq9FYKBzSrM1n5+AFbdiSoEk/UkLlChsupJa+Lsr3TbM5AxTrGk+3mQ
	Td/exG0cScFFc9F1ij5abL1MeQ3JdfVAag++f6S3Sg6CtxjV4HaYunuqzAgYgoeDsUJW32PTsPg
	kkmw6j3y25tYYz5DQlkKhT1NHCXESQ07gkIRhFFmI
X-Received: by 2002:a05:6512:3a8a:b0:5bb:ff6f:b4bd with SMTP id
 2adb3069b0e04-5bfb79cfb9dmr89930e87.14.1792917307506; Sun, 25 Oct 2026
 01:35:07 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261024161118.1007472-1-sashal@kernel.org>
In-Reply-To: <20261024161118.1007472-1-sashal@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 25 Oct 2026 08:34:31 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxKRThB+kp33nALkEejj2L8vDxE=SZYw+0KyHodYu0y8g@mail.gmail.com>
X-Gm-Features: AclHuK_kP_F3xF9Iyo3ZWQZWl_t2OJWVWAHcLTFVaYw38-o0EI2yWRjxxMOJhA0
Message-ID: <CA+EHjTxKRThB+kp33nALkEejj2L8vDxE=SZYw+0KyHodYu0y8g@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Skip ignored AArch32 ID regs in
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

On Sat, 24 Oct 2026 17:11:18 +0100, Sasha Levin <sashal@kernel.org> wrote:
> test_idreg_frozen_after_failed_run() checks that changing a feature ID
> register after a failed first KVM_RUN is rejected with -EBUSY, and does
> so for every register in test_regs.
[...]

I reproduced this on the FVP AEM model configured with no AArch32 at
any EL and with PMUv3, under nVHE: set_id_regs fails on
ID_DFR0_EL1_PerfMon without this patch and passes with it. It also
passes on QEMU (which supports AArch32 at EL0) under VHE, nVHE and
pKVM.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
