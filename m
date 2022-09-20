Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1046C54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 21:46:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 366E84B645;
	Tue, 20 Sep 2022 17:46:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@ozlabs-ru.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KyBvpNISnQ-w; Tue, 20 Sep 2022 17:46:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A9C64B64F;
	Tue, 20 Sep 2022 17:46:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 383F54B3C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 17:46:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FHfIc5i6NPgQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 17:46:29 -0400 (EDT)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9570B49EFA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 17:46:29 -0400 (EDT)
Received: by mail-pl1-f181.google.com with SMTP id p18so3733378plr.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 14:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date;
 bh=7l/du9tda2XXL7FC7D3+ws6V56vBPTifJOsgn5Df51U=;
 b=gOwSfOBbOr0MQjW5J+UipqgY2Yw0uaNGsdreNLLUTDAa9oJvasIrAg0xIqNd6JiCJa
 /lgGQS7Q7nYv6b+T6ZiQMMEBH/BgMj/HFdvRGGgH3smBNXbNaXSmFnTYFomPlG0Z0NGS
 2cenws1/5V21PiPBEdeHsWTCSLNfKNhlCdt/MAYtvkn9gp6c/7PG4lN9X16+DcF5/ij6
 e5f5cdzMkb9SYgvYUAkvx/e+KHrZ57z10+mRwcube170/DdHCki9xJNAnreu6apEm/HG
 zlrEnBZu26IHdG0QI6woc6awnSbNFJ7vtkmuhh2eW8WmicHnxp3rSI+lOebJnCfq36Z3
 sISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=7l/du9tda2XXL7FC7D3+ws6V56vBPTifJOsgn5Df51U=;
 b=lHhHCL7NZav+DYdCzXiI/PzJ9AtD60KFO8vVsbHlDkxgMYjwWMpq1A0dCd5OCqGx9m
 AorvdFt/Wj1LFUrlxN1EUlP4FW48Q7qKtKBJKuWIbG8Bh7ib17R4rzro+pQiPb5X1xQl
 QqEVLFViJxWOvULVtBKqJDI/gnI+ZXWe9yr5cPS0K7Yf1/K+RJFkE87mpHXBvrA57NDr
 EmfgwsVF+eWwaHZuVUSjI23NuPLyhKZcxRhe4AVhEadZr5yarQFex9Sc14JrYPmOr2iv
 2sj2IZyrvN5F+4Z615hAY0I6dh0IWrXYcHXBJ3vlknsgSjW0vF9IqvScT6Tq8VbIVh2/
 9k3w==
X-Gm-Message-State: ACrzQf1eXrZ+gTywJHpAUwd45pX3ycGjh3Lnf4PdaEewPF7Vcq2H/ufg
 qiI2DG7nGexYBDHDyYvASMNv1Q==
X-Google-Smtp-Source: AMsMyM4SuFzhjRKjEs3+Aoh19U+sLXTWgvCFX2DZggzYsKqwvyHbVXt9oLg9ZfwFqHhT7+94CUlpUg==
X-Received: by 2002:a17:902:aa8b:b0:178:8f1d:6936 with SMTP id
 d11-20020a170902aa8b00b001788f1d6936mr1595515plr.168.1663710388674; 
 Tue, 20 Sep 2022 14:46:28 -0700 (PDT)
Received: from [192.168.10.153]
 (ppp121-45-204-168.cbr-trn-nor-bras38.tpg.internode.on.net. [121.45.204.168])
 by smtp.gmail.com with ESMTPSA id
 i2-20020a17090332c200b0017834a6966csm367205plr.176.2022.09.20.14.46.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 20 Sep 2022 14:46:27 -0700 (PDT)
Message-ID: <02490d2a-5e89-f342-f5b3-386406ffb2ea@ozlabs.ru>
Date: Wed, 21 Sep 2022 07:46:21 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
Subject: Re: [PATCH kernel v2] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
To: Marc Zyngier <maz@kernel.org>
References: <20220920125143.28009-1-aik@ozlabs.ru>
 <874jx2kp02.wl-maz@kernel.org>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <874jx2kp02.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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



On 21/09/2022 02:08, Marc Zyngier wr
ote:
> On Tue, 20 Sep 2022 13:51:43 +0100,
> Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
>>
>> When introduced, IRQFD resampling worked on POWER8 with XICS. However
>> KVM on POWER9 has never implemented it - the compatibility mode code
>> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
>> XIVE mode does not handle INTx in KVM at all.
>>
>> This moved the capability support advertising to platforms and stops
>> advertising it on XIVE, i.e. POWER9 and later.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> Acked-by: Nicholas Piggin <npiggin@gmail.com>
>> [For KVM RISC-V]
>> Acked-by: Anup Patel <anup@brainfault.org>
>> ---
>> Changes:
>> v2:
>> * removed ifdef for ARM64.
> 
> The same argument applies to both x86 and s390, which do select
> HAVE_KVM_IRQFD from the KVM config option. Only power allows this
> option to be selected depending on the underlying interrupt controller
> emulation.
> 
> As for riscv and mips, they don't select HAVE_KVM_IRQFD, and this
> isn't a user-selectable option. So why do they get patched at all?

Before the patch, the capability was advertised on those, with your 
proposal it will stop. Which is a change in behavior which some may say 
requires a separate patch (like, one per platform). I am definitely 
overthinking it though and you are right.

> My conclusion is that:
> 
> - only power needs the #ifdefery in the arch-specific code
> - arm64, s390 and x86 can use KVM_CAP_IRQFD_RESAMPLE without a #ifdef
> - mips and riscv should be left alone

Fair enough, thanks for the review! I'll post v3 shortly.

> 
> Thanks,
> 
> 	M.
> 

-- 
Alexey
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
