Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA1DC49EA6
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 10:14:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9450C613FD
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 10:14:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9450C613FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F21CD4B26E;
	Thu, 24 Jun 2021 06:14:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YapjamRdGJsy; Thu, 24 Jun 2021 06:14:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C46864B26F;
	Thu, 24 Jun 2021 06:14:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42FE84B26D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 06:14:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qfJpgWTeFCVI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 06:14:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26FCA4B26C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 06:14:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624529640;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=qgeFYkU0pR1Q1xO1W6kYeH0XfpPQ577wwQcLewdoy9I=;
 b=C4fJMYlyXOYFpPhsPy1vz2dgiKNtgYeXnf2Y6/fmC4MIieSXk2suAoRLv2d06iqAl6PY01
 3Nz1og9YsiGkL3UJjq91DaNiVB2jGqB5uoOuS6mIom482jv7bm5fjAjBzrAWCmphS38SVN
 2lIADXMQJUlWrTg6XHU3hw4qPYrlkfY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-9-o017UEODm8s79eEVt6fQ-1; Thu, 24 Jun 2021 06:13:56 -0400
X-MC-Unique: 9-o017UEODm8s79eEVt6fQ-1
Received: by mail-wr1-f70.google.com with SMTP id
 v8-20020a5d43c80000b029011a94e052f2so2027117wrr.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 03:13:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=qgeFYkU0pR1Q1xO1W6kYeH0XfpPQ577wwQcLewdoy9I=;
 b=sIhobnTN7rOmF2Gm3EvtFhNE7fiGjECtWCwfJnetE4ZF2yMy5rID8vdYPRVMGmbaUS
 9016frwMmVi1jp8sNP9Tz2YuIw73lS3JhfdIT623ZchNuCb2RSvYidn1ws6ZR+b4cY6m
 fz3bFgZXXE9TuP3mENCOB5ugHkW+AOLwXF8p8kt1QUsptBWp/jRhO0ENXtf3DKMwtJcm
 Y05eFtK3tRbIAuv6HP+iGI6MSv+47sLFK5FWncDvtUelKedm4LnQaDgAoX5/HGuL+C+5
 BBbJdJ7Ux2+XxKJLRgWV/GDmRHW4Zb1QotEivmtJfWU+1s8M0EK87n2dv5W209E0WKVy
 5tGg==
X-Gm-Message-State: AOAM530tKX35iMTarapudXkd4waogXTwqMYwBpbvDCeEGLbe/uqzFYbH
 R39sSUR0ZWWsSQ9P36AWfFyv0iza10ietogs7cHcUC8BMabp+duOdGEIoV9uh0wh5oQLwbEJ4zO
 NkmjPXi5QYK1HyQ+tBALdML06
X-Received: by 2002:adf:e80c:: with SMTP id o12mr3526090wrm.425.1624529635786; 
 Thu, 24 Jun 2021 03:13:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwystGI+L9gOrbELlIiJWJblqcplIdniKN++kkqVaKxE8NfJktozv1x7SoGv2eSTMa2UzUKpw==
X-Received: by 2002:adf:e80c:: with SMTP id o12mr3526053wrm.425.1624529635607; 
 Thu, 24 Jun 2021 03:13:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id q19sm8207562wmc.44.2021.06.24.03.13.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 24 Jun 2021 03:13:55 -0700 (PDT)
Subject: Re: [PATCH 2/6] KVM: mmu: also return page from gfn_to_pfn
To: Nicholas Piggin <npiggin@gmail.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>, David Stevens <stevensd@chromium.org>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-3-stevensd@google.com>
 <1624524331.zsin3qejl9.astroid@bobo.none>
 <201b68a7-10ea-d656-0c1e-5511b1f22674@redhat.com>
 <1624528342.s2ezcyp90x.astroid@bobo.none>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bbbd7334-5311-a7b4-5dec-8bc606f1d6c9@redhat.com>
Date: Thu, 24 Jun 2021 12:13:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1624528342.s2ezcyp90x.astroid@bobo.none>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 kvm-ppc@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-mips@vger.kernel.org,
 intel-gvt-dev@lists.freedesktop.org, Joerg Roedel <joro@8bytes.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 24/06/21 11:57, Nicholas Piggin wrote:
>> Needing kvm_pfn_page_unwrap is a sign that something might be buggy, so
>> it's a good idea to move the short name to the common case and the ugly
>> kvm_pfn_page_unwrap(gfn_to_pfn(...)) for the weird one.  In fact I'm not
>> sure there should be any kvm_pfn_page_unwrap in the end.
>
> If all callers were updated that is one thing, but from the changelog
> it sounds like that would not happen and there would be some gfn_to_pfn
> users left over.

In this patches there are, so yeah the plan is to always change the 
callers to the new way.

> But yes in the end you would either need to make gfn_to_pfn never return
> a page found via follow_pte, or change all callers to the new way. If
> the plan is for the latter then I guess that's fine.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
