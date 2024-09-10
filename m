Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24DD23AB
	for <kvmarm@lists.linux.dev>; Tue, 10 Sep 2024 00:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725926993; cv=none; b=JfXkRqsCPaKxf/QwOzICHDrgYKJEbMF1uWZTX623Lc3A7Stb5A43B10jsi8puxw5nWXB9WUNADd2cbMkTz0sY28JDriinERyMw06N1HGj2fYMHH9kgCiYU9C9j/bk2k15xevnOUXFeXZ+JHt09Ml/JmLpmdDMmcBSo+oA5BhApY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725926993; c=relaxed/simple;
	bh=V+ndQboUKQbl2kpi9ghwnfZz1sbDkngsuOFkFc275Jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nh3nIoPs1Xei6p7NNXMeDk9q3CxJVN8o9Fh/SaVdCsrkf4h8/oaKTiFS4Cr3HbVITqt9zryNH9WldlN4ht5FmXLsul42eNBs6mBSG7WMFOgvMvbBSb4AMtAgUbJAhHtVNIAdCt7UGFBKNaMb7QJ8qBOyhufmb3KDrjrjtqfIC8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h4Wk8dEG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h4Wk8dEG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725926990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMaP86bC+hPhOjPzwPjEKilwC9SBm5gKL8ioVFK2IxE=;
	b=h4Wk8dEGgZhvLhmxdDlBhlcgRGcRneNcs0SEnmtUCBUq6Aina7liXNDs+/Ms46JiRSb95h
	Pa8Ok/xC4c9dyiJets7Yt+rF3bctTWtogK68wcUUnzAtIJGi7LNyffjHzm5WYx6oC/wz2y
	GZeb+Ksp2xYjf/AACoGOWY/V/DGX9iw=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-niErF_6fOmqW7FM6-7Rx1A-1; Mon, 09 Sep 2024 20:09:49 -0400
X-MC-Unique: niErF_6fOmqW7FM6-7Rx1A-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-718e129311aso2943248b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 17:09:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725926988; x=1726531788;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NMaP86bC+hPhOjPzwPjEKilwC9SBm5gKL8ioVFK2IxE=;
        b=P79bVwDqA3sMxy7RwsuILsKfq+BLr+x87ObiJlshDPI1qLTYmlO2d/agFA1T7oqLd3
         USHSvo3EOK5y9ru3Q1mawWOCT/SskYpnZz+RqxhW8esxqHIN6DP9ChyObY8jBk88p2KO
         SwBT+BwTm0tO130F4hqi/t67JqQ0Z+cfy3oyCP19XqCckYc3FZeI/vp0Yv2aC4IChGmC
         ufdsndutghM4OslYvENDQVnWYvASNSREg+Z33joHac1A2WqQjIsFjRqBWOq7noyGqFA6
         G+hds0vs5osbS1zysxicO5zAaDW9yy3FLj6x7w5YZU4rjoHZxAsCi6KvQd2XAuhoBS2N
         SQXg==
X-Forwarded-Encrypted: i=1; AJvYcCWvcfUwijdVyBnlJL5CJcDAKvT1z9Rh05SG2An6fctjhB8i52d8fAgg4jV6Ar/pn0NjpXPQe74=@lists.linux.dev
X-Gm-Message-State: AOJu0YxX3W32GV1jsHF2oI9tXquaRlRVSvWfKE2sM0ZsIcdo+Tx9BUL/
	ndPEWGDoJsRLmBsC5bIwU+YoocZZJpLVmOVyqvSigKiU0JY8lucOW7fyZy5tt/jgePxl0WCRIfQ
	7GADIc9vkqyXmEBZ5DDTgUhUZMnmqv1XvG2zNIc/JJVh1/nZLnHLbPA==
X-Received: by 2002:a05:6a00:2ea8:b0:717:9896:fb03 with SMTP id d2e1a72fcca58-71907eb88a7mr1676602b3a.6.1725926988286;
        Mon, 09 Sep 2024 17:09:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOPTJ+MAzzAaW9hu5Sm5LtqVY+qPsIcrMrv6ipiDOnyMneCo1T4P1xJfwBR5Lh/LAWTBHDRg==
X-Received: by 2002:a05:6a00:2ea8:b0:717:9896:fb03 with SMTP id d2e1a72fcca58-71907eb88a7mr1676558b3a.6.1725926987824;
        Mon, 09 Sep 2024 17:09:47 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71908fe29f6sm283845b3a.67.2024.09.09.17.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 17:09:47 -0700 (PDT)
Message-ID: <bb69bde0-4564-49d6-bbd6-95bcbd4d272e@redhat.com>
Date: Tue, 10 Sep 2024 10:09:38 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/19] arm64: Detect if in a realm and set RIPAS RAM
To: Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-6-steven.price@arm.com> <ZsxTDBm57ga6MkPu@arm.com>
 <2e8caa91-bf66-4555-87b3-52f469b2c7ef@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <2e8caa91-bf66-4555-87b3-52f469b2c7ef@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/24 1:54 AM, Steven Price wrote:
> On 26/08/2024 11:03, Catalin Marinas wrote:
>> On Mon, Aug 19, 2024 at 02:19:10PM +0100, Steven Price wrote:

[...]

>>> +
>>> +void __init arm64_rsi_setup_memory(void)
>>> +{
>>> +	u64 i;
>>> +	phys_addr_t start, end;
>>> +
>>> +	if (!is_realm_world())
>>> +		return;
>>> +
>>> +	/*
>>> +	 * Iterate over the available memory ranges and convert the state to
>>> +	 * protected memory. We should take extra care to ensure that we DO NOT
>>> +	 * permit any "DESTROYED" pages to be converted to "RAM".
>>> +	 *
>>> +	 * BUG_ON is used because if the attempt to switch the memory to
>>> +	 * protected has failed here, then future accesses to the memory are
>>> +	 * simply going to be reflected as a SEA (Synchronous External Abort)
>>> +	 * which we can't handle.  Bailing out early prevents the guest limping
>>> +	 * on and dying later.
>>> +	 */
>>> +	for_each_mem_range(i, &start, &end) {
>>> +		BUG_ON(rsi_set_memory_range_protected_safe(start, end));
>>> +	}
>>
>> Would it help debugging if we print the memory ranges as well rather
>> than just a BUG_ON()?
>>
> 
> Yes that would probably be useful - I'll fix that.
> 

One potential issue I'm seeing is WARN_ON() followed by BUG_ON(). They're a bit
duplicate. I would suggest to remove the WARN_ON() and print informative messages
in rsi_set_memory_range().

   setup_arch
   arm64_rsi_setup_memory                    // BUG_ON(error)
   rsi_set_memory_range_protected_safe
   rsi_set_memory_range                      // WARN_ON(error)

Thanks,
Gavin

