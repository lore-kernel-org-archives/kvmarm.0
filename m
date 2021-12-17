Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE62BC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 17 Dec 2021 15:54:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FBEA4B383;
	Fri, 17 Dec 2021 10:54:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y3IL21Dq68LQ; Fri, 17 Dec 2021 10:54:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F0DC4B2A1;
	Fri, 17 Dec 2021 10:54:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EF0F4B2A1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 10:54:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zZgyFws6uuar for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Dec 2021 10:54:25 -0500 (EST)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32F134B292
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 10:54:25 -0500 (EST)
Received: by mail-wr1-f46.google.com with SMTP id e5so4907445wrc.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 07:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=AHfUikZmyD4dINCWakIQJtobxvYGz5CvtkfmXC/JM0U=;
 b=kkoc4FHM+YuQr9vZVtoceLdb6WDPQLhgj4yrAneG0S9X+rspnO/cHTjzzLHoFMucxW
 f/hpbjjYx/5FXX57Y9KVVq6kXDhnnu1UaInliIeJ1fVNCwxAG7x1ch6jrIUGx3e4q4vb
 i4ozNkufUfpUMXtDhBwJxFdBi5dYXn3N6+rAKS49Kca2spsxiL1X5jXW5OxxQExxyPB5
 mtn8C7cwExGjebtfAkAs6vAWhPNDr6SD3aHoHqaB73+jKuH7VQjS2Rp4CFL3Cqyr7pTJ
 p8dmjR4mYm6fdo4+GoSjpl6nYl4XwkcOKU0xajZXIL2YxeDPiL3khk6uQ3bl7z+Kg35W
 HKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=AHfUikZmyD4dINCWakIQJtobxvYGz5CvtkfmXC/JM0U=;
 b=y901Ps4BZVm6BwZraVbv0nM0spEkPLxoUYvn24TVFckarFBbNkeknKLdNEwmu0zL64
 zCiJo9/gaZzqeSSVvT9/aS0pVVDY1AERnIJcot/83qXnJIIzFof+ym+836yCFrbgCwWz
 69fXr2Ie4dcpG2uvN8PH3LQi2Qm3BGICbQXmrvjLY/Uc0nQWPGo7f+BJ1LGvsXCCo8jC
 yKiyJFuoGvtx1/0wOmI5qjJgjm8+E6h3QBlQJGzlJ6wzHaDFroNBqUSHKlUo89uQNB5v
 YpcKycEvkVuhQknModpv2M8iQ6Ujdrjd6jsh/L1VVN9ZEKC8EB/Z/KnJ6JQ+18qZVK2x
 9/qA==
X-Gm-Message-State: AOAM530e+sLJom1/p/es2l9LGjtn3nNv0L1n6Eap0FJuk5na7HZvDJi1
 9W6J1mVAQKYbY8qRs2rQzmA=
X-Google-Smtp-Source: ABdhPJyGxYhZSxDUxszzp9INdkaMS8zLvwT/pmwuIPWM1rk+PG085n9I8oYQLKBFYA2zw6Fgd+MA6A==
X-Received: by 2002:a5d:6d8b:: with SMTP id l11mr3077055wrs.25.1639756464297; 
 Fri, 17 Dec 2021 07:54:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe?
 ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
 by smtp.googlemail.com with ESMTPSA id k13sm7619520wri.6.2021.12.17.07.54.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 17 Dec 2021 07:54:23 -0800 (PST)
Message-ID: <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
Date: Fri, 17 Dec 2021 16:54:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
Content-Language: en-US
To: Mark Rutland <mark.rutland@arm.com>,
 Nicolas Saenz Julienne <nsaenzju@redhat.com>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
 <70f112072d9496d21901946ea82832d3ed3a8cb2.camel@redhat.com>
 <Ybyg1r/Q6EfeuXGV@FVFF77S0Q05N>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ybyg1r/Q6EfeuXGV@FVFF77S0Q05N>
Cc: paulmck <paulmck@kernel.org>, maz <maz@kernel.org>,
 frederic <frederic@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
 rcu <rcu@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On 12/17/21 15:38, Mark Rutland wrote:
> For example kvm_guest_enter_irqoff() calls guest_enter_irq_off() which calls
> vtime_account_guest_enter(), but kvm_guest_exit_irqoff() doesn't call
> guest_exit_irq_off() and the call to vtime_account_guest_exit() is open-coded
> elsewhere. Also, guest_enter_irq_off() conditionally calls
> rcu_virt_note_context_switch(), but I can't immediately spot anything on the
> exit side that corresponded with that, which looks suspicious.

rcu_note_context_switch() is a point-in-time notification; it's not 
strictly necessary, but it may improve performance a bit by avoiding 
unnecessary IPIs from the RCU subsystem.

There's no benefit from doing it when you're back from the guest, 
because at that point the CPU is just running normal kernel code.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
