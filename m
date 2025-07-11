Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE891898E9
	for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 14:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752244671; cv=none; b=ewi8E1CjwM+mGcsBlXbZMEKHA8zRBYnBo8mDBsOzDxkzTJczfivkyzr2ETZpMMMRZVl//D32f685PRtsEeo2O01kBcO4yjgJIbPxLSR9kRap8oEcGBLuozPIEv9WAf5pULHL9IY7+lhcL3Thqd392X+19VIQmLd9v3X2SFWJ8SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752244671; c=relaxed/simple;
	bh=7mEmCLR/fJHsoR5MqhPCbFckk4ro8dDzYNVP3ynwy8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aYLc+ieKIO+WmXkGcnTPwyvbly9y9kWDIYrBkjhsK6Z5H04PtNjNm1hs9OrFXkvKdatU6Oly4k+TBKkgaqEP5I6MwWSnYx7G7LviI4bd6T049oOBDLL9Y9ppj/Dr853JQAWrKba86oCHQEfkOMo0BKQOPLzh5OnjAFqjdedztZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HstFGfTS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HstFGfTS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752244669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/BU9s+p9vDeup7+iZfjpoY4Y+pfEtPqATP7w87mkUv0=;
	b=HstFGfTS5qlJ31tCReVhKTHkTsy4rWNJbrQlBux1U0+ZNlYa/EJ8IxicfvgVo6sFfWhwGr
	eXR/fOc8T8Y1gZutQqd4AbnyL4nF33YYXDOI+LeLEpJXKo1BQhm7msqt3Q8kaSvKse1Q/G
	ryL5aUJoKjY1Uj5nbXxUoQi/T0GK75k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-biqOcyNBOoSiqfYeG3Lesw-1; Fri, 11 Jul 2025 10:37:48 -0400
X-MC-Unique: biqOcyNBOoSiqfYeG3Lesw-1
X-Mimecast-MFC-AGG-ID: biqOcyNBOoSiqfYeG3Lesw_1752244667
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a54a8a0122so1230966f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 07:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752244667; x=1752849467;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/BU9s+p9vDeup7+iZfjpoY4Y+pfEtPqATP7w87mkUv0=;
        b=F2mfAoUiTMbYJOAKPH1HgdKK8HoW+kx+23QX/wvapwUcl/NYelOuqzcG2BUBe6FpVo
         0V/3RIVBUpiAhF8fgGBMcKn1XecZ2uh6WgPTWv4zMpu1xetwncos765HVRflSXhZkFXg
         EL4rWC/nun4n7WRZo/BgUcDTL0bI4ST+jXKo9z+sUBlrlLjKGMSZopUzPfKPbdVPICCY
         B04N6WEe0JB0L53a2wxMrxpr4cAKx+M+SRuwjI9yzHneQYj/I7vmNIPluABoxJUGaVGU
         vouXQXxkkN+ik0CY7INCfARDk2P1VAjbpaR/s+T/PULz9XcFZ/zehfhAtqNTXZRzHUYj
         bjYQ==
X-Forwarded-Encrypted: i=1; AJvYcCViWaJHkyMG68sIH3GW12c4iNQHbAbIyP/B67V6bnbbs/zFDTG8DaCnEUXVZiPyww/4yFSUiWk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9I0FEv+QA7Mxz57Ei7qZPmARtK1aTENrv0fpKAZ506Crz8J2i
	gr+Qa7QUJfeizNnnTqsXowfP6UY/Rp1LH/wKSNqRDhiHQGiUDQ6qJoX9KwN3KTiIvFWwEVVzWEL
	n5bbZoozLYkGvGGvx+OdLDoQ4HwZhRQB/l2K2gjprmnE4cDD8rOhwM1ORng==
X-Gm-Gg: ASbGncs0eDja0MQzgk6iaU5PPOuop5B8ljrxCLpL5pkL1KSKsvz3iKqaK+w/adloMNQ
	kJXEdHLUadqPDqQkE8kvqkpXACxB8j8PI35hdQ6MbfwQmvfhvM1ni09S1NHDL3Le9KPYyfJZZ+Y
	sV/oYcnqCbjuSLyGTYAGPrRp4TeAISo+JX2cM0UwQ3Wv5tfR2KHJX8NIX1RgiKgUugTv96vHmPO
	O+McJ3NBFPjl7Zp49DEbMdrThNZBr1wrTmbqTh72MmoGVXQvo2pVGeBkN4SHdVjIQqx/00zxfSx
	8FqWxkL3bLqeuF55/JJcUyDeUZH5wdrzCOU3LalGQWGuFPEfH5ot61gy4smkE1oT4dbsNTB3z2Q
	Agf+q
X-Received: by 2002:a05:6000:20ca:b0:3a6:d349:1b52 with SMTP id ffacd0b85a97d-3b5f1887badmr2596046f8f.21.1752244666611;
        Fri, 11 Jul 2025 07:37:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXCQnwKJ4P2xru4rDXDie6A6u61embhawOE9E4KtDmPAJ5DNlW7yRl8zSbtPMgPw96iVGU/Q==
X-Received: by 2002:a05:6000:20ca:b0:3a6:d349:1b52 with SMTP id ffacd0b85a97d-3b5f1887badmr2596020f8f.21.1752244666189;
        Fri, 11 Jul 2025 07:37:46 -0700 (PDT)
Received: from [192.168.0.6] (ltea-047-064-115-149.pools.arcor-ip.net. [47.64.115.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454cdc4671bsm74502545e9.3.2025.07.11.07.37.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jul 2025 07:37:45 -0700 (PDT)
Message-ID: <c1b1ca55-13e3-44ff-9889-f31f27501372@redhat.com>
Date: Fri, 11 Jul 2025 16:37:43 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 07/13] scripts: Add default arguments
 for kvmtool
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, eric.auger@redhat.com,
 lvivier@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
 nrb@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, will@kernel.org,
 julien.thierry.kdev@gmail.com, maz@kernel.org, oliver.upton@linux.dev,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com,
 andre.przywara@arm.com, shahuang@redhat.com, Boqiao Fu <bfu@redhat.com>
References: <20250625154813.27254-1-alexandru.elisei@arm.com>
 <20250625154813.27254-8-alexandru.elisei@arm.com>
 <ce92db8c-6d26-4953-9f74-142d00d2bc2a@redhat.com>
 <20250711-357d520bb64154cbe119679b@orel>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250711-357d520bb64154cbe119679b@orel>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bPngrEHaqmV2uKKWp6HrAgEbGpX6-ivA_UR09uWHMGI_1752244667
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/07/2025 16.35, Andrew Jones wrote:
> On Fri, Jul 11, 2025 at 01:32:33PM +0200, Thomas Huth wrote:
> ...
>>> +function vmm_default_opts()
>>> +{
>>> +	echo ${vmm_optname[$(vmm_get_target),default_opts]}
>>> +}
>>
>>
>> This causes now a problem on s390x:
>>
>> https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/10604334029#L591
>>
>> scripts/common.bash: line 56: vmm_defaults_opts: command not found
>>
>> ... any ideas how to fix it?
> 
> This is fixed by https://lore.kernel.org/all/20250709085938.33254-2-andrew.jones@linux.dev/
> which I just pushed.

Ah, right, thanks! And sorry for missing the patch!

  Thomas

