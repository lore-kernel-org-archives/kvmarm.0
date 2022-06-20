Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEA4C43334
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 12:04:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C9264B4BE;
	Mon, 20 Jun 2022 08:04:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mcjboqx2-nmC; Mon, 20 Jun 2022 08:04:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB25B4B4C1;
	Mon, 20 Jun 2022 08:04:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 427CF4B4BC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:04:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AcQ2JbxOLIws for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 08:04:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E14B64B4BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:04:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655726647;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3fWG6f9+wPyZUdKpzq6SUM1FvIBmD72g2Gxfy7zPec8=;
 b=dRwY5VDDBDHsFGzABSg0ZHQJQf/0K6G89yufHd/cc6ecWuwrkSmKOtbQZtw2ooojbH8+Z6
 Okriva/0xWYGqosNB4QvPhZQxGFPdSjqEqXhlynEwxxNh+hyLzyoN8XvmUuyQgeoJ3IVCW
 P0FOGIfyUBbwe8fJwonIyioPZDuPlWI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-mIwTg9RvOkujCOmRZ-g3yw-1; Mon, 20 Jun 2022 08:04:06 -0400
X-MC-Unique: mIwTg9RvOkujCOmRZ-g3yw-1
Received: by mail-ed1-f71.google.com with SMTP id
 m5-20020a056402430500b004319d8ba8afso8605608edc.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 05:04:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=3fWG6f9+wPyZUdKpzq6SUM1FvIBmD72g2Gxfy7zPec8=;
 b=aTbLISF7/EI3DiBy4mMn3iRzTYCS4YXAGN4+WuMIpQWoNDvtJz/x0ec4ZsmyvUSMNX
 IEOZC0DkguMJQm/t0JsPcll6/ubcEFL+vJG2aEeD5hYZkA96MJRAL5hG33C/8NlU0F74
 mJjBLfwP4uqOTDVSVWFbdV9pY/aoFuZ8rNjuwv5YMhsjNmNfeqEnIkF+F9b35w1jApyr
 c0vVgeEBCIoBpPYPMk883dEeRfEm2acYcimvmCgdnaX+Rv2Z+lWmSlgoUAAJ8x51bLJj
 hD3xSZLgu4PSFX61NSpBu0F/eW+63G+f/qoc26ZiBnHMCNZvV0LhURxXYqKriCMohJVk
 PT8Q==
X-Gm-Message-State: AJIora+JO81821S80/sfI8uZNTJJFqvfEKI3FJa9vEsiy1Er5epmle2b
 xWT7/i/rSqXgu3Nl74KGbi0hd8mbSwzTgk2cChqQHo8OQEfrNyg+9lCKSo+f8Q18Mcl+SWOSmnc
 T5MdN+hPE9tapLB/f6C/WzANc
X-Received: by 2002:a05:6402:11:b0:431:680c:cca1 with SMTP id
 d17-20020a056402001100b00431680ccca1mr29443295edu.420.1655726645155; 
 Mon, 20 Jun 2022 05:04:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u9VhJ+ObuyZNUvGoEylbYK2DQSNd9ckf8bXsZN3l2pKVlgkfhq7FwfxpWwysL4rM30ugQ6lg==
X-Received: by 2002:a05:6402:11:b0:431:680c:cca1 with SMTP id
 d17-20020a056402001100b00431680ccca1mr29443254edu.420.1655726644932; 
 Mon, 20 Jun 2022 05:04:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 u20-20020a17090657d400b00712134a676asm5894961ejr.93.2022.06.20.05.03.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 20 Jun 2022 05:04:01 -0700 (PDT)
Message-ID: <19bba1a0-8fb7-2aae-a65a-1111e29b92d3@redhat.com>
Date: Mon, 20 Jun 2022 14:03:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/3] KVM: selftests: Consolidate ucall code
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20220618001618.1840806-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220618001618.1840806-1-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>,
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
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

On 6/18/22 02:16, Sean Christopherson wrote:
> Consolidate the code for making and getting ucalls.  All architectures pass
> the ucall struct via memory, so filling and copying the struct is 100%
> generic.  The only per-arch code is sending and receiving the address of
> said struct.
> 
> Tested on x86 and arm, compile tested on s390 and RISC-V.

I'm not sure about doing this yet.  The SEV tests added multiple 
implementations of the ucalls in one architecture.  I have rebased those 
recently (not the SEV part) to get more familiar with the new kvm_vcpu 
API for selftests, and was going to look at your old review next...

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
