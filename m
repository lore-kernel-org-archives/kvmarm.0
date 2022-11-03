Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C6E6FD6
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 14:01:33 +0000 (UTC)
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
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-hXTUF79mMvW4Orm1VbWnNg-1; Thu, 03 Nov 2022 10:01:32 -0400
X-MC-Unique: hXTUF79mMvW4Orm1VbWnNg-1
Received: by mail-ed1-f70.google.com with SMTP id i17-20020a05640242d100b0044f18a5379aso1448693edc.21
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 07:01:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gp3ZE1TCS6qUf/W2wfyFuvz85/MTtwzsFfwWgQFj3ps=;
        b=XRzLJxBXPHiyyuJQ9L60kOJ88uAnZuV0rskLm/NMItnEDjQ6wbJTta7nz/2olRgb+g
         n58no8Yx1KdVvswridBy3ExnBreAtBHvAVrOI+hTeEmTQuRDVzX+I3Wd/ZAGVFmuZAgU
         x7c0PYN2hjpUOAowu+u1GB8MgtMJOCH2vlkKbNIhwxAk0kJgeguF4VK6B1e8kWEk1cfg
         NTiqpI6kLpsZ2dZEnTHgD9jnvHjxuDYsoCi3HIw8Oll6O0gqN+r6sW5Lv2i/oOmGzv3X
         /ro/76TA3BlHwXG5oQk+933I/1gtS2I7gs3udPUBS/a1SqvrxJNNND0Ka2vssWTMNCli
         ewxg==
X-Gm-Message-State: ACrzQf36nOTZ0YL1yiw17Qjje1OgiNBDGa1b22EB7fUbAIwixM0SNL5k
	4NXjDHdR2tmHockc0vTbfglEXl4D5gLhMnlt/KE+TTK2tpDtBvVXx6zIngoyNruaH/H0zaMJJ8C
	7P4Fba4zQxRIyZ/Uy
X-Received: by 2002:a17:907:7e9e:b0:7ad:bc80:c003 with SMTP id qb30-20020a1709077e9e00b007adbc80c003mr25375085ejc.198.1667484089778;
        Thu, 03 Nov 2022 07:01:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM573p4EUrag9CU7KGeV5DPwqVdO4hG3cdn9PAejBOFdAvPNF2Pfj2lgSHDnk+0puoAwMgBkew==
X-Received: by 2002:a17:907:7e9e:b0:7ad:bc80:c003 with SMTP id qb30-20020a1709077e9e00b007adbc80c003mr25374580ejc.198.1667484084861;
        Thu, 03 Nov 2022 07:01:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id a7-20020a17090640c700b007305d408b3dsm532188ejk.78.2022.11.03.07.01.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 07:01:23 -0700 (PDT)
Message-ID: <d641088f-87d9-da77-7e98-92d1a9de6493@redhat.com>
Date: Thu, 3 Nov 2022 15:01:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
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
Cc: James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Atish Patra <atishp@atishpatra.org>,
 David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, Michael Ellerman
 <mpe@ellerman.id.au>, Chao Gao <chao.gao@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Yuan Yao <yuan.yao@intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-11-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221102231911.3107438-11-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221103140121.VPFx2nCkqIUI6OP24t2dQS1Zl1eL0kuhKv3E97edJj0@z>

On 11/3/22 00:18, Sean Christopherson wrote:
> +static void hv_cleanup_evmcs(void)

This needs to be __init.

Paolo

