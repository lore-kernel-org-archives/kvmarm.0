Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6D5C11F68
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:21:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A59AD6141D
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:21:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A59AD6141D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213644B096;
	Fri,  2 Jul 2021 12:21:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aRD4w54Q3QuG; Fri,  2 Jul 2021 12:21:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA1F4A4BE;
	Fri,  2 Jul 2021 12:21:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B372240856
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:21:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qTNiA0IXxmdJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 12:21:13 -0400 (EDT)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D630A407A0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:21:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
 Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
 Sender:Reply-To:Content-ID:Content-Description;
 bh=1zeioteA+jdIxWL/dgp30Yr4n/h54VyVtqBx1y8dmpw=; b=fYXRPL+pdyd6pWTWgyqUpSCon6
 hVRsaqHU4sbIFMylpPESw6s1ds+Ne9pVmfvWssHCPh1tDhQ9NkyStK+h+EbWgWCnW12z5BtIVCdGe
 f+zT2Z6CPo0EeWU9hw197UGVVVwpfo/M/LWBBZmP19BuXpyZ9vOQSoLzX4yYf8flnCnzPjudhIe5I
 nAPW1UA4YFmGzh9Tr8facSLDTW5eGOBQNDmEGJQ9f2Ue8KDsvmGSbeYOcfg67qbyPcb5an5v85HpA
 uIFMkJLiWxHwoIg2+vPo84aLIc+3qyJICFoRdiDRt5ZJq1EXAve92cC7Nu/lybkzevKBEV34ZCENu
 mIazXrTg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
 helo=noisy.programming.kicks-ass.net)
 by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1lzLtX-007r9Y-4l; Fri, 02 Jul 2021 16:20:02 +0000
Received: from hirez.programming.kicks-ass.net
 (hirez.programming.kicks-ass.net [192.168.1.225])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (Client did not present a certificate)
 by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 65FA830007E;
 Fri,  2 Jul 2021 18:19:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
 id 484942B759E47; Fri,  2 Jul 2021 18:19:56 +0200 (CEST)
Date: Fri, 2 Jul 2021 18:19:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <YN88rE+cxb7HrEtI@hirez.programming.kicks-ass.net>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-2-lingshan.zhu@intel.com>
 <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
 <7379289718c6826dd1affec5824b749be2aee0a4.camel@perches.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7379289718c6826dd1affec5824b749be2aee0a4.camel@perches.com>
Cc: wanpengli@tencent.com, Like Xu <like.xu@linux.intel.com>,
 eranian@google.com, weijiang.yang@intel.com, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kan.liang@linux.intel.com, ak@linux.intel.com,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, joro@8bytes.org,
 x86@kernel.org, linux-csky@vger.kernel.org, wei.w.wang@intel.com,
 xen-devel@lists.xenproject.org, liuxiangdong5@huawei.com, bp@alien8.de,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, vkuznets@redhat.com,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 like.xu.linux@gmail.com, Nick Hu <nickhu@andestech.com>, seanjc@google.com,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 Zhu Lingshan <lingshan.zhu@intel.com>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Jul 02, 2021 at 09:00:22AM -0700, Joe Perches wrote:
> On Fri, 2021-07-02 at 13:22 +0200, Peter Zijlstra wrote:
> > On Tue, Jun 22, 2021 at 05:42:49PM +0800, Zhu Lingshan wrote:
> > > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> []
> > > @@ -90,6 +90,27 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86=
_pmu.pebs_aliases);
> > > =A0=A0*/
> > > =A0DEFINE_STATIC_CALL_RET0(x86_pmu_guest_get_msrs, *x86_pmu.guest_get=
_msrs);
> > > =A0
> > > =

> > > +DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
> > > +DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
> > > +DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest=
_cbs->handle_intel_pt_intr));
> > > +
> > > +void arch_perf_update_guest_cbs(void)
> > > +{
> > > +	static_call_update(x86_guest_state, (void *)&__static_call_return0);
> > > +	static_call_update(x86_guest_get_ip, (void *)&__static_call_return0=
);
> > > +	static_call_update(x86_guest_handle_intel_pt_intr, (void *)&__stati=
c_call_return0);
> > > +
> > > +	if (perf_guest_cbs && perf_guest_cbs->state)
> > > +		static_call_update(x86_guest_state, perf_guest_cbs->state);
> > > +
> > > +	if (perf_guest_cbs && perf_guest_cbs->get_ip)
> > > +		static_call_update(x86_guest_get_ip, perf_guest_cbs->get_ip);
> > > +
> > > +	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr)
> > > +		static_call_update(x86_guest_handle_intel_pt_intr,
> > > +				   perf_guest_cbs->handle_intel_pt_intr);
> > > +}
> > =

> > Coding style wants { } on that last if().
> =

> That's just your personal preference.

As a maintainer, those carry weight, also that's tip rules:

  https://lore.kernel.org/lkml/20181107171149.165693799@linutronix.de/
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
