Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A9EC636C9
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 17:56:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 107D061283
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 17:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 107D061283
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88F914B100;
	Wed, 21 Jul 2021 13:56:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rAX-GIAo-6-F; Wed, 21 Jul 2021 13:56:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 759294A19A;
	Wed, 21 Jul 2021 13:56:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 139644A19A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 13:56:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gstAxyXIWCG7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 13:56:48 -0400 (EDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com
 [209.85.218.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D4D3F49F6C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 13:56:47 -0400 (EDT)
Received: by mail-ej1-f53.google.com with SMTP id hr1so4546636ejc.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 10:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=vrMphr3tpItn2w3bBK1L8WnMR/wafltXE6Any2pLriw=;
 b=rtdiKAHwaRqh8X+FKuOHGfbcpYhyq06wimQpNcQgPkZTz6/eAvUT1D1HBNHj5YoaLE
 X+vmixOJr4r15Dzo1zBi6hI0mIbdzMsUdGxXCqFMnKc5ROVW3dXItOh2of/2WPOU8+Yk
 6V2CFYdkbmpsPZis/khwXfYZdxSav5Eai2B/Qj1bjP3yeYHdYbkjQXkMCXkWzO3pm9JG
 LVxyY1yhCYvmuCdyV/944q6XZ0Dbz/mXKkDAqlCUF+JXdM6e/0elAqQoszltebGx1Rbq
 6siHkU46e8dFc3XhRcnMXXQl+lv0FrdkasnCdiQWlL0cSBohyrZ5lqB197OkMaJYMuzB
 dNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vrMphr3tpItn2w3bBK1L8WnMR/wafltXE6Any2pLriw=;
 b=RE5bNY6fxoL0nWH6+0N3katnz9eGanK+kGL+DIStp8q0S8oVPxU0gUARQHCJKJVzr3
 uWv85ar7cENx4yQTdwTj1zYngWJ63LpG8JhrNPikpOaOV/R1GvwpwsuOCFlNsmD8I6Lg
 F2M89FrJdWbiYaOuxTQBwW6xFp09T8bdh5vpKAj+0FJ7hO39uK1AkBie+DGeackaaGMB
 J1w9m043u0dRhxNAR1gXhxMVHi2+TEx1YtKo3Mq95IrFC5mGzE2fVQ4lG+voO8BqfX8w
 sRmbjK6HNxnrkiIICCje15smZWmVNLcWYMWFRaFY3N+sW2mtVTrY10mw5F523LMn0AAv
 Zw7w==
X-Gm-Message-State: AOAM532sFZ/MYGBSONZ1Xpl06AricrRZpZMBXPl8Hw3kdDP3aVAL9S+M
 KKTXJm/RzEykVX0bejgWn0pgPw==
X-Google-Smtp-Source: ABdhPJztICbLBjabcxqrQBD4WycfWu5/hNk/dhR2NO6b/fMWzVqkTTn/NuY6CqSY8ILFXvSFOtrYAg==
X-Received: by 2002:a17:906:4ad9:: with SMTP id
 u25mr39222251ejt.174.1626890206835; 
 Wed, 21 Jul 2021 10:56:46 -0700 (PDT)
Received: from myrica (adsl-84-226-111-173.adslplus.ch. [84.226.111.173])
 by smtp.gmail.com with ESMTPSA id p5sm6130708ejl.73.2021.07.21.10.56.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 10:56:46 -0700 (PDT)
Date: Wed, 21 Jul 2021 19:56:25 +0200
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Pass PSCI to userspace
Message-ID: <YPhfyVUIKHW9xF22@myrica>
References: <20210608154805.216869-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210608154805.216869-1-jean-philippe@linaro.org>
Cc: salil.mehta@huawei.com, lorenzo.pieralisi@arm.com, kvm@vger.kernel.org,
 corbet@lwn.net, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 will@kernel.org, jonathan.cameron@huawei.com, pbonzini@redhat.com,
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

On Tue, Jun 08, 2021 at 05:48:01PM +0200, Jean-Philippe Brucker wrote:
> Allow userspace to request handling PSCI calls from guests. Our goal is
> to enable a vCPU hot-add solution for Arm where the VMM presents
> possible resources to the guest at boot, and controls which vCPUs can be
> brought up by allowing or denying PSCI CPU_ON calls.

Since it looks like vCPU hot-add will be implemented differently, I don't
intend to resend this series at the moment. But some of it could be
useful for other projects and to avoid the helpful review effort going to
waste, I fixed it up and will leave it on branch
https://jpbrucker.net/git/linux/log/?h=kvm/psci-to-userspace
It now only uses KVM_CAP_EXIT_HYPERCALL introduced in v5.14.

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
