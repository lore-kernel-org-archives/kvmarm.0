Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795598417;
	b=ds+EpuJ/uwKd1gQ3eF6nhkdKinZS201vb6Adw5xRSCzIT50DgSf0UHVeuvQbhvqe/ZdF
	 zLhJktVLf8qLYDOWdCVLo5eh8LGbb1mEYAJGCX81UhYm40Q8ZNsutEwbAPuYWwDQuw+TS
	 TXdsEfZ1i3HIB3lxjFo9qjiYCIDYh41uYn6fSlFEP9kj1pQv8G1jExzYWvwmmdF03kwZL
	 Gg95P4/3xowFjPupbz+mEghNnFmcqtzdzotL8qMNdhbSxf/7bvT9G3oW5LgCVdqk6RovI
	 oIS59jwkeKFrkp4Qjb3PAdPQpCm/S3e3X5COoPQgYyc+/z+j6mnqoFZdDpEKFu5EJGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795598417;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=F2Xkdeo0HzaNsNuC4QUMqleMrJpmw0zTyb8wkyKNlT0=;
	b=ylX6+f3TjZDg78wV7HngrcK/W1hkk/4aHcdhWmoif/JyjlMb+3HhqPHIu/HVXaXiJCbb
	 kxlOl+VS+Wtv9zRJTOQufCCc/Yd4OZkPt7oJltSIWsSri2Y4B0F6hSH7BnMDy+9LgWHww
	 xnojxKsxiRsjjG+iBuU9c27PSrLFxd0tZ5pUTYP3ydxjPf4fGyfhUzq13kFIu4tf4hRAk
	 mkuXkRJ+YY7nsSUC8J8qvJ79aV/H8a2K2VkIjahJvMU3WJ5dulXWahN5sWHmtArfwhcHk
	 OEsTnvmMi6ktkxVbeKBX2KOLB5vzf1aQ3O1EKvsUg9HtQNMK42mIdCsSUL3V48DmwVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MQkRp8Gu;
	arc=none smtp.remote-ip=91.218.175.70
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C43606A686
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 09:20:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05C43606A686
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MQkRp8Gu
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=F2Xkdeo0HzaNsNuC4QUMqleMrJpmw0zTyb8wkyKNlT0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795598414; v=1; x=1796203214;
 b=MQkRp8GuJ/ig0B8Td1SADf5vB7lyE4LCsrE8/0XFbARUMBLuR7RAnNILkqCLQiEJwFQzSSpN
 92z7gbeCsBRB/glJeS/twWjuSFJUIGJSBHBa0beAEXjfkuUB39d4d5yublBGOepY2KDq0XhRjI9
 w/ZvpSe74lZV+CbZkPJu+ML8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 23aec541905c7266;
	Wed, 25 Nov 2026 09:20:13 +0000
X-Mizu-Trace-ID: 23aec541905c7266
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so26593e87.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 01:20:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErER865lEG8RiI5SARMsd5hiJX7bH96FGk1WTGZhsXSCz1sdlXyhu9nkkPuWxTJU9he7xfa5aaY=@lists.linux.dev
X-Gm-Message-State: APuU4Z8LzUbneQJmOqpgnJ/egHSHg2nGF8sycPLwLEZJBbtec/KehvCy
	Y+3628URIhqugVv7i5fEJQUCUYSgWDAMGMyhfzAamQIOZ6nrbljI8rucEmmZKXMhlhwFfgKlqJd
	J/x7j69EyRtv+Tpgh45wJRRggkjZREhIZJLpkHmpz
X-Received: by 2002:a05:6512:2249:b0:5c1:ac5e:ee43 with SMTP id
 2adb3069b0e04-5c212394558mr484720e87.3.1795598408854; Wed, 25 Nov 2026
 01:20:08 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102095656.2948964-1-fuad.tabba@linux.dev> <2576e9e5-395e-4842-aa83-e09494e97d4d@arm.com>
In-Reply-To: <2576e9e5-395e-4842-aa83-e09494e97d4d@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 25 Nov 2026 09:19:32 +0000
X-Gmail-Original-Message-ID: <CA+EHjTw1higCqZ5eY9_xsegh=C9W_=ba3VSE=8-wa-X-7_oG8w@mail.gmail.com>
X-Gm-Features: Aa3M54rNelAy3rRx_aqH9o44IgmjZOttEw2zqBrwcOUYh3b1IB0PHZ2N_7TmlyA
Message-ID: <CA+EHjTw1higCqZ5eY9_xsegh=C9W_=ba3VSE=8-wa-X-7_oG8w@mail.gmail.com>
Subject: Re: [PATCH v5] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
To: Ben Horgan <ben.horgan@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Xi Ruoyao <xry111@xry111.site>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Gavin Shan <gshan@redhat.com>, 
	Yuan Yao <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Nov 2026 at 12:00, Ben Horgan <ben.horgan@arm.com> wrote:
>
> Hi Fuad,
>
> On 02/11/2026 09:56, Fuad Tabba wrote:
> > finalise_el2_state() clears the EL2 MPAM traps on every CPU whose ID
> > registers advertise MPAM once the arm64.nompam override is applied.
> > KVM sets them again on guest entry only when ARM64_MPAM is set, a
> > capability that also requires MPAM1_EL1.MPAMEN. Without EL3, only
> > MPAM2_EL2.MPAMEN is writable, and the kernel never sets it, so
> > ARM64_MPAM stays clear and so do the traps. A guest can then access
> > MPAM0_EL1, MPAM1_EL1, MPAMSM_EL1 and MPAMIDR_EL1 while its
> > ID_AA64PFR0_EL1.MPAM reads 0.
> >
> > Record two per-CPU flags at KVM's CPU init: whether MPAM is
> > implemented as finalise_el2_state() tests it, and whether
> > MPAMIDR_EL1.HAS_HCR is set (MPAMHCR_EL2 is UNDEFINED without it).
> > Read ID_AA64PFR0_EL1, ID_AA64PFR1_EL1 and MPAMIDR_EL1 from cpu_data,
> > which holds them with the overrides applied since commit 342e62ded77c6
> > ("arm64: cpufeature: Read MPAMIDR_EL1 in __cpuinfo_store_cpu()"). Set
>
> Ok as long as this patch isn't expected to be backported.

Nope. I didn't tag it as stable.

> > the traps from those flags. MPAMEN isn't part of any MPAM trap
> > condition, so the traps take effect whether or not it is set.
> >
> > Fixes: 31ff96c38ea3 ("KVM: arm64: Fix missing traps of guest accesses to the MPAM registers")
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
>
>
> Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks!
/fuad
