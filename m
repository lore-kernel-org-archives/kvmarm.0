Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDBCC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 01:48:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BD3040DF4;
	Thu,  3 Nov 2022 21:48:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5xdI3I5BSVeP; Thu,  3 Nov 2022 21:48:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CBF240F58;
	Thu,  3 Nov 2022 21:48:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEDCC40D0B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:48:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xkbnkq5klzVv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 21:48:30 -0400 (EDT)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2BE340BED
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:48:29 -0400 (EDT)
Received: by mail-pl1-f172.google.com with SMTP id io19so3593760plb.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 18:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=kI2bio8wmQ0tUqhuEplLTLsBHSGHlrsvdLcA5KYXd1o=;
 b=okJIUsjhGpoSr7ebbtfgAqH0GYDYyL7dOwFsAvIpPQxaUkfj0UP2ubzMSszKzLoSJN
 v6PakLQ+XxWm79MGsDUXql9IQEZxdMTWbKG81FTHJSY9kzQGK+YsR1OvwDbkE09D1VlJ
 4dw4AZi5O9K8lqfRcZFGFnYrPVqUMUcNoMABhjUk0b4JfdXLO0pshLnVS/0Z74PotUp/
 mlKcoIwavTTTQ18DLNZ1g2AW+XuW2afaA+rYfxRqMHWRPYZsUyIvJriVnnZSrEQKK6le
 XI6Un19ShxQI7Ey405lypQalZbGVguAIjN21YMsahXg364hurzORypaF2/fKRwCkV3D2
 vW7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=kI2bio8wmQ0tUqhuEplLTLsBHSGHlrsvdLcA5KYXd1o=;
 b=t9gV82ytHvZGJnTrGgyCfhUixeG4ShPEw3CwdF2+cCduFuJ2iZW38NCNcxLCa4QS2N
 NLXNa+dXw9lMj0m63HqKAEwTXTNEb9Aif4G7y7yQINp9dUqbp6q0p6pkExC1gv5Sme2A
 xqv9Ero+sxIHKxJ+ilj4Xh0utL+cuXAZqkPZn6aa1qVcw64KUP5uiBp2LbHQmuMAxeVp
 bEuk/L2gTz4Bljr2SYrO9D/4eNMW0W+ZY1nVoCD280MZ9EpkNmZhqnlmJq+fiwUje7b6
 Mo8+yvOamXE6frEAc3vx6l/VC02ygnlIa5txELzlaARtc9hu/pzV1foGATixC34JqK69
 +F4w==
X-Gm-Message-State: ACrzQf3pSPHsVrsCpnGAd+ME6PA4dj+1hMVVuhcYq9j6oTYOL39cX2QI
 YBQG08Z6LM05WlJwH4ENa60=
X-Google-Smtp-Source: AMsMyM5IldMoiS3xXBLh2Vh0OIVV2RvQ8KbcaI/UFxFMESQqDNIp1EYyZ1RDviZLejrZpnABGqs7Zg==
X-Received: by 2002:a17:902:f686:b0:187:16a0:fd2b with SMTP id
 l6-20020a170902f68600b0018716a0fd2bmr27368685plg.91.1667526508865; 
 Thu, 03 Nov 2022 18:48:28 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-15.three.co.id.
 [180.214.232.15]) by smtp.gmail.com with ESMTPSA id
 m5-20020a17090b068500b002132f3e71c6sm592915pjz.52.2022.11.03.18.48.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 18:48:28 -0700 (PDT)
Message-ID: <4b2b78c6-9903-1247-9d16-fc6270aa34fc@gmail.com>
Date: Fri, 4 Nov 2022 08:48:21 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] kvm/arm: Fix pvtime documentation
To: Marc Zyngier <maz@kernel.org>
References: <20221103131210.3603385-1-usama.arif@bytedance.com>
 <24d81fe9-7cd1-71eb-8c35-0739f638b3df@gmail.com>
 <86fsf0qc1w.wl-maz@kernel.org>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <86fsf0qc1w.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 Usama Arif <usama.arif@bytedance.com>, fam.zheng@bytedance.com,
 punit.agrawal@bytedance.com, linux@armlinux.org.uk, liangma@liangbit.com,
 steven.price@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 11/3/22 22:42, Marc Zyngier wrote:
> No, this is the correct course of action. There isn't any point in
> having an *unrelated* change in a separate series. This is a
> standalone change, posted as a standalone patch.
> 
>> Please reroll your series [2] with suggestion applied.
> 
> Or not.
> 

You mean the series before this patch have already been applied,
right?

-- 
An old man doll... just what I always wanted! - Clara

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
