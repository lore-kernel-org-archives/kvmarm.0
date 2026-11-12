Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794461329;
	b=oDObywN5Zzkum3ioOoaooAChQdrqZBZ1Cek9A2RsTr2sAD+sLbLn8mO/lHONGAgbzoc5
	 uUv4hYpiX1VqUEUADysQ633G0edrKpQUzgpm1Czs6BzDo0ZqIsarXumTz9BL0FijH764e
	 QArimrM7w4NAliE6hoO+xk+Q7jqYYIMMZDW9HM7gtCrVitCleDXpwtxuwwdX24zzFJAtu
	 JrTRcnDw56EP9hydc9rCSbco6Sg7DMtsoqNewqqQB18A2gJg1l5CxU8LStT1do1PSFdAR
	 s+iXEu0nGhos/0NWtQws743f/2B+Jmft9luvDbgNaWNC0243YQKWVaFUf4rWjKH0Zcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794461329;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=hNlfYdQobugmf9UW73UA0KZ3DncrTeY2FGpbRf8Ii54=;
	b=YBW8E8hBasOeYqqflCsRCm4hE78iKX8NDIRivk9TdNq8ASzmXiqKedFDNdWotO5Fw16S
	 pRNH1/9qdJbt5mRImE9b/chyjD1oYs9rFLc3kDaLOUo1rSYzKGcCthKAm4tQwEdvlNXaq
	 kJIPSMvSBJkgSOQXKsmw1aO6wnmdTQA7FWUlazjNRdiIFnkPnLQML+j0L49aYIWM6Xukt
	 iVQjixyRrteF/uUlDwIaljUlI0FJh/9d9lhZjOxQD7AfB/FoBC5I/Os08ThWgbBAzNBOx
	 QX2FE+zxI/c88Fiuhv+LXsLmialvyDq3YZ8so+Efr6KxBUNCmKAc4PTU2JXbbiCzzIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=pereq.eu;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8926A606A32A
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 05:28:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8926A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-490d59c3f0aso2063212f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 21:28:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794461327; x=1795066127;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hNlfYdQobugmf9UW73UA0KZ3DncrTeY2FGpbRf8Ii54=;
        b=Rdv9CThutWv2dk6lAZHBjFlL9Awjjlx4d8prWgcm6EhTztI2XrFDVsTwQ9e//FE7CA
         //ebQSCkSyW9d7qwpUIpKF6gpyBvedbrpSOC1nXbR5ps5CfRto4NlQauXFTBGB1mFZwc
         bn4kgAgdeO7XUIyp9mga5gPXizt2yEdeAZipD+u4ghMGrqTH7XXjO8GlA9d0Bv2BIPjm
         Yli01XjpLkH01lp/gOsp6BRyv7/UPXg9dvZQtKgiKzPYtl49YUAn2D/5942WCGbMQP91
         XC0n8Etc2WRmCSDTQ5B/G6dWZyLKiLNDSqoVsqZ/6pkrRxnGFLiXaT1VWjh6TstdUVKg
         LpJA==
X-Forwarded-Encrypted: i=1; AL+hErHwAUQo8XP4q9vZPQbvrBWBj5zLhj2VftrftSh+KD9sySymJup41rwVbkJE7JWu3RneLDkt2I4=@lists.linux.dev
X-Gm-Message-State: APuU4Z9Bc/ZP/vwJlmbPYLjFvIPeV4VHLin2Em1du2FVfR5LgbC07+DR
	N//tREWVcuq1Xt6mxgUjEqXBMnNMQw07mu+uE9OnM9jpAg/JcNrawl0w
X-Gm-Gg: AYBFou3YPK7a1xBb/D31T9q+mi/uXrs1nefIKSxhH7nHP+/VWeN1vHaRQckrLG4nyeQ
	+5zq6Zlh/VT65C9jIu6suP+yhucGHRih6JeLJHUp47489fjMKJXP3yRAnJUM7lSrkVIMtb10iJZ
	dqp5w0tY2ZI36PmGP+SsgE4zTbsI6SmwN44CnFuAdyeyOgTxYM1MB1jjQJb/yc2/aAi/KCQUkfl
	Gwxw+fqImmwgJIIxKevn4mY0svROvYNSDqCvYgJHPdlzqON4+mk2+VNtfvVC6m194HGwp8Zn3uq
	NY/SRIJ4OPuYrvu2zTAUIVlznCobqDZDtzHuYwb6IzF0Xr1EdV7vFqg7cKOZ3jF1sUOjBOIk3fk
	1MhJptL3jlBaNjlH8z6X2Qt2j1oiCj2L7ZVPoh+i7mYTPtQ4dR2f2NLtP70tOm/rIwla+AW7/4k
	+xz0X1uYjsHlsAkgqILfaQ5gCMyax37BH1a+udb+j3ZcAjpIOf3CYmumVfzXYXJ0GrKXheiAPva
	ldV8GbSds5wTdizzoFX+wj6lCk+m74gGO15PbQv2w1TWUdQ4uuLGSKM4LanKGTTaiIMj9AHiCuS
	IaSgmSeDCzTx4Pao2rYIuMFHZIU53/asd6qTn+lrl970pOwaEHOU5hMNt73482dKpVr7F6Hg3JM
	BJtESC2O9Oxosn/0mXFgULvDKtmaabrk9SRKxE9L+XWXWxnPISfGyllYV19OO
X-Received: by 2002:a05:600c:8708:b0:4a7:c366:d791 with SMTP id 5b1f17b1804b1-4ba0931c364mr69232725e9.1.1794461326740;
        Wed, 11 Nov 2026 21:28:46 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49944d646f9sm11119109f8f.32.2026.11.11.21.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 21:28:46 -0800 (PST)
Date: Thu, 12 Nov 2026 08:28:42 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Dan Carpenter <dan@cryspen.com>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: Re: [PATCH] KVM: arm64: nv: Initialize hw_mmu to NULL for nested
 vCPUs
Message-ID: <avVOivX0YmlES4Pe@stanley.mountain>
References: <d3571fb535e1832d2a067649f294b83d824d4350.1794395321.git.dan@cryspen.com>
 <86ld6z1782.wl-maz@kernel.org>
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
In-Reply-To: <86ld6z1782.wl-maz@kernel.org>

On Wed, Nov 11, 2026 at 07:46:53PM +0000, Marc Zyngier wrote:
> 
> I think this really needs a comment to explain why we repaint hw_mmu
> to NULL, because the next idiot who looks at this (likely me) will
> probably remove this line...
> 
> The other thing is that this means that nothing can evaluate
> vcpu->arch.hw_mmu anywhere outside of the loaded path, as it can be
> NULL. I *think* this is OK, but I need to really convince myself...
> 
> I'd like to add something like:
> 
> 	/*
> 	 * We can't rely on the S2 MMU being the canonical one,
> 	 * as userspace can restore a nested context. Nuke the
> 	 * hw_mmu early to ensure that we pick the correct one
> 	 * load time. It also means that we can't rely on hw_mmu
> 	 * being set to anything useful if the vcpu isn't loaded.
> 	 */
> 
> If that works for you, I'll squash that in.

Absolutely.  Thanks so much.

regards,
dan carpenter

