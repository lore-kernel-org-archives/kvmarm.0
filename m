Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5338BA31
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 07:12:11 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id y16so1248181wrt.12
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 00:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OBfEswiMsti3OjaKbPQcyAca5te7/jZ5jHcc8SlAT9E=;
        b=EOYmqRt+/NXugZnlIP4em6mI3EQkzvGwpLXhzORTBxBkCP2uHtj6EIHrWTEowCV0gy
         LjLxmy1kx2FmBqwAXMu8s7YUEChDsUQy5qxfdkx40NZii0vXZu9Y5+E9WIQ98im7w2Qz
         aOc+G9yXO8FMp2gmsGVhL5vc6lj4hdeRWLBju/dhOwwfhZrxP6JKghml+WEnDzleKfR2
         xT+vK0HSOhR2frMY/9x+44r4Scku2Y/ouh8iYDp71I/Bsog0PelRVmfpSZ0wxjqL2jqd
         o6DVxRPDxt5z1+9lDTnQ22y8cNKN7oK+0fUhVvCWoxg4QyLcgrLA6TLc/Hs3GkkFsCs4
         skXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OBfEswiMsti3OjaKbPQcyAca5te7/jZ5jHcc8SlAT9E=;
        b=dVuGIF5H3rOFo5leCbYx/gczWhrAZOq1lpQ+QBJZWIJETrp/yu9drdMunpyS0geHPZ
         a03qod23ER6ZgH+vOPpP3PVtNrJVH5SUJH+J2lEbz8UESMu052LAvjzuAqtpBUsGuEu3
         J699RHjnNSe0iA7n7SkpveaRdylqu1mxbF3eENdWX2VyjRWffBTd9SVoGvdIYPsN9Vte
         zRbm9VtF0CL0sNZdH/q6qaneLL0yDAOVnwubOXysatTKFuLU7nki8CTIe4HCreIX4/4a
         +08HgvBZQfG0CB6zsdyKjlNt8x556UV7iHKW8bvwrwARy68uJtXYg1JEtXOYh/QvPiEq
         5vkg==
X-Gm-Message-State: ACrzQf1yYh8fcyuAVQqRU9A5KsVg0nVFm6s/k7nRLzy8CcV65iBhmyF+
	4ER3kDEmneyV4gWQ5D2WHragQuWBX8yyPw==
X-Google-Smtp-Source: AMsMyM6cHSUzeR4K9K8x56LNKCrmIwrY3rn7gLNAI0DHx5P8Dkfz8OPY8ArcGxqxO2wWVx+YIs8sgw==
X-Received: by 2002:a5d:644d:0:b0:236:8330:a5bf with SMTP id d13-20020a5d644d000000b002368330a5bfmr17103381wrw.125.1667459529624;
        Thu, 03 Nov 2022 00:12:09 -0700 (PDT)
Received: from [192.168.11.175] (216.red-88-29-181.dynamicip.rima-tde.net. [88.29.181.216])
        by smtp.gmail.com with ESMTPSA id k15-20020adff28f000000b00236740c6e6fsm1599wro.100.2022.11.03.00.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 00:12:09 -0700 (PDT)
Message-ID: <9cec1cc6-5050-9fc6-46ec-a8984b8266a8@linaro.org>
Date: Thu, 3 Nov 2022 08:12:05 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 21/44] KVM: MIPS: Register die notifier prior to
 kvm_init()
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
 <20221102231911.3107438-22-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221102231911.3107438-22-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Message-ID: <20221103071205.Zq5-_vW3s9W859fsIkUHNEYcu1liwCR7k0zDSJ4RK60@z>

On 3/11/22 00:18, Sean Christopherson wrote:
> Call kvm_init() only after _all_ setup is complete, as kvm_init() exposes
> /dev/kvm to userspace and thus allows userspace to create VMs (and call
> other ioctls).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/mips/kvm/mips.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

