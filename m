Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C430AC432BE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 16:33:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D5DE60F43
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 16:33:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3D5DE60F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4A414B0DF;
	Thu, 29 Jul 2021 12:33:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5MhkvFutIuMN; Thu, 29 Jul 2021 12:33:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C1204B0E4;
	Thu, 29 Jul 2021 12:33:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA2C54B0DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 12:33:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A09D1do+XM9C for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 12:33:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7E8A4B0D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 12:33:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1627576429;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=FjcH7sCGB66RKzqPeaDWjgM8tAnh9bdebcMjCL2pj+c=;
 b=AZMgn07nZDnWk6ZmC6UevS+2QDxOnllRT7nBFZ+Vy0zxVauxY0qwb2CoQM+QD/p0kGYU1t
 YYEGPi9+AQT3dvmsMreQmUkKOPv9tmyM4r9F3vI5+GVLvUSb0RWDLp4Z2ftx62SmB96f0r
 gmeAiRZdY5RlLL0PLHg5nkUrjL4cisM=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-GtzZSG1AOr6a71MlM4hlug-1; Thu, 29 Jul 2021 12:33:48 -0400
X-MC-Unique: GtzZSG1AOr6a71MlM4hlug-1
Received: by mail-il1-f197.google.com with SMTP id
 x16-20020a9206100000b02902166568c213so3524152ilg.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:33:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=FjcH7sCGB66RKzqPeaDWjgM8tAnh9bdebcMjCL2pj+c=;
 b=SSt2vZCewyZuptYoUX/MLpZc4DQu9hpS+w7ZCQfadYvJYSrZgP1oQ5yKWPn5DpcHWn
 Sflp2FnIBBAnr5KXfXqoY6kpy1/Wi1ZTUGawqD9hQ8D1c0VX1GoesoMQgx8ow9slZ0mR
 2Nlqy0k0aP1jxy1XhymQVxUzKYWNUsoNZUryee9PpMHEEECYUIvfIUk1cfxfzBMi/9e7
 pg0gvyt0hhR3s7s0h8PuWJEkenMN2rKPW2OOf3m6b372VxPpyoyPAS4qjXrUqV9eblp2
 vb7JH8HhGQ5/66WQ9/TAWnt4ppf/L8NNxiT1L2aOi7ueazj9uB6wVtFWhqS//zQFHDHP
 tJlw==
X-Gm-Message-State: AOAM532qO3sLifVIFrh5JBP7IpHzMbL5iQ7z6SMiraZQy3yQY/mzNagn
 28Ez89d8mvF6tSHnf5LsPUlG+jNqVfXOU6c5Yiq2dBBIPScmkmk4pCm/Xch7lrNIh5YXN9g44NQ
 To/b5podzfhwNf/9NEtqZmKuN
X-Received: by 2002:a02:8241:: with SMTP id q1mr5172583jag.134.1627576427833; 
 Thu, 29 Jul 2021 09:33:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4d115XMfSVHnaViBRH7zqO/+JS3UA9k8rGTp/h+c0mtFXHxXJNO0ZZi3gMSV04nJNqZsx0Q==
X-Received: by 2002:a02:8241:: with SMTP id q1mr5172569jag.134.1627576427690; 
 Thu, 29 Jul 2021 09:33:47 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id f16sm2147192ilc.53.2021.07.29.09.33.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Jul 2021 09:33:47 -0700 (PDT)
Date: Thu, 29 Jul 2021 18:33:44 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v4 11/13] KVM: arm64: Provide userspace access to the
 physical counter offset
Message-ID: <20210729163344.bojsdqw4z6pjdg3g@gator>
References: <20210729001012.70394-1-oupton@google.com>
 <20210729001012.70394-12-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210729001012.70394-12-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Thu, Jul 29, 2021 at 12:10:10AM +0000, Oliver Upton wrote:
> Presently, KVM provides no facilities for correctly migrating a guest
> that depends on the physical counter-timer. While most guests (barring
> NV, of course) should not depend on the physical counter-timer, an
> operator may still wish to provide a consistent view of the physical
> counter-timer across migrations.
> 
> Provide userspace with a new vCPU attribute to modify the guest physical
> counter-timer offset. Since the base architecture doesn't provide a
> physical counter-timer offset register, emulate the correct behavior by
> trapping accesses to the physical counter-timer whenever the offset
> value is non-zero.
> 
> Uphold the same behavior as CNTVOFF_EL2 and broadcast the physical
> offset to all vCPUs whenever written. This guarantees that the
> counter-timer we provide the guest remains architectural, wherein all
> views of the counter-timer are consistent across vCPUs. Reconfigure
> timer traps for VHE on every guest entry, as different VMs will now have
> different traps enabled. Enable physical counter traps for nVHE whenever
> the offset is nonzero (we already trap physical timer registers in
> nVHE).
> 
> FEAT_ECV provides a guest physical counter-timer offset register
> (CNTPOFF_EL2), but ECV-enabled hardware is nonexistent at the time of
> writing so support for it was elided for the sake of the author :)
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst   | 22 +++++++
>  arch/arm64/include/asm/kvm_host.h         |  1 +
>  arch/arm64/include/asm/kvm_hyp.h          |  2 -
>  arch/arm64/include/asm/sysreg.h           |  1 +
>  arch/arm64/include/uapi/asm/kvm.h         |  1 +
>  arch/arm64/kvm/arch_timer.c               | 72 ++++++++++++++---------
>  arch/arm64/kvm/arm.c                      |  4 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h   | 23 ++++++++
>  arch/arm64/kvm/hyp/include/hyp/timer-sr.h | 26 ++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c          |  2 -
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c        | 21 +++----
>  arch/arm64/kvm/hyp/vhe/timer-sr.c         | 27 +++++++++
>  include/kvm/arm_arch_timer.h              |  2 -
>  13 files changed, 158 insertions(+), 46 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/hyp/timer-sr.h
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
