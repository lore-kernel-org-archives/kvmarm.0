Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF01922A4E9
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 01:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786065204; cv=none; b=gYhhKHrGyezFT6IlhQlcoSCIYJG5rvkA3IGxEBug0Fh20uBVamfD3j3Mc4AQjIpElSNPkwFgxseUQ4CILOTF1F+RlXTfop17LjbczX0tdiTwO8pVzYokzdunxmcAEJRqrPz/o9Ys4kJJfaSOochJJ/qKFe9ijHKsu28PDtv63c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786065204; c=relaxed/simple;
	bh=SIIgJPGFhz5hNnkc11W1Z33TkabJ2YrobQTf7snc4jY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=clA/lm0kQkYk8K59dv7cE7fAMGzDv6ZCimpQQKYegTzSjAS2+6H/DBbL1HXARoxtA772/TtM637gTFMuI0vGmN1pj2K/G8aeVQsD/F995s3Rr6J369lvob9lXWq2oDOPRtoeDdKjfsfPw73hJIp2Xi/6Hm8Rb0WfvRFtE5m9zVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bAH3teYR; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bAH3teYR"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so4208595e9.3
        for <kvmarm@lists.linux.dev>; Thu, 06 Aug 2026 18:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786065201; x=1786670001; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JhTAK8kd+tCRfVOm3LmowAQ3BoIBHWxZmJ5DLNOQvkM=;
        b=bAH3teYRr08z5BGG0Tagv3J8KqUWClLfZ1gm0SY8WQiEc4KxhuI3ol1+YLC4kgBqW5
         JhovqmPtyHB7H9eQipKzCIiAe+WV7OGiXMLGGlzkT0VRJfU8p8sKxNTXhMKbh0g2TjN2
         dU/yOWKzuwC92MIwYlEYt0uD7Q7m9pDwFwTiPn9KBjUcN7bZ4mFJIkYZjbAdHUsu/UXt
         DyLkTT1R3T4Dk9M4tOZEzPpE+G1ylYvo0dCyDFM0onO/RUua9BZRwvdUycQjF3r4rQIY
         ly38ATN627X0D8K+8nid2EVubaz2qgTxD4zb364g9n38tqU8jZN09/68vgHQH/Zu2R2y
         nW/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786065201; x=1786670001;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JhTAK8kd+tCRfVOm3LmowAQ3BoIBHWxZmJ5DLNOQvkM=;
        b=je2DRzUpq2XJdy5KBJzNup5ft+G023s90Ob5h04FMqukoBgPGdHsfoh43juwCkEsDi
         JMDjXc9hodOOIduCvhMsh53j3tlJg6IW7co0FjnkMzDxSTtjq5x4l+RD5OsSuud0wDpe
         dGO2CEHoasV/I5JCMJJz99YK/x3JKd7d8gEmpTAOpDyYiNQITCLg7IDJxrfoHxrCsgRV
         O6Bux9K4pwJ7tPSz4ViUtBfRUnOOO0TyBkWSAIMhfDL4syMppYC6TvdfGwOsHc3WMHY7
         q6mthhH3dtFSOKQqXe/bzAOP2n0nJLnDB6np9h1kq34rC0SDXs3tMm+WXPo01eB/8gRv
         HYbg==
X-Forwarded-Encrypted: i=1; AHgh+Rq0zG1HKgAb8UJwGXmnf40LdCAdrWrSbOJA6RyZ2QpCbBsTQsuP2HV6otqOoXEBtGjXeXj+dzc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxW1K+CgwaQzB+hPdepmp4v49v2Md5vokbglZV5eXtr8DLzxG93
	YnUwXhybK0QDQR5iOAIpNjrRyMMO1wAacJq2NPiLLN8B25HSw9nUB+3y
X-Gm-Gg: AR+sD13a2582QEh78QW2MFSCeMiGgK+pvBwP6tQrvrsFvLh8OOUmtJWO//Je5obI0Hq
	9ddXBmJGFGtz61usbDAVamqipr0lr+vO+V7pj3WNhRzbyH5P13C/KtgzigUNG++1bpl0ELof4oS
	YPa0yyqcE+xPv0h/0ix9kqywHJv/2dKfTMNCb0rk1Znflo8qO5ejiz1AzhbgZqK25ME1lH1wMD0
	mc434EW8MMuVGrfXd8CQ3fm1OkZb81V+jiipbN+XCPjFkIpKP3kR2URixdcmZe14n7XJ/yD6UWM
	g0Sqjpd4sjvqwo8+Bvb0b6WlHn298IkYO5+VkZLB0Tbq3YweOCfraI/kdCS1ueUUoW5H7CcfQgY
	0bjHp22hJJIASLkTVxfJNOw4AvmvGbOYCG/OoLbaYYkHCoexModPSBLKvfxIbM5jJP9UkfR3A7n
	Qg9ovNx5dSzy865d0zill9wBLcIsuJn2zjfZye6MDqctifki1W9onb2/jHBEQYeibOGjxwxA99q
	bLk5iwqqQueBhRMMzkbgXhCnzBsyHSPo06FKH+P+0Ree/cKp7OYT6M1g/1xJMl2JuxoUMT74TzF
	uCB8y9ozLsXFUN67LKQDn/zpVrgeGA6mEfa49hBx2KW43K9BEnWK16ZuFlgdmLpNF5GW+su2EV4
	r7CzcH1E=
X-Received: by 2002:a05:600c:1f96:b0:496:c249:dd9a with SMTP id 5b1f17b1804b1-4994e71364fmr228063365e9.3.1786065200908;
        Thu, 06 Aug 2026 18:13:20 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-adf9-2301-8c14-6be6-a9e6-a2d4.310.pool.telefonica.de. [2a02:3100:adf9:2301:8c14:6be6:a9e6:a2d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995c8bcca6sm13771385e9.4.2026.08.06.18.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 18:13:20 -0700 (PDT)
Date: Fri, 7 Aug 2026 03:13:17 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, grayhat@foxmail.com
Subject: Re: [PATCH v3] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed
 addresses
Message-ID: <anUt9gd8HIwaj9jf@gmail.com>
References: <20260806192451.10169-1-kmehltretter@gmail.com>
 <d5svhw3jkjnkucohx2ntwhphemgbtfcmjt2zoyyw6svz56zfrh@z2ziydov5ras>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5svhw3jkjnkucohx2ntwhphemgbtfcmjt2zoyyw6svz56zfrh@z2ziydov5ras>

On Thu, Aug 06, 2026 at 10:54:03PM +0100, Wei-Lin Chang wrote:
> 
> Hey sorry for nitpicking once more, I actually like v2 more, as this
> version splits the error handling to two places. Marc's implementation
> [1] is also good, but that requires a twist in kvm_arch_flush_shadow_all().
> So I'd personally go with v2 (+my suggestions for it :)), but also fine if
> others have other opinions.
> 
> I also think the comment in kvm_vcpu_init_nested() is worth adjusting
> slightly, too.
> 

No worries, thanks for taking another look.

I was following the guidance in include/linux/cleanup.h:

  the expectation is that usage of "goto" and cleanup helpers is never
  mixed in the same function.

But maybe keeping goto is better. I'll wait a bit for others
to comment.

For the comment, I propose replacing the current text with:

	/*
	 * If allocating an MMU object fails, keep the VNCR page alive so
	 * that userspace can retry vCPU initialisation without affecting
	 * the VM.
	 */

Is that the adjustment you had in mind?

Thanks,
Karl
