Return-Path: <SRS0=1Vfj=WT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBF1C3A5A3
	for <kvmarm@archiver.kernel.org>; Fri, 23 Aug 2019 17:08:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A1AF422CE3
	for <kvmarm@archiver.kernel.org>; Fri, 23 Aug 2019 17:08:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1AF422CE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0910A4A60E;
	Fri, 23 Aug 2019 13:08:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5pv9aBDvmSYm; Fri, 23 Aug 2019 13:08:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05FE84A602;
	Fri, 23 Aug 2019 13:08:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36D6A4A5FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Aug 2019 13:08:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rZCaBGr3-EhU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Aug 2019 13:08:03 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A4524A5B1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Aug 2019 13:08:03 -0400 (EDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 1AA5D4E4E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Aug 2019 17:08:02 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id f14so3148955wmh.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Aug 2019 10:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=L7CFzFZcBTFDB9gXZjKJlWNHgFbguv8P194zUY7iBjo=;
 b=QQ03KUoBi3Q7igwQXb5sW+1jBLIltIy0D+3eIun4Jv6M4qvtrMBYWcLusfPJp5UPab
 U0ybRuQw/c/ZqM2yA6X/OIyXM5F1OkBTNNn166noDzg4mj5JjXadLbhH7b64y84Sc6hI
 2E+mPTlpOn+Y7lWgAPSuhJXu2Ws+SdxrVNOammoBe7pWMsEwdC6+iy6bAPkPfmWIU6fs
 AuUwtCMLym9p85pfieU2TgJK9kgBcV0yhyCLCrFxZASveoSGjJQo5MUAPkb8623BUm96
 +2WO0MdPike1Rn7zpqfRFfszp+aKZNLmEMUTWhtgX3+wh6ju0YDC7a2K2H1ff8lhv3Oa
 maCw==
X-Gm-Message-State: APjAAAXvo1Hq1U84i3T0bS/kLmcEj95wsYhiW5QhAZk4Ud1cgK6sHVc0
 bnqNVbiuG/rIj2QstIp/ubGAlSdBI3NiMjlGcxsreXwFN14Izq/CIReLVLm2wWkl+sLEzQxIns8
 vo03muurV4aTp2BVf1LWKnC5G
X-Received: by 2002:a1c:6145:: with SMTP id v66mr6820126wmb.42.1566580080623; 
 Fri, 23 Aug 2019 10:08:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz2VfVqVmbNSKh60msz2D85O4kPeYbsxyx65VFv1ZLWWCCH6sSVLhBJZ0JI2ziJHjDOK7yijA==
X-Received: by 2002:a1c:6145:: with SMTP id v66mr6820078wmb.42.1566580080242; 
 Fri, 23 Aug 2019 10:08:00 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
 by smtp.gmail.com with ESMTPSA id n8sm3065205wrw.28.2019.08.23.10.07.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 23 Aug 2019 10:07:59 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm updates for 5.3-rc6
To: Marc Zyngier <maz@kernel.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>
References: <20190823163516.179768-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <21ae69a2-2546-29d0-bff6-2ea825e3d968@redhat.com>
Date: Fri, 23 Aug 2019 19:07:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190823163516.179768-1-maz@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, Christian Borntraeger <borntraeger@de.ibm.com>,
 Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org,
 Dave Martin <dave.martin@arm.com>
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

On 23/08/19 18:35, Marc Zyngier wrote:
> Paolo, Radim,
> 
> One (hopefully last) set of fixes for KVM/arm for 5.3: an embarassing
> MMIO emulation regression, and a UBSAN splat. Oh well...
> 
> Please pull,

Please send this (and any other changes until the release) through the
ARM tree---same for s390 if need be.

This way Radim can concentrate on pending 5.4 patches while I am away.

Paolo

>        M.
> 
> The following changes since commit 16e604a437c89751dc626c9e90cf88ba93c5be64:
> 
>   KVM: arm/arm64: vgic: Reevaluate level sensitive interrupts on enable (2019-08-09 08:07:26 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.3-3
> 
> for you to fetch changes up to 2e16f3e926ed48373c98edea85c6ad0ef69425d1:
> 
>   KVM: arm/arm64: VGIC: Properly initialise private IRQ affinity (2019-08-23 17:23:01 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm fixes for 5.3, take #3
> 
> - Don't overskip instructions on MMIO emulation
> - Fix UBSAN splat when initializing PPI priorities
> 
> ----------------------------------------------------------------
> Andre Przywara (1):
>       KVM: arm/arm64: VGIC: Properly initialise private IRQ affinity
> 
> Andrew Jones (1):
>       KVM: arm/arm64: Only skip MMIO insn once
> 
>  virt/kvm/arm/mmio.c           |  7 +++++++
>  virt/kvm/arm/vgic/vgic-init.c | 30 ++++++++++++++++++++----------
>  2 files changed, 27 insertions(+), 10 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
