Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA80C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 11:47:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 371D94B08F;
	Fri,  4 Nov 2022 07:47:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 17tXwRdL8nzV; Fri,  4 Nov 2022 07:47:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C60FC49673;
	Fri,  4 Nov 2022 07:47:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22A6349F3B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 03:18:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RfssZ64mHsVh for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 03:18:22 -0400 (EDT)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF6924141A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 03:18:21 -0400 (EDT)
Received: by mail-pj1-f45.google.com with SMTP id
 d13-20020a17090a3b0d00b00213519dfe4aso3927735pjc.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 00:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
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
 b=BVIVZimTZSO16fqeHnFpv5nXKLtvbPX1TKww5vNqO7/JxWxMsdNaRwrXqvNM9R+6kC
 ZfJtlPDlQabCq+0Ru+2PktKsujtTVhJydjvTXy5BVHuDoEnf8k9QLWNd/N6aAF8KDyQY
 Qc9EstQoWxRCbecBaH4zBUlYnfPeO+0ortJZWeC3zeyTIXR3tKCjEXhkOGyzNOEdMdpq
 gxxEP0wRmLnr7KKJCGCyf3kEDCOVEMaJG8zsJwjq07wzMp/Pz1xqAw226r/VQQIwYNFF
 PwqHqtJQBvzc4KlTMAYjNEBd43+4j/WHbI1zdlAEBgxFf5yjYTwWcJd7x950OBxMksyh
 +M8A==
X-Gm-Message-State: ACrzQf0tLdIR7kLYlnO3dn2YKwsXJciLPu8Sqv7R7cotzYcawLO3dwDJ
 G9gSyIZEFcvoE8aQqnawfdY=
X-Google-Smtp-Source: AMsMyM44DihVYXeoqfThPObIIFl16q8Fgq5Ol1s8X3KRnlnJD5T+n/qjAhXcJhbg7QI1HMtgLqbViQ==
X-Received: by 2002:a17:902:d592:b0:17a:582:4eb with SMTP id
 k18-20020a170902d59200b0017a058204ebmr34136415plh.40.1667546300864; 
 Fri, 04 Nov 2022 00:18:20 -0700 (PDT)
Received: from localhost ([192.55.54.55]) by smtp.gmail.com with ESMTPSA id
 y9-20020a17090322c900b00186f0f59c85sm1854838plg.235.2022.11.04.00.18.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 00:18:20 -0700 (PDT)
Date: Fri, 4 Nov 2022 00:18:19 -0700
From: Isaku Yamahata <isaku.yamahata@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Message-ID: <20221104071819.GD1063309@ls.amr.corp.intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
 <20221103210402.GB1063309@ls.amr.corp.intel.com>
 <Y2RB4qT02EkhMjPL@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y2RB4qT02EkhMjPL@google.com>
X-Mailman-Approved-At: Fri, 04 Nov 2022 07:47:47 -0400
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Yuan Yao <yuan.yao@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Isaku Yamahata <isaku.yamahata@gmail.com>,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Chao Gao <chao.gao@intel.com>,
 Eric Farman <farman@linux.ibm.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
