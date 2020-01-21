Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4094EC2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 12:24:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5A372073A
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 12:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CDoZ+FRb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5A372073A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E9B74AFE5;
	Tue, 21 Jan 2020 07:24:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6MJqq3ypKJlc; Tue, 21 Jan 2020 07:24:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 964994AFEB;
	Tue, 21 Jan 2020 07:24:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCC894AFC0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 07:24:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id suUQKO1vI+Wj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 07:24:34 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB7064AFB1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 07:24:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579609474;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2JRami1vqERtvVOhWdic7ftSfhU5/AM2PS8umediSqQ=;
 b=CDoZ+FRbuTegZPROtVuTwBn3WOTMF/8tx6/d8t8sp6oDOSyV7cO3bzGDojU50zIAiI88Tm
 I/ZQrMQSwtIEpJvqGykHWn0igFNbkQZkFuV9ZuwK8CS3QHvz4QdIg50i/ftw9F7SEtNMHR
 bjYcJb4AqCadv7OpoNRmtK2LQk6WyYc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-dfYa7ptoMbCUMMbuzRw9YQ-1; Tue, 21 Jan 2020 07:24:33 -0500
Received: by mail-wm1-f69.google.com with SMTP id l11so699614wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 04:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=2JRami1vqERtvVOhWdic7ftSfhU5/AM2PS8umediSqQ=;
 b=AFIjh/Ro+Cy1wfdVu4LFS+scyBqJIXJOUtAXOLdZ6dw33Bk5h407OadhWg1rz2fyGV
 KxCPOtUxho5T641k/lIdd3KLjA5MESGLij1ZFyanq9lFGvYwghst0LzK0M2icy0BhlOv
 DfV73yHWlYFGeAeaCBqw793HOBh84H79WIhNmzZiRxcDDNtGRWQ6Cb/aknl3Eok507Wj
 sVMAEapDrQApZ5+2UtmgBFV/8ktZwG7DUPWNaxeSNFysiTOYNAl0FnR1vfidovgyCUor
 /zsvTLhSioKhr1Eo/s4lrSYKvcAYtbWrcIV4ntN7leCfluXhpR3tJgTETdaUWKocV9Pm
 ppjg==
X-Gm-Message-State: APjAAAUjddyFvZ604tfx4+QYUuUoy5DJxKnBz0nSQRx/9uZhhszWRK/u
 bY+xYuJnNBm2scwjk6Xf4zg32Nj346d/MqxqNFaAlWtj2iESj65CX9gXagULz08oeW8DzPJcbc2
 FfzUtC4731BZhMRmt9wjHy/Ue
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr4914505wrm.284.1579609472349; 
 Tue, 21 Jan 2020 04:24:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNvH/P6poOhLh9BEBTM0W39aC5Gdgb79gu8uifJcP0NDeYfjycB4x/ep68tvfF9lucHS4Q4Q==
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr4914477wrm.284.1579609472031; 
 Tue, 21 Jan 2020 04:24:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a?
 ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
 by smtp.gmail.com with ESMTPSA id f12sm3844116wmf.28.2020.01.21.04.24.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jan 2020 04:24:31 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests 0/3] arm/arm64: selftest for pabt
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20200113130043.30851-1-drjones@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bbd1f024-2f6c-d963-57f9-e6d7f2939fda@redhat.com>
Date: Tue, 21 Jan 2020 13:24:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200113130043.30851-1-drjones@redhat.com>
Content-Language: en-US
X-MC-Unique: dfYa7ptoMbCUMMbuzRw9YQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
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

On 13/01/20 14:00, Andrew Jones wrote:
> Patch 3/3 is a rework of Alexandru's pabt test on top of a couple of
> framework changes allowing it to be more simply and robustly implemented.
> 
> Andrew Jones (3):
>   arm/arm64: Improve memory region management
>   arm/arm64: selftest: Allow test_exception clobber list to be extended
>   arm/arm64: selftest: Add prefetch abort test
> 
>  arm/selftest.c      | 199 ++++++++++++++++++++++++++++++++------------
>  lib/arm/asm/setup.h |   8 +-
>  lib/arm/mmu.c       |  24 ++----
>  lib/arm/setup.c     |  56 +++++++++----
>  lib/arm64/asm/esr.h |   3 +
>  5 files changed, 203 insertions(+), 87 deletions(-)
> 

Looks good, are you going to send a pull request for this?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
