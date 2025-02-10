Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809AB225380
	for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 13:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739193506; cv=none; b=t/zGNCjUahe9O1/oMEqxG+d+SIKr29MEzpvCeT4lwS7JGGOVooGE7K5NuRcz5hQ9JkLjvsZrjLOpGdNGPEnB0XiXzAMoC/rtiAeDmXOcbmS5fp+Q966Yf2ZOYiZlb5pKomNjHMB8ONL9V+/oi8irsEYZyDYBOEMSNCQmUOv2B30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739193506; c=relaxed/simple;
	bh=aaEKiW23plNWCqQayU6HDAr16q6whBnAcEruYcoYO5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W80O7aQOqJ9Ii/pohSEwjgVQIFa4gp5VaS/CHLaclot74OmIp61PuT5L5i3H2bVR2jJgl7rodDKUqKJPk2qq/0pxdo0bJ6ro2lEEGxBZUIW0HbMTgWoyyPlDFjzGvhh8IJJeMRU+cVk08lMSiJX14tKgypdIpsrc7tq1sYY1EiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d36xJsQ0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d36xJsQ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739193503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M0MPt0ycdUSMONDSu9mYoplPstvbsn9ikTgZv5+baQE=;
	b=d36xJsQ0JUi/P0/a/SDU/rFcGPtLRODuhNR2yRT8vtx1/N9k475HT0eJfGBol1GCcnqhRs
	UsMPlOk1772pkrU7AIBjdwuMEtw2vHu4xYJTLYQMBEIurUepnK96/Zvdx2VA4jt6dzvYqB
	mRxcpemXjDSHwO5hFUmJpqVssv2FoP8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-dsxWZTk_Mf2VAA5Hg4V2Qw-1; Mon, 10 Feb 2025 08:18:22 -0500
X-MC-Unique: dsxWZTk_Mf2VAA5Hg4V2Qw-1
X-Mimecast-MFC-AGG-ID: dsxWZTk_Mf2VAA5Hg4V2Qw
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-439385b08d1so12044045e9.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 05:18:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739193500; x=1739798300;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M0MPt0ycdUSMONDSu9mYoplPstvbsn9ikTgZv5+baQE=;
        b=AF4PMfJhRV2lT8XwCByc2LgpgNviaxcplHiYwfO3sHYa/NmDLrx7IcFA6aAnwpR/GM
         Bz8nhtVNjYyjobjUr+GsrbuP0koZd4vdr4VGM9mpDCWnV0hOmPuurKBfLsBjfr8tXymS
         3lKUW62U3U1Svt2iOQbhhFCEsNxj5nUwsIciyxDmUu+SLdOocMLTSrmrOp3niE8pTxCn
         Qh6bObjRbcbMiHo644cmKgn7eNm3ebpcfMQ47V2ScWGQlMi5SZZN764sFBCQ0onjOq64
         X6m6kRtZwfAfVY5x/C30/wrXnu242dP7yWuSPaiaY8BE26TQb3nwui1rctbUbuF0SFq6
         ao+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzpuJZ4XvY4aRRvAu/PcMcfyhA/ADNvMB6R7DGmZ1glDPar/184aOqfO8SXsgo6xwc1Gv4NQA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzeXiUd3+EB+c5uoXeyH2foez7OPsuTZB+vqzPwUCuRrZTKwIoA
	0kGyiklHekvVocu2LPdNaXbGiyQYJuH2rU2PKpUyJ0NWPInEj1OjD/EqvA1LFVzywRfH+477HTx
	EZFhSQhJGpqH/TDFk/ZVqx4jDdvgdqjBxv2e16gIi18k19lqfeDnWHA==
X-Gm-Gg: ASbGnct3C5cI7zJ6jN3hPdmQghrWtBS26wZ/2+9rKSjSdMNDhzvAy8pnHurulkz5NFP
	LIjciRUGixWLsYAXHL5XkvhPdXI06xoFNj26S0S+NDlmyalMl8bSYEWeZ+eDb82YfsWrA6GQAu6
	1viUiT4OxkqU6DI+erOQCKvjlVTHyPnC7GhB2zpsjtqs4F3Kc7IZYmqRgxUdaRIkUD0+ocdUdBr
	pstp12bTLoh8+7IDENY4yBCqYTM3JZMRJF2iBaYMR1aeakeqwHzaTYDSPLBShJMT7LV3JybtJ00
	5IWAKDxa8arqe6t0pPkb1tVKNlh5Fi0ol++yCwamU5duAPI=
X-Received: by 2002:a05:600c:3c84:b0:435:32e:8270 with SMTP id 5b1f17b1804b1-43924991e0cmr110864685e9.14.1739193500532;
        Mon, 10 Feb 2025 05:18:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFoG9yP3/H9MVEK+qppHO2dXkw+Mes+rTTzfBqf9J7j6+TGHkenAflO96Xy+SJtMO0c9pi0Dg==
X-Received: by 2002:a05:600c:3c84:b0:435:32e:8270 with SMTP id 5b1f17b1804b1-43924991e0cmr110864445e9.14.1739193500176;
        Mon, 10 Feb 2025 05:18:20 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439492affe2sm13118155e9.28.2025.02.10.05.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 05:18:19 -0800 (PST)
Message-ID: <16086d70-2371-47ab-8980-ffbf40971bcb@redhat.com>
Date: Mon, 10 Feb 2025 14:18:16 +0100
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
 <b22d5916-8b55-43bc-a256-2136d66ad25f@redhat.com>
 <86frkptzr6.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <86frkptzr6.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4KhY1O5nAuVM1wBlqnEy5VkDgGIkcYKdf788SfHvc2o_1739193501
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 2/7/25 6:45 PM, Marc Zyngier wrote:
> On Thu, 16 Jan 2025 17:52:10 +0000,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>>
>> On 1/14/25 4:52 PM, Marc Zyngier wrote:
>>> On Tue, 14 Jan 2025 14:57:43 +0000,
>>> Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> On 1/14/25 3:38 PM, Marc Zyngier wrote:
>>>>> Hi Eric,
>>>>>
>>>>> On Tue, 14 Jan 2025 13:12:21 +0000,
>>>>> Eric Auger <eauger@redhat.com> wrote:
>>>>>>
>>>>>> I also confirm that using a mailine edk2 fixed the issues I faced
>>>>>> previously (fed/rhel L1 guest not booting).
>>>>>>
>>>>>> I used Marc's nv-next branch and qemu rebase.
>>>>>
>>>>> When did you sample this branch? It is almost daily rebased at the
>>>>> moment, given that we keep piling up things in kvmarm/next.
>>>> 5 days ago.
>>>
>>> OK, so probably before I reapplied everything on top of kvmarm/next.
>>> Not necessarily a bad thing, just slightly older. The core NV code
>>> isn't rapidly changing anymore, with the exception of the recursive
>>> nesting stuff that I am currently rewriting.
>>>
>>>>
>>>> If you want me to test a specific branch, please let me know, esp. in
>>>> the context of latest series including
>>>>
>>>> [PATCH v2 00/17] KVM: arm64: Add NV GICv3 support
>>>
>>> That'd be the current nv-next then, which has all the series currently
>>> on the list, and a few more.
>>>
>>>>>
>>>>>> With a rhel L1 guest I can now boot buildroot, debian and rhel guest as
>>>>>> L2 (feat mainline edk2). For rhel, I tested different kinds of page size
>>>>>> combinations for L1/L2 (4k and 64kB) and it worked.
>>>>>>
>>>>>> I tested on AmpereOne and Grace-Hopper systems
>>>>>
>>>>> Thanks for the confirmation. I haven't had a chance to try QEMU yet,
>>>>> but I expect that save/restore will not work. Something to look into,
>>>> I have not tested this yet.I will give it a try.
>>>
>>> Thanks, that'd be super helpful.
>>
>> I confirm the migration fails when putting some registers on the dest
>> side. I will further investigate.
> 
> I found at least one issue that could fail the migration. Before the
> VM starts running, we limit the feature set to the subset we actually
> support with NV.
> 
> By doing this, we also change the value of IDreg fields that are not
> writable, because they describe features that we don't support.
> Obviously, that fails on restore.
At first sight the registers we fail to put are
- ID_AA64PFR0_EL1
- ID_AA64DFR0_EL1
- ID_AA64MMFR1_EL1

I will add some traces in the kernel to figure out which fields cause issues

Eric

> 
> I need to have a think...
> 
> 	M.
> 

