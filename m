Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792746535;
	b=VRnvMFjI2BE+rxDoEh16H/WuYLT4vya17VbpyfbTlHjW/lBIIiSRDHL9AHborFfu26fT
	 a/15uHnTGPHuwNwXdE96PxDr5hrh4oVOtzcJ0AB6bFUZ1hmedbESutY2HilurULJymd10
	 hJMefd3BjswfaAGcmWEuOgPjiaDMFrwmYLC1wiRtzsw2jBgOoCJ+epPgsW2xYs/ll3kc9
	 64HPT4m8yK1vdgd86v47Q5nizUDboBRrUr4auKpsJIiycC8ERHArCt6q5drmC/LdSx9Xn
	 XAbsoB2gtdlYU82sBTJ74bb3WPOyK3wNOLQPNAAo0aDwFW3v1DBRqlscAKKkmYVOA/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792746535;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=aHdZ+oKwe6OINwv5V856+JzJxIwxr2tU0lqEBlQhC6Y=;
	b=NSzGBCc6yMyLjhFL6TBGIQoULq1CqOZymmWnLkt3KL2FtflqwO4nZrd6KZ7E59s4CRJP
	 fRgbp+CqpcYtnBo3EI6wjwK9D2TNEvjUlgQ5myYYSIY6NNadwvti4S0qE5TlCgfKreiWa
	 pHWdQLS1p73p/T5+RIAHaB+U6bmbyGYlM89Yd15azIIxQc1BF3afAwA5iS7gtriWS3E3B
	 +PTIdqljGTgj4ReN8pVrax3waZeyk/fpgXnY9kYpV83Q5o24gwNGbvct5Cu70kAPmv4CP
	 OiqmidPBvCp2iAnt9o4zwouT0ZT8ngd8v9YB16zhHTU/qGq2c6oGBRYISYflYP3rc8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q+CtonFs;
	arc=none smtp.remote-ip=95.215.58.174
Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347F5606A321
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 09:08:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 347F5606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q+CtonFs
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=aHdZ+oKwe6OINwv5V856+JzJxIwxr2tU0lqEBlQhC6Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792746533; v=1; x=1793351333;
 b=q+CtonFsq/yIiM0skPBshBA4a0cnJyCmZl0ywNg+6KYtPzv9uEvbqzU/Ll8t936D8nT9edL0
 1WjdK2yc4ipdY2VCsy/llbY+ulHP/0tpzk7p3YimKgkK2fxaLD9OHjo04LWNeQ2ctN35L7VooYx
 ovGJ3X95vLsmNWIrn1K3+jTw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id eab9fa1100caf4eb;
	Fri, 23 Oct 2026 09:08:53 +0000
X-Mizu-Trace-ID: eab9fa1100caf4eb
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5be58ad9600so6450e87.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 02:08:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByvKIQKgjCDrbmKDBrmW/R7gGMxbVs1uLEz01f9weaueyyD2KXAVSiSD4QCbq4W8UW7E5Aj89U=@lists.linux.dev
X-Gm-Message-State: AFq9FYKUor+DoQszU29nawAukDxRbaU9KJfwaiuG397C10Tp9e7xG5t1
	yexsWUVS7wPHN1b0W2X/n229CrDraThv1oJi1mT5zdZibaKlQx8xo1B4wEmtcqciktunysA5/ic
	XJOEOQC3w1c3ZxA8knNkTMJckb/s7zY5g4zXa8vBv
X-Received: by 2002:a05:6512:3f03:b0:5bf:a49c:ddde with SMTP id
 2adb3069b0e04-5bfb06b5140mr90492e87.10.1792746528071; Fri, 23 Oct 2026
 02:08:48 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261023070110.1833446-1-fuad.tabba@linux.dev>
 <20261023070110.1833446-2-fuad.tabba@linux.dev> <86fqxwzul7.wl-maz@kernel.org>
In-Reply-To: <86fqxwzul7.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 23 Oct 2026 10:08:11 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw08SZC_3Uodt6ew6vXVH-doW-8G41fVCF-rmaKsv+0fQ@mail.gmail.com>
X-Gm-Features: AclHuK8By_xwbQyrvckEGFfA4cAUoxoiGOv41Z9xRvku379045c1KVkkaVcFF80
Message-ID: <CA+EHjTw08SZC_3Uodt6ew6vXVH-doW-8G41fVCF-rmaKsv+0fQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Hide FEAT_LS64_ACCDATA from guests
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Yicong Yang <yangyicong@hisilicon.com>, Zhou Wang <wangzhou1@hisilicon.com>, 
	Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Fri, 23 Oct 2026 09:31:32 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> Why settle for the least capable option? Context switching ACCDATA_EL1
> is easy enough, can be gated on guest features, and avoid the
> userspace horror story.
>
> I'd rather see that.

Context switching it means accessing ACCDATA_EL1 at EL2, which traps
to EL3 unless SCR_EL3.ADEn is set. booting.rst doesn't require ADEn
today, and TF-A only sets it when built with ENABLE_FEAT_LS64_ACCDATA,
which defaults to off. On such a host, KVM traps to EL3 the first time
it switches ACCDATA_EL1 for a VM, and every VM has LS64_ACCDATA by
default. The cap leaves the register alone, and the fine-grained trap
takes priority over ADEn, so it works whatever ADEn is set to.

Should we keep the cap as the fix for stable, and post ACCDATA support
on top? If you agree, I'd rebase your patches 3, 4 and 8 from [1], add
a booting.rst requirement for ADEn and EnAS0, and lift the cap and the
compat.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20240815125959.2097734-1-maz@kernel.org/
