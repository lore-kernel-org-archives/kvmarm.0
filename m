Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A4944B66B
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779902430; cv=none; b=LfUTcwherlTuL0zteR1Ei5/I5kRAydy7Cuazja8JX7qMLxub5Yd+Gs3lpFfipTzUFSHNZnuUnfWDIMvdU3hOyD5g5nWnUmFoDE4rUXy/x5/TjE0XJJ3xw5DM6x9IopVphxWLM9tjKTbD47uNslX9zpROtW5GlUTYXCxaA1amnCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779902430; c=relaxed/simple;
	bh=39cHuRSev4FkhDW5XFBNT64BOPXBoV+iQHRYvYw+fLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TsWUuJAaXuMAtmV5AlKUvSKdl1Eo0hwLkoCdgvMA1MUBbfhAWJjRJE+ttSWpfnF+NYNF9XVghej95dGG63ik4t8eD204pj0IM1trLQDrNPzr5WVvCwVkKs5oY1JWklvQkaHjx0K1x5N0dzuePtDjy3pm46tWew7Lt7fmJv/HGwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PU3Z+Gg6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PU3Z+Gg6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779902428;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l6Rb/5e6cfKqUwsTpbO8ZKOU4I90esxxdPIWqIHIR8Y=;
	b=PU3Z+Gg63Qa0giq8tj0mRjG/m0t7gMm2OZN2AwPx8XlIqxfZOTgjPsCMdT6riuWrSErZUz
	Cv/rvtJKjeALgPjdIpkU1uEjhnJ8xyj0UllFYXCsGbik9LQTGbEEWjPhQJZH435glApnlW
	tZ28bDLTBi8NHT1tAbRhpIDB3/Kd//0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-jQryT5AIPbmsfbMKE5Gn1w-1; Wed, 27 May 2026 13:20:27 -0400
X-MC-Unique: jQryT5AIPbmsfbMKE5Gn1w-1
X-Mimecast-MFC-AGG-ID: jQryT5AIPbmsfbMKE5Gn1w_1779902426
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49058e91639so31532025e9.3
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 10:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779902426; x=1780507226;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6Rb/5e6cfKqUwsTpbO8ZKOU4I90esxxdPIWqIHIR8Y=;
        b=M3xbEXov9R7KEadAw/fg82AjN/cPEw5+v3M8N5GL9CbnNz97DgwjI0eThKOCCv4z94
         juFebp/uHoItAMeEVcdlz8wtXQydRYP0+8ZZET5NizC3xxAyGzSnyoGdyEACauyqFlce
         SVGtrVGaQvPMqBIeXhPhc3uqagZQ+AAxOrzFpnhngQ8Po323ubz2yodwumlHwNJrHehV
         A+TUiFVmrDVrftefrZNCBFCrcXxe7xtVmqfYMqK0yAVoDT6mZ1rMTNVm04pMq8xseoPI
         ICDdUXs5Wk/l45vO1cAsyMtTRk/gaLZC9LWmBCvczmF9R4VQZEPmAib6V3k5tCzQQcWg
         7bZQ==
X-Forwarded-Encrypted: i=1; AFNElJ94WQDda4FDKGKgN3sG86zcy2y5dWhf08XlAQfJjIerbcZ+Dhk4XnHlSbtt/GQHFb+d1JmKMNs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVYAi26x1fwXPZ3ujXLjG1XzvtakQhaM9XDhsqlMVvTMra9yrm
	CSnAE79HHcbsTrrfXMWEYK7i/91/+H+iGlEs0YaFxBJZsYpxO1EBQcWEIL848SqGNu37L7Frd0k
	auBAiATN11PuxVGH2l0QG4K8BefFA60Y/zKWJH4mJMfkXuEU29hxiDM/YGw==
X-Gm-Gg: Acq92OGqYYuWXlb1nwlf+RNX49dRSxPwQ2OAVuVe9MqFzqhGlPG162mscbAMF/8OL/+
	r3bddWXwqfTKwE3S8XW2IZzpCz4rkP+Ber9KgW47+gShalh8xQxzqHJWYasM0gS9mOKSH4WBHuI
	VM7q0PI/5oHbz/MBK7qVcguC8GHnb5TMd+foMxp0fHogULjH5KWBO1tY/aR8Iak1svF9MzOxC1N
	kKuPttcAwffLM7pmW5JmKlNZJqBIh+A4Z9tPhIjoNU1wA8i1AsH3vbv+NiFtu7NrnoTz/KXi5u4
	UlOY1sO/Fqeos+byC8Z0XPsUuRidig5XXw7beXnyFq4o2wW+KlcwYaw8UiduANpPHuCelxcJEyM
	ayqQkWXLikTCvMsbpZP7p4TOxuCWe1+HHHZw32Ls1C9pxeyxzaqX9GDhTfu9n5BPyapiurg==
X-Received: by 2002:a05:600c:3b8c:b0:490:480e:266 with SMTP id 5b1f17b1804b1-490480e02eemr430022385e9.26.1779902425655;
        Wed, 27 May 2026 10:20:25 -0700 (PDT)
X-Received: by 2002:a05:600c:3b8c:b0:490:480e:266 with SMTP id 5b1f17b1804b1-490480e02eemr430021715e9.26.1779902425144;
        Wed, 27 May 2026 10:20:25 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454c5eb0sm438591845e9.2.2026.05.27.10.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 10:20:24 -0700 (PDT)
Message-ID: <8ee2b611-ef48-4805-aaf0-087856dc30f0@redhat.com>
Date: Wed, 27 May 2026 19:20:21 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-17-eric.auger@redhat.com>
 <30F66A6A-E26B-486C-81D1-8E1B2CCB558A@nutanix.com>
 <6c14a58a-60ab-419f-9395-ca3489f6cff8@redhat.com>
 <CA136979-E0CC-420E-9271-63CF27CD7DA5@nutanix.com>
 <2fd2057d-c74b-4bbe-b2d0-cb9ed092a37d@redhat.com>
 <6F6ECB0E-82A8-4FFA-8687-2D6E243A2096@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <6F6ECB0E-82A8-4FFA-8687-2D6E243A2096@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qASozgn1YIdY93XrZT93j5kSsI9yj8YaIcZZCg5m4G4_1779902426
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 6:11 PM, Khushit Shah wrote:
>
>> On 27 May 2026, at 9:34 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> On 5/27/26 5:56 PM, Khushit Shah wrote:
>>> So you are saying, if I do, 
>>> -cpu host,sve=on,SYSREG_ID_AA64PFR0_SVE=0
>>> QEMU will still show sve capabilities to the guest?
>> Yes that's what I expect. Require more extensive testing though. That
>> could be way to handle coexistence of different levels of granulaity.
>> Lowest level applies first, overriden by legacy compositive options. I
>> guess if you plan to introduce other layers of compositive props you
>> will most probably handle this situation too.
>>
> I am sure this at-least does not work with sve, 
> because arm_cpu_sve_finalize() just takes looks at the PFR0.SVE field and If value is 0 sve is 'off' otherwise 'on’.
My reasoning was:

arm_cpu_post_init
---> kvm_arm_add_vcpu_properties
    ---> set_sysreg_prop set the new value in cpu->isar.idregs
arm_cpu_finalize_features
---> arm_cpu_sve_finalize
---> arm_cpu_sme_finalize
---> arm_cpu_pauth_finalize
../..
those fonctions do some subsequent isar accesses

So I think in general id reg field settings are applied before composite
legacy options

Thanks

Eric





>
> What you describe might work for legacy props backed by prop_* boolean variables in ARMCPU like pauth (backed by cpu->prop_pauth).
>
> I have not tested this. I maybe wrong if some prop ordering magic happens at machine level.
>
> My plan is to just parse properties in order they arrive in cmdline :)
>
> Warm Regards,
> Khushit

