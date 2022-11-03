Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB64BC43217
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 16:58:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A60974B638;
	Thu,  3 Nov 2022 12:58:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VHQZHycZWUTE; Thu,  3 Nov 2022 12:58:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22B404B634;
	Thu,  3 Nov 2022 12:58:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E887C4B649
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 09:56:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FKKpd1WXe7+P for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 09:56:32 -0400 (EDT)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0C714B647
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 09:56:32 -0400 (EDT)
Received: by mail-pl1-f182.google.com with SMTP id d20so934692plr.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 06:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=ign6P2397IfFIK8m+Wt90gPlj7W1vvnJv9kawkVb51E=;
 b=HI60mlPg8m4ViBKO0Ko7cuIw5CWkpo8OHY1k84Ajd5UAw+zDBFvmBRD4QqqhAkWjrN
 lNmUO5a0U0c9OsgC2lnIcjG0iXaXQwj1Rjdhdq3CWXM3n20R6+lqm1pCRuvrf7JrLUxY
 ty8hjsDXeWQExDcegMa7fgsxIufgE5FGrldncF2oy/UlSjaix/bMMutFDFEgSiuDnZQO
 0DgEIpgx/XfW3tmQMZa/NUd6jvrjEc1L14YPWBE1ZcnUtLREdMF8hBrirywpkLkCcwtx
 B38Pd5TkQTOi5rbP8ECHzsFmcft2lugGBX2bI3whqkTYnqsAwTPuWQomeqr5pzoOSuec
 9FCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ign6P2397IfFIK8m+Wt90gPlj7W1vvnJv9kawkVb51E=;
 b=j5oy9wx9Cc+IY7DjRV8B6mVuVZRgFDDYs8PJiEfepnwGbk6uIAYE2kRvd1h3+ZsG6h
 0dA5IyA0tjO+apo+MGBIWiI79glZ/ig3KOkDQd+t9U3tERr/t3rTTn5tlTGIR1wRhuRr
 YdWXHFTpYYhfRJib7Hulne7mm0BfxA2RIewfSGhj8AFRWIkxOnG1NCjQ7SBrHyt7WDyq
 irPJLv8hhkvUX8ZjgwdTxLqX56GdjZH4aHkQIQVOqgQFfQctfG3/q+pcHguvUVbRfjW7
 pGJLH96W2/lNVumgXoSKG5C2O0lnkLOrn3idGSXTq5XAVZ2Y1qwnmS7GTECZaJdYthIP
 bPnQ==
X-Gm-Message-State: ACrzQf1OQUHfvSDoHU0aEvvFOMZope+mx9yhLzK1p6IZJ+HX7BPGSC7q
 1f4I1mn14drtebljXhC201k=
X-Google-Smtp-Source: AMsMyM4vIEMLHQ7RSu1HWrdVM/SWZEWnhtUUleBmGwGYurtfIHzBYGeVcxvcjRtNSl0mHNh1iLLDqg==
X-Received: by 2002:a17:90b:1c8d:b0:203:cc25:4eb5 with SMTP id
 oo13-20020a17090b1c8d00b00203cc254eb5mr31460357pjb.132.1667483791949; 
 Thu, 03 Nov 2022 06:56:31 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-12.three.co.id.
 [180.214.232.12]) by smtp.gmail.com with ESMTPSA id
 b6-20020a170903228600b00187033cac81sm689757plh.145.2022.11.03.06.56.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 06:56:31 -0700 (PDT)
Message-ID: <5636b9a1-dbb8-5ab3-8b56-05f6faaccded@gmail.com>
Date: Thu, 3 Nov 2022 20:56:25 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [External] Re: [RFC 1/6] KVM: arm64: Document PV-lock interface
Content-Language: en-US
To: Usama Arif <usama.arif@bytedance.com>
References: <20221102161340.2982090-1-usama.arif@bytedance.com>
 <20221102161340.2982090-2-usama.arif@bytedance.com>
 <Y2M6eU6xW7jjVQNx@debian.me>
 <61800b69-5f6a-d173-fc42-628ee3db15d8@bytedance.com>
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <61800b69-5f6a-d173-fc42-628ee3db15d8@bytedance.com>
X-Mailman-Approved-At: Thu, 03 Nov 2022 12:58:44 -0400
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 fam.zheng@bytedance.com, maz@kernel.org, punit.agrawal@bytedance.com,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 11/3/22 20:15, Usama Arif wrote:
> Hi,
> 
> Thanks for the review. I will include the changes in the next version I send for pvlock. I have sent a patch to fix pvtime here https://lore.kernel.org/all/20221103131210.3603385-1-usama.arif@bytedance.com/.
> 

Please please please *DON'T* top-post; reply inline instead.

-- 
An old man doll... just what I always wanted! - Clara

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
