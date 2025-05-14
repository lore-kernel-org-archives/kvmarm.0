Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295938488
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747234079; cv=none; b=gy5x265lnwMXGANNExfsAfPKOwDhgI3f8YkOtxZSo/hfj8jaPLUwrUtmFi6FgoU0a9Kq04ftnsx5uCTh1xJLWOe+SwtFsQqezhiZjKW3CpMTR5Zaa1eryN0fHMiN22NOX98/bCNJoZrHoXqZN/OIsMZ+Y5llhOOjOdD6OwOJxac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747234079; c=relaxed/simple;
	bh=X2BsONOjDivtTgtkFsn0yv2PnUrWsXcvAaV+8U9+UuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bD8Wkov1wdLtLvgC625bYGHp8n4xHS/9+v/vR2lyKaziCas/GA+AEDOFHu/SEbVZnZuiy921aUmB5v0qRfWhv8NtOw09FO5xM/OFBULcB4V7Sza5FMa8G5ofgCMmy9939Xk85HXJlPikLTydi60mQm1k8Hex2dzzC+uJRJIXmlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KGBXjTy3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KGBXjTy3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747234076;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X2BsONOjDivtTgtkFsn0yv2PnUrWsXcvAaV+8U9+UuA=;
	b=KGBXjTy31yU31oYdSZKll1JahUtZ3PSKZAmIM5TRodPJUVcZPOvbcctta0Jvzxt+AuCNmw
	LThlMSSwnWlGFDLL2SA534T/JvS4mD1RGYaD55pZShNuRys7DV0I6QIl8lVki2c85elpAZ
	4S7eu/6b8Oqmoe0HbPey7vPvnGslTBg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-316-kfwusiPpNcO9kA8bdW87Ag-1; Wed, 14 May 2025 10:47:54 -0400
X-MC-Unique: kfwusiPpNcO9kA8bdW87Ag-1
X-Mimecast-MFC-AGG-ID: kfwusiPpNcO9kA8bdW87Ag_1747234074
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a1fa8742a8so2069245f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 07:47:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747234074; x=1747838874;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X2BsONOjDivtTgtkFsn0yv2PnUrWsXcvAaV+8U9+UuA=;
        b=PCjiVZJgnt5/Glt312PFi/Oj2BT+U4VXEBWCgbCR0fh/tV641lwf4dRp3h676t2jma
         jhqy/ZpXLv4XvEfeXokbDEAAasQN/tjKL/YEgXCdUOvMchIvRLQMEcCjT1LPtxvjy0Be
         JdMBqLvrjQi2nkVpJVIOTgaE4fnA/KXBXEd4M4W4NG9yGLBSsBv2eUcJBMnYHcYLx+G5
         fbEwg5aQ4KXOh4eBgXLEEXXNr3oFNIAvqqO4D0ynRmmLV2u12jk6Bvn+j1b6a9Hgnugg
         PQKz6TSPltV3YPHbxLueiz20Cj0Vy0LZBkakp0DUo1u6JG8KvWX8x/2chSk1Zrbpx6pO
         MFKw==
X-Forwarded-Encrypted: i=1; AJvYcCW213Y2Tb0R29h2gETdyWJvo30xjTRwgzxqpETTYrKYmiCVM0gqS0KX4v9pK/nLjA7QGmcFH5E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3+Xaj8ipgum7bai4xR4ZC3ByUVJXgkb8uqXwiC5tzn7O0+VuU
	MRouaASU7XivI6AocA9sMnizAWtS2tFqh9I5hFIww8idHL9tsgjkzb0nV49FnnebVjd0O4ujVzY
	2UqiWYiDK5j4CLo++2tfIqLMOU8Ew3stvBGa44YeySXB6Nr7q7MkZxA==
X-Gm-Gg: ASbGncvGQAlerw626H9/uaISP6t+JahazeNpwpUVUHW/HiqEcWfeyz4CK2d9ia5XmGx
	zPjsAVuNp+xDslau2FOck/B4KzStQ1hHLJymk4wjkX/d4U3ihokvJ6UoDfXS7osYWHT35tVYcyj
	ktKy+M0ad2y+w6Fm6WIpnnqFzCFWH2ihgpUH1GVq2FJCcXxyOE3pIEOS7UbM4KaNINX00MsKsqf
	v7H8QxP8CsPJgMEuv6Y+IV0YeAhqxwBoDrbyf984vGDdctyMPy8UHPykQrzrfZphlrzssOi/kmG
	djiAu4wx+XInaoSvYk+mdmVGb48QU/Yd2RciD9yB52AgMdK3hC4ulAekp+g=
X-Received: by 2002:a05:6000:2207:b0:3a1:fed3:7108 with SMTP id ffacd0b85a97d-3a349927544mr3236545f8f.40.1747234073710;
        Wed, 14 May 2025 07:47:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSU/glQYPaDOKhV61rdaTt6qL+5rdXjEA8/73Ln5jAN35z/SkLF6fJczukQ8V9uFKDnlfNXA==
X-Received: by 2002:a05:6000:2207:b0:3a1:fed3:7108 with SMTP id ffacd0b85a97d-3a349927544mr3236510f8f.40.1747234073308;
        Wed, 14 May 2025 07:47:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58f2af7sm20184529f8f.52.2025.05.14.07.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 07:47:52 -0700 (PDT)
Message-ID: <c8f14e69-21b2-403b-99a5-b34f4c9dc2c5@redhat.com>
Date: Wed, 14 May 2025 16:47:50 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Cornelia Huck <cohuck@redhat.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "alex.bennee@linaro.org" <alex.bennee@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
Cc: "agraf@csgraf.de" <agraf@csgraf.de>,
 "shahuang@redhat.com" <shahuang@redhat.com>,
 "mark.rutland@arm.com" <mark.rutland@arm.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
 <dadc4acd-97c8-4647-9467-89cd1966a6f2@redhat.com>
 <4fcfb4624f90491ebb238de76f04e4e5@huawei.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <4fcfb4624f90491ebb238de76f04e4e5@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WVUVoQv5ycUTLJgnDor_KHD-Juy4yNo58ta2fEMUPHc_1747234074
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/14/25 3:47 PM, Shameerali Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: Tuesday, May 13, 2025 4:30 PM
>> To: Cornelia Huck <cohuck@redhat.com>; eric.auger.pro@gmail.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; richard.henderson@linaro.org;
>> alex.bennee@linaro.org; maz@kernel.org; oliver.upton@linux.dev;
>> sebott@redhat.com; Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; armbru@redhat.com;
>> berrange@redhat.com; abologna@redhat.com; jdenemar@redhat.com
>> Cc: agraf@csgraf.de; shahuang@redhat.com; mark.rutland@arm.com;
>> philmd@linaro.org; pbonzini@redhat.com
>> Subject: Re: [PATCH v3 00/10] kvm/arm: Introduce a customizable aarch64
>> KVM host model
> [...]
>
>>> We still have to deal with MIDR/REVIDR/AIDR differences by exploiting
>>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit?i
>> d=d300b0168ea8fd5022a1413bd37ab63f4e5a7d4d
>>> (in a different series.)
>> Shameer, do you plan to contribute the qemu integration of this feature
>> you developped on kernel side; or do you allow us to integrate it in
>> this series?
> Yes, it's on my ToDo list. I'll first go through this series and then work on
> adding the above support on top of it.

OK. Thank you for your reply!

Cheers

Eric
>
> Thanks,
> Shameer
>

