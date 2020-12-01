Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95386C64E7B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:20:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5B56207FF
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:20:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="a5w9Ab02"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5B56207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E43B34BD0A;
	Tue,  1 Dec 2020 08:20:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O3JhUG+z+GwI; Tue,  1 Dec 2020 08:20:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1F1A4C1A1;
	Tue,  1 Dec 2020 08:20:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF34E4C1A1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:20:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X81vulUmyWds for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 08:20:35 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AADF94BD0A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:20:35 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id s8so2563592wrw.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Dec 2020 05:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2UsigzSoUrcWefZPVlh907PdAiwKvnJCxqM3bK865xE=;
 b=a5w9Ab02L7z/Ws6Swour5XHiDemqkyRoJMnrsjmQ7dP6ZLcdnSPl4rl7uCSoefsSgY
 CSEM/hSiuG2V+lMG6XWUBoFP+umx/Z1SVH3TjxButBNmxRpd+woEE6TVMNN9WHNpy5tJ
 ZEYGU8NtIHTuGypVh+KkDpgmLvcDC2pLG0Er10VjuCtRBenorREyUgLQLwVpFN6JBDEW
 ronnfqxfmwHhCPQ01dnSKmwWets/XfGXKFw/uOqsdAVJTRapDsOCz5sJzwWUOq1ktIfu
 4cGDQDzbuGu30W2f/qjd8TvucoBxOFs8kFxke2+S46bX1rPSzpW/5asHiBqkHtlmriyV
 MPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2UsigzSoUrcWefZPVlh907PdAiwKvnJCxqM3bK865xE=;
 b=rI7/sHxlzApZNIhFqoa5WoTsNB7tvr0iwhA+RYRt3w4a61XbM2z+H7z/rN8BitLtYm
 5zwNbxAUKn5Lt+bXu14z59YswonkvfDfpiTUfaDhUWVFh41aDqP9QIwFdrmdTwnef8CO
 65KERHorgKUjdPyk4Rszq3nL+2fCMCXo5bVkx/OLg+KPqhnCfhAWNLO0LWDaq6raFLF3
 aaKSJPx9csAf+K+r8rLRvVooqcL9qGB6wjGAJx3IlCTRI49JwKSC5+sLOrOnsxri2KZG
 MA3DZ89QMCBcBYvkNLTS4HGMjw9b2MLUrq+BZMi1uv0tqytRyx/JGSxxVwt3WVgnZJZ2
 pJSQ==
X-Gm-Message-State: AOAM5323R3jDDs7+tCvOKXxh951yaGR4Vj8mmaIUpMlWSI6YU80Wyjvb
 PFJkf0RcSAJk7VzE9dyu1t8iOA==
X-Google-Smtp-Source: ABdhPJyca9R4xKZARa2KQnxST/3CMFlBn6fpNOSPil/kBrj5VNBo6V2f44HqUyGs2N30XTmZGFFNLA==
X-Received: by 2002:a05:6000:c7:: with SMTP id
 q7mr3842571wrx.137.1606828834384; 
 Tue, 01 Dec 2020 05:20:34 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:7c5f:5ab5:ac1f:89ce])
 by smtp.gmail.com with ESMTPSA id u66sm2979560wmg.2.2020.12.01.05.20.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Dec 2020 05:20:33 -0800 (PST)
Date: Tue, 1 Dec 2020 13:20:32 +0000
From: David Brazdil <dbrazdil@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH v3 16/23] kvm: arm64: Forward safe PSCI SMCs coming from
 host
Message-ID: <20201201132032.we4jbsvtsngwixse@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-17-dbrazdil@google.com>
 <20201127165159.3s7hob5tgjcrbz33@bogus>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201127165159.3s7hob5tgjcrbz33@bogus>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Nov 27, 2020 at 04:51:59PM +0000, Sudeep Holla wrote:
> On Thu, Nov 26, 2020 at 03:54:14PM +0000, David Brazdil wrote:
> > Forward the following PSCI SMCs issued by host to EL3 as they do not
> > require the hypervisor's intervention. This assumes that EL3 correctly
> > implements the PSCI specification.
> > 
> > Only function IDs implemented in Linux are included.
> > 
> > Where both 32-bit and 64-bit variants exist, it is assumed that the host
> > will always use the 64-bit variant.
> > 
> >  * SMCs that only return information about the system
> >    * PSCI_VERSION        - PSCI version implemented by EL3
> >    * PSCI_FEATURES       - optional features supported by EL3
> >    * AFFINITY_INFO       - power state of core/cluster
> >    * MIGRATE_INFO_TYPE   - whether Trusted OS can be migrated
> >    * MIGRATE_INFO_UP_CPU - resident core of Trusted OS
> >  * operations which do not affect the hypervisor
> >    * MIGRATE             - migrate Trusted OS to a different core
> >    * SET_SUSPEND_MODE    - toggle OS-initiated mode
> >  * system shutdown/reset
> >    * SYSTEM_OFF
> >    * SYSTEM_RESET
> >    * SYSTEM_RESET2
> > 
> > Signed-off-by: David Brazdil <dbrazdil@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/psci-relay.c | 43 +++++++++++++++++++++++++++-
> >  1 file changed, 42 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> > index e7091d89f0fc..7aa87ab7f5ce 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> > @@ -57,14 +57,51 @@ static bool is_psci_call(u64 func_id)
> >  	}
> >  }
> >  
> > +static unsigned long psci_call(unsigned long fn, unsigned long arg0,
> > +			       unsigned long arg1, unsigned long arg2)
> > +{
> > +	struct arm_smccc_res res;
> > +
> > +	arm_smccc_1_1_smc(fn, arg0, arg1, arg2, &res);
> > +	return res.a0;
> > +}
> > +
> > +static unsigned long psci_forward(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	return psci_call(cpu_reg(host_ctxt, 0), cpu_reg(host_ctxt, 1),
> > +			 cpu_reg(host_ctxt, 2), cpu_reg(host_ctxt, 3));
> > +}
> > +
> > +static __noreturn unsigned long psci_forward_noreturn(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	psci_forward(host_ctxt);
> > +	hyp_panic(); /* unreachable */
> > +}
> > +
> >  static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
> >  {
> > -	return PSCI_RET_NOT_SUPPORTED;
> > +	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
> > +		return psci_forward(host_ctxt);
> > +	else if (func_id == kvm_host_psci_function_id[PSCI_FN_MIGRATE])
> > +		return psci_forward(host_ctxt);
> 
> Looks weird or I am not seeing something right ? Same action for both
> right ? Can't they be combined ?

Sure, happy to combine them. I thought visually it made sense to have one
action per ID.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
