Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CED3C5552
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 19:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783367597; cv=none; b=dRMZ5rL7u7xFdTtkZhhJv9h/m39OrkKP3p37kgq7xmW2VhHB60m/C5x6dxh4Bmnfk7E/UC3y4xGY8WIQKXwCh+eM8KDNcfEssWKFAfgFxBvLqWQwCZKgrQ8C4Y8XZZlgl5NKld1MtYyk1nO4GHxZyk1453Nouf0A8jdMifcfCbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783367597; c=relaxed/simple;
	bh=1B+jpjxTx5TOVbLZW+lRl8rr9j7yKX/HAr+WiXhXlbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WolfNFKJgTvbaPy/JWnu09lnrwl5aGrhkbrTxwx7Q0gDMjsB7OTn/VUP/ja3YMKmEXmVFob8KyKVsKzWRHXxrak0V4lB+H5vcZxabgVyb6cXGiQ4EJ0LcfjdPuWdfTvUW5kDE+6wHad/PMMHiwVy/lCTM8crryMgVssONie08go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=mormQX5F; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="mormQX5F"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e6391b114so245671085a.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 12:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783367595; x=1783972395; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ryDaMDdUIlJtmHnTUoGTHsXnTD+6T4wqV6GsP0/9lPI=;
        b=mormQX5FRyXxFb7pnwY/7T4yGWFa41xyao/KSQQGUn6Jz0JiGSYwQ1KpeOC7isTdn9
         QvOSEemnIOC30nHlBYYy8bxR/c+r8LO6fX+LKr90OrPB3YZWEYWKlCFqIWJgyW2LtsXt
         KPUF8QKi7kydf/D8j3VH888f94uPvd5jfosVmd6nYmTRT7bM2RsrrTgxpIMQf/lxjEeC
         MBsDROuzRYCgbcAZRe4yYjOmMn50yelC/SzsmpEefVVLhKp9XPFWf4Jkxqgm8TLIj7Ij
         WRkwrHMGShm+1CYTkmYezLT+dZqd8vtjoFqIvnZMe+Q2NCtLHKJ54iYo601e4JnturxN
         Y6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783367595; x=1783972395;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ryDaMDdUIlJtmHnTUoGTHsXnTD+6T4wqV6GsP0/9lPI=;
        b=mhv3gjIddsJR07z+edPolK1JHOqzbQrmoHsHxz0aUU1bHt3OwnlB2Q8uAwqB80mbL1
         DUITR9zfInjqnedq0bWpNzUSPv6DB1leZ+O1zk//BUap1aft/V7QquUpMXdJR4Yzdu1R
         vT09s5ho3a95ADes0S/3gJ7wJAmAyyXxqK+3oWZocdW3P38T+Fo4Sh80YpiM2L2jH+wL
         1zjTSS11xj8CWTOA/wVnMIQ2J2NU5aJOGPNB+hXddiEyGjvRkvOtq6c/RkvE/NrbIIn6
         3BLJyvIcbutog6xmiux29poHBtc/bajYjST9XyOJRMRDi5iFITKizk8BGsZKpKOtEQ+e
         okeg==
X-Forwarded-Encrypted: i=1; AHgh+RrzxP9lRac50I9wCGlxFSns2jx4y3CC7yG7yeJTdVvKUiynEAEmHS+VhyLeDY7wyheLToWo16c=@lists.linux.dev
X-Gm-Message-State: AOJu0YwpQZyWN3PVWh2umPC9ARbKOV0xAt8glA9x1uc71qqts1VnGp26
	l10dUBiwtefGaCm+loQIorFjTMsnwfe8ToBh2GEsL53s+ZUjt7CgXnVfC++O8GGky9I=
X-Gm-Gg: AfdE7clUsifg4xIYPHDJp1cQM+L1b1+/cmDE7IvlUmHPhh3nwDUVSWCSc1/f7pLp1QD
	etXJLKhOuZtXBrHkg840xp8D0jio2opxMMzR5+7QZH7cCWyzOFexyCffCzf4Dd078338LSqINfB
	IsbF2Yh3wIJbRgPcIRnCxV1GeiNbPjomsd+PZ4G8RW4qYL3z0WlcQmocQf6Mivwu/rTnAaW9Rts
	3cPfq8NgziMQa9dg9U6CWdo28amf68W0Rma/SQx5o6FcqohHFZR4B2rLLaPxrRcriA5VINxxcba
	1ZegdIsw/3H2OZzmfDZzqQ90yh5NOQcArpDAs6wFZZYQVFtWE8cFNwv9xl6NTpFnJGTsr293M90
	Bf2dN6f1yGoqekIrI0o5JQA89MTfCvID7vhiSZVW1GinHuxhFR+biIjIh8II/
X-Received: by 2002:a05:620a:1791:b0:92e:4773:5a05 with SMTP id af79cd13be357-92ebb52f990mr273301285a.4.1783367594962;
        Mon, 06 Jul 2026 12:53:14 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90cce037sm988196785a.38.2026.07.06.12.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 12:53:14 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wgpNR-00000000euT-3bF7;
	Mon, 06 Jul 2026 16:53:13 -0300
Date: Mon, 6 Jul 2026 16:53:13 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Grapentin <gra@linux.ibm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Friedrich Welter <fritz@linux.ibm.com>,
	Gautam Gala <ggala@linux.ibm.com>,
	Hariharan Mari <hari55@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Hendrik Brueckner <brueckner@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
	Nico Boehr <nrb@linux.ibm.com>,
	Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 01/27] VFIO: take reference to the KVM module
Message-ID: <20260706195313.GE118978@ziepe.ca>
References: <20260706085229.979525-1-seiden@linux.ibm.com>
 <20260706085229.979525-2-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706085229.979525-2-seiden@linux.ibm.com>

On Mon, Jul 06, 2026 at 10:52:01AM +0200, Steffen Eiden wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> VFIO is implicitly taking a reference to the KVM module between
> vfio_device_get_kvm_safe and vfio_device_put_kvm, thanks to
> symbol_get and symbol_put.

I thought we weren't doing this approach? Use the struct file as the
kvm handle. I thought I saw patches doing that already?

Jason
