Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794808854;
	b=2bsDprvRwC36XlfkTXMNY0Z8Nc027H+C3R3hJcOp0UbWEiMv4QNAmIKDgxL9+H8Dz3X4
	 p/4TrBMVrV75TOjVDn5o7IwsV2xtVL0EyLR7XySx7azlsXqGDpYDujtM4qNsfA4Y5rgqt
	 NiVcnBqtETHIpj2+takhceEFjGZgEj9sgJ9pnRSUx6koDDKCWgUBpnKEpwQRgGzZSrHyG
	 aIoMGCeQuSDA+ZBR/JScQCqmTov+Eb9PqxZatqNyP5DGjVroE2HQdDoUFwYqFuljym5dL
	 tbNjW/sL6pGs/C779uR0f+UgTe5irQmdvXysaBupz7dj1cI67m/TLrJm/dwQHI9X2jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794808854;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition;
	bh=WFV4t0eUs0gbqqsFkBQx5rUyLF4Yon8sMLY8mNC/aTw=;
	b=cqOyvackT6vDzWW9nXsdEmIa6avjI8h9IMFNX0E/VLS8H2lDe8U5GqMMHKjpBB8NZmgu
	 PUxd2C+6qAh1yDRt0HvQjBR/YI0UjUJ7qYfSTHPjuDeVnLh9uoRQDgGh32lmmUWWvxtqx
	 zBGZ6Y868t9pCm2Wa4XlYzbsiV+5SuQx/fcEXVbdjGOijTrTBI4aXaUXzUqg9r8nT7Ym5
	 mKBfiiJ7NF6uE7L3D9LGVSHyEuEYkkP5cFyMS/mFRGkQGbYcAhPHmvXN+oVe11jCxXFDw
	 qmgo/Vpm3S8l/N6FqLiIUjxysu+hIqW6jkfC7vMnMZewAzm55MZBYt1HKOTtnLKqibQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=LNvpUTcp;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C22606A323
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 06:00:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44C22606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=LNvpUTcp
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-491f34b4e0fso1187699f8f.2
        for <kvmarm@lists.linux.dev>; Sun, 15 Nov 2026 22:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1794808852; x=1795413652; darn=lists.linux.dev;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WFV4t0eUs0gbqqsFkBQx5rUyLF4Yon8sMLY8mNC/aTw=;
        b=LNvpUTcpfGL4W0x8c8tNSiGPv74GJFe1UUoAnOGN9xc3fDuqhnIEOHxDIAs98V2g1k
         4h9HTOw1zNnAjAYqi9ikBid0LLZY3YfXq/14K2XZp8QvESKOyxG6bPpP8ipxFAelfBti
         HWtDsiixJ9uoWLYJdx46oMj+T/a8CNp1FaJIRK3FzAd+2+0ovRSgSlZ6iVPhgR+3xL0Q
         b18ER0nssPRUyVOKuDRslgiBrYCE+6WVoypzz0AH68+EgDmjS79qXWAgR58Fw1hbZQ0K
         W2jy4Buw0rkXxE9CSsrYpaAOTmpRKbXC8VPR5c745ZewsNrhe7LTUcEaihUk+npWYuWL
         85kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794808852; x=1795413652;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WFV4t0eUs0gbqqsFkBQx5rUyLF4Yon8sMLY8mNC/aTw=;
        b=oQH7e5z+8/KUhLLwJi8zkGi4HVRB66HdkH/e45OJclEomWoSJWh3yTM4iAYhEFcH2D
         ZiO6pJDVzQA6mK+wTD8RK98P4e506WVfdBDK6o2hl8lXwhn27N+iAPg6vbdy7oAwo1A/
         Fonj1mOf3/rsQrShPJ3IqrR87LhPc1SrdvuGACF5/mTA8Wc7UaPXH6YK+SJyTuWiCK00
         ifJgAZ3Od/tUiGASjsX6StN/LZbP813JD2dZ6zgRlnqeF/gejdHpI3+iDrb8yyJ7yFaw
         cZ+3+PwMITfYkslBQ3cQrCYG/oqu5fDv35pRlcv3zVPZUj1/2jkhsT/5c9Q+OnQABxAP
         OMOQ==
X-Forwarded-Encrypted: i=1; AL+hErEbI+Ljnsz0kpR27HtKGPrbZnUWsVEMcYTHfpXqdSiaHtvTch/7GLwUdSKjsvZ6VEoI2tSywaQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z84izJ8477V31rm6u0LgxPRw7yfTZxgNcQKZGrWuUMtzgIV2HHn
	lTZyDcNrdYo4AL9MqAPVP7oXB3Ept6Bup2sPoL4TY1L16t2VoyALVzOdM3WT1BLv8kY=
X-Gm-Gg: AYBFou0KDs8kj4xZrPTO/MRY4eN3WJxdTMJF10QjEl/p3JCqB+ePgQD6UFEt16lHASi
	DISF3e/ZSHrgdpXaF0bvWObBep3AVoFgkiypiFejZyDg6K635C2V45+R45lWEhWP1GqOFtnLU7E
	Q1COlfm3LqLeeODJA/R4TzxnNDbnSutqutTUR71h+zmjEthhiMKjPK81nbG6/Yycc2mCXXasLiz
	E9Eg/Xzb/6nXDwgcKHsH/FN/tBDN+JCxMIqu1+SAyHEG+F8KX2A+V+A5TPBKpu6SOylnYL3p82D
	MYgyrlS4+xhGM2bGVfDCiaWBGkJyvfF7DM+D0iIPXyoVSxGN0haMWTmEeQh8UHlkEPUGgOecW0h
	8C+tYpfyFX45df1eO+EABjyp6j9eXZDKw+8XOxc/ZxGIYd+4B45dM455te+GmRbGDfuvWlg+KP1
	qMZI68OrG/aGhKtHDDNon1BAHM3UT/JKjACuJlInZGTLE7WqQGtI/MwUltl8YOzfRQkTPJ7IEu6
	8ETHcDqWNjWaBDlrihLuEB8Jx3MUrA7g244UUosHgdMFkvwBIMSYC+45R7jpgJWkUTgAz/XdsmO
	bq0oaW1zvO6kJdEooyY=
X-Received: by 2002:a5d:5e85:0:b0:48d:f391:5c45 with SMTP id ffacd0b85a97d-49c740bcf7amr18562595f8f.42.1794808852035;
        Sun, 15 Nov 2026 22:00:52 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c6020bb7dsm20283638f8f.33.2026.11.15.22.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 22:00:51 -0800 (PST)
Date: Mon, 16 Nov 2026 09:00:48 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Jintack Lim <jintack.lim@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH 0/2] KVM: arm64: nv: fix a couple bugs in AT emulation
Message-ID: <cover.1794808373.git.dan@pereq.eu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

These are two bugs in __kvm_at_s1e01_fast() which affect nested
virtualization on arm64.

They were found as part of our Formal Analysis work at Pereq.

I have tried my best to get things right and I have tested the results
but please understand that I am a newbie in this area and review
accordingly.

Dan Carpenter (2):
  KVM: arm64: nv: Fix AT emulation for TCR2_EL1
  KVM: arm64: nv: Update the shadow MMU's VMID for AT emulation

 arch/arm64/kvm/at.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

-- 
2.53.0

