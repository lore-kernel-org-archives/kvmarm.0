Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA217C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 17:59:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EB824B128;
	Thu,  9 Dec 2021 12:59:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qCv-2Ik6TIR4; Thu,  9 Dec 2021 12:59:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4D4F4B0B9;
	Thu,  9 Dec 2021 12:59:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF2544B0B9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 12:59:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8OFFKHpCSxjz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 12:59:49 -0500 (EST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com
 [209.85.208.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 177E640256
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 12:59:49 -0500 (EST)
Received: by mail-ed1-f54.google.com with SMTP id o20so22416778eds.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Dec 2021 09:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=Al9kg2F9KDqFvq3nxTcebEIzKXlYK2ZMwKvTrLWHJ6E=;
 b=AfxDwo47UvGMhAdm6Rw/BtUIa4RRpUznlxWNvCDi2EwKzRCRrPvpJmh+M2nKrIHif6
 RpHyhRpE97GWx32ojsr+vOQSd5ecRefy6O6Vid8OcOd0+D4p0Q2SoCBgR3rrAmmKahlA
 aUl3wft7sP5QEuN7iSZhH5rkRKaVK1peWM2Os+UDkvDQn533w9x1rcBKjnT9Nokfcqta
 Nef0h+w0lhpcQqN0kBurWFGd8S50Mwadf5HiHCGvZWYCzfgJ7NBAmJnNi6ZglYeTn5YH
 YVCRHEqPF2Ka7FDT6tHNM5M/dGc0icYZIyOfod4j1semrTFhGJ0HeqkSr+p8VomRXS/o
 2VaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=Al9kg2F9KDqFvq3nxTcebEIzKXlYK2ZMwKvTrLWHJ6E=;
 b=tuqpqlsHAUqFesmTTxEqhmvdHPnotLRyGFnkiJuqmeUEaoCX/l1wC77qI2TAQGzJkx
 j2pSvHVLQpCk2lJxQ13p7NqjijE+eTFOByP2I3vGTn31nKitWhnZXxK55pp6upvCaVb8
 9kvTJQtRHOpZ3c3yTqA2ELAXQmSnTyIsUzqoa17CmrtEeDH5BgGWjCcHYLWi1hDGv1y8
 Kw3LfrpAbcKJNN/TjxqF41oO7jWFWLAolMt064xeR3k0K0q3M3y5fRFQSwBhr+ERlpm8
 5WM40+4/LSenGDJRyM14ILMhlUN8A98xu9nZRwtszshbItrV7yIEnvh+pNFXVXmG0eJO
 tOJA==
X-Gm-Message-State: AOAM530qqwLdvHjdV8YcNgskIfIvsm1mUNhSaHL/HhlDgyZqXj+DzIA9
 /1+7HF7yI+rsOcQ5KilsJ6Q=
X-Google-Smtp-Source: ABdhPJxaGNq1VOGmKW6I6GM+NsKqxWNzc1RuAQMRjvuCk3KwBPxNP9Ur2NQtkE54kPDyjrnXzFPGaA==
X-Received: by 2002:a17:906:7315:: with SMTP id
 di21mr14270348ejc.193.1639072703169; 
 Thu, 09 Dec 2021 09:58:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id hs20sm259690ejc.26.2021.12.09.09.58.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Dec 2021 09:58:22 -0800 (PST)
Message-ID: <5549294a-b411-1279-dcd0-3977c19c928e@redhat.com>
Date: Thu, 9 Dec 2021 18:58:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 03/12] KVM: s390: Use Makefile.kvm for common files
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <20211121125451.9489-4-dwmw2@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211121125451.9489-4-dwmw2@infradead.org>
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 butt3rflyh4ck <butterflyhuangxx@gmail.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On 11/21/21 13:54, David Woodhouse wrote:
>   
> -kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
> +kvm-objs := kvm-s390.o intercept.o interrupt.o priv.o sigp.o
>   kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o

"kvm-y +=" here (for both lines) would be nicer, it's consistent with 
x86 and avoids the question of what happens if you have both kvm-objs 
and kvm-y.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
