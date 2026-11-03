Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714241;
	b=hwb4n6tS7FFE7F+/gyZV+reITR5ypyY6/97f0sG9VonhP52skjFDfSdM+R1D4pPFEmYq
	 LSaCmQWPHczbG4DJ/q7jQ38Kp+XM7UxvshEf0PMoCvpzw1aSnLHO1+MPSoz7adjIpRvDA
	 q9Znhee83DsjvG2/ib0FaG+c4gU6uD+CYd3VpQNZ3GpS8gmBaw3U2igfQpaAnjHprMIbA
	 31C9m8Csolc+fcOCFSYKt4a9qtYayiFJg9VJAbSg2x7Tsw2qTY/iXMg+XUVCnbQG2eytI
	 DnqyO1UPpxk4MtR7jfnnZIUdRKLqD2HqFuLDPI+6+Iy3Xjx+sOr4zmCYWNXd6WbmJyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714241;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=tyERGr5hdOOoKX6h8lJLvesFYUWczrxWlktN3GBL91w=;
	b=sw4EMII/3GTaSTRmh3JEmlVzxt4aIANlebHlHoU3IOpttaYYIQaMW91GMbhnZ3oX8mz+
	 S/cN+vSko1EXsc+pVhvduT4KSCQ8tJdZFRIPo5MkG2rJJpMnf4hSXjja+hpmPvtkfObqO
	 UsfiK8VMVoYcq2QVQ5qlzdtXbVHfmZf5vFwVMFfmdjZAQycvY8gUSqsrTOmCUwzXNeQyF
	 SKS11q0LCrjJ87mYYm/A8VEpgiHO2IycCqUtFBj5AwMr8/RPevk3qJ6UvqaNnaj2nVPhv
	 Zf4VLAKW7pE035VT8i3p7KoK54Q2/PhxRhhkikHRr8ciH6xINCNciO61mJCRTMyWPJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KNalMyhN;
	arc=none smtp.remote-ip=95.215.58.22
Received: from mta1.migadu.com (out-22.mta1.migadu.com [95.215.58.22])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922F7606A337
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:57:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 922F7606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KNalMyhN
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=G9LToFbCiWp9wS1VO1jBKDgeZl6HQaIVAnBp5WasFrg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793714238; v=1; x=1794319038;
 b=KNalMyhNtZ0dVj0JJx1rQdz6pdbCalAr1+Xj1B+OcTgd81ugL7kEJdTSuDTbCZ3QtxG2/jZH
 5vIOhRJlA9Y/NyFbZcct5/Ht63+0rVPd483KkwFMDA8Huy5MhPWBIPiubEIVpwNAG1kK/9PSROC
 HH1M/cx7qaJdW/KRgCEclWno=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b5f7c6147c9c64bd;
	Tue, 03 Nov 2026 13:57:18 +0000
X-Mizu-Trace-ID: b5f7c6147c9c64bd
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so5084e87.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 05:57:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByMO1T6NEWg4M7gyYoqWsOkXbiF7Woid1iAwwJ0E4142nRzZWAXI+uFl/YsY95vnWYe/ekiRtw=@lists.linux.dev
X-Gm-Message-State: APuU4Z9Ut0MvJA+7ANWcPs95/L0+6DVjBTdhbch/9jAiujXPOe51NggB
	ryEsQG1Pv5V+cRU33J5KVPzfWW3w4BjrUv6dfNePcRj1B/n/R2S0eW2NeaSx3vQDJr+pt+0QWvj
	M/Qh5sA++3tzFi+AwIsBbWLzPPflsiJd3J+k7OEBU
X-Received: by 2002:a05:6512:1087:b0:5bf:c0d0:8fff with SMTP id
 2adb3069b0e04-5bff0efda80mr92373e87.11.1793714236905; Tue, 03 Nov 2026
 05:57:16 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102194454.4086911-1-sascha.bischoff@arm.com> <20261102194454.4086911-10-sascha.bischoff@arm.com>
In-Reply-To: <20261102194454.4086911-10-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 13:56:40 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzCH=8RwJ=5FXB=Hw7_qWYmYN9qZPFzFs3ShEcVjiBXjg@mail.gmail.com>
X-Gm-Features: AclHuK-svprfnHONOILI0GBqj01szuLcNL1Pgm3q7EqTgPF9NwQczUK83_h49Hw
Message-ID: <CA+EHjTzCH=8RwJ=5FXB=Hw7_qWYmYN9qZPFzFs3ShEcVjiBXjg@mail.gmail.com>
Subject: Re: [PATCH v2 09/16] KVM: arm64: gic-v5: Add ITS MSI injection
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	peter.maydell@linaro.org, lpieralisi@kernel.org, timothy.hayes@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 02 Nov 2026 19:44:47 +0000, Sascha Bischoff
<sascha.bischoff@arm.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
[...]
> +int vgic_v5_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
> +{
[...]
> +        if (!READ_ONCE(its->enabled))
> +                return -EWOULDBLOCK;

Should the plain stores to its->enabled should be WRITE_ONCE() to pair
with this?

Thanks!
/fuad
