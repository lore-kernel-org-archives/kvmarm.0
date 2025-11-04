Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1BA2E8E09
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 11:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762256441; cv=none; b=AnJUdmAgDWSY6KkbiuyISFmz0Fi00ybIltvhuqXf0L9MRyFyNY3YMW0GR2RI47f9oWgbyCORUPY1/VBsGM4Pggewri42tvFzLlh++zPbO6vea2ZWCxBtD5i0VfP+MquTL1mhuyqhNyBCrd3+XOV5w15DZr9JuZJ9QnjBCWBdDUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762256441; c=relaxed/simple;
	bh=+oWB3A/Q6CzSkeY4soYqa5X1mb+HtRxJLp8w5G8pEck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q/0cqY7nkVR6cWmsT5hPEdrQph8Uq6NM1YPp25YzJuuvQHPgMrDZNke9jbDeNJRo/ZOI0q2SVh9zS9PzQcnYx0XTrsuHQarkg6EeqeEt+UcoD1GYHD0bzPXJFYcZDG539E5yeTyk1M7iw8yzSfnPguIpcXu31Tix6GtlBzouu8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NZJBRGDm; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NZJBRGDm"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4710665e7deso25425595e9.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 03:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762256437; x=1762861237; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VtEDtvTY+cIWIGM0pelvhRwZ4E8HNdVkiBIKwKLkzCw=;
        b=NZJBRGDm0CJ0xdqpKKI36/300lSO351q7hGObhPO1Cy3ASBEa4wdG0hP6k88QFD8X7
         mX0t6AcSRXYPPvamEl+VG1cpO9YRke4csycnWXwGX/clOnNdrK4ADP5CDk5SBKxH+ofI
         uZDaWZeAIZcANdugxS2RhIzlICo9J5yi3JbkDmdaWQDiZ/2joYXnRnYWkjUrQdSpS4c0
         F2P9mtbrFc1K4COdybk/D6I7qq5qLo6iZKw3qvX0Sz9fvxF1PWb5Zeo4+YL9Yt0M6wzK
         1gUBN5XMgYlVYGJ+1uF5LbiovZ4P69SjYvOrArrXIHF2nwVNKLKWuE7bk8ZVasaBrmNc
         9bLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762256437; x=1762861237;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VtEDtvTY+cIWIGM0pelvhRwZ4E8HNdVkiBIKwKLkzCw=;
        b=vS/5Q4SuK1EHsxxak40HMptZK3TS79rGpe/JqT6QL64lezKnoN0W7m71XWe4wJrxF/
         7ZzzfD7YIWRQ8F/yWw5Udckggs8fH3Wmh0seFQHdR2G+dG8ZyrDNvjWl7lZOOQ6iX2x1
         fUnOvrxrQcGu3aMUUpJjr3KYxVo7gtuN+4rK7gi8qSbgHlY6FCVuiMn90KPBaOEE83jV
         kAPErlKMWxkFcNxk22WwpOuIobCI84qQfoGElLclxv9zSSKhGA7gwBYqqohqNeV8fpWZ
         1aOFfI1kVSEPZwHAty6Cr89U79nXL2uTBv0VRycycaRrYQkcVCfAd7snIYLi416z9zQC
         x+QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxVonilT47h5C5ol6GK0i5x1uIVeHsavnmby3VXeLCf8aSCfYCiXL18Qx9yq6Kssd8fpt1lGI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPjRQS7fdeGd/o2y013o5PbWMsmtIySFOiaLcacfwuAsXXJ9Hh
	ExGpwdjSsUNqvPoVwIpP/MS9Zo9S1XGqD8agu00mBb0NmeRDB0sYV3ul
X-Gm-Gg: ASbGncuFct/QVVqLtyw2z64Tz+ANvMg+XEJX8Q/KRvroYdBkXpOz5q6Apv5EYWzmv4z
	tEq+rvSexf08ejuIwtNH55utaihMtyBXTtIL96GWzdJX/roeBH2ND3fOwfXdOgXeZk058gXFjoa
	29ah2E9sz2kC6wX8Kie3AMseWvggSeYK3XB5Gccjijul7sXcxkSELdazs0FDtzW/MqYItXBZGR+
	7vkOzVPV4Jdel6DsnjHM1GlaRg4zqU4F0i6sM5lWpYV6etW9oFS875GAc9xj1ypH83m03mvE8cc
	zvSAJ+dW473wbcPKjYwLC3yB3yGPrnoP4RQ5+A88IAH3dvbqF4fjVyT8jk2TcLjI3kCwd0mlhug
	VjFRTcpqHQy9TdsQyDgaXdH1x6N+OZN79+N0zd9aPOddng5Zua0ed9RXjPFwXXDQwSwK4pzXtu9
	GGrWayb0qaYMmtmWfqH9M+Y2OZWg==
X-Google-Smtp-Source: AGHT+IHLUzkgy93j93/Y457i3JDPVA/x2jz7pwHQeQNMkgQOo5iNeUyTYKEKqioqrc6ql8RXud3YDA==
X-Received: by 2002:a05:600c:3146:b0:456:1a69:94fa with SMTP id 5b1f17b1804b1-47730802c68mr141327745e9.13.1762256436466;
        Tue, 04 Nov 2025 03:40:36 -0800 (PST)
Received: from [10.24.66.43] ([15.248.3.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47755a550dfsm33200985e9.17.2025.11.04.03.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 03:40:36 -0800 (PST)
Message-ID: <0c3db907-7012-43c3-b7fc-36848789da52@gmail.com>
Date: Tue, 4 Nov 2025 11:40:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] KVM: selftests: Fix unaligned mmap allocations
To: Sean Christopherson <seanjc@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 isaku.yamahata@intel.com, roypat@amazon.co.uk, kalyazin@amazon.co.uk,
 jackabt@amazon.com
References: <20251013151502.6679-1-jackabt.amazon@gmail.com>
 <20251013151502.6679-3-jackabt.amazon@gmail.com>
 <aPpi1c-8EpWuo87B@google.com>
 <c52db7bf-494f-49a8-9829-3805db6dda7c@gmail.com>
 <aQkZtjLt6lIULffA@google.com>
Content-Language: en-US
From: "Thomson, Jack" <jackabt.amazon@gmail.com>
In-Reply-To: <aQkZtjLt6lIULffA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/11/2025 9:08 pm, Sean Christopherson wrote:
> On Tue, Oct 28, 2025, Jack Thomson wrote:
>>
>>
>> On 23/10/2025 6:16 pm, Sean Christopherson wrote:
>>> On Mon, Oct 13, 2025, Jack Thomson wrote:
>>>> From: Jack Thomson <jackabt@amazon.com>
>>>>
>>>> When creating a VM using mmap with huge pages, and the memory amount does
>>>> not align with the underlying page size. The stored mmap_size value does
>>>> not account for the fact that mmap will automatically align the length
>>>> to a multiple of the underlying page size. During the teardown of the
>>>> test, munmap is used. However, munmap requires the length to be a
>>>> multiple of the underlying page size.
>>>
>>> What happens when selftests use the wrong map_size?  E.g. is munmap() silently
>>> failing?  If so, then I should probably take this particular patch through
>>> kvm-x86/gmem, otherwise it means we'll start getting asserts due to:
>>>
>>>     3223560c93eb ("KVM: selftests: Define wrappers for common syscalls to assert success")
>>>
>>> If munmap() isn't failing, then that begs the question of what this patch is
>>> actually doing :-)
>>>
>>
>> Hi Sean, sorry I completely missed your reply.
>>
>> Yeah currently with a misaligned map_size it causes munmap() to fail, I
>> noticed when tested with different backings.
> 
> Exactly which tests fail?  I ask because I'm not sure we want to fix this by
> having vm_mem_add() paper over test issues (I vaguely recall looking at this in
> the past, but I can't find or recall the details).

The test failures happened with pre_faulting tests after adding the
option to change the backing page size [1]. If you'd prefer to
have the test handle with this I'll update there instead.

[1]
https://lore.kernel.org/all/20251013151502.6679-5-jackabt.amazon@gmail.com

-- 
Thanks,
Jack
