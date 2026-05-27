Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C183128A3
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897689; cv=none; b=Acqk4zprLhjHBbxx1zRnVx2/eIwdmGIvz+yWjQULSxnunM3QzODQEMKXdEq7HwEFyaqfBWdduH1G7DxU1n41yRQDtlIBsyUpD2nj0n6FZJfGXoFGj8zBklzHh2U1vl92TDZPXHiXd/D53xKy/HYgUzEych0YgXD+ph6M1OwSVXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897689; c=relaxed/simple;
	bh=wiWS7n9u0ta9sqZHGeZei6TXp7lBVR3P3EGvuKxZ5cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PYVyLZbCfafJMLdwhv6vear0LEJj3uozi0vCLD0YxZHNkBEwtVZD6tYJ/DO7beMrnyB56EDk6E+61y2pLYb7Kehons3xSlcy54g7S1K6sL4z6nRiJJ3uav6JAUkrzQRWfWXLB8dE+SwMOq6KikrGWyT8+80HhpVLj8QCn+w4ilU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qq3V/ZPG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qq3V/ZPG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779897686;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RiPe4Prk+kzBu6QwStAHXAFHar9zGaaOXhVcZMTjvIk=;
	b=Qq3V/ZPGYSjBgl3tMZSG/dlS3fxEKQ/jIgg/UUQv5gRywT+0IxwBc79DayEC5jOtT2tRLQ
	dLBlEf3LQlDTiM/ssPk6LgxhrvV+kvBTEggHyB8qZeCmlokC6itwkc1mNSg+6dWzHsl+F+
	nXp5T4ye5PCaFHjwCw1NznyF8o8Tqqs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-ZM3xfKhdNvKYeWI9JzLfUA-1; Wed, 27 May 2026 12:01:21 -0400
X-MC-Unique: ZM3xfKhdNvKYeWI9JzLfUA-1
X-Mimecast-MFC-AGG-ID: ZM3xfKhdNvKYeWI9JzLfUA_1779897680
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49058e91639so31061935e9.3
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 09:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897680; x=1780502480;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RiPe4Prk+kzBu6QwStAHXAFHar9zGaaOXhVcZMTjvIk=;
        b=iisnpbeWsYfsabHBHYK+0uaG/3O2Esjp8aoIrNAy8EyZetUEu9g+PqXUJMzNcjrAup
         phL14cnkDHj33ntwF6aeBFgoxZBj1wdtP63c0GH9iFCh4d88yzZ35l9rSP5WzTVJJtt/
         m6HUKpo1d28Ie2W+v/5n237eukB6mTKTvOoFupF7LTvbK3I1dIT7Wyp5pUtu5epxK/Fk
         1nTJnmbmjiMuCQJXEPUVkgWQ0CWfdeQ0u9nIS/50ouPII6+e/yBmEzOo4eYkXCA40P/J
         9lzOD0cqA9Cp5RSzCcMnRFf2qymeHkMSlwnU4+C0MT2y6lVJsY/LcPpthiMW9WDMXC0/
         YTEQ==
X-Forwarded-Encrypted: i=1; AFNElJ/KvIBkpevylZI+0KuKSjnI7Omq8vb96HganznIc0NEEUGF/eOkkGxqPw8kZE73GAmUOJ3TleI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1kFvvos2X1pO4o/FdT39aiy2CyRSROmlg1/kFrxrHssEsxD6B
	9NyyhD0ET9CPkWXiWWsHPYXWED4WJSZCDItowsPVYCuoHcd5nLe343+Ux8lvEQRQT6dgOZDRmXW
	k2I86yyV6n71DlBpwOAZchU90HZOcvfs6DuepTn1ry1QC/VlI93yUV25e314vAdUkDg==
X-Gm-Gg: Acq92OHiReUv13M7vGylFC6Wuae5QhgLeEFj7TUvCcRxHO9rhNVHkFXGGjYu3FdKzsw
	kjBFyDo8D9aDCTJTs4cFeMb9EWnQYGXtvbRiYE1Sp3EUvWY5frYihaNCrkhpkrkeaQrE6+YuPm5
	02uFJoEbv4lm71OxyKdej5VDY6tgwa6PSDKeiuYqcxpy+KwH35+gUgaBr8cCH0dpK5N+QKGgP3q
	pDuxeY/okhFNq3JSkjy895Tsg7bwl11OJBp/GilqbXUnN5eq+xBxc++3+Iw7HESBlDueg54DQpR
	umSL6VVjJALJ5mT78Sap6ylfM615FvmTszAjW5tvo1HHYsDBedI24v9kV3eYM9Enf5G2O4XqjIg
	K2ZqyfI3ZUjUCjsYzpydBhedjnBiIeh9SuPcwHLWuzOaA1GQqLLaaW0Lc701+aHZicrAhfw==
X-Received: by 2002:a05:600c:3b02:b0:48f:d1c0:5cd3 with SMTP id 5b1f17b1804b1-490424b3189mr405188725e9.13.1779897680112;
        Wed, 27 May 2026 09:01:20 -0700 (PDT)
X-Received: by 2002:a05:600c:3b02:b0:48f:d1c0:5cd3 with SMTP id 5b1f17b1804b1-490424b3189mr405187915e9.13.1779897679614;
        Wed, 27 May 2026 09:01:19 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904527f7f7sm601871475e9.7.2026.05.27.09.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 09:01:18 -0700 (PDT)
Message-ID: <72f22825-d810-4fa1-8fc5-123ae06af91e@redhat.com>
Date: Wed, 27 May 2026 18:01:16 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 15/18] target/arm/kvm: Ignore some writable bits that
 shouldn't be
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
 <20260519132905.145643-16-eric.auger@redhat.com>
 <E5402D74-AE00-4088-801C-C87A749E17C9@nutanix.com>
 <80fa5157-2376-4010-88b2-deb6ab50f87f@redhat.com>
 <6CA1EBCE-BA44-42A1-81D3-1A723C6F0CC3@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <6CA1EBCE-BA44-42A1-81D3-1A723C6F0CC3@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: emXwZtm1-1EJC29LYCtGWJBx2BdqheO6Px2SLg4Z420_1779897680
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 5:54 PM, Khushit Shah wrote:
>
>> On 27 May 2026, at 9:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> What would it change anyway, if we detect we have a writable field
>> matching a RESx field, I guess we would continue raising a warning, no?
> At-least for named models we want values for each bit in 
> ID register.
but if a field is RESx why don't you want to overwrite it? Are there
cases where a field is RESx depending on a condition?

Thanks

Eric
>
> Warm Regards,
> Khushit

