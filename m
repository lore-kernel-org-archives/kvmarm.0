Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA88C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 16:10:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 353F420873
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 16:10:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eQs+PA1s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 353F420873
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 926B94B214;
	Wed, 27 May 2020 12:10:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4k0TPnxJHM4q; Wed, 27 May 2020 12:10:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF834B237;
	Wed, 27 May 2020 12:10:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D2B74B238
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 12:10:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9oaxBlT8-zjF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 12:10:41 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39DFE4B164
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 12:10:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1590595841;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gpS5WDJIgyjBNnbz57joD1fkY56BnMjV/cB+edX+sFA=;
 b=eQs+PA1sqjIJqZrzF7zY/oP0eQTeCVfvHSdKoK3R+2x6cWZ5h2ln/xw4mfT+3HIfTHbG55
 cBibQpxczWkQN4QjWBWx9roUCc1L5Ur7tWYoo0YkfVl5PHqUbBNTS2ilNyXSSb/lHNOtYf
 03I4mCKwss19oj1Ix5Jz3OBlabqTYE0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-KdrABXfINHu0MDsXeEi7yg-1; Wed, 27 May 2020 12:10:39 -0400
X-MC-Unique: KdrABXfINHu0MDsXeEi7yg-1
Received: by mail-wm1-f72.google.com with SMTP id o8so1048610wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 09:10:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=gpS5WDJIgyjBNnbz57joD1fkY56BnMjV/cB+edX+sFA=;
 b=pD7GDDUV/AK+Np9L3diaLa/rV/moVx7WjTgKmHr912btDEpotDaFP/2gxu/7urDSCE
 2m43sADxlH+6L+s60JIJXBs8ztTOHhWmbYT1GcRye+1EraoifPKEiqAwqN8qqyYW+Tk3
 nFSmljghKhDsSfttIDHbdENQ4hbgYLQMptBfYpn4Oj9swykSPhEFUCJsqaC8OjR2E7xT
 sp0zE/628K6hTg/oVIP4OBlkWRO+/5fU4c6VBPvzuF80SqKeUigTwgyI3NeUl9yrWaRq
 GCM0EXH0xgku9fd04dmBam7AXjr2lUn2Q5yTjul8yCqIly/2S2c7IqgtRuhzvO5tAzab
 DmbQ==
X-Gm-Message-State: AOAM533lhW5oJC+hGQGVrGo5RmCLQ8W13HW6+drP2euUAEkgIUeCmu0x
 6cqsYLphSRBH1/G+NVy52u2Y0Xddh5UiV6L4mv9bRb6T12T2+P+xZIiWMkekYGDje8l6rt+HvZd
 e2pyb0//wlRpCWd9627g4VQWS
X-Received: by 2002:a7b:cf06:: with SMTP id l6mr4939098wmg.63.1590595838151;
 Wed, 27 May 2020 09:10:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwv2WOvp+dGE5Bd+63NHTAUmNpXjYKI6PXzKuriRFk4SIKF8scu4bdTkpQ8+eWY4jLf6e98w==
X-Received: by 2002:a7b:cf06:: with SMTP id l6mr4939064wmg.63.1590595837858;
 Wed, 27 May 2020 09:10:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8?
 ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
 by smtp.gmail.com with ESMTPSA id a10sm3149808wmf.46.2020.05.27.09.10.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 May 2020 09:10:37 -0700 (PDT)
Subject: Re: [PATCH RFCv2 0/9] kvm/arm64: Support Async Page Fault
To: Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200526130927.GH1363@C02TD0UTHF1T.local>
 <987785b2-2533-c3d8-8f6a-4193aa82d502@redhat.com>
 <ae0f32fa338969d25dc3da56292e35ed@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eb2a2291-85b0-a39a-96d1-58e4652771ba@redhat.com>
Date: Wed, 27 May 2020 18:10:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <ae0f32fa338969d25dc3da56292e35ed@kernel.org>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
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

On 27/05/20 09:48, Marc Zyngier wrote:
> 
> My own question is whether this even makes any sense 10 years later.
> The HW has massively changed, and this adds a whole lot of complexity
> to both the hypervisor and the guest.

It still makes sense, but indeed it's for different reasons.  One
example is host page cache sharing, where (parts of) the host page cache
are visible to the guest.  In this context, async page faults are used
for any kind of host page faults, not just paging out memory due to
overcommit.

But I agree that it is very very important to design the exception model
first, as we're witnessing in x86 land the problems with a poor design.
 Nothing major, but just pain all around.

Paolo

> It also plays very ugly games
> with the exception model, which doesn't give me the warm fuzzy feeling
> that it's going to be great.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
