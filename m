Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40815212164
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 13:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729862314; cv=none; b=FIliuWwwjSbpd7JlwH1Y7xBEF+nQuuJjOgR4XrI7tQagCNp/7ZdaOaDcSTjQXyLElpgDHq+cW4mlEggcJh6hpLQR2/XdcvLrmsOiwVtxbfwURExaHrCYsy1vTNeNXyK6JQGDhnF5g+nOLYDZ2Bltuv+ve5QK83XnP+Etyym+iA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729862314; c=relaxed/simple;
	bh=fe3bdzVNDDtKHv632jU4qEmquq83aic/pWRk6LD1q0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SPHsUcpHAlgolxSalezGdVWtzDg7QYElVvwgRPBjO/amrOnkKW/Jj6jHNOKDR47xUsR84jZHhOCiE3rD7KPdWYDdrvxYD5FjoSxSxLTemdNBH9Ln89GOkJfwW4AG81ThwCEHEsg2a+nKcLNtTEowB8x0puNwCe4taqrcohn0FcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EyqBpGQT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EyqBpGQT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729862311;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ovdnNFJWfaMrNfQOdsyd8gG4V34tuPWZ0MBGZ/4cI3c=;
	b=EyqBpGQTAt2UiBHM6ghMb4cvlnKSF5/PmdwxD0c5z9UgrQJ0LizJhaUc+y4IePjInct6xG
	1bVjBufupH1+fJnEhTncmdzDwmignX2/xUs2nAtpM/74lpECTJRy9y95FL0Lta+1V1kjML
	CLig5b51778kM8WrjCCU5Z+z+b6C/hY=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-5J2c2AjAPLWcZ7dtDwbb3Q-1; Fri, 25 Oct 2024 09:18:30 -0400
X-MC-Unique: 5J2c2AjAPLWcZ7dtDwbb3Q-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-539fb5677c9so1782424e87.0
        for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 06:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729862308; x=1730467108;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ovdnNFJWfaMrNfQOdsyd8gG4V34tuPWZ0MBGZ/4cI3c=;
        b=a9Y7tx8PDWu18CT1qsOlsPKj1XNWJigkRaldMaEW1c5Mt9BpedmyR2SvxhCJkX9LLl
         gqeVAmJYNNkZ1s+15A52ROz1E0Z0yjH8krDtO2m+6gkCv98iVDDkj6iHrLjW0DRYwv01
         4khABFajgSR84V/iVDszZCIotoHcPNNR66F/FfenH9YWwmPLQTvk7jqz9I2kvyHebIjr
         gfT2dv/XkDTpK4p8odB+rX9yrDn/LbgZO7L6guIZgzaBdif41RiwcsZnkfkuNOboaClv
         IFAlEFmHWCweUdbwMgaNoO1Xa9Rj/XAzEkBQTujW747JQXzJ9itLcP2SuQ4uttEmmsfu
         Ra9g==
X-Forwarded-Encrypted: i=1; AJvYcCUDYG+/AmnEgkZuCUCNNza/XBYhg/98LDvdVAOuURC9giN/WkIeZx41dnpDp1Fkbx0o9NSIxUo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4aNgvp8iSeL7l8Bk6VoHCe2G3ENj9ch9phGEkBAe4vXgj2dBa
	waOdEV3CTHxxUkf+T6U9GB4gk1ZyL8Uo/38/EjyAg8fsypZjOjG6/0DD0CdnGxjSg8IjP7lD2ri
	CwJUDQmWrXoq5ID04MBFudRh7ViV9rvfjU7cOH5+oITRwRMsJ3fTn5Q==
X-Received: by 2002:a05:6512:6ca:b0:52e:f2a6:8e1a with SMTP id 2adb3069b0e04-53b23e1913amr3353659e87.29.1729862308374;
        Fri, 25 Oct 2024 06:18:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEE6l1RO+HFEJ0fSLyfHGTU99HTtHKSVheFimbf6qCBYJTxuCcv2khs7uZGHEDow/AG4mL6qA==
X-Received: by 2002:a05:6512:6ca:b0:52e:f2a6:8e1a with SMTP id 2adb3069b0e04-53b23e1913amr3353619e87.29.1729862307898;
        Fri, 25 Oct 2024 06:18:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431935f875esm17460435e9.37.2024.10.25.06.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2024 06:18:27 -0700 (PDT)
Message-ID: <cb6c8f62-c5dc-416d-865f-fbdf96164dac@redhat.com>
Date: Fri, 25 Oct 2024 15:18:25 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: eric.auger.pro@gmail.com, cohuck@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-19-eric.auger@redhat.com>
 <ZxuX4i9NjVRizB72@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZxuX4i9NjVRizB72@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Daniel,

On 10/25/24 15:06, Daniel P. Berrangé wrote:
> On Fri, Oct 25, 2024 at 12:17:37PM +0200, Eric Auger wrote:
>> This new cpu model takes by default the host cpu values.
>> However it exposes uint64 SYSREG properties for writable ID reg
>> fields exposed by the host kernel. Properties are named
>> SYSREG_<REG>_<FIELD> with REG and FIELD being those used
>> in linux arch/arm64/tools/sysreg. This done by matching the
>> writable fields retrieved from the host kernel against the
>> generated description of sysregs.
>>
>> An example of invocation is:
>> -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
>> which sets DP field of ID_AA64ISAR0_EL1 to 0.
> "SYSREG_" feels kinda redundant to repeat on every single
> feature. 

I do agree. To be honest this was mostly driven my implementation need
for cpu model expansion. Given the high number of props which are
getting exposed, I iterate on all props and having a prefix let me
return only those SYSREG props. Most probably we can get rid of the
prefix by using some generated code as well.
>
> Also, is this naming convention really the same one that users
> will see when they look at /proc/cpuinfo to view features ? It
No it is not. I do agree that the custom cpu model is very low level. It
is very well suited to test all series turning ID regs as writable but
this would require an extra layer that adapts /proc/cpuinfo feature
level to this regid/field abstraction.

In /cpu/proc you will see somethink like:
 Features    : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp
asimdhp cpuid asimdrdm lrcpc dcpop asimddp
> feels pretty low level to me ?  Naming after the registers &
> fields, would be like configuring x86 CPU features by asking
> for "SYSREG_EAX_1_ECX_20" instead of saying "vmx" which is the
> human friendly name.
agreed.
>
>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>
>> ---
>>
>> At the moment, the custom model does not support legacy options
>> of the host cpu model. We need to understand what we do with those
>> latter (SVE, ...). This means that related KVM ioctl are
>> not called yet.
> It will be pretty painful to have to use different feature
> terminology for different CPU models. Everything in libvirt
> assuming feature terminology varies per-arch, not per-CPU
> model.
Actually as far as I understand those regids/fields would fit all kind
of aarch64 Cortex-A CPUs. So they wouldn't vary per-CPU (I mean their
terminology. Their availability will).

Thanks

Eric
>
>
> With regards,
> Daniel

