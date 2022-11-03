Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0B2C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 14:01:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24D624B647;
	Thu,  3 Nov 2022 10:01:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CM8XBgdYnEm0; Thu,  3 Nov 2022 10:01:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DECD84B649;
	Thu,  3 Nov 2022 10:01:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74C084B1C6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 10:01:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ryRCzvrimrw0 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 10:01:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BB004B15C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 10:01:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667484093;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Gp3ZE1TCS6qUf/W2wfyFuvz85/MTtwzsFfwWgQFj3ps=;
 b=Qo0SXA6+5H3ZBoogEL6UCs0UcxfnXe5K6TRqTja55nGKmuiYXb7LShyB5TuCujid+WusZS
 Dz4yA8ncxDQh5SW8Q+jcrTA41nn7uBpQisHBa9HDW7fccHQfL4YrVYdYREWeO9yZ+qObMp
 IN0ZLILxGxDgc/Kstx/J0LkKFbA++Zc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-473-jV6VFX9BPGOwhtsfN3vBiA-1; Thu, 03 Nov 2022 10:01:32 -0400
X-MC-Unique: jV6VFX9BPGOwhtsfN3vBiA-1
Received: by mail-ej1-f69.google.com with SMTP id
 hs34-20020a1709073ea200b007ad86f91d39so1309557ejc.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 07:01:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Gp3ZE1TCS6qUf/W2wfyFuvz85/MTtwzsFfwWgQFj3ps=;
 b=JKox5vX1uPcXu8P6HXRWapMZ08boDxvVsOPCU8oeQ69Ub5GELut1uYioRlrrCM4JR3
 OYqO6GvrP0vVHzDxZUFOSmbQuDOznzQmkT5lEU6CsU8HX+fWgKnSScXSdTXJrF+Nf5tx
 JC2sLSlVtFGPgrZRLU4KZHRKPVm5p0Vcf62c6QAeUmlg4smgXYP7651iohhyUzpsk3Zw
 6Uxzp+yRXGMMZrX8Mg4G0D/pPi6XKbiS0VpaLjZmmfNDnxXjkZ6G3OfrwK2axsxP0Z+G
 /0wwc0qle529eyejwwDyn6NqPz0yg6lXdOeYRrlNyFV4k6TUjNdTk3DgwmONnH6emY5o
 oL0w==
X-Gm-Message-State: ACrzQf34Dx8kMAxQsyEDQhtW4JIOEJwXRdwR5gNRyucGkRpoT6LQiwnu
 /Gp9g3v450IDIqxhLAfXSj2WRlzHDTA/0VPj5r/N124eM9pw0jiE+QIcmKf/NsssQhGuEUU2QhD
 S4X560uwtjXRwdfVp77Wq2Pcu
X-Received: by 2002:a17:907:7e9e:b0:7ad:bc80:c003 with SMTP id
 qb30-20020a1709077e9e00b007adbc80c003mr25375097ejc.198.1667484089846; 
 Thu, 03 Nov 2022 07:01:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM573p4EUrag9CU7KGeV5DPwqVdO4hG3cdn9PAejBOFdAvPNF2Pfj2lgSHDnk+0puoAwMgBkew==
X-Received: by 2002:a17:907:7e9e:b0:7ad:bc80:c003 with SMTP id
 qb30-20020a1709077e9e00b007adbc80c003mr25374580ejc.198.1667484084861; 
 Thu, 03 Nov 2022 07:01:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c?
 ([2001:b07:6468:f312:1c09:f536:3de6:228c])
 by smtp.googlemail.com with ESMTPSA id
 a7-20020a17090640c700b007305d408b3dsm532188ejk.78.2022.11.03.07.01.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 07:01:23 -0700 (PDT)
Message-ID: <d641088f-87d9-da77-7e98-92d1a9de6493@redhat.com>
Date: Thu, 3 Nov 2022 15:01:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 10/44] KVM: VMX: Clean up eVMCS enabling if KVM
 initialization fails
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-11-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221102231911.3107438-11-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
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

On 11/3/22 00:18, Sean Christopherson wrote:
> +static void hv_cleanup_evmcs(void)

This needs to be __init.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
