Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFA3346FAD
	for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 11:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763033645; cv=none; b=u8BvNRhKIyij7Bjhkc7DGkD5Y7G9YrIfUf1pkDY50QFkitDOX/KxFsqIqO6UJtBT9emaVqa5uONJMkcuGanu4XxkPRs1PqPvJ+tw/p5EgiBoNIIgR5lY1Nnh5J6hXN7xNh385Zkp3mReMRYoQ7uuFxgYtBKfr1/bJZsHxjiUW/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763033645; c=relaxed/simple;
	bh=szEfWU/bVV1zSB98g0M2rX9bxqlQLQNTUONjL2LW8Zc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OcP9xQzrAnyc1oe1rf0GKpOZlbuvsjE/B5DLEvgqW/5258d27yOuOldPwIYvbyFg4wVOCNM8dz/t6Us9ks9SHFlm86xNps/XHPaJQQu/xC9Vf6b8uvMrLwKmaMnSFCVsp/j+nP++56DnPRFttHm/XXK9W/JxpwwmfSYVJHJZe2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHKiNLUa; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHKiNLUa"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42b3c965cc4so353246f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 03:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763033642; x=1763638442; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=itNJjGbKr9hOTSLlNwiZZOpbJXSs/2p7rVNvrCzyP+Y=;
        b=HHKiNLUaGtbJ6SHnWuxW+HvMe3FPaJgpKWvQh5hc0YdIuUNUXHuMuShSQCPJaGmO1O
         e+5UuA1uqTV+OX/8b/4S/W9hhRjJlzbz/rWHF8Js3fWfWAJInbnk/xwWxmsZnjg1sgn1
         EVr8oGHDFFWRfOLwb8/RCTQcOz/f8gzF9QSx7AL//BB/QdbppKX2ucdF9i/xdvuxnx+H
         oCxqjS2OBBfbUOzBAr0xlHS4dXv1NgcyuJJ7XAQXxdIGpi0VsDhQ5L0s5RIMI1beZu63
         MAFCYTmLV6djqYkPQzKYZUmnrD2y5uuh2DCShc2Rbwin5WJTHf11R+LbBelxhsCa7xqP
         3lYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763033642; x=1763638442;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=itNJjGbKr9hOTSLlNwiZZOpbJXSs/2p7rVNvrCzyP+Y=;
        b=FLjiITkzGaBqk36Lcv7g8yoDo+XuKFkOIXVytVeI3ftj0T9XqUkL9uRdKbYaE0ic97
         npHSED9DyJ6Y1Y7g85y1gH54dxYCdFkYBACLTT/SasM0ew28K7kCXRscmywkvB9BdKN7
         dFB5FC3hV8JuFequ1PytHohU1TtoEhxBJ3Cv5B26LS1P9/RunGLTDkc01oiZ3TjC7XRk
         y0o2/GijHrkzcj6X562O9QRHnbJepUrIm3IIenomNhiyHZ6i112v2YG2doPOB4T3mrSm
         Q4NmP1LMlc1Cx1M0drp1sgN12qJ5BpplwpwD5BYS5g3UmHVuH1N66h8pjy1lmfmoA9IX
         h46w==
X-Forwarded-Encrypted: i=1; AJvYcCU9yoWhqeR24D+N/uTwfsx83WkcpjMLWSs4ouBGOZHlAsLL+uvFqv/QBRSBoVyHZ4DjONvEBkc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzp9w7sX+htw9c4y4GZSROVAOGfSXUfEO8ZhKNcB0jnvn55To47
	VpzavVp5L7N6dPwtoDwI0vEeXk1DwIjcVXpy18E0d2L2GH9yWtImLpOE
X-Gm-Gg: ASbGncvP9/Mdfc8ybYXtMmg0BPDBXOTn/tkTG+GGmFXKUatGrvLg+aGNKMLKAS0wRGm
	UCWrHBe8Rm3lbOxTjQdETtxiNVamDgFySCzy3jikp2ikK7icLEBMDXTgYcfWamRlVANOLJCOP5w
	lY5HrB4s3CIBFHbLLXizt5lUVONnogdZmnTBU8jYLUs6ll1uLzuxuM7nBrnuwKnUCGHdjQWPuHM
	8gRXcpKZ3Gl2MShfarLsyUFsAysv7smzA14Pa4IB4cuVCwfbQtnTaMoVN+MwVD9tJ15WXjqDm4W
	LlODzfUiECAMso0X13lOI9qd1ZqGdoGm7NdKdXF10IFsHYhVdtMGtfDrplXMZznw+S/yi+j1XC+
	ViUX3g/K77gAOhQ5dw0SNfskWFNgrk2zkEb+uJPywYtMr5nDsLbbdi9RiSvdvzbSF3fFceSL0OE
	b1A2Wq5QG71jcqlSYGM1TLFZaAckk=
X-Google-Smtp-Source: AGHT+IGdopSjDKcZsfNDj50WFrJg2rJWrnZhwNBuCTBSaYL3A3I/G6d2OYwxOSpsfHYEqI44/nAYpQ==
X-Received: by 2002:a05:6000:40dc:b0:429:d3c9:b8af with SMTP id ffacd0b85a97d-42b5282384cmr2499048f8f.25.1763033642106;
        Thu, 13 Nov 2025 03:34:02 -0800 (PST)
Received: from [10.24.67.124] ([15.248.2.24])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f17cbfsm3172575f8f.35.2025.11.13.03.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Nov 2025 03:34:01 -0800 (PST)
Message-ID: <25469f8f-27ea-4d9f-af70-86e320224ec4@gmail.com>
Date: Thu, 13 Nov 2025 11:34:00 +0000
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
 <0c3db907-7012-43c3-b7fc-36848789da52@gmail.com>
 <aQpfviS-oAmanqpq@google.com>
Content-Language: en-US
From: "Thomson, Jack" <jackabt.amazon@gmail.com>
In-Reply-To: <aQpfviS-oAmanqpq@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 04/11/2025 8:19 pm, Sean Christopherson wrote:
> On Tue, Nov 04, 2025, Jack Thomson wrote:
>> On 03/11/2025 9:08 pm, Sean Christopherson wrote:
>>> On Tue, Oct 28, 2025, Jack Thomson wrote:
>>>>
>>>>
>>>> On 23/10/2025 6:16 pm, Sean Christopherson wrote:
>>>>> On Mon, Oct 13, 2025, Jack Thomson wrote:
>>>>>> From: Jack Thomson <jackabt@amazon.com>
>>>>>>
>>>>>> When creating a VM using mmap with huge pages, and the memory amount does
>>>>>> not align with the underlying page size. The stored mmap_size value does
>>>>>> not account for the fact that mmap will automatically align the length
>>>>>> to a multiple of the underlying page size. During the teardown of the
>>>>>> test, munmap is used. However, munmap requires the length to be a
>>>>>> multiple of the underlying page size.
>>>>>
>>>>> What happens when selftests use the wrong map_size?  E.g. is munmap() silently
>>>>> failing?  If so, then I should probably take this particular patch through
>>>>> kvm-x86/gmem, otherwise it means we'll start getting asserts due to:
>>>>>
>>>>>      3223560c93eb ("KVM: selftests: Define wrappers for common syscalls to assert success")
>>>>>
>>>>> If munmap() isn't failing, then that begs the question of what this patch is
>>>>> actually doing :-)
>>>>>
>>>>
>>>> Hi Sean, sorry I completely missed your reply.
>>>>
>>>> Yeah currently with a misaligned map_size it causes munmap() to fail, I
>>>> noticed when tested with different backings.
>>>
>>> Exactly which tests fail?  I ask because I'm not sure we want to fix this by
>>> having vm_mem_add() paper over test issues (I vaguely recall looking at this in
>>> the past, but I can't find or recall the details).
>>
>> The test failures happened with pre_faulting tests after adding the
>> option to change the backing page size [1]. If you'd prefer to
>> have the test handle with this I'll update there instead.
> 
> Ah, yeah, that's a test bug introduced by your patch.  I can't find the thread,
> but the issue of hugepage aligntment in vm_mem_add() has come up in the past,
> and IIRC the conclusion was that tests need to handle the size+alignment, because
> having the library force the alignment risking papering over test bugs/flaws.
> And I think there may have even been cases where it introduced failures, as some
> tests deliberately wanted to do weird things?
> 
> E.g. not updating the pre-faulting test to use the "correct" size+alignment means
> the test is missing easy coverage for hugepages, since KVM won't create huge
> mappings in stage-2 due to the memslot not being sized+aligned.

Got you, that makes sense I'll update this series to resolve this then.
Thanks for taking a look.

-- 
Thanks,
Jack
