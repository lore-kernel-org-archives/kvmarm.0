Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792751912;
	b=rjW0eVZWDbalBuJPxHrsph6Csa6kRUdR2E1noKZBgBNi7wpWWZVT110K3mIt81zg2YLm
	 NWvZ0vfCeqdE2nOebTPaWSGfX3W8cLANXOUAAXO6q3/aHHs0Kx4WRewKM0GgeHPntFL2S
	 zXyx5biM6AAP5BHnht/eyUU84iIcMYUi1qf9wMeHtyT/iNlhKpdaPI6FP16RmsiOr7Xw1
	 a3e9egy+245ypMVJ9OyxCZdGMoE78xg87XTN+BxK9B0win7dgpLQDmTzKvv30zu6GMNy+
	 1VT+4khS5GCCfNNVeO7D3YscDEPXcWJIITLUGsgQM13V2hfCLe5JVePa+gfR+OP0/KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792751912;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=cLLRVkOcST0DyQ8J/JKflZi0Zz/mIu85uAsHsW1TVFg=;
	b=i71Q+dEZbECYuIAw4LKkMW61VOrCkz07XEiogUexQ5WG32oKhZ9RkIyYr0qUnJTq96yM
	 KzgNPmWRv8D16r1P38QxZm+WNycxKwhUEYfJ07FOs06FQtKGajIqJKx15pqMxUcIYkz9+
	 m21aBSkYJJBK9ILCqNakVeQE/a/+ZMFtdAMMFNLOfyZ7Nt/Z3hrcCBkgTKRrmPjKYcvgN
	 xZEPS42blf+n03jY8iPdec7FnzHTg5kXB5MPLwlFAp0vwP9twLZRznpcpMhvcxzN2Vrrs
	 ppRGyRdiaSXwhfAV8If8BNW3A9Pb4XmBgmQkEQbkV6/tQcNGcvIftdD2glGiDXNhEGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="oS0BZ9O/";
	arc=none smtp.remote-ip=95.215.58.74
Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5C3606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 10:38:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E5C3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oS0BZ9O/
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=cLLRVkOcST0DyQ8J/JKflZi0Zz/mIu85uAsHsW1TVFg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792751910; v=1; x=1793356710;
 b=oS0BZ9O/xylIlDBLbOSAtzt4V8E16KCcDZ3sFsZiHJgOR/m/tVKw4QD+MEe6yTg1RREty51d
 GyQkOH4kRgesYtIxsvSs8+5Ek9X+9X+W3mVnrhruk/3GaSV9DrcW+8RhG4+DR0oSk+2vWVVvTfR
 4gb1iAEH4j90fa3AkafUgdCs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 13ba06cad9ad4398;
	Fri, 23 Oct 2026 10:38:30 +0000
X-Mizu-Trace-ID: 13ba06cad9ad4398
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so6906e87.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 03:38:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzuHO3zci0yMrUUNcDBIu1uUURPlwhZKfgUAtecjP0FKSTmO1tJ3lOk/47apMhVwXqk8GovCJ8=@lists.linux.dev
X-Gm-Message-State: AFq9FYIl7pffX9VlNba+0/MrtXN7nzLBBkM9VmIbpf6d+/kXRtUlrlXh
	nzTiKRetUcVKDIb6DPDa0FRXXadnj7LMY/5zuLR6sGqE+/n8xuy/YIdsoKLf70We/8mayYFhTAI
	VW5Ju5Io9A8OLafS8dz4OYnneEUdKeQHBssbF1nv+
X-Received: by 2002:a05:6512:3e26:b0:5bc:fbf6:2352 with SMTP id
 2adb3069b0e04-5bfb06d38a0mr119014e87.9.1792751904240; Fri, 23 Oct 2026
 03:38:24 -0700 (PDT)
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
 <CA+EHjTw08SZC_3Uodt6ew6vXVH-doW-8G41fVCF-rmaKsv+0fQ@mail.gmail.com> <86ecdgzp6m.wl-maz@kernel.org>
In-Reply-To: <86ecdgzp6m.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 23 Oct 2026 11:37:47 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy0jpY3sdVCENJRj_kfRDwbZ6TpkCAHQ2xUO-7ZuErpcA@mail.gmail.com>
X-Gm-Features: AclHuK-Z7-qsjF596RnJ21sZzB7mzj2vXd60dbcKuOxyJq8KgdnvpDHBkQR87RQ
Message-ID: <CA+EHjTy0jpY3sdVCENJRj_kfRDwbZ6TpkCAHQ2xUO-7ZuErpcA@mail.gmail.com>
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

On Fri, 23 Oct 2026 11:28:17 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> No, I want this fixed by enabling ACCDATA support by default, which is
> what we have *already* promised to userspace, and see the fireworks.
> You can add an arm64.nols64 kernel option if you want, which is
> consistent with what we do for CNTPOFF, NV3, and other extensions that
> depend on FW enabling them.

Will do. v2 will have your patches 3 and 4 from [1] rebased, EnAS0 set
when the guest has LS64_ACCDATA, and an arm64.nols64 option.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20240815125959.2097734-1-maz@kernel.org/
