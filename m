Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504E5C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 10:05:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B81E160F56
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 10:05:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B81E160F56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 302944B178;
	Fri, 15 Oct 2021 06:05:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lzwRV3LQDIS3; Fri, 15 Oct 2021 06:05:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B9AF4B17B;
	Fri, 15 Oct 2021 06:05:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5C554B172
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 06:05:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZPeLVLsZBBWV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 06:05:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D26DF4B161
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 06:05:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634292353;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=b0uHWXZnqeTxhuKyqKx8y/HRcY8yBSsrr8AiAitLaHk=;
 b=UD/PEFeyM/xCZx3njuGiQNg2mHfVPV1syzCnDVybQVjnPg2sz5dqOIHxCPNheMcmDrft0x
 m1Y2MDHoWxQxPSd3FJ6rwc8uNOd1gCJ6r4TcQ+v397PkVVr95pKwTlix4rPMLqxCK2bcxp
 c31HrJCfr+jwVyARG5IZBcscsVgP1iY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-p_cUjvwsOImVz3f2Fp3IFw-1; Fri, 15 Oct 2021 06:05:52 -0400
X-MC-Unique: p_cUjvwsOImVz3f2Fp3IFw-1
Received: by mail-wm1-f71.google.com with SMTP id
 s22-20020a1ca916000000b0030dcdcd37c5so687926wme.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 03:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=b0uHWXZnqeTxhuKyqKx8y/HRcY8yBSsrr8AiAitLaHk=;
 b=2ZvoNhsXtCli1pVOR/lLzDVRLA2Jhls1YnhFLLKiyQ8gbAazTzmd3yg7K3BtLpMxx6
 5a76Ld64dofnBYPRGJajL9yRfcfu6PVnNXfEaVP+IaqEK2nJwu7C97TS8ooYwbslGcxb
 lLlRX3XKxGJYFiH7RCO+9HcEPbER4wZDQk7vDuPWrdMfn21JxwfU85XAf2xpX8MSgfWs
 v6mt1nPIN8N52QwgCDploiUX+2N6uUPfL/KNMtJT9eCfxqnGac+aKInTGQHtt198CGCc
 c3aeej5q19DMQKj2QHuluQ1y6lm3/GR6tHVFf2VFf4Oo9M/8NUTuL0vTwhNSeB9aAmCj
 ZThg==
X-Gm-Message-State: AOAM533ohNIHGoe+he9llnDZhG/3dH4IvmWgtgmvX2+c++D7wF0xO1Fc
 DVwQMBGW9dbltBjILj0rxf74McNa5E1kgFOIVAatTVBGXaKEc9rrTPSUVMY0crVfYbD4/5enPTI
 LVx35jWT/XDSh/zVMJrOj3Lnd
X-Received: by 2002:a1c:a791:: with SMTP id
 q139mr11551235wme.102.1634292351348; 
 Fri, 15 Oct 2021 03:05:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfXBNIKizN+SJiZFGqzqQgnO0A5xN/k3JphvbQHlTMEeg7cXSlABUxCwsJlYSRI54rXUqToQ==
X-Received: by 2002:a1c:a791:: with SMTP id
 q139mr11551220wme.102.1634292351151; 
 Fri, 15 Oct 2021 03:05:51 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id a2sm4558837wru.82.2021.10.15.03.05.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Oct 2021 03:05:50 -0700 (PDT)
Date: Fri, 15 Oct 2021 12:05:48 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/5] KVM: arm64: Reorganise vcpu first run
Message-ID: <20211015100548.4yd2ukon5rypexoo@gator>
References: <20211015090822.2994920-1-maz@kernel.org>
 <20211015094900.pl2gyysitpnszojy@gator>
MIME-Version: 1.0
In-Reply-To: <20211015094900.pl2gyysitpnszojy@gator>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Fri, Oct 15, 2021 at 11:49:00AM +0200, Andrew Jones wrote:
> On Fri, Oct 15, 2021 at 10:08:17AM +0100, Marc Zyngier wrote:
> > KVM/arm64 relies heavily on a bunch of things to be done on the first
> > run of the vcpu. We also do a bunch of things on PID change. It turns
> > out that these two things are pretty similar (the first PID change is
> > also the first run).
> > 
> > This small series aims at simplifying all that, and to get rid of the
> > vcpu->arch.has_run_once state.
> > 
> > Marc Zyngier (5):
> >   KVM: arm64: Move SVE state mapping at HYP to finalize-time
> >   KVM: arm64: Move kvm_arch_vcpu_run_pid_change() out of line
> >   KVM: arm64: Merge kvm_arch_vcpu_run_pid_change() and
> >     kvm_vcpu_first_run_init()
> >   KVM: arm64: Restructure the point where has_run_once is advertised
> 
> Maybe do the restructuring before the merging in order to avoid the
> potential for bizarre states?

Also, before we do the merge I think we need to duplicate the

        if (unlikely(!kvm_vcpu_initialized(vcpu)))
                return -ENOEXEC;

that we currently have above the call of kvm_vcpu_first_run_init()
into kvm_arch_vcpu_run_pid_change() because
kvm_arch_vcpu_run_pid_change() is called before kvm_arch_vcpu_ioctl_run()
in KVM_RUN.

Thanks,
drew

> 
> >   KVM: arm64: Drop vcpu->arch.has_run_once for vcpu->pid
> > 
> >  arch/arm64/include/asm/kvm_host.h | 12 +++------
> >  arch/arm64/kvm/arm.c              | 43 ++++++++++++++++++-------------
> >  arch/arm64/kvm/fpsimd.c           | 11 --------
> >  arch/arm64/kvm/reset.c            | 11 +++++++-
> >  arch/arm64/kvm/vgic/vgic-init.c   |  2 +-
> >  5 files changed, 39 insertions(+), 40 deletions(-)
> > 
> > -- 
> > 2.30.2
> > 
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
> 
> For the series
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> Thanks,
> drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
