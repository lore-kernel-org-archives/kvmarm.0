Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D833C64E7A
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:55:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48F9220770
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="eUJWOYMj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48F9220770
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77EC44C264;
	Tue,  1 Dec 2020 08:55:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OuX0B-D8sUQM; Tue,  1 Dec 2020 08:55:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27E4F4C267;
	Tue,  1 Dec 2020 08:55:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA39D4C224
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:55:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jkGaur6Zs1VN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 08:55:20 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABE284BC53
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:55:20 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id e25so5168801wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Dec 2020 05:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=+PwXtTlcdJC6Kz6wHrFVenV3uj6g4mhzGOO7PCwpUDQ=;
 b=eUJWOYMj7hUEXl+QsjBQLb4Ml91vgJpJhCrjpxbqM+50vIH2ZQr0o0DZ8eYxOZyD2o
 qwK6VPbpB7r9OpI2pQzstBVO51hojkHH/0EuWCbkVWnDnxeTGQwxo7VZuIIWqFp8HMiM
 HVgkn/F6eMzurxhiSQXvv2Die4eIq572mY627xAt4ltupWKvoFDcjH8wfMXyaRjTxDbK
 P2fC1SvegV0bW8P/NfopNX6pZGUs2h4/HoDwq+NF7H6ZGOjbQupT8yplG2TwaL5YU7QG
 05vaH8BrE584TyNyIOq9F5K2WiZHXZ6N946VYV9SAcc566zeIk1Xid5fVDSMBBlJVcV6
 Khrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+PwXtTlcdJC6Kz6wHrFVenV3uj6g4mhzGOO7PCwpUDQ=;
 b=rUKsmGhLA/zK9vydbTnJMnmEn5sX9yln0DzUM42fbGUmasp2VskdkbFxlNC4cE6TrD
 GX6fU2uHFQxG+Bz9+7pZC2c3qqj5HrggbqnIQt4UuDzp067of9djTkaLMNOtBK0X14Ba
 4tkTB2a214hT0hoi3p/FOaMQkWbSFcnbUXrQGXQ9FyBD+36WZXo6wCyyu6y3lt+azyZK
 7ZzJXl679PwNhlcUmIcOpwO91Ez9dKXjKRLo9FTXsx5lcNNxldidiQ18p8Y7LGvJ08SH
 CYQtIYJ/75DsqX0VpT3T2QIDLS4SJOoKMxlJlBnIPQIaLfpIurypAksR7vCGc+C65NY3
 sE9A==
X-Gm-Message-State: AOAM533XMXmnlgiTRn3Mu5SUrafCKO9zr+bC8ywT49xagNlNTbOXptow
 cwzVCnBMn+d4QRR0noWWHRzCUw==
X-Google-Smtp-Source: ABdhPJx0qfzSScy1bKvaj9lSd/UJsODYPKOs6sdmtZoDpxlKzd7namARNALtRyqKWoGJ6kLRj1q4lA==
X-Received: by 2002:a1c:e042:: with SMTP id x63mr2861883wmg.68.1606830918697; 
 Tue, 01 Dec 2020 05:55:18 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:7c5f:5ab5:ac1f:89ce])
 by smtp.gmail.com with ESMTPSA id b12sm10194961wmj.2.2020.12.01.05.55.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Dec 2020 05:55:17 -0800 (PST)
Date: Tue, 1 Dec 2020 13:55:16 +0000
From: David Brazdil <dbrazdil@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 05/23] arm64: Extract parts of el2_setup into a macro
Message-ID: <20201201135516.3ksifw3ynlxyok7k@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-6-dbrazdil@google.com>
 <20201126180608.GF38486@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201126180608.GF38486@C02TD0UTHF1T.local>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Hey Mark,

> In the head.S code, this was under an ifdef CONFIG_ARM_GIC_V3, but that
> ifdef wasn't carried into the macro here, or into its use below. I'm not
> sure of the impact, but that does seem to be a functional change.
> 
> > +
> > +.macro __init_el2_hstr
> > +	msr	hstr_el2, xzr			// Disable CP15 traps to EL2
> > +.endm
> 
> Likewise, this used to be be guarded by CONFIG_COMPAT, but that's not
> carried into the macro or its use.
> 
> If the intent was to remove the conditionality, then that should be
> mentioned in the commit message, since it is a potential functional
> change.

Apologies, and well spotted. Marc suggested removing the ifdefs as redundant
during his review of v2. I'll update the commit message to reflect that.

David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
