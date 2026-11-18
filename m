Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.192
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794999503;
	b=bchCu8KuwDN5k4xfU42S5a6X1Q3adA+J4cdUPC+axKpZal0k7Bo3FwxDIX+Xhdir4FF5
	 VWFtHiCv//4HsmoB4F2KQvGB9P3RMgMVNxrd+23+vSXZMTdfQIHMsPdgdlyliKGKpVcbK
	 92bJucvlmUh+tjJcpEHvXhB4Bh5+yCv7WCKZUhwEMR3q6PJ8qNTiKdLGCnR0UbMMe2Kcf
	 yUGN/7kTlRz7X/rqN3QbU2I3DlZIel6XBRzJoE7YAwd6cbhilhXcTzpGVgS5GDb6qHQXD
	 T1WuYbTdIWzfsAUZL2Dcy0WPW/72+yBtpyNMJCOolLqIv7kcVjY2TSt+VHEwkG31W8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794999503;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=ji0Sy7yk69gklaMPP5Zc2g+qgmHVYq7bGDR02Mw+y7w=;
	b=1VBq1S5PizTvNjItJXQ/6nbWKxgA0Jsm/nSTut0t7dR32+UJemsyiRfanb/6AuNZ2AL4
	 I7B3Oh10VkLUXTSb/bvqcK8EizWO46BjPe+Hi5nGUtksMYqIcO4DI8S4uUmUqrA6Zg0MY
	 NxNzwyJcWHujh4iVs4UWHKQpC1JWRWQdBOdNKgWJPBzE5/05UO55NtUNG98MPm2bGWR97
	 akfqAUsx5JZ4kjHGl1DDrnxg1ZN4lvtptbSEEMMQcXrMEnMsSjWMzKr49M2dp94oXsls+
	 zy7n+98IAG+RKQQ6yPBGNJQ4dZyT2Pi9VI86WqxGdMPavKKR4HbVFqgwo5QyW8DmmWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vt+IfZIZ;
	arc=none smtp.remote-ip=95.215.58.192
Received: from mta1.migadu.com (out-192.mta1.migadu.com [95.215.58.192])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76FA606A325
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 10:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A76FA606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vt+IfZIZ
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ji0Sy7yk69gklaMPP5Zc2g+qgmHVYq7bGDR02Mw+y7w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794999500; v=1; x=1795604300;
 b=vt+IfZIZJOS0URSsZzPpdtdsks8eAAoXxtanAnia9tpoLGYih90ndeL65criPFR/mMaeZzbf
 uzD1nRpduIpEsqu6Fxvs3Q1n9Z22EIz+r2sA3w68RgfwEhFr9pVOp1v3bW/3HKMBCT+aNvk+OZG
 lEpOXQMrET0YpQ+nqPVdmU4U=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id df8d333ee19203cc;
	Wed, 18 Nov 2026 10:58:20 +0000
X-Mizu-Trace-ID: df8d333ee19203cc
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so6826e87.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 02:58:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGwdjoaBrEodKtiUvIqbcA3uaJd8udaCuhW0D8eTYcEXlKqjd2AQJgwyLffEvsLR3zija1gWOs=@lists.linux.dev
X-Gm-Message-State: APuU4Z8C4wWpOzRiQhsLPJjehQrE4kEdBuj1BDlEs1X6svWaBdWh+RdL
	BO/avWUKITuMtc8xINeXTEZZbQM8HfIOlpsFjO46J2XizSGhW5MjiK7o6k3vYevrruwksAcQIwc
	K2TEJ9vDqsi+CtgQUxJuTEKrdxJduuoJ6ZY71awv3
X-Received: by 2002:a05:6512:2346:b0:5c1:6e17:16fc with SMTP id
 2adb3069b0e04-5c1a985f78cmr169644e87.2.1794999499497; Wed, 18 Nov 2026
 02:58:19 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261109084854.840576-1-fuad.tabba@linux.dev> <20261109084854.840576-2-fuad.tabba@linux.dev>
 <86bj7n1bzx.wl-maz@kernel.org> <CA+EHjTwJ9XTCfrfBLgGjed3GrRtiTnk-ErvPSwU-AhvyTVcnsw@mail.gmail.com>
 <867bia1kab.wl-maz@kernel.org>
In-Reply-To: <867bia1kab.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 18 Nov 2026 10:57:43 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxMVXR11s5_U5144hdpYStkd1-gi1P2HK6DLnn5D4RW8Q@mail.gmail.com>
X-Gm-Features: AclHuK8nMc23WqG7bzjhLPz1LETcOHXAsv2Kso31Kz9QH-6JXZhmhiORkbvHHMI
Message-ID: <CA+EHjTxMVXR11s5_U5144hdpYStkd1-gi1P2HK6DLnn5D4RW8Q@mail.gmail.com>
Subject: Re: [PATCH v2 01/19] KVM: arm64: Hide generic ptrauth from protected
 VMs without ptrauth
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 18 Nov 2026 at 10:55, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > It's in this one because pkvm_id_regs depends on it. The test checks
> > that GPA and GPI read 0 in a protected VM without ptrauth, and it
> > fails without the fix.
>
> But that's a *test*. Nobody runs tests as a production workload.
> Delaying a fix to satisfy testing makes no sense to me. If someone
> screams that their tests are failing, let them scream, safe in the
> knowledge that you have fixed the problem rather than the symptom.

Ack.

> > Would you prefer that I send it on its own, or with the respin of the
> > features series?
>
> I'll cherry-pick it directly.

Thanks Marc,
/fuad
