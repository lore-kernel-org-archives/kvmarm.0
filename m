Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A05B1C3054
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730744139; cv=none; b=sTPLIFVBYRgHoT4txb7M5z57SNChz9eFxRXLeixgUutRzoiY7CorG2/p4gcyfmAUKAqqMDz5paCjfwMdfzOZ9zkDKbNFsC7GX0bYW5mo4vObLFz559kfgHv57+E7ucUCJw5ou772v+gDymaghbkT3cobyq0XQgG6VKcspqUEcjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730744139; c=relaxed/simple;
	bh=lBmPx7J81kPDhku9+xjmgrgbxAjE1ApCT3Q/Pe7qD4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rNXRDzb9fIGKZrs4JLQRCap+clGx0u0q24XLsK+vrsp8hjIvjDYQ2Tgnxwoxl8a/UlGbnIkUo1wY0nb1tFf9Dori+aCnSlIQFE4M+oAScRfmByx/KN9A4k0qayeP3iw0B/ooL2x0sx9i8+BrG1RY4SHCu6RsS3X8lQPt+FQICkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V0Q7b4He; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V0Q7b4He"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730744135;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBmPx7J81kPDhku9+xjmgrgbxAjE1ApCT3Q/Pe7qD4o=;
	b=V0Q7b4HeHI1zWgIvSPlqfjtl4VVdV+ej5Zos2UM//I+aN3uFyzK1W5nLJwJoWzcKU/gWxY
	2Of6HUNbzZbgsqZsXGPqYlvRHpRc1gyPg39qy1mzTLdev13hSQuIlLZy7bqAlQQpU33HMm
	Nx6sX/jl0dX4EHyukoypW5b0znmryCM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-_6ttZkSUOXqBQOtOZ0iZRQ-1; Mon, 04 Nov 2024 13:15:34 -0500
X-MC-Unique: _6ttZkSUOXqBQOtOZ0iZRQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d533a484aso2767310f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 10:15:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730744133; x=1731348933;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lBmPx7J81kPDhku9+xjmgrgbxAjE1ApCT3Q/Pe7qD4o=;
        b=rYStCRBXGoPbRucSnuYrIOvdJINqGEdBCJkDb6oCcnnC5AJRhaKI9BDXcXiIbzmJtC
         +VgSPg7uOhRWQ7MmNhev45kksLMj8dVL3jozPhvvE8bYHFfN8weK4aLduVXNsALby8Sa
         Th7OX0Cb2LlLRg2HL0avkDzyYoK6vGvtCMX3TYD6e9ogVLh9ptQf0w2drIHQF2CIuN9i
         hxsgcWRyp9eNq08V6FDgIa/E7rz0A1VMUuZJDnyJS5v5Y7fNskWdtRlZaC27GfrbRvaK
         oidFcFBDStjOYC2eu0veV5eXNdNqXLzxkT9DGat9k4s+Z7auJO0wEP/R4+UpLQ8dNliI
         flnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfUnhXh+JU6hs4Rx0E8AZLHvbPGJty19l1Zfx/yh4VvTKbKLjj2yzD9Kxqsi+Kx+AMN2xcam0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwApLOokPg4wTaH6TJCt/AnBG1qxPbnHJyVwnLLyT3+jzzXtfoq
	/sVtstRiZZg+muCfuW+hhN++emvw3fGutf/JN8Lkz7OP/M77f7nvVJzVXJS98UnDB/jEXyc0bUz
	SbdS+l36TJ4iL3HYiSoTw2WHKQ8jqJfz6r7cy/7rk1sOuvAx4BnH8MA==
X-Received: by 2002:a5d:47ac:0:b0:37c:fdc8:77ab with SMTP id ffacd0b85a97d-381c7973202mr11463764f8f.7.1730744133002;
        Mon, 04 Nov 2024 10:15:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0xxiT0gNzh7c1eBS3/tOiILacXPaDItLf/SGOxQ5FHjMTBEFHqhkRjrtudfCG35tsJSGMPg==
X-Received: by 2002:a5d:47ac:0:b0:37c:fdc8:77ab with SMTP id ffacd0b85a97d-381c7973202mr11463740f8f.7.1730744132625;
        Mon, 04 Nov 2024 10:15:32 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432a153125asm1938525e9.2.2024.11.04.10.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 10:15:31 -0800 (PST)
Message-ID: <d275b86b-75d0-40a4-90b6-b519748ccc5f@redhat.com>
Date: Mon, 4 Nov 2024 19:15:28 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 eric.auger.pro@gmail.com, cohuck@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com>
 <ZxuX4i9NjVRizB72@redhat.com>
 <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com>
 <Zxub7ol4p8P_sWF8@redhat.com>
 <CAFEAcA_wQu17y0PyQwxw0wuf2H5y2VE5aX16nLP2-u7QUP2ggA@mail.gmail.com>
 <Zx-9WxXkmkMuGIlQ@redhat.com>
 <CAFEAcA9w0mb5bcU8p+fScQony-=oqLmNurGWpnL_sBneQCzxUg@mail.gmail.com>
 <Zx_CU9eeQByANMRW@linux.dev>
 <6c05fc4e-ce14-4000-bb2a-63496bce9e98@redhat.com>
 <CAFEAcA_XhkBrco=V3Ky+cgvyp3cwqHXjDkmm+dP7N2B2av03bA@mail.gmail.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CAFEAcA_XhkBrco=V3Ky+cgvyp3cwqHXjDkmm+dP7N2B2av03bA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Peter,

On 11/4/24 18:16, Peter Maydell wrote:
> On Mon, 4 Nov 2024 at 17:09, Eric Auger <eric.auger@redhat.com> wrote:
>> Was just wondering if all the writable ID reg fields were associated to
>> an official FEAT_ listed in this feature list.
>> Let's take for instance CTR_EL0.DIC. Is it associated to a given
>> extension or is it just implementation defined?
> CTR_EL0.DIC is IMPDEF choice of 0 or 1. There's no associated
> FEAT_* -- as an implementation, you are effectively just
> reporting here what your implementation's properties are.
>
> (CTR_EL0 is not an ID register in the architectural sense.)

thank you for the confirmation. So this means we also need to be able to
tune such bit although it does not have any fellow FEAT_*.

Eric
>
> thanks
> -- PMM
>

