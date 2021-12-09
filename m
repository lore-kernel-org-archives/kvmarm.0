Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B82C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 18:56:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8D9E4B11A;
	Thu,  9 Dec 2021 13:55:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lirM8TK2M6Po; Thu,  9 Dec 2021 13:55:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D09D4B10B;
	Thu,  9 Dec 2021 13:55:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E30DF4B0BD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 13:55:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bWVYY+DthSKv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 13:55:55 -0500 (EST)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com
 [209.85.208.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A59CF40667
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 13:55:55 -0500 (EST)
Received: by mail-ed1-f45.google.com with SMTP id w1so22469659edc.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Dec 2021 10:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=pWwoYV6f5eE3TAEXwDK4FFkFf2kDxMmFmHp/m8WrKqU=;
 b=BgFP9f2AS8qbKScGYulFkIKBIZF7JhPtQutQZsMXRAyJ3VsVqzndrMn244/YxeSa51
 1JUMrJPUwH6WLWl6wKGB+t4kB+BfxBS/3tylxelJEEsxjfutVgkY0NGGWdXlHSxUH9/s
 IG5V5H9F2fbokZUBDHFl4GJeYwFtPdJjNvWKwn/iXALcP0VtLbtjDrHf8WZWTCwB3Xhm
 geXXoQOtv6TQOuhRK4Dwojif5cLxpkeylANQuiS2B3K1Yq5gB28MA62ZLyfdvPigvuID
 /R8nJ2bNX2pioETM5nl38v0+1+ad+KAxF1M3iKasVf2dXhApLQn8URlgJhmcpu2xwC3Q
 0KEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=pWwoYV6f5eE3TAEXwDK4FFkFf2kDxMmFmHp/m8WrKqU=;
 b=XKTIwGAZ9C+klZ4p8gKAurhgVzoojD7oHS/DyAYIRv05xi7+wCOLuS6BnM00mB4DQH
 1Yn7Z7XayKnI4JM6ODAjO7ruh6xXdN0CSyxE+Eufz4T4QmX8mDH16q2aJD9dyt6sl6EC
 H2hqa2VOVOM+75GltizV2bXc4VXZtJ8VB2nOCJI/49LyITtN51Um5w/njHO1SpTcXGU0
 4Qekm8GutMNsgyIJ2FfooWI16AIRzFUQ2Ju5LzIeRDZ34jFXFlWo+XrnjH2pfy49rhKI
 scq0oRIBwEKBpMWbiLKhNkZgq01JWvIMVbR2rAbGdcOvwVBVnbYXgzigjN0MfUwQaCgX
 eDoQ==
X-Gm-Message-State: AOAM532JPjpUd9kuYCha8j71Oa+GF1ZcbmJDMXeRdfn2/pg9f6ATxvCC
 EnjsXzD4ed2JzIhXQXe9NAw=
X-Google-Smtp-Source: ABdhPJwFiK8t4T2rMj2CnTJwfI5KDFX/WPkj8rfHAoRspVvoAsdM3AeM8i4uwXNbLWDTdu8wAOHXxw==
X-Received: by 2002:a05:6402:40d2:: with SMTP id
 z18mr31216197edb.395.1639076154663; 
 Thu, 09 Dec 2021 10:55:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id h7sm279134edb.89.2021.12.09.10.55.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Dec 2021 10:55:54 -0800 (PST)
Message-ID: <68d867c7-1031-00be-e28d-bd435d9c4170@redhat.com>
Date: Thu, 9 Dec 2021 19:55:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 00/12] KVM: x86/xen: Add in-kernel Xen event channel
 delivery
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <2617aea0-af09-5c0d-1fd7-65e2a814b516@redhat.com>
 <5706a7fec0ffdb18097792374dad90c0400b17cd.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5706a7fec0ffdb18097792374dad90c0400b17cd.camel@infradead.org>
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

On 12/9/21 19:47, David Woodhouse wrote:
>>> As in the previous two rounds, the last patch (this time patch 12) is
>>> included as illustration of how we*might*  use this for fixing the UAF
>>> bugs in nesting, but isn't intended to be applied as-is. Patches 1-11 are.
>> Queued 1-7, will be on kvm/next tomorrow though.
>
> Thanks. I assume you made the changes you wanted to the makefiles then,
> and will work on the gfn_to_pfn_cache changes you suggested.

Yes, thanks.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
