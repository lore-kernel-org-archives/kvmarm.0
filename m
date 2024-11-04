Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBFF1BBBDD
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730734483; cv=none; b=MdAROx5/2FUhIjz5oMlFJmib/AwZX3vW7vzBCZxcDFNaDh08DhZvV9poTw6RvfaPvidMmw9AyjQT7+zt8ZZ55ZtGsIw1xI65kNYAmvPQyPS4eAOl91J0rQlTz/fixl967+B+0Oe1PvUpuTqHWyoBYh6IXVtFKYWbn/fEnYo9hjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730734483; c=relaxed/simple;
	bh=ncvdW+uBuD88UNlndDTa7l51DX+F6kYdOJ9rvQYXF4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kE5dajW3hBYdK3FlnwHnf6ilmhT76E3dVtKCFhj/RwUKGYaAmVexYIHyz7HmIWtiauzsTz+AK27Jg0rIAgotyZrbkp+hM5ofpjZKg44BctrGustUe4YINk5ij7fknzLF3xFz4YwKyY3Ek8YwCbne6JfmE/M2f6qcgm0p0IfNizA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vfl81mzm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vfl81mzm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730734479;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nSzC8fuhrTYfNX2e1clLraq8/0hvYKlTSC3OeLDtmLQ=;
	b=Vfl81mzmMdmK3/8xQVPF0BTyYYfZZeA5boM/sXc6hy23JpHB75w5eGRipvK6nX700RPeZy
	8Ls61iOuKj5bWpKEsfL+eTva8L33AjJGyCUoRN7ywXekkHXaiTEFCgoY+b+4l9X1IIBML7
	UUAVu7cpAqMqpLT6Law2+KlyHj8oPDA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-tjnBVhlpNECMvNqkZTx07A-1; Mon, 04 Nov 2024 10:34:38 -0500
X-MC-Unique: tjnBVhlpNECMvNqkZTx07A-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d5016d21eso1977229f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 07:34:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730734477; x=1731339277;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nSzC8fuhrTYfNX2e1clLraq8/0hvYKlTSC3OeLDtmLQ=;
        b=ReLEEFgC6XlnX4YRFnUowvLifjgZ3t+GVTdTCkEcKeFMGgk6pxB2sfHiHh24WOxRxV
         +l9VvGKf1ajPKHKVA352CcgpHtjSTQe1+HxhssBNNvzSOGzs5jzx0yTmi9mRtrix12Ms
         d9qrPpo3+w1ksCPCjkbc9PDh17RPtgHbagPnOd7AV+k4dn+cj/RVDMyc11YwOVVKw7CU
         GzkD7dJuURFn5SdrPKK63OSb2d+8Cn3R+3vI3GAc6DyREjSU59Vuoz2KI4gRWDsNbXw+
         Vi9OwW5XkTGujXXed5r36NLsC5nsWGRQDue6ow0VR67L3UJotbTUF7M6WLLcryfCWGT5
         KsVg==
X-Forwarded-Encrypted: i=1; AJvYcCUhMSyLtepI1xcz+7JIy5G9HJpKCOnbAUWD+BD2tvrWBkQtp1IMtYld1+A8lfisyPbC8w7kwOY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwcimvGxV2UwyOx2yjLtGhe2XJdIyKi3Z4vqghArBfZXIXJ9IZm
	zO0w6GwnUQ0abmD7RL0cKUnJoi1NwETHKW+yh1MpzJSUrxZlAdrdX8Veqhc8Zz8sWcn2YpINzRY
	StDx9BmHMGZxKzU7c+5lQmruPpqxTqZzIDk68CKw/Xsl/l6cuO3dJew==
X-Received: by 2002:adf:ebd2:0:b0:37d:3f42:9b59 with SMTP id ffacd0b85a97d-380610f7ea7mr22023353f8f.11.1730734476720;
        Mon, 04 Nov 2024 07:34:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHye8TT8MTrXCSMQ9mkus4MGj+FiLhpS9zRuPDmehNe0w/kgz6ZwC8PSbE0EzuU1gXHNIBaJQ==
X-Received: by 2002:adf:ebd2:0:b0:37d:3f42:9b59 with SMTP id ffacd0b85a97d-380610f7ea7mr22023318f8f.11.1730734476312;
        Mon, 04 Nov 2024 07:34:36 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10b7b32sm13547570f8f.18.2024.11.04.07.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 07:34:35 -0800 (PST)
Message-ID: <52690aae-55b6-47d5-a308-dd75475f8377@redhat.com>
Date: Mon, 4 Nov 2024 16:34:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 21/21] arm/cpu-features: Document custom vcpu model
To: Kashyap Chamarthy <kchamart@redhat.com>
Cc: eric.auger.pro@gmail.com, cohuck@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com> <Zx__Zi3Zpg1AspnE@pinwheel>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Zx__Zi3Zpg1AspnE@pinwheel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Kashyap,

On 10/28/24 22:17, Kashyap Chamarthy wrote:
> On Fri, Oct 25, 2024 at 12:17:40PM +0200, Eric Auger wrote:
>> From: Cornelia Huck <cohuck@redhat.com>
>>
>> Add some documentation for the custom model.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  docs/system/arm/cpu-features.rst | 55 +++++++++++++++++++++++++++-----
>>  1 file changed, 47 insertions(+), 8 deletions(-)
>>
>> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
>> index a5fb929243..962a2c6c26 100644
>> --- a/docs/system/arm/cpu-features.rst
>> +++ b/docs/system/arm/cpu-features.rst
>> @@ -2,7 +2,10 @@ Arm CPU Features
> [...]
>
>> +Using the ``host`` type means the guest is provided all the same CPU
>> +features as the host CPU type has.  And, for this reason, the ``host``
>> +CPU type should enable all CPU features that the host has by default.
>> +
>> +In case some features need to be hidden to the guest, ``custom`` model
>> +shall be used instead. This is especially useful for migration purpose.
>> +
>> +The ``custom`` CPU model generally is the better choice if you want more
>> +flexibility or stability across different machines or with different kernel
>> +versions. 
> Does "more flexibility or stability across different machines" also
> imply "live migration compatiblity across host CPUs"?
yes that's the goal
>
>> However, even the ``custom`` CPU model will not allow configuring
>> +an arbitrary set of features; the ID registers must describe a subset of the
>> +host's features, and all differences to the host's configuration must actually
>> +be supported by the kernel to be deconfigured.
> [...]
>
>> +The ``custom`` CPU model needs to be configured via individual ID register
>> +field properties, for example::
>> +
>> +  $ qemu-system-aarch64 -M virt -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
> If possible, it would be really helpful (and user-friendly) to be able
> to specify the CPU feature names as you see under /proc/cpuinfo, and be
> able to turn the flags on or off:
>     
>         -M virt -cpu franken,rndr=on,ts=on,fhm=off
>
> (... instead of specifying long system register IDs that groups together
> a bunch of CPU features.  If I understand it correctly, the register
> "ID_AA64ISAR0_EL1" maps to a set of visible features listed here:
> https://docs.kernel.org/arch/arm64/cpu-feature-registers.html)
Not all the writable ID regs are visible through the above technique.
But indeed I think we converged on the idea to use higher level feature
names than ID reg field values.
However we need to study the feasibility and mappings between those high
level features and ID reg field values.
The cons is that we need to describe this mapping manually. Besides
being cumbersome this is also error prone.
>
>
> Next, I prefix the below by noting that I wrote it before seeing
> Cornelia's reply that the name "custom" is not set in stone:
> https://lists.nongnu.org/archive/html/qemu-arm/2024-10/msg00987.html.
>
> I wonder if the word "custom" is starting to get overloaded; on x86:
>
>   - Libvirt itself uses the term "custom" this way, to quote its
>     documentation[1] for the 'custom' XML attribute:
>
>       custom
>     
>       In this mode, the 'cpu' element describes the CPU that should be
>       presented to the guest. This is the default when no 'mode'
>       attribute is specified. This mode makes it so that a persistent
>       guest will see the same hardware no matter what host the guest is
>       booted on.
>
>   - Some management tools also follow libvirt and use the term "custom"
>     to refer to one of two things, (a) a specific named CPU model that
>     libvirt and QEMU recognize, e.g. "Cascadelake-Server"; or (b) a
>     named CPU model + extra CPU flags, e.g. this is how OpenStack
>     uses[2] "custom" to configure CPU models, and flags that can be
>     enabled or disabled via "+" or "-":
>
>       [libvirt]
>       cpu_mode = custom
>       cpu_model = IvyBridge-IBRS
>       cpu_model_extra_flags="ss,+vmx,-pcid [...]"
>
>     (Note the "cpu_mode" there: it is referring to the three possible
>     modes that libvirt and QEMU support today: 'host-passthrough',
>     'host-model', and named CPU models via "custom".)
>
>     The above config translates to this QEMU command-line:
>
>         -cpu IvyBridge-IBRS,ss=on,vmx=on,pcid=off [...]
>
> Now if QEMU introduces "custom", it is likely to create some confusion.
> But luckily, as referenced above, it is open to change. :)
Agreed! Thank you for the references!

Eric
>
>     * * *
>
> FWIW, I agree with Dan here[3] that it would cause less future pain if
> Arm's named CPU models also decides on a "baseline that matches some
> corresponding real world silicon".  I've experienced plenty of such
> debugging pain in x86-land from years of troubleshooting live migration
> bugs involving CPU model (in)compatibility.  (Often, with help from
> DanPB and Jiri Denemark).
>
> [1] https://docs.openstack.org/nova/latest/admin/cpu-models.html#cpu-modes
> [2] https://libvirt.org/formatdomain.html#cpu-model-and-topology
> [3] https://lists.nongnu.org/archive/html/qemu-arm/2024-10/msg00888.html
>     — [RFC 21/21] arm/cpu-features: Document custom vcpu model
>
> [...]
>

