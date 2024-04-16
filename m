Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6E53770B
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 04:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713242786; cv=none; b=KWULr2vDw5J/kPUi7nyVTIK7QpbTtmbkS/FS2YoRLZZWK9ibrtXrUhcI2pOHhkL0ymst28b4cKCuDmoFsRkh5HZzcysB3qp8/rTfuMpEECB7bAE9Vz7+Nxkl0XuJNgbt/cpipZKQpajiroqMRNcBKA6DndlLlNx8WkO3m0emfSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713242786; c=relaxed/simple;
	bh=80hUjCkjKS5u7V5gbiuzD+oIL+4s0qQV1OKu5uzzkvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bs38a4ZRgD6sC/KvE2C0kTK2naNDy58m3vNKv9dEXTyfblYNKam5j2CfuEyrJgM5FG0OK33DZ57WgmFEqa91kEzvXCWzePBMtmheeBfZvMsAehLneEr/V7kIY6Q5cbc2dZdIH01sbCq54V+yQrlc8SZxFEubEsJDF84/OPgWNWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RQyc/MPp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RQyc/MPp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713242783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rMDcgaXiXzVs8uPv0yj1Wn6dMRjFJOR9or+OJI4S4LI=;
	b=RQyc/MPpf3WQkeMJ3tiXHpcRKYAp7XEyWTcK8r7jSczLfP0kqi44CKtShuczmkvQk9mQob
	zDMd1voke4E26GPqyVMMNjogiPVFcyxqDUTwZmhOvTUzYbq/jHA689AJtK7OPLKvbuOV7b
	nRWWeVwc9LjNsFSD9EgL93jwCDphjr8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-kYeGNo-yMsubERJccCoO_A-1; Tue, 16 Apr 2024 00:46:19 -0400
X-MC-Unique: kYeGNo-yMsubERJccCoO_A-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-568a9f3ba97so2252330a12.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 21:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713242778; x=1713847578;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rMDcgaXiXzVs8uPv0yj1Wn6dMRjFJOR9or+OJI4S4LI=;
        b=XjeSZ4bRx7ZmwNG8IJA0mHEvxRm4yWLsow86fdrBO7QKXBRdVMhtmDVKw/tKVuBm5+
         cXntpefkczy5Qe3iOwc3dAzHpXrPOtGCYBJx6Lr6Bpb9PG+4A75ecIiVeRKa6V7NmFKY
         40s/kQFccg/X2jzMGJITvzvFF5fn7uI9E9n3NcXDcw17U8eZdUdKDhY8x7bYFkWFKj5T
         GG+dDW9hJSdrei7FqxtrUU5WO4JfN8PZ5hbjQ1jZK2P2m0f15CPGw8tvl5Xv9UVe6Gse
         JqxUUhb66Xxd1MZJIanyTURbpp+arNwpFsS8yApluKR/in04ZxvklmJgOI1naIbv92h5
         NVdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPq9gNJOOwPnZ7CO8lxfpZ9xfFT9qvVlXBm99e9+WVwwQOeLiWULErtU1ETRGvfgdyrpx2egJ4fxklLFmvDgXha2PgQuu0
X-Gm-Message-State: AOJu0YzlzRbpD18GJh3z5XckXViwG8pqecjfYrw6YNCOULtBlYXsaqCJ
	Tiyjv2RFpyBdCOIWaJJYNIMPqivSh+rRFyWDeVyxP2WnJ/JeJznkau6VlMiH4qXlhHAXdLVByi1
	S+FzXHLCsnLxv5SzEJ+vXhjGv0Zwzna6d6mjfami28A8/NB6xhfBzcw==
X-Received: by 2002:a50:ab15:0:b0:56e:2493:e3c2 with SMTP id s21-20020a50ab15000000b0056e2493e3c2mr7416019edc.37.1713242778414;
        Mon, 15 Apr 2024 21:46:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjJiN4sk7slyW1gbhfGoFcXXDmV9FAeRULRLojKqmJEU/91CsGyWgRN1k0slv+TC4KPAhXiw==
X-Received: by 2002:a50:ab15:0:b0:56e:2493:e3c2 with SMTP id s21-20020a50ab15000000b0056e2493e3c2mr7415995edc.37.1713242778055;
        Mon, 15 Apr 2024 21:46:18 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-50.web.vodafone.de. [109.43.179.50])
        by smtp.gmail.com with ESMTPSA id i8-20020a05640200c800b00562d908daf4sm5602008edu.84.2024.04.15.21.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 21:46:17 -0700 (PDT)
Message-ID: <3ed01604-3b9e-4131-9ec0-c354c6d65cc8@redhat.com>
Date: Tue, 16 Apr 2024 06:46:15 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC kvm-unit-tests PATCH v2 00/14] add shellcheck support
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, =?UTF-8?Q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 David Woodhouse <dwmw@amazon.co.uk>, Ricardo Koller <ricarkol@google.com>,
 rminmin <renmm6@chinaunicom.cn>, Gavin Shan <gshan@redhat.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org
References: <20240406123833.406488-1-npiggin@gmail.com>
 <a7cdd98e-93c1-4546-bba4-ac3a465f01f5@redhat.com>
 <D0L86IDPMTI3.2XFZ8C6UCVD1B@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <D0L86IDPMTI3.2XFZ8C6UCVD1B@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2024 05.26, Nicholas Piggin wrote:
> On Mon Apr 15, 2024 at 9:59 PM AEST, Thomas Huth wrote:
>> On 06/04/2024 14.38, Nicholas Piggin wrote:
>>> Tree here
>>>
>>> https://gitlab.com/npiggin/kvm-unit-tests/-/tree/shellcheck
>>>
>>> Again on top of the "v8 migration, powerpc improvements" series. I
>>> don't plan to rebase the other way around since it's a lot of work.
>>> So this is still in RFC until the other big series gets merged.
>>>
>>> Thanks to Andrew for a lot of review. A submitted the likely s390x
>>> bugs separately ahead of this series, and also disabled one of the
>>> tests and dropped its fix patch as-per review comments. Hence 3 fewer
>>> patches. Other than that, since last post:
>>>
>>> * Tidied commit messages and added some of Andrew's comments.
>>> * Removed the "SC2034 unused variable" blanket disable, and just
>>>     suppressed the config.mak and a couple of other warnings.
>>> * Blanket disabled "SC2235 Use { ..; } instead of (..)" and dropped
>>>     the fix for it.
>>> * Change warning suppression comments as per Andrew's review, also
>>>     mention in the new unittests doc about the "check =" option not
>>>     allowing whitespace etc in the name since we don't cope with that.
>>>
>>> Thanks,
>>> Nick
>>>
>>> Nicholas Piggin (14):
>>>     Add initial shellcheck checking
>>>     shellcheck: Fix SC2223
>>>     shellcheck: Fix SC2295
>>>     shellcheck: Fix SC2094
>>>     shellcheck: Fix SC2006
>>>     shellcheck: Fix SC2155
>>>     shellcheck: Fix SC2143
>>>     shellcheck: Fix SC2013
>>>     shellcheck: Fix SC2145
>>>     shellcheck: Fix SC2124
>>>     shellcheck: Fix SC2294
>>>     shellcheck: Fix SC2178
>>>     shellcheck: Fix SC2048
>>>     shellcheck: Suppress various messages
>>
>> I went ahead and pushed a bunch of your patches to the k-u-t master branch
>> now. However, there were also some patches which did not apply cleanly to
>> master anymore, so please rebase the remaining patches and then send them again.
> 
> Hey Thomas,
> 
> Yeah the sc patches were based on top of the big series, so some
> collisions expected. I'll look at rebasing.

Ah, ok, we can also try to get in the big series first ... I just lack 
enough spare time for reviewing currently, so it might take a while :-/

  Thomas


