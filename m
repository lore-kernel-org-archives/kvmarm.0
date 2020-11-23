Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4194EC2D0E4
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 14:03:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8361820738
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 14:03:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ltVKPu+m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8361820738
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0D094BB5E;
	Mon, 23 Nov 2020 09:03:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YpyCl3KqiIig; Mon, 23 Nov 2020 09:02:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C52A24BB1D;
	Mon, 23 Nov 2020 09:02:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C5604BA7C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 09:02:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UG-o646Fq1q2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 09:02:55 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92C624BABF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 09:02:55 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id s13so17335534wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 06:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8MbLOzoiGt8qOrDnUA/zH8u0u0zSMC0gXKfi559DqVA=;
 b=ltVKPu+mf3w4cnT/dnxBHhtwTdvH5234a5m0Aas+h+d2O+deloN4yvQEqWA5jdgL7J
 BBwCdHTKDne3rtZS0479aN3cO3cK+qHE6RJeFtQD88SABrLknnTJIWPt7vFegoL9JAMW
 tfJ66juRzDAMcoPc3Q0qet+A+HXN7V++y5x4xM2kc9zgzhx3h6U57HdwASSxRI5xat96
 BhPR4KyhD3Do/OEx1hLna61IZUxVJpjCstJkxu9okbRxbT/18JE9VgsD6QeRJo/OjI6z
 GfIEjP7OFlskU0BPW9s0Lm8eEjmI5XyUFsIp0EVclLPkh5UQlfPxKshKoo9TN39JqMei
 EP8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8MbLOzoiGt8qOrDnUA/zH8u0u0zSMC0gXKfi559DqVA=;
 b=S17sn1YNuL4dJq85KA/p/I2rhB1DXIfbKxrZEHAIE+BdcnKG0RnWThaJqbzO2Uo1Z0
 LhYaqxJw0q9azv9h0t3i1SBqXOXkliNzifjlYGgX3XIAdOwyCUnZLBZMLlyvjI3cq42S
 IEumdDkyOSLKtDko+R3jOFSvRzSahLpA01Wm8gTlVFj1A8ZluQ8qh1RQEkVrlstseXoa
 wWTptG9e+2MUfmGyaHHrWxY5BNoE5J8iLC8z/CCRZOeZb1Aw5a+I2r8DAKWyyz/JKJSb
 4pL3bhPLioF/DxwzT696RK7qZBTiWuWaBZI0vZgMrxlmkxMnAoUN+xPL2xI3lSF/8irg
 S0Cg==
X-Gm-Message-State: AOAM530carwwOV24Kg75+8rfRhjYWsntjb+DGcyz0RbtmfsHLBHjjQVU
 pLErxoG2HO1cY+dn7s/ByMn34Q==
X-Google-Smtp-Source: ABdhPJxjgLyk9Fulttys1g8vPl1CXFrXrd8EhtH74rQmWAECciCrmgsHxN+h0I4wxVN09sd5aywgVA==
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr23203780wmj.109.1606140174472; 
 Mon, 23 Nov 2020 06:02:54 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id x13sm8390719wmj.48.2020.11.23.06.02.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Nov 2020 06:02:54 -0800 (PST)
Date: Mon, 23 Nov 2020 14:02:50 +0000
From: Quentin Perret <qperret@google.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [RFC PATCH 09/27] KVM: arm64: Allow using kvm_nvhe_sym() in hyp
 code
Message-ID: <20201123140250.GB490744@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-10-qperret@google.com>
 <20201123125723.4mnodg3tnal4q4v2@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201123125723.4mnodg3tnal4q4v2@google.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Monday 23 Nov 2020 at 12:57:23 (+0000), David Brazdil wrote:
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 882eb383bd75..391cf6753a13 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1369,7 +1369,7 @@ static void cpu_prepare_hyp_mode(int cpu)
> >  
> >  	params->vector_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref(__kvm_hyp_host_vector));
> >  	params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
> > -	params->entry_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref(__kvm_hyp_psci_cpu_entry));
> > +	params->entry_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref_nvhe(__kvm_hyp_psci_cpu_entry));
> 
> Why is this change needed?

You mean this line specifically or the whole __kvm_hyp_psci_cpu_entry
thing?

For the latter, it is to avoid having the compiler complain about
__kvm_hyp_psci_cpu_entry being re-defined as a different symbol. If
there is a better way to solve this problem I'm happy to change it -- I
must admit I got a little confused with the namespacing along the way.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
