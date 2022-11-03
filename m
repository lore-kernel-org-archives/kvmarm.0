Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C507488
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 15:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667488098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MLzJVyRQvNMkBYTyqF+CAZ1OHQes3dhnjH8NkXHBEKk=;
	b=FrT37/qLSZklV8qCdqtQsv9474p7GTCJhbbybK9bc+vrslLQCAQK/k/u/bsdbFk105jplt
	UBjAVWSBgEHOpseZeSoeYMzPjyT20BNcH+UKBwOiCT45q2Xy2iXNeKoV0/AZfWIRMcf1aF
	n+oNKLgnKTIk7iXNQwZgHgXgLi+wetk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-502-1HNMt5BBPTmKjFiEsJa12w-1; Thu, 03 Nov 2022 11:08:14 -0400
X-MC-Unique: 1HNMt5BBPTmKjFiEsJa12w-1
Received: by mail-ej1-f69.google.com with SMTP id gt15-20020a1709072d8f00b007aaac7973fbso1448370ejc.23
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 08:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MLzJVyRQvNMkBYTyqF+CAZ1OHQes3dhnjH8NkXHBEKk=;
        b=AcE6QARU2Z87k3Af7Xag3bznA+WzK6INyDMnrc59ggZT+HuZBlCTPRHlqNQZwvIgvq
         eBh0cIfpDFHEIDehDUkN9lM9qp9SmF1PhqdfD+mwQRF8M6Uw6hRPDaynDVXazdgepemY
         z67vKHPAv5FuPjc2U/0qe2RtzUSTt4wrfE1R6Dclw3hf/o8+agGoYQqy2nQ1g1TIG6tS
         Xk3SxCGN9xJfBgapgsG7l0yMwz98vjiX6hYGC+LTbmCfke9O464VEIABaYhXkkjdO6pR
         +nOoouqfPAG140OSF6M2KVMEB2mS1SclX9jWcE/GHPuxeDu9y0ruM8Vmn4PaTt2D0G+O
         520w==
X-Gm-Message-State: ACrzQf0ZTV9mOyJ74xMQCp1ybxy4C8VdYcNbHsfqsODoZ+yrJfltVdWp
	Kdcdy3vKuS6yO3L0VpB8ZgxHsZzgaK5UqZZo4j/pknpF081DuFa5vcsxDdYZk/8sFcOpCpTWAIH
	ShFzsuf3l3lWP/4aO
X-Received: by 2002:a05:6402:550e:b0:456:f79f:2bed with SMTP id fi14-20020a056402550e00b00456f79f2bedmr31117707edb.106.1667488092995;
        Thu, 03 Nov 2022 08:08:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6ksX1XHskAylW8hRvHj1WJtzsGVm4o7GE4R3Qlz1mullFc3dI571812AyMzkQixxOznTrmOg==
X-Received: by 2002:a05:6402:550e:b0:456:f79f:2bed with SMTP id fi14-20020a056402550e00b00456f79f2bedmr31117664edb.106.1667488092781;
        Thu, 03 Nov 2022 08:08:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id s28-20020a056402037c00b0045bccd8ab83sm646641edw.1.2022.11.03.08.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 08:08:11 -0700 (PDT)
Message-ID: <bfa98587-3b36-3834-a4b9-585a0e0aa56a@redhat.com>
Date: Thu, 3 Nov 2022 16:08:09 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 33/44] KVM: x86: Do VMX/SVM support checks directly in
 vendor code
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
 <20221102231911.3107438-34-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221102231911.3107438-34-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221103150809.y1xjww-F6AB43x3jYAAn6aKX0smPV2NyQ7-4IN9LwUA@z>

On 11/3/22 00:19, Sean Christopherson wrote:
> +	if (!boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
> +	    !boot_cpu_has(X86_FEATURE_VMX)) {
> +		pr_err("VMX not enabled in MSR_IA32_FEAT_CTL\n");
> +		return false;

I think the reference to the BIOS should remain in these messages and in 
svm.c (even though these days it's much less common for vendors to 
default to disabled virtualization in the system setup).

The check for X86_FEATURE_MSR_IA32_FEAT_CTL is not needed because 
init_ia32_feat_ctl() will clear X86_FEATURE_VMX if the rdmsr fail (and 
not set X86_FEATURE_MSR_IA32_FEAT_CTL).

Paolo

