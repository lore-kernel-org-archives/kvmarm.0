Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.167
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821174;
	b=RixrLamE0dx5vzEydriqdSzIAGIP4pixH3875x/ngMjRhjZ5HCC2zoUNoNgvkBSeAjl8
	 rGM8Pt42ry4y+eSmVhd7m9N0o4eF60QcVDgpxVpOu0ji+ubTlQW++GUxAoKr4PSNH2Nvi
	 xWM1GXrhVGxU6Y59dk4v6JUDrod1RvdJonG+S/bG4ePjhhYX93bwPIxqPwrTfXxSgwxXx
	 UFDmTyKSHQYp2MRegrj7aQWOLJgDUq0t5X8jewonkgvSteywujGABqoNol48mKRa02jvR
	 8c84R8X+0rM6o6YVNNmwTx65IxfddxV2z6YlCq2wzkpd5q5GzkWMo3FY+RC8xa6Xb8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821174;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=D7WbQXrrSrOg6sS9GtWj6hAsCJUVrDxUGniXvXJ1jxo=;
	b=Fab7VHV4bps99EYSYkNJWORxZiEOYyZcmbM9jW4dgvPbklI7DwIV7XPLr182wXlAYLTE
	 HboUwC0xi8CIR22ryNp3gtDEQX91UEoZ5CpVBbWz22rv/tqAEpL+wFaxJ5wgtZ4fUSKSt
	 Zh2h5csbxAQ2/DEFkHta2FknMB/vXjHfydxIxOgcr1Y2TGKc2JxIyPqNuSp6sOX/Ega3l
	 GpGGH+u4pUDAIjBfMNQi8Gcr8CghVbLCqZk4R1wGFzxZAmYW/1AFA/jGSKLKzNBVlqY1W
	 ydDvbcz/0S9zqg/i34y1s/k9v6Nu4bfClgWpsETd3o4GGejYqAMQg6oO+aKx9fxS1+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RaR16Qae;
	arc=none smtp.remote-ip=91.218.175.167
Received: from mta0.migadu.com (out-167.mta0.migadu.com [91.218.175.167])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA94606EEB1
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 19:39:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EA94606EEB1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RaR16Qae
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=74ExVBB+ei6S46cEXVQqMO9R7/DDzZNlWMQikqnEM6k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793821172; v=1; x=1794425972;
 b=RaR16QaeKpmq31kBMxJRXUxh/m1/qSf62Cz3hJ1XSOZvYJTFQoiF/JqWsDlRT/fWRVHVcK76
 3dGf964SgdC8Oj07UNR7SA5afAvWBZ4/8UrNuioHCC8oIFslAUdAncr0rVsyes0JlwBQ5GlmCTT
 NEQAglVJq9SSEhPQWJiEAHA4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 64b969e920bb14cf;
	Wed, 04 Nov 2026 19:39:32 +0000
X-Mizu-Trace-ID: 64b969e920bb14cf
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so1176e87.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Nov 2026 11:39:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxLVnwrGLgadm2JzNban7MygifuYjbkm1xrjzF5BUAQc0Eb0zBBb9oppndN01X00N27+o9jf5Y=@lists.linux.dev
X-Gm-Message-State: APuU4Z/WZbctQlYbsY+HhsJWN86j2vobAMaQhOOiwlFBWsA2n6GVJ+dS
	3fyCfF5ajf3Tuy3ojmCTKTia2i0BhlcFWdmnDZp9LsZilXhjQmiJr+qRWWi7aq/XPuNHNloK1EV
	Txv9WxAYoFErG8bs5X7kdLhMb7auuKij6FssQ1vEI
X-Received: by 2002:a05:6512:3dab:b0:5bf:ec8f:c361 with SMTP id
 2adb3069b0e04-5bff59a5dadmr217277e87.14.1793821166164; Wed, 04 Nov 2026
 11:39:26 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261104084842.132944-1-fuad.tabba@linux.dev> <aus8xb_xT64WKHDu@e143914.arm.com>
In-Reply-To: <aus8xb_xT64WKHDu@e143914.arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 4 Nov 2026 19:38:49 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxkaNRhiq6mFFZTODfntk_e_o4gYGOGrjDd7Ehj4R9nYQ@mail.gmail.com>
X-Gm-Features: AclHuK8riSEhzUcDf-9TQZh3Kvvf2G4Bq4PoB9O0DW_xpYQYnA8l-TCApe4f2jc
Message-ID: <CA+EHjTxkaNRhiq6mFFZTODfntk_e_o4gYGOGrjDd7Ehj4R9nYQ@mail.gmail.com>
Subject: Re: [PATCH 00/16] KVM: arm64: selftests: Tests for protected VMs
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Joey,

Thanks for sharing this.

On Wed, 04 Nov 2026 14:10:45 +0000, Joey Gouly <joey.gouly@arm.com> wrote:
[...]
> For example I also added a 'pre-boot' stub, which looks like your
> pvm-entry.S:
>
>         https://gitlab.arm.com/linux-arm/linux-jg/-/commit/cd3ae35d89974b02b7051a0c45cc68b4df8f9d3e
>
> However I extracted the registers needed for the stub like this:
>
>         https://gitlab.arm.com/linux-arm/linux-jg/-/commit/f559d5b61fa1a37e2d7b23704bd367e079cf8eae
>
> This is because the current Realm branch I'm working on top of rejects
> writes to those system registers (TCR_EL1, CPACR_EL1 etc). Which is why
> I had to modify these functions, along with __aarch64_vcpu_add() and
> some others.

When EL2 boots a protected guest, it takes only PC and X0 from the
host, so pvm-entry.S reads the registers from a block that X0 points
to, rather than from X0-X7 like your stub. I think a block would work
for a realm too, since your test sets X0. The trampoline also sets
VBAR_EL1 and passes X0-X7 on to the guest code, for tests that install
exception handlers or take arguments.

The host side of pKVM accepts those register writes, so pkvm.c creates
the vCPUs with aarch64_vcpu_add() as for any VM and reads the
registers back, SP_EL1 and VBAR_EL1 included.

> I'm not sure how much there is to gain by sharing overall, but good to
> bring it up early!

Thanks again for raising it. I'd keep this series as it is for now.
When you post the realm tests, would it make sense for you to move the
trampoline and its boot-args block to neutral names and boot the realm
tests through them, with your register extraction in the same series?
Patch 2 is close to your "Allow VM types for arm64", but allows only
KVM_VM_TYPE_ARM_PROTECTED, so you'd only need to add the realm type to
that check.

Cheers,
/fuad
