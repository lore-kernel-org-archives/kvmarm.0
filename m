Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157F822C33A
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 17:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737049940; cv=none; b=dy5MfEfmbVX9mMmpTbUi6lgCN4NxN1BxlRopOBqYJaIngoKqWdwnj336HJDGGpzvkz2TxjitAUnIqshwiL1SGW5rXNDw31wRtvihhELeEt78aLFeKIPRB8FAAnTVk4wr9TMGC9X/AsIlB2UjWhDjG5VircV5h2pyWi1w5q45xQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737049940; c=relaxed/simple;
	bh=H5BirUPRTkfHFJFgXNHIASC6oghzdUiXePOB2ZQiCWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XPBDQIebkUcJ0nXE5xJ8dNwJSk55lFZYe/RteuJZBHtYWhyASPdaIYlo3fS6TsTVTgypkoN3uuz2mW/MNSCixrPVe3QfXaly2S8OBa+clIgmw9nYTWe5DXl5ihf9hC6am7ACbxwqWWr7e2eWpA8dljsLhnjzd4SSJB73i22dStw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hSq5pSla; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hSq5pSla"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737049937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ktk2GUjb3uuEtg/gq7dyWK4NYCCF/Z75QRIh0J92azQ=;
	b=hSq5pSlaay65aRMe5r75AAEs9WP5OiKxZEBabBIFpBSYogq6fdhDonydZvG/fVs2lO2mg/
	Ig6sfZAhVCvLikjbDXsKLy9t1ZhupdQ+3/XlbFtSuX7Cho6h8Jb+FiKW/FQYjwW55/64aw
	ja4Yv6h5HuEMd4aQDRn2HwKaJ5JQlzU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-ZbkasNkMMmmhU3M6BeLyQw-1; Thu, 16 Jan 2025 12:52:16 -0500
X-MC-Unique: ZbkasNkMMmmhU3M6BeLyQw-1
X-Mimecast-MFC-AGG-ID: ZbkasNkMMmmhU3M6BeLyQw
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6e19e09cc20so25021446d6.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 09:52:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737049936; x=1737654736;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ktk2GUjb3uuEtg/gq7dyWK4NYCCF/Z75QRIh0J92azQ=;
        b=DzPJkwyr/hsKXlfMtbGDfLCPhlBMItCkHYXgGJ9P96e5c36VMSgvuBQVMkON9zOw4G
         j+jnPHyXBpD+T8m3t3U8QPOZdwsz+GBJz0YWOtLH488oelRyAytMi5GIWU2Yzn39nT+R
         Zryug8KhfNMgxhAY2mT8PNO+NplzRP4xP6HWA/2rQ5JdRU7i/ldmnMoB+oTpsIbk/jkJ
         jPxkqr49cyRU9t4qntlRXWzsisdTDIsnx6sm/B7+CK8b7DyTvRaOtL9ZeqHILBktTglN
         IZrGGbACFjG9MS6o56nC3jGNdVlwtp9zU7iTaZYzFhnmEU4vRhvIZCuKtHEFfDSt79YN
         Me9g==
X-Forwarded-Encrypted: i=1; AJvYcCUXnvyE9PrpLSuafUL1iazi1d0896Rrv0nfOkLIyhQS9f+7pJjW0BulW7GqmJ54U6rUj/yj+IY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNhLdptiRWt65rWIac+EasmARJEwNyY8s3yzBtYJLqGQiVu7fU
	NswCkkWJrra+uGhFrfDwWH5YsSoQMg9vJCbT5H25BLfVugZcjFIoI1Fssssnuf/9QWu7ZuTKRzy
	C36eRIhMzemAb07motW3k5KsylKnbjslRz2OJDWLllHbPm8/XhmurBg==
X-Gm-Gg: ASbGncsM4jJQ/SiNVBACaaoyqIlzayudUGOC1CbQPtGV4Q9cASBzmbjrrtGvk265cLM
	iVWd4mMdUymDw6s84Jw7pTYkdtrwGyzRq6M5zeYRCGMqnjYbQbcb3pWj8S82IuEcQJjsHP6c0v7
	17s1UUdneyIM6D/ix7jPNt7YXkIOP9AQ/QWEqt+pCSvNkJk99KjCyKVK2tcOP6fhAitAopkbPB7
	Zn5m517p8d2c+kUJgEnq/UtASOJgRR91J0p5jxHa5Nj9c2kdrL/i3GrjFAtcFSMHl/PGks2abKL
	UjwHvV5Md1/4rZdVEaT9sBQ=
X-Received: by 2002:a05:6214:3b81:b0:6d8:a48e:a027 with SMTP id 6a1803df08f44-6df9b1bb67amr563036426d6.2.1737049935861;
        Thu, 16 Jan 2025 09:52:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0yNflOiDALshiw4SZfmGRBifWYCyvNAYdY9A1ERtGRbmOn0qfOk8jphR/ffWEJ6aRVBOPWw==
X-Received: by 2002:a05:6214:3b81:b0:6d8:a48e:a027 with SMTP id 6a1803df08f44-6df9b1bb67amr563036006d6.2.1737049935566;
        Thu, 16 Jan 2025 09:52:15 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e1afb1b293sm2333576d6.0.2025.01.16.09.52.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 09:52:14 -0800 (PST)
Message-ID: <b22d5916-8b55-43bc-a256-2136d66ad25f@redhat.com>
Date: Thu, 16 Jan 2025 18:52:10 +0100
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
 <4a9fbdd9-ad23-44bc-8ba5-399f08068db4@redhat.com>
 <86cygpwfy0.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <86cygpwfy0.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IWOEC7QRfgtVfYhJx7DppF5dbbofBKQm2fzMei8Ep4U_1737049936
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 1/14/25 4:52 PM, Marc Zyngier wrote:
> On Tue, 14 Jan 2025 14:57:43 +0000,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>>
>> On 1/14/25 3:38 PM, Marc Zyngier wrote:
>>> Hi Eric,
>>>
>>> On Tue, 14 Jan 2025 13:12:21 +0000,
>>> Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> I also confirm that using a mailine edk2 fixed the issues I faced
>>>> previously (fed/rhel L1 guest not booting).
>>>>
>>>> I used Marc's nv-next branch and qemu rebase.
>>>
>>> When did you sample this branch? It is almost daily rebased at the
>>> moment, given that we keep piling up things in kvmarm/next.
>> 5 days ago.
> 
> OK, so probably before I reapplied everything on top of kvmarm/next.
> Not necessarily a bad thing, just slightly older. The core NV code
> isn't rapidly changing anymore, with the exception of the recursive
> nesting stuff that I am currently rewriting.
> 
>>
>> If you want me to test a specific branch, please let me know, esp. in
>> the context of latest series including
>>
>> [PATCH v2 00/17] KVM: arm64: Add NV GICv3 support
> 
> That'd be the current nv-next then, which has all the series currently
> on the list, and a few more.
> 
>>>
>>>> With a rhel L1 guest I can now boot buildroot, debian and rhel guest as
>>>> L2 (feat mainline edk2). For rhel, I tested different kinds of page size
>>>> combinations for L1/L2 (4k and 64kB) and it worked.
>>>>
>>>> I tested on AmpereOne and Grace-Hopper systems
>>>
>>> Thanks for the confirmation. I haven't had a chance to try QEMU yet,
>>> but I expect that save/restore will not work. Something to look into,
>> I have not tested this yet.I will give it a try.
> 
> Thanks, that'd be super helpful.

I confirm the migration fails when putting some registers on the dest
side. I will further investigate.

Eric
> 
> 	M.
> 

