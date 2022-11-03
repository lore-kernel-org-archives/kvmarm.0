Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DC8C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 16:58:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B549E4B75D;
	Thu,  3 Nov 2022 12:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2YJrbgagMpUr; Thu,  3 Nov 2022 12:58:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0559A4B282;
	Thu,  3 Nov 2022 12:58:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C20004B649
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 09:55:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r7Q69wjl6iZz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 09:55:38 -0400 (EDT)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E7904B647
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 09:55:38 -0400 (EDT)
Received: by mail-pl1-f179.google.com with SMTP id y4so2010311plb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 06:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=2s5CjDAaY+90OmXPKcOa8nR9wP4LZVJneib6FSefkRA=;
 b=MS8/7KEh2OptfpY9W5htuDaz/SSTGx+/DggQYwJvqUceNYlopOwfxW2JcjxE64vnew
 xWEu8xE3P1/zcBWNS0oftj50W/EpNPO4oulM3NodbDZF9gOsSFwko/9dEa9Pg3ggylGD
 YUbtOtBdNW3kyrysWmdapq36lB0UUBHiHjoPslEBvMimAo9BHhSwe6g7GcDKVmfz/cND
 KU6iMth5PLHzvKuChZ6m9xMSj9BtW+oyuWHMhnKortAp9W0O4O/s6Hdt9VC4TsuGSxcR
 HjYax0FMkw+QXQhELnw4bIW1xXbd+hLyHEQp1zQr2WIkqF3ydF22p1CdqDXVS56UtBE4
 9b1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=2s5CjDAaY+90OmXPKcOa8nR9wP4LZVJneib6FSefkRA=;
 b=hq5JEU4jOg0ZbEv7jSluLTMUfT7L0K468603mxUQJ08WbEmB9TdIH9Z96jA8vyepfk
 crnhIwrr1ELkyRMxHnSjClfBtTuZFlmRBfcEkXBgUygfm+bk1R1UbSqQECtOjP+dlYKB
 H7wsGYfDu+kFu3A/TLl7rMTGW+gxz0Dfh37KIJ2EzjBprqeUHI4NP95+bwGASZ9sbn20
 ScaT0bi/SoCl7hp606NDPFi88VdXrw3afXP0EbGZMw32O4pk0kxagzIA0xxDmjBVE8Nb
 LJsOJ/ml5WqyUngLmakzuVlJlUbsHayhlQUhIZxhEu9RfuPjhLCfCzVbeBNCxpSwrVcu
 8UXg==
X-Gm-Message-State: ACrzQf2ozZpi2D5510FDRfwQt+I8cPIyBqCLA1PQirLKFO+ckDhxTUrV
 jAFOy71/NtC49Tyqd5NAkcc=
X-Google-Smtp-Source: AMsMyM7jLL4puj7iVEGlPCsNA/AfQoaXr2wHeqikdv+S7v8dxTEzekFXavxGHIU/DhFhAmAr4eRXNA==
X-Received: by 2002:a17:902:aa0b:b0:187:34e8:7285 with SMTP id
 be11-20020a170902aa0b00b0018734e87285mr15105196plb.156.1667483737439; 
 Thu, 03 Nov 2022 06:55:37 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-12.three.co.id.
 [180.214.232.12]) by smtp.gmail.com with ESMTPSA id
 u9-20020a170902714900b00185480a85f1sm608717plm.285.2022.11.03.06.55.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 06:55:37 -0700 (PDT)
Message-ID: <24d81fe9-7cd1-71eb-8c35-0739f638b3df@gmail.com>
Date: Thu, 3 Nov 2022 20:55:29 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] kvm/arm: Fix pvtime documentation
To: Usama Arif <usama.arif@bytedance.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
 yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com
References: <20221103131210.3603385-1-usama.arif@bytedance.com>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221103131210.3603385-1-usama.arif@bytedance.com>
X-Mailman-Approved-At: Thu, 03 Nov 2022 12:58:44 -0400
Cc: punit.agrawal@bytedance.com, fam.zheng@bytedance.com, liangma@liangbit.com
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 11/3/22 20:12, Usama Arif wrote:
> This includes table format and using reST labels for
> cross-referencing to vcpu.rst.
> 
> Suggested-by:  Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>

This is not what people normally do when given suggestion diff like
what I sent before [1]. Instead, they just apply and squash the
suggestion (while also applying requested changes from reviewers).

Please reroll your series [2] with suggestion applied.

Thanks.

[1]: https://lore.kernel.org/linux-doc/Y2M6eU6xW7jjVQNx@debian.me/
[2]: https://lore.kernel.org/linux-doc/20221102161340.2982090-1-usama.arif@bytedance.com/

-- 
An old man doll... just what I always wanted! - Clara

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
