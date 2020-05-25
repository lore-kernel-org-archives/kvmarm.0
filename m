Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56815C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 06:16:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5F85207DA
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 06:16:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="viFVpiWH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5F85207DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA3434B138;
	Mon, 25 May 2020 02:16:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6byJ3GzGBaAr; Mon, 25 May 2020 02:16:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9164B179;
	Mon, 25 May 2020 02:16:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6354E4B165
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 02:16:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XrHCjd-TEugj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2020 02:16:27 -0400 (EDT)
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com
 [209.85.215.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77AD04B138
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 02:16:27 -0400 (EDT)
Received: by mail-pg1-f196.google.com with SMTP id w20so3248694pga.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 May 2020 23:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=b96SL8+sRaQd4BNuO23oq4bmCu1x+cpwG9cm6rdCDA0=;
 b=viFVpiWHuDc+z9efiUkJdmh0VIDdJhkAiST+Q8beFUNnLgWtubZLHcJRe/qLLGg8Ip
 oTS8O5XPHQs5ZVa21IJrk9t5LGs94tYmAROm9iFn1gJg9EDp/ugeFILzwEj705KEvBGw
 b6JOOJ8Nw5uv/ziocgKDzhB84SwhMNSQMNaUAF+Ud1gvxPqt/eCPKpnOQcblDZXukU0k
 +YBUM4j7kZBcaRI3PmXwDJ1y1cgi3Lpe6Krsm8Hb3yurUa3b1ux8WWYM8OKxnhdxfQ25
 h3j2njsqK4+wVLtpj54w7bo2yq5Pakh/CDS4wsnvE8rqEgH2ggXaQJ6GUB5Z+zZZcTX0
 lA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=b96SL8+sRaQd4BNuO23oq4bmCu1x+cpwG9cm6rdCDA0=;
 b=qgxZ1n+rqSpmufx/j2BZhuszj8g+F+3bUmTuLQ8osMbivQFdnK8tsYaclNh9fWorxb
 dP+c6xgDkbf9N0mMPxybyNX0DNQ9s9xfSqdFMyy1lf+rK1eqvc4+A+mnzoKHl5JLb5VQ
 X0yoDHA43p2rZT0h/OUmIX916uNSGbMjqT0KK25bIQPj4juIFKIjrkIV8NQfVwmM5n/0
 9ZVvF/IaVVoP7Dcr1NUh5c2SvmVw3moDo5kbsij0XpYN2vPIw5RBdiOr7lWYL+KyXh4Z
 3vgfPMSQSACdWIE5qHoigjMKax7nkQff9KB16ypxEZ/myWA9qG48WKU2Id2GcuiQ2reB
 XyUw==
X-Gm-Message-State: AOAM532yAJkwbVNPIbaABKQjPsd+aoeTcW+gO80TZrqw1EbHFp8tQKGX
 kHBGGbYva7BZDIYL6U8td7w=
X-Google-Smtp-Source: ABdhPJxgBcGXY7WW27C6rn95w54bsP+6x+NYWWLJeYwxugt6XN3ID/4qT8FuaL3vxAeluC7dMnrvaA==
X-Received: by 2002:aa7:84c6:: with SMTP id x6mr15776442pfn.46.1590387386501; 
 Sun, 24 May 2020 23:16:26 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net.
 [73.241.114.122])
 by smtp.gmail.com with ESMTPSA id v1sm12380566pjn.9.2020.05.24.23.16.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 24 May 2020 23:16:25 -0700 (PDT)
Date: Sun, 24 May 2020 23:16:22 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Jianyong Wu <Jianyong.Wu@arm.com>
Subject: Re: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
Message-ID: <20200525061622.GA13679@localhost>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-11-jianyong.wu@arm.com>
 <20200524021106.GC335@localhost>
 <HE1PR0802MB25552E7C792D3BB9CBE2D2C7F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <HE1PR0802MB25552E7C792D3BB9CBE2D2C7F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Justin He <Justin.He@arm.com>, Wei Chen <Wei.Chen@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 Steven Price <Steven.Price@arm.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, nd <nd@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Mon, May 25, 2020 at 04:50:28AM +0000, Jianyong Wu wrote:
> How about adding an extra argument in struct ptp_clock_info to serve as a flag, then we can control this flag using IOCTL to determine the counter type.

no, No, NO!

> > From your description, this "flag" really should be a module parameter.
> Maybe use flag as a module parameter is a better way.

Yes.

Thanks,
Richard
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
