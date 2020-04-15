Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D79C2BA19
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 14:53:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E9922078B
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 14:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JjydEm3K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E9922078B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04A8E4B158;
	Wed, 15 Apr 2020 10:53:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5hQb1GsX6rY7; Wed, 15 Apr 2020 10:53:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21C334B168;
	Wed, 15 Apr 2020 10:53:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6153A4B154
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 10:53:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xO1nfd628tbC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 10:53:33 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 996E94B14D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 10:53:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586962413;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=K5aShlaM4L7LBpzpuTEwY9oR96TrokeSvhA+JevS168=;
 b=JjydEm3K+xWc2nEV5L+8ZaX23sdIouTvuMz7Cz8Jnjz/rI4L/lTo9gxWzUYQ3SdNzaVfVB
 HXFEUYXmezcWWbE9/5BnInA/OY6JigarzpKICa7rJe0chUEGgkEc8SSrnfL95BeewS0odx
 YNlOEuVHhO0ayg8j8tpzXNUx7miRg8k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-VfVJtoQVMNiNfuldemScjw-1; Wed, 15 Apr 2020 10:53:31 -0400
X-MC-Unique: VfVJtoQVMNiNfuldemScjw-1
Received: by mail-wm1-f69.google.com with SMTP id h6so5421439wmi.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 07:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=K5aShlaM4L7LBpzpuTEwY9oR96TrokeSvhA+JevS168=;
 b=RLjO0klvPWLV7Tu1f7iseoEqOgO96tueNFV2xakX1z51ga2RrR1+QuSXV0zSU0x2SO
 nzAlekWcQQt3VMlsf+YSIfinO2QJ5yt9zySnRja6z3Dd6xcxE/k6J2JchIFhFsB2gEf9
 ZCYxtN0/iWPx44dvSm7XFjx7PiBoL9tfXI/VzI4pUHMASKx7UAt3lN1ZemoGaiqqhWgt
 HuxG/jhD9bOYX1weDiMTmtCwRIoYzgolNo2nMd/9Pi8F9mG9r6suOSIKsvESd+Qd+YdX
 mUf9Mgk48OLU3M3f/tyygjBndDxf4tEAS/2bHQ7HsDIihakuvHLVF7q7Yp5z9sh4WmHM
 BPtA==
X-Gm-Message-State: AGi0PuYGNDeXLTizPujaQrVeEpIYBKWuVojEXE4IfF+J136qzHY395gX
 gCs9lhfI0O2M+3VgtiUgFelB3xlkC9LjmSHqpEk3OWsmmAZFfdUSeq88LpxTYDUhXSAcGDWsQjt
 21lfSrOfrIBZaLtYnUC5nQgxE
X-Received: by 2002:a1c:4ca:: with SMTP id 193mr5676272wme.18.1586962410827;
 Wed, 15 Apr 2020 07:53:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypKgkkaOjvC7IzHh45gZluJBlRAB0EDDEKLC5J1nBzdDb/gCljFCcJsnBzwUJEmVbAtBvAy4Yw==
X-Received: by 2002:a1c:4ca:: with SMTP id 193mr5676247wme.18.1586962410610;
 Wed, 15 Apr 2020 07:53:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e?
 ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
 by smtp.gmail.com with ESMTPSA id p10sm22953476wrm.6.2020.04.15.07.53.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 15 Apr 2020 07:53:30 -0700 (PDT)
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
 <875ze2ywhy.fsf@vitty.brq.redhat.com>
 <cc29ce22-4c70-87d1-d7aa-9d38438ba8a5@linux.alibaba.com>
 <87a73dxgk6.fsf@vitty.brq.redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9e122372-249d-3d93-99ed-a670fff33936@redhat.com>
Date: Wed, 15 Apr 2020 16:53:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87a73dxgk6.fsf@vitty.brq.redhat.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, maz@kernel.org, joro@8bytes.org,
 x86@kernel.org, linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
 mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 jmattson@google.com
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

On 15/04/20 11:07, Vitaly Kuznetsov wrote:
> In case this is no longer needed I'd suggest we drop 'kvm_run' parameter
> and extract it from 'struct kvm_vcpu' when needed. This looks like a
> natural add-on to your cleanup patch.

I agree, though I think it should be _instead_ of Tianjia's patch rather
than on top.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
