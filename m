Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69FBC43217
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 22:34:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 340BC4B0AC;
	Thu,  3 Nov 2022 18:34:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jy85hSzUO9IP; Thu,  3 Nov 2022 18:34:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0C6549F51;
	Thu,  3 Nov 2022 18:34:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0F7949ED7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 18:34:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2UDSvo6Y0Atm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 18:34:15 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 827E44106C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 18:34:15 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id u6so3251343plq.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 15:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=ldFAJy69ux+7z8nNCEANq8kYxugZwXEN2GoxlipQK+E=;
 b=mkCIQ7bnuqf5rnZcP6hp5JREtMJ78/S1f1OWtkJaTeRse5OVZRNDMID1AYpz+jBJzg
 eTpW9c3Fpt1GJSjywJBWRecDimPLsqOLfN7Nt46XLz4VoW6wiMtnGP3QRSBmWb2Jy2Ue
 XIrU3j6Zv6WjRE+wBsl7MInjLBoh0ETGKk290BPhyym2xqAHPTTSp2piVfBSnA5Xqpa6
 3LkVfTkbpSA7y+3xQukW44oEvhoV3ll0HshYQg8WmMixLpenp+usLAkNlELtK9JmVVTO
 f4CyPp1jxX+2aW0ZdvzjRbMLb0KbcueA1rrAX1kSu3aGK0UrE4ad6SuEvUCcApyckgBR
 ztmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ldFAJy69ux+7z8nNCEANq8kYxugZwXEN2GoxlipQK+E=;
 b=WcFuKWYt6Ff3qxCFkQH1TmjrEq8nlNCXGleyY/XrlaVUUQqGBC1qEFBfqeugvfuwVr
 YPVJc5rl/dCji/lb3tyZD2UZZDdLLhEhbfSe5u+P7cUxOsPTe6++LaQbOM+9u6BhNVmR
 CiR2UNGrtk+6I5X2uQGz9K2H0mkV0BOTMrx6+fGIKdYoIPzTyuZN8Clq58jcYC9wa87I
 d6PB+4O2H2yDAQ1Rk6J0Q05qjBucJhg7pzwwCmdRvCIPzbqvcBH4oB+XrKo9lB1UEmgL
 ht1z3DoUDFtyp8VNaYZ2XqRTW8wQBGoa2Pc9XQKJhfHsKGx1BOJImziOeTqm6TW77x7U
 eIIg==
X-Gm-Message-State: ACrzQf1lpU/LEH6fz5gLR/S6OXtR/WHCUb2tcoeyeaDAvkhUChgpKqe0
 A0CvdbtM/+rTH8+ePBE0AmpuzA==
X-Google-Smtp-Source: AMsMyM4x/1h/4H3vdmKr9CnvGb6Osipgsi8YDrhqpMcYmjYNzerzqYc2UHi5AhKhfTxXN1DVaborYg==
X-Received: by 2002:a17:90a:6045:b0:212:fe9a:5792 with SMTP id
 h5-20020a17090a604500b00212fe9a5792mr49415367pjm.178.1667514854306; 
 Thu, 03 Nov 2022 15:34:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 u10-20020a170902e80a00b00186ad73e2d5sm1151929plg.208.2022.11.03.15.34.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 15:34:13 -0700 (PDT)
Date: Thu, 3 Nov 2022 22:34:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Message-ID: <Y2RB4qT02EkhMjPL@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
 <20221103210402.GB1063309@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221103210402.GB1063309@ls.amr.corp.intel.com>
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

On Thu, Nov 03, 2022, Isaku Yamahata wrote:
> On Wed, Nov 02, 2022 at 11:19:03PM +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f223c845ed6e..c99222b71fcc 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1666,7 +1666,7 @@ struct kvm_x86_nested_ops {
> >  };
> >  
> >  struct kvm_x86_init_ops {
> > -	int (*check_processor_compatibility)(void);
> > +	int (*check_processor_compatibility)(int cpu);
> 
> Is this cpu argument used only for error message to include cpu number
> with avoiding repeating raw_smp_processor_id() in pr_err()?

Yep.

> The actual check is done on the current executing cpu.
> 
> If cpu != raw_smp_processor_id(), cpu is wrong. Although the function is called
> in non-preemptive context, it's a bit confusing. So voting to remove it and
> to use.

What if I rename the param is this_cpu?  I 100% agree the argument is confusing
as-is, but forcing all the helpers to manually grab the cpu is quite annoying.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
