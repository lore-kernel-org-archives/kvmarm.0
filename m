Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C9114F9ED
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736866672; cv=none; b=Sm9j2Ah2Yruh2DiomBo5r4lwEfWsKppO6wqCJ2/zr/yYRAZf1IZsRKpASL0eYLJ7RSffZ0aKGLIrC6sVIOQtjFhh8D2NIcEqUyakY5kVfUoruLOEIr5CrzNSxloc7WpF4+N7BadN3o352mOwd1fJ9tvxI4fOFYrRbbesdT3151I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736866672; c=relaxed/simple;
	bh=T6Yz/vRVgXl1GGTCcH+3tZW8cmxZsJWW/vsAVKOJXa8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UMw0MeQbU36lJko7wpXqROjnXsWK6VfPp7TTcTtmlnOpxXFRLSYtAbNWF0Guv1vfhQpKfHZaRTkXIkFAZHmukk2YBOFLjfq1ONfYxBDCG0UpwNuOXHeAh+qVvc29dO1Ua+X3cga+g2ZpBQViUgXC/v3t/tYoB4/3laMw18UvtHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=elBpfutk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="elBpfutk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736866669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4SmzP/tN6OjoTvpKUmzAp05cCCcydG3yT7FnpCUoYlk=;
	b=elBpfutkFQ5H3dr2lRyWIaVwxHkMNcjN2SbRhcSaC6/xFgoHZqpNbWeFDLD4HwCmjrB3RW
	DCpNkbn+NdKZyWxYbNPQwxirKRpBMdmbL0HofQItNQ5lHnbQdAgpkRErtuHrLaATaFBFcl
	+ovcCS31wkMOzXS2cOK2AMN6eY7L138=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-03GMdqWiNdOdYVP6zXFqWg-1; Tue, 14 Jan 2025 09:57:48 -0500
X-MC-Unique: 03GMdqWiNdOdYVP6zXFqWg-1
X-Mimecast-MFC-AGG-ID: 03GMdqWiNdOdYVP6zXFqWg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361ecebc5bso29677955e9.1
        for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 06:57:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736866667; x=1737471467;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4SmzP/tN6OjoTvpKUmzAp05cCCcydG3yT7FnpCUoYlk=;
        b=HzslcyktN4LmgfVKPoQ0VAko4IIgITGwL6zmRvoSyo/5CZweFg9afaQJWzJUQOMgyV
         dZ3YQ7KSraeM6loHE7kay2OFRTWV+HoWLhZuNlyl2gFFwDK9YLNBH1DWxiDAWEQvGRre
         zKLHyqXRjsXA25iPizS5c3E2AD2iF9daaZAZZ5xatb/jDMeSs+Wk3ZHx76fIihTwmiAi
         KtWHRzP/r653lz0anPSmm1u3yIawkq3m/pU+BONWIbKfJOjCF5WNftysJ/Zy1SunHjBF
         cyRWkMdboyH/CaCyxpC0gNBAbOig1UNrwiV5wF12aW1lN9FFg4ZLp+rCqr8r7RiQby3k
         b7hA==
X-Forwarded-Encrypted: i=1; AJvYcCWAV/Yrq60ucB7Va4QjBL4t26P5oxK/0Oi+1xRXx1C+/85az9z41NjpGNkVByiMEQM/dZkkG7s=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKYeRdTbjSxhuTmNILEBHbP2gTTCWCEyEfY+ZnWoG8oDh9YGct
	o/CypmcHj1ZxhYoCV68rBpMvxPpZmT59bEkR1jxCSBRGdbrR8aXInAlUTq8S+PwMNJVezfc8jf1
	lUE00glegCEYPGmP9SCV2/PEwquB4nOymwDLC1bvuq6GjCjzyeDB4fnihmQZkrw==
X-Gm-Gg: ASbGncvxj1OWwE70cYlNL9JUsh5MV6zyYsNr9vRSqHewULizAmabQv03VPtnReP2W6H
	7FmgcOBHgF0C7313xdoVhuo+pgxIaXefy20j8FLBb7K3D/nRk9SSXtbPucR/ql9KR0umoM9LWCv
	kI6gDnv9MfDy7HFDuN7oKBVJ6yjn8JgtyEdfVJXYormMOsLn/atfontfE55wWAek8j1RFPNJGEV
	B6MPJdoiMDBwaMBa1HgOSRCGUB7doepL0uNMubk1GxDvp4jU0TPCepnP8rEr/Bt3AHeW1q91xkA
	dWx5AdrZ2sRltQkNFwrtReI=
X-Received: by 2002:a05:600c:468a:b0:434:a968:89a3 with SMTP id 5b1f17b1804b1-436e26a78a5mr189805455e9.9.1736866666657;
        Tue, 14 Jan 2025 06:57:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExk0wU6asFYaR4DpbkMbnI7udaC/CcYasNtWPbYNjEYNALHWG8jGD2PzfrC1f6nYMjRGJSZA==
X-Received: by 2002:a05:600c:468a:b0:434:a968:89a3 with SMTP id 5b1f17b1804b1-436e26a78a5mr189805235e9.9.1736866666247;
        Tue, 14 Jan 2025 06:57:46 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2df3610sm211355245e9.20.2025.01.14.06.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:57:45 -0800 (PST)
Message-ID: <4a9fbdd9-ad23-44bc-8ba5-399f08068db4@redhat.com>
Date: Tue, 14 Jan 2025 15:57:43 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Set ISTATUS for emulated timers, If timer
 expired
To: Marc Zyngier <maz@kernel.org>
Cc: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 kvmarm <kvmarm@lists.linux.dev>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev,
 christoffer.dall@arm.com, suzuki.poulose@arm.com, will@kernel.org,
 catalin.marinas@arm.com, coltonlewis@google.com, joey.gouly@arm.com,
 yuzenghui@huawei.com, darren@os.amperecomputing.com,
 vishnu@os.amperecomputing.com
References: <20241209053201.339939-1-gankulkarni@os.amperecomputing.com>
 <867c89tc4q.wl-maz@kernel.org>
 <c5b1c3d7-56ca-4afc-a831-045dba4beffa@os.amperecomputing.com>
 <865xntt2kv.wl-maz@kernel.org>
 <8be59ff3-6a68-48e1-8181-0ce4b2e7180f@os.amperecomputing.com>
 <bcb4289b-507c-4ea1-afc7-6febd34d88db@redhat.com>
 <86y10osr19.wl-maz@kernel.org>
 <4d443db1-85b1-4071-acd5-3187deb9cb17@redhat.com>
 <2f6b2cb1-3d32-480a-9801-9b993ae74e2d@os.amperecomputing.com>
 <152d262e-641d-4bb1-9656-a13e049d62c4@redhat.com>
 <86h661wje4.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <86h661wje4.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9jgppIc6Y8pqZGBLul2qp_L4KvaweWyeZFo9Y3jWXII_1736866667
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 1/14/25 3:38 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On Tue, 14 Jan 2025 13:12:21 +0000,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> I also confirm that using a mailine edk2 fixed the issues I faced
>> previously (fed/rhel L1 guest not booting).
>>
>> I used Marc's nv-next branch and qemu rebase.
> 
> When did you sample this branch? It is almost daily rebased at the
> moment, given that we keep piling up things in kvmarm/next.
5 days ago.

If you want me to test a specific branch, please let me know, esp. in
the context of latest series including

[PATCH v2 00/17] KVM: arm64: Add NV GICv3 support
> 
>> With a rhel L1 guest I can now boot buildroot, debian and rhel guest as
>> L2 (feat mainline edk2). For rhel, I tested different kinds of page size
>> combinations for L1/L2 (4k and 64kB) and it worked.
>>
>> I tested on AmpereOne and Grace-Hopper systems
> 
> Thanks for the confirmation. I haven't had a chance to try QEMU yet,
> but I expect that save/restore will not work. Something to look into,
I have not tested this yet.I will give it a try.

Eric
> I guess.
> 
> 	M.
> 

