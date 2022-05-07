Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C486C433FE
	for <kvmarm@archiver.kernel.org>; Sat,  7 May 2022 09:14:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBD9749B0A;
	Sat,  7 May 2022 05:14:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iwomDPIVncrC; Sat,  7 May 2022 05:14:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C74974B2F6;
	Sat,  7 May 2022 05:14:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20AE54B1F2
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 May 2022 03:47:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fpk9UL6rpd9E for <kvmarm@lists.cs.columbia.edu>;
 Sat,  7 May 2022 03:47:06 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05ABC4B1CA
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 May 2022 03:47:05 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id
 a15-20020a17090ad80f00b001dc2e23ad84so12728130pjv.4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 07 May 2022 00:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=nB3DYjKLYyYWfNZgZK9W2AdXK4sBfxt6y19hg7k0bWQ=;
 b=lLgerdUrwFgqY5KSmEGF55k1CT5IEVnAK48E+XmSLQo1aE2sZEi5rTZUO8FXExriiU
 LWJbsc9LYYcL+ngR+XKA2yuK1yoA7/9Jsc3HjPu5gDMSi5vJyclvLe0PZG6p6Lg4TbRG
 A+SpJsH65XtEoYe/YTzOz+DjUUX58V6iCqTR/0aFM78NdQ08CxV+DDki3lnUg/GK1gdf
 ZgZAc/FbBfNH5633KlK3kGu9fGMRVzLKdML2vx7VSjnU/jqmTv2ZA3v0L1Y7hI/dg1HM
 AglOAn7O4tq3Y0/ygxZtwz5MU3raEVnhW4fgU9y2pLwl2HnlCLeZjudZcxH2FLsgoqp9
 76WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=nB3DYjKLYyYWfNZgZK9W2AdXK4sBfxt6y19hg7k0bWQ=;
 b=l7+E73LlW+xg8sn8+RIJ24ctjVLOrrVt/QdSdt040sHhMV4BNLDcJZ3kSWrUbusV8o
 P25bk2Ogm1tqI4Dx0hNnynUVeVgP9i7jVJfqdcDAP48gR/opYGp7W6qu+ei/29onzM7G
 Km0lHYWYf7PoXNWAN9rzz0Lyad902jblbFtpAbUIhnEums/va8vOw81+D7ko9OtyaLOB
 6AfXZ42Q0IX2/XfzOdiNoLctE8A44VetEJG/YZIao7ia+sFfHvJP6zrnrwAgOQPpSrqa
 o+RPvfmmYssTg3K60bNYRSJT5rkGOQEuQ/9qBsK7YdSMt0ui2dNctU3sw3DQ3ZxUZ6YZ
 SKVQ==
X-Gm-Message-State: AOAM533837VE4Ai77XJu/xfye7RvTCqTamWj8M6cPLiUMcsAI/euMW+t
 AriLpQURMh852p7M7M5jveM=
X-Google-Smtp-Source: ABdhPJzoUA93BCaNMvFRM7dpjETpDp+8EsOq+q1oC8wEjIZ1U0lUhRyo2h6oynP6i2Cal4U4jL+7tg==
X-Received: by 2002:a17:902:a712:b0:158:e577:f82 with SMTP id
 w18-20020a170902a71200b00158e5770f82mr7528008plq.146.1651909625068; 
 Sat, 07 May 2022 00:47:05 -0700 (PDT)
Received: from [30.22.112.212] ([205.204.117.91])
 by smtp.gmail.com with ESMTPSA id
 oo10-20020a17090b1c8a00b001d0ec9c93fesm4914540pjb.12.2022.05.07.00.47.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 07 May 2022 00:47:04 -0700 (PDT)
Message-ID: <d06c57fb-5c54-e496-7c0b-f5a57912f082@gmail.com>
Date: Sat, 7 May 2022 15:46:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v4 02/20] KVM: x86/mmu: Use a bool for direct
Content-Language: en-US
To: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-3-dmatlack@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
In-Reply-To: <20220422210546.458943-3-dmatlack@google.com>
X-Mailman-Approved-At: Sat, 07 May 2022 05:14:38 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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


On 2022/4/23 05:05, David Matlack wrote:
> The parameter "direct" can either be true or false, and all of the
> callers pass in a bool variable or true/false literal, so just use the
> type bool.
>
> No functional change intended.
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---


Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
