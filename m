Return-Path: <SRS0=nyIz=OH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62997C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Sep 2021 08:46:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0425B61056
	for <kvmarm@archiver.kernel.org>; Fri, 17 Sep 2021 08:46:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0425B61056
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C6E54B099;
	Fri, 17 Sep 2021 04:46:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TOpSYDwKMjlA; Fri, 17 Sep 2021 04:46:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01ED34B0E7;
	Fri, 17 Sep 2021 04:46:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05F3E4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 18:30:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9kPh882KS4bM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 18:30:51 -0400 (EDT)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE8F14057F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 18:30:50 -0400 (EDT)
Received: by mail-pf1-f182.google.com with SMTP id b7so7244995pfo.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 15:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=SbpJPJ4GLHhtaxBB1xHIdRhJVAuKGVRHlo9Wp9BtXvg=;
 b=igafNvMA1/3Bo/Hn8R9+USa5il0ulFxjx+nPIh2XyZCbl93vTOyT82CSDzdcKRJJgO
 FkJ5tfOZgSqPwIB2uy13Vsv6TyxDZo5SSSg6NO0tCl0m6iggfHrPIgqTtDvi9KZvPNYG
 8S05G6PCVB/DKu6Qps+LsPTZQ05wevCQFNZ+BICkpGZZdeZrOwvM4eNTBKGGZV/zaEby
 /Uo1noNrpUpRnME+TSkjRKmfn4qrb0maTPZTyYR72JBGteB/DiewqWAa7W2K5Npk1E/o
 h4Ealz2zUj5Dq5lsSJIpFakB2CCLO0hEG1zQ+M9xbiD1cysQ1HBn46apv1+McHJBcrYb
 Amkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SbpJPJ4GLHhtaxBB1xHIdRhJVAuKGVRHlo9Wp9BtXvg=;
 b=ZHIe6qf096mMdSmztIc3zpLtu2QpbcJKR4Jw4foI6ravsoWqM+mrXhce/C5zJcEdZV
 GLAwoefwrvnAt/6FJQpJAPdTWWgpLgK3iVm5lVRC9tR/NuaYxJygA2pA5wLL9iNOm0SL
 40dPhYjfbmwv3/21pI9xv+zil841NmrnpnKFmkDq2JB8rIxo5bm7E6ros88CE/nw2WWj
 NyVtdKPpivjPSyEBb6llSVMFgZHUhs4i5d32QzQIG/RwwWo9S9TMFg+5T2KmCKPH8sUo
 3O70dwlBrViAcWtqPw7kCh347USPh6iv0aSxv/xaTglK2dAHOj79rzZiGJO3REepBP1r
 u6Ag==
X-Gm-Message-State: AOAM530loVQPRwPO8V3aw3OON5qCDwQ/Mae9pac2PFns4UrWAWm5J4NR
 /AA0vEcNiHaBrRrS+8V1pwicsA==
X-Google-Smtp-Source: ABdhPJx9Zno3oAszEpQSd/n4PnO2QNAuNkUGb12hjpp8HsLen9cxO4C/uNjsvLGvYRAHddpH9w+INQ==
X-Received: by 2002:a63:6ec9:: with SMTP id j192mr7022031pgc.115.1631831449675; 
 Thu, 16 Sep 2021 15:30:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id b1sm3951150pjl.4.2021.09.16.15.30.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Sep 2021 15:30:49 -0700 (PDT)
Date: Thu, 16 Sep 2021 22:30:45 +0000
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 05/13] perf: Force architectures to opt-in to guest
 callbacks
Message-ID: <YUPFlb6r1udRKcBH@google.com>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828003558.713983-6-seanjc@google.com>
 <20210828194752.GC4353@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210828194752.GC4353@worktop.programming.kicks-ass.net>
X-Mailman-Approved-At: Fri, 17 Sep 2021 04:46:52 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-csky@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Ingo Molnar <mingo@redhat.com>, Like Xu <like.xu.linux@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Zhu Lingshan <lingshan.zhu@intel.com>,
 Will Deacon <will@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Sat, Aug 28, 2021, Peter Zijlstra wrote:
> On Fri, Aug 27, 2021 at 05:35:50PM -0700, Sean Christopherson wrote:
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 55f9f7738ebb..9ef51ae53977 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1776,6 +1776,9 @@ config HAVE_PERF_EVENTS
> >  	help
> >  	  See tools/perf/design.txt for details.
> >  
> > +config HAVE_GUEST_PERF_EVENTS
> > +	bool
> 	depends on HAVE_KVM
> 
> ?

Ah, nice!  We can go even further to:

	depends on HAVE_PERF_EVENTS && HAVE_KVM

though I'm pretty sure all architectures that select HAVE_KVM also select
HAVE_PERF_EVENTS.

Huh.  arm64 doesn't select HAVE_KVM even though it selects almost literally every
other HAVE_KVM_* config.  arm64 has some other weirdness with CONFIG_KVM, I'll add
a patch or two to fix that stuff and amend this patch as above.

Thanks again!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
