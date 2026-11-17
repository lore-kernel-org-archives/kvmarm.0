Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924346;
	b=5qbJTGs7N0n3Bczxm1hpgZeEO5VUch+JIpzYtdpb2nUQAgUH47MHjvgPR4cS1InPDtCm
	 +ozr48rfwbHgZig4/DsmZ24hVa6wQTh6WFTdBJyfYzbGlF64s3SVQAzYw0cTtkM3DPVGZ
	 mYZvMmvhVM3MZnXwc2D/J5uoJPp0VllHyW1JhHLroRT3LBk+/OMmMcNFHCVs3GOFqQHt8
	 sEEjW6IqASsjPPjPN2NK5KWayBQ75VHo8ygprPfPBN4pzPpwqJ59N61euJqMR5UqJtUmj
	 HwZRkN6AdvR9ShIwIJywdexTCjw8mnrn98in0mqvbX7Pjni5F++qMFnbqxc1vuwEevA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924346;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=ngfsadg2SKwRZORmemooRU9fe+LsEp8AELUWW3EroVQ=;
	b=v2Xx2W6K8KrbQ281uXsT7e033cQQ1PbQ1yG8Ke811qmbvG8VsjT9McTLt2W1kvkdp5Xl
	 t2bMF4zJPzIJwnd5C4aABOomKbZrbmwa2YTy5ynbwiF5b5jHgjI+M1fFgrdLS29pblt/+
	 yDPivXITdZmpOZCfDun8UYgt2p4tIsGcbIzMMB/pgyVDYRk9nQ0retzeSQM4H/veiXNUf
	 SbD/Fwr2iInCGuMJzHTwltgEll/NTHnVfaU30o8Un9zx1WCOpl/elIx39SXjecuIyujrv
	 qscpHCn/F8YoQn88n34J97p7YOw5dYyp02PGpDftj57YJMUeaafMuYE2mBPldmbSVBw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CSdIYHHV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.50
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C09606A337
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 14:05:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18C09606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CSdIYHHV
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be58ad9600so8832e87.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 06:05:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794924344; cv=none;
        d=google.com; s=arc-20260327;
        b=ai0XMThbMUxuP07GH18r+FIRbw9XH0vibuuoip7NpHLiLDgJM4n4qcs9NRHQcjMlWq
         YeMEwgft/D5ybzhAWXVtOC6khWpfX5VJ/gAcgW3spJLZ8vv2VB7ptenD24deh5seSsPF
         TLTegMfNfVBc1LuywvAMKNlir26/yPOVEzluAobCnN7GrCVE/DkWT3yRktUc3MzpJrOM
         dNXNReaq/p/QzGFUgVws8pZFYp/CCY/uBj3wPRJd3qjbA2qo7QbgeYbb+oaBaBDktLeL
         T9CisGqGExvtogciRJ68rqmm9qnWpvLyUGqEAKjuIBUxWXwm2gjgpew0gWLnfeR2MXr9
         jXiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ngfsadg2SKwRZORmemooRU9fe+LsEp8AELUWW3EroVQ=;
        fh=RVB7xbQ00/taHE1iXI5bD3wyA+Yfz08YLSFKR2N2Oow=;
        b=KSR64YsrvsvXuZ2wAQR9uaKU0CSWyik4SwcuvP/07Fx9TRyOjl6pTmifXumDvoopdW
         fH/1lN75zfDt3XOrRc1p/9k+14rpOb9TUBUNddP2VM1UJ4xY/EO3rxF3Ifx/D7rl2BXC
         jvnb4+8S7FHqm8+YOlrxuOxCLg5csSWOAxpNvHscx6DY2exY2tIom+tFD8YqXux3Jaw/
         R17zvkp2A2NBRcDCvn1KNMzvqne8yClGa5fbW28AyBOgaTFvjUylmAHlbTNdT1JKy5fD
         KP0G+DVjNJh8oqLhtn5Ik4Uvusptbgj3HuQ2mH7dMVX+YEt/Qy3mmEK66Xt1H/cjeyU9
         PTGg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794924344; x=1795529144; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ngfsadg2SKwRZORmemooRU9fe+LsEp8AELUWW3EroVQ=;
        b=CSdIYHHVbaGD89gVt9GkCpt7UbtNi8wJI8Sd/AhfL4c9DNNDfHABzrjnojEStI0wKf
         nmP3fNFf10Hvk5PWBFt8FjVp0O5wzl4sZyE5wDypfQroQ9n/EEAlt5vmm+HKUh5yQ9Uj
         r4DKOAle0TiGhb6+CABB2aEDy5xh/CELs3eZ8zesoigPP3suaUdRePRgSYt/G7gGJxr1
         Ur/TaaxFLHbv/sNHBorQZeCz//NX8M7tT4cy3l+wj9ftbKo/jSGmFfrCwGtbHnaa18XA
         bJucMt5+31sEUbAngl1eyHp97y2legaTkwyxnjzhOQvx5YGJDJa65pgBU8CnHqwWPvA9
         dR5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794924344; x=1795529144;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ngfsadg2SKwRZORmemooRU9fe+LsEp8AELUWW3EroVQ=;
        b=2q6a4ylpYbBwnHsMPGdGq0UNb/T+m8vgH2X4eGwvw90GvDM3HwYF40NUa145Q3PWNo
         KIXTvXtrqiy2+boLXSp1r9PsmCMQbrzQGhFVkKig9PBvPDtKRrMliyc+h8XlXewjONpr
         YiBThImQkY3EvpUM33n5zQJ3OEvDO4IC/rQg0mY/pcFgSmXe1LyNgnKXo15fcF9X1Wjt
         aC2fteTcehPFK3qViwc0qwdsJ316AQ+V6gyRFv0QUo/kx0QgtnuvrZTqSr/Hdih4G6T6
         Gzf60AJWvuEERozrMNOCthHZ9NAoLNK+2HI+lL8cKuJW1sSuY2qS+gJxd6lZ2nEjKdXN
         Ol6w==
X-Forwarded-Encrypted: i=1; AL+hErHVrP6lhNWF708FaAaaUwkE7H/LEK23isv2oYyf3m4cjqI+1BU41yIQhO7mfeeoA9N3/Lb2jJk=@lists.linux.dev
X-Gm-Message-State: APuU4Z+PKqu+neQ1IBrzO45w+KAhedDhKLkkIQoICPDKJSiugD/WofQz
	DjKPoK3/vEApTX0VI9pAlBrmOE6LLsOaVOPy2PBCvKmlrKGOtB0cGWTTIRUlhZZcsypCwl0Y233
	IiC0pR3bIA0MwRsN7xupj8Dm2/Xw0Ln8R+DwutTRV
X-Gm-Gg: AYBFou3xK2/WTJ7jms5th5Lvc2yNx35f/JcwSu4tmA8A9KHfPAXD5B3hsvAYDPS7VY2
	od5sl6L/vOzLCWJBeCdeDzpJTWoHZLBEKxA6jlNEbmwI1xqVmOtzHsrpCIVhPEnQQ8l/zhJiZuK
	O7E/8XqijBhRmXg69+6xl4m12JXFEC9McY7hLZou4urMRf+uMAII9PS3z9/iSmajtdcunCWvyMF
	tXYC0an8D1bRsl1lmJLjkcAmLEDetzYIoC+XGnIcORQpoe7gff2wHTyFmI/gSeiIYwsU4Rvk7kF
	N4CYNz02eONrGOhyaCqozFLy1adHP9YeoCCcpjt2tRdnk/xGDvGaQn8ccXkFGO16QP11zRVBKKV
	M9Rb9HULAesdZXTepO3OEM94oXMN4YYNjUW3xoZxw3ZYZXXG7kA59f1lQOQ/FBzg29dTN6uCXKr
	stmrHVcYu1lAlM9GmZ3YbmI8o=
X-Received: by 2002:a05:6512:1111:b0:5c1:4f9f:1ae6 with SMTP id
 2adb3069b0e04-5c1a217f086mr131117e87.15.1794924343575; Tue, 17 Nov 2026
 06:05:43 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261116164358.142785-1-steven.price@arm.com> <20261116164358.142785-2-steven.price@arm.com>
In-Reply-To: <20261116164358.142785-2-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Nov 2026 14:05:07 +0000
X-Gm-Features: AclHuK9jKHIPqUkK3esGB7IzhXZkIYCyUzZ9ZlR4n4bgSHCJJEi20GuUOPH-oTg
Message-ID: <CA+EHjTy5xBmavNWSYPjqU9qXtssV3ZHzsUr1s_4bVOt1GnDLVg@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] KVM: arm64: guest_memfd: Check mmap support when
 preparing memslot
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Kohei Enju <enju.kohei@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steven,

On Mon, 16 Nov 2026 16:43:47 +0000, Steven Price <steven.price@arm.com> wrote:
> Check the guest_memfd backing file when deciding whether an arm64
> memslot has mappable memory rather than checking whether the slot is
> gmem only. A public helper function is added to be able to reuse the
> static kvm_gmem_supports_mmap() function.

nit: could the message say why this is needed? It's a no-op until
patch 8 defines kvm_arch_has_private_mem(), which makes every
guest_memfd slot gmem-only.

Cheers,
/fuad
