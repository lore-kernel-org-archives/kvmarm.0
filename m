Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB7FC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 16:50:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 263314BAFE;
	Thu, 10 Nov 2022 11:50:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u1AJwH0w3e-B; Thu, 10 Nov 2022 11:50:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE7424BAED;
	Thu, 10 Nov 2022 11:50:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F26C14BAB1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 11:50:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ayV6pC9ACMef for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 11:50:37 -0500 (EST)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F4B14BAAD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 11:50:37 -0500 (EST)
Received: by mail-pf1-f179.google.com with SMTP id g62so2689913pfb.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 08:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=ngpTqFXA20Qov7vlYrPcJjUI8sUR/quxgJrGzBa7LTQ=;
 b=dFHHoN/Nh+VXrE9JsY3e3+fkRaRAvb1aGnzgeGfgDdwTgSMupLwM8ROA3+W4pYGjY0
 5rtK6lElI+DgF0DyaiLvpiaAorCWCegKieghDDMY6o0ECE7iPV/tCP64EmRRyb1QKnLg
 h1cjN79kb5l9jgix2MCBmxfqZYQuwhlkODvDz7ZvaH4sxe61Ml97iSmSMtvAoCeE4p6S
 zdFuv8u4MZbd4uwMLlGMYvkNsSjoXRG5kz2GxfEgOPys7+fCqRAsVr0dupEjPva4LkLJ
 QEyjxBRtbWEN1lQAedlvI4TNbWVV6gyxLgVr0x17HRSOYZcACGBuRj0/yzFNApiBrJr+
 O6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ngpTqFXA20Qov7vlYrPcJjUI8sUR/quxgJrGzBa7LTQ=;
 b=HTmBmT49VebMM76tYyJgs66jlZEx6bJvoBnKslSF29C5xOZkXEXJw1sIRCQDIP75wy
 2pSOizBhIioickIFF3NBw7vT4pire73Dpx1gPaEFRqzuJSsbIMDKlM9Uq36j6aJUSN0c
 EkE/SvVam1WXgbNrbLIikWxLXRz/I+CZZjHRrP+R5kfvDIg15WmiNRF2kGZLHFCV3Qf7
 iET3jdWEETEDb8s7uTy1t37MaZ66YXJYkx9mCHFn09gv1H7Ywc3jT9yCBFBZsnYPj8ZL
 r/N7b/FHupagh/Ii4JBxSK9CtFWotI9ruK71hHj7ahY2aOSDtahIQ6irZOz74Q0rnJEk
 tslg==
X-Gm-Message-State: ACrzQf2iS/JlMbpw+E1L2olPYrTWQ/70wdUsPdyD7Y3HNQuLHFuBdXHq
 GGXdRrEqcjaYSpkqiybj13vOIg==
X-Google-Smtp-Source: AMsMyM41GjMawKBCP5Kop4vnrwekEGW/LOSR6lYqiErYbTmquFxjglLK4Ryhg/mdPPwnXrGhT3xNoQ==
X-Received: by 2002:aa7:8d08:0:b0:56b:a4f6:e030 with SMTP id
 j8-20020aa78d08000000b0056ba4f6e030mr3031241pfe.85.1668099036440; 
 Thu, 10 Nov 2022 08:50:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 m2-20020a170902db0200b00186f81bb3f0sm11518667plx.122.2022.11.10.08.50.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 10 Nov 2022 08:50:35 -0800 (PST)
Date: Thu, 10 Nov 2022 16:50:32 +0000
From: Sean Christopherson <seanjc@google.com>
To: Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH 32/44] KVM: x86: Unify pr_fmt to use module name for all
 KVM modules
Message-ID: <Y20r2NR9MaBbOGLn@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-33-seanjc@google.com>
 <ff0e8701d02ee161d064f92c8b742c2cc061bce0.camel@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ff0e8701d02ee161d064f92c8b742c2cc061bce0.camel@linux.intel.com>
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

On Thu, Nov 10, 2022, Robert Hoo wrote:
> After this patch set, still find some printk()s left in arch/x86/kvm/*,
> consider clean all of them up?

Hmm, yeah, I suppose at this point it makes sense to tack on a patch to clean
them up.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
