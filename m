Return-Path: <SRS0=3b8a=HV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5864EC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 18:11:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD70C64E5F
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 18:11:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD70C64E5F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A35A4B322;
	Fri, 19 Feb 2021 13:11:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pz8cFHUoxG2W; Fri, 19 Feb 2021 13:11:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EFAB4B2B9;
	Fri, 19 Feb 2021 13:11:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB7124B279
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 12:54:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mrc836xAJejZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2021 12:54:47 -0500 (EST)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 824984B276
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 12:54:47 -0500 (EST)
Received: by mail-pg1-f175.google.com with SMTP id j1so1834134pgh.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 09:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=glvZ+nCfB9TtbAroDymQkDFhBNuKdCgNd2JMzbDR3kI=;
 b=OCyoHdUAUdv7opL3EZFA7lTMEfk3yF8FryLxCsvYVnjGDzjyo3IU/c24JBfeqd7Wek
 htlrq3CI2X7xA4XR6tgBgRmcOimlCZyvreXpDi0cBn0e7Op3Gtb9GT+mvag2vQoL86sf
 J0f5gDbks/Dkv/ld51c1f0GgMocBOlWoIoOEdzcEOPTTrwnF/h8V0l0WfEqpLvGWNdWX
 pRsJzlcOFdUHpbWX4cx1FCRdE1h+ASi7U36zIZ2gY/fAR3a14ZS2bBkxXS4Pg3/6hmRG
 uxDTlXeWoVGVQ+nqd4wJZsOKg5SJvzrp201YnPYTjQuRSLi2j+7jVMsSPZO2TUloFe1t
 ZqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=glvZ+nCfB9TtbAroDymQkDFhBNuKdCgNd2JMzbDR3kI=;
 b=oyl2MgGnzd3s3lRmyxGmnAhLYMI1WHXbn1mWhgyXZL5mZmQSE6naW0aREKdelQISII
 KJneoQNFHeHL3OH35bW7l+ofEPdapmqHoEhJlX5jnmtK84NAZloJ6zK+ZEn3fjydUgiV
 6U4zM3hcSRNn9CnK2ZDgRW7TZAEb1X0o7OGYZsah7+xJBvuzPPZkyg7CMUkYqOKMzVZh
 /gJFDY+iKZXr12n+31iuD0Wyu7CCq0Ye/IaI0zKF/85WslpAbZudCx81vTbLy9ms/tym
 3FfHRkzewvyhAZcYRj9z+WYs5HV/Y5HnfoyZltIlgqfm4K8UBbSjB64pxsqO9kHUyla3
 lwpg==
X-Gm-Message-State: AOAM532JnAZ3w8mabLGxoq7x+n8z++8VmSpsZHaHXHHQAANJigMImYvZ
 Y50bJz4oZSfrPt3Ozr6wlZTKiA==
X-Google-Smtp-Source: ABdhPJx6LkZZbRlVWvf8Qceg5jpRQTiPkyf5Y3+HD6ZGTTavt9ztCUZdCVv8/v9Y3O4vJmgK1tv/Fw==
X-Received: by 2002:a62:7985:0:b029:1e1:1703:c2e7 with SMTP id
 u127-20020a6279850000b02901e11703c2e7mr10602461pfc.69.1613757286450; 
 Fri, 19 Feb 2021 09:54:46 -0800 (PST)
Received: from google.com ([2620:15c:f:10:903f:bec1:f9d:479b])
 by smtp.gmail.com with ESMTPSA id t2sm5997590pfg.152.2021.02.19.09.54.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Feb 2021 09:54:45 -0800 (PST)
Date: Fri, 19 Feb 2021 09:54:38 -0800
From: Sean Christopherson <seanjc@google.com>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 00/26] KVM/arm64: A stage 2 for the host
Message-ID: <YC/7XuB30N8C3sNx@google.com>
References: <20210108121524.656872-1-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
X-Mailman-Approved-At: Fri, 19 Feb 2021 13:11:37 -0500
Cc: devicetree@vger.kernel.org, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Fri, Jan 08, 2021, Quentin Perret wrote:
> [2] https://kvmforum2020.sched.com/event/eE24/virtualization-for-the-masses-exposing-kvm-on-android-will-deacon-google

I couldn't find any slides on the official KVM forum site linked above.  I was
able to track down a mirror[1] and the recorded presentation[2].

[1] https://mirrors.edge.kernel.org/pub/linux/kernel/people/will/slides/kvmforum-2020-edited.pdf
[2] https://youtu.be/wY-u6n75iXc
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
