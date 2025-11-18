Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BA716D9C2
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 01:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763430359; cv=none; b=NLD0JVoKnntQW1FK7jJbahHiTDmt96307baerU2pgQh9awtmi9M0Si0uneq6QcJmTX3IzsYC0vbhMNVCSb07ayJ1kEPXjVwMFU0jcctehDcR+l8X0Shg1sSiThY/irHDJMETXNPvh5zy8pbyDGbzAZcRGaQclo3SCMVkV6e6LF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763430359; c=relaxed/simple;
	bh=rATIvjZWl17/yzOZ5j8ONKzwEletAb128KFIym5/z2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ExMNALyUmwb/aS7DssCDTgT3lIZDkTH/6jyzZyIvZiDcszMCFAHHlEz1xKgvYeR+gUh0R8Y+WH6Ki3n1irsDxPEZWBtK967i/sZx22AQ7k7JP5l5/UezchSI0SQmXRXVgsEoqAOa4vlMErYvrkXZjiFg+1eAjD9Yszy6pdUc3Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eurWVBCU; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eurWVBCU"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7aab7623f42so5857891b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 17:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763430357; x=1764035157; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9LVu1ftHSweMGGMS0wtdGEkaqFzhCbvStNQPyLLvshM=;
        b=eurWVBCUpu4mZDD3HXGwJ132gez4xfyRkBPAOqgN7KRBBSX9Q6gzhkCziJekBeQTV3
         K0+fUN2WBrPxuezZyDvE/eZv1hDYRaek0QAlc7QGpKvZPopjP+HmhGijo1hg34EwgmUV
         R1q4lGMUcwXremx/eg4qrhU+l3BEd+2soS5DlSDYOw3fGFRYSuCs6FRTaubvnYobxzyP
         gAKyMGmXaPdHURnF1GnvreYN6kjVkntwsRhdAXEa64fgdYrCQ8DSEYT5VGzpnBs/utW2
         SQFnRCUVT8YYDL/WuArcGfsl5X4y2XKG0HsYq5kJlqjZZN6oIfu3ujY3t4tR8CD8qctY
         G+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763430357; x=1764035157;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9LVu1ftHSweMGGMS0wtdGEkaqFzhCbvStNQPyLLvshM=;
        b=BNA6DjPImt8co3+Hlu8dgoTA6xPQfT11yKiw2lPGJ4bw5KwElJ6Ofa5zAMB56rEZ9U
         CXWg7m9wo5qgFnkpk9sIQw6hIZK+Rcn4yC3CQyY0zCgzHUwGNGy3zWm3fSacTr86KVC9
         dNDwZkRCkjDko5d1UdHl+gFdTagwTEjL8gdoc3C9hD3rZOgLY//jkLDZnGqfoo1obckb
         WE9tXi84QXKUJlyVeOI7B/HONCiVlaOh03TBDs/9OCmxTmGySZWi7103Ok1xATfmgl8q
         1HSTb4jK5XfQ2CPaWfq0N5G2Fb1UqnbcBZvUR5TUQLgjoXYfhxYEbO2EAOl8wezonivT
         mG9A==
X-Forwarded-Encrypted: i=1; AJvYcCXD2MShP21zSBcWX90Pdc2CJovOIkX1xg/7CPHJTVr8dRA6nQD7jfEck/b2kI0RPehBmG0/D9Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzm45Kh4EX2T0Bq8ExiuQAc+Yke64mFsEP/HGf+cSK7zroNKDzT
	oKefjjMBJlsjTE/jiegfQc+4T6/uUvWg6U1KryOhzzTEt/zDEy9VIK3i
X-Gm-Gg: ASbGncsm7DC3XTnliX0SyEzZxqojg1Nj6wKZ3arQ7CQDb+2d8shHEVPDQo8puccCRNA
	hUxCWQfDpVUpIKGNx+Tt/ZdnxAus93SIGoJLTFNermTB/uY5vYABkpnk55C8RZVHXzD7K6KOhfR
	fZLAc5jgUKSzOwP94aIixWy5GmDeXDf+u/k7lPj5zcv562ZW4bVmAr8MBUElVGeubEiu01+veQ4
	aFBaExhKFyR/aoLJ4WS2vVNfDrKf5oCJfmLh944By+acjjrVbgFi++Pjtu1+EvnYRa5nNS3OV0s
	sLJrMPIbW2NBBZJgYKPsh4QAuzrtRix6Cs771vFkoPq5SAfgNipkihFGWRfAyWezLYfj71NXa7q
	en+jkMSHWOWP8FbO8UbYqTyfHOPEdO005b8D1F5f/GegBamwYVBx0vzmDRC89KyllABs9f50Gq4
	F0TQcqhFbUOj74TN6KWhhJ
X-Google-Smtp-Source: AGHT+IG/PNQV7yS4/dOlu2YCel/annKvAJBo90V1Nz+6LPzZU6gOPlYVZPEcln+UbOpMuRAShHAXFA==
X-Received: by 2002:a05:6a21:3397:b0:35d:cc9a:8bbb with SMTP id adf61e73a8af0-35dcc9a8d3emr9776085637.47.1763430357500;
        Mon, 17 Nov 2025 17:45:57 -0800 (PST)
Received: from [192.168.1.2] ([122.177.125.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc3761d0109sm13385461a12.27.2025.11.17.17.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 17:45:57 -0800 (PST)
Message-ID: <0f6fe0c6-7c11-4f16-bed4-db4de675b002@gmail.com>
Date: Tue, 18 Nov 2025 07:15:50 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] arm64: errata: Work around AmpereOne's erratum
 AC04_CPU_23
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
 <456bba04-07b7-4c27-96fc-9bf226b12fd9@gmail.com>
 <86bjl0o9yd.fsf@scott-ph-mail.amperecomputing.com>
Content-Language: en-US
From: Jaikiran Pai <jai.forums2013@gmail.com>
In-Reply-To: <86bjl0o9yd.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 17/11/25 10:47 pm, D Scott Phillips wrote:
> Jaikiran Pai <jai.forums2013@gmail.com> writes:
>
>> Hello Scott,
>>
>> On 14/05/25 12:15 am, D Scott Phillips wrote:
>>> On AmpereOne AC04, updates to HCR_EL2 can rarely corrupt simultaneous
>>> translations for data addresses initiated by load/store instructions.
>>> Only instruction initiated translations are vulnerable, not translations
>>> from prefetches for example. A DSB before the store to HCR_EL2 is
>>> sufficient to prevent older instructions from hitting the window for
>>> corruption, and an ISB after is sufficient to prevent younger
>>> instructions from hitting the window for corruption.
>> I see that this patch enables the workaround only for AmpereOne AC04
>> systems. Do you happen to know if the underlying issue for which this
>> patch was introduced, impacts (or can impact) AmpereOne AC03 systems too:
> Hi Jaikiran, this issue impacts ac04 only, it is not present on ac03.


Thank you Scott for the quick confirmation.

We have been investigating an issue on AC03 (running Oracle Linux as a 
VM) where some memory writes (stores) are lost especially when the OS 
appears to have accumulated high buf/cache usage (monitored through free 
-h). That investigation, backed by a trivial C reproducer, is still 
ongoing and we are trying to understand what could be causing it. The 
issue description here made us curious whether it's the same issue we 
are running into and since this patch wasn't applied on AC03, we decided 
to check once.

While at it, if you have any inputs (tools/commands) that you typically 
use to narrow down such issues, I would be happy to experiment with if 
feasible. Right now we are focusing on the kernel itself and checking 
which specific kernel versions can reproduce it. We have been able to 
reproduce it consistently on 5.15.x and 5.16.x and we plan to try it 
with other kernel versions all the way upto 6.12. That should tell us if 
the issue we are encountering has already been addressed in any specific 
kernel version.

Given that you noted this patch isn't relevant for AC03, I don't plan to 
further reply-all to this PATCH discussion, but if you would like me to 
keep you updated with this investigation (I would love to get some 
inputs and provide updates as we go along) then please let me know and I 
will communicate with you over your email (or any other relevant forum 
you suggest).

Thank you again for the quick response.

-Jaikiran

