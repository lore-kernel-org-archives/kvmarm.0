Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4667C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 16:51:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2953D60FF2
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 16:51:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2953D60FF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 949144B1E9;
	Mon, 13 Sep 2021 12:51:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J5Wx6n2g+vxQ; Mon, 13 Sep 2021 12:51:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 868924B121;
	Mon, 13 Sep 2021 12:51:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 920EC4B121
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 12:51:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 85HLV6C9rqEd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 12:51:47 -0400 (EDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com
 [209.85.219.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A89414B11E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 12:51:47 -0400 (EDT)
Received: by mail-yb1-f174.google.com with SMTP id c206so21815048ybb.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 09:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=3/SIYclYJBA8R/7MLXxAd/hpBEuATYrK81iK2vA0aLI=;
 b=UaGSj5rF9TV4TbKEczi4abu9Nvmk3QFlrNsZ94RkSIZo5XRGdw1+Yp8wU1bW9ZIKU7
 qVYpBNuU+BqPWj1VV0lFT/GWawzyPNcOXttDDmhFRg+yEyIx+9mPVAx48lK+heY3iA3U
 HfCW9WvnXI6sbmUfIeRc2nkS12QocvHXtxiMMfataHdNLwYk/dbbfasez2yumAPudGYC
 n/k5QceOvkIZ5XWqkUBFnHcWLXjV0SJXVTJO0j+H5/1iEevGYv+hiF5UfvY0YT6vNala
 zKfQdTpdroaT4Tu5XUNzVCE60Q3x49dFineIsNw6rXKH899hYBUZPrQ4vrEEBC5tbuni
 gB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3/SIYclYJBA8R/7MLXxAd/hpBEuATYrK81iK2vA0aLI=;
 b=Rlnyt9VwL/CMYhiVTgsBipsUPd109MpbiSZDd09oKTMi21MS1GR88uY+X64W1wp7uo
 wTJQixWC5W96lkRJUWmNBPo10WN1vwtM19ajDZHa97Zy+5UlnelQO59Z1UVbwjQuE4dU
 mCAA5b13V5bc8wVfs86zQURMejf9PLXjl6DkWwPswntf/1W1LjCSKUWIKBiJIC4c6A9O
 Ad/HAtX+u67We3dmfrNW8pFD43Up8HzxQV+dXMEfXIpEOpFsPXbLwblJ/9UgKrl7zhEO
 4CIRAovutmUSG6d0I1DjEpQjZjp/mAuEUwM7FQRa/zFIHRon+KeagQzv5QnZQqHKtTVU
 EDFQ==
X-Gm-Message-State: AOAM532IFuy0LCbgaBcWiZ8lPXGyEiZ6LEgz+5Z5juNGwWeg+qGEAPm8
 s/tJLY5ZYmBCoucFK+C2ABmyAonwRarknuZCKzrwrA==
X-Google-Smtp-Source: ABdhPJxF0MJAT41gnQOnRX7DjWFM0GLtwxdoVZIW+Gw+fILuc0cKnD6bHktwWwOauF6yqJrWs2OzSb/bX+FogXn7Y8c=
X-Received: by 2002:a25:50c7:: with SMTP id
 e190mr17068088ybb.439.1631551907001; 
 Mon, 13 Sep 2021 09:51:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
 <CAAeT=Fw0Z1USVpdi2iRMRq0ktTP4+VFzfy31FWV36VPOCTq6_w@mail.gmail.com>
 <20210913073512.x774i5hi3s4wmopx@gator.home>
In-Reply-To: <20210913073512.x774i5hi3s4wmopx@gator.home>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 13 Sep 2021 09:51:35 -0700
Message-ID: <CAJHc60wVJP4=s3r16nLWXA8o=k71OagvLFrWVWwJJnLycHMQyw@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Sep 13, 2021 at 12:35 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Sun, Sep 12, 2021 at 12:05:22AM -0700, Reiji Watanabe wrote:
> > Hi Raghu and all,
> >
> > On Wed, Sep 8, 2021 at 6:38 PM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > >
> > > At times, such as when in the interrupt handler, the guest wants
> > > to get the vcpuid that it's running on. As a result, introduce
> > > get_vcpuid() that returns the vcpuid of the calling vcpu. At its
> > > backend, the VMM prepares a map of vcpuid and mpidr during VM
> > > initialization and exports the map to the guest for it to read.
> >
> > How about using TPIDR_EL1 to hold the vcpuid ?
> > i.e. have aarch64_vcpu_setup() set the register to vcpuid and
> > guest_get_vcpuid() simply return a value of the register.
> > This would be a simpler solution to implement.
>
> That is a great suggestion. It's arch-specific, but maybe the
> other architectures can mimic it with their own capabilities.
> And, in the unlikely event a unit test wants that register for
> itself, then it can build its own mpidr-vcpuid map if necessary.
> Ship it :-)
>
Thanks for the suggestion, Reiji. I'll send out a patch soon for this.

Regards,
Raghavendra
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
