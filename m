Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A6BC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 11:47:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61D3340E00;
	Fri,  4 Nov 2022 07:47:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TTTK0k44t292; Fri,  4 Nov 2022 07:47:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3786540FAC;
	Fri,  4 Nov 2022 07:47:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE21341278
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 17:04:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8JvrnnVEh1Jk for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 17:04:05 -0400 (EDT)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
 [209.85.214.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 507F54120D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 17:04:05 -0400 (EDT)
Received: by mail-pl1-f177.google.com with SMTP id d20so2028970plr.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 14:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=RKpWMQos6VVD1S/I4lACLsmO/tYS5LRA7d2ENkEKbRo=;
 b=W1jfdVvCiC74H1TrCZBHpy39zmLx6ZdDw7CTvEA3hQRy2SYEYEHpqHKEqbYIPLurIe
 Y2whGNqDI5mui4w+1QXrkHh+GC9ATmNd8ps8PeHw3qaJpwgt1d7jvMCXqs25Zy8Lpx4o
 BRkdqU5nSWSpkaBgaA/lV+5CSWVpabSirQHa1cejuentrhT/uERBbBImlSMJgf6A967J
 fjOlpx3kn0dIaEHhhAKeVdXj4/EkPaL2dmbdM+AJdzuPv1TA2eEp2KkYLi7TVhEuAixL
 VUk9wO+wTZMMnlMLn0pWY/lQ/5O1/2ysb54mA9Nupm245dVRVUlabq2dQWglwCNzBaAj
 yq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=RKpWMQos6VVD1S/I4lACLsmO/tYS5LRA7d2ENkEKbRo=;
 b=qBgAH/VtNcY9W62m0mzjH9OTdIA9cCgPpAGZunK1ny0fvSeeXqaLJkqyjS/oer1mC1
 JyyYlYD7LNBsxu0NJYeknrE7Ef8DcMG97vLXSfeAfe0hcUlyYyBFrnOlelmOGZuxEU8L
 OTkYt9IlkXyng/MDqdY8VNHDedrrJ130gdTesVlmOrhrMkTVsqqjk0Lw1hNmS3aJpEhD
 osvW89L5fBWQ5HAFbnFBkwUDJ+mTQH1ELX/PW9ViT//fiyRolJIjQr0ZSyHvPAeKXPC2
 DC3CUpYkDHY/E1xtspSFyUCZqxQf+ikVtNbWzpgdrfe1eYIDcjIn2VLtFFVd2CX0QlsD
 sbVg==
X-Gm-Message-State: ACrzQf2drdPFQC+Gwy3AblvIgVTLbHFNl2d+ba7BErsY2qcm6LCF85Ks
 Se22UbF2NEfzmaw0VKUx1Ig=
X-Google-Smtp-Source: AMsMyM4B7LXLMUo1WLny520SMeR1sIUEIak6LqJqMDk6N+6eScsWNFNrZpvHK/6RhT2SJsSNsCUIWw==
X-Received: by 2002:a17:902:e5c5:b0:186:5f09:8468 with SMTP id
 u5-20020a170902e5c500b001865f098468mr32699741plf.122.1667509444114; 
 Thu, 03 Nov 2022 14:04:04 -0700 (PDT)
Received: from localhost ([192.55.54.55]) by smtp.gmail.com with ESMTPSA id
 27-20020a63125b000000b0046a1c832e9fsm1137383pgs.34.2022.11.03.14.04.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 14:04:03 -0700 (PDT)
Date: Thu, 3 Nov 2022 14:04:02 -0700
From: Isaku Yamahata <isaku.yamahata@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Message-ID: <20221103210402.GB1063309@ls.amr.corp.intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221102231911.3107438-37-seanjc@google.com>
X-Mailman-Approved-At: Fri, 04 Nov 2022 07:47:47 -0400
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 isaku.yamahata@gmail.com, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Nov 02, 2022 at 11:19:03PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> From: Chao Gao <chao.gao@intel.com>
> 
> Do compatibility checks when enabling hardware to effectively add
> compatibility checks when onlining a CPU.  Abort enabling, i.e. the
> online process, if the (hotplugged) CPU is incompatible with the known
> good setup.
> 
> At init time, KVM does compatibility checks to ensure that all online
> CPUs support hardware virtualization and a common set of features. But
> KVM uses hotplugged CPUs without such compatibility checks. On Intel
> CPUs, this leads to #GP if the hotplugged CPU doesn't support VMX, or
> VM-Entry failure if the hotplugged CPU doesn't support all features
> enabled by KVM.
> 
> Note, this is little more than a NOP on SVM, as SVM already checks for
> full SVM support during hardware enabling.
> 
> Opportunistically add a pr_err() if setup_vmcs_config() fails, and
> tweak all error messages to output which CPU failed.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/svm/svm.c          | 20 +++++++++++---------
>  arch/x86/kvm/vmx/vmx.c          | 33 +++++++++++++++++++--------------
>  arch/x86/kvm/x86.c              |  5 +++--
>  4 files changed, 34 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f223c845ed6e..c99222b71fcc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1666,7 +1666,7 @@ struct kvm_x86_nested_ops {
>  };
>  
>  struct kvm_x86_init_ops {
> -	int (*check_processor_compatibility)(void);
> +	int (*check_processor_compatibility)(int cpu);

Is this cpu argument used only for error message to include cpu number
with avoiding repeating raw_smp_processor_id() in pr_err()?
The actual check is done on the current executing cpu.

If cpu != raw_smp_processor_id(), cpu is wrong. Although the function is called
in non-preemptive context, it's a bit confusing. So voting to remove it and
to use.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
