Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84A6202F67
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 11:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738582129; cv=none; b=K7P6dkISUx3WUyXReVCD6m4hmWdyKi2ALStoWXenUU7zQQcUMZ8rg6OfB8nnMwd+fj61LKC1pqWi2eO1CJ236vDn1HlkiHPt9zmoMuSPTHgeus0eW1OeBF1y2LdnEse4Z22hDUx5kRq8XhNDYXMKVDnqgx+Un1G0F5dsc901cTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738582129; c=relaxed/simple;
	bh=/K5N3VJS4zbstl2ynRET37Jk72zu8/TikndeVhgoKOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FwFa9psFlwO2SnitG9QedMJ4YcoM6Dt8CsdAwPwNQQq9TkKUj2QeV0qBPWu/2bUqiW2pF1iM3McyI4fc/g1NpDOSkdwry8z4K/MQUZZOiQr29KYJi5nJGwFDI3GMutGxl2SQu639+DN4MlkzLvLIX7uoExg2cApcHn1+SrG77LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c4lssNts; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c4lssNts"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43626213fffso32611915e9.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Feb 2025 03:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738582126; x=1739186926; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=03gUTOPYMxUMcZhmVIjGAOR45IAzZBtmIXb7cPKWi+Y=;
        b=c4lssNts1QQGLOJM0qMmZonFfCWoSoizPs/7RIut8z7l7fQc3+obd3DYqw05L4nrMT
         igCDnpJJk/lYcR5sRsDWClMI9fR3hLzu6fS7ALEeAM1O37UshZZ8mZyxA1jX+K5icylu
         VXeh381X3QTOxTqH9UPe4dz7VverjSAK7ljGjCBs7GwlSJdkOR41rRaTuHwcDC7gI/5z
         a7rPy+/mgtATrE+DF4bNIPLmZaoe/oa34IckepTUbcVwPaFcCCczviPzbtTiKXDlKM0+
         sWvfdmFrHQ0kOe7t7Idp4U8IRQcO9yiUPSQhazYuIKCAF3oKZbjRUIWJOz23xb3yCNqU
         0b7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738582126; x=1739186926;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=03gUTOPYMxUMcZhmVIjGAOR45IAzZBtmIXb7cPKWi+Y=;
        b=DksCLwrmwDIK/ITbPSCScvnFM44y4poja0SJOvpcuIAYvh4XLjbGNUmwk/w8AWK/yO
         w/Ge1vbouvaiXFbktTYeRfx7+hL+V8Up/KLVT5QNHJEcNb0vVjo8aqL+ymLGUV2wNoEm
         Hcdj3R95W7Iif8yd0s20k+arbdoCfCIBDEx58ILR7AQP/b+BXgygrJpRevF4JnFZqC/j
         9G9EdpOKjVj4LJ5orxC1FK2MyFEyRNMxBcx6b5OA+qoK2M5UVYNDeGyLSFSqq6F+7ciH
         AkT0K105BYBh4LKnmmj1096VhSMcV8lTK2fdQOQKswwYWJnye0G2VODqEiU/20C2N2NK
         WRAA==
X-Forwarded-Encrypted: i=1; AJvYcCVfAWg2Wnm2kVzA2BrBKf80AKYfwqmdp/eDA4eW7bhA3Hydzp3WV/uUJ7XkSZ9TD/gHthXDp+g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5HMXIH/PQtdXKCMai3ADgJatsojnTVMlhRxLNHsYti1P21yea
	5Knf7PKbQOIqB5zY5cNAwAYBJI+zNvb28zkUbUFoP6R8MC2VoPkTdvhaQ0PxvtQ=
X-Gm-Gg: ASbGncvxGCXvZLdwp//FYAWWCO1s1b9w/ezqBgClVAt1e52J9vF/DX8o1anbysr6rlA
	ezaCogyhe/nc6qm09qxTOVRhI9gfNUKBUD80ZzhGNQl4pryfdFX+tRyHZny/FIHMCsHY39ogMYq
	8YF2ocKKBekUuvFCVmLq91Qn7VWUtZRpFXZh81vi0IOBBxNg3V66r9heT407Prg84XCjZzOHjDv
	u3s3JMAwGRNYF5PkkSwovzDWIFGt2rO3zEBHnmEhCLr5K8A8L7SUxyR0z2Ki//hjt5+4Kg+hjKz
	h6ecoCc7rkhv5CVcBMJM+U6Idw==
X-Google-Smtp-Source: AGHT+IGzdk+Sqe63Mv9Bm/BPmdRTVGijSJCqG2+aE5exrBjEFpqR+uegx/hrDwI77yjfzrbFRZf6LQ==
X-Received: by 2002:a05:600c:1e08:b0:438:e521:1a4d with SMTP id 5b1f17b1804b1-438e52122eamr113014465e9.5.1738582126037;
        Mon, 03 Feb 2025 03:28:46 -0800 (PST)
Received: from [192.168.68.163] ([145.224.90.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc81911sm185351695e9.38.2025.02.03.03.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 03:28:45 -0800 (PST)
Message-ID: <4aaaa1de-ec5d-433b-96c2-3b28a8cffe7e@linaro.org>
Date: Mon, 3 Feb 2025 11:28:44 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 10/11] KVM: arm64: nvhe: Disable branch generation in
 nVHE guests
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-10-1c1300802385@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250202-arm-brbe-v19-v19-10-1c1300802385@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 03/02/2025 12:43 am, Rob Herring (Arm) wrote:
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> While BRBE can record branches within guests, the host recording
> branches in guests is not supported by perf. Therefore, BRBE needs to be
> disabled on guest entry and restored on exit.

I don't think this is strictly true. You only need a Perf session in the 
guest to records sideband events. That allows you to make sense of the 
userspace addresses, but by then you might as well record BRBE in the 
guest in the first place. See [1] for an example.

With kernel addresses it might be even easier as all you need is 
--guestvmlinux, --guestkallsyms etc and no sideband events.

[1]: 
https://lore.kernel.org/all/20220711093218.10967-25-adrian.hunter@intel.com/

> 
> For nVHE, this requires explicit handling for guests. Before
> entering a guest, save the BRBE state and disable the it. When
> returning to the host, restore the state.
> 
> For VHE, it is not necessary. We initialize
> BRBCR_EL1.{E1BRE,E0BRE}=={0,0} at boot time, and HCR_EL2.TGE==1 while
> running in the host. We configure BRBCR_EL2.{E2BRE,E0HBRE} to enable
> branch recording in the host. When entering the guest, we set
> HCR_EL2.TGE==0 which means BRBCR_EL1 is used instead of BRBCR_EL2.
> Consequently for VHE, BRBE recording is disabled at EL1 and EL0 when
> running a guest.
> 
> Should recording in guests (by the host) ever be desired, the perf ABI
> will need to be extended to distinguish guest addresses (struct
> perf_branch_entry.priv) for starters. 

There's already this which would be enough (if every entry in the branch 
buffer matches it):

   sample->cpumode == PERF_RECORD_MISC_GUEST_KERNEL
   sample->cpumode == PERF_RECORD_MISC_GUEST_USER

But I don't think we need all the extra complexity. Just let the guest 
use all of BRBE and then there isn't really a use case that's not 
supported. I assume a lot of these workflows were added for trace 
because it's not supported in guests, but I don't think that applies to 
BRBE so we can skip them and go straight to full BRBE in guest support. 
As a later change obviously, these comments are more about the commit 
message.

James

