Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABC1C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 08:02:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 720F649F49;
	Fri,  4 Nov 2022 04:02:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v7cE61sg6K07; Fri,  4 Nov 2022 04:02:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 401E14A49C;
	Fri,  4 Nov 2022 04:02:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBE9249F49
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 04:02:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VBSf9NyGjoPl for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 04:02:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80DA549F3F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 04:02:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667548958;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QJu1Z+r/Jj1Q22H/Z28kMZfifRbtSqoNatlqDbaYr8M=;
 b=Ht881+Jlk5g+JMhSSLNDUJyiPl1UFMFDxFF9LzjwLU9xxQgu9oKJvvXsOJj+Pzlzgrs21E
 J6OWFWTWg6jrvcXwWk8vnmUSA/DI3Gv4bwgJ5W2BUCe0SyMptQeSs7A7RaSLTJfhITqF2S
 C16Sm+gvNoncb4hATdNLsdRfOpIH/fg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-10-KFqvTpzDOVKCBNnFcajMgg-1; Fri, 04 Nov 2022 04:02:37 -0400
X-MC-Unique: KFqvTpzDOVKCBNnFcajMgg-1
Received: by mail-ej1-f72.google.com with SMTP id
 qk31-20020a1709077f9f00b00791a3e02c80so2756046ejc.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 01:02:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=QJu1Z+r/Jj1Q22H/Z28kMZfifRbtSqoNatlqDbaYr8M=;
 b=wLzZEIwFztS6SSPyMppXcISXo6owjzvJFX+7g1QBuh6xc+CU5Kz0DRapDQHXGSPh60
 FkzvIp5N3LS98tk/udMYdTO1a0U5RBmaVCaYCz1OgVwPie1X9Mjc/tqqvivXlhqKd7nX
 7MR2TWOfOXA4JtLj1JbDVoYeOeCoXxR2mqAsWRUe1imhPPMYt265HLsogwC4yxeJG+8y
 UW/ezJnihVve+k1RwcXx/EVv/Uf3hJxwZ0Kh/gNN6XBnKZbJ9i4lFEvLUfeJVjUv2wJe
 +NlVwiW1oQQIrhsQsUUHEh5vUCotFBnqSw6BlJtY7QEY4qoHFOGbck8ZuAzTCvTNTi+a
 rkaQ==
X-Gm-Message-State: ACrzQf2HgMD49b7q1Z6EtLaegE5TqMJpgRjEe9maMPKLZ/NSfG7KtpR1
 p+M5KHvq83Te6pG8hI3fjL84c+Flb9HkxWb3Gk0ElRqtKpLhUlMDwW6gQlMWXDQVn3o4YcguPig
 aQrt+DNYWF30nk9qfGCyGDYof
X-Received: by 2002:a17:907:1dda:b0:7a6:8ffc:7dc with SMTP id
 og26-20020a1709071dda00b007a68ffc07dcmr33677016ejc.163.1667548955857; 
 Fri, 04 Nov 2022 01:02:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5ZNqKb/aQP9ibAQb8G5uHFxFpKasjpH84kkwoGMwJiLbxjg9Lh2wolUrwViafofx0ss1frxA==
X-Received: by 2002:a17:907:1dda:b0:7a6:8ffc:7dc with SMTP id
 og26-20020a1709071dda00b007a68ffc07dcmr33676971ejc.163.1667548955613; 
 Fri, 04 Nov 2022 01:02:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5?
 ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
 by smtp.googlemail.com with ESMTPSA id
 tz14-20020a170907c78e00b0078ddb518a90sm1433630ejc.223.2022.11.04.01.02.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 04 Nov 2022 01:02:34 -0700 (PDT)
Message-ID: <6c71fcca-c17f-5979-e15e-afcf08899064@redhat.com>
Date: Fri, 4 Nov 2022 09:02:32 +0100
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
 <c29e7d40-ddb9-def0-f944-a921a05a4bb2@redhat.com>
 <Y2QPSK1/6esl61wQ@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2QPSK1/6esl61wQ@google.com>
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

On 11/3/22 19:58, Sean Christopherson wrote:
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 3e508f239098..ebe617ab0b37 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -191,6 +191,8 @@ static void default_init(struct cpuinfo_x86 *c)
>                          strcpy(c->x86_model_id, "386");
>          }
>   #endif
> +
> +       clear_cpu_cap(c, X86_FEATURE_MSR_IA32_FEAT_CTL);
>   }
>   
>   static const struct cpu_dev default_cpu = {

Not needed I think?  default_init does not call init_ia32_feat_ctl.

> diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
> index c881bcafba7d..3a7ae67f5a5e 100644
> --- a/arch/x86/kernel/cpu/cpuid-deps.c
> +++ b/arch/x86/kernel/cpu/cpuid-deps.c
> @@ -72,6 +72,8 @@ static const struct cpuid_dep cpuid_deps[] = {
>          { X86_FEATURE_AVX512_FP16,              X86_FEATURE_AVX512BW  },
>          { X86_FEATURE_ENQCMD,                   X86_FEATURE_XSAVES    },
>          { X86_FEATURE_PER_THREAD_MBA,           X86_FEATURE_MBA       },
> +       { X86_FEATURE_VMX,                      X86_FEATURE_MSR_IA32_FEAT_CTL         },
> +       { X86_FEATURE_SGX,                      X86_FEATURE_MSR_IA32_FEAT_CTL         },
>          { X86_FEATURE_SGX_LC,                   X86_FEATURE_SGX       },
>          { X86_FEATURE_SGX1,                     X86_FEATURE_SGX       },
>          { X86_FEATURE_SGX2,                     X86_FEATURE_SGX1      },
> 

Yes, good idea.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
