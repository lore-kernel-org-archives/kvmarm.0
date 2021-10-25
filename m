Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D536C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 15:05:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 052C160D43
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 15:05:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 052C160D43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68EB94B102;
	Mon, 25 Oct 2021 11:05:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zspey4N6t0su; Mon, 25 Oct 2021 11:05:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B56944B0B3;
	Mon, 25 Oct 2021 11:05:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58E974005D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 11:05:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RxIKk8xBl6TX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 11:05:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 254374A19A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 11:05:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635174326;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=17YKkfI8G+c9Iih6iy4QvMoudnAtBOzRU5Sn0sW8tZE=;
 b=aUowJOSEezruPAV5aYjmQ+lYK4PnUPZm2rdY0GZqKxlRyLjdAP8jYom4/YgWe9sjL8zZ+v
 L3KR9DA0JY8x+SfbqhPtmpp/557AsSNAybKVKckopLoiKnXSjsfAyqGfRwkyfSg/iN8ynJ
 R8xOs0MQVRjRt5Mnl0wbHjoPgnBwGg8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-nOh08Y5bOoS_RYsy_Ch6Cg-1; Mon, 25 Oct 2021 11:05:25 -0400
X-MC-Unique: nOh08Y5bOoS_RYsy_Ch6Cg-1
Received: by mail-wr1-f72.google.com with SMTP id
 n14-20020a5d420e000000b00167c303d862so3323086wrq.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 08:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=17YKkfI8G+c9Iih6iy4QvMoudnAtBOzRU5Sn0sW8tZE=;
 b=uDURGIvC77mkFMrtDXK6gx1Q4E/TWqAsSOvvjLl0GQUxM1RgksjNW2S05x19p0SM0X
 XpuDRrAkkCOU/cTIOo0w/jF/AHA3qSKd+cf5C8Dl0DEIMHcGKse3PRkgipYJAQ2E5jbl
 u/m+T5yXXJzs2tTa/vIPJhI3axEuKsRF1NfReq66WpF8Q3pLhBrHhfr5vgMTML4II51v
 fN096fZltacOQ/tynGnG8gkz+Rm7zkyxdOydorqOwIDdE5F9YrMOKjqUqgNGFufBIamr
 SGvSCRhfam3c0+VmGj60DU65yc+dLmlq4c9nWNemCZOx+ONKeE/KHLH2FrcZd9MGYP0J
 Qx+A==
X-Gm-Message-State: AOAM530gru3FQNyU7vRfa9+zHp73dMkafbgAWeFeYEqNqLgLvFJ6QCoM
 U5k8pVnJQU1yoi0WPNZKLGr4As1vJkl17uiPUhXwH73PvjZAHgLpH2fS3dig9NuAKsR6HHrmO/I
 7yXe9JzotqQ5NODb4gWxylnum
X-Received: by 2002:adf:b1d7:: with SMTP id r23mr24328031wra.145.1635174324218; 
 Mon, 25 Oct 2021 08:05:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNexQuzHRq+jpnX8KTr0omvqAmOMBdWB1dnxyBAmmWnxN2QzlfyX1PUJV+JR7ASMMz0R8mMg==
X-Received: by 2002:adf:b1d7:: with SMTP id r23mr24327978wra.145.1635174323914; 
 Mon, 25 Oct 2021 08:05:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id w10sm9256784wrp.25.2021.10.25.08.05.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 08:05:23 -0700 (PDT)
Message-ID: <a2a4e076-edb8-2cb5-5cb2-6825a1a4559a@redhat.com>
Date: Mon, 25 Oct 2021 17:05:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 40/43] KVM: VMX: Wake vCPU when delivering posted IRQ
 even if vCPU == this vCPU
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Anup Patel <anup.patel@wdc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-41-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-41-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 09/10/21 04:12, Sean Christopherson wrote:
> 
> Lastly, this aligns the non-nested and nested usage of triggering posted
> interrupts, and will allow for additional cleanups.

It also aligns with SVM a little bit more (especially given patch 35), 
doesn't it?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
