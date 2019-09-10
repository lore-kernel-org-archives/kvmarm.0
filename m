Return-Path: <SRS0=7IkQ=XF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA53C49ED9
	for <kvmarm@archiver.kernel.org>; Tue, 10 Sep 2019 17:09:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9BC8D2089F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Sep 2019 17:09:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BC8D2089F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B6614A599;
	Tue, 10 Sep 2019 13:09:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DvjhbdiuklOC; Tue, 10 Sep 2019 13:09:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B99E4A5E3;
	Tue, 10 Sep 2019 13:09:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAA954A5E0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Sep 2019 13:09:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CLKVrxleu9zm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Sep 2019 13:09:24 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A98CC4A599
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Sep 2019 13:09:24 -0400 (EDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id DC27DC015C30
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Sep 2019 17:09:23 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id f10so121058wmh.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Sep 2019 10:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=N6OgVWm3LipI6S2dhNRtI34S9LNNCSkrvYxcJwqfZsI=;
 b=CXlvqFMqSIjWqFdRIJJ9I3UwGVJxHZq2/K8PHZKQv0IV0/jajnxyvM5gxqv0OcvW8c
 dIHY0+HW7FOOVmI9bXCqlPOMErNrZqCZigrS2yDX8ZDcMRs2YRDFQA+pBppz1rWT5eeL
 ngplQj0L3vzaFkIMCpLCPfpl1heWGO2HFCaM5CxBHcP0PhSKvmU/u2faFaKBm93zopjj
 7U7dNT2HuTnjc5eN6Ufx2pZPNvBEd0hsxaeWrX9TLpT8EE4tVQ5JLtpIyCM+LJfKQKXZ
 nfpNwj3BnH6DFxffevkKWjUw3mkIGewcdNmbVp4teA7fTEmp3DGja9d8FrsKY0TleOMp
 wAaQ==
X-Gm-Message-State: APjAAAVrkUPrP+Yy8nYjaQQlnE85TJtTUaIfypMmdPc9+Dt9v7g9egcF
 OmxD0DSu7FSm2n1Ci+Nqpdd7mjqW6R7j8uiRpLQ0ViOWU1IEqwmzsmlrGKKi/dnYny9hPMj3ejf
 CJvE82hBKeyRsLgsSnxRC95OI
X-Received: by 2002:a7b:c922:: with SMTP id h2mr436532wml.63.1568135362534;
 Tue, 10 Sep 2019 10:09:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxYTqc0EPZJui9RRlRkbko3iJmJuc0qI4AmciigJIrk+NreoBnAJ7W6d/VwZU9kBdxQPOnWqg==
X-Received: by 2002:a7b:c922:: with SMTP id h2mr436510wml.63.1568135362307;
 Tue, 10 Sep 2019 10:09:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1435:25df:c911:3338?
 ([2001:b07:6468:f312:1435:25df:c911:3338])
 by smtp.gmail.com with ESMTPSA id q25sm383779wmq.27.2019.09.10.10.09.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 10 Sep 2019 10:09:21 -0700 (PDT)
Subject: Re: [PATCH 00/17] KVM/arm updates for 5.4
To: Marc Zyngier <maz@kernel.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>
References: <20190909134807.27978-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3d822288-2517-0667-dfad-45f77a918738@redhat.com>
Date: Tue, 10 Sep 2019 19:09:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/09/19 15:47, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.4

Pulled, thanks.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
