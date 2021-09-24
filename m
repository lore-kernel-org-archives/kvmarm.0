Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2831AC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 10:04:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97396610F7
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 10:04:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 97396610F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D09C84B120;
	Fri, 24 Sep 2021 06:04:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tTlWKpZZ4xyI; Fri, 24 Sep 2021 06:04:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B63E74B118;
	Fri, 24 Sep 2021 06:04:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D20C4B10C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 06:04:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8fHdQH2KKbjk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 06:04:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D03024B10B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 06:04:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632477864;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5I8+/PBpXab5XEShtr8cIKRG6bCQ0vQu8F83jY5+nd0=;
 b=jHyTVDSRI0qWg5kaEnOqss/k/xhJaZGrpWUtmGjxTbB0BEo6FQ67wqrs2G/9ZUbT0oBp47
 y1KOnJe6Uht+6BS9FTCyd/lfu+Jytd+HaDAx7n3T3JjfZnN7UXOKRvL9RQhbEsarqEeUBW
 qPTJX+VWxh8cg6J18VYOZdsZ6/Bsm4Q=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-O49LUMASOP2QKKcMgSo5Cg-1; Fri, 24 Sep 2021 06:04:23 -0400
X-MC-Unique: O49LUMASOP2QKKcMgSo5Cg-1
Received: by mail-ed1-f71.google.com with SMTP id
 w24-20020a056402071800b003cfc05329f8so9722206edx.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 03:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=5I8+/PBpXab5XEShtr8cIKRG6bCQ0vQu8F83jY5+nd0=;
 b=TR0vg+IVXlkVVuHS8tSvQwd9eNAz1t4BLjqSx49KRhYqLI/ZWVMBI6EQGyKutptenY
 +zSYXo8VbHthUisVbW1WGnSpX3TLQFP3KCN8U2/zD1wXR0rF1YX8czp8+o9Jop8Q+FXN
 9YTgKY8JaQxD6B7ED+1Hgf2IacXkZ2jIkohmWWrdLRVqPcnBEMkyxZYPX+Og+4l/kb83
 EhI8zY+AKmC280XJQs/Bh58k/uVbgGQf1HKb58CRQkxK8uD7Dqmf6oCSPcujB/DYwHFy
 RMK1y1f0G2yWt+S+LUNT51ll0KX3AVgaquFJBsVuc6Rlwqx+tZv1h+C7cZCmvc7RY4Sa
 xAmw==
X-Gm-Message-State: AOAM530awHTzZz6STZVZKUKD3F39IyPJj3CKXwgFVvgZVTvJ7GsPyIox
 t06RBaxLdC1u0EnaY+oUDoZ6w592FiPI0zbHMNzLEWDShRyqhL43Chwjm9gQwUhrjEr0rf9ro/2
 NndVxBuyqHAwQ2aMxHHLGB3BZ
X-Received: by 2002:a05:6402:1508:: with SMTP id
 f8mr3986177edw.255.1632477862132; 
 Fri, 24 Sep 2021 03:04:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygeZyMT7VCjV6ItZHI7JAJSC8GZk65ZQmI8K8y7NN6G9PnXBLJoj/cYhKBOivcf2S9KwSbeA==
X-Received: by 2002:a05:6402:1508:: with SMTP id
 f8mr3986156edw.255.1632477861926; 
 Fri, 24 Sep 2021 03:04:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id r2sm5453064edo.59.2021.09.24.03.04.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Sep 2021 03:04:21 -0700 (PDT)
Message-ID: <43cecad3-f144-1f5c-4106-911732b906c7@redhat.com>
Date: Fri, 24 Sep 2021 12:04:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.15, take #1
To: Marc Zyngier <maz@kernel.org>
References: <20210924083829.2766529-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210924083829.2766529-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Masahiro Yamada <masahiroy@kernel.org>,
 Russell King <rmk+kernel@armlinux.org.uk>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 24/09/21 10:38, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.15-1

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
