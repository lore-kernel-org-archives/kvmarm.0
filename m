Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4D9C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 18:11:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A7C8F61038
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 18:11:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A7C8F61038
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BF984B0F3;
	Wed, 22 Sep 2021 14:11:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2kaSnkwvirEd; Wed, 22 Sep 2021 14:11:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 439D64B0F1;
	Wed, 22 Sep 2021 14:11:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA7634086F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 10:49:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t9GAoH4u19VZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 10:49:02 -0400 (EDT)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 868094079A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 10:49:02 -0400 (EDT)
Received: by mail-pf1-f176.google.com with SMTP id w19so2875680pfn.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 07:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=0sqc+8Rn23i9NIXRc3rzWglOlIsYoDOCKK+U0vVnVf8=;
 b=i17P/LE0kBMgmTnemIWdlFQzqY0Hs2jbI6I1/q7BOVL5p2dtOUMx0v77u9KgBVc6Wn
 aKV+BPEmJqQFBnpf2JgmIIqtssY8WUcJgn0PyaL+KfSiTDztZbnAplBfnqcfDhlXXfFn
 BjrKCa5IqUkRjskJLByrIP0vUAdGBFoOpGk78YEBagXPKCi9T3kxBnFA97BcpKw7BZcR
 bmLTSv6ivPklBCfoVzjL+iJjEelTUzY+vAJf7MF3MbJsLpnqXAXpI4Q3beusWaRqYBkI
 4OoNyyAV9qr/c1FTp2tfQsv3gnSyBPHEnLObwapHJkjxKwND1CbJf6lm69JT2lSfnhHf
 qYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=0sqc+8Rn23i9NIXRc3rzWglOlIsYoDOCKK+U0vVnVf8=;
 b=wLsYZdU3NII0/DMWB+fWyz1Am54A9i5Zyw7sgnIMz4ZnlddkjwhWiwVyMwLExBcX3l
 GdxwXzOcVid2qdN0ugM5kEVJAW4OaCz1Q2JdDZdxCPWApQB4tgoCNRJLJBIKC1Zzv9lK
 oBRZupeIBnkyPF0E+dWWOuT1xzU9fKiAjLjhj0w+aWifMMvqKXsbSx2aE+BEof3ztoy9
 NVxxEIy+9pTu/yLVUruJ82/wyxvDcBoMGQq2+VJ/LIp3tH6OSrLxOQ4ouE7y1uUBJzH2
 /HLsj37yhqCfRxUSu5vcoR9/aQXM4FsbQWZuLk2r2RSJ/0aUn5yWE5rZcSpsZruF8IRL
 ABfQ==
X-Gm-Message-State: AOAM531PtMQfoiGUoiObG8VDDvh0oVARr7x0hRHwUgHxdektgRgIuF0T
 /jOc/5Jb3na36w3q76Uxkr8sng==
X-Google-Smtp-Source: ABdhPJyY3Fv9QcnunPtvdtmn1QYeYqhfMcgkYKWmFqTAaf0DAX+dPQteKaq7uTqZ/uQmOkkrqsksfg==
X-Received: by 2002:a62:5fc7:0:b0:438:9e3a:b8c0 with SMTP id
 t190-20020a625fc7000000b004389e3ab8c0mr22443pfb.74.1632322141372; 
 Wed, 22 Sep 2021 07:49:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id x19sm3250084pgk.37.2021.09.22.07.49.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Sep 2021 07:49:00 -0700 (PDT)
Date: Wed, 22 Sep 2021 14:48:56 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 08/16] perf: Force architectures to opt-in to guest
 callbacks
Message-ID: <YUtCWOYJwCUYDYtW@google.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-9-seanjc@google.com>
 <f2ad98e2-ddfb-c688-65af-7ecbd8bc3b3d@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f2ad98e2-ddfb-c688-65af-7ecbd8bc3b3d@redhat.com>
X-Mailman-Approved-At: Wed, 22 Sep 2021 14:11:48 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Vincent Chen <deanbo422@gmail.com>,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-csky@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Like Xu <like.xu.linux@gmail.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Zhu Lingshan <lingshan.zhu@intel.com>, Will Deacon <will@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Wed, Sep 22, 2021, Paolo Bonzini wrote:
> On 22/09/21 02:05, Sean Christopherson wrote:
> > @@ -1273,6 +1274,11 @@ static inline unsigned int perf_guest_handle_intel_pt_intr(void)
> >   }
> >   extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
> >   extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
> > +#else
> > +static inline unsigned int perf_guest_state(void)		 { return 0; }
> > +static inline unsigned long perf_guest_get_ip(void)		 { return 0; }
> > +static inline unsigned int perf_guest_handle_intel_pt_intr(void) { return 0; }
> > +#endif /* CONFIG_GUEST_PERF_EVENTS */
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Having perf_guest_handle_intel_pt_intr in generic code is a bit off.  Of
> course it has to be in the struct, but the wrapper might be placed in
> arch/x86/include/asm/perf_event.h as well (applies to patch 7 as well).

Yeah, I went with this option purely to keep everything bundled together.  I have
no strong opinion.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
