Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510D750276
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458737; cv=none; b=HaUdbFyrpEgIt0NMB6FFWM1OFkpypbxE7SJGT+QOGsDBnltxWPrLM9JvtxC6fQE33TnAuaE/+dughJkRk9G76nVtd5A4vP8omxZJosWaNexTGOAKITpV1hlMQNbuCiSGkTGbcRrRVE+TH933rvxscf5m8XqvdqoJRwPZnb9IGmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458737; c=relaxed/simple;
	bh=y/Vt/7o7UidbX5PJ0irZISyAqYPzc1kKuttTNSgvcM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XFmF4u4MixCDmYX45g9h75pKEdvgmCqbKWy3WWncmEBMiZY2RilH1XbHqNttL2Wco3GZl+U8Y1eC+lac8eXUmRhrT3826Fw95U0C6B6o1zky2MRU3c7LWRLtxoedI9G997yzeS+KOkKhViXlwCZdasHfiNQPfSmHcqZbvLv6FuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IICIHKTv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IICIHKTv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734458734;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nDkviBfNZ2F8uB4fxuvKv5iQl4CHchMQHl8YCgZirPw=;
	b=IICIHKTvV/t+ORIlifqKioPluIWkzpJymFhvxTzLUXboRVcMw6ac4LaGG49h3AWGeBt/WT
	JYFIzpw6NkaRiIGhhZEeQmRPez9MinjlybrtUbaETKd1fopeuPUhNnSyls1PRX9WV3pD4/
	7QrUV+xKBJ3UD2/Xp54u9Hav8/BbLjg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-np_EiKvJNv-W2__X_pfbfQ-1; Tue, 17 Dec 2024 13:05:33 -0500
X-MC-Unique: np_EiKvJNv-W2__X_pfbfQ-1
X-Mimecast-MFC-AGG-ID: np_EiKvJNv-W2__X_pfbfQ
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b6e1b0373bso725174185a.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 10:05:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734458732; x=1735063532;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nDkviBfNZ2F8uB4fxuvKv5iQl4CHchMQHl8YCgZirPw=;
        b=PQAs6mw+R3GhCuPo6VEON8rNlt3updwpgco3GFgox57TwTIeqI6mtQMavbjtkJM3xf
         Ifmaz0m4BgRNrE7fz3X2y1Utt58W3dbbqVI5FGoUIWglAATlxLFIA62AYTnaSi1s1bwq
         UEsEVzY60ESB+7h6thdvTTdfD0tHKJ/H/vPYWTjpjSX5w1HRAwt3qT5k1nKG5nCc8OOz
         zBlKQcETDMqQ4sn249/bO3/HTgs8pyKu67Rtu9DW0JmipTzS4BVh6H1LhLYKKt3NeMwy
         J2+4HPVwOTi2YTajzsZ8P/KQBouzoUdyBM5XEU5tqnb+g5AWC5soVqpALxstwBc7ZXSc
         YuOA==
X-Forwarded-Encrypted: i=1; AJvYcCU3ec696HawhNtB2z5GVQ8hNGI48rI7Ycj1m+Dasc2UnUlIqDIDeSljHeGIxo6lulk89FcpKJg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1xzmMPngVHGn5eFxhT5F59RdR1G47eUfS95+XYhLf0kRlJqbh
	BpJuyRTuJMcL0JBbtbibOmwLvwsIThDQ9qKm8DV6Q1UxqTFclwOMkkQ2dA54wbq4FvPYC0wsFN1
	ElMDk3eRhmTH6FtoIOcQAlepOU7q2gfHD5P1kJOT+8wvyy/kk6lcsEg==
X-Gm-Gg: ASbGncus/YvJ2CJ45q9XoPdlY6yWKNJlcIoFPi+zVq6JrehiPDbpHcF/HeVPJNkFNcZ
	LmtsHl87SG5ulNlBKrVj2KLc5nMkr25DbJcX73WTZ+eA+aWxk5b3L08uGCLumVOA97p3fv9W+cW
	wafUsMo+5Nrk3C9q3Q8sVkgY3stDdbRLld14NXcHZybxPT+JFfMXamXBBQqOnvxdwSv5Ui6Zj+o
	lInRtmRxnMeTSY1hby6YFdy+m298VNBsjdIPHHAX0qe1Dv3pTShKZlVXh4aaWSSqJ2V2LdSam79
	GikB8W0VwMIH4Bs871EFrRBlnAt9
X-Received: by 2002:a05:620a:2b82:b0:7b6:6d5a:d51b with SMTP id af79cd13be357-7b862614d37mr91663485a.52.1734458732604;
        Tue, 17 Dec 2024 10:05:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEW5ui+wAo2PD865w59h6YULPD8BmamaM8eh4GamkCEeJhSprfad2zvG8PzjPN7tfJBCcllbQ==
X-Received: by 2002:a05:620a:2b82:b0:7b6:6d5a:d51b with SMTP id af79cd13be357-7b862614d37mr91657285a.52.1734458732294;
        Tue, 17 Dec 2024 10:05:32 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b7047f07basm340407585a.62.2024.12.17.10.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 10:05:31 -0800 (PST)
Message-ID: <6f665483-61ff-4a5e-adff-24e8bc1cca99@redhat.com>
Date: Tue, 17 Dec 2024 19:05:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: Marc Zyngier <maz@kernel.org>, Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20241206112213.88394-1-cohuck@redhat.com>
 <86r066qqs1.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <86r066qqs1.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z2w72d-ckkZzmVdV42rPo5WO6Ta7FI73OdewuPyqHe0_1734458732
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 12/17/24 16:21, Marc Zyngier wrote:
> On Fri, 06 Dec 2024 11:21:53 +0000,
> Cornelia Huck <cohuck@redhat.com> wrote:
>> A respin/update on the aarch64 KVM cpu models. Also available at
>> gitlab.com/cohuck/qemu arm-cpu-model-rfcv2
>>
>> Find Eric's original cover letter below, so that I do not need to
>> repeat myself on the aspects that have not changed since RFCv1 :)
> Does anyone have a branch containing both this series and Eric's KVM
> NV support series?
>
> Asking for a friend...
I have just assembled

https://github.com/eauger/qemu.git
v9.0-nv-rfcv4-vcpu-model-v2

Totally untested atm

Eric
>
> 	M.
>

