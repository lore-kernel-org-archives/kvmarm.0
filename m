Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F768CA9EAF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 15:31:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC700206C2
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 15:31:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC700206C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3941D4A9AC;
	Mon, 21 Oct 2019 11:31:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NoN63SjKfifY; Mon, 21 Oct 2019 11:31:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 574544A9B8;
	Mon, 21 Oct 2019 11:31:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6985F4A4F6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 11:31:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ab6+0jEpd76R for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 11:31:01 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 855684A4E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 11:31:01 -0400 (EDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 81C9983F3D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 15:31:00 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id o8so6144147wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 08:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=HXpSYYKAOP8qmSkuN9OQPmoeggjz/B9bVdloCHt7b9Q=;
 b=g05CrJb2vyxCTwbj91HT9pFE//RVl2dxqPNyspSkd7BOc0gscrUaIFXMD8rnkP3HJ1
 v5O6rsVVmL3k9EPa8b8z+oj/PVffR1IFRO5UNTafIQJ+z4hCVDFRaLKSy0Y8TvMpztkR
 q82uOrcT7gTMg5Jext1IckKoTHK9lhkl+xILugn/v662tQgbrHUWLxDiNnGoQIV34qE6
 OrfLHLMC7vhUKwF+M0KkT/7/oSrdDxYNjnGXTmzV/AtaTtHlESzdD9dzekCjyhFgvIKZ
 fXxyn2ooxslvNQiB+9zUh2jJGWWpiEJmDrlacRKDQR3j00t64Hi5j1CwAdZPxlvLM6/S
 a7/g==
X-Gm-Message-State: APjAAAWzXl/U3Wl/O3z+q5B79hTi/OGxn5PNYJhPzmm9UKS1JglMxhlD
 oZdTGuhvPolp5eT5u7//laD5bozV0D3g+kIMLUk2zl3j9NiBv4GJoCnk2u0hhayJ51zbV33uELu
 0IA38OAC4Axaor70PafaSokQD
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr19967242wmg.89.1571671859148; 
 Mon, 21 Oct 2019 08:30:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxTZ/lUVjW3sj3DfIBV7IL+Q0e6WVIFdjwvrO+qO4Vf7KPNSe2KjsRG/pv34P9t+UFKRzKAvw==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr19967224wmg.89.1571671858896; 
 Mon, 21 Oct 2019 08:30:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd?
 ([2001:b07:6468:f312:847b:6afc:17c:89dd])
 by smtp.gmail.com with ESMTPSA id d8sm2174955wrr.71.2019.10.21.08.30.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 21 Oct 2019 08:30:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] Switch the order of the parameters in
 report() and report_xfail()
To: Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>
References: <20191017131552.30913-1-thuth@redhat.com>
 <20191017133031.wmc7y26nsd63zle6@kamzik.brq.redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b6982589-33ff-db3f-d6f2-941a70cd0783@redhat.com>
Date: Mon, 21 Oct 2019 17:30:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191017133031.wmc7y26nsd63zle6@kamzik.brq.redhat.com>
Content-Language: en-US
Cc: Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, kvm-ppc@vger.kernel.org,
 Bill Wendling <morbo@google.com>, kvmarm@lists.cs.columbia.edu
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

On 17/10/19 15:30, Andrew Jones wrote:
> Paolo, do you want me to do PULL
> requests for all the arm-related patches?

Yes, that's why it's not merged. :)

This patch is mostly automatically generated, so Thomas can send me v2
after your pull request is in, and I'll apply it.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
