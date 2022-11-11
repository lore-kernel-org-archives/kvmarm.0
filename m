Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDACC43217
	for <kvmarm@archiver.kernel.org>; Fri, 11 Nov 2022 00:06:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79BA84BAA9;
	Thu, 10 Nov 2022 19:06:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XJ65oi90N3bX; Thu, 10 Nov 2022 19:06:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 925ED4BACC;
	Thu, 10 Nov 2022 19:06:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CF5C4BAC7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 19:06:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OTvqMJts5uhn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 19:06:13 -0500 (EST)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9AA694BAA9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 19:06:13 -0500 (EST)
Received: by mail-pf1-f171.google.com with SMTP id k15so3503212pfg.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 16:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=sXQg6m0KDTXTm2nqz+lTg6WMBvdzJA0Ss4aaQqsqfi0=;
 b=hNVPv+ey8HIvOZmC+WAnWIG8OYAeSlZS0xPLzYhDCZmnArotz5Y/nhfn9r9c8PCEFe
 E8mVjVIva+def9PHp762BmRXmUoK5jg3heR3NAusrpN5STPSFfkervClje0NQa5CwXrE
 HdlsTtSUM+MPo4+vdGUA38aqr644tAa7P5bI3VxUrx5hCBiuVMLzUakeu0v8EjWAOK7v
 BgVrNZDyAWChq0qRi87Yhdn0EcEzkTu6Ae/6zTz8SPVNgwEGA83vKScQ/P1+h2fj3QJH
 Ic9NMyWV4IhkYFZTb5wG6PyKY3kSFDqOOs7F1TgAuJpwI7fBOge9ep4GrU+eZD7ML8Bk
 8lbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=sXQg6m0KDTXTm2nqz+lTg6WMBvdzJA0Ss4aaQqsqfi0=;
 b=j6OXVuaumtuGuQVwSQhWEu4ojlJdrbOVl6IeYha4bQTu0PyR9l9mrrIdihpPSKwbOD
 SasYVHcg0uC7Z4F54y3HIpZKuPY+2hFwRaUTxBJjT9UgKuU2XWPmXtsOiK1puwDGuDkZ
 ZMnrCirobwlRdpocayCHURxrW3tAERKNMCAdAORq7wWWYFQkCPHtqF4D+Y+vN1XFFz1F
 57bAFcG19g93yRm8+njBjfl9GLLaeoIKT8f2FTiFY1YWx/2UITNKIgWeC4yRIbwGdvoL
 l+A41sBpoD4wF2Rt3BR4akIcvFn9xTOkLpxI8VWnIGsvxB+ItA8+dc6cVaSnn8w7pxgA
 tsWA==
X-Gm-Message-State: ACrzQf0drCUjAMG6tGv7CFuZapmuo0NnCxlQCWoLh+5j1B6Y8qYsMB+4
 gBJ7i58LKe8Z+3ZMTqgmEgV3kQ==
X-Google-Smtp-Source: AMsMyM4gD1W2r9wxYtObzCBR9GM6UAk6Hoer15K7R44TK7byNmqvji7Uiit5OvUTQRObzAPBYqhIPw==
X-Received: by 2002:a05:6a00:bef:b0:56e:3a98:1089 with SMTP id
 x47-20020a056a000bef00b0056e3a981089mr3906306pfu.38.1668125172489; 
 Thu, 10 Nov 2022 16:06:12 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 s18-20020a170903215200b00186a6b6350esm234146ple.268.2022.11.10.16.06.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 10 Nov 2022 16:06:12 -0800 (PST)
Date: Fri, 11 Nov 2022 00:06:08 +0000
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Message-ID: <Y22R8GAvcuoWBELA@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
 <20221103210402.GB1063309@ls.amr.corp.intel.com>
 <Y2RB4qT02EkhMjPL@google.com>
 <20221104071819.GD1063309@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221104071819.GD1063309@ls.amr.corp.intel.com>
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

On Fri, Nov 04, 2022, Isaku Yamahata wrote:
> On Thu, Nov 03, 2022 at 10:34:10PM +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Thu, Nov 03, 2022, Isaku Yamahata wrote:
> > > On Wed, Nov 02, 2022 at 11:19:03PM +0000,
> > > Sean Christopherson <seanjc@google.com> wrote:
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index f223c845ed6e..c99222b71fcc 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1666,7 +1666,7 @@ struct kvm_x86_nested_ops {
> > > >  };
> > > >  
> > > >  struct kvm_x86_init_ops {
> > > > -	int (*check_processor_compatibility)(void);
> > > > +	int (*check_processor_compatibility)(int cpu);
> > > 
> > > Is this cpu argument used only for error message to include cpu number
> > > with avoiding repeating raw_smp_processor_id() in pr_err()?
> > 
> > Yep.
> > 
> > > The actual check is done on the current executing cpu.
> > > 
> > > If cpu != raw_smp_processor_id(), cpu is wrong. Although the function is called
> > > in non-preemptive context, it's a bit confusing. So voting to remove it and
> > > to use.
> > 
> > What if I rename the param is this_cpu?  I 100% agree the argument is confusing
> > as-is, but forcing all the helpers to manually grab the cpu is quite annoying.
> 
> Makes sense. Let's settle it with this_cpu.

Finally got to actually change the code, and am not a fan of passing "this_cpu"
everywhere.  It's not terrible, but it's not clearly better than just grabbing
the CPU on-demand.  And while manually grabbing the CPU in the helpers is annoying,
in at least two cases the pain is just shifted to the caller.

I'm going with your original suggestion of just grabbing raw_smp_processor_id()
in the helpers that print the error message.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
