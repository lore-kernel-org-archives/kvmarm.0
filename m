Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5535D70816
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 15:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730735583; cv=none; b=LLM4QVurDqJZhF6H7i8KvhTVQs6Vf+26wXeFfzWYs8SaHSgr+Ks1bieqUOJfgGPDafrfVAnJH5yfBI7lhtYREyEtcSVPNnMMKunT3PMq45HmL2ifxLCAmgO64eaGvpFwTI4U7twn9gtibvnK1Fehx2TDeclcx8Zz1Pl+pBEi7pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730735583; c=relaxed/simple;
	bh=1GGJlHVxRjaQSWm0KzrRIdm7yiNhYjvD7bg81g+mzQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h8hnfsOlQNoY+IDhMq98LfAT46eskh/7NmMqC4k0BwOy9MIQmVM+r1fTNRBfkaVKD2JhhHok+oo5mabEqogggPN5s2/5p7Mr0cTV9OE/ku2B6DRgumjiri4GSiOIRgYn9SP77UAZvsj4tLUFu9nR9/zwcvioDb1GITBfHPxT+dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L5V/tJN6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L5V/tJN6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730735580;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7mUA65axYf94RHzQ+FsEaE5eP349wKq6vreKY/gkmjE=;
	b=L5V/tJN6XNTAAMzg8dyia4u6KLrGPMOuSRtmXVlnCnNH1cmlvwScVKMltjBJUtWukzFISm
	sIhvuhqeKUN/r7jnLBMjC9btfW4SJxO8ou73MilazJFJmrcjvRY8s8HdHWGyfFWF9qrDNP
	npQcpfl+IoFFMieK3SMn5YpqSfoD5+0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-RBhe4szsNCC0PG43WMjpXg-1; Mon, 04 Nov 2024 10:52:59 -0500
X-MC-Unique: RBhe4szsNCC0PG43WMjpXg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43164f21063so26409095e9.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 07:52:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730735578; x=1731340378;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7mUA65axYf94RHzQ+FsEaE5eP349wKq6vreKY/gkmjE=;
        b=Wa8u3ivakiY34v0N6Wvpqovdmqa5VQOKznTWvs7UDIZek0B6FKb0q2wZoRccs2R8UY
         YnDfC13WLIG6VX9sac8CtKc/wKfzv9m9vwp6ppHiFN5FsQtPaApwh6Ggz6uSNoXIWuMK
         ome8jbcyYzzPEjMv7ePCBEI5NrqExYb2692sN0vH6oVYcuamxc+YL6Ad+ciD+sezhAvu
         P4kbHdDrBy4rFLhMTWroV08yExnGFc3bQKsGgj9i7SF7mKCSxwDUOmYLlHKu1S4TMZ1O
         UCv3Q5yfLnyke9OYkSV+y+ac9XsHN/n+fvSy5nfLnRAzN073F9MlEJCxv8VJQjwoikOA
         ONSg==
X-Forwarded-Encrypted: i=1; AJvYcCWP2+AMGFcVeYvODA0zk+dHp3YSumUFKX51yBXXbS+FB+SMuSxcFMAhxlOhqR+02hEZ2qJEmOM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpkdSpXrvsUAYjomctRlx2KJrmwDUkxN3hMkWKLCA+pIR4n50g
	edQK3Ic1EQPrIM0H9Dvk+0pZybWthzLQXnHo3ZknTQgkCwZR1pKfnplPi+su7TfMIxvuc1VbVcE
	4mrP484f9gPfQIOA+NiJ8T5XPhae6tYcXXcyKP50SNsAYWIgFSV4NbQ==
X-Received: by 2002:a05:600c:a01:b0:42c:ba83:3f01 with SMTP id 5b1f17b1804b1-431bb984e8cmr179170825e9.8.1730735577943;
        Mon, 04 Nov 2024 07:52:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHM/sgFkPsRHyrJgwZBk+yGqKXTJjw6x9koC6zrD0mNzXVobnNx8Sxn9ebXaRxRRr6GdAwKOw==
X-Received: by 2002:a05:600c:a01:b0:42c:ba83:3f01 with SMTP id 5b1f17b1804b1-431bb984e8cmr179170445e9.8.1730735577520;
        Mon, 04 Nov 2024 07:52:57 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4327d698144sm162050515e9.39.2024.11.04.07.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 07:52:56 -0800 (PST)
Message-ID: <0007b45a-0278-4dad-8b8f-a65bd0506dc2@redhat.com>
Date: Mon, 4 Nov 2024 16:52:53 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 00/21] kvm/arm: Introduce a customizable aarch64 KVM host
 model
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
 <ZxuwZw2plMI6dNyE@pinwheel>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZxuwZw2plMI6dNyE@pinwheel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Kashyap,
On 10/25/24 16:51, Kashyap Chamarthy wrote:
> On Fri, Oct 25, 2024 at 12:17:19PM +0200, Eric Auger wrote:
>
> Hi Eric,
>
> I'm new to Arm, so please bear with my questions :)
>
>> This RFC series introduces a KVM host "custom" model.
> (a) On terminology: as we know, in the x86 world, QEMU uses these
>     terms[1]:
>
>     - Host passthrough
>     - Named CPU models
>     - Then there's the libvirt abstraction, "host-model", that aims to
>       provide the best of 'host-passthrough' + named CPU models.
>
>     Now I see the term "host 'custom' model" here.  Most
>     management-layer tools and libvirt users are familiar with the
>     classic terms "host-model" or "custom".  If we now say "host
>     'custom' model", it can create confusion.  I hope we can settle on
>     one of the existing terms, or create a new term if need be.
>
>     (I'll share one more thought on how layers above libvirt tend to use
>     the term "custom", as a reply to patch 21/21, "arm/cpu-features:
>     Document custom vcpu model".)
agreed, as replied earlier, custom terminology most probably will be
dropped.
>
> (b) The current CPU features doc[2] for Arm doesn't mention "host
>     passthrough" at all.  It is only implied by the last part of this
>     paragraph, from the section titled "A note about CPU models and
>     KVM"[3]:
>
>       "Named CPU models generally do not work with KVM. There are a few
>       cases that do work [...] but mostly if KVM is enabled the 'host'
>       CPU type must be used."
indeed
>
>     Related: in your reply[4] to Dan in this series, you write: "Having
>     named models is the next thing".  So named CPU models will be a
>     thing in Arm, too?  Then the above statement in the Arm
>     'cpu-features' will need updating :-)

Yes named models implementing a baseline are the end goal.
>
> [...]
>
>> - the QEMU layer does not take care of IDREG field value consistency.
>>   The kernel neither. I imagine this could be the role of the upper
>>   layer to implement a vcpu profile that makes sure settings are
>>   consistent. Here we come to "named" models. What should they look
>>   like on ARM?
> Are there reasons why they can't be similar to how x86 reports in
> `qemu-system-x86 -cpu help`?  
>
> E.g. If it's an NVIDIA "Grace A02" (Neoverse-V2) host, it can report:
>
>     [gracehopper] $> qemu-kvm -cpu help
>     Available CPUs:
>       gracehopper-neoverse-v2
>       cortex-a57 (deprecated)
>       host
>       max
>
> Or whatever is the preferred nomenclature for ARM.  It also gives users
> of both x86 and ARM deployments a consistent expectation.  
>
> Currently on a "Grace A02" ("Neoverse-V2") machine, it reports:
>
>     [gracehopper] $> qemu-kvm -cpu help
>     Available CPUs:
>       cortex-a57 (deprecated)
>       host
>       max
>
> I see it's because there are no named models yet on ARM :-)
yes this is definitively because on ARM there is no such named KVM model
besides cortex-a57 on aarch64.
on x86 does it return the closest named model?

Thanks

Eric
>
> [...]
>
> [1] https://www.qemu.org/docs/master/system/i386/cpu.html
> [2] https://www.qemu.org/docs/master/system/arm/cpu-features.html
> [3] https://www.qemu.org/docs/master/system/arm/cpu-features.html#a-note-about-cpu-models-and-kvm
> [4] https://lists.nongnu.org/archive/html/qemu-arm/2024-10/msg00891.html
>
>

