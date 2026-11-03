Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.121
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713512;
	b=MnKQ9oD03WXLpRIoN7iNMjJoGvgDSHXTkEHPY19RnE/YYWiSzCAYJXc6FJLQxzlNhQp9
	 d962i/ExfyME8eWAiQgDfhdPuqj4503sDpX8Tk0db2n8pDUM8Bqw0lf707o8+fcHp2fAD
	 P7Hy+UgtU7IaVb4nvKNXDv45VVxk2ahM8Wp+1M6YU/1RnW9cSrdzpiRnQ6U5bUwgG85GD
	 B4tjFn/8+bXOrZw3SZoMmSFZHhEqwYtvTfBHgPNuSRZ+3Fru7VuF4ADS6EvHsr4LYysBI
	 dRL/24ewzRyiSKRPKAOHntqny6+Laimmis7oCAmaGbT5eDeZXUISFTq6toQSU6PbD8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713512;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=7JATDHeSysjhrflLAzQ9XRWSKRJGHXy+wbdwm4zZP4o=;
	b=hGIxdPRk7Uhh7BHo+opNGQkttXpimuQ8CtErBqzgeP1sKDWQMtLkGOBD8JhD9+dSdZC+
	 BIvPigVu6R1gKVas0qBjPKwmkkZpuSqqp/I9qCqVHqTokdo9Pa15UtcRGqkjOzcZilmt7
	 hS488OYoNS/4l7ebiFhE2F+xEFNoBJDKkoovWXxcU4EQcNmxPQWhoZPXg35OA/4IpDAgt
	 Gkv8EufICvmr+jz9TrfhkxaGL+i6OUx6b8M7UUCl88bFfmwCGCdQMz+VbKV2XlDafbYqv
	 TRp4sOBzD3YnAp86Lb56dhRcAbYtvaKzxxRC8nG2TlFc7CG3laJTQNA5ag01SyDycXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=T5mn3YGa;
	arc=none smtp.remote-ip=95.215.58.121
Received: from mta1.migadu.com (out-121.mta1.migadu.com [95.215.58.121])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87F3606A328
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:45:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B87F3606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=T5mn3YGa
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=7JATDHeSysjhrflLAzQ9XRWSKRJGHXy+wbdwm4zZP4o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793713509; v=1; x=1794318309;
 b=T5mn3YGaEG0QCMmW26wojeLW3zrjcz46RH/wKpY0ghGOXG6wwJmLuRmd4gDPnbj4mGQxTAAk
 EvCeEiydRDj0G3mJRyTuChcn5fHkJDBXnUNk/Jz3hRy2gdNxenGUKJkds5agcbMmzaTuIUEg1oU
 szY1SlsNql+4j7+zkfMJeDqI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id fa2c90b4c25e179d;
	Tue, 03 Nov 2026 13:45:09 +0000
X-Mizu-Trace-ID: fa2c90b4c25e179d
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be58ad9600so7348e87.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 05:45:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBylwn6hPxWKH/HpgJRlBAx5GxCWbu4emTdXVsOiMHIHPgP+e82o7A2knNQVwVffz6yDzKrQ3yY=@lists.linux.dev
X-Gm-Message-State: APuU4Z8fcmenqnjYDw+ULsrJUNhgRpYMbP1CrUoAqKmvcbUYgLYAha7O
	tFIB3CwjEloQB2nZKBidVErFrYSymb23nuJvgJc04uz4brRCTctEetCIrxtVDQjF0BXejhjNHhS
	FfN1niiOHe7/peazPviXChQrsW2oua+ZAmebLg9Lk
X-Received: by 2002:a05:6512:3e06:b0:5bf:a49c:ddde with SMTP id
 2adb3069b0e04-5bff0efce9emr111926e87.10.1793713507212; Tue, 03 Nov 2026
 05:45:07 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102194454.4086911-1-sascha.bischoff@arm.com> <20261102194454.4086911-5-sascha.bischoff@arm.com>
In-Reply-To: <20261102194454.4086911-5-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 13:44:30 +0000
X-Gmail-Original-Message-ID: <CA+EHjTx6RuEs7gP=kUMJEJ-ktC_p0UNxG38rq3P68Xyo8xOMag@mail.gmail.com>
X-Gm-Features: AclHuK_8x91av0-bAi-LcSEBarsfA-5SHr6ALUzPfLF0-91WlZxDuJwLvudbzOc
Message-ID: <CA+EHjTx6RuEs7gP=kUMJEJ-ktC_p0UNxG38rq3P68Xyo8xOMag@mail.gmail.com>
Subject: Re: [PATCH v2 04/16] irqchip/gic-v5: Add ITS MMIO register definitions
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	peter.maydell@linaro.org, lpieralisi@kernel.org, timothy.hayes@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 02 Nov 2026 19:44:42 +0000, Sascha Bischoff
<sascha.bischoff@arm.com> wrote:
[...]
> Keeping the ITS register frame definitions together avoids spreading
> register-definition churn across the subsequent KVM ITS emulation
> patches.

nit: the re-tab and the XDMN_EVENTs rename worth a mention here?

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Thanks!
/fuad
