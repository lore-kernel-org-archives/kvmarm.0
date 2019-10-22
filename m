Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01C5CA9EA0
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 11:34:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 793CF2075A
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 11:34:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 793CF2075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E00854A991;
	Tue, 22 Oct 2019 07:34:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EOa5BjspXd-Y; Tue, 22 Oct 2019 07:34:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E80A4A970;
	Tue, 22 Oct 2019 07:34:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A698E4A96D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 07:34:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J6wXDL87Ihyo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 07:34:22 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 751A64A968
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 07:34:22 -0400 (EDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 821334E926
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 11:34:21 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id z205so7314559wmb.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 04:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=hKISof+jZanOjFuAMb7NpTQQo5K+nkz0naeOg86T7Ow=;
 b=IxI7uNst/aGUohgMz4AKP5QCDSrAu+yWZeyQ2qKx7SSYPneS1wfGp89bIR1ycICy0g
 +9d12KZw20W3jeO/MZ02pnN6rzGmED4huq1lXGZOtJVXxx1HOp/A5iwngla+Qe24Ly0r
 S9hISB6czvy9GIZj/FI5OcoZjAV6holwd7PQM3CGk7870/F9YjJACs8WFDYJtyuPSZMM
 iN0lUu90IbOIaLfJOhqi8JzllqjlgGI0t11MTtWSGsqifYuZNMH+iboqj85W6iaGrz2a
 V76AgE3Ec4pDlU5GB7y5DJLKGI7TmWqTmNa6uPLvfNylytVvCmCXtVFIrxt1iLSDR1Yl
 mf4A==
X-Gm-Message-State: APjAAAX0/B1sHyjsMzFAXwcUjCez+UjWUYoEDbLpiPvXlQvYTtSyzQcz
 MRWxtSWg5GarWapb1JSHHdH7RJ11A4nJOAssFGb3DifvT16t3dnDRYrHDDrxGUpdg79M51RFwOs
 KGGnCrf0FGRzXbwdXhy/g9V1Q
X-Received: by 2002:a5d:4341:: with SMTP id u1mr3122520wrr.306.1571744059707; 
 Tue, 22 Oct 2019 04:34:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy0sYBGB7epCnwESA0v66tQGqclr5cgWDSQmRWvyyuLm8Mc9lam9XOd18v3dCyWbw4+tpHmjA==
X-Received: by 2002:a5d:4341:: with SMTP id u1mr3122496wrr.306.1571744059423; 
 Tue, 22 Oct 2019 04:34:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19?
 ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
 by smtp.gmail.com with ESMTPSA id x8sm17229628wrr.43.2019.10.22.04.34.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Oct 2019 04:34:18 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm fixes for 5.4-rc5
To: Marc Zyngier <maz@kernel.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>
References: <20191020101129.2612-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e639182e-fbd9-c7a1-43b0-5889a0e61930@redhat.com>
Date: Tue, 22 Oct 2019 13:34:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191020101129.2612-1-maz@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

On 20/10/19 12:11, Marc Zyngier wrote:
> Paolo, Radim,
> 
> Here's the latest (and hopefully last) set of KVM/arm fixes for
> 5.4. 4 patches exclusively covering our PMU emulation, which exhibited
> several different flavours of brokenness.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit da0c9ea146cbe92b832f1b0f694840ea8eb33cce:
> 
>   Linux 5.4-rc2 (2019-10-06 14:27:30 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.4-2
> 
> for you to fetch changes up to 8c3252c06516eac22c4f8e2506122171abedcc09:
> 
>   KVM: arm64: pmu: Reset sample period on overflow handling (2019-10-20 10:47:07 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm fixes for 5.4, take #2
> 
> Special PMU edition:
> 
> - Fix cycle counter truncation
> - Fix cycle counter overflow limit on pure 64bit system
> - Allow chained events to be actually functional
> - Correct sample period after overflow
> 
> ----------------------------------------------------------------
> Marc Zyngier (4):
>       KVM: arm64: pmu: Fix cycle counter truncation
>       arm64: KVM: Handle PMCR_EL0.LC as RES1 on pure AArch64 systems
>       KVM: arm64: pmu: Set the CHAINED attribute before creating the in-kernel event
>       KVM: arm64: pmu: Reset sample period on overflow handling
> 
>  arch/arm64/kvm/sys_regs.c |  4 ++++
>  virt/kvm/arm/pmu.c        | 48 ++++++++++++++++++++++++++++++++++-------------
>  2 files changed, 39 insertions(+), 13 deletions(-)
> 

Pulled, thanks.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
