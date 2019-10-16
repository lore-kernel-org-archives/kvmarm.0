Return-Path: <SRS0=103j=YJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AB6ECE599
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:10:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3EB842168B
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:10:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ACxjq5Tq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EB842168B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D96934A9A1;
	Wed, 16 Oct 2019 03:10:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LX9oncm7UH80; Wed, 16 Oct 2019 03:10:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAC754A97B;
	Wed, 16 Oct 2019 03:10:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4ACC4A978
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:10:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qRIdKiSDIkxl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Oct 2019 03:10:42 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0409D4A97B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:10:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1571209841;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=atkKBE+OhbQ4pOII4N38Iv93WpWN9YTy8W/dwEibJvo=;
 b=ACxjq5TqXYEs/g4Q87nJBpbK0rfwqbkth7Jqn+8D7tE2KA9hsfgpcBGZx25dpRDXF23XBC
 iXSwsvvieC65Rg9T/klXLiZOmSvZjWHrWxmD7DZ7Df2sDr0KyfqPdrURgTCCErSNNhoc0O
 vHWpYmtllzdfKEzJ2Xc37CHh2c4x1vY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-3FTPzMSSMYuXa1VMelx1kQ-1; Wed, 16 Oct 2019 03:10:38 -0400
Received: by mail-wm1-f71.google.com with SMTP id n3so761042wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 00:10:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=4KmZ9tmpXlk46xmJUogDKwLZzCFViFGNnmxsywrkhr4=;
 b=BGIxhSXaoQPCZ988lga8zY84Na2qaCqVkp0Qq7FWpPX0btyl3SKdBR6aElXzmTnw9F
 HpcKbe3MnYjnbf/UqQUz5/7SRX6ESeS8889xfUX9eBqlvrgmymCF43JQ/AujXfaLiWg9
 n7e9PNb8tWD5q1EiLYuiMX+/8dbnI7CyB7lbs3txSgTtuQ/i2tQZ7H1QQ5huNOcDAV7w
 DWSinYUEOHv5+z0iamH2zxcPjPZjFsWlMDF8RGycn5ESMTkVPNzTE0QLbaIhKvDb6umE
 vsliaW3vW7hqA6OHekorEiRK2ufnFW/kRFh+OcTnfRrtjsDMDgffr/ci4cTQhzt8L09f
 0ZPg==
X-Gm-Message-State: APjAAAUuCJCsXFMzRI71OW3kOPi+YeaGf+ezGflGtKk8unKUJwrjIOWg
 QcVE+SqIrK+xqL8BsxL1pjVwpAq0vVeRxDXzGvsrqEFbQLyDe2/7OiXKV+KNNGirhXsbJu3reMR
 U7R0/KdFy9VBpNUqoBX22U6E6
X-Received: by 2002:adf:cc8e:: with SMTP id p14mr1344873wrj.301.1571209837020; 
 Wed, 16 Oct 2019 00:10:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyMkepD45un/zag7gKTc+lFp9N0/XMwW6mC1kmyUCBXgrwtYogoeP8y+AmUc8Y9iVF713Y8IQ==
X-Received: by 2002:adf:cc8e:: with SMTP id p14mr1344860wrj.301.1571209836713; 
 Wed, 16 Oct 2019 00:10:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e?
 ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
 by smtp.gmail.com with ESMTPSA id z189sm2973051wmc.25.2019.10.16.00.10.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Oct 2019 00:10:36 -0700 (PDT)
Subject: Re: [PATCH v5 5/6] ptp: arm64: Enable ptp_kvm for arm64
To: "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 Mark Rutland <Mark.Rutland@arm.com>, "will@kernel.org" <will@kernel.org>,
 Suzuki Poulose <Suzuki.Poulose@arm.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-6-jianyong.wu@arm.com>
 <da62c327-9402-9a5c-d694-c1a4378822e0@redhat.com>
 <HE1PR0801MB167654440A67AF072E28FFFDF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e9bfd40-4715-74b3-b5d4-fc49329bed24@redhat.com>
Date: Wed, 16 Oct 2019 09:10:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB167654440A67AF072E28FFFDF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Language: en-US
X-MC-Unique: 3FTPzMSSMYuXa1VMelx1kQ-1
X-Mimecast-Spam-Score: 0
Cc: "Justin He \(Arm Technology China\)" <Justin.He@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd <nd@arm.com>,
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

On 16/10/19 05:52, Jianyong Wu (Arm Technology China) wrote:
> This func used only by kvm_arch_ptp_get_clock and nothing to do with
> kvm_arch_ptp_get_clock_fn. Also it can be merged into
> kvm_arch_ptp_get_clock.
> 

Your patches also have no user for kvm_arch_ptp_get_clock, so you can
remove it.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
