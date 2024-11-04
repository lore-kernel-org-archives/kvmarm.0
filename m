Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82AB1B21A1
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 14:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730730453; cv=none; b=etztCKjKEIHoCgtDfaXm+kxFXQjfJ5SFpW6Su1at59sugtjlQ+ppUFWeqq+x9ZGUHngYyXAhZcuvSwr+KKsDLkTPwfahTE6pCBoGdpXkdLZV8wI6ZnvZeKmPG3j7kEdEA3FoeVPYNajtkw+YmIXUucLSllg1LQDurkhno26PWVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730730453; c=relaxed/simple;
	bh=ZHgdTb9kq9TNoZUWYuGURyZ3CuPL6hUsLCvvqMjuxhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQ+/cOLPFQdzbbJt4/BzNTEe8Bk3hVUAqyW+ISU2t4f2hhn2RKEZxm2yWwMKvUpsWSFFkWwD2fMpsNgyMSQxpKKveqbsJV7gIDB3E5FBu4NrwyIOe8U0uFirDe4rN47jCyem9p2+E/YuTAo6kj+3iw60JXS5kS4SM/kiQKC0QXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UuHFKCt7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UuHFKCt7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730730450;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oTGEwhCT8hhD7r51rSqL2rFj/gm7aU24XxE68FPJ2XE=;
	b=UuHFKCt7hCbURvVipAdMWGfH1QaDu2NWlO0JB47ABQPcrdESGVI2cGPctyJ8i8wOz4IYIw
	VEVA8asktYoBFOm7FDJhfFacwaJoTFBxjlCB0wCdNWQIqOIQicW1AIQHVdGEbyGksYxNvG
	Ujkl9tUSOC/J2xu9k8+BYX6nzV+i+JE=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-gawdWKxlNL2xUHnt0XrowQ-1; Mon, 04 Nov 2024 09:27:29 -0500
X-MC-Unique: gawdWKxlNL2xUHnt0XrowQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-539e7dc83ecso2484399e87.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 06:27:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730730448; x=1731335248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oTGEwhCT8hhD7r51rSqL2rFj/gm7aU24XxE68FPJ2XE=;
        b=IlhN5FdEXTgn3Xab1lERNYJqNOt/+RiSuVeKdDifC/k+SG8CcFj6FmacmyIY1IHxk2
         cODBEjAVjRSSG9urLP2OtGsgRHbYSFxBCfSFmEIue+4bbNztSpSoa5sYxhB/U1fbfRqA
         QoonjbALHZ3TZNx14+ApfXL3BZ0VFqeplgNYEGyPsdO6QsNUwPCh47lHGj2PV8J/DSb9
         xoslhh6VTDGUMGSkvYU52Z5pF63IfawdwjXrFRDheEyrn4Q+gKL8KlB5HC/wX41CrIuX
         Ydxo9CYXGEGvtvmUfg7P0OTSeXD8qR8A5lX9uiwNgpn+33bWVWujtiXRLlZHBpSfNStC
         Na1A==
X-Forwarded-Encrypted: i=1; AJvYcCWMG4YBvztrRLLNAtPbAz1h6OAm/BYWcYdHdn2d+Exh7mpJxWiHSyHskVpJ2eS/HAhNpkEPFF8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHcM3LOk+p5feri3hS8xozfkxj7clvTicFYCI1i2VKZewXQ1GY
	rGF3Xp7jr2sqwh5BEDZhNmttewtHHDRnbl++T60ufnaVaVx53A8hw1yS2fhU7cmRcrBPhIYGdAb
	v6dqbb/wvyTAd2DyETg16JiRVhCPQi/qSgc+Kse8osiiKizlRF16tEw==
X-Received: by 2002:a05:6512:1590:b0:534:543e:1895 with SMTP id 2adb3069b0e04-53b34c5f77bmr15041799e87.39.1730730447674;
        Mon, 04 Nov 2024 06:27:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhFA2XdRNordUGlHR6vowAO+4EIFUogyl7A57fA3uxb9QO8/Vzuy4zcATr3jt7aE+WyQzBtg==
X-Received: by 2002:a05:6512:1590:b0:534:543e:1895 with SMTP id 2adb3069b0e04-53b34c5f77bmr15041771e87.39.1730730447145;
        Mon, 04 Nov 2024 06:27:27 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c116abf3sm13362914f8f.101.2024.11.04.06.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 06:27:26 -0800 (PST)
Message-ID: <63c232c2-a325-48d6-8ed4-753a7c6e3b4e@redhat.com>
Date: Mon, 4 Nov 2024 15:27:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger.pro@gmail.com, cohuck@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
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
 <Zx_EGxj2aqc_2-kY@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Zx_EGxj2aqc_2-kY@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Daniel,

On 10/28/24 18:04, Daniel P. Berrangé wrote:
> On Mon, Oct 28, 2024 at 04:48:18PM +0000, Peter Maydell wrote:
>> On Mon, 28 Oct 2024 at 16:35, Daniel P. Berrangé <berrange@redhat.com> wrote:
>>> On Mon, Oct 28, 2024 at 04:16:31PM +0000, Peter Maydell wrote:
>>>> On Fri, 25 Oct 2024 at 14:24, Daniel P. Berrangé <berrange@redhat.com> wrote:
>>>>> On Fri, Oct 25, 2024 at 03:18:25PM +0200, Eric Auger wrote:
>>>>>> On 10/25/24 15:06, Daniel P. Berrangé wrote:
>>>>>>> Also, is this naming convention really the same one that users
>>>>>>> will see when they look at /proc/cpuinfo to view features ? It
>>>>>> No it is not. I do agree that the custom cpu model is very low level. It
>>>>>> is very well suited to test all series turning ID regs as writable but
>>>>>> this would require an extra layer that adapts /proc/cpuinfo feature
>>>>>> level to this regid/field abstraction.
>>>>>>
>>>>>> In /cpu/proc you will see somethink like:
>>>>>>  Features    : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp
>>>>>> asimdhp cpuid asimdrdm lrcpc dcpop asimddp
>>>>> Right, IMHO, this is the terminology that QEMU must use in user
>>>>> facing APIs.
>>>> /proc/cpuinfo's naming is rather weird for historical
>>>> reasons (for instance there is only one FEAT_FP16 feature
>>>> but cpuinfo lists "fphp" and "asimdhp" separately).
>>> There's plenty of wierd history in x86 too. In this
>>> case I might suggest just picking one of the two
>>> common names, and ignoring the other.
>>>
>>> If we really wanted to, we could alias the 2nd name
>>> to the first, but its likely not worth the bother.
>> Or we could use the standard set of architectural
>> feature names, and not have the problem at all, and not
>> have to document what we mean by our nonstandard names.
>> (cpuinfo names do actually mostly line up with the
>> standard names, just not 100%. Similarly gcc/clang command
>> line options are mostly the architectural feature name.)
> Ah, right, yes. Sorry I mis-understood you originally to be suggesting
> the same low level names as this patch.
If my understanding is correct, Peter suggested to rely on the
terminology used in

https://developer.arm.com/documentation/109697/2024_09

the doc pointed to by Oliver.

So I think the next step is to understand how those "high level" features do map onto low level ID register field values. I think a high level feature can map onto separate fields in separate ID regs. This may not be the most common case though. 

Thanks

Eric

>
> With regards,
> Daniel

