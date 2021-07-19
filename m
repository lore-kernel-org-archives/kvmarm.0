Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55527C07E95
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 19:38:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE5ED61107
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 19:38:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE5ED61107
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 399804B0E1;
	Mon, 19 Jul 2021 15:38:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jh6bJrM3KfoH; Mon, 19 Jul 2021 15:38:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B50A4B0DC;
	Mon, 19 Jul 2021 15:38:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5C274B08A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 15:38:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FXQmI6WJqzAo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 15:38:05 -0400 (EDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com
 [209.85.167.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FD25407D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 15:38:05 -0400 (EDT)
Received: by mail-lf1-f54.google.com with SMTP id y42so32126773lfa.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=wDda5dbFXyknFG+xoYFL2uxWIVC+IEB+7xC2zqUFwSc=;
 b=C2kt/tLjq50F2/8YiWA2vApdMGBU1c/5g8q0V7XaPGvDRnYu01eyxREz3eqyUTFPjo
 +RkvlkvZfYICjMHAI8gTK9GAf+/flWsUK+v7GAxtmc+xq9D5SUVbZ+DUZ9CiQxzMeanC
 YwYKYS3yuZmuX9KNoLodu1DiX6u9M1TDj8A4sNlA8pqZqXdGe8vk+eCXrW99r7bbq4xn
 aezOsvO51i/RTsOu+xwDKXdMBUxnzitKNY74AjA/4ymoyUgfBT077E45qJa7F/qXUBWW
 ztnTsieI6KT6/2V/OeLJPzcwydkdGfXsTY7HAJUxHWTKjw57wll20Q46XtDXCQNoAQ7m
 jF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=wDda5dbFXyknFG+xoYFL2uxWIVC+IEB+7xC2zqUFwSc=;
 b=PnqWhXcPqttidEzrC1YsMTx09NgCyIzgH+v+CX0yAJJ1n/EgflXDHu/pQR69KgwUqU
 y8tpUwD3lLlXgUCHrFd9tFCBCBsFrNuWq/sp1FKDx7Oiiuu9Rac7owcPyDIl+PxKPMOr
 2+CAQckTiGcJqil81hQ9qr0LJZnNKitGS+9ePZwu+TBWP7sFYf9huwwMTjJ+xag8N0B6
 8YNKXS15V1r/bn0etaQNSVxP1W+AxkYlyJ7RCp/Zxzmi/sHP6R/d3yHxApqZ56VkyN9O
 Xm7uV3L74YW+GTnXs6SexezWu5PztPGNgJ9eaftqUvMM3RZllp8XlAsHbbIUgG7+M7uU
 89Rg==
X-Gm-Message-State: AOAM532RHMnn5H8mtUeCS2v1Mg0Hz4Wd4aRNGP9bES8pRfJySgAiSKbM
 dwqXpVlzLNpIpK3WTgDEkTNgNVxQepVryWEGaw5r5Q==
X-Google-Smtp-Source: ABdhPJyPUYUhTA7ZwgH8jo3MfY2NUldDSUZwBUe+PjpACyXQEbBrAmTn2pGTqyellwWFMuv9G9LvWhR2OIXXWG8rOvc=
X-Received: by 2002:ac2:46d0:: with SMTP id p16mr19415538lfo.23.1626723483858; 
 Mon, 19 Jul 2021 12:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210608154805.216869-1-jean-philippe@linaro.org>
 <c29ff5c8-9c94-6a6c-6142-3bed440676bf@arm.com> <YPW+Hv3r586zKxpY@myrica>
In-Reply-To: <YPW+Hv3r586zKxpY@myrica>
From: Oliver Upton <oupton@google.com>
Date: Mon, 19 Jul 2021 12:37:52 -0700
Message-ID: <CAOQ_QsjyP0PMGOorTss2Fpn011mHPwVqQ72x26Gs2L0bg2amsQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Pass PSCI to userspace
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: salil.mehta@huawei.com, lorenzo.pieralisi@arm.com, catalin.marinas@arm.com,
 kvm@vger.kernel.org, corbet@lwn.net, maz@kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, jonathan.cameron@huawei.com,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jul 19, 2021 at 11:02 AM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
> We forward the whole PSCI function range, so it's either KVM or userspace.
> If KVM manages PSCI and the guest calls an unimplemented function, that
> returns directly to the guest without going to userspace.
>
> The concern is valid for any other range, though. If userspace enables the
> HVC cap it receives function calls that at some point KVM might need to
> handle itself. So we need some negotiation between user and KVM about the
> specific HVC ranges that userspace can and will handle.

Are we going to use KVM_CAPs for every interesting HVC range that
userspace may want to trap? I wonder if a more generic interface for
hypercall filtering would have merit to handle the aforementioned
cases, and whatever else a VMM will want to intercept down the line.

For example, x86 has the concept of 'MSR filtering', wherein userspace
can specify a set of registers that it wants to intercept. Doing
something similar for HVCs would avoid the need for a kernel change
each time a VMM wishes to intercept a new hypercall.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
