Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9B2C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 18:46:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 641654B3C0;
	Thu,  3 Nov 2022 14:46:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1XgoRyFUcF0D; Thu,  3 Nov 2022 14:46:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 516EE4B25A;
	Thu,  3 Nov 2022 14:46:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C09F4B239
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 14:46:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xFHQ4rdMSmZI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 14:46:28 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE8CB4B16F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 14:46:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667501188;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KUvqpmismHtbPDi1RWOVBVQOlTCkIOX4rr6fY8m3qi8=;
 b=EabJpTwfu8tjjAfHEkBVi7bBq+lrfUWFHawhyEB1UMCeQZXnLUaK5P9HsuBOfU3j6e6noZ
 SJRT20RiiiB+HpCjpj0Hhrm05HM7kb7Wpu9MwqIEstj4N4izzUjgBuNbbsO4PblKrwrYHN
 iuCVN8/aEt7ngeIDwuH4QtswA1pOwKY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-246-SQWKLz0dPRuObUHEg4XV7Q-1; Thu, 03 Nov 2022 14:46:27 -0400
X-MC-Unique: SQWKLz0dPRuObUHEg4XV7Q-1
Received: by mail-ej1-f70.google.com with SMTP id
 hq18-20020a1709073f1200b007ade8dd3494so1821395ejc.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 11:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=KUvqpmismHtbPDi1RWOVBVQOlTCkIOX4rr6fY8m3qi8=;
 b=UWLL0rCR23oqR4KMyVwsLRxY+j4ZGw0z5dH1OdGPobPjTsb6Bkf10BSGHbmn8qTu0l
 J7jE3O7vEune4853oUHIEmdWt1eETMKF00GxTz6I4D57l6AHi259x03723oOemEwvsev
 Ggh6OEJmSO6AO4g7VAHPA+Cjpi/5JlPiuS4jzUNtwduW94jOeyyaZNH/nwvmd61kHGv/
 jR21LmRafb0EgmCMDbCw57DgoAkOC4m0ZcSJdYyqADWyFOC0R9rTadMTORCVZI3pmkFO
 hVMR0emVIFqebfWWtNPezx2palFkpF60geBebW6hR+Z/+7onZeXzEXtgbu57JM6JiYC4
 /Lyg==
X-Gm-Message-State: ACrzQf3H1j4mlrjTUmItiI8SBvp1OisCKtZLAyyNN7FcQcozsZQZwCzH
 ShwrEvYI5pwOQWYcojJ/GrUocWRxJlku/PNBs7D8xOkGJwiF0jAlMJAHcwTD6fLw30XjRv4bSEh
 PynK/iuFrrWoMul6NWjIQfyy9
X-Received: by 2002:a17:907:31c9:b0:740:ef93:2ffd with SMTP id
 xf9-20020a17090731c900b00740ef932ffdmr30301715ejb.584.1667501186294; 
 Thu, 03 Nov 2022 11:46:26 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6jngiF1WMeYDLzQRcIfcwEai0RoBStUb1QJ9IQKOY38atIN4TLSIas8P4CJc6XubwxUck1WA==
X-Received: by 2002:a17:907:31c9:b0:740:ef93:2ffd with SMTP id
 xf9-20020a17090731c900b00740ef932ffdmr30301665ejb.584.1667501186012; 
 Thu, 03 Nov 2022 11:46:26 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c?
 ([2001:b07:6468:f312:1c09:f536:3de6:228c])
 by smtp.googlemail.com with ESMTPSA id
 2-20020a170906218200b0078246b1360fsm799044eju.131.2022.11.03.11.46.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 11:46:25 -0700 (PDT)
Message-ID: <c29e7d40-ddb9-def0-f944-a921a05a4bb2@redhat.com>
Date: Thu, 3 Nov 2022 19:46:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 33/44] KVM: x86: Do VMX/SVM support checks directly in
 vendor code
To: Sean Christopherson <seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-34-seanjc@google.com>
 <bfa98587-3b36-3834-a4b9-585a0e0aa56a@redhat.com>
 <Y2QJ2TuyZImbFFvi@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2QJ2TuyZImbFFvi@google.com>
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

On 11/3/22 19:35, Sean Christopherson wrote:
> It's technically required.  IA32_FEAT_CTL and thus KVM_INTEL depends on any of
> CPU_SUP_{INTEL,CENATUR,ZHAOXIN}, but init_ia32_feat_ctl() is invoked if and only
> if the actual CPU type matches one of the aforementioned CPU_SUP_*.
> 
> E.g. running a kernel built with
> 
>    CONFIG_CPU_SUP_INTEL=y
>    CONFIG_CPU_SUP_AMD=y
>    # CONFIG_CPU_SUP_HYGON is not set
>    # CONFIG_CPU_SUP_CENTAUR is not set
>    # CONFIG_CPU_SUP_ZHAOXIN is not set
> 
> on a Cenatur or Zhaoxin CPU will leave X86_FEATURE_VMX set but not set
> X86_FEATURE_MSR_IA32_FEAT_CTL.  If VMX isn't enabled in MSR_IA32_FEAT_CTL, KVM
> will get unexpected #UDs when trying to enable VMX.

Oh, I see.  Perhaps X86_FEATURE_VMX and X86_FEATURE_SGX should be moved 
to one of the software words instead of using cpuid.  Nothing that you 
should care about for this series though.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
