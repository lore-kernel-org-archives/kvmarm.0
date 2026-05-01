Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3777440DFBD
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 02:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777602651; cv=none; b=WXMpf9hM6zRgSOdjYJoLQUMPyhlQoDkB2SIYqQqKFYKP0CNys7XXOpU5b97zbZxxGNp7NtfllLdyTFF2ZxOtNsjp+hFIpl8WLWcwoCSnGcogC0n42KqekCya8++QOW8UlQfGVUsc36foS3FymHIYqQLzuvXZsSssavJdt8sNhCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777602651; c=relaxed/simple;
	bh=/IRFyLS/V26r1hRKe6NgfsO4ihu7Z+8H9cq2UsOyb+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g+T1BWLAW6CK74133m8oc0PCS5KwyhLr3BY8bE/ezQkumoOg3sNNx1jVV5NzS3q5JHfXTJ9N/uPDufYQeddeuXhhOkFXvNvZt2gPj4hPfbSAqYxSHj44TU649f+K4WtvZoQ3AVVI9priA9l7q1QbdSZCAsdVSsjUp9bBiN9G+98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20251104.gappssmtp.com header.i=@immunant-com.20251104.gappssmtp.com header.b=eLhKZj3W; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20251104.gappssmtp.com header.i=@immunant-com.20251104.gappssmtp.com header.b="eLhKZj3W"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-79a46ebe2beso16296787b3.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 19:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20251104.gappssmtp.com; s=20251104; t=1777602649; x=1778207449; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1ltJ1qk7ArZg0qL7brVsQZxHqLIMgRzChfwso+j23+0=;
        b=eLhKZj3Wtp0+bWsCWhAVYTu6XuM2zvx3o/XhJhSsjlI+TUc1hVGeP9wK7AlAHl+V7I
         QOTgMNHbksprKNDOO0MFfAd2P+xj0ZeAOiGSlXJhJD+1qp/GkWywqfCv0uAGW2jGxLHn
         FFT0IcFZyOooILfye0t6axLvBpTEzLTndwUGxMWVVVcux+Zno0KJiunWR58Cw4qTF+eM
         Zy8/r70E63zMHqSAnpTU4yEceEAJqQ9/7EHqj33hnh1P2wR5P9hg8tQ6qZSEzqth7zYV
         IvwLsNl+Mqp+4HNMKqxw/kHnmu2Z/uyO7/FOII6PS+qMF1hPggPsth37jcywNuga5/zJ
         cUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777602649; x=1778207449;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ltJ1qk7ArZg0qL7brVsQZxHqLIMgRzChfwso+j23+0=;
        b=fYFtEYM7Sb3Ti9/ze4cl+hNkTV2nBggv8Le3qPcua5QpV6LHYAEPT25gSaYZXNdNOf
         QREYkup6otCi+jokdxLVw1HmkUO1D0NnmwVFlW1NiMvl9bN8wRMb8fM0VsSrl7zlwe3v
         tmMtcbfnnlqlqOLpsv+BB9qYgF6u4bVBib9HVENeOgydXJQupZ/aMWd/OHBjHPbUsmNm
         oQPFE+CAEoWaJRKRncQfLy+4NdH0Ic3siSFrB49MVGoMWLeLIs5NZgMXvd97/Twqa5nX
         5Wd1DLEoh1UElqkHdqDBHsjUVB2/YyR3tBuMts1/hMUZpFgxX+qsK15up+gcAX7lJ9nZ
         OYvQ==
X-Forwarded-Encrypted: i=1; AFNElJ8EvvGFF0LCY4kSCHgJTtX19vyKCVABlRvW4DUdRh0WHSbE80EnixyyWFvuhk9lV2BFf6VExwQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywx+d8VlSpnOts0nkULokEkGyoBEJBkdD5fEUCdr/BAvUHsjOD0
	X6+/4oCAquYAWQhEtHAErUCMl5/NxyrH3HC1P4DuHySyp3TId3uWRsd1dQ5i1538LwU=
X-Gm-Gg: AeBDietvxXdih0qnY7g/xzYOqz7R4BQ/h/o4Rcc1Em9GyqezQd+2zi40ql4woCK4PHh
	tOBtrnm974E8wVPWzcja5W3XSW4QHnfpCup6ILdY/HBrSgS5UHa/LKZlDKh8RTFP1VryhuEctRk
	17LwP8PbUJt31Hzs2iLAsbHjwPvbq0PDu/4LP7/pAmm+c4LjBCsvXVLUzMTS4Un9MALsSkoWJ6+
	GxoKNuQborQlpp4Or6sJ4Zol1POvhWwiKZ05TbO8Oets0K7Ca6VUPBVX0o5iZt/gjaw1HYfUqe/
	ihFEqAToLgdRztyYp9fDdoVZEBq+kJ2oAyTNyvWlUfJwSjzC5cynW5lcdRwPCi6km46wE5SPUoe
	r115fbZEV1prCiJ5bNew0j3ZB6O2QMmKtbYWZva9t1yMyBcgWfgRR13SWkUYpqbQnQJN5e8ztdu
	WdH17roRT+tb88WgkI2H5PlQeW/RCFweY1264Lj4jratVcKnUNGga+0FhPvSf54hBhetFcN4HkI
	u4Q7zQ=
X-Received: by 2002:a05:690c:e4ea:b0:7bd:696d:5125 with SMTP id 00721157ae682-7bd696d561cmr7221337b3.45.1777602648819;
        Thu, 30 Apr 2026 19:30:48 -0700 (PDT)
Received: from [10.87.48.52] ([12.15.201.178])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6652dae3sm5424557b3.8.2026.04.30.19.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 19:30:48 -0700 (PDT)
Message-ID: <e03a3c1f-4b1c-4431-80e2-62051c8d227f@immunant.com>
Date: Thu, 30 Apr 2026 19:30:46 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/2] KVM: arm64: Support FF-A direct messaging
 interfaces
To: Yeoreum Yun <yeoreum.yun@arm.com>, perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Ben Horgan <ben.horgan@arm.com>,
 Oliver Upton <oupton@kernel.org>, Armelle Laine <armellel@google.com>,
 Sebastien Ene <sebastianene@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260121-host-direct-messages-v5-0-2c1614c94e80@google.com>
 <afPMQ29x5fjHwtDo@e129823.arm.com>
Content-Language: en-US
From: Per Larsen <perl@immunant.com>
In-Reply-To: <afPMQ29x5fjHwtDo@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yeoreum,

Sorry to keep you waiting; I'm addressing v5 feedback now.

Per

On 4/30/26 2:40 PM, Yeoreum Yun wrote:
> Hi Per,
> 
> May I ask how this patch is progressing?
> 
> Thanks!
> 
>> Support FFA_MSG_SEND_DIRECT_REQ unconditionally.
>> Support FFA_MSG_SEND_DIRECT_REQ2 if hypervisor negotiated version 1.2+.
>>
>> Framework messages (FF-A control plane) are filtered out. For
>> FFA_MSG_SEND_DIRECT_REQ, we look at flags in w2. Messages using the REQ2
>> interface are always partition messages.
>>
>> The second patch was part of a previous patch set [0] but was dropped
>> since the use case was unclear. A clear use case has now appeared: use
>> TPM device with CRB over FF-A when kernel boots with pkvm [1].
>>
>> Tested by booting Android under QEMU.
>>
>> Best Regards,
>> Per
>>
>> [0]: https://lore.kernel.org/all/20250730-virtio-msg-ffa-v9-0-7f1b55c8d149@google.com/
>> [1]: https://lore.kernel.org/all/20251027191729.1704744-1-yeoreum.yun@arm.com/
>>   
>>
>> Signed-off-by: Per Larsen <perlarsen@google.com>
>> ---
>> Changes in v5:
>> - 1/2: do_ffa_direct_msg: validate that sender is HOST_FFA_ID.
>> - Link to v4: https://lore.kernel.org/r/20260109-host-direct-messages-v4-0-95da4221d186@google.com
>>
>> Changes in v4:
>> - 1/2: do_ffa_direct_msg: check that flag in w2 is zero; drop unused vm_handle parameter.
>> - 2/2: ffa_call_supported: simplify logic by reordering cases.
>> -      do_ffa_direct_msg: switch polarity of check and update comment.
>> - Link to v3: https://lore.kernel.org/r/20251119-host-direct-messages-v3-0-c74d04944b26@google.com
>>
>> Changes in v3:
>> - Filter out framework messages as suggested by Will Deacon. Update cover letter accordingly.
>> - Update trailers: Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
>> - Link to v2: https://lore.kernel.org/r/20251030-host-direct-messages-v2-0-9f27cef36730@google.com
>>
>> Changes in v2:
>> - 1/2: Drop support for FFA_ID_GET interface in host handler.
>> - Link to v1: https://lore.kernel.org/r/20251030-host-direct-messages-v1-0-463e57871c8f@google.com
>>
>> ---
>> Per Larsen (1):
>>        KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler
>>
>> Sebastian Ene (1):
>>        KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host handler
>>
>>   arch/arm64/kvm/hyp/nvhe/ffa.c | 39 ++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 38 insertions(+), 1 deletion(-)
>> ---
>> base-commit: 6c790212c588fddeb0d852f2790840753bb604b1
>> change-id: 20251029-host-direct-messages-5201d7f55abd
>>
>> Best regards,
>> -- 
>> Per Larsen <perlarsen@google.com>
>>
>>
> 

