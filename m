Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87561C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 17:58:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E95284B4D7;
	Thu,  3 Nov 2022 13:58:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mqhd5RB4LTp8; Thu,  3 Nov 2022 13:58:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C5164B0D7;
	Thu,  3 Nov 2022 13:58:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 179524B0D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 13:58:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0KxmF-67afRc for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 13:58:03 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD3994B0D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 13:58:02 -0400 (EDT)
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
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-537-w4zrtZl2OhGkVqUSOgAhIA-1; Thu, 03 Nov 2022 13:58:01 -0400
X-MC-Unique: w4zrtZl2OhGkVqUSOgAhIA-1
Received: by mail-ed1-f72.google.com with SMTP id
 c9-20020a05640227c900b00463de74bc15so1884494ede.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 10:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=yqxXm7t2WOic9y4ISYxOwK8KmYTr1cBIHzcg/Vydbzs=;
 b=C5JV3qIcaRBb0FWHNlNQ+nZhriJL3u6atPMjxQ2AOsOVgqmD3GgPKTVSe+WChyhWTh
 ZIWTviczwrV2h9sZLQXhx5Xd4x4SxfNRc3ZEkRDnlw/mKAuapIIkghu2xk+9DFLDXktO
 G1eQGq6xkc1TG9O9o7W3PJahq7UKbjTGjf4yqEAKQ5qQ1gA7dEmElUg9+7zfL5zof6qI
 IHo0UMraU1maOhx8bd2LYwwGhWoZql4ZS/LuEgAE9Mn/TcbesdgSyIYA1FDsCeSBZzcc
 vaYFUHvEaAdYalNemneqKVANrdlGPjg0gfPQq5luQf0Ph5HLlx40DTLDH6kZWDexTU2k
 zkHg==
X-Gm-Message-State: ACrzQf0t2m81kTYiN8ODsmsVUF/TlzQw+SWKw953gWWNlp5u1J5dj6if
 qhRDmXaHqnzue474hB26ERbxYwSIPDPSE9jG28UWXUpzjYrwwpFZAGm9NnBPm4cAR+85M6vJaIY
 dtQC+sKgXsz40mD5rly8vZkam
X-Received: by 2002:a17:907:a087:b0:7ad:a2ec:1afa with SMTP id
 hu7-20020a170907a08700b007ada2ec1afamr30061891ejc.151.1667498280174; 
 Thu, 03 Nov 2022 10:58:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6QZmNq5hCph1jlllZl0PdTQdpFjKynjhfU4TqqXsTy2ri356CZrCrEtJkVH+I+gMfL+O9fNA==
X-Received: by 2002:a17:907:a087:b0:7ad:a2ec:1afa with SMTP id
 hu7-20020a170907a08700b007ada2ec1afamr30061831ejc.151.1667498279805; 
 Thu, 03 Nov 2022 10:57:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c?
 ([2001:b07:6468:f312:1c09:f536:3de6:228c])
 by smtp.googlemail.com with ESMTPSA id
 l3-20020a170907914300b0078d76ee7543sm734215ejs.222.2022.11.03.10.57.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 10:57:58 -0700 (PDT)
Message-ID: <1fd2e729-6e46-b0bf-d89e-f5d1b4dbde77@redhat.com>
Date: Thu, 3 Nov 2022 18:57:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
To: Sean Christopherson <seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
 <23bfd709-f99a-5a74-e4b9-1381b88453f1@redhat.com>
 <Y2P+E+631c0TNcK7@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2P+E+631c0TNcK7@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
