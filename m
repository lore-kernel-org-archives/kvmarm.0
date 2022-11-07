Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62410C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 18:08:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA4904B8B3;
	Mon,  7 Nov 2022 13:08:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vh2Uva-wC+Q3; Mon,  7 Nov 2022 13:08:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A2C44B877;
	Mon,  7 Nov 2022 13:08:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDE974B866
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 13:08:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id adkOCtYIlHJN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 13:08:48 -0500 (EST)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E5AE4B85E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 13:08:48 -0500 (EST)
Received: by mail-wm1-f47.google.com with SMTP id
 187-20020a1c02c4000000b003cf9c3f3b80so2674431wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 10:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=Iyemd4HvK+DGYoF1NoBJb/8v7rlPpLIo+qNtTJ7A0Ww=;
 b=BZYjDsn/5DylRVSBVwNfJ49v8b0I/sVskWuhe3YR71vQtj5NDJzzp3iI6/QEi20uYL
 FfZ9yZ5wd4+4/poDHpX42prieA/ABkyC9CMQCh8Kecv0rC8XTeq3E1iJZPH8TjytnPdm
 2KlApBArF0MjvFn6tfAVN1Px/03htSrzGTSD/rZimuCZerxfr5UZaOjlok3me3++Tac1
 K28jTJyoLWZDWNcVKYmtEPRMBcnpqfotxiVKufkl0BqNoMln9J5KDjPL/ZHqGFGRkhzA
 cC0F9ou2jlvBM4qjHfFw/yQsFEv8QxoEYMTpdr5v19/00tG9yoLn+OiUMjV1ySZYM1SP
 3mjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Iyemd4HvK+DGYoF1NoBJb/8v7rlPpLIo+qNtTJ7A0Ww=;
 b=KXiGU8s7yTFNRAKGQMd5c3/7g5wBLmVSDlPaJQKh7gcvxyT3Hza7qWRgM05zPDbE49
 43LEL+L1hqfuVebH+GpfNtEMR6PBqcpKA3B+RRKhvpToeE443lUDOJqtDsHwGob5XyAP
 MfuwlSD+GZhlfkDAw53eatmgA51XUBc1IO61W/Ynt50+TjcNQGb8lNxmKfji3HufuL0A
 14nDpaawKB0ZW//WyvUccGAk5q7johc9BSLVzxluUNrwbREVJEDHq4OAs0+1QUFuQD0C
 x2kyg//Mlrd+IvQJCpsDLB2F90b1P/2djsB+P9hilH9v01XOmR0QIXuoFucm2GJ+tVdD
 CCpA==
X-Gm-Message-State: ACrzQf1xbBAmpuNNTlv3lByvr57Fu2qUN8OsBPyUKycL1BoBYWNDXR01
 GDxL8YZI/ZBO3gY/0gs09dxbEg==
X-Google-Smtp-Source: AMsMyM5Hh1s5ndsMCASrivT9+H550/0X3uXptpk3+2XbPJSWiaha1BuW5q/Uu0FobiOLXQQyw1iRlA==
X-Received: by 2002:a05:600c:1609:b0:3cf:4dc4:5a99 with SMTP id
 m9-20020a05600c160900b003cf4dc45a99mr34442575wmn.67.1667844527658; 
 Mon, 07 Nov 2022 10:08:47 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b4d7:0:ebf7:de38:f6bc:8fe8?
 ([2a02:6b6a:b4d7:0:ebf7:de38:f6bc:8fe8])
 by smtp.gmail.com with ESMTPSA id
 l21-20020a05600c4f1500b003b4fdbb6319sm13186914wmq.21.2022.11.07.10.08.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Nov 2022 10:08:46 -0800 (PST)
Message-ID: <71a41442-b1eb-d02e-53fe-c35dbcfc8416@bytedance.com>
Date: Mon, 7 Nov 2022 18:08:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [v2 2/6] KVM: arm64: Add SMCCC paravirtualised lock calls
Content-Language: en-US
To: Punit Agrawal <punit.agrawal@bytedance.com>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <20221104062105.4119003-3-usama.arif@bytedance.com> <87cz9y3avq.fsf@stealth>
From: Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <87cz9y3avq.fsf@stealth>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 fam.zheng@bytedance.com, bagasdotme@gmail.com, maz@kernel.org,
 linux@armlinux.org.uk, liangma@liangbit.com, steven.price@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 07/11/2022 17:58, Punit Agrawal wrote:
> Usama Arif <usama.arif@bytedance.com> writes:
> 
>> Add a new SMCCC compatible hypercalls for PV lock features:
>>    ARM_SMCCC_KVM_FUNC_PV_LOCK:   0xC6000002
>>
>> Also add the header file which defines the ABI for the paravirtualized
>> lock features we're about to add.
>>
>> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
>> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
>> ---
>>   arch/arm64/include/asm/pvlock-abi.h | 17 +++++++++++++++++
>>   include/linux/arm-smccc.h           |  8 ++++++++
>>   tools/include/linux/arm-smccc.h     |  8 ++++++++
>>   3 files changed, 33 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/pvlock-abi.h
>>
>> diff --git a/arch/arm64/include/asm/pvlock-abi.h b/arch/arm64/include/asm/pvlock-abi.h
>> new file mode 100644
>> index 000000000000..3f4574071679
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/pvlock-abi.h
>> @@ -0,0 +1,17 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright(c) 2019 Huawei Technologies Co., Ltd
>> + * Author: Zengruan Ye <yezengruan@huawei.com>
>> + *         Usama Arif <usama.arif@bytedance.com>
>> + */
>> +
>> +#ifndef __ASM_PVLOCK_ABI_H
>> +#define __ASM_PVLOCK_ABI_H
>> +
>> +struct pvlock_vcpu_state {
>> +	__le64 preempted;
>> +	/* Structure must be 64 byte aligned, pad to that size */
>> +	u8 padding[56];
>> +} __packed;
> 
> For structure alignment, I'd have expected to see the use of "aligned"
> attribute. Is there any benefit in using padding to achieve alignment?
> 
Just made it consistent with pvclock-abi.h. If its more appropriate, can 
change to aligned in next patchset:

diff --git a/arch/arm64/include/asm/pvlock-abi.h 
b/arch/arm64/include/asm/pvlock-abi.h
index 3f4574071679..bacec4cb927a 100644
--- a/arch/arm64/include/asm/pvlock-abi.h
+++ b/arch/arm64/include/asm/pvlock-abi.h
@@ -11,7 +11,6 @@
  struct pvlock_vcpu_state {
         __le64 preempted;
         /* Structure must be 64 byte aligned, pad to that size */
-       u8 padding[56];
-} __packed;
+} __attribute__((aligned(64)));


> [...]
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
