Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D4CC43334
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 17:43:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CEA94D722;
	Wed, 20 Jul 2022 13:43:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q84h07Erjjad; Wed, 20 Jul 2022 13:42:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CE994D7C7;
	Wed, 20 Jul 2022 13:42:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE2744D6B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 13:42:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id onP7z+yr-vQU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 13:42:57 -0400 (EDT)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD6954D6A4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 13:42:57 -0400 (EDT)
Received: by mail-pf1-f170.google.com with SMTP id y9so17084619pff.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 10:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=DfEX4zoB1CUktXM16Ag23RFGvAYk/58RpJGt7MGAocE=;
 b=k8rKBnr7aZjsE0e238dfyBRXFOKEu15TVKWwxkiMzRfMOeXtH2u+tOPYXl8NhgaWkI
 mpr3M14vF3hibRu5Jz4rLaRk2G1sYTVNUItbwqR+NkFcFn+AZS0tiagegsLQrmWpvw5y
 LtrHvVGmcrV+4XSfSzWQyqGB1pBoKwumJSgiVa46KuYsSDdaYOq8NSh3Ji24DEAsLQuz
 ilyr7fqgq9ngkwvMahO19rpODEIfxg0Oq0TOhZYRnd6h9q5ueaSMJwK5eiYaBtuFbBPp
 bszWvnoLROSimM0IIIYTN3/21asLHLA/wWYt7TZp8V8BA8SKK7KsBD02I8McKu3QDRtQ
 bM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DfEX4zoB1CUktXM16Ag23RFGvAYk/58RpJGt7MGAocE=;
 b=gDmfwaEoe2BqVApQeeWEYPUProLaTm7zE7S3I64/GZR3+r9Hm/XNZ85/Ly2oWWWCUb
 1QcFEk+R7KGctsoJxh+bbcDGH64hfBxNr5FGHFcS0ZwDBCBz4YBxia2PYRwRfFLimvNt
 YUZIZjrc0E/W2/HD/e89ISLxJcbZ8jkhUIkRxFtV3NQ7FhgSK2PAXHErX2U+AMxPe6es
 rwYVL/DgIZWrpGErxxjD1kxbcDpSoCW14yYgeE+EwRYdARa47tLnHKHfhJCr8ULHiwbo
 SQLx5NKCsIeLv+6Qj1hUsZAvaRAZ/SmuaxU98Y2qVeJkyyvkbHhhjNVmL4Dyth759mQI
 ruHg==
X-Gm-Message-State: AJIora+/kVdoO5MZ5YrQHbJN8u+vW5/Dwc3vIo7XrgnCno/6jmZRsphP
 s0WATedkyFV1Sf9SLBNW5BHb+w==
X-Google-Smtp-Source: AGRyM1sF5IvK8I6QJM2ULGYuEYt4O7oHWje74vqLLTLxm1FXIws0PWEywVUK0mjlJqEYf5boKjSyvg==
X-Received: by 2002:a65:62d1:0:b0:41a:69b2:91f with SMTP id
 m17-20020a6562d1000000b0041a69b2091fmr2782576pgv.283.1658338976399; 
 Wed, 20 Jul 2022 10:42:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 mp16-20020a17090b191000b001ef863193f4sm1967177pjb.33.2022.07.20.10.42.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 20 Jul 2022 10:42:56 -0700 (PDT)
Date: Wed, 20 Jul 2022 17:42:52 +0000
From: Sean Christopherson <seanjc@google.com>
To: Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH 0/4] Fix filename reporting in guest asserts
Message-ID: <Ytg+nOmnSj4JaS9J@google.com>
References: <20220615193116.806312-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220615193116.806312-1-coltonlewis@google.com>
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org, drjones@redhat.com,
 pbonzini@redhat.com, vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Jun 15, 2022, Colton Lewis wrote:
> Fix filename reporting in guest asserts by way of abstracting out
> magic numbers and introducing new reporting macros to report
> consistently with less duplication.

FYI, this is queued up for 5.20.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
