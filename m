Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A068CBD3C
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 09:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675762008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/F3qfr1H23q3phH6cljEmKpLs439z5etAwPY/FDcZlA=;
	b=CxoDAQAo/llAIi5O8DVB/i7BvMRrQOKSg4JtRk4RQY3BDaTG+28dkDEgj8sgWNw/m78J1D
	cDJl5G3wpiszr22w8em40GxjbJz9/AYIPvQKdn0b+QqJezJqk/gqjBjwZqPvCvlG+MyP/4
	SlOqurUJxD+0KmGayLT35ZX465GqGuQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-144-NYBbWsiCPseuxtmbTxFGzw-1; Tue, 07 Feb 2023 04:26:45 -0500
X-MC-Unique: NYBbWsiCPseuxtmbTxFGzw-1
Received: by mail-qt1-f199.google.com with SMTP id a24-20020ac84d98000000b003b9a4958f0cso8163875qtw.3
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 01:26:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/F3qfr1H23q3phH6cljEmKpLs439z5etAwPY/FDcZlA=;
        b=wYuXp1mqyY1X79SAWs++MOtr33omL1OqBDUnJs7tYPy3jazONAMPuKhUDDbyIWMp89
         Nn6I+I0Zwfers8SEWM/MqXvkR9jF9qt/Wz+H4OUKnmXJ0TWwFAZGqc/plztJvJrOl3EI
         KhuKJdwwbovp8oahsBCwDU9ktEfCzNx6DrRJPQDCa0k202WRayERU8luNO9LQEIpBGAa
         ZXH6IzEoQGpdJX3L2qydPvrebkcpd9el27LsHA0XFoOldy8KXmAjQZ+m8aqpvNtFE35a
         v/3Opxi9uAyU+R9JiASkqT74CLjOhOvt95NL0LemxTeGRmpZh9RlcpfIqvGkpdLYn6NL
         z7jg==
X-Gm-Message-State: AO0yUKV5dg9K1ipITQJKp/wig8NVoB/D4KkmSGOiKWyEzd8GVn2e6+vY
	F7UUFzS2diIOr9fmvlcDseS0fGpYSoQtjQj++y6PBlTCS/gv4wgcyJ9XijBlkH0udx8dIbv7fYH
	NvT3TUmo56LhP+RKD
X-Received: by 2002:a05:622a:188d:b0:3b9:a441:37f3 with SMTP id v13-20020a05622a188d00b003b9a44137f3mr3131470qtc.64.1675762004508;
        Tue, 07 Feb 2023 01:26:44 -0800 (PST)
X-Google-Smtp-Source: AK7set8bB7OmE4JZ0vH4S5PaJ9NaK/oiOhz8aqf0f6ynkAzsxoZg5CO1XDpfEPDTS/rewIBCUB+dtA==
X-Received: by 2002:a05:622a:188d:b0:3b9:a441:37f3 with SMTP id v13-20020a05622a188d00b003b9a44137f3mr3131454qtc.64.1675762004253;
        Tue, 07 Feb 2023 01:26:44 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-120.web.vodafone.de. [109.43.176.120])
        by smtp.gmail.com with ESMTPSA id dl12-20020a05620a1d0c00b0071323d3e37fsm9034385qkb.133.2023.02.07.01.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 01:26:43 -0800 (PST)
Message-ID: <579f432d-6100-0ba1-5ba4-f72349ec9173@redhat.com>
Date: Tue, 7 Feb 2023 10:26:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 2/7] KVM: x86: Improve return type handling in
 kvm_vm_ioctl_get_nr_mmu_pages()
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, linuxppc-dev@lists.ozlabs.org
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-3-thuth@redhat.com> <Y91JAb0kKBYQjO8a@google.com>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <Y91JAb0kKBYQjO8a@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/02/2023 18.48, Sean Christopherson wrote:
> On Fri, Feb 03, 2023, Thomas Huth wrote:
>> kvm_vm_ioctl_get_nr_mmu_pages() tries to return a "unsigned long" value,
>> but its caller only stores ther return value in an "int" - which is also
>> what all the other kvm_vm_ioctl_*() functions are returning. So returning
>> values that do not fit into a 32-bit integer anymore does not work here.
>> It's better to adjust the return type, add a sanity check and return an
>> error instead if the value is too big.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index da4bbd043a7b..caa2541833dd 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -6007,8 +6007,11 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
>>   	return 0;
>>   }
>>   
>> -static unsigned long kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
>> +static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
>>   {
>> +	if (kvm->arch.n_max_mmu_pages > INT_MAX)
>> +		return -EOVERFLOW;
>> +
>>   	return kvm->arch.n_max_mmu_pages;
>>   }
> 
> My vote is to skip this patch, skip deprecation, and go straight to deleting
> KVM_GET_NR_MMU_PAGES.  The ioctl() has never worked[*], and none of the VMMs I
> checked use it (QEMU, Google's internal VMM, kvmtool, CrosVM).

I guess I'm living too much in the QEMU world where things need to be 
deprecated first before removing them ;-)
But sure, if everybody agrees that removing this directly is fine, too, I 
can do this in v2.

  Thomas


PS: Has there ever been a discussion about the other deprecated interfaces 
in include/uapi/linux/kvm.h ? Most of the stuff there seems to be from 2009 
... so maybe it's time now to remove that, too?

