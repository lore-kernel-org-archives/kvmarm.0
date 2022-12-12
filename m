Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE44C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 22:50:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1C524B951;
	Mon, 12 Dec 2022 17:50:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hxTygzTZYpvg; Mon, 12 Dec 2022 17:50:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF32C4B921;
	Mon, 12 Dec 2022 17:50:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E534B91C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:50:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RKwzWOEL2Bff for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 17:50:37 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F74B4B91A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:50:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670885436;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SyXP7MS8bTF3RbvPik+WjzHwHuSSdP6S+AJrUdi5oEE=;
 b=UbmrHDZTVAISBXVLA80tSafMGUAE2XKmlE9r2rwWqVN7NnzZEVIUDXkMjMrALv0NeytJ86
 rUAzzbfwuRKOm9PrEWWKxh9SqUkBUNKoY9UoxsCmvDjihYomCTwn50sfw1kZtn44GwfX2r
 hpUpq3Om7QgeOIYIRmFDp2N8+TcC0iU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-331-zVcEhWWtMgKwAV6PNos7KQ-1; Mon, 12 Dec 2022 17:50:33 -0500
X-MC-Unique: zVcEhWWtMgKwAV6PNos7KQ-1
Received: by mail-wm1-f70.google.com with SMTP id
 o34-20020a05600c512200b003d07ee4a667so57184wms.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:50:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
 :content-language:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=SyXP7MS8bTF3RbvPik+WjzHwHuSSdP6S+AJrUdi5oEE=;
 b=bs73mFnVwI+2ps6/oohGBCcfRHoCjvbVTumIuD1UsIaCbPKmN8QppXg0KHqBtcfkbI
 yiHe9AXfdZ4d+LoSeM32wVBhMG+x7hnPRTpMXnYtaewpQqZYjh5zDGiKXovEC8Ks+Oan
 H3Mh7X1TpzZF69RVmA3fLDatvFZO79XoYyn679TH3Wx6MjKBdXOi8I+qu7kYLZshGs4u
 6vlA1/wnF+VahjPIjinmycVWycMI1lVHMkdaj4MREzlmaHiZ18TinUl96MvzupNh2O7i
 79JNE8o/gSTg8FDys/JCjZQRDDPIh06mhds8UacNohUPpkbPiKS04sJeR2JberQPcAYP
 NYvg==
X-Gm-Message-State: ANoB5pkdVp7YvsLuN/YjsteMVmTrFxVME1HZLcDeYplvYT4hN1fll4UF
 65FHiU5bn4IT+ebCqoR/k8pc+6/JgEBzIRfHKzG8LVv13EJQQY2nDc5swSKNxqDyvnG+yDxvw4L
 KhWCHApEp9VH+87q0hqshbYty
X-Received: by 2002:a05:600c:4147:b0:3d2:2904:dfe9 with SMTP id
 h7-20020a05600c414700b003d22904dfe9mr2900886wmm.21.1670885432384; 
 Mon, 12 Dec 2022 14:50:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6IZI0JQ674vEsdHgG0GiqLautfRb0p9b68d9OO4rhlD9rOnbnd3mXqInAe/GEdBqLbG8sv0g==
X-Received: by 2002:a05:600c:4147:b0:3d2:2904:dfe9 with SMTP id
 h7-20020a05600c414700b003d22904dfe9mr2900870wmm.21.1670885432160; 
 Mon, 12 Dec 2022 14:50:32 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 n9-20020a05600c3b8900b003b4ff30e566sm199780wms.3.2022.12.12.14.50.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Dec 2022 14:50:31 -0800 (PST)
Message-ID: <01cb4882-7a06-176f-7d55-f80cca300ffd@redhat.com>
Date: Mon, 12 Dec 2022 23:50:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To: Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
 <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
In-Reply-To: <Y5dnWgJ0ine55/hN@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Yang, Weijiang" <weijiang.yang@intel.com>, "Amit, Nadav" <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Yu Zhao <yuzhao@google.com>, xu xin <cgel.zte@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Arnd Bergmann <arnd@arndb.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Atish Patra <atishp@atishpatra.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
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

On 12/12/22 18:39, Sean Christopherson wrote:
>> The notion of address spaces is already existing architecture-neutral
>> concept in KVM (e.g. see uses of KVM_ADDRESS_SPACE_NUM in
>> virt/kvm/kvm_main.c), although SMM is the only use-case I'm aware of.
> 
> Yes, SMM is currently the only use-case.

It's possible that in the future Hyper-V VTLs will also have per-level 
protections.  It wouldn't use as_id, but it would likely be recorded in 
the upper byte of the role.

I'm not sure if Microsoft intends to port those to ARM as well.

> My preference would be to leave .smm in x86's page role

What about defining a byte of arch_role and a macro to build it?


> Unless I'm missing something, e.g. a need to map GPAs differently for
> SMM vs. non-SMM, SMM could have been implemented with a simple flag
> in a memslot to mark the memslot as SMM-only.

Unfortunately not, because there can be another region (for example 
video RAM at 0A0000h) underneath SMRAM.

In fact, KVM_MEM_X86_SMRAM was the first idea.  It was uglier than 
multiple address spaces 
(https://lore.kernel.org/lkml/1431084034-8425-1-git-send-email-pbonzini@redhat.com). 
  In retrospect there were probably ways to mix the best of the two 
designs, but it wasn't generic enough.

> And separate address spaces become truly nasty if the CPU can access multiple
> protected regions, e.g. if the CPU can access type X and type Y at the same time,
> then there would need to be memslots for "regular", X, Y, and X+Y.

Without a usecase that's hard to say.  It's just as possible that there 
would be a natural hierarchy of levels.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
