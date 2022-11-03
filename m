Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CD463A0
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667498282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yqxXm7t2WOic9y4ISYxOwK8KmYTr1cBIHzcg/Vydbzs=;
	b=JO0fY+VMuNNNhB9GwqiOZKCp7OisVtjP792TK1lpPDIfzSzbT7aAJufF3oHGhVTVFyZUGQ
	ypXwi8rVRS4QmQA6Lg0x3F8li1VJ7ovfimxJHpMQGE6P6HtY23MmbmBQro9xR8QSBVNE47
	UJ/Be44vj5/GmEQJYh7tSZhvW+53jI8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-288-R1QxJvaUNrCc9OZB0tRi_g-1; Thu, 03 Nov 2022 13:58:01 -0400
X-MC-Unique: R1QxJvaUNrCc9OZB0tRi_g-1
Received: by mail-ej1-f71.google.com with SMTP id he6-20020a1709073d8600b0078e20190301so1748668ejc.22
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 10:58:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yqxXm7t2WOic9y4ISYxOwK8KmYTr1cBIHzcg/Vydbzs=;
        b=rwxf9t0caEsPnzoyu3DtY+VlF+BJIbdsgN3ltJvUP9CF7BCJHVYegm1NeflOJ/FnCJ
         6GeC0VCjQRtPhdAoe9bdW92W+JdBPpZFV0JX5MD1ttfpqEbxJpYgwFKvmEvmhpFPkJES
         a6aVAHvhSxE7BuCijYnKO21mIu7ILQ9Wvpf+5LOuZ7IVo9tvqy4jPJRGLWOsAmE9lgYq
         i/jtPlJG0/J1o8yHyTt1+CWlf9FjjtVobgOKV+vJBUhcS9gkoiHQlBPLTBOfhBOrYvdS
         EM8jbik8flfoH+7yG+qBH4kSsRZlZHxc6Ly7IOh9Q19m0HlivQMUcNtbR3Co225zHI3E
         u6Ng==
X-Gm-Message-State: ACrzQf1BH4RmaZlUb7UcX7Uy9chqK4rFfnT+ZuAhkQE8Fu+f/k81d2YV
	i4OCkIh07c1PmZCQ6hrzXMZLyf+p+3gAc0ZhKzX+PyLE+MzfI5F1WrjSi564N3RPEEIogpGO0LZ
	6VSu+4PBxjE+4nBzZ
X-Received: by 2002:a17:907:a087:b0:7ad:a2ec:1afa with SMTP id hu7-20020a170907a08700b007ada2ec1afamr30061861ejc.151.1667498280032;
        Thu, 03 Nov 2022 10:58:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6QZmNq5hCph1jlllZl0PdTQdpFjKynjhfU4TqqXsTy2ri356CZrCrEtJkVH+I+gMfL+O9fNA==
X-Received: by 2002:a17:907:a087:b0:7ad:a2ec:1afa with SMTP id hu7-20020a170907a08700b007ada2ec1afamr30061831ejc.151.1667498279805;
        Thu, 03 Nov 2022 10:57:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id l3-20020a170907914300b0078d76ee7543sm734215ejs.222.2022.11.03.10.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 10:57:58 -0700 (PDT)
Message-ID: <1fd2e729-6e46-b0bf-d89e-f5d1b4dbde77@redhat.com>
Date: Thu, 3 Nov 2022 18:57:55 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, James Morse <james.morse@arm.com>,
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
 <20221102231911.3107438-37-seanjc@google.com>
 <23bfd709-f99a-5a74-e4b9-1381b88453f1@redhat.com>
 <Y2P+E+631c0TNcK7@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2P+E+631c0TNcK7@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221103175755.6-SY03lSaLlI4Tb_5rj-SbPtKUkgMnxuZ5ZurZI8jXg@z>

On 11/3/22 18:44, Sean Christopherson wrote:
>>> Do compatibility checks when enabling hardware to effectively add
>>> compatibility checks when onlining a CPU.  Abort enabling, i.e. the
>>> online process, if the (hotplugged) CPU is incompatible with the known
>>> good setup.
>>
>> This paragraph is not true with this patch being before "KVM: Rename and
>> move CPUHP_AP_KVM_STARTING to ONLINE section".
>
> Argh, good eyes.  Getting the ordering correct in this series has been quite the
> struggle.  Assuming there are no subtle dependencies between x86 and common KVM,
> the ordering should be something like this:

It's not a problem to keep the ordering in this v1, just fix the commit 
message like "Do compatibility checks when enabling hardware to 
effectively add compatibility checks on CPU hotplug.  For now KVM is 
using a STARTING hook, which makes it impossible to abort the hotplug if 
the new CPU is incompatible with the known good setup; switching to an 
ONLINE hook will fix this."

Paolo

>    KVM: Opt out of generic hardware enabling on s390 and PPC
>    KVM: Register syscore (suspend/resume) ops early in kvm_init()
>    KVM: x86: Do compatibility checks when onlining CPU
>    KVM: SVM: Check for SVM support in CPU compatibility checks
>    KVM: VMX: Shuffle support checks and hardware enabling code around
>    KVM: x86: Do VMX/SVM support checks directly in vendor code
>    KVM: x86: Unify pr_fmt to use module name for all KVM modules
>    KVM: x86: Use KBUILD_MODNAME to specify vendor module name
>    KVM: Make hardware_enable_failed a local variable in the "enable all" path
>    KVM: Use a per-CPU variable to track which CPUs have enabled virtualization
>    KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_exit()
>    KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock
>    KVM: Disable CPU hotplug during hardware enabling
>    KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
>    KVM: Drop kvm_arch_check_processor_compat() hook
> 

