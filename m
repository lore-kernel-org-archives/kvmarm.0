Return-Path: <SRS0=103j=YJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA854C4360C
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:43:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 780AA20873
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YynUyPSm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 780AA20873
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E70614A9CC;
	Wed, 16 Oct 2019 03:43:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ABA5cfyZpfcP; Wed, 16 Oct 2019 03:43:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06E4F4A9A2;
	Wed, 16 Oct 2019 03:43:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17C4E4A98C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:43:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ePNL-mUIfMUq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Oct 2019 03:43:23 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4548E4A94A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:43:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1571211802;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references:openpgp:openpgp;
 bh=2TZPYczZMoe38v6J5VmGL4LQBizJV5OWL5TaFj5ByLo=;
 b=YynUyPSmgpH4Ldc+lJxiN5PCMoRtGcntxMazA6RCu7ddLT4jho9HqSIw0z+J4DzLqi6ZJY
 bz81x+WY3Hju55EeQKAM7YkTdZ4e3l+Bey7W3SiKMYsAr0cfwjcDZiKozI4zWEueUZwoKK
 iUTpGMlA8STTcqpySIm4rkBdkNpp6Zc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-rDH6BXZmMXm8c1oJxqBBdg-1; Wed, 16 Oct 2019 03:43:21 -0400
Received: by mail-wm1-f72.google.com with SMTP id l3so787536wmf.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 00:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=2TZPYczZMoe38v6J5VmGL4LQBizJV5OWL5TaFj5ByLo=;
 b=FHa+hRDIUQN1stjQtVPn97Ijokv5h3Dk5UX6lwqVarC5T2ZppsaxbvATCZmq5jIsXq
 ZjY9Od28aomC7Nj2NL2WLv47shQqIH35tfBphdld3M/1IurbrS5929fHnCme9Kp8Pw+/
 avQm3bf1rxqDhhBn9urhQ4DUZoO74HD6sUpLs8tNvLUUV9FxVVW1kliI8piFUfiOGpK7
 owpMkliCPe1fFr3+eO0YjdLmqTQJhDz/tYrhDU59DhohbLYcVyLym1VbLIQ6YF/XI6ti
 J3c6vrns0ia6QgWzTXdGelA1D8yfgVa3ieKflo0b7JxarNkOkbSApiQyWyLYssfHhW4g
 W1WA==
X-Gm-Message-State: APjAAAUpr06BlBGXNCP3M13QfNOcchDVZrcDQYNyEYis4Xl6LlhVelu4
 5zFOWCKY/8K8y5KmFxEAdzQKmki+pfWInmgenXbY0Ixgg8UmEWc9rGUOUtokPDiRL++RHKJ4JId
 tz1hYqR8GEp4Z8PPzIyNdwgjl
X-Received: by 2002:a5d:6203:: with SMTP id y3mr1414798wru.142.1571211799707; 
 Wed, 16 Oct 2019 00:43:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzYE+zEFsYqXUGvnl9sFNQ8c4wx17KGf+Az81W3+WtMXjrT9dBRLwLjKr90BAhiAxvpImSuwQ==
X-Received: by 2002:a5d:6203:: with SMTP id y3mr1414773wru.142.1571211799459; 
 Wed, 16 Oct 2019 00:43:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e?
 ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
 by smtp.gmail.com with ESMTPSA id d78sm1595639wmd.47.2019.10.16.00.43.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Oct 2019 00:43:18 -0700 (PDT)
Subject: Re: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
To: Thomas Gleixner <tglx@linutronix.de>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-5-jianyong.wu@arm.com>
 <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
 <alpine.DEB.2.21.1910160929500.2518@nanos.tec.linutronix.de>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5e344920-1460-337c-9950-858165d37d14@redhat.com>
Date: Wed, 16 Oct 2019 09:42:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910160929500.2518@nanos.tec.linutronix.de>
Content-Language: en-US
X-MC-Unique: rDH6BXZmMXm8c1oJxqBBdg-1
X-Mimecast-Spam-Score: 0
Cc: justin.he@arm.com, kvm@vger.kernel.org, maz@kernel.org,
 richardcochran@gmail.com, Jianyong Wu <jianyong.wu@arm.com>,
 linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
 yangbo.lu@nxp.com, john.stultz@linaro.org, netdev@vger.kernel.org, nd@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 16/10/19 09:31, Thomas Gleixner wrote:
>> 3) move the implementation of the hypercall to
>> drivers/clocksource/arm_arch_timer.c, so that it can call
>> ktime_get_snapshot(&systime_snapshot, &clocksource_counter);
>
> And then you implement a gazillion of those functions for every
> arch/subarch which has a similar requirement. Pointless exercise.
>
> Having the ID is trivial enough and the storage space is not really a
> concern.

Ok, good.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
