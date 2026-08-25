Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51E4440A09
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 13:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787663100; cv=none; b=l8v2D16bdpNEl712t+KK6mVlebeTgTFl8Dcqsiuf4AeSJw3UBO/4R4HMfLtLpBtn/rZnkx/IpiSwwOIRWDIYPn1i6t+hU4GG9DZVG2E0oxiZAdASK+TLku6E2yY4kPrQGHuM7zydFn5Mio/VQiyoyCcHl4EHAiR1IN4gQLBxM90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787663100; c=relaxed/simple;
	bh=S7aRfssWDQ2nLsCC53U4z8DSCtzysrcHj28aPhwBZ4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dVgemNtzoiPWtHNCBCrvnD92ibDnGb7UlLxcppUKrTHl02H65UNttljwZZRvIS8wmfEGeVLjYG5DNxgPxB9zXu5udHOHM7XlGX/3QvDlOoP27a2tyBUn3ikE96ioPqXf3ZqST2MINbLQZyuskZUCc0WNlknVziK/lRQ72j0hEiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hBfvuYUz; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBfvuYUz"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a10d02ff43so9185272a12.0
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 06:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787663094; x=1788267894; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PQylkDyhUMfAxwzHJuOU6RYKfPVocoG2MM8Zczy9TIY=;
        b=hBfvuYUzi8eRBK9TD7WR0EgpcHk5eWVn+qlCBuZabFKFepIwDJaTuLg7+yzZrCMzpc
         0J4o2lCJtFVXpsVRoQGOCneExAOnQXI/7OmPF0yD/N1VkJw8eXi1p7FsZbKusfQB2x3d
         fBqwlLSmVDtXca9NtUhqN5/YjfkzWVF1XDF00gf0izgkNDTpLISb+cDrm/Wl9lxfp/9l
         v+woGdUy0SJLXB0H6AwqIo8ojffmDW4HLmn9ER67RTVTXv+sS2Vbi3G6o09aTNOQMTG9
         NnPHwE+78bI0epJFzbkN87zNtGiaS9iRmvSmLXalehEkGEFjrdsyzbgHa+KJmNwicvS9
         +/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787663094; x=1788267894;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PQylkDyhUMfAxwzHJuOU6RYKfPVocoG2MM8Zczy9TIY=;
        b=ozypC89ckFKJplukrYeT2QwexTxzzxlhmwnee3oiJ0v0ZuP1qA4FkiTPmTThZZw/Oe
         VKnZ+6dUyfZlsUrDfv6laJ55aRAman/nzatmOVwfLo23ogaON9NWsMXlbcjSL23QxHDD
         c30XDIoR6IVTkpRML8KYOtRpfbS1F1ThGYeZmVrwv8CjI9rqPeKWrTVH25qaKG0wwvsA
         cR+xk3WYzMWrG5nAaXt//A2jLiQmbIBD9InuoWFMqMydtY5PimVOK4CGML9HbvfIQoW8
         FSYSynQQztbDt0nHLhS5nlPstRDtZs8+dEtfkdMTnWbvEMPlhhhQv3E9Q/aEY4naiM7I
         Lnhw==
X-Forwarded-Encrypted: i=1; AHgh+RrUsBYo/iK+kNCw8PtpIkIwKqulpAFARoeNKQiMIIhS+8pmuHi1xQYX95gmc7y066rQe8GHJKU=@lists.linux.dev
X-Gm-Message-State: AFuF++mAIHkLUyYlpsFkU8jbVfpG+K23QLQBGCiBhVg/hFm7rUWR1Ksd
	uz5+aQB6G7dVbVw1zTpzfsSSJUyeoZPgaefMb/kK+o7SFVm8fALIvpRX
X-Gm-Gg: AR+sD11iXynL9vrM/4XP6EqT8e3FZYzPSxK4tneooJg03nPVBcoTFdX9tqMDNJhc4cV
	J98hPcJUWsrMmbM2Iou8IaXU5ZcfXxrLE80O0ikFlqVKlovp9c2rAC9+XbG+sOyZ7o6MK/q5yb1
	MdH6xcKY1VFEWiDq19LtfOf5ehs49gMMA2lVJwACTnIN/KZs5arMu6P/khPvxSycEPelFMxE7WB
	HlqEbNxiA0y59oOfhMA33PXzTHAn9wG7WCsiO6OEZmstdSVt2LOHaBLwc28xiE+/sX2jDzqBRyw
	10h7OT6MjhkXe9zzRUDEFbYB/KHvHaQnpTGwmgUIlfSkUO4KocM7DD/Capc3qetFvDdd25whiO5
	b7Q2Jf+0SfPynse2G/tO/vLPP2G7I7SBbtarcmJKYfl0jy2vFJZfiUrAqoCgSaGcnyxJvSl+2SA
	1OK1an+iL3F/9r+Rxut90HxtF0LBHtJnLargtE6bSljmV9y0RkULibvb1y61DuEf0A6Bjq7w/lM
	1oX
X-Received: by 2002:a17:906:fd8d:b0:c25:58e:83ff with SMTP id a640c23a62f3a-c25058e8844mr45353566b.10.1787663093845;
        Tue, 25 Aug 2026 06:04:53 -0700 (PDT)
Received: from [10.45.28.110] ([15.248.2.30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606b4f1sm1822703566b.3.2026.08.25.06.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 06:04:53 -0700 (PDT)
Message-ID: <f81f8437-57da-4545-9046-28562df3c385@gmail.com>
Date: Tue, 25 Aug 2026 14:04:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/5] KVM: arm64: Add pre_fault_memory implementation
To: Alexandru Elisei <alexandru.elisei@arm.com>
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
 <0365d77d-616b-47f7-a5f2-3388bad692a1@gmail.com> <ao2KmmUd1lVFUUkp@raptor>
Content-Language: en-US
From: "Thomson, Jack" <jackabt.amazon@gmail.com>
In-Reply-To: <ao2KmmUd1lVFUUkp@raptor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Alex,

On 25/08/2026 1:29 pm, Alexandru Elisei wrote:

[...]
> 
> I think there's a word missing there, I meant to say that it would be useful to
> explain *why* the x86 implementation does not mark new PTEs as accessed, while
> arm64 marks them as accessed, and arm64 also does that for existing PTEs.
> 

Ah got you, I'll update the docs in v6 to explain that. Thanks!

> I was wondering if you have any plans about posting an updated series.


Yeah I have v6 almost ready, I've addressed the comments. While testing
it found an issue on pKVM which would case a hyp panic if we prefaulted
before it's first run, the EL2 context load blows up. So I've also go a
fix for that bundled in.

I'm just tidying a few bits up and hopefully have it out within the next
couple of days.

-- 
Thanks,
Jack
