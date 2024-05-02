Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C0D3EA76
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 07:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714636729; cv=none; b=PA4u8DizGJsrNZcnQlCNJXqxse42u+lRE1iVF/itKM1lhSJWnsqD3B5ZCObeeAl8GPNWEtNXau5HpsjCMA6Puj+73T7g7WYfQMQXHkPNMV0Jjs/I5LG4c41k8so2O0pXn3gv1iIlLWiKvomwVYq1lqsMO3C1BMf/T7aO1igLYt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714636729; c=relaxed/simple;
	bh=M6bNAlUWFAUVedhVV7/Ef/MA8rIvBKks3JV/imDXzTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C79viq6OsExyND+1qZpZf+jhxBFSb4r9IWxjK7Q24x+bUw7ZOdRrn+E7OhZsV2s2hhAEJBhPdEehHfH+rZt2aLdIngM2HBbsDcIzTvJ8H+MDihwQBw8y0ts+cxdqVm+Eg9kHsEX+CU6jQS0uJg5xmcrPRE5m9k/QU/MkRXK+ZG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zc5I8WD0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zc5I8WD0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714636726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CHP3GjDVgcLRBj76hOfDQWMiYZpjeo5fFoO4QDsCmSE=;
	b=Zc5I8WD04ssolG8y5GdUc5gtywzWXjlYM8Uwsl6HDz9mxZ4mBjLLI4hp+3PNLnmjPmqCLF
	PKG7bhwp+s9C8Cu48I9LOfx6yuUjNYizIlZGGd+oY4Zq/3NLpjVUnJBT3Kk2lgIr1BI9R/
	/Mv8jN8p8V7VvJlGR5Ud4/ZGRju07Z0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-pZt-_u-nMaeGxkvHHoH53w-1; Thu, 02 May 2024 03:58:44 -0400
X-MC-Unique: pZt-_u-nMaeGxkvHHoH53w-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-790f5a68b83so493063185a.2
        for <kvmarm@lists.linux.dev>; Thu, 02 May 2024 00:58:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714636724; x=1715241524;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CHP3GjDVgcLRBj76hOfDQWMiYZpjeo5fFoO4QDsCmSE=;
        b=kDrBB+7m2TUS+qXZ7gp74hpIAFFZMjQheE25S0pNRUZ0FukcWg1QOpm5hD7Al0qfHu
         aNUKhbicabFiozv8pgqx8JqfZPSSrUENdgoTxm6gsDiru2yqcgxollwM6DgCdlE0bws5
         rjUnm7LiT46qq0Ha3efZsiKAx92NIolxilm45GJ5LvYpQsYTXlzFZHT8DX2Z9BrL24IZ
         eMVeBhzlvdAque+5z5XBfHTuxUxLm8M2e6gTLAbn48duVRBpnWmulkYist9/pxsLaDE8
         RgRtHdx80V/TWEmb3CYPfcJ19ELbaDJO7gnp3SoEmyruPujhH30yaszm7oxj4pDcqgw7
         qHyw==
X-Forwarded-Encrypted: i=1; AJvYcCVsPmRIdC8a22viAx8DU1YmjZpxu/16nKwHFsB3LSpy1PQ6bbgu2mI3OdOFYjuMlHFyTR+VIJDSq82hjW/tRUokyZrEkRy0
X-Gm-Message-State: AOJu0YwQSDc7TfMwc+dyn4u5dBfEfnB5ZybrT7xOz2hhTOzxx6DFb+rK
	QO5ARU/HVfUjOy0Ni+xHjbcQosCqihYve2bJPJnmlBZlnW+OIZ1i4OMQQ68mbjHpKOcO1Mkyeae
	AnRMnR0quKZo2HkqXj/fUPnobLXL7U3+FJdOEJDygRsSVK5rzLG9eDQ==
X-Received: by 2002:a05:620a:22a2:b0:790:9e68:db10 with SMTP id p2-20020a05620a22a200b007909e68db10mr4788251qkh.5.1714636724032;
        Thu, 02 May 2024 00:58:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfPs/80kVsOGbEIowCh7I12Up+qoGrvJCwcHBhGjIAUjboedJxmagzloxRfQpATVk8ujnjNA==
X-Received: by 2002:a05:620a:22a2:b0:790:9e68:db10 with SMTP id p2-20020a05620a22a200b007909e68db10mr4788237qkh.5.1714636723717;
        Thu, 02 May 2024 00:58:43 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id g4-20020a05620a108400b00790676d0fe2sm176981qkk.121.2024.05.02.00.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 00:58:43 -0700 (PDT)
Message-ID: <c0c32041-38b8-4918-bd6f-7637ce515fd2@redhat.com>
Date: Thu, 2 May 2024 09:58:39 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] arm64: Default to 4K translation granule
To: Oliver Upton <oliver.upton@linux.dev>,
 Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20240502074156.1346049-1-oliver.upton@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240502074156.1346049-1-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/05/2024 09.41, Oliver Upton wrote:
> Some arm64 implementations in the wild, like the Apple parts, do not
> support the 64K translation granule. This can be a bit annoying when
> running with the defaults on such hardware, as every test fails
> before getting the MMU turned on.
> 
> Switch the default page size to 4K with the intention of having the
> default setting be the most widely applicable one.

What about using "getconf PAGESIZE" to get the page size of the host 
environment? Would that work, too?

  Thomas


