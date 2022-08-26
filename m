Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE7EECAAD5
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 14:06:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9560D4D6F5;
	Fri, 26 Aug 2022 10:06:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kYB144eqxl6d; Fri, 26 Aug 2022 10:06:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 606304D6CA;
	Fri, 26 Aug 2022 10:06:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7944E057
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 08:00:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hBumSgwfzeYs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Aug 2022 08:00:24 -0400 (EDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com
 [209.85.218.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C279A4E045
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 08:00:24 -0400 (EDT)
Received: by mail-ej1-f54.google.com with SMTP id fy31so2314232ejc.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 05:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=user-agent:in-reply-to:content-disposition:mime-version:references
 :message-id:subject:cc:to:from:date:from:to:cc;
 bh=MxGGd+3msz7Zn8awEDtaAUBprmyOYrYaH1QuR+N4/7o=;
 b=Gpo7N7AFg7ypzz4ziWV5/xqGFn6VPSfepZxdPxvYxjBT44+e2TYfUynhvuN4bgXRS/
 Y1lMBDwSuSvsL4hGB4NVY0v3EWF3sT7n/bwVeuIOO0ODHJdT0/abtE6mRH2DymksTXXO
 r1ObcZJ+e7Ndu8lJcEp/bXAX2zEQ1GVh4vtmyJ2otqk5MeOeGigP0uXSnvUviUdyKMUb
 9msUNjrYLw+GCjpRbA06oyQANC2DsCXnYbXtaRvOYkeCMk/UHYKt4JhjPsqcwksrWypU
 p8o94YuVPtobGYa1F4jwdkuKvP6bhOSsOcBBEtFTo7INwdfxMTydzpLeyUkWamzDAgnB
 0w8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=user-agent:in-reply-to:content-disposition:mime-version:references
 :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=MxGGd+3msz7Zn8awEDtaAUBprmyOYrYaH1QuR+N4/7o=;
 b=yBXbYU8YQdljbuqC7oEvSs+vWvhglfEDzvo7HvGKVb7YY4A86wEeucFYRh2VkE/Msp
 sHA8UKPUHWxewTVkHtVZ5GCAQJUDIklUc1ljcpQQJk5/fH5872nbvoY/gjawAIc+wMAY
 X2PEQYm1B+RTRbzgflNANWGoiTfXSWegUGX9cpyhp+bDyD77EwwN/LSzn1XjOP9gV4KZ
 VTWCL+GyIfKKoEY56DAuNGLJKv0QdUuzBa2o0xr2qVg0erXDVejOz0Y0NvusHYyJ6vaV
 9IqpIHzjaW152aea83fganvrXQHFQQwRzlYVA9OcGH1ISm9z+YaXe9Bbo2ApZSxcDmid
 QRKQ==
X-Gm-Message-State: ACgBeo32UkQsv99auYK6VBw0LfctYh3POiLjCnjEM0VDQPZat4DwSxOr
 TFH/hYR3FL+Za+Dfsi1SxtRuRA==
X-Google-Smtp-Source: AA6agR6pWzpqNgeu5nYDI5mFIoqg2F0SdV1dhlacTRMXfwMX4RTLBi/UMn/Zte3pGXH6yssBl9NJZA==
X-Received: by 2002:a17:907:6d2a:b0:73d:9ba5:633a with SMTP id
 sa42-20020a1709076d2a00b0073d9ba5633amr5386524ejc.201.1661515223724; 
 Fri, 26 Aug 2022 05:00:23 -0700 (PDT)
Received: from mutt (c-e429e555.07-21-73746f28.bbcust.telenor.se.
 [85.229.41.228]) by smtp.gmail.com with ESMTPSA id
 w20-20020a05640234d400b00447c2c1b9a0sm1164957edc.91.2022.08.26.05.00.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 26 Aug 2022 05:00:22 -0700 (PDT)
Date: Fri, 26 Aug 2022 14:00:20 +0200
From: Anders Roxell <anders.roxell@linaro.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH V2] arm64/mm: Fix __enable_mmu() for new TGRAN range values
Message-ID: <20220826120020.GB520@mutt>
References: <1615355590-21102-1-git-send-email-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1615355590-21102-1-git-send-email-anshuman.khandual@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailman-Approved-At: Fri, 26 Aug 2022 10:06:02 -0400
Cc: linux-efi@vger.kernel.org, arnd@arndb.de,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-03-10 11:23, Anshuman Khandual wrote:
> From: James Morse <james.morse@arm.com>
> 
> As per ARM ARM DDI 0487G.a, when FEAT_LPA2 is implemented, ID_AA64MMFR0_EL1
> might contain a range of values to describe supported translation granules
> (4K and 16K pages sizes in particular) instead of just enabled or disabled
> values. This changes __enable_mmu() function to handle complete acceptable
> range of values (depending on whether the field is signed or unsigned) now
> represented with ID_AA64MMFR0_TGRAN_SUPPORTED_[MIN..MAX] pair. While here,
> also fix similar situations in EFI stub and KVM as well.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-efi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Hi,

When building an arm64 defconfig kernel from stable/linux-5.10.y and
booting that in QEMU (version: 1:7.0+dfsg-2~bpo11+2) with '-cpu max' the
kernel doesn't boot. I don't get any output.  The kernel boots fine if I
change to '-cpu cortex-a72'.

If I cherry-pick this patch to stable/linux-5.10.y I'm able too boot the
kernel with '-cpu max'.

However, I'm not comfortable to backport this patch to older kernels
since there are a lot of conflicts.
Can someone help out to do the packport?

Cheers,
Anders
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
