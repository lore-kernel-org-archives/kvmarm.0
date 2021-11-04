Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBC3C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 14:18:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B9690611C3
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 14:18:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B9690611C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D72E4B1BA;
	Thu,  4 Nov 2021 10:18:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FbMGql2HU3Mp; Thu,  4 Nov 2021 10:18:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A181C4B19F;
	Thu,  4 Nov 2021 10:18:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A03244B19A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 10:18:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DVCF4JNvH3YV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Nov 2021 10:18:32 -0400 (EDT)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BD634B199
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 10:18:32 -0400 (EDT)
Received: by mail-pg1-f177.google.com with SMTP id e65so5537291pgc.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 07:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GgU1oUsck/kv7V8rA9YPXtLGsU5UGF/lzeg6fggjKVY=;
 b=RTR1r+Ui0w7nUSHbbKl234uth/uzF1T7qF0sliOvvfsRTTb+Ux1LBt/ffQdTAY+/ec
 E1O0cYaxUcP9JJO91gsHWRMciPl/F1cyjYk822jBCR9TBPiuByHH3wQyg8CO0RsG69s3
 xxzxbxhqtVhFtR1IL3PwpUwYtMOSHDPFnwjUBiz3EACBzoEuXHLTOpHAkW6OfrqPvopQ
 XlcXyGEUw7b6wzkLr4K8OvDzbhOksbBNbi3EmpkiMJmFBXoGv87f+9auU+g0UJJslfkq
 YHd6yOra6jxs1gpwYkmD3+RM+zmhPNdO2qhY5Blp/Ql4/z42+YEAbgjAkELLYFLa2Wdb
 1tBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GgU1oUsck/kv7V8rA9YPXtLGsU5UGF/lzeg6fggjKVY=;
 b=Ju0ezugTwzbSzopxnJfMjxWKrUaf3pug6xEHFL1Uf/NE11IOQNrdz3MV7B8UQMNDT5
 OmnIuaY9jSZeSMKMCFe1aH8zZ2yIzd0+3iF9H753YlP2rJqrH+o+UyYi5l1659pg6iK7
 pNZuzBYD79q9gOdcfkwK1dDigFCPUHiR4qjIB2vP1hDEx+3QxbIGIrOd+uOTInKCgT3A
 uDW1mR8/ty9oZF5+Un7dRWfz1Qnt9OeHYrmY0L6JHtry7pgeY970gX1T350VCx/c7OSt
 3pYLV3cmaBL9qPMsPdgSQUP7PvTEMasIZ8XWObQJSLfYQN0tt9UXrRN34PR/b89c0/S2
 tOXw==
X-Gm-Message-State: AOAM533MS9qJtYnh9Z9Wj6rmHU13XxbbF1dkVDxIFZlgg+TwKddodC4n
 OETTv8B1HmfNIjwY+StJgfpXaQ==
X-Google-Smtp-Source: ABdhPJxdt1yraCn5ATAvpc1jCPrfM/2fIu0pWDknNbK+x2XDbxsbKhM1gzBOeaAuduFP4pk+NDgWGQ==
X-Received: by 2002:a65:5b01:: with SMTP id y1mr22260090pgq.451.1636035510920; 
 Thu, 04 Nov 2021 07:18:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id c9sm4061004pgq.58.2021.11.04.07.18.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Nov 2021 07:18:30 -0700 (PDT)
Date: Thu, 4 Nov 2021 14:18:26 +0000
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v3 01/16] perf: Ensure perf_guest_cbs aren't reloaded
 between !NULL check and deref
Message-ID: <YYPrst2CUBXLYc9h@google.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-2-seanjc@google.com>
 <77e3a76a-016b-8945-a1d5-aae4075e2147@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <77e3a76a-016b-8945-a1d5-aae4075e2147@gmail.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Vincent Chen <deanbo422@gmail.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xenproject.org,
 Albert Ou <aou@eecs.berkeley.edu>, Zhu Lingshan <lingshan.zhu@intel.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Thu, Nov 04, 2021, Like Xu wrote:
> On 22/9/2021 8:05 am, Sean Christopherson wrote:
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 464917096e73..80ff050a7b55 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -6491,14 +6491,21 @@ struct perf_guest_info_callbacks *perf_guest_cbs;
> >   int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
> >   {
> > -	perf_guest_cbs = cbs;
> > +	if (WARN_ON_ONCE(perf_guest_cbs))
> > +		return -EBUSY;
> > +
> > +	WRITE_ONCE(perf_guest_cbs, cbs);
> 
> So per Paolo's comment [1], does it help to use
> 	smp_store_release(perf_guest_cbs, cbs)
> or
> 	rcu_assign_pointer(perf_guest_cbs, cbs)
> here?

Heh, if by "help" you mean "required to prevent bad things on weakly ordered
architectures", then yes, it helps :-)  If I'm interpeting Paolo's suggestion
correctly, he's pointing out that oustanding stores to the function pointers in
@cbs need to complete before assigning a non-NULL pointer to perf_guest_cbs,
otherwise a perf event handler may see a valid pointer with half-baked callbacks.

I think smp_store_release() with a comment would be appropriate, assuming my
above interpretation is correct.

> [1] https://lore.kernel.org/kvm/37afc465-c12f-01b9-f3b6-c2573e112d76@redhat.com/
> 
> >   	return 0;
> >   }
> >   EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
> >   int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
> >   {
> > -	perf_guest_cbs = NULL;
> > +	if (WARN_ON_ONCE(perf_guest_cbs != cbs))
> > +		return -EINVAL;
> > +
> > +	WRITE_ONCE(perf_guest_cbs, NULL);
> > +	synchronize_rcu();
> >   	return 0;
> >   }
> >   EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
