Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.253
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793346204;
	b=HGeKOYZ6HiTJbgiSiSc/xGSzyGAoc8np0ovLjs0T2oZovuMZT4szt/g+xBcTpleb+rx5
	 qkt0vCjVchF+Poi/NW2OCwBJzK7tCJ484FvbUCiR2cSRFiObczldDcNbpfNBZEBT7rfD6
	 KbiTTc+Sn+NM7x13txuvCUjPXQ/lU3NoI6Xg89UVyTRwPfkvcLEw3eu4YOShGwmubTlZp
	 q3huMlBTrjUgSxVMBHFEY7N/G5tzfDcGglX1E48DwmnHgrHCpMzXinn1CH5TeBsZ6fIqa
	 cc1rIjpuxCZYmLPEZ0/FwPNCj2MoljPxxlHkfOFFt7Qu1OadnfOMQlOKtYt15y4rulg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793346204;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=Ic/DznHWY6qYKyiKcZAzEYcjT1Csqaqbv7FtlV+91D8=;
	b=GeI5imbVU39+NQ/EjBEmBgX2/W49dL5NPS8vAZCr+R/E7H8p+VtMhoc+fGhGLKa6X/4u
	 EfMPJoLwRI0Uu2F7KukeF+kKzQQP6rbVz7gRlOzhXXEoK3T5WQTkxbUUooF35v6J9mze5
	 kNWchzR1IjhNJpYd1zrYUq2KPijyCXQAKRQGGtlA8lVh4yGTQKisHZEUmMidgLoFZa0UK
	 GsAZKZvpqprDNXNpcQS2IHk7qUiGNDSiPYpqzyxChF2Eyy2HdVmL55N2X71KQzcABiCZr
	 39Rl9gasn/xvyeyN7cAP8wMdeWJbsPQW+4vB1tpQeiIuIni+PwNjLpdMhDZzJ7aL1cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t9TgI5jW;
	arc=none smtp.remote-ip=91.218.175.253
Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8D9606A320
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 07:43:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA8D9606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t9TgI5jW
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Ic/DznHWY6qYKyiKcZAzEYcjT1Csqaqbv7FtlV+91D8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793346195; v=1; x=1793950995;
 b=t9TgI5jWPB5V4qovkpq1PvudxkP7d8Fq2gMsBw5RdWQ6/0B6mX902LGwfDP/cCekem82bZd7
 k8vb4bygjTGRHHUVscuLVzLm7hfke4AXFzPtTjY+RdJ0tNikUZjcyxYid1SXYh+oc8VUL/cGk0i
 QfcQKg7PVUqkIjm0gbQoPZbo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f3227d9b7d3f97b4;
	Fri, 30 Oct 2026 07:43:15 +0000
X-Mizu-Trace-ID: f3227d9b7d3f97b4
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so3863e87.1
        for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 00:43:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwkuFf2ADg925ThNQVHflwioxNo+8zWbPCWWOVrLtyt1M/1G0Taz3tXP1C26gdt7u+ZOW2jBxE=@lists.linux.dev
X-Gm-Message-State: AFq9FYJK6nU1apUREb4/ASKO87aXAoc1Zxhi8noUdR3hPjptiu3fUC4N
	NiRUBFBvf5jB/3CHy0ppCLLn7835MZ+Aa4jlsxMMEf1A2Jlaq0oxZkmSzNj/ZtJQMvGPVK9wt2n
	xi9qWdRIBqHEUXMEoF9xzbM4CwfA0XlGA9Orr7TW+
X-Received: by 2002:a05:6512:39ce:b0:5bf:dcd7:86d9 with SMTP id
 2adb3069b0e04-5bfdcd78993mr28332e87.16.1793346189429; Fri, 30 Oct 2026
 00:43:09 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261025075138.2919734-1-fuad.tabba@linux.dev>
 <20261025075138.2919734-2-fuad.tabba@linux.dev> <auO3Kiykovvs279e@arm.com>
In-Reply-To: <auO3Kiykovvs279e@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 30 Oct 2026 07:42:33 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzvCAStFp4TOBJZ2dEi9GT_S0CW0i7HzB4Q_+qLbv5Uew@mail.gmail.com>
X-Gm-Features: AclHuK-iAV_pLdWc4hp6CdmUshGwwfxe2S4f_ErlrqMD7iHGLjhkPDfxfT1tlNg
Message-ID: <CA+EHjTzvCAStFp4TOBJZ2dEi9GT_S0CW0i7HzB4Q_+qLbv5Uew@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] arm64: Add override for ID_AA64ISAR1_EL1.LS64
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, 
	Zhou Wang <wangzhou1@hisilicon.com>, Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Catalin,

On Thu, 29 Oct 2026 21:14:18 +0000, Catalin Marinas
<catalin.marinas@arm.com> wrote:
[...]
> However, does this need a plain cc stable? I assume you want it to go in
> with patch 3 but that one only goes as far as 7.0. Same cc stable in
> patch 2 which you may want to limit (or add both as dependencies to the
> cc stable in patch 3 when committing).

No, it doesn't. Patches 1, 2 and 5 are only there for patches 3 and 4,
so none of them need to go further back than 7.0.

Marc, Oliver, could the tag on all five patches become "Cc:
stable@vger.kernel.org # 7.0.x" when you apply them? I'll respin if
that's easier.

Thanks!
/fuad
