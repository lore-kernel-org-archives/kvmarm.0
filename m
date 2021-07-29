Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E0CC43214
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 09:30:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CFA2061057
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 09:30:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CFA2061057
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 423944A4A0;
	Thu, 29 Jul 2021 05:30:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wpv16kj3rt+Q; Thu, 29 Jul 2021 05:30:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 573CA4A500;
	Thu, 29 Jul 2021 05:30:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A95B74A1B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 05:30:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 786geKdAPcGC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 05:30:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D100740895
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 05:30:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1627551039;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=J23iSJURRvqOkAxJMklwOxLv8DDTdOwhOo68zLNGqb0=;
 b=HYpJDx39zXvFxJkye6SNZvN+BMxAJBVE3JzwYACGZQBjNadEOk7tEi7CRKN8Q7vW55/RHF
 BF6TREy9QEvJXR5eC82azUTKU752MUGY+okAslkvLBRLVBUs9rhsKeqMKZt+0dVrekO/RW
 58TJ3cj7suC01RMFdtKXhcw6YXc8xRQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-pmCA2ygLPJSlhBoltY1J7A-1; Thu, 29 Jul 2021 05:30:38 -0400
X-MC-Unique: pmCA2ygLPJSlhBoltY1J7A-1
Received: by mail-ed1-f70.google.com with SMTP id
 y19-20020a0564021713b02903bbfec89ebcso2634711edu.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 02:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=J23iSJURRvqOkAxJMklwOxLv8DDTdOwhOo68zLNGqb0=;
 b=Q2HayQ4e9nw0odIrJhGllSbNP+6T05ocUbgdJtiRKWmu1DFK2Tm+ranBWTUjzXjrY4
 A+Gy1kqzMQSBfrzeXphBUO4aop1fvucSuitNjXMVo6NLlJrIZnb5gsmq3WjvhytR8l8D
 zbN0t7+n0tnRbUFZoq6168RlA4udrtDvw85MKw1HMT+pP3WAIy9nycU5fv7Ih3lM6Nbo
 2dxSqH3KX49MFPnCAHi3R7uN+ZfXmlZIJ32q3gR0Qxm6+XbO/XUQTqVpdP3UNvNEgf1e
 nK9KkMU5gUwXKBF8we9CplwgZkp+eM3YpzHBSVVxML/DFZJMRXMfh2k6nLjMuHBJoLK7
 R1BQ==
X-Gm-Message-State: AOAM530zmnA5cJaao/n7yphtyqv1LyjuqYBzZ8lciyDu1j2P2LmLC5xV
 yCRDEgxYVzgIMRXPuN5r3F7BHHonsCz0A+zwilQFgYzK72nOPWjCntl01c0rFEF2ZExzLxz8V0Y
 P2QyR8LftaNN7A7dL8t4IiTNT
X-Received: by 2002:a17:907:9d4:: with SMTP id
 bx20mr3676527ejc.123.1627551036997; 
 Thu, 29 Jul 2021 02:30:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3wIR5FM8ntRVfpyHiOWHksHokdn3YpbAIvZT7i5L+rZrnbhYwfbL3DgrDPF/a7EY6Be57TQ==
X-Received: by 2002:a17:907:9d4:: with SMTP id
 bx20mr3676502ejc.123.1627551036834; 
 Thu, 29 Jul 2021 02:30:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id v13sm768791ejh.62.2021.07.29.02.30.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 29 Jul 2021 02:30:36 -0700 (PDT)
Subject: Re: [PATCH v4 03/13] KVM: x86: Expose TSC offset controls to userspace
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210729001012.70394-1-oupton@google.com>
 <20210729001012.70394-4-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7cb58a33-316c-58b5-b542-671a43dea89c@redhat.com>
Date: Thu, 29 Jul 2021 11:30:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210729001012.70394-4-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 Oliver Upton <oupton@gooogle.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On 29/07/21 02:10, Oliver Upton wrote:
> +6. Adjust the guest TSC offsets for every vCPU to account for (1) time
> +   elapsed since recording state and (2) difference in TSCs between the
> +   source and destination machine:
> +
> +   new_off_n = t_0 + off_n = (k_1 - k_0) * freq - t_1

The second = should be a +.

Otherwise the algorithm seems correct.
> +

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
