Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED30358D32
	for <kvmarm@lists.linux.dev>; Sun,  9 Aug 2026 18:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786299119; cv=none; b=rWQA9Z53vk97ERsdGxtEw0/c8DBsj9h63fvbbTEr/WhOoB1x2+aUv52JxjWvfWGEtTEqlUUggY5bGQes6E/QgODD8A/xTF+0Bdh++QqoJHGHHcfJtuqZ9+xGUM8os2haEmzYH1613m99jpzzK5PAdTlhhrfjUmfNkPsj3kiSutI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786299119; c=relaxed/simple;
	bh=UzgFFcq25sDDfKoaHn+VXHNND3WRXeDcn+AQuJuIe+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aiDLNorPn8gjXAJNRXp4yUPmSlftXkEtdVHvJ5SQuOQwZi64gUk4vhN0vMh6lINSa5+zi/GndzTShD+pxBsGhbEh7U278kXsCYqHnuLpgj+lCauHgSSA1wiS059bRaUFVFHXjw8Vm3/5y1Te7oM8HSOroXdPpH4J3LcbbwqEDyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H9LniBNV; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H9LniBNV"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-476a130c138so1110757f8f.0
        for <kvmarm@lists.linux.dev>; Sun, 09 Aug 2026 11:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786299116; x=1786903916; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WoCA45LQ4z+3BUUhv5YOm84o93I32Yjtpc3HcvkQ194=;
        b=H9LniBNVPwmtycmp20fBW2IbZz6hYzkWOCrMzvVcxYlBRWKBmWk1ivXDKilKK23rRr
         rxFkzEg4NGnznMQ3/GNmMW4mlZbs0ST31XCibWAnTqP1Sqrr/tyuIolihhb9Sh4E/ynw
         ATHguD6YFRGnVjKdb/1MFzq7vJzIvRd+HDANKjLi8jMC/ST07j93k+zi76QCuWzPngo+
         BqkzpCT1uUzeOC2C909/H5LzVnsT0SPpmf7+vP8BfjK1hjd+xjmYYr7CgzayynU0n8qX
         6ZkY332b0K/RJzD5tn5YWiR8+uK5F8IJk76CNQd7/VCAAr8KwY9/lczJKIcatJsjOvIP
         T9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786299116; x=1786903916;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WoCA45LQ4z+3BUUhv5YOm84o93I32Yjtpc3HcvkQ194=;
        b=bt7SPV0rdjl+gRAGo9xvXN/LTSxKs1Aizwxmid1iEVBqR5GvjsBrVFQzqMLkveSl1G
         Olp+4v2X8xOiCqphNSond4ZyJvVQAqmVlDSb1Zw1pNu3515vQO4KW7pzeIk+QBjXtJDY
         eGywqWKRSbhCedvYiWA+lqMjtuDM8tjFkZJnO9rF7//qGP+E0As1TqloaPzo7UpkU9/t
         B53fJ0Z+OAMoSQFkUrl4YCg+aouDOQPmqmizMadY1ynmiiPDGi/qPrKPjD8H0ED9uhpe
         CgHQVuJaGVq0XbzJKhdDKsseEedMlGmA47iruQvkRcPKzF+CcKuF6TmvETQCm4Zodd/S
         mAFw==
X-Forwarded-Encrypted: i=1; AHgh+RoQXyioFrSr8t5XFeMZ3RGoA7N8Kn1hc7P09SHADyX4j9JZ0hS2HbHg+391Znlwv95gtXUUS7s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/V8oQAnD9Qh2QpsoPkHFUMd55qBI1IObg7SLvibQ6Kf2uw+7B
	WnkgNGaWdyFSDQlbTM53m03uoQwNIkQTlg1vMplx9UARhEch4mvKyY9h
X-Gm-Gg: AR+sD13A4FvKLGSAw+eVUPN8Fc+R03hmqv8kdTGRXnXEvQTCfthiW4ye9gP/Xg4ueEf
	rosSu2GyS0/zi7s6sDu2aGbvq4Dse79mPgUxeR80XHKAzl0mWsaeduzYQOzhNdeDzaCm4bSZdNe
	GSbcfxeMJE8EfDk/otDkrCa8J1Ng/rZtq9PusVXdA/Ssq0gLndANvzxG5bGZ2j5+UQsdHpEG2Pm
	10+XVO0Ms2YBuisSspTr9csHAiD02sylbQfcxYyyc5rdXhJDUUcqsZ0p9tKPLz5uApLUQ7F6doi
	hLMhZZUn93vz6yR8ZjMlZDFcOMk0OpnrVQw+PuFG9Ol+AeSWU7DsCJOMA5TKsZibc/M7P+oaZJ2
	y1VMypZoz9mj7A+yIarR/DGTssJPSd5RakTT0+5UJ1OsSAwQ5c6z6EWVCRYOXlFwizyMZQFlX4n
	hBm9lWFC2o6jutZomu8SXrHluURurjNNwF8UmYgXrOHW/l/LD6pEdR0ZMVeOMAsToYtTDCHunlh
	oFRUcJWkxdZwkw1JHe7uLBrZ+GbG6lTXxRbupgJ3rHQnTNvfOw9edb0KurfWAl3cGebNi5ynSQ8
	e9iswkkEoiVJmcSgYvYEV2UmJKptHkkyz/lUUcMOxn2CY27T+gijMdLriQEGomrfH2cSKhnHhxF
	pIQ==
X-Received: by 2002:a05:6000:22c9:b0:47f:e7c8:3fe9 with SMTP id ffacd0b85a97d-47ffd15cb0fmr36249046f8f.0.1786299116224;
        Sun, 09 Aug 2026 11:11:56 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-ac88-a501-9c5c-9666-3a00-3cdb.310.pool.telefonica.de. [2a02:3100:ac88:a501:9c5c:9666:3a00:3cdb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480020be8f3sm24111242f8f.0.2026.08.09.11.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 11:11:55 -0700 (PDT)
Date: Sun, 9 Aug 2026 20:11:54 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: nv: Allocate the shadow S2 MMUs
 individually
Message-ID: <anizGXThM-haqQXU@gmail.com>
References: <20260803224405.41468-1-kmehltretter@gmail.com>
 <86mrv2arf2.wl-maz@kernel.org>
 <anYNTW2e3HalTqTk@gmail.com>
 <878q6fplpd.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878q6fplpd.wl-maz@kernel.org>

On Sun, Aug 09, 2026 at 12:39:10PM +0100, Marc Zyngier wrote:
> My current patch is as follows, and so far, I haven't seen much that I
> like better.
> 

Hi Marc,

Thanks for your revised patch.
I think one correctness issue is in there. 

> +		for (i = 0; !ret && i < S2_MMU_PER_VCPU; i++)
> +			ret = init_nested_s2_mmu(kvm, &tmp[i]);

> +		if (ret) {
> +			while (--i >= 0)
> +				kvm_free_stage2_pgd(&tmp[i]);

The increment expression of the for loop still runs after an error.

I reproduced this with failslab. If init_nested_s2_mmu() fails while
allocating pgt, before mmu->arch is assigned, the for loop still
increments i. Thus while (--i >= 0) passes the failed entry to
kvm_free_stage2_pgd(). The resulting log is:

Unable to handle kernel paging request at virtual address fffffffffffff650
Internal error: Oops: 0000000096000046 [#1] SMP
Call trace:
  _raw_write_lock
  kvm_free_stage2_pgd
  kvm_vcpu_init_nested

Thanks,
Karl
