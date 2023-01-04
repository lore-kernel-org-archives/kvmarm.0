Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A943AC3DA7D
	for <kvmarm@archiver.kernel.org>; Wed,  4 Jan 2023 01:09:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 299784BB6B;
	Tue,  3 Jan 2023 20:09:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DypGJgcWyiyY; Tue,  3 Jan 2023 20:09:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D0974BB59;
	Tue,  3 Jan 2023 20:09:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9DC34BB59
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 20:09:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZmEQaBrAoG-0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 20:09:40 -0500 (EST)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D00724BB56
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 20:09:40 -0500 (EST)
Received: by mail-pl1-f179.google.com with SMTP id w3so2802545ply.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Jan 2023 17:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=2VT5QZhcZZeDbsiEz/fllfSXONvy51XdiSS8QokpwQg=;
 b=Q4DEfeoNUsJnujmG5WDcxlCAMaEfhBmMWAS7aUzEC2GW3ofbkRwZ22ZYFjITsxmo6K
 bb0vjmVJXZL0G/l4TGKr3KMTIDcdwQUeKoeFnx6I8MLcodY9TVH6AGEpkz9x9GWI5hwx
 k7R0UjHzbUt2Ai1wJRy2IFQHhF6DWYLx8cxQAFMWDWI6Xgrug2FARlR3RiNRVi4rCbo9
 AP/OLiZNnuV7UvZFm8qEsAphMEm93ULbKnV9d+A7rgWdhM6aiDUP6a5tWQx2bF/ggq6A
 f7JPgRzWEeYZPXHV5Lm4ZgFljKv8WtzXvID2mUUKGwqdRm31BuBbvKfhkRXpKAhdOylW
 Zj3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=2VT5QZhcZZeDbsiEz/fllfSXONvy51XdiSS8QokpwQg=;
 b=mL3l5ez9goKzsdb27Xv7kG8NLk/lhHo9kjdc08E/rXg5RvN7mkYOSD3bQWDqiC1e+p
 KPTQyMbbtp3jWLgI3LIJNDglYzNy4YDoe4XRcWCM9zdK1cp8W3N1zL6qieDjkhF0uBOt
 bJY7hbo+BtEjGushE0fUQxuIK5Th9T6mD+ohP7usyjknD55fWRgkwpvee8omsP7Hxy1W
 RZ6kBnlYbGhwhJnWrYfLDPjLC2seIbPqx6i+dsylzlmTe882OsYjblGzXC6b1/cORJWk
 x6fdfXYI2OS3V8v/3gFhQaGJbyj6sOzL+Na+a/fSLaUqd71G3eSoVnrjfbNjkCmTAh+Q
 o5VQ==
X-Gm-Message-State: AFqh2krJMwqKWQEBwLiSprAM1YkN9S+idFa/irXAjxjXK34EvMsPADL1
 mav9G8Pp0qXjODcw9b496e9AYA==
X-Google-Smtp-Source: AMrXdXt4xHOajqscKlKaEpBiTyEw5HpxcS2+BmkjFSTy1AWvaTA2O2HtoOh9s0+BdQR2dE8QR1delA==
X-Received: by 2002:a17:90a:9912:b0:219:f970:5119 with SMTP id
 b18-20020a17090a991200b00219f9705119mr3677621pjp.1.1672794579775; 
 Tue, 03 Jan 2023 17:09:39 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 dw6-20020a17090b094600b00223f495dc28sm19707506pjb.14.2023.01.03.17.09.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 03 Jan 2023 17:09:39 -0800 (PST)
Date: Wed, 4 Jan 2023 01:09:35 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 12/14] KVM: selftests: Use wildcards to find library
 source files
Message-ID: <Y7TRz1AY95SlKOHv@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-13-seanjc@google.com>
 <363f4713-6105-82d1-351e-423d07470cdf@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <363f4713-6105-82d1-351e-423d07470cdf@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Aaron Lewis <aaronlewis@google.com>,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, llvm@lists.linux.dev,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Nathan Chancellor <nathan@kernel.org>, Tom Rix <trix@redhat.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Sat, Dec 24, 2022, Paolo Bonzini wrote:
> On 12/13/22 01:16, Sean Christopherson wrote:
> > Use $(wildcard ...) to find the library source files instead of manually
> > defining the inputs, which is a maintenance burden and error prone.
> 
> No, please don't.  This leads to weird errors, for example when "git
> checkout" is interrupted with ^C.

Well, don't do that ;-)

Are there concerns beyond having an incomplete and/or modified git working tree?
E.g. could we do something crazy like fail the build by default if the working
tree isn't pristine?  The library files aren't terrible, but the number of tests
is getting unwieldy, to say the least.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
