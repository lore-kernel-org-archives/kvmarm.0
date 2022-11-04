Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C9B10EB
	for <kvmarm@lists.linux.dev>; Fri,  4 Nov 2022 07:18:21 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so3915948pjl.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Nov 2022 00:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eA0yZupCmJu+lIFxWoscgsZofsCuVm6nQ+r3Bs4PfgM=;
        b=pMTxZL/oe6jfdbdYCNUp+Xb6WGMwDJ0tqzYjFuCFVTbU1K6LCmp38IhtqgFEtGH1Fw
         eLi3S+bCzf2+/rSdLI9BvXSs2AxVFQGLdZ/VpkCMRosDZICPg8K0E7aAi3VCg4WFPYDw
         BfmWNQys/m/eitnUWQLYZ4i97xNTJmOpokS1/YmW7+tK6sMrbeSwt/lUvRFiVPBmwrU/
         ivWuBjfa1WZ8S1UNebL0AtpJKNK0IoOPWmP7NKKqfcpMaASq0oFieIk/rtzcNf6p/IAa
         QK7q17GoUs4Yjdkmho6a4WFZ4muIgt4Uy+uR4Vu4p0vmgfomnVLk+4/4y9tD9W4Njnx3
         1t6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eA0yZupCmJu+lIFxWoscgsZofsCuVm6nQ+r3Bs4PfgM=;
        b=tCiBYiofKTTtRK1DfkChEoSibwqD/Cug+mBmJug3446gVZ+N3vqVIPooqOYfqZXgv9
         ufOR3o9BNVegFi60xIQx+YxfTeZ71tirMiaXGQymKgGpMUpqZC5/RrlujfwXojW1cElw
         jO3HGYP/8Xtkxaqq9jSKGpbJfFdL/N6h+6qAbKs2vPxXQMDcwD979U1gMC3gTwaMFCrN
         HruYOTCIUjdR9Dma5Pmk9fxWMBBxEm80ev3QXPu3UlYnHn7zsBjwcSatYxEM1VYvm3qo
         lybVlZ94bmAD2J/co/HDOe0BMdvadbchFeZJc8XbKa0buUso5P4K5BmsaYg3YG1IGSLI
         ue6w==
X-Gm-Message-State: ACrzQf1tN5+lW/VW7WKcgZRcjuuh3ExS5F5eTxlP9SFKgxZAT+LZHQ1c
	B9Ism8P+nlOhhR0Gly+AS3I=
X-Google-Smtp-Source: AMsMyM44DihVYXeoqfThPObIIFl16q8Fgq5Ol1s8X3KRnlnJD5T+n/qjAhXcJhbg7QI1HMtgLqbViQ==
X-Received: by 2002:a17:902:d592:b0:17a:582:4eb with SMTP id k18-20020a170902d59200b0017a058204ebmr34136415plh.40.1667546300864;
        Fri, 04 Nov 2022 00:18:20 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090322c900b00186f0f59c85sm1854838plg.235.2022.11.04.00.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 00:18:20 -0700 (PDT)
Date: Fri, 4 Nov 2022 00:18:19 -0700
From: Isaku Yamahata <isaku.yamahata@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Atish Patra <atishp@atishpatra.org>,
	David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Fabiano Rosas <farosas@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Message-ID: <20221104071819.GD1063309@ls.amr.corp.intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
 <20221103210402.GB1063309@ls.amr.corp.intel.com>
 <Y2RB4qT02EkhMjPL@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2RB4qT02EkhMjPL@google.com>
Message-ID: <20221104071819.Wi47rEZuiMJ2VtBW7EHTgG-Vbs4AhcpjAJ5rwypS4zo@z>

On Thu, Nov 03, 2022 at 10:34:10PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Nov 03, 2022, Isaku Yamahata wrote:
> > On Wed, Nov 02, 2022 at 11:19:03PM +0000,
> > Sean Christopherson <seanjc@google.com> wrote:
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index f223c845ed6e..c99222b71fcc 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1666,7 +1666,7 @@ struct kvm_x86_nested_ops {
> > >  };
> > >  
> > >  struct kvm_x86_init_ops {
> > > -	int (*check_processor_compatibility)(void);
> > > +	int (*check_processor_compatibility)(int cpu);
> > 
> > Is this cpu argument used only for error message to include cpu number
> > with avoiding repeating raw_smp_processor_id() in pr_err()?
> 
> Yep.
> 
> > The actual check is done on the current executing cpu.
> > 
> > If cpu != raw_smp_processor_id(), cpu is wrong. Although the function is called
> > in non-preemptive context, it's a bit confusing. So voting to remove it and
> > to use.
> 
> What if I rename the param is this_cpu?  I 100% agree the argument is confusing
> as-is, but forcing all the helpers to manually grab the cpu is quite annoying.

Makes sense. Let's settle it with this_cpu.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
