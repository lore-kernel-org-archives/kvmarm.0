Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4786218054
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 09:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706089541; cv=none; b=k9c9zbMorx+++GU+er3e80tgZWeDSk/SUrUoRdbIFYOUZHYiP93THBlYIYg9aVPuQMSugoNV26sRo84TSFJ3NzWR0QlfgdSWoKGfeWQuvlKsD1+0+OOv0IucO7pmSZ5U3RFsAuaw84ZtMqY3Qu6M9+LDQn0/NHg9Lew2x97mBfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706089541; c=relaxed/simple;
	bh=zZgjJ5sObV4V6Fc4Ezw3PQUaia4ZAxVz/ghRZ5tneks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fbDs8jm7LKAqJ/GxHKNwSwV+ixJ3y9zwy3yltHCT+H92zODc+ueqNEsMUhSYMF4DxZm7us4zwcAhlpwp/3flzXZDMQnzLZrGr/TWwdeqUzm5X9GoTaT71IiFtw4XGbZ0dykze4q0YMxmzMjt2hX6giRgeerwS6SNAMUXrJyMHl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BQHoh1uI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQHoh1uI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706089537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vFVmbMK/0jD0DaOJ344q21rhp3Y1wmhStABcCKCXFSk=;
	b=BQHoh1uIZdn8ck93Zwh+MRQB9wRo/xdvGoBzWUk4VojIlVbzvbwh1Nbu6Z3LtYIgSCmvy0
	o37MYiw8utZTi3Z+1Y00HdG6OKBo2n/Bb5DbaFdnN53V2e6pOR6YHBl+PlLs9F1BOauvK5
	5BktC9W5alU8jFpGVfKRpActjBMq0KA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-alGgr_1eO06S1sHI1Muogw-1; Wed, 24 Jan 2024 04:45:35 -0500
X-MC-Unique: alGgr_1eO06S1sHI1Muogw-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-686aadb56a1so20066476d6.1
        for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 01:45:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706089535; x=1706694335;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vFVmbMK/0jD0DaOJ344q21rhp3Y1wmhStABcCKCXFSk=;
        b=A0V2eJnfZq+eTZ9M7CgW5T3btOnGUafKUi78o18rbXX7A5lJj/Sjv0+fLpC/vOcWbu
         1gv7mlK0sLtZoQ4YfNV4qYM3K6N4VWysJ8zpiPu0twEWJpyVI5IPYRgFCiIEY7+YuWmy
         5dbwojPuUsl0Sr3JkgpskhokyhJbnxQASm5zsKN3AeeDNS7YLg35DZMTSUtSs2EgQprS
         NIby0WlXkWt8hMJCgqJuvrNv/qfDtPA3GD6Q232tSKBnNKM1iMyZJ3fDBtzhxmWKIeKW
         uc+hBurRF9LJFsyiMAS8Eh3lLBwb391exS7ipJQwVHPFKb0JH8ucWbZUbgtJLucmRW80
         IRtA==
X-Gm-Message-State: AOJu0YxCwrNFmNTAUVSz1I86SYgy3x4zyn1eb/ay4gyVLEz8VIwGEFUq
	VTxpIxKO56It5IX1FNF0nvi1vkBA8K05OamRiVWI7pIIRRE6qhhpxI2XNSOkfJdf+2kOf/XzRIH
	M8LLM9G51EPyIp8gDgYdyrg+OgfP106Sf83wRm68yus2u3+dn9A29Gw==
X-Received: by 2002:a05:6214:dae:b0:681:9a39:c572 with SMTP id h14-20020a0562140dae00b006819a39c572mr1505715qvh.1.1706089535368;
        Wed, 24 Jan 2024 01:45:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEl9LBxXEGhQrIWhBMzjgECkFPLTEsvbDNBH2y0JTZImB/9lozjy3/mwXqYwga9ELPx5t+ZEw==
X-Received: by 2002:a05:6214:dae:b0:681:9a39:c572 with SMTP id h14-20020a0562140dae00b006819a39c572mr1505704qvh.1.1706089535133;
        Wed, 24 Jan 2024 01:45:35 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-177-121.web.vodafone.de. [109.43.177.121])
        by smtp.gmail.com with ESMTPSA id me17-20020a0562145d1100b00686ac6401fdsm664081qvb.13.2024.01.24.01.45.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 01:45:34 -0800 (PST)
Message-ID: <283af7cb-33fa-4486-a038-0c5a2235ffd5@redhat.com>
Date: Wed, 24 Jan 2024 10:45:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 23/24] gitlab-ci: Add riscv64 tests
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com
References: <20240124071815.6898-26-andrew.jones@linux.dev>
 <20240124071815.6898-49-andrew.jones@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240124071815.6898-49-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/01/2024 08.18, Andrew Jones wrote:
> Add build/run tests for riscv64. We would also add riscv32, but Fedora
> doesn't package what we need for that.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>   .gitlab-ci.yml | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 273ec9a7224b..f3ec551a50f2 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -87,6 +87,22 @@ build-ppc64le:
>        | tee results.txt
>    - if grep -q FAIL results.txt ; then exit 1 ; fi
>   
> +# build-riscv32:
> +# Fedora doesn't package a riscv32 compiler for QEMU. Oh, well.
> +
> +build-riscv64:
> + extends: .intree_template
> + script:
> + - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu
> + - ./configure --arch=riscv64 --cross-prefix=riscv64-linux-gnu-
> + - make -j2
> + - printf "FOO=foo\nBAR=bar\nBAZ=baz\nMVENDORID=0\n" >test-env
> + - ACCEL=tcg KVM_UNIT_TESTS_ENV=test-env ./run_tests.sh
> +      selftest
> +      sbi
> +      | tee results.txt
> + - if grep -q FAIL results.txt ; then exit 1 ; fi

IIRC it's better to make sure that at least one test passed:

   - grep -q PASS results.txt && ! grep -q FAIL results.txt

Otherwise all tests could be SKIP which indicates that something went wrong, 
too.
We're using the check for PASS for some tests in the gitlab-ci.yml file, but 
not for all ... we should maybe update the remaining ones to use that, too...

  Thomas


