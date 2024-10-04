Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66791CACF1
	for <kvmarm@lists.linux.dev>; Fri,  4 Oct 2024 15:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728056466; cv=none; b=LuNcnPaw8WfGTZbWfAYuVWJYxyjrhdB+bna23cS0Gr6IFQ5ji5f0TGo8emnQe7OG2O65QWnadJwYQHkt1AJGnON0xUry/zj58yfd8aSR7X62+pVegsTUjQOZmYYceUvX/n1tL0P9VnNJcNz03tuWXEuiLX0GsBRNC6tcZ3mRcw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728056466; c=relaxed/simple;
	bh=20AmYbkEB6T41UL/c+4zUxfKyVux0mJtMt+1W48A3OE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N2Ubfo1FCKQB8xNtEXw6+N7F+4UpSF2dI6b5ygLtTQqDAneG99d+rEUQaeH30xrdOmtFp9WFdYsGn8kGNr1CfeS2bjow/n0a8YjyO7N7VAquVJpAi1a8bxaOiKxypSAr491VNUvaWOTBSBN1K4mBrTfnMGFKIh0RczHBprYIx6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xDHIJfKK; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xDHIJfKK"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42cb2191107so20667375e9.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Oct 2024 08:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728056463; x=1728661263; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xW7ABMqU3IEMi/eD8093jS3ka8zsbrF+KnmR1LU/41M=;
        b=xDHIJfKKqOOildn94HV6bfxWng6yi/9eE3DITyNW4CNFsVPEB+o5y5YWNfsxRolFU9
         QR7qSNzjoltwygXYcI75BEXpZ9zOKG+xR+/Tdb+VyOWObyi3ELo0EfcQLi3pwfvLi/xX
         zSPBDOPPD0sWvEnttt1UHtkXDZxUZofV49qDMsicCpWdexYthPT+wQknNKtZKWwSWjla
         RlB3TWO0uj131ktvNgVvzvNPw8ef8DzU3dd8QthJk3YXm+256uI2LZNppcXFzAYcSYBy
         swbpcKD3EUejuys9t17PpKurXvo3WlwhqNbPZg8gqxzLrJZHl22MXbrOMbSG//eR3TWD
         lsnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728056463; x=1728661263;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xW7ABMqU3IEMi/eD8093jS3ka8zsbrF+KnmR1LU/41M=;
        b=oqL95aZtucebmEhAENDZIleQ9eACoZuZ/jiXorxyTgTnosO1jtBhDPuzWVRLI/MjZn
         0dyOQaa2X8xD9iL5znW7I8B9WY8kp5zWsZlufS7bU1p/5ndWEgrc+ITzw5pjL1YqkxP6
         SDZNgWnb79laPCRBnk6/ByreMFk8E7YopN7nIJKVWcaqC7Fm8CScBQZ6PaoECvlJFGMt
         m3PuGfxHsFwxjnNzLdHYZMLeD0/QE7nLuFNCM0OtbqzvJQBT5EnKjk0iP4N1MjrJM6c1
         wbUwUEDFV2NVeCmg4KedjuU3lxfCi/YJj4fcpVB09DEFlDMEkhaiYOOggz49UcPeWkP1
         nhuA==
X-Gm-Message-State: AOJu0Ywx7oiYRf9AvIkO/rlJbvtFhMoLZ/jPptm8LcxRtFEp+gCuqdqt
	nltPYn0KMjjKE0XLfa2yCFaaofLdU6hkymvvTlwhUxzBi36zKiRGIXIjkydp2b0=
X-Google-Smtp-Source: AGHT+IHhAywax1Pcz0Li6Fk9RsdmnOkjJBPrOmtCbArSzvngrXf5k+pPbugCS/w1cGl4lFg40C3AkQ==
X-Received: by 2002:a05:600c:350c:b0:42f:4f6:f8f3 with SMTP id 5b1f17b1804b1-42f85aa3a92mr21374665e9.7.1728056463019;
        Fri, 04 Oct 2024 08:41:03 -0700 (PDT)
Received: from [192.168.1.183] ([89.47.253.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f89e89b42sm583875e9.13.2024.10.04.08.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 08:41:02 -0700 (PDT)
Message-ID: <cd1dda81-e23d-4f97-96b2-bf6e2002ea99@linaro.org>
Date: Fri, 4 Oct 2024 16:41:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] KVM: arm64: BUG when reading kcore with
 kvm-arm.mode=protected
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, will@kernel.org, tabba@google.com,
 maz@kernel.org
References: <f99c7436-502f-4f51-9a3c-c402b70bac58@linaro.org>
 <Zv1qeOOHjF0mv5Su@linux.dev>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <Zv1qeOOHjF0mv5Su@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 02/10/2024 16:44, Oliver Upton wrote:
> +cc relevant folks
> 
> Hi James,
> 
> On Wed, Oct 02, 2024 at 02:23:32PM +0100, James Clark wrote:
>> Hi,
>>
>> I noticed this when running the Perf tests so I'm reporting it here (I don't
>> actually need kcore FWIW). I tested from 6.1 to 6.11 with the same results:
> 
> Yeah, this is (somewhat) intended behavior. By reading kcore you wind up
> reading from memory that isn't in a visible state for the host (e.g. hyp
> text).
> 
> Protected mode is very much a WIP, and is expected to be rough around the
> edges like this. Eventually the hypervisor will inject an abort into the
> host for disallowed memory accesses instead of tripping a BUG_ON(). We
> don't have that upstream right now.
> 

Thanks for the confirmation. I assumed as much but just wanted to be sure.
