Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B4F9475
	for <kvmarm@lists.linux.dev>; Tue, 28 Feb 2023 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677618330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0/5hmQVwpzcKmo7ZySLNvsyz1qAPMMBkqrZKd0ciXbk=;
	b=AsK4gTBvUHwFRY727XMjHCBXsbQENr9ReSTbV4DGEL7l1o6RbG30rKiOqu30dqW+d38r34
	yfwUWNXw/NB2EwwjonbHjG08WRyED1PZWIu60RGG0FQe0s9+rS2eQGuRTjmgioxWHfnoCH
	JMi7FBtE/Y/U21q0daQKlZVjRRhi+/U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-647-k4Ri9KZqOACYPdVwVhvd1w-1; Tue, 28 Feb 2023 16:05:29 -0500
X-MC-Unique: k4Ri9KZqOACYPdVwVhvd1w-1
Received: by mail-wr1-f72.google.com with SMTP id r3-20020a5d6c63000000b002bff57fc7fcso1859249wrz.19
        for <kvmarm@lists.linux.dev>; Tue, 28 Feb 2023 13:05:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0/5hmQVwpzcKmo7ZySLNvsyz1qAPMMBkqrZKd0ciXbk=;
        b=lMAJJibKqCUjWAGO8vn/7oxMBr9TmZ/swIgZHYMLGUhuD8C4/95tDYJHrQEzmD5eoI
         QsPPtQWn2QR9NR5DIMdL5T1anZ0gPBHuWUWykk0z0uWLDnfVq+0EYJf14yLWkl24ocug
         SilUHi8ba1G2vgxH6ZCv55ciRJoRJKS45zFChEE92FIHMVKL40qemXMBxQQpsHoySIFg
         i/vB/ag7HH01u9Q1jOcXu2U4VE/JVTopG7WXzvhES+pwntS7usipIb+WzYZuxGX8eEHs
         hJrEDMyWlqs+hgN5RIseEVDaNXoB1cwplN7EQpPd95I9c/U2LUL0T4J4zN52q1oBVBVm
         X8bg==
X-Gm-Message-State: AO0yUKXpw0GBUDHc8Ve657qmG5s9aXFy/E115NPXRr+kKYd56Dxa2JpM
	0LaDXfQHAIpsu0b8sCVLlb/sE3zZUMRWDibU08LKTU7mborVzrtvDYL5ZNfownrbSRUBbAksPmn
	bBA6gBe30MozMsqHb
X-Received: by 2002:a05:600c:1d28:b0:3e2:147f:ac1a with SMTP id l40-20020a05600c1d2800b003e2147fac1amr3385144wms.21.1677618328376;
        Tue, 28 Feb 2023 13:05:28 -0800 (PST)
X-Google-Smtp-Source: AK7set9zrY1Ob9BThSVmM8VM9t39M7li3rs0M0P+LAVMOqBxDLKVC6qz7tgEwMKRPuRCd+1G8HlP3w==
X-Received: by 2002:a05:600c:1d28:b0:3e2:147f:ac1a with SMTP id l40-20020a05600c1d2800b003e2147fac1amr3385132wms.21.1677618328092;
        Tue, 28 Feb 2023 13:05:28 -0800 (PST)
Received: from [192.168.8.100] (tmo-112-221.customers.d1-online.com. [80.187.112.221])
        by smtp.gmail.com with ESMTPSA id bh22-20020a05600c3d1600b003e01493b136sm17087499wmb.43.2023.02.28.13.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Feb 2023 13:05:27 -0800 (PST)
Message-ID: <04213fad-909f-e86d-caaa-c559917b2e4d@redhat.com>
Date: Tue, 28 Feb 2023 22:05:25 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 6/6] KVM: Change return type of kvm_arch_vm_ioctl() to
 "int"
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 Cornelia Huck <cohuck@redhat.com>
References: <20230208140105.655814-1-thuth@redhat.com>
 <20230208140105.655814-7-thuth@redhat.com>
In-Reply-To: <20230208140105.655814-7-thuth@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/02/2023 15.01, Thomas Huth wrote:
> All kvm_arch_vm_ioctl() implementations now only deal with "int"
> types as return values, so we can change the return type of these
> functions to use "int" instead of "long".
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   arch/arm64/kvm/arm.c       | 3 +--
>   arch/mips/kvm/mips.c       | 4 ++--
>   arch/powerpc/kvm/powerpc.c | 5 ++---
>   arch/riscv/kvm/vm.c        | 3 +--
>   arch/s390/kvm/kvm-s390.c   | 3 +--
>   arch/x86/kvm/x86.c         | 3 +--
>   include/linux/kvm_host.h   | 3 +--
>   7 files changed, 9 insertions(+), 15 deletions(-)

Ping!

Unless I missed something, I think this series had enough review ... Paolo, 
could you maybe queue the whole series, since it's mostly an 
architecture-wide clean up?

  Thanks,
   Thomas

