Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC20E1117
	for <kvmarm@lists.linux.dev>; Wed, 28 Dec 2022 11:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672228721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYdiyUW7v3jDVb1QwzZWNab9jTsMpMxmysun3BoXT8E=;
	b=BUmrbtzLHXKgoS2cqq0PXGvKWAC5e997bHYtEwEZOPPY6zk7DsT/+SPsXE6A6fPtiiXYhA
	uyHReXcNu9XqL42bARoWjCMgaenQqa8jNDHYzG9cijSu0VK/eSeq7ZmFHbXk8Cha1R6yly
	zEs0Zs6zSvzH6xkrIgVz+EL76A54CIw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-74-4PzMybwbMhiRr7S01K7SIg-1; Wed, 28 Dec 2022 06:58:39 -0500
X-MC-Unique: 4PzMybwbMhiRr7S01K7SIg-1
Received: by mail-ed1-f69.google.com with SMTP id f15-20020a056402354f00b00485864db618so4555189edd.13
        for <kvmarm@lists.linux.dev>; Wed, 28 Dec 2022 03:58:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KYdiyUW7v3jDVb1QwzZWNab9jTsMpMxmysun3BoXT8E=;
        b=zkZXG8fvrzr/v3clx/v8E3NzKKLlCicTMoJt6TJ9HncDFlOZvrbc+C5T93kZzzg5Xh
         NiH6LJJ59yvfpAhG9xsMJtlVpe2rl3mGbSn//Ntti/Kton5V0f7frX5LqgPeyI6R1EMs
         XfjX7krG8JE3PE/almEx56Bzc/6ZyTh/M2CMyMTKX7slj+J9cGJjyXHcgYWGWXl6YU50
         tUqDYFzG62v0qwrUjr5u1UdMc7r3ZJj2srVqQo3DLSonOjwkNuas9sq1HwPBYJNxTCrR
         U11BKLum84yqzTHjldjz7EsARCOhp9DXaPDRfIdfXACcpIfk1xIYbXU2hd7ASCslRtzU
         9GeA==
X-Gm-Message-State: AFqh2kqbLiTStE7z/iR9gwJr/Y4VpO4z+Ortv1GHlcH8rlsCjDbKC78C
	tmDmMKiSJN6L3KZ4OGIzJ/utYRmDMMMKffpTJlHYCf02+vyI6mx/LfxwMThCNK20rQhYw86wtGL
	M3RM7FOLZyjpbCB6p
X-Received: by 2002:aa7:de15:0:b0:483:30d7:f9ac with SMTP id h21-20020aa7de15000000b0048330d7f9acmr12028248edv.19.1672228718682;
        Wed, 28 Dec 2022 03:58:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtrIO5srJBbY8oizuyf5Q39Hr1tveD2PqIx/4KuqYlJNhV9zI7izo96N6ps5dxKil3bsWjXNA==
X-Received: by 2002:aa7:de15:0:b0:483:30d7:f9ac with SMTP id h21-20020aa7de15000000b0048330d7f9acmr12028204edv.19.1672228718422;
        Wed, 28 Dec 2022 03:58:38 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id h25-20020aa7de19000000b00463b9d47e1fsm7031261edv.71.2022.12.28.03.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 03:58:37 -0800 (PST)
Message-ID: <55a31d67-b9d0-1a62-1c60-f86b48a34a8b@redhat.com>
Date: Wed, 28 Dec 2022 12:58:33 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 00/50] KVM: Rework kvm_init() and hardware enabling
To: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Atish Patra <atishp@atishpatra.org>,
 David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
 Cornelia Huck <cohuck@redhat.com>, Isaku Yamahata
 <isaku.yamahata@intel.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?=
 <philmd@linaro.org>, Fabiano Rosas <farosas@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Kai Huang <kai.huang@intel.com>,
 Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20221227130249.1650197-1-pbonzini@redhat.com>
 <9acea262dec3511e9cf63081506f0bd7@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <9acea262dec3511e9cf63081506f0bd7@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Message-ID: <20221228115833.7YUuZ9DX7qvm8MTZ-0IIMgIjG0Y0LKxBA095tNvCFJE@z>

On 12/28/22 12:22, Marc Zyngier wrote:
> 
>> Queued, thanks.  I will leave this in kvm/queue after testing everything
>> else and moving it to kvm/next; this way, we can wait for test results
>> on other architectures.
> 
> Can you please make this a topic branch, and if possible based
> on a released -rc? It would make it a lot easier for everyone.

Yes, I will (it will be based on 6.2-rc1 + pull request for rc2 that I'm 
preparing + x86 changes that this conflicts with).

Paolo

