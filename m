Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D2127713
	for <kvmarm@lists.linux.dev>; Mon, 30 Sep 2024 06:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727677247; cv=none; b=NYY4pw4DG4f9LiD7k2Ok8CxHnzoiBfrpQz/QvT6ktJyYjh6UccW3v4n8g4Klkix1fsSbu94AKXbSkFv5Ohese+VReqGZ+1IZRbl4nUQuYkU4bIvS129SFUzupBW6147/XutLZAq3HIVsKFNacEdMu57hFv6jREfBtz/FxENn3yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727677247; c=relaxed/simple;
	bh=pGPc+JYDsZqFewmXA9OYhQgLIhty7QPS90kktb+w6AA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MsXLfBYnfPmeBjKT2uK1bTxpYpJrQBcRpo9n5efUgL74gZjWQNaa/PkuI6OOkz5fa2sTQmprcG3zjyBgqCq1+EiDRXLUHZSJVSn5WqFES7JvUlIniitSTgeZmHcYR5k2RKMvi6T18R7+1RBUlR+HBgrOobecQm2iHJQ1UmpHSJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NQQjrVY8; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NQQjrVY8"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7a9a3e731f9so368840685a.0
        for <kvmarm@lists.linux.dev>; Sun, 29 Sep 2024 23:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727677244; x=1728282044; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhTbPt1aUPRRqMfF/iI2ldaEOQJQVcgQDTvk5oRV9Co=;
        b=NQQjrVY8ueCYs0bzsfJBBmpi0Vk4U/Ae3YNGzha8ObJwAYOJojZdYlz5yCCeTl1Zr4
         kmQ6CwlWd3N8UkS2CKcGI55JSlGiAy5bs76GKnlMfnAZbyyvScH0npKqlbRI8wRRc9I8
         kUvb4JUXOQXiVal9AYZWtvXW7F+ncjWgKo/cFtIyVxG3DngZqwugIeYe6rvHZ+mMaUOF
         ZhlEr4ZNZqGVzUWNhN4a78t2pLqYpU9r3VNOzrbWOptKu8FC9ULGC2fKdBlPCTVMPaQj
         +zDoYtSuwNtfqKLf6k4+WSCw28riXfCVXdkmIRBRgKGZj2XcTFz6nRLi2tsgptWRZqi4
         3d6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727677244; x=1728282044;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NhTbPt1aUPRRqMfF/iI2ldaEOQJQVcgQDTvk5oRV9Co=;
        b=EdlJzj1rLwrD99209nXBTtczZhhDZpFqkPM5Pao16K8giWKEXvy2Vcx38uIWdBg8Rh
         BPERoPZA2LDaNX/ui15qfUl6oK/PEblTLP2rMMSVEwsrgsgjwXK0Hof4ebyS7HkfgUm7
         t43+EWeOjCPni8KLDHUL4e/VrNMWMfOz6abcMdl7MnzvdZKTXrN4oC+GRuwA+QRGQmnv
         wOW2uij0kJobK7oR5LA8sE9STJj7iVr4hJTAd+nlnUArEivWZJDSLWga1FNLdmSrPXYe
         qzBakqmBdiBJXqOhi0BlObqMIdBA5K2ak+XyDCZIeL88OMdbO+cYpTxNTH1rFDcIkkCN
         eGww==
X-Forwarded-Encrypted: i=1; AJvYcCVdC2T2iHP/ZiVvyVaTt8wY3CP6RSoTx/aOERMYFIRHf8LgpyneHGat9J1Wyv0E0ZzyK5pXQR4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyg5xlGBLfg2lrDit1qaa0nUYL/zqGND7KDqIn38zUCC05NNiBQ
	UQTT3XrDUjGpqLNZkb1nZYqMidgr1g1V7NijPHyXCedCA6AGr51w
X-Google-Smtp-Source: AGHT+IEXLITWRzMYezDnabDByPKOLgZhSmoB9VoyzWMRR7EMYd6z8a4rkGrGOADqwIVxy1gGuMLxfQ==
X-Received: by 2002:a05:620a:1a06:b0:7a6:6447:19ab with SMTP id af79cd13be357-7ae378bc056mr1713694585a.46.1727677244482;
        Sun, 29 Sep 2024 23:20:44 -0700 (PDT)
Received: from jia-21cx ([185.221.23.200])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae3783fdd8sm383704485a.102.2024.09.29.23.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2024 23:20:43 -0700 (PDT)
Date: Mon, 30 Sep 2024 14:20:35 +0800
From: Jia Qingtong <jiaqingtong97@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Jia Qingtong <jiaqingtong@huawei.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic: fix GICR_STATUSR in
 vgic_v3_rd_registers
Message-ID: <mhwgdkcgoan7r53bubpvlnu4xoexmnldwlk6ni5zjvkn4cnr72@fhxnwlfw536t>
Mail-Followup-To: Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Jia Qingtong <jiaqingtong@huawei.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
References: <20240929043937.242769-2-jiaqingtong97@gmail.com>
 <87v7yevlyc.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v7yevlyc.wl-maz@kernel.org>

On 29 Sep 10:38, Marc Zyngier wrote:
> On Sun, 29 Sep 2024 05:39:35 +0100,
> jiaqingtong97@gmail.com wrote:
> > 
> > From: Jia Qingtong <jiaqingtong@huawei.com>
> > 
> > vgic_uaccess use bsearch search regs in vgic_io_device.regions, but the
> > GICR_STATUSR have wrong order in vgic_v3_rd_registers.
> > When check all vgic_register_region, it turned out that only
> > vgic_v3_rd_registers has this problem.
> > 
> > It's harmless since vgic_uaccess behaves as RAZ&WI when it can't find the
> > specified reg. This is exactly the same as the behavior of the GICR_STATUSR
> > register.
> >
> > So just move GICR_STATUSR to the right place.
> 
> That looks correct, but I think we should have some code that ensures
> that these tables are correct at boot time, just like we're doing for
> the system registers. Or completely remove our reliance on bsearch().
> 
struct vgic_register_region was defined in vgic-{its,mmio-v2,mmio-v3},
do you think it's appropriate to extern and check tables's item order in
vgic-init.c's kvm_vgic_hyp_init?.

> Another thing is that GICD_STATUSR looks pretty wrong. It is handled
> as RAO, but we never clear any "error" (it is WI). This has been buggy
> since GICv3 save/restore was added, 7 years ago.
> 
Let's change it to RAZ? We will implement the complete logic when someone
really needs this feature.

> Do you mind spinning a series fixing this up?
> 
Sure. 

> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

--
Thanks,
Qingtong
