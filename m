Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795509354;
	b=Z2E/Aw8W58ODtwxZhII7ifr8GLjprtGsolrR/piXjxprzBIAZGjzdfW5DbJa6Zk3Ihta
	 X34K+HQGZ3RMeXBsbrk7AR2uiETchxy4+/8pQBG342GiL64RjsDLBvlLl/lqU7POPvfzx
	 bCSxr4OUaJxsMgFhm1xoSj8i3D5IJaKCLmNNvLZFxaOO8MoAbtkwRmD9a5mlW3ppu8Lrj
	 vHdceHAl0k7OkoLrlAsq64wdENsU1vORjV257xosT9gZyA/iMwSqbDycZAeMvjH+sbt1O
	 fNqTqTLav2HkDLzi2aaNW1K2sgfvslcYNZkzvXVdYpVXOiMbcLJQIMBJl6xrc+7ANnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795509354;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=Y/9Z+Oxaa18zcAW8dXB36QsjKCZKOxK0vvzwf7T1dLM=;
	b=zVMf7tlV1ljZpM1JOSg5e89xCwIAVXE7xfsL53W6wG7BVjgNtqIztRrW3yGeUVBG57iX
	 MzXs9eXFkxg+T+Mzr58UK3KdbS/eB8ixnTArccdOV1sCidGae7T2NWHt0jPXubJJPBdFD
	 p6G/CTRmC20SoOUq1qjzRT/VG9OIV6QsEq8Q0H6wutXVXbhE7Q/jI5eN712rUHBghAkuI
	 XKonxQuy4g4p6J5fg6ncrF7c+xMC0jqdEnoWsST5+cNUQv4f2dmRjSzAZNYA+mhNJsrsU
	 s06FHxK6ikKNKWjMtTCljylHVj+W62StAhnV7Qot/NsTgkiispieWBl3++IbWNvU8dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fDH1lci5;
	arc=none smtp.remote-ip=91.218.175.172
Received: from mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84832606A321
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 08:35:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84832606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fDH1lci5
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=frRhWONZHUb4W+PwfONUFPXQmHE/jfkhamJXvxAVQwE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795509351; v=1; x=1796114151;
 b=fDH1lci5ymHlZckqs1K/cZdaQ/vPpmYmneR8zo5diWqv2zdNMVkek7/M/Sbhxd4G3iZM4zjf
 Dhtiez54habRQDgl382as7JjfjjCjGK5u1UxP0qVNXc7AMtAvbF4Rf4i1/nfdVRpOlkWJeEANz+
 YH+qNuG7DtDifwfkW0ICflcY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 64586305c29cda53;
	Tue, 24 Nov 2026 08:35:51 +0000
X-Mizu-Trace-ID: 64586305c29cda53
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so16795e87.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 00:35:51 -0800 (PST)
X-Gm-Message-State: APuU4Z+ABtKKuS5mIzqlI/w8tuX9elBoSRyx3u/pOjppnpebJo1DmKaH
	RpxEOgod3i2U0QxIqVuUuM+fup/5LALL23m9+nqTBK6whhsLidKZ3LTjtjARyWoaMDkD0zx74ZO
	aQo1l2UJ9cDopcktCKRYvajaf/Rq9EB+IL1vO91sV
X-Received: by 2002:a05:6512:3ca7:b0:5bf:f060:c0f3 with SMTP id
 2adb3069b0e04-5c21a26fab2mr329358e87.12.1795509350390; Tue, 24 Nov 2026
 00:35:50 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261123192457.8700-1-maz@kernel.org> <20261123192457.8700-2-maz@kernel.org>
In-Reply-To: <20261123192457.8700-2-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 24 Nov 2026 08:35:14 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwsRNp+ThVP77L42OMV+CwMFMpRNzqAeKRjMHrpa1YLbQ@mail.gmail.com>
X-Gm-Features: Aa3M54rxabL4rIXwrzfAj-LSW2gkv_0xvrJLgjhQwGE1NK_mFU7OAUw9n46ykdw
Message-ID: <CA+EHjTwsRNp+ThVP77L42OMV+CwMFMpRNzqAeKRjMHrpa1YLbQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Add enum support to idreg sanitisation
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 23 Nov 2026 19:24:55 +0000, Marc Zyngier <maz@kernel.org> wrote:
[...]
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
[...]
> +static struct resx compute_idreg_field_deps(struct kvm *kvm,
> +                                            const struct reg_bits_to_feat_map *map)
> +{
[...]
> +        for (tmp = map->idreg_field_deps; tmp->match; tmp++)
> +                if (tmp->match(kvm))
> +                        break;
> +
> +        resx.res0 = field_prep(map->bits, ~(tmp->bits));
> +        resx.res1 = field_prep(map->bits, tmp->bits);

Sashiko flagged the res0 line [1]. With the tables in patch 2 the loop
picks tmp at run time, and GCC 14 and clang 23 builds of config.c
don't trip the BUILD_BUG it describes.

nit: could you still compute res1 first and derive res0 from it, as
Sashiko suggests (res0 = map->bits & ~resx.res1)? That way
field_prep() is only passed values that fit the field, whatever the
compiler folds.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

[1] https://lore.kernel.org/all/sashiko-outbox-229945@kernel.org/
