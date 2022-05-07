Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19970C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  7 May 2022 09:14:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5FA24B2B4;
	Sat,  7 May 2022 05:14:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d-VRr+RdFxLK; Sat,  7 May 2022 05:14:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A77CC4B2F2;
	Sat,  7 May 2022 05:14:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1E794B23B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 May 2022 03:46:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QOueILCCyVO9 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  7 May 2022 03:46:26 -0400 (EDT)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3BC24B232
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 May 2022 03:46:26 -0400 (EDT)
Received: by mail-pg1-f175.google.com with SMTP id a191so7907800pge.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 07 May 2022 00:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=HoNZSyMsFh0YGr6XMn2S1QvK2RQy1yb4yDnc0NWz6oc=;
 b=Ebb7mWsRqf/tGM07zO/HW9zZ5uDpqZ7FmKRVWRwJ5I9vjjFF1+vYkK6F4/1cru8rq7
 OjRLKU4N3l9l6c5pTvoUEbItc/bQc6dGsj8uGOJAqCKhQ8KstUnZU55m0c20a7JRFn9y
 Y15yeYCujfL7rKv0Dpckke6FJzfSrhst7NiQpAKOsAD1rHQhvCGYgItqP9r+iKtnCzbC
 EHSOS18gj2ZZwOxGC2LR2VcyNibP3U8o8yYdyN+uPA0o9UfdXr+zLOcUPzVstYe1BBXZ
 zmk7NtWev27+5si9mgOUUMT/1xO1XsYg5DVZHVUSZ2pNAqTNHSOeMttvKZv4e9UzP3eX
 4ssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=HoNZSyMsFh0YGr6XMn2S1QvK2RQy1yb4yDnc0NWz6oc=;
 b=1DfEkutZWP9AEkcE1v29AgNaVILr12Pa1/c15haJRz6anRX8rlf7oPRm0a5PC4tRSR
 K4KLqOj6+5MMyhd0eCuODE836oXBxs1oT+fOWuBy3Zp98WZ4jG0G1j9t678kTJ0K7EVk
 Ua4Y/1tpXkZrGz9zr0D/+SE0ITMJAa6EatoI1z7U43stRH6bY6ccTtBJragiMAkuJXnM
 ZdVsvZj9laHdY0Q22w3svL85nsLbp6hnufULwB2RXZd+IH4Lae4b0GaRZqYZK2z54OLi
 DjRONRIIPEKM4mecq+vtl0GxIEZ89edHvrPYYMfyXUUAoDpozG0zQVcbXybDC4CKeTBM
 iCqw==
X-Gm-Message-State: AOAM533qSTkKs1sBp+FpxDyVBG051iFeSHWr5Cs3IExWI7yHjmXNU7+O
 OAQ1NiZvvMNNJ0j20dBgox4=
X-Google-Smtp-Source: ABdhPJxjguZ9DDrPz4gDnb9yHPkMUMCF3GCbvbp/S7EovieX143wCGT1AeBuk0StNs+kplE5MiMg0Q==
X-Received: by 2002:a05:6a00:130e:b0:4cc:3c7d:4dec with SMTP id
 j14-20020a056a00130e00b004cc3c7d4decmr7398006pfu.32.1651909585489; 
 Sat, 07 May 2022 00:46:25 -0700 (PDT)
Received: from [30.22.112.212] ([205.204.117.91])
 by smtp.gmail.com with ESMTPSA id
 u18-20020a170902e21200b0015e8d4eb283sm2990078plb.205.2022.05.07.00.46.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 07 May 2022 00:46:25 -0700 (PDT)
Message-ID: <eb54e7c0-9270-bc9b-d91e-8d0dcaa02a71@gmail.com>
Date: Sat, 7 May 2022 15:46:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v4 01/20] KVM: x86/mmu: Optimize MMU page cache lookup for
 all direct SPs
Content-Language: en-US
To: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-2-dmatlack@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
In-Reply-To: <20220422210546.458943-2-dmatlack@google.com>
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
> Commit fb58a9c345f6 ("KVM: x86/mmu: Optimize MMU page cache lookup for
> fully direct MMUs") skipped the unsync checks and write flood clearing
> for full direct MMUs. We can extend this further to skip the checks for
> all direct shadow pages. Direct shadow pages in indirect MMUs (i.e.
> shadow paging) are used when shadowing a guest huge page with smaller
> pages. Such direct shadow pages, like their counterparts in fully direct
> MMUs, are never marked unsynced or have a non-zero write-flooding count.
>
> Checking sp->role.direct also generates better code than checking
> direct_map because, due to register pressure, direct_map has to get
> shoved onto the stack and then pulled back off.
>
> No functional change intended.
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>


Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
