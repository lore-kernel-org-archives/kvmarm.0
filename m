Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794943668;
	b=dM/VYVxoUBLnVqwxQIGQjMe7Ry1lsPk7Fti9Vain7mPMjIFMxc7QLJAnnEII+e78rnLB
	 ZL6iBTySnehg/f6r30lLiP5oByrA8pDksBucc/eNcm//Gc3k4iOY9rgY655Gu57AeaTwD
	 GIggqCCKBBy6Xak6nCB0ITvqz1TOesOp7A3L6Xop7cNZK0Ba8RHN5ABAlzwKUzNqy/Vyn
	 1KUIHUiUIYFjOM40SfoOA4+VUFLwR2RqN4+7F1p3aL4yrjtgXfbb11d7LyRzMpUyu0vKb
	 PxTbdBxj9EtRk2VDw+n8gzrV9cG3himq9vl2jVd/AhBWHdc1RnKI4udeCP2OCiibIXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794943668;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=+DQj5Rd8zqu4HARCi8rW0yj9HPFCT3iadFhwoSDGLHw=;
	b=w90YSc0F6V3hj+BU2Zn+wtpIebvDiwJN9NrSCC9hGbhv2QQDlabbkmPjrsOojyS/V/ox
	 Ae+pqk9yZ3JDN7gaIWcS2zqsRQaGertrSDrIrS6iNqzqVJW2hhkbSX5qUsyxvE/3Gc2nN
	 cNtuE299bfdlpe2+/di3AN2M/pkyXPKYlLX2DChaklX/81zl1on4MZ0zttotJbZ5O4etE
	 xmZRJrOa/vBgb56V/IkuABzDZ8GLtHVK0C3QKr9WRNUxOI4aHTxu42GHhTBgQWZuYtGO6
	 E/egRn7ioY4jy7uw0sSqry9kFFuvuFdIU+FXRv7aZbJD3PcwrN0LKwE3Li5R4aBjufg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FCNxMS1+;
	arc=none smtp.remote-ip=91.218.175.19
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647F4606A332
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 19:27:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 647F4606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FCNxMS1+
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=dKmJYX/63y+iQ1pYCnW01HTy/TWczwm2xVh0zs98/fA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794943665; v=1; x=1795548465;
 b=FCNxMS1+O1fZUVoqO+8hBDbYTalQFDhh+55jfHDON8Hs9nx+LNPzsJ/bAUWcifrMKOeYGB6m
 j/yQdJvKrf3NE32L29QR3Mi7RhSQl40el38qU0plS8V51Ky4RQpHsOio55YLt0ub+4SnnWkXsh/
 ppjsreX/wojyE828CJLaAFok=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 31bea878b86674fe;
	Tue, 17 Nov 2026 19:27:45 +0000
X-Mizu-Trace-ID: 31bea878b86674fe
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so1137e87.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 11:27:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGEYZtFITcNeYcbOUZsl8e6g6EPTyxPDtvgfXlwGjMxkaCS6S7dpcWb2cTiMduwv3FIsZaonCw=@lists.linux.dev
X-Gm-Message-State: APuU4Z/KHhqcCMWGRRST+fLqP+dfSGBcA2emp9oInOplDjDTV8FsseB9
	4SwjiO6XW0FW3puTHOVXYFoCcPJG6Gdkxg/W7rQFd/g2hoQNwq/waiY7bmclRx9TJzBiEJEqIx/
	n1xCgYwpUvQtOpNTj2RWP+FntEhQKfXP/mt/dO3hD
X-Received: by 2002:a05:6512:304d:b0:5bf:f81a:f24e with SMTP id
 2adb3069b0e04-5c1a98e431bmr17685e87.10.1794943664222; Tue, 17 Nov 2026
 11:27:44 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261109083205.806619-1-fuad.tabba@linux.dev> <20261109083205.806619-8-fuad.tabba@linux.dev>
 <avyZH2g3rrIVm-Fl@kernel.org>
In-Reply-To: <avyZH2g3rrIVm-Fl@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 17 Nov 2026 19:27:07 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxsZFOwT5O5FfMf3wcTWrydR+x1TYVRDaCEF_FQX8giFw@mail.gmail.com>
X-Gm-Features: AclHuK_6wbUaiI-auzUUbuozU8SjWYXkCa76KeN8iu8Ffe01iC2J030eQ3Qa2QI
Message-ID: <CA+EHjTxsZFOwT5O5FfMf3wcTWrydR+x1TYVRDaCEF_FQX8giFw@mail.gmail.com>
Subject: Re: [PATCH 07/16] KVM: arm64: Compute a protected vCPU's fine-grained
 traps at EL2
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, 17 Nov 2026 18:12:47 +0000, Oliver Upton <oupton@kernel.org> wrote:
[...]
> > +#ifndef __KVM_NVHE_HYPERVISOR__
> >  static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
> >                    int map_size, u64 resx, const char *str)
> >  {
[...]
> > +#endif
>
> We already have too much ifdeffery... It isn't mentioned in the
> changelog but I take it you're doing this to avoid the printk() in
> check_feat_map()?
>
> If yes then just upgrade that thing to a WARN() and carry on, it only
> ever runs at init.

Yes, it's because of the kvm_err(), as printk() isn't available in the
hyp object. WARN() calls __warn_printk(), which isn't available there
either. WARN_ON() works, so I'll use that in v2 and drop the ifdef.
The warning won't have the register's name or the bits, though.

I'll wait until next week before respinning, in case you or others
have more feedback.

Cheers,
/fuad
