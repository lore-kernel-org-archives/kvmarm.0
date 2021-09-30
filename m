Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C74C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 18:08:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 021216126A
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 18:08:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 021216126A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 759EB4B0BD;
	Thu, 30 Sep 2021 14:08:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J8p+b9lGiIBz; Thu, 30 Sep 2021 14:08:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33E984B0B4;
	Thu, 30 Sep 2021 14:08:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7BD54B08E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 14:08:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2u71SeicvAZo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 14:08:37 -0400 (EDT)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD4F849F5F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 14:08:37 -0400 (EDT)
Received: by mail-pl1-f178.google.com with SMTP id b22so4633256pls.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 11:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=EoZfu8bpen5KFMUVG6jLqzqied/lYe6mK0ma9Cef8Os=;
 b=bXQfSxmBXOfT4WF1wCJ2uHhAn2c04X0SQKHS2xapCL9/Uhsl4XxrYsrnsseZhnbA60
 b3qEkUcxB21kqfR4mXgiff7CBu78x9TTEzl0jDrljzdTFi35bN/2k1dmNFkQpcTLFTtN
 C2Ky2PMllbuODghV5eIb0Yxe1DYKlq4jSZtLsriuQVzE7BwnOUkmePZH1dGOpGKmhIye
 UxrQ77bpWdbAQDK/csIhkwjanA6B3nYpkd89EVa9Gwi3gvs1YvJFs+XoYLjw/9MMVkmm
 kCxoN1yVCaXXDLrTwAI4w+eoV5ZCrwXGMd+XNb100w15ojbpdx+k+/6m6X+PqPdIz+jO
 DG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=EoZfu8bpen5KFMUVG6jLqzqied/lYe6mK0ma9Cef8Os=;
 b=WqTeAvaS7i1MbfDLBnkSgbug4UcFMDEu3LV+eTBpTCkMq/1mzJppj6SyCX7W3k7LlF
 Bx0nEBHlcjl3v1Q03ccGcWjn4fK8Y3O81ohZx7YA202YngDuhOT/GPXjlFIVQN9+X+eh
 prafwrYFW2i668roe5GX0yURG8+rJZXa0Rx2RyDOeBGgawAIY9Q1bGJck+sWIz6cBkLS
 DtYURyWYiXMCon7bplXWZImK/lM+XaQRR1/gpkP/DpOlfpSfmAkW5Nk2XE6lDx8qlWDL
 Ijb8i+5WgOcmqnI7BhQoCGZBj5u2OOVv3MBeKiYF3R3CfejVS9liGMaYqUCtDkEJmIyD
 +Mqw==
X-Gm-Message-State: AOAM5313D678TwLiquqmdeiNWAz1z0ouJUg84+z+LCBSzkSqt6EquXcJ
 C9rv1T3TEU8f2HAC5AVar83QOw==
X-Google-Smtp-Source: ABdhPJyofT3EyCRTUH4uH/kvj1uCfmupdajOzWbRL4wny0VfkHxLMQqDTXmIdg75I/pNah8kDYB0sQ==
X-Received: by 2002:a17:90b:38d0:: with SMTP id
 nn16mr3499466pjb.112.1633025316319; 
 Thu, 30 Sep 2021 11:08:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id d22sm3668968pgi.73.2021.09.30.11.08.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Sep 2021 11:08:35 -0700 (PDT)
Date: Thu, 30 Sep 2021 18:08:32 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 05/11] KVM: arm64: Defer WFI emulation as a requested
 event
Message-ID: <YVX9IOb1vyoJowQl@google.com>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-6-oupton@google.com>
 <878rzetk0o.wl-maz@kernel.org> <YVXvM2kw8PDou4qO@google.com>
 <CAOQ_QsjXs8sF+QY0NrSVBvO4xump7CttBU3et6V3O_hNYmCSig@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ_QsjXs8sF+QY0NrSVBvO4xump7CttBU3et6V3O_hNYmCSig@mail.gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Thu, Sep 30, 2021, Oliver Upton wrote:
> On Thu, Sep 30, 2021 at 10:09 AM Sean Christopherson <seanjc@google.com> wrote:
> > Unlike PSCI power-off, WFI isn't cross-vCPU, thus there's no hard requirement
> > for using a request.  And KVM_REQ_SLEEP also has an additional guard in that it
> > doesn't enter rcuwait if power_off (or pause) was cleared after the request was
> > made, e.g. if userspace stuffed vCPU state and set the vCPU RUNNABLE.
> 
> Yeah, I don't think the punt is necessary for anything but the case
> where userspace sets the MP state to request WFI behavior. A helper
> method amongst all WFI cases is sufficient, and using the deferral for
> everything is a change in behavior.

Is there an actual use case for letting userspace request WFI behavior?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
