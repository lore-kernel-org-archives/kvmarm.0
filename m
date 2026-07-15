Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929E9388879
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 14:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126058; cv=none; b=AMYO4ooGxrRkK1lV2p8RJps7wFG/b1ZbCgp6qYuVhocvAphSCqwjUDVgrn/UHxR+d7CuIoTOiFmX7QZjYwqNA/uS69qCc4OX3NYrwZNqgO9kXEWz7CdTmUvQJSDrtClGO1051K4zz2DeSqRKOHyRUX+KUJVgk4UWrJLrFSjxY+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126058; c=relaxed/simple;
	bh=k8eKHIpCaaPLKTjtgUqCHzqXzJ9WDZ7k24XDEaWgMaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3SuSpDA/XK9+0ssC4QepptTpKlUwTuOCeReczyDJJM8lulMCnfsRXX59cDB5bxsrTPKEYa4gcWJKAGfFLq2kzFVKddxgW2lD4AyM75qJQoymHsVTeb5mvnZ7D9XHadXixdJjiiAyN3VZY/KTpXiR+wXoAL08r6iYb13EQQEGhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iEU/jQv9; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iEU/jQv9"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47de0093c42so1855851f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 07:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784126055; x=1784730855; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=knIg8/634584Ytue9vf6OuJG9Of4+644gUu2jDQuGXU=;
        b=iEU/jQv9FWo56wu+l37oMd60MoHhZqc0izobT1lGiZk0ZU6D5c9GnPaJvE3E1aF1ip
         hh4ajrhs2dzvWc8LLixIGcqp0tgtgc54wSnFzFXPOr/5f4v4Rjaru0ccAwakltvV42Eq
         Kj8msDxPfOaDbDWgUA5RkKkYO34Zuz/IhCvlYrsMO73SZWSvY2qTlllE/CvNzz9b87OT
         358ErdI1QG0a2mmyNSJAS1NCpUM70LMx963qjuj/iRrq5g8q3Mp31kyz6HzqzPhLsP0Q
         54kxsbVktLBeTrVRR/5iiyv8qXDwpPjN8YppMSG6VfdQMRHziU4zYHYjIIuozXxrpwlv
         U+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784126055; x=1784730855;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=knIg8/634584Ytue9vf6OuJG9Of4+644gUu2jDQuGXU=;
        b=qXhPBdc3FQqTWIX4+x2AdjwFNeWICGdKxMG3PP073UHcPdmZzcK+FpQxHrK9/ca7p+
         L0Ba3nM/o98E1TaHRTW7ys1/yCgBik2pjVLim0RUDtnh630NAiM1Q4kRw67KOYkja15h
         3z9Yp6d29CwyfzFB7eO+7mjD3TomFY4lG3jcqrh5RUeTqsO8ga1c2qptCKtSnBlkqsgd
         jc7/IN50xgFvM/nvPC1dmZ+XfjwbW4GDkmggAW8E4asr0nIbYTGQqCn5MAjhw/pTepdc
         kEXDjNvGVcjKhSf6uS++CretvFDVXkpWmaAk94Q0oh/Wgt1Srml7dolAs+SnWGBTsT4H
         PbTw==
X-Forwarded-Encrypted: i=1; AHgh+RrjXvpm0u/vio8XPcLNBCHQkBB0HTg35u8k902xKbM9pzka8gj9Hfhge8ANZMS9DSzXBGdnSxQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzzIdhqbm+LXRBwg0ufsogDCn4gzxqdziTSDiyrlCUjYpOniY4v
	8X225zcgrLU1OqexKwly5agYBP2Q9ehGJlN4SD92aKvLbHVvapPMcNaQhYGNSTAA7Q==
X-Gm-Gg: AfdE7ckSYqaGV6AwWPtdr/yJy3XlrkMyWysV3rSGnG4BuN6qPvumR7xb7+xlnncN0Ks
	moAP6nWxLltW/267jTZyEEaQ8iXHQ4abuoyVVu+wn1GMxjBtRjXQEqTil+5zzm3U7aNC5uCjcAJ
	BwbOmXnL4752r2lAr4y5IfCxZazwdLSWZWk9GPg3KhQnvd2csrer3yHn2MOmliyOs0GbBAI71yQ
	LaLBxOA6VNTotKyeJJQQ+iRik036D20Oz9APDLcNd8GkuTlvogOfytvHtRi7w4uixysZpxWeK9/
	vOsEkm/A3CGV2p14THev2T2rcLsnvHNQt8+Y9BqCvHBpm5U4fl/BHFV0UAcOHtrD/9u2wBfwmnu
	hO7qF8m53H6EMGyfYdjoCyjfVJVRc6CAZpia9TeaVrCfyeQ9C4KhvvKRn5wDJpPPs7pN9lFJizl
	/ApZJ3PgL8/t/xyotc+0aTLNckaltoEKfQxips/hndxyhIoPplcEOzdnyYVcfPuA==
X-Received: by 2002:a05:6000:220e:b0:474:e0f2:905c with SMTP id ffacd0b85a97d-47f2dccb729mr19822692f8f.26.1784126054166;
        Wed, 15 Jul 2026 07:34:14 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464a96cfsm17087436f8f.20.2026.07.15.07.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 07:34:13 -0700 (PDT)
Date: Wed, 15 Jul 2026 15:34:09 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v7 01/24] KVM: arm64: Add a generic clock
Message-ID: <aleaYVz5m19veRjT@google.com>
References: <20260715115906.2664882-1-smostafa@google.com>
 <20260715115906.2664882-2-smostafa@google.com>
 <alePwq2eKV5g_7Gc@google.com>
 <aleVozZEcxiGE4Y3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aleVozZEcxiGE4Y3@google.com>

[...]

> > #define smmu_wait() {
> >     static u32 window = arch_timer_get_cntfrq() / ARM_SMMU_EL2_POLL_TIMEOUT_US
> >     u64 timeout = __arch_counter_get_cntvct() + window;
> >     u64 cur;
> > 
> >     ...
> > 
> >     while (!(__cond)) {
> >       ...
> > 
> >       cur = __arch_counter_get_cntvct();
> >       if (cur >= timeout)
> >           __ret = -ETIMEOUT;
> > 
> > 
> > No risk of overflowing u64
> > No init necessary
> 
> It believe init will be needed as caching arch_timer_get_cntfrq()
> is much better that re-reading everytime. But I can make all of this
> contained in the SMMUv3 driver and remove this patch.

That's why I have made window static :) (well of course it is per callsite...) 

> 
> Thanks,
> Mostafa
> 
