Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F142225779
	for <kvmarm@lists.linux.dev>; Sun, 16 Nov 2025 11:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763290872; cv=none; b=cxQJisz7wxQg1J7GL5AU5Ni++JxjPE2ofFOCNDf58yizTeDoV0oEyhG5Ax2rBoNJIlLBslOPNsMDWOBQJGUu47WtM2GMDd3Rd0ZabHGQA2KeikgFIOZWyRdtHbIBV+wwW4bs78cLTGxjHpr+oEULBjtIVzGG/eJw4RV8zlefR7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763290872; c=relaxed/simple;
	bh=9dtn3zhF4pNp0HRjuahTXbNpgIfE2IdQgne03qczeWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oGUqD3/dj2qZfPufviZul2zN7tb8UvQ19ALde/UjZ6JO8g5lwWeQXcDg5qBBi5iPAV5dieeVK+28KihxXiDZF7nFrH05zsE8SHfCdB2azRjmZwOtJMtWgEAGOtogmjg1tWd8J5j/ap3+RijzpMYbAef4QrrrGxwf9CwofJ7sbL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MsBW3ler; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MsBW3ler"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2984dfae043so30426645ad.0
        for <kvmarm@lists.linux.dev>; Sun, 16 Nov 2025 03:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763290871; x=1763895671; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uRv0x/mbD31ezymVtnCbBZQgh6UPxXX7neGyCw/P4/k=;
        b=MsBW3lerCMWV0nROr6dWgsoxzkzBndKhJUxbB1uDmlYxbldGYAYsf0LrzJvidp9VeK
         ut6jpYyySuiEgVMibdWJQ66rf6O2LHPvowK1ocIQW/XeDwf07VWR+9vvDtayvbHzPSe5
         9l3xo5VVsNkyv9vVBuVrDkVLv7SJ5rZidiHourAvvRLWDlyQI8jZbph79Ne1R2pWt92f
         OhpbqbAah0/76GEj/Pb/8+umkGpJr4J4KeosSig4RiN0DnQCcJknFG1kPp3XiF8LT9Vm
         9jDONO+lLYLwhaKmOscGjM7NDMO3fh6wEvUTytwGejGw7gTkzKe9p6nDV2twIPPWBD8G
         ZyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763290871; x=1763895671;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uRv0x/mbD31ezymVtnCbBZQgh6UPxXX7neGyCw/P4/k=;
        b=X6PlAlGDu05cP1iZeFJFC3dl0XGwUCUyRy+cZQbA0emGVU9GPz29si3d7BJShv2P/+
         bCFpBaIzTYZpyoYi5BERs9yLGRUjlHCqL06w7nlUcNrjtIBTr5bu++Hg1jTRmEbm05D0
         OscZXeiDKtlwUfcYJbt01Xa3nBfmNiDY8RyPHrZidqhK1P7SgGqWRWVEMjbU7z+fSwU+
         aIqFUy8YKrZlWO6gNUrexdFSYvFpWYqOSHkt/sNnMOKov/EcmplG+XSHUebwVGh42sLw
         sfF69ESkXhyVRigQahPe2CKfDUm1Ij9QYQThFKrBpvwYoQBpL8o0LRha2a3WC6cdH00B
         0ayQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkoBSljhPOZpvDmUF7PKRBuTY8rf+DE1qwNmTgsFVuIFlEU/2ILQdi2rtf1C2/1z3BnTG9O8w=@lists.linux.dev
X-Gm-Message-State: AOJu0YwN8TxVZ7lsmDlC+obDGaFkg7SIZGOs7kDhl+mSY3FDL7fdoUyN
	X14G157qaVsKHhh0tcmMLshz1LMSfNkYqyyjhVBfTarDadLsEYnEJTIL
X-Gm-Gg: ASbGnctVobl7Z3dCjCXOD8zQ4S5BrwaLtMilSiyfr1ymv6ScRs3C0B5i4AsKOyrWIbq
	1kFmkvnhpLn0IkhMghrxql29yrVQk6z7mzH16NImK3CxGY/znxGCZdbNPyhodCNc4vVW5ICy5dI
	xKJ0h0IVqwnAp3tc5JgkoBNVHeeDhNosugFZW5vqJClkV/fBzpxKSMBNil91a9iFnF1EmzWErzx
	K2QIRPAiUgkk9fKNikADqjfHwCGE0lFFqDLYEXk+KPBgDissrtcVThzbV57W7+ZzrKDjSxWaavA
	zYspp7xhKD4CFinJByVmh9ec+GGnRMz7wp2pjQt/ntIa3rR7vmjjsU3SgKgihcGtT96pc6W/0UZ
	l88bezrx9LIQCHnWPAhCK2kUNRg40WSHVL/VAut2e71GeLaI7z2mKdv2VEoWmNtRZztRX9+x89O
	EfjW+FRTtBDpSjs9ZZpes/r6DOkq0lxwQ=
X-Google-Smtp-Source: AGHT+IGwXKVh3JoXqwDVnEA8t27M4iTiBciJSt6uHCX3HWuQiqFLuOCSzc0jDkXVTsETAHbo8/8pyQ==
X-Received: by 2002:a17:902:c945:b0:295:5da6:6014 with SMTP id d9443c01a7336-2986a6d07f2mr112271255ad.22.1763290870736;
        Sun, 16 Nov 2025 03:01:10 -0800 (PST)
Received: from [192.168.1.2] ([122.171.252.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc375081023sm9414287a12.21.2025.11.16.03.01.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Nov 2025 03:01:10 -0800 (PST)
Message-ID: <456bba04-07b7-4c27-96fc-9bf226b12fd9@gmail.com>
Date: Sun, 16 Nov 2025 16:31:04 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] arm64: errata: Work around AmpereOne's erratum
 AC04_CPU_23
Content-Language: en-US
To: D Scott Phillips <scott@os.amperecomputing.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Clark <james.clark@linaro.org>, James Morse <james.morse@arm.com>,
 Joey Gouly <joey.gouly@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 "Rob Herring (Arm)" <robh@kernel.org>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Shiqi Liu <shiqiliu@hust.edu.cn>, Will Deacon <will@kernel.org>,
 Yicong Yang <yangyicong@hisilicon.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250513184514.2678288-1-scott@os.amperecomputing.com>
From: Jaikiran Pai <jai.forums2013@gmail.com>
In-Reply-To: <20250513184514.2678288-1-scott@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello Scott,

On 14/05/25 12:15 am, D Scott Phillips wrote:
> On AmpereOne AC04, updates to HCR_EL2 can rarely corrupt simultaneous
> translations for data addresses initiated by load/store instructions.
> Only instruction initiated translations are vulnerable, not translations
> from prefetches for example. A DSB before the store to HCR_EL2 is
> sufficient to prevent older instructions from hitting the window for
> corruption, and an ISB after is sufficient to prevent younger
> instructions from hitting the window for corruption.

I see that this patch enables the workaround only for AmpereOne AC04 
systems. Do you happen to know if the underlying issue for which this 
patch was introduced, impacts (or can impact) AmpereOne AC03 systems too:

CPU implementer    : 0xc0
CPU architecture: 8
CPU variant    : 0x0
CPU part    : 0xac3
CPU revision    : 1

-Jaikiran

