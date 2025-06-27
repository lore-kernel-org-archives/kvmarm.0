Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237E220D509
	for <kvmarm@lists.linux.dev>; Fri, 27 Jun 2025 20:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751057142; cv=none; b=R4dQpWEKVwUEdmCxGxD4uJuKniNdDA4bWnDz+nSNEMaUj61KDDFX+LBV3oFrf5UciPqC2NKhUIl6ec9BNxbumh8y5pgFzHR34AZXRXqJSqckFvcupuF/e3Py24jvMjtMyonrI5EdmyM7Lci6Go81KKjV7FHO015Zc85+GMddp44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751057142; c=relaxed/simple;
	bh=tdvLWFsh/wI9WWSqIsGVNp6UW8sVmmyQUHoavqrwGBE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=SJLSTCqim/OnxUrExt07U4By7dx3yzTDc6pCKvlyt14Ggc+pLWWLNfs+EMErRG+P0UWY/FzXNCW8fkFx+KVuFUVmqHOcYaeOIfwOnqfkWIn4LR4UIE3tz4KRcJY/zOVYW598XeXitJU6oVpJR/TI9XgDTgC30o7Vo5JupvfaFGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CixRjDmA; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CixRjDmA"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-40b27ae3317so255979b6e.1
        for <kvmarm@lists.linux.dev>; Fri, 27 Jun 2025 13:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751057140; x=1751661940; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RtzxPj829hxx6a8LNGtfeNdfTNyEQAZxil+yeQpRBG4=;
        b=CixRjDmAzLpuBAjy/cm0Dv4nmZb9DzVpz+kkxrucQlwfGtYREvvc803Xa+4SzScsOP
         uiLJiK2P/YbEQm7kIQeBXk55nQIrwidR8heAuh4o10wjkIez/JKcTL7Ww9xpA5bk6fe6
         hGxTd+cB1PCQ7yTjKm+8Aqygsz9jjrbpC1l+peFwedfdmg13SsXx6e0AU497Z4nlJOSD
         rmR7Cw7QKBExpepc1KW6DuTHm1/1rxERf9kO0d6ZjgQSpnO4Y+5UQuwtCL8WAo4jM0dg
         IYhchJfRAZJI82q2pusDkcG+kUPiQCWPROQGHwV3BpeLPJG0whzSjngSB24Rh7Wu7cN6
         co9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751057140; x=1751661940;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RtzxPj829hxx6a8LNGtfeNdfTNyEQAZxil+yeQpRBG4=;
        b=bSjAFbCwS6U9FQ9/rDxUTo9wAxLo5CtwI1iFRXpWM09pHYfr1lWMpfkM5teDqPX7HF
         ekOEO8iE+MF3SqUawoGZmYOOL7UH7ElECIFAdcm7qIl+oyj/OT/gpaRFbfiszutBbJte
         cC112nj2cTtAH7o20dUmgW5JdcQ0/mtwBGYxc/2I9DfOC81mecggxKy9VunC2BrchacD
         oiIN2gIGQoLUfmb0mzQnQ9BV5e/SQEzUOpW5T1kjMIAO9/GehS08ws7n5kpWycfBpAjN
         UqGABu/HwkBKHUX/RcI+2gzskeWu0SNuGyHK+EjbNduJo7C+QFRx42y8u5jUS2njGYWA
         UtnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDgig0lnyZSvDl2bXdEzP1U08U+J1aGsg04Kpq22ySD2tK1AVCJCOxLk1tWIUVenY/EGHYb5s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2STzutntm1Dzh5dedW1YCjtvuCmj3oiWmC3asYf+HlIadQdYt
	4YTO9bjomcK4oNKzpwovsiiLYgY4qQYtmPYzO26yDkSXO5xRyiIlpV0WjPsDyFk8CtaX4uRgsiq
	p09JDYqu/+aJnucIbwbnBOfmDCg==
X-Google-Smtp-Source: AGHT+IEVJG2F41QRpFsQcHOZM3LLETHwJl5cQHVqdrJwuBS7mGDCrIIEijxTBzEQVHHKwtJ80l+vFT15a5JN0DRDMA==
X-Received: from oiu5.prod.google.com ([2002:a05:6808:80a5:b0:3f9:9583:af9b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:21a7:b0:406:6e4b:bd91 with SMTP id 5614622812f47-40b33c489d6mr3625383b6e.7.1751057140014;
 Fri, 27 Jun 2025 13:45:40 -0700 (PDT)
Date: Fri, 27 Jun 2025 20:45:38 +0000
In-Reply-To: <603eb4c7-5570-438c-b747-cdcc67b09ea6@arm.com> (message from Ben
 Horgan on Fri, 27 Jun 2025 10:04:21 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntecv49aml.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 02/22] arm64: Generate sign macro for sysreg Enums
From: Colton Lewis <coltonlewis@google.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Ben. Thanks for the review.

Ben Horgan <ben.horgan@arm.com> writes:

> Hi Colton,

> On 6/26/25 21:04, Colton Lewis wrote:
>> There's no reason Enums shouldn't be equivalent to UnsignedEnums and
>> explicitly specify they are unsigned. This will avoid the annoyance I
>> had with HPMN0.
> An Enum can be annotated with the field's sign by updating it to
> UnsignedEnum or SignedEnum. This is explained in [1].

> With this change ID_AA64PFR1_EL1.MTE_frac would be marked as unsigned
> when it should really be considered signed.

> Enum	43:40	MTE_frac
> 	0b0000	ASYNC
> 	0b1111	NI
> EndEnum

Thanks for the explanation. I made this a separate commit because I
considered people might object and HPMN0 is already an UnsignedEnum in
my previous commit.

Do you think it would be a good idea to make plain Enums signed by
default or should I just remove this commit from the series?


>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>    arch/arm64/tools/gen-sysreg.awk | 1 +
>>    1 file changed, 1 insertion(+)

>> diff --git a/arch/arm64/tools/gen-sysreg.awk  
>> b/arch/arm64/tools/gen-sysreg.awk
>> index f2a1732cb1f6..fa21a632d9b7 100755
>> --- a/arch/arm64/tools/gen-sysreg.awk
>> +++ b/arch/arm64/tools/gen-sysreg.awk
>> @@ -308,6 +308,7 @@ $1 == "Enum" && (block_current() == "Sysreg" ||  
>> block_current() == "SysregFields
>>    	parse_bitdef(reg, field, $2)

>>    	define_field(reg, field, msb, lsb)
>> +	define_field_sign(reg, field, "false")

>>    	next
>>    }

> Thanks,

> Ben

> [1]
> https://lore.kernel.org/all/20221207-arm64-sysreg-helpers-v4-1-25b6b3fb9d18@kernel.org/
