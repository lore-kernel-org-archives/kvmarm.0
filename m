Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368E6C48BCD
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 16:39:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95999610A1
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 16:39:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95999610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6D7840870;
	Wed,  9 Jun 2021 12:39:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HTEvyiamRtr7; Wed,  9 Jun 2021 12:39:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C435A4066E;
	Wed,  9 Jun 2021 12:39:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B5C405D8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 12:34:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jOolfscDCw3E for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 12:34:33 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86C3A4031F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 12:34:33 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id
 mp5-20020a17090b1905b029016dd057935fso1709379pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 09:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2fp6Uuy6GSNvKepEDgRuQTao6to9O/zWUvKaMxtTuY4=;
 b=rJAYvImo8GqMKS2I8qxEWb0cR3WmfDKnRVZfann15BrfdcD6zdhw/QtCxha2yCBB1K
 Tw6UKVWjwwhuX+WrgIQ7xeIzzGUTB/i6Awd4KjcATD0X5NDYiSJvPTERk/sz2ohI53ey
 A7g++W3uHNTg+RjpJzLRBNbaAdvGsNNFTpDxxu861jwv5HjOYgWGdDTIjiOOcH/t1KBt
 Z0Hgx273qBsfsqSon4qwp3PlO/g6dvElYapSdkzlyDU0WUoaOL79zEWz4KZmzU7k7wZJ
 DSoU7Z3L2Z15lU0+ioJ5hkCEuKofiOyyL+HcdZq+DP5AQDWMEj9lUgaRox/tBZDtjbR4
 nMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2fp6Uuy6GSNvKepEDgRuQTao6to9O/zWUvKaMxtTuY4=;
 b=LX0KTvPbn+6JATDwyJ+6rKouJk2L4Cp9cGK53lagMsMi9OEfNR6LxN8mL1Fgc8uDMy
 fqcmwLcC67ck0OgROV0WKpvQJqkSwg8dWN5yL6qcO9gfOgCXXWfPh6NK8Aj6H7JMtcOB
 ArIB5V4hTmPXJ5cFugDOG9RJ4VLrmfhBe0m+9lLuwYUwItAoKhQLL0tTHqmnuQCWQoQL
 0d8qREfSrMy/673yjbOhFmeWxvH8vwCUcMvwMWWncYFHCFFmqURlrlIfXqsaFH63qnGO
 /LT+bNLjP/783ilIV1zKKo2n0c5NFVujXRJU19m1nOT8ns8m6dkRkioyGyQkkG+UDJwB
 wUeQ==
X-Gm-Message-State: AOAM531fzpGWzN9audamFuhmWMKyFAqZw8OiU8I5Usj/yX9f8zR+VllF
 kxKqO3dN1zMlFTdsC3m29RgVEg==
X-Google-Smtp-Source: ABdhPJxF8FSKckqpsOMeQdDomw9GOa31eWHF4SWhPDbbAhjn+xUSXWde5Q9m3XV7BCG2Toi7HDfqNg==
X-Received: by 2002:a17:902:6b8c:b029:ea:f54f:c330 with SMTP id
 p12-20020a1709026b8cb02900eaf54fc330mr458980plk.10.1623256472218; 
 Wed, 09 Jun 2021 09:34:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id f15sm316396pgg.23.2021.06.09.09.34.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 09 Jun 2021 09:34:31 -0700 (PDT)
Date: Wed, 9 Jun 2021 16:34:27 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
Message-ID: <YMDtk/Xyf/7wpIxx@google.com>
References: <20210604181833.1769900-1-ricarkol@google.com>
 <YLqanpE8tdiNeoaN@google.com> <YL/q/IJ41gO6kTIF@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YL/q/IJ41gO6kTIF@google.com>
X-Mailman-Approved-At: Wed, 09 Jun 2021 12:39:03 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org,
 kernel test robot <oliver.sang@intel.com>, pbonzini@redhat.com,
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

On Tue, Jun 08, 2021, Ricardo Koller wrote:
> On Fri, Jun 04, 2021 at 09:26:54PM +0000, Sean Christopherson wrote:
> > The multiple layers of routing is also confusing and a bit hard to wade through
> > for the uninitiated.  The whole thing can be made more straightfoward by doing
> > away with the intermediate routing, whacking ~50 lines of code in the process.
> > E.g. (definitely not functional code):
> 
> This works but it would remove the ability to replace the default sync
> handler with something else, like a handler that can cover all possible
> ec values. In this case we would have to call
> vm_install_exception_handler_ec 64 times.  On the other hand, the tests that
> we are planning don't seem to need it, so I will move on with the suggestion.

My objection to layering handlers is that it introduces ambiguity regarding
ordering and override functionality, e.g. if a test overrides both the "default"
handler and a specific exception handler, which handler will be invoked?  My
expectation would be that the more specific override would win, but someone else
might expect that overriding the default would win.

It should be relatively easy to provide helpers to override the handler for
multiple/all exceptions if we do end up with tests that want that functionality. 
But yeah, definitely a future problem :-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
