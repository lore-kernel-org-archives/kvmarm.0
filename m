Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52DB18E01
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 09:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706089977; cv=none; b=Pc3G7ahxwichS+IlO7gTobAHgDYXRonhWE33lAXZy3vfCFP/Kma+m2a0SSb59M5UacRfnZib8e4umQoraF5yXac/WZgoQhSEeoGU2qd813xN5kQdsK7g4ZDp/xh+jrop5UR+Y9r/nK7iF1ogW7bBQKPmOUL6Eenm56WMAjsPdY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706089977; c=relaxed/simple;
	bh=fL7xsFAPf6mLm5AqWXPAvpgnkwrwuTjyDCASZ1m7eZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P81p1t/T6cWG6Mdn9jGxXYhSRpmjbPOzT1CmoCL+ggnZcXTEhvSg2kA515/kujbni4BnTnnGAy1uOpkt5A+cjliyH4zR13X+61rEUHrUVyMKkQIO+08TwtsNdfW4IKu9e8Z9sfSFS82RKSLPRYNpwBviC6vGUP0VeeBXNihe88E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QEsiX7nE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QEsiX7nE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706089974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3Em1vhfyXKT1LEE01SdpLdKpgsNPtBUovozPrXlkUAI=;
	b=QEsiX7nErpf4FOz1viGuaSJKXB/nmn/n4/76iA2/o8IzxluYGY69Gmv/+dDnMOuaheGld8
	yRP9QdfkeK36/1AqMF24NKAKtpLAefxGaccMlBB3i7Ad1O06sa6WtN8sSHMl/ehJYQjuQB
	B4qeqmQNR5AukoygXcWRkMfd1XSwooI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-DotJJ9boNCaEQUeGs_GFVw-1; Wed, 24 Jan 2024 04:52:53 -0500
X-MC-Unique: DotJJ9boNCaEQUeGs_GFVw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4297db4eba1so62935821cf.2
        for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 01:52:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706089971; x=1706694771;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Em1vhfyXKT1LEE01SdpLdKpgsNPtBUovozPrXlkUAI=;
        b=HcbvAQNQ+8vi7MBBNJ2TFr1qcYAKbfVogMscsk/03hRnGwG1SZh8MuEZiUzKMw7Biz
         cPmmFztKkE3VlySQK6LjaNxu44Eut2p6jRXUIPyMoLEvdiBbJgo2XHV+zEE82ngsCWVC
         U/0lCRQvO2bxaRTjl2l1TjQkr6wy8GRL+uI+IzYdPknYyY68/3GH/YWFiMnwNDinwlyJ
         IrYe9By0JBGMHV4nFIt9Oq/KlP3zosJB6wpHI1BZGCosdNWUy8R0RrXr7ygQ13ismTMe
         glx1mE8atA200jxDB7koBMcwJJRak0xSuI6gjNMFU11MIUVEVWaOnX4+BJiSBqt+HQMz
         TLiQ==
X-Gm-Message-State: AOJu0YxhKDti7X9i1jEmOm0Y+gd4qj9SUbmoJ4Ktdm0V+BuBVoGcFOj7
	Sn0oy39K3l4E0DUZXAiR+JOassaSeU7PvYLjv0SIJ9plwTxbTl2nerCUQg8rA+EvjTU7D39nAoU
	tpBiofmcC08oOfQBReh0GyZ/qUcwRu8QfURkrngEBNf962qJ4YtRnJg==
X-Received: by 2002:a05:622a:288:b0:42a:5b85:32ca with SMTP id z8-20020a05622a028800b0042a5b8532camr862558qtw.11.1706089971533;
        Wed, 24 Jan 2024 01:52:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGH/1IaQQCpdnGnKzLipGmiYfUhmKC7+77PPGsSQdq692kdDR2DfILIz56aG7RtlIcdHEFhOA==
X-Received: by 2002:a05:622a:288:b0:42a:5b85:32ca with SMTP id z8-20020a05622a028800b0042a5b8532camr862549qtw.11.1706089971305;
        Wed, 24 Jan 2024 01:52:51 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-177-121.web.vodafone.de. [109.43.177.121])
        by smtp.gmail.com with ESMTPSA id x3-20020ac81203000000b00427e0e9c22dsm4222908qti.54.2024.01.24.01.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 01:52:51 -0800 (PST)
Message-ID: <1284c5bd-8c2d-4228-b2db-915548672eac@redhat.com>
Date: Wed, 24 Jan 2024 10:52:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 03/24] arm/arm64: Move cpumask.h to common
 lib
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com
References: <20240124071815.6898-26-andrew.jones@linux.dev>
 <20240124071815.6898-29-andrew.jones@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 xsFNBFH7eUwBEACzyOXKU+5Pcs6wNpKzrlJwzRl3VGZt95VCdb+FgoU9g11m7FWcOafrVRwU
 yYkTm9+7zBUc0sW5AuPGR/dp3pSLX/yFWsA/UB4nJsHqgDvDU7BImSeiTrnpMOTXb7Arw2a2
 4CflIyFqjCpfDM4MuTmzTjXq4Uov1giGE9X6viNo1pxyEpd7PanlKNnf4PqEQp06X4IgUacW
 tSGj6Gcns1bCuHV8OPWLkf4hkRnu8hdL6i60Yxz4E6TqlrpxsfYwLXgEeswPHOA6Mn4Cso9O
 0lewVYfFfsmokfAVMKWzOl1Sr0KGI5T9CpmRfAiSHpthhHWnECcJFwl72NTi6kUcUzG4se81
 O6n9d/kTj7pzTmBdfwuOZ0YUSqcqs0W+l1NcASSYZQaDoD3/SLk+nqVeCBB4OnYOGhgmIHNW
 0CwMRO/GK+20alxzk//V9GmIM2ACElbfF8+Uug3pqiHkVnKqM7W9/S1NH2qmxB6zMiJUHlTH
 gnVeZX0dgH27mzstcF786uPcdEqS0KJuxh2kk5IvUSL3Qn3ZgmgdxBMyCPciD/1cb7/Ahazr
 3ThHQXSHXkH/aDXdfLsKVuwDzHLVSkdSnZdt5HHh75/NFHxwaTlydgfHmFFwodK8y/TjyiGZ
 zg2Kje38xnz8zKn9iesFBCcONXS7txENTzX0z80WKBhK+XSFJwARAQABzR5UaG9tYXMgSHV0
 aCA8dGh1dGhAcmVkaGF0LmNvbT7CwXgEEwECACIFAlVgX6oCGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAAoJEC7Z13T+cC21EbIP/ii9cvT2HHGbFRl8HqGT6+7Wkb+XLMqJBMAIGiQK
 QIP3xk1HPTsLfVG0ao4hy/oYkGNOP8+ubLnZen6Yq3zAFiMhQ44lvgigDYJo3Ve59gfe99KX
 EbtB+X95ODARkq0McR6OAsPNJ7gpEUzfkQUUJTXRDQXfG/FX303Gvk+YU0spm2tsIKPl6AmV
 1CegDljzjycyfJbk418MQmMu2T82kjrkEofUO2a24ed3VGC0/Uz//XCR2ZTo+vBoBUQl41BD
 eFFtoCSrzo3yPFS+w5fkH9NT8ChdpSlbNS32NhYQhJtr9zjWyFRf0Zk+T/1P7ECn6gTEkp5k
 ofFIA4MFBc/fXbaDRtBmPB0N9pqTFApIUI4vuFPPO0JDrII9dLwZ6lO9EKiwuVlvr1wwzsgq
 zJTPBU3qHaUO4d/8G+gD7AL/6T4zi8Jo/GmjBsnYaTzbm94lf0CjXjsOX3seMhaE6WAZOQQG
 tZHAO1kAPWpaxne+wtgMKthyPLNwelLf+xzGvrIKvLX6QuLoWMnWldu22z2ICVnLQChlR9d6
 WW8QFEpo/FK7omuS8KvvopFcOOdlbFMM8Y/8vBgVMSsK6fsYUhruny/PahprPbYGiNIhKqz7
 UvgyZVl4pBFjTaz/SbimTk210vIlkDyy1WuS8Zsn0htv4+jQPgo9rqFE4mipJjy/iboDzsFN
 BFH7eUwBEAC2nzfUeeI8dv0C4qrfCPze6NkryUflEut9WwHhfXCLjtvCjnoGqFelH/PE9NF4
 4VPSCdvD1SSmFVzu6T9qWdcwMSaC+e7G/z0/AhBfqTeosAF5XvKQlAb9ZPkdDr7YN0a1XDfa
 +NgA+JZB4ROyBZFFAwNHT+HCnyzy0v9Sh3BgJJwfpXHH2l3LfncvV8rgFv0bvdr70U+On2XH
 5bApOyW1WpIG5KPJlDdzcQTyptOJ1dnEHfwnABEfzI3dNf63rlxsGouX/NFRRRNqkdClQR3K
 gCwciaXfZ7ir7fF0u1N2UuLsWA8Ei1JrNypk+MRxhbvdQC4tyZCZ8mVDk+QOK6pyK2f4rMf/
 WmqxNTtAVmNuZIwnJdjRMMSs4W4w6N/bRvpqtykSqx7VXcgqtv6eqoDZrNuhGbekQA0sAnCJ
 VPArerAZGArm63o39me/bRUQeQVSxEBmg66yshF9HkcUPGVeC4B0TPwz+HFcVhheo6hoJjLq
 knFOPLRj+0h+ZL+D0GenyqD3CyuyeTT5dGcNU9qT74bdSr20k/CklvI7S9yoQje8BeQAHtdV
 cvO8XCLrpGuw9SgOS7OP5oI26a0548M4KldAY+kqX6XVphEw3/6U1KTf7WxW5zYLTtadjISB
 X9xsRWSU+Yqs3C7oN5TIPSoj9tXMoxZkCIHWvnqGwZ7JhwARAQABwsFfBBgBAgAJBQJR+3lM
 AhsMAAoJEC7Z13T+cC21hPAQAIsBL9MdGpdEpvXs9CYrBkd6tS9mbaSWj6XBDfA1AEdQkBOn
 ZH1Qt7HJesk+qNSnLv6+jP4VwqK5AFMrKJ6IjE7jqgzGxtcZnvSjeDGPF1h2CKZQPpTw890k
 fy18AvgFHkVk2Oylyexw3aOBsXg6ukN44vIFqPoc+YSU0+0QIdYJp/XFsgWxnFIMYwDpxSHS
 5fdDxUjsk3UBHZx+IhFjs2siVZi5wnHIqM7eK9abr2cK2weInTBwXwqVWjsXZ4tq5+jQrwDK
 cvxIcwXdUTLGxc4/Z/VRH1PZSvfQxdxMGmNTGaXVNfdFZjm4fz0mz+OUi6AHC4CZpwnsliGV
 ODqwX8Y1zic9viSTbKS01ZNp175POyWViUk9qisPZB7ypfSIVSEULrL347qY/hm9ahhqmn17
 Ng255syASv3ehvX7iwWDfzXbA0/TVaqwa1YIkec+/8miicV0zMP9siRcYQkyTqSzaTFBBmqD
 oiT+z+/E59qj/EKfyce3sbC9XLjXv3mHMrq1tKX4G7IJGnS989E/fg6crv6NHae9Ckm7+lSs
 IQu4bBP2GxiRQ+NV3iV/KU3ebMRzqIC//DCOxzQNFNJAKldPe/bKZMCxEqtVoRkuJtNdp/5a
 yXFZ6TfE1hGKrDBYAm4vrnZ4CXFSBDllL59cFFOJCkn4Xboj/aVxxJxF30bn
In-Reply-To: <20240124071815.6898-29-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/01/2024 08.18, Andrew Jones wrote:
> RISC-V will also make use of cpumask.h, so move it to the arch-common
> directory.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>   lib/arm/asm/gic-v2.h        | 2 +-
>   lib/arm/asm/gic-v3.h        | 2 +-
>   lib/arm/asm/gic.h           | 2 +-
>   lib/arm/asm/smp.h           | 2 +-
>   lib/arm/mmu.c               | 2 +-
>   lib/arm/smp.c               | 2 +-
>   lib/arm64/asm/cpumask.h     | 1 -
>   lib/{arm/asm => }/cpumask.h | 9 ++++-----
>   8 files changed, 10 insertions(+), 12 deletions(-)
>   delete mode 100644 lib/arm64/asm/cpumask.h
>   rename lib/{arm/asm => }/cpumask.h (94%)

Reviewed-by: Thomas Huth <thuth@redhat.com>


