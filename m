Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE37FC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 21:57:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35E7361A02
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 21:57:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 35E7361A02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8745C4B091;
	Thu, 30 Sep 2021 17:57:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I+rmj-h+iWbD; Thu, 30 Sep 2021 17:57:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50E004B099;
	Thu, 30 Sep 2021 17:57:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0BEC4083E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 17:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qipr1yRA6zmK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 17:57:22 -0400 (EDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB36240667
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 17:57:22 -0400 (EDT)
Received: by mail-lf1-f53.google.com with SMTP id x27so31135693lfu.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 14:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1VJrgIZzgtxa6YpK70z/m29SP7Hw5UszTAKK7fc3/DA=;
 b=A5QE5aV4FIKYCFm4FmQJcVJLo3lzWAM2HM8tjo7vFO3aObQQQ6S1vDpJQNxxmaRfQb
 NV84RP6IXgMoedcU3jSVFTm7rWCTWZ3jDyux6m+dsVXjQfvMstMsaaywrhjpRc8WIMyC
 9VnoFr868cR1XBqTKlANmDLBnmPd9EqeljHG9vP8jv06ft+yU53GPjvX9cr+yQ7jK7Jh
 6vrar2o/0bvLjjcXancx3vxwwXyw4j7FjxmniEHSiMqyinpIEajGEjylyZpLzrqBskgp
 2KNOzYBGd24afmcU9Y57qwZed6D5lqOJJcVxsrYl0Z1WQkYfFAvKAXivvQUac0HuGbx2
 YwkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1VJrgIZzgtxa6YpK70z/m29SP7Hw5UszTAKK7fc3/DA=;
 b=IWkqfsWoba2bOKmRBcG5wZ+4xK8xBmka+uS7dBPu5F7bgIpOJ1SUVlx4NZ6TIEERQs
 S+61+4ko/ax6YLv9OBiYAAp+cNGjm+PLPUqFeOXl4F8gEpAuQ13RRSiFrvgEfHQAyUus
 rZvlhgAFq/dneihSAvOaAp45GHCEjDHw8Fqerv2MoQAMrfNouSQigABbWG7yvB0zZpVD
 7AC+CWqk4PBPALbR92I7ayOrrjU4eNXoZBgqjFuPWTHhB5KheASPS1amFn91QpWanAMu
 RIDlzs54VfCUXm71Si72NjfCONXeghVZHuBgvaoRr7ORH/m9LRTSyg/pxynm5FoICfiy
 YWsQ==
X-Gm-Message-State: AOAM532SC2AYKJBu7eDFMosuqWk7wnE7t9PvxszQOU5PWqKS6HbM75lA
 WNBK8iQZg6Y2WgRjRAjgLw72UaLhRtq1duJYfrG8Bw==
X-Google-Smtp-Source: ABdhPJwNjZ1Ft7Rzgz1bsFFoRB4MAZdYHAhGAclXUZdIGmyqv+o7vcKq3MEtf03pMU0UI0S/+P5WJEKkm/8e6nprZTQ=
X-Received: by 2002:a2e:719:: with SMTP id 25mr8749326ljh.251.1633039041032;
 Thu, 30 Sep 2021 14:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-6-oupton@google.com>
 <878rzetk0o.wl-maz@kernel.org> <YVXvM2kw8PDou4qO@google.com>
 <CAOQ_QsjXs8sF+QY0NrSVBvO4xump7CttBU3et6V3O_hNYmCSig@mail.gmail.com>
 <YVX9IOb1vyoJowQl@google.com>
In-Reply-To: <YVX9IOb1vyoJowQl@google.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 30 Sep 2021 14:57:10 -0700
Message-ID: <CAOQ_QshZsDEt6T2=EwyzwUi-hPoz5u-BnjOnuOj=ufmRWUB=0A@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] KVM: arm64: Defer WFI emulation as a requested
 event
To: Sean Christopherson <seanjc@google.com>
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

On Thu, Sep 30, 2021 at 11:08 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 30, 2021, Oliver Upton wrote:
> > On Thu, Sep 30, 2021 at 10:09 AM Sean Christopherson <seanjc@google.com> wrote:
> > > Unlike PSCI power-off, WFI isn't cross-vCPU, thus there's no hard requirement
> > > for using a request.  And KVM_REQ_SLEEP also has an additional guard in that it
> > > doesn't enter rcuwait if power_off (or pause) was cleared after the request was
> > > made, e.g. if userspace stuffed vCPU state and set the vCPU RUNNABLE.
> >
> > Yeah, I don't think the punt is necessary for anything but the case
> > where userspace sets the MP state to request WFI behavior. A helper
> > method amongst all WFI cases is sufficient, and using the deferral for
> > everything is a change in behavior.
>
> Is there an actual use case for letting userspace request WFI behavior?

So for the system event exits we say that userspace can ignore them
and call KVM_RUN again. Running the guest after the suspend exit
should appear to the guest as though it had resumed. Userspace could
do something fancy to handle the suspend (save the VM, wait for an
implementation defined event) or ask the kernel to do it. To that end,
the MP state is needed to tell KVM to WFI instead of starting the
guest immediately.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
