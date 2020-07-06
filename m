Return-Path: <SRS0=KDMR=AR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D930C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 17:05:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0294206DF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 17:05:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bzJBCpac"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0294206DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37D624B356;
	Mon,  6 Jul 2020 13:05:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WDf2ypwggj6R; Mon,  6 Jul 2020 13:05:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39F0C4B364;
	Mon,  6 Jul 2020 13:05:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B59E4B2FD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 13:05:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wqa0cyGzqXMV for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2020 13:05:39 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29D374B248
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 13:05:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1594055138;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xHW+rYY0Q8vu0hEfh8n5Hoh1YU5C8a7qUY2OrcJ3VUA=;
 b=bzJBCpacc243oxbCTI97GGVTudpaYA09jptRWWTBdpS0+WqSbO8ApkV/4Avkp1wEwNZ6v/
 HYleEAg1Azngglet8r/y3+0wuVFd/7Yg4GpqcrbLZB4elzcIl9UV71R1PZhJNChCdx5F6I
 0Gmie7vqqWBXzhRPJy2P7g5fUJ820uw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-M4czyu7ONvOsBRnVQ468vw-1; Mon, 06 Jul 2020 13:05:34 -0400
X-MC-Unique: M4czyu7ONvOsBRnVQ468vw-1
Received: by mail-wr1-f71.google.com with SMTP id s16so31297059wrv.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2020 10:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=xHW+rYY0Q8vu0hEfh8n5Hoh1YU5C8a7qUY2OrcJ3VUA=;
 b=RWYAyEZDhbf2dRAbxC7Gf8UBsgiKNkRX+/qvcdtfWKBqvgeqL9iXq4CmInPhoAvX/l
 HMiq9KCjGTqSEaN/A2AkCAnmZMtKrAA5FkZ3G3ZY7KpGOQLh+exVBIcIFuQ5oCBpdmCF
 Jx0cHJ/PYB7fNH/SHUxJ53Ue0U69+7qZWltF1ugzDclgKG/Yf6kpBBhodh0OajVds1os
 Ryt+qmzLy3NjzUK0EMjUUMi9BxtFfdzU4AanoWq6yIY860rNRO+Gf96tDIjjOQsJzFMW
 shgjjXg1TiEbKD6MEcHRCz9gmM0zQX1brpeg9r5JW8ZhR00JvVlF8c9+rv54xlUTgZlj
 +cUQ==
X-Gm-Message-State: AOAM531M96KphW+TFlXwqfhWpzOPaD5H9dxBlTW92RBAEY7osJVlJjmQ
 ueegqpc4ptDDbZSuYJ9nDhb32m9Cet8E+gWv2xXYOH40NqkCrfd0odvR512GafyM1Sd/M4ALizv
 I1bsXReceRTAluhZwRx3RhcOG
X-Received: by 2002:adf:8091:: with SMTP id 17mr37366089wrl.13.1594055132903; 
 Mon, 06 Jul 2020 10:05:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG4sDAwM7tZdeCLE5A4njYJEWbejVQHYTjYvOGEQWWlAiFhhT95RnAPUF4/X/qRguticHxFw==
X-Received: by 2002:adf:8091:: with SMTP id 17mr37366071wrl.13.1594055132726; 
 Mon, 06 Jul 2020 10:05:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3181:5745:c591:c33e?
 ([2001:b07:6468:f312:3181:5745:c591:c33e])
 by smtp.gmail.com with ESMTPSA id z6sm86817wmf.33.2020.07.06.10.05.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 06 Jul 2020 10:05:32 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM/arm64 fixes for 5.8, take #3
To: Marc Zyngier <maz@kernel.org>
References: <20200706110521.1615794-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aa4d3a7f-3b16-c113-0bed-a6fc4017ce0d@redhat.com>
Date: Mon, 6 Jul 2020 19:05:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200706110521.1615794-1-maz@kernel.org>
Content-Language: en-US
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Murray <amurray@thegoodpenguin.co.uk>
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

On 06/07/20 13:05, Marc Zyngier wrote:
> git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-3

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
