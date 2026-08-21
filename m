Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B392631E841
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 14:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787321145; cv=none; b=DB/ta2f91/exwE0QE9uzB6gSlKuFyzopSnOk/67o/ecoRs5/sXuKx73PsXDG8rRonZBdv9tARlklrOQ/0k1WgukpDuyJruLDUFxxwo/oiVONN6f6ey0wX8O7qudfORlfn6QsY4qpxb+Rs9qfBlL3EnOvzK8cKAUFoGidw7k1kak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787321145; c=relaxed/simple;
	bh=jDrIyCe2jaCiIraTFxwU4uL7bpB+DZ42EwaByqhvMF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kx/zhkgNR/f/5T7j8Yi4FHT9fszUDn3Ki2fCkH/YTvGA/amrm1bbVLBbF8UFqak+V2AvyiR4WD1Eyvjs4ASRUjoH1Gj5ITWMmn1MX7L+0v7uZAtqYgx+x7v6snQ7nm0oMNC+M1HNSJIAXPe6+aHSmxwj5f/YSMoBIFd0pLNClYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L+3NFt2s; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L+3NFt2s"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-471eeac43bfso926873f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 07:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787321142; x=1787925942; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sfvUUTP3o9O2j15EPReGLnJgVKtQAvfjBsA4ztGbKes=;
        b=L+3NFt2scHS8uqbQGk9OYi1jIEnQrJRpmdIrZ8vX+REXX5TTtn2TW+K0QuaElxO+QV
         bWyuVcE9AnTTYUpEit0Rwb3NJ0PEkotujFLQFtmQtU3EcNHA6D2xBec2zOZTn5pNruKc
         oPmyL6sO6JJXgmoxHbg9+FT/Z3mfAcLXu1lEeL8G9NAPl1EETnZvqNtVYYWsohxBxsAv
         ubFNLWhovc//vvo8in2hEMbb3ZlqhP6Ti9RZE9uQU/VWu3+kycu7WJmmc8cdVfP1v3BY
         csFDgS6U60CTt8010Fpji+LDVzj1K9MmNKJ1CKEdX3zUg7t3qb0pmR7UMUETmaXUybWV
         9j+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787321142; x=1787925942;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sfvUUTP3o9O2j15EPReGLnJgVKtQAvfjBsA4ztGbKes=;
        b=Su2YiR4Q+aqhbIqMfri7hoKasRq36aL6ZlGQ5GXRfb0ZnxKEDjJ12Im9Z6RMWf5zko
         4vYftG98L6b1QnEElDebn8oAP8iTP3M3eV32WldNer+RsqcJmRMP25oFR9hZUcKCByYa
         fxevXATo7dTD08+4qOo+iriWE1WSVn6KEW7Up+yVfxxSVJWwkf0QZvQP4OXNdC4gZQsE
         FjrgiuKqCEbZljSxsI/3McszVh2BkZCgzU+P26wgt01BBNFymJ+EnrS3oHQnIJm0CdZP
         pjC550G6iDzxrtvrN8YBWnOoo61iHcSVuYtHzRwxVS+lMhSp34eU/xypCuqMaE/ORWEE
         liww==
X-Forwarded-Encrypted: i=1; AHgh+RqOrO/QHjo9A2yvMG28YDyEXn+Wd//q5d8+dacdyxomkH+kWDr5ILispHRsRQSs7+JUCoBqdus=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiBmSWAO9tdr8nQx6IiyZyfJXTQjLCAlzsKgCvieSXd88Oq0DI
	9+MaGmwiSy7vnKw25EcyrPP14CWakICF+9Exv7r6e7AsvZRmc2/XSRuL
X-Gm-Gg: AR+sD10J/9GVQ/nlSqL7AM0qUX8+e6vL6oR8mLsPCdHF4Gjw9f9xXpQjmX3TrOvaIzO
	8f+KxcEdISHc4wa8GzCGh3UmA09VK+GLgpadons7Kg+53BSc3TK5Z2bOuwcRDXzJ6hYQKyp7O0r
	3IBWq7ZaxFFZjYD2t1VZO9/oCI0ey+V3yhGO7jBKVcxpuOkbeaUgHgsvtRxQUvcfhTPJfcmJg8o
	wvqkGXrYbI0FEpvhSn25NJB7MC6p293sdTnEbK98UUAYleVwnRWK8y+K10qjERF3xSVSa9eRd5h
	+wPWu+xPD13+epg5UWIXHEfAEhr4l7o4pwprvvIitPf0aY9awMLqNbINDS5mixZ8QvDnNLg6zfm
	eIfw+lvWIJyu+RI+HL4VBrSZ+hXFDxHYxNKiSY2yBH5gk5qJA8egBMiWyQv/Kzx+n3NnT/jSqLc
	zgWLfSNZjEgJ1MfT7CBENYfs29rCAE35zlxvhqkvJHZWuT4mSSTqhi4lmv30oY7SkbRV/MGwIHW
	rfT7Z54Li1iuaQ=
X-Received: by 2002:a05:600c:46d1:b0:492:4e09:9fc1 with SMTP id 5b1f17b1804b1-499b8469f20mr84781845e9.15.1787321141718;
        Fri, 21 Aug 2026 07:05:41 -0700 (PDT)
Received: from [10.45.28.226] ([15.248.3.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499b9049f84sm29305385e9.0.2026.08.21.07.05.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 07:05:41 -0700 (PDT)
Message-ID: <986b9e8f-f136-41af-9ded-8bece569c0c0@gmail.com>
Date: Fri, 21 Aug 2026 15:05:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/5] KVM: arm64: Add pre_fault_memory implementation
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com,
 joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 shuah@kernel.org, corbet@lwn.net, vladimir.murzin@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 isaku.yamahata@intel.com, Jack Thomson <jackabt@amazon.com>
References: <20260612162354.73378-1-jackabt.amazon@gmail.com>
 <20260612162354.73378-3-jackabt.amazon@gmail.com> <alEXtW7w-rqlNG09@raptor>
 <yq5acxvz4u1i.fsf@kernel.org> <antH38FPSmAZ0nrB@raptor>
Content-Language: en-US
From: "Thomson, Jack" <jackabt.amazon@gmail.com>
In-Reply-To: <antH38FPSmAZ0nrB@raptor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Aneesh and Alex

On 11/08/2026 5:03 pm, Alexandru Elisei wrote:
> On Mon, Aug 03, 2026 at 11:36:33AM +0530, Aneesh Kumar K.V wrote:
>> But both gmem_abort() and user_mem_abort() handle -EAGAIN internally, don't they?
> 
> I think you're right, please ignore my comment about an existing mapping with
> is_protected_kvm_enabled().


Thanks Aneesh, yeah that's the intent. Vincent pointed me to the
pgt->pkvm_mappings interval tree that can be used to detect the existing
mappings in pKVM, so I'll be updating to use that in v6.

-- 
Thanks,
Jack
