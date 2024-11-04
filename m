Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0466762EB
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 17:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730740201; cv=none; b=P4mA3tHSAsZv1e0mNAzImCKevk4lt+9c+sNAyybm7fL9BeLQWNRvhNMMDMOo+KxTpu3wyLCqF/j48c3DjnSWL1Q1HK9SahGVZx30EQIo692rgeH2bmBCFOO0i/gjQJueU79/kEPONM+Yh3tlBbcK1F+ceH/O7qTzck4D6Wdbox8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730740201; c=relaxed/simple;
	bh=l9bpno3V+v9cWhDXFEEUnf1mb5uVj0eJINSiv5Y9zRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LArAjwubiCrACKs+5BRrTVqlSEhIgoZFsG0cD/5b3Qc09CytEw84zAnGX3QBVR4tZ+4hMyevHVri59DyB/EKLQdTgPFieY7e6yCNB71J1bDespiPt5R1GAJt6odrEzhromwqWQ7Y+cmqvYCLA0pIwVaRxWt+nCH3kBQ5FjXtjqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fPp3d9X/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fPp3d9X/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730740198;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KFeisZyKjab9DBMxlw5RHMVKj7JFUpwBhmXREaCFMWw=;
	b=fPp3d9X/OzmMTIdiXU5FD5eUpkONuv/hxMD9V/s/EgiGM3EDrUue0Yn2qMAyXQtSkjx3yr
	Fk1Cg5VmFvnAyjV8k2x/ErwUugZTHD1XmME6afmUK+nPj84DDfQZ6tErQ+d0uonvCz+BAX
	nq36FZVKU45pG4Xdpn+5m6R4Dzw7A08=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-1xj2yZg9MyyFUAPn2A3SGA-1; Mon, 04 Nov 2024 12:09:57 -0500
X-MC-Unique: 1xj2yZg9MyyFUAPn2A3SGA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-539e4cd976dso2718602e87.0
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 09:09:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730740196; x=1731344996;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KFeisZyKjab9DBMxlw5RHMVKj7JFUpwBhmXREaCFMWw=;
        b=GGFf31d3S7GVmFEBbjoCou/i/pJo/N1bgunEzTojqQek9yl7Ejmvp9dpOf14zkvbRp
         INCIiMtVYBTvV3x5pnOwsz5v86WqfIiCd2VgFs8mTFcjeUuWASVXs5NmmDaS2+RqNHYI
         oWK9VJA3A+zP+wvOWw5M66iNf32RO4w5AN27kdYyCap0u1p3ri3DU+iGf9HVgXvPdCg3
         xyXXHltWsiFhJ+VJ7kZzLCX3OPhq+VN5zu9So93yRx9dRwCYnxXF2Bcbw5wE1CMjW8wK
         Cihdn7ZCkOgMkMKdNCcxnTzjdJbOsY5BPgbAcGNeDcXcsWyx5fOwQ/AyM6NGwkyk3625
         fORQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2zOK/lCCP5QaZypkTSUakei9bxznA97ui6sZwdjCPb8T/T3pSAkNoOXxRqXDNx57RpJLD3N0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxjbMsdT7MmVqbjAqrT8QZQgscu0ICDNdMFZ8vZZVCXopP9Uywt
	Kv9Bt24rne3iL1Uv/hR6GtvnCN7HXOxoZWeuS0fldSkbF0TsznAvVMw9qz2Sa8dArj81GKhXdUQ
	fZcxq8pmD2AbR+j0K0BziE6zy0QR/dqSi8IImxdcGLpghB/HgwYLcuw==
X-Received: by 2002:a05:6512:1597:b0:536:54d6:e6d6 with SMTP id 2adb3069b0e04-53b7ecdece7mr10191505e87.17.1730740195810;
        Mon, 04 Nov 2024 09:09:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE7xwAcB+0QbfJoyh/EUDF5R2PpiYAI9Gm+fjNdJNgyQYB+bVZrmUS2hrGWdvpWlmtJrg2xzQ==
X-Received: by 2002:a05:6512:1597:b0:536:54d6:e6d6 with SMTP id 2adb3069b0e04-53b7ecdece7mr10191473e87.17.1730740195319;
        Mon, 04 Nov 2024 09:09:55 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9a9a53sm188454675e9.30.2024.11.04.09.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 09:09:54 -0800 (PST)
Message-ID: <6c05fc4e-ce14-4000-bb2a-63496bce9e98@redhat.com>
Date: Mon, 4 Nov 2024 18:09:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
To: Oliver Upton <oliver.upton@linux.dev>,
 Peter Maydell <peter.maydell@linaro.org>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
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
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Zx_CU9eeQByANMRW@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Oliver,

On 10/28/24 17:56, Oliver Upton wrote:
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
> +1
>
> There's existing documentation [*] for the standard feature names, which
> provides:
>
>  - A short description of what the feature does
>  - Any dependencies a particular feature has (e.g.FEAT_VHE implies
>    FEAT_LSE, FEAT_Debugv8p1, and FEAT_AA64EL2)
>  - The register fields/values that are used to discover the feature.
>
> This seems like the most user-friendly option...
>
> [*]: https://developer.arm.com/documentation/109697/2024_09

Was just wondering if all the writable ID reg fields were associated to
an official FEAT_ listed in this feature list.
Let's take for instance CTR_EL0.DIC. Is it associated to a given
extension or is it just implementation defined?

Thanks

Eric
>

