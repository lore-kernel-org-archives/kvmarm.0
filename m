Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D106481B1
	for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200064; cv=none; b=dxAWMwOls8zpzUgI34IbFB0k1ExEIO7W/krfpFZCFBvQex3Iwq7MuyZhZj25FDWjr3oMHCPe2R2ia07HVtkFtcwHl4OhFZUbjdsZeGxL4YmKj+Zoif05OegHLZHs54uIvR78B3Q3Q7JND/m0ArKpjX92t4eZSYRNhMjID5iWmO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200064; c=relaxed/simple;
	bh=tqNy6BKpM2xDaY4FPSYJUXOIvAfzzDMUG7OXLcVzG0c=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Zv4zc5Rur3E29DF8+o+OGWhTNf4RIFiVu2Omd+jV7MW5WYIXK585EtL0B733lOFvj5yxA4Sd8zfxRt2luq9p+rtc+ktBZBcnYV7ZrGy0DyYidInssNgjrHtH3hgKVxtj3WLPyjS/qkxnDpFZk+Ze6a5Z5dk4XBRtpDzhc9j3IGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bjaIlm6d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bjaIlm6d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742200061;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qaEC6lM4c8aLRLEjNI+sQ2in0w+9/2SdD4KxuUiKf1U=;
	b=bjaIlm6dPzvkZhxYOvFi1kFXV5s0xqcKUwcey14EkrRl0YQyeZlNQOhGPIKXcC845FWhlf
	R7H82p187wdXowEYd3gwt0JPrD1+FDvRkuqLz3mU7F5zmaUKGrCSSpf98po4NiSCOlYG0n
	KGdb3yfrZxTfE4XG32FeN/0KRqCkX8k=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-_UbwuB8NOU6cd1ILboGxaw-1; Mon, 17 Mar 2025 04:27:37 -0400
X-MC-Unique: _UbwuB8NOU6cd1ILboGxaw-1
X-Mimecast-MFC-AGG-ID: _UbwuB8NOU6cd1ILboGxaw_1742200056
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-85db19e5e0eso398779939f.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 01:27:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742200056; x=1742804856;
        h=content-transfer-encoding:in-reply-to:references:reply-to:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qaEC6lM4c8aLRLEjNI+sQ2in0w+9/2SdD4KxuUiKf1U=;
        b=FIvoTnkxZJls5nDVV8epUVnb7v9FDiWkFM0gN/HgwpvoVS6yZ+UYtLDQWMuZjJVx7x
         aAsj4wR6JPCHOSlrDUq49z0Vu5g6dQ+RQKg0BZ1iK1cYflSOZfjsrNVwRYhCLaY/BS4B
         oXoy1RYFwGA9kEfKcrXW+Lv6g+vGHgAG67fmHATDvUy0ZrwJS8/mfRozRHNhjMxygNwp
         ra636oUvuBlokSElqXVGGO3bNd3wfjRIf0NYp5FcEtK5tZiCYUrCsiHgFwyEU8Nvk3sr
         RuuQYaVhMZIWNIZV8KmDUXCpvstXHKm9ZoDwvShGfK6uMsMIfL7qqsW49k0aWxeCzpMO
         WPAg==
X-Gm-Message-State: AOJu0YxUfY9DFrXYvvpLu1lTLWZG2bKedV9hpXOuF8GNO12+n9jaIdM0
	yb3tma7TwfSuAkyvDBdPb8YiR27YtKK+21RAyLUd3HdhwLg9aWnI9VJHFAg0M/FHthGF0+JRJOq
	zF9Q0XnqisiaiW0n9FZcERfTK1DwqoosTqqR1C0k2DNfUtiWQoIP2tQ==
X-Gm-Gg: ASbGnctMNPW13Ueojip1Y2tXCYuvUhUQUm0mUBo5tmVOH9Cpcd8UKzXKrJyCOIqtDdB
	ML48BY71aly1zVTbAMDpoCDQw6oNxd7NzrdSE7O2KKNL24K2Q9s6Tsfh1gNP7x42VIs8aBBg13x
	YYvuBBFrZjRW1zjYOoBPg2ExXtR+TzdIZOiVKBrJpUX71XQOH6xpztrn0WhhGk5+uJ8mjVobLxS
	ftMv+ZLP8Fz4nbSbTGfIRpLve+WKzDWKy9UBPxqiZxlShb3e1CwsME3IRjeIRKhAN2B99MOjSVt
	mX7/Iwr4TooGt756YF0Hd/DRypT4RdirwJQP4Tdddf/nWu6Ttt8WY4hQD8PiO/s=
X-Received: by 2002:a05:6e02:b46:b0:3d4:2a4e:1272 with SMTP id e9e14a558f8ab-3d483a7517fmr123863715ab.19.1742200056615;
        Mon, 17 Mar 2025 01:27:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGd41vdtyIf466bhMfI+neQE4uPHYcdKmdVV38Hf3JbIctOMMqGI2AFDJ73sUyG0hh2b4szAQ==
X-Received: by 2002:a05:6e02:b46:b0:3d4:2a4e:1272 with SMTP id e9e14a558f8ab-3d483a7517fmr123863585ab.19.1742200056319;
        Mon, 17 Mar 2025 01:27:36 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637031a4sm2196881173.11.2025.03.17.01.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 01:27:35 -0700 (PDT)
Message-ID: <fcb7894d-51e5-4376-b32f-4cb9eb94b573@redhat.com>
Date: Mon, 17 Mar 2025 09:27:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 1/5] configure: arm64: Don't display
 'aarch64' as the default architecture
From: Eric Auger <eric.auger@redhat.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Reply-To: eric.auger@redhat.com, eric.auger@redhat.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-3-jean-philippe@linaro.org>
 <1b0233dc-b303-4317-a65d-572cc3582b8a@redhat.com>
In-Reply-To: <1b0233dc-b303-4317-a65d-572cc3582b8a@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yIBVgLxmIjH_OoTBQHo4dXY4fA3fOT7hmSDz0Ob5xFI_1742200056
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/17/25 9:19 AM, Eric Auger wrote:
> Hi Jean-Philippe,
> 
> 
> On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
>> From: Alexandru Elisei <alexandru.elisei@arm.com>
>>
>> --arch=aarch64, intentional or not, has been supported since the initial
>> arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
>> "aarch64" does not show up in the list of supported architectures, but
>> it's displayed as the default architecture if doing ./configure --help
>> on an arm64 machine.
>>
>> Keep everything consistent and make sure that the default value for
>> $arch is "arm64", but still allow --arch=aarch64, in case they are users
> there
>> that use this configuration for kvm-unit-tests.
>>
>> The help text for --arch changes from:
>>
>>    --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
>>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>>
>> to:
>>
>>     --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
>>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  configure | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/configure b/configure
>> index 06532a89..dc3413fc 100755
>> --- a/configure
>> +++ b/configure
>> @@ -15,8 +15,9 @@ objdump=objdump
>>  readelf=readelf
>>  ar=ar
>>  addr2line=addr2line
>> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>> -host=$arch
>> +host=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>> +arch=$host
>> +[ "$arch" = "aarch64" ] && arch="arm64"
> Looks the same it done again below

Ignore this. This is done again after explicit arch setting :-/ Need
another coffee

So looks good to me
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> 
> arch_name=$arch
> [ "$arch" = "aarch64" ] && arch="arm64"
> [ "$arch_name" = "arm64" ] && arch_name="aarch64" <---
> arch_libdir=$arch
> 
> maybe we could move all arch settings at the same location so that it
> becomes clearer?
> 
> Thanks
> 
> Eric
> 
>>  cross_prefix=
>>  endian=""
>>  pretty_print_stacks=yes
> 

