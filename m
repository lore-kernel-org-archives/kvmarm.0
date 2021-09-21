Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682B1C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0995C61100
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0995C61100
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A378C4B11F;
	Wed, 22 Sep 2021 09:12:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7r-c8gsNhL6D; Wed, 22 Sep 2021 09:11:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A61934B187;
	Wed, 22 Sep 2021 09:11:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A02B949DE3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 19:22:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AvdlTunzH90R for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 19:22:15 -0400 (EDT)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 83DCE407ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 19:22:15 -0400 (EDT)
Received: by mail-pf1-f169.google.com with SMTP id m26so1050652pff.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 16:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=SrgpsGNJ8rqjyV4/EJo88O9IIQbG0UxIB/O/sCFEHCQ=;
 b=Aek6S4Ex4HL+FlRX8wezQ0nSn8PZPLVSwGFM6Tuf5Vb5PRgM0t3QLU9WUHFeTsdzAU
 QtJBZLxCtSTzHjvsrBDZHuAtRs8M/UcTtn16UVPyICkA/9SmSo6/wgDRXNjilfk6+22r
 W51t+bozYpGIBCS76o+pBdu3BTXYTvAYrWg54kKw/zUklVknkRQaSR+HYh+NPP+yi8y9
 Yb/gjfeOPPT4vB//YCwqd+j/uNNgvnBzGOO9gtxuEZPi7zBRKotpsZHqTtUaIjyqVYgT
 sIUYBMdsmRG8oPPacCtBAXZP+CTj2FLeluAQ6fbuqzgy0II1EfOxhsPqM2kyF7AdcmHW
 W4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SrgpsGNJ8rqjyV4/EJo88O9IIQbG0UxIB/O/sCFEHCQ=;
 b=6poU55XczxzRBOn9wplyUPpn/AlLfv5vtsWyUs58Y+u9NLuWMDFCNaAr6aiTk53YB3
 rP93rc7t0rlhh5z3gcRLiFtw9afQzS6EdoTGM6J9BontMufLjA2jZxHPYUk4AsZDwTQS
 eiMTKN8SJ8yPVKEeSYbivTBixKms8wAPJ1ErXE0FFfHRiaZecuv/41rzh+jdmjUo5TRG
 TS5Lv88Fx1eRzGLDNFp/Qjmpje58/g0OmvvFCyhyN0tXxK13hhB8E3gXPZGeqc+3ufqu
 EyNAqAWye8A12mYULUCd8XBkOPjOWG1uJJ27pwcMuPIOe4yh5L8lU1UWu0LA8qH+ISvv
 STQA==
X-Gm-Message-State: AOAM53185C+zF9YCueADu81EWGWKLvE6fM7YFqLQ5kDu7mrx1eHUqEgw
 4USAUxQ+LMZoVnv3qbz6A6DGSw==
X-Google-Smtp-Source: ABdhPJztKWJhnn4ll+uIjZV6ppsKBX5LhsnC09hXPT7pT0HwfgdemziHQj0i0h1tKYzjFbRFxZd+Gw==
X-Received: by 2002:a63:bf07:: with SMTP id v7mr30381034pgf.333.1632266534266; 
 Tue, 21 Sep 2021 16:22:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id gp11sm3483849pjb.2.2021.09.21.16.22.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Sep 2021 16:22:13 -0700 (PDT)
Date: Tue, 21 Sep 2021 23:22:09 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Zhu, Lingshan" <lingshan.zhu@intel.com>
Subject: Re: [PATCH V10 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <YUppIQxphCUK6ZLS@google.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
 <20210806133802.3528-2-lingshan.zhu@intel.com>
 <YSfykbECnC6J02Yk@google.com>
 <186c330e-be42-4c49-545c-8f73573b5869@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <186c330e-be42-4c49-545c-8f73573b5869@intel.com>
X-Mailman-Approved-At: Wed, 22 Sep 2021 09:11:52 -0400
Cc: wanpengli@tencent.com, Like Xu <like.xu@linux.intel.com>,
 peterz@infradead.org, eranian@google.com, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kan.liang@linux.intel.com, ak@linux.intel.com,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, joro@8bytes.org,
 x86@kernel.org, linux-csky@vger.kernel.org, wei.w.wang@intel.com,
 linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org,
 liuxiangdong5@huawei.com, bp@alien8.de,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, boris.ostrvsky@oracle.com,
 jmattson@google.com, like.xu.linux@gmail.com, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
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

On Wed, Sep 15, 2021, Zhu, Lingshan wrote:
> 
> 
> On 8/27/2021 3:59 AM, Sean Christopherson wrote:
> > TL;DR: Please don't merge this patch, it's broken and is also built on a shoddy
> >         foundation that I would like to fix.
> Hi Sean,Peter, Paolo
> 
> I will send out an V11 which drops this patch since it's buggy, and Sean is
> working on fix this.
> Does this sound good?

Works for me, thanks!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
