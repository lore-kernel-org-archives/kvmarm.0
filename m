Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.29
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794420417;
	b=085PUiuKmbQ3RSKrom06CDYv2Ng1ofQ2RXrpjSmH7sQULXdtOH3D65qvnDvitqAlK2YL
	 mxnDgqTw9XGNEPiNS9JPtJ7N44cIPnLb/oluu4HcT+AnDcuf4riezYtK9uWKtv8X02dpH
	 VAgWcQkGLFR+vyAnfypHZB5vwKZIGo7gLbIZe6+a79ipYDV7eoi3NfN4wO2A1wVhqM9RE
	 36WQ6BeV+CYqYrrmb/4qA7jtJevilFhIJUp/sMgTLbx88Xjvzq/CXvNyX/atcatoKh/rc
	 11/eNvh6SuTjKNOLvP70d+WWeTw77iq04FVDZNtkPy9CeWAT2zlL76Z3HebxsphG0pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794420417;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=nFABM/SwyM5n9FbKHYal/oQliYZ3pyaRcZ9nUutqbLU=;
	b=LwOWBJrXft259phmJS/1IksHJtxJ/1PNs968wTJy4NOTtnmz/eDqv4rRMwJqd+iYYvEl
	 tiP0k2msq8wDNwrbQACyHPIDUPBHizBAuKA5POZwEnRMMI1AjNRGPCNS00Gu82VZq8hbY
	 +/mz2n5woEHY+/lFxjBwJvOikwhqQNxnkp4TQawN8K+X4YnSc6JarwSLadd/f7v9sG/Pi
	 N2gxG5x3o5ndktn78LpI4HaBxz3hxX+KZyGpsE0OaRDWqFNmjiSyf4U034j3kGvaxt9Cf
	 gYsxsDkgEAM36Ca0tWSbDcBVxdWXXj1wHPbTDJAiramigunsL1F7jainvabOsYwINDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=G296BTAY;
	arc=none smtp.remote-ip=91.218.175.29
Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BAF606A336
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 18:06:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6BAF606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=G296BTAY
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=nFABM/SwyM5n9FbKHYal/oQliYZ3pyaRcZ9nUutqbLU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794420414; v=1; x=1795025214;
 b=G296BTAYlr33H15IkABq/oUkNMmQE6c0AkxPAN2a6YYe6THCY6ExiHFLurqAtGTBQjM4n+Df
 EzNC1zKJWg4j2DPkuxsjC1n9pjmPVhVB5/DQ73RLHrAZjvF6eUzL5XmPOyFu8YX7EiWAyIi5V9+
 4d+J47P9zxdLOMjOb2nu64Og=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f2333bdf22f4fc21;
	Wed, 11 Nov 2026 18:06:54 +0000
X-Mizu-Trace-ID: f2333bdf22f4fc21
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c00d7ac49dso45e87.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 10:06:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErE/4Gulq8+UNHIH04ZjaRNKpXdb6vwEcN8ZTQe7+3OIIJcr7QWk+wpbueJshR+rBotB3KYeH54=@lists.linux.dev
X-Gm-Message-State: APuU4Z/Lcgezhf9XbV4qO29Y6uaMMvUqfMdwiqAi5schLDueMsD7QXHa
	1dnYSC/xQH3UpO2pG8npnnv4qVkle1mvtKYxoC4T0LNU186DWa1hgvYLlA8W/GGtAD0WeJEEGCK
	d5EFuWzSbigptC0zxrNZz8zVkujEWKTLmZTlFodsp
X-Received: by 2002:a05:6512:3054:b0:5bf:f0fb:2c9c with SMTP id
 2adb3069b0e04-5c15d3f5907mr196823e87.5.1794420409621; Wed, 11 Nov 2026
 10:06:49 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
 <20261001135711.1640520-10-fuad.tabba@linux.dev> <5fa8a1fb-4e2c-4746-8a70-a47f387ef0d6@arm.com>
 <CA+EHjTyCcGPMte9=HuqyvCS7CCCt80Lc_JQuA+1e3ZE+3A0zqQ@mail.gmail.com> <c426f5a3-d161-476d-8911-99903ecf8e46@arm.com>
In-Reply-To: <c426f5a3-d161-476d-8911-99903ecf8e46@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 11 Nov 2026 18:06:12 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzJggL5gwBT=5+eF-30=W3rHnwtQoCguiqYZrnV-dhQNA@mail.gmail.com>
X-Gm-Features: AclHuK-obnEvFeK-oZDjiRcp3WhqMlDvWCrbcxoPgPML16ljc-27phGiA9oxoSw
Message-ID: <CA+EHjTzJggL5gwBT=5+eF-30=W3rHnwtQoCguiqYZrnV-dhQNA@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: Implement HVC handling for protected
 guests at EL2
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, steven.price@arm.com, vdonnefort@google.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Nov 2026 at 17:50, Ryan Roberts <ryan.roberts@arm.com> wrote:
[...]
> > Yes, where the mitigation is the firmware one. The host can disable it
> > with an ARM_SMCCC_ARCH_WORKAROUND_2 call, which EL2 forwards, and EL2
> > doesn't enable it again before running the guest. With TF-A that's
> > only on a Cortex-A76 without SSBS, the only CPU it implements the
> > dynamic workaround for.
>
> If the mitigation is via SSBS but SSBS is not exposed to the guest, I'm guessing
> this is safe because the guest is expected to set SSBS=0 in this case?

Yes. A vCPU is reset with PSTATE.SSBS and SCTLR_EL1.DSSBS clear, so
the guest doesn't have to set it.

Cheers,
/fuad
