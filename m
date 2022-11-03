Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56931C43219
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 16:58:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2A024B64A;
	Thu,  3 Nov 2022 12:58:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JQ9VxQIBJrvH; Thu,  3 Nov 2022 12:58:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C04294B731;
	Thu,  3 Nov 2022 12:58:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43B7E4B63E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:25:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XudF4D4vxHqt for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 03:25:43 -0400 (EDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15C594B633
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 03:25:42 -0400 (EDT)
Received: by mail-wr1-f45.google.com with SMTP id g12so1290491wrs.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 00:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=EDXCjZngZdqFd0T8UNtaJgIVNUXtxy5kh+IvZcYgc3o=;
 b=KBb4CRffvbqT8vCYmIjrzMCnn1vGDH3hTE8kztkuirWCWDx5vmnnhlY12+76G8HB+D
 zNMscqf1aWjU1jn9Q/+2qznV1nyjnfJgJejU0eBLDst+wEJ5JP32F9KCikAYwccYRz/4
 CEoS+rbiQf+EK76mQ+O07yD4/kZHVOkQQ4sHVGI67dP7iLfCkYZsRk0ZykZuinHxGqnw
 VBepbg5NHi4yk+ONf1CC+WSt8MwwyKu83Az0OvU8HlQtsrRUhgNXczuxh+p9v62b1ye5
 0/LNF3gKJJGGBQ4GVZwf3fHBWg9tW8pDxWcOYgxGkG6PYQEim2NR9gsO5CmPy3fAtv6n
 sc3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=EDXCjZngZdqFd0T8UNtaJgIVNUXtxy5kh+IvZcYgc3o=;
 b=u/1k5uTi5j7fNZABWNkt0tMWFpeQovPNgwiTaj+XJMsVuWiR1CQkM0tt3PN1nRcD31
 E0F2Du5XwY3OEH7hbF1bZLuxMjgPFOeL9vLjIQt4DNJUu2Jo+TsjGObrDl5V99vOhBTb
 Xk6FsFL8m43I1r+2Vk+PEFtu69NCY11P6IM21KqtdZRB5qG6RwFTcIyhOmQeYDKWAeQ1
 iG496QFMq8Sx1wC7bsLq3xuXPwSkRAcjkF9hZL62Dibb6j6K4zKnKbymUvVYzDUNXZCg
 vHoZXQSrg7sUPk3DsG/sU7p7xEgPrJc7Ee300qmwKYP1yd1o/QZBZt0MArm63oqK+TFB
 7L2A==
X-Gm-Message-State: ACrzQf2TARxwvsAfjHoOMFETDhQ7mcSEQmKy/O71/5rF8Jgl7ZF3yKFd
 IrRiWR+I6rX2f70zd+U7zdbo7A==
X-Google-Smtp-Source: AMsMyM74HX/NoI0zgj7ni+fuzXHxAnM/kiJpMAz2sP8bktGhOQR4suw74I3bBM5aFs9fFpQjlVL3zA==
X-Received: by 2002:a5d:50ca:0:b0:236:776c:3075 with SMTP id
 f10-20020a5d50ca000000b00236776c3075mr17956880wrt.656.1667460341889; 
 Thu, 03 Nov 2022 00:25:41 -0700 (PDT)
Received: from [192.168.11.175] (216.red-88-29-181.dynamicip.rima-tde.net.
 [88.29.181.216]) by smtp.gmail.com with ESMTPSA id
 i10-20020a1c540a000000b003a3442f1229sm4408723wmb.29.2022.11.03.00.25.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 00:25:40 -0700 (PDT)
Message-ID: <dd59d579-4a4e-6db2-eac4-6c5c3ab71fd3@linaro.org>
Date: Thu, 3 Nov 2022 08:25:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 17/44] KVM: arm64: Do arm/arch initialiation without
 bouncing through kvm_init()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
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
 <20221102231911.3107438-18-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221102231911.3107438-18-seanjc@google.com>
X-Mailman-Approved-At: Thu, 03 Nov 2022 12:58:44 -0400
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

Hi Sean,

On 3/11/22 00:18, Sean Christopherson wrote:
> Move arm/arch specific initialization directly in arm's module_init(),
> now called kvm_arm_init(), instead of bouncing through kvm_init() to
> reach kvm_arch_init().  Invoking kvm_arch_init() is the very first action
> performed by kvm_init(), i.e. this is a glorified nop.
> 
> Making kvm_arch_init() a nop will allow dropping it entirely once all
> other architectures follow suit.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/kvm/arm.c | 25 ++++++++++++++++---------
>   1 file changed, 16 insertions(+), 9 deletions(-)

>   /* NOP: Compiling as a module not supported */
>   void kvm_arch_exit(void)
>   {
> -	kvm_unregister_perf_callbacks();

Doesn't this belong to the previous patch?

> +
>   }

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
