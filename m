Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF66C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 22:08:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3F8B4B203;
	Thu, 24 Feb 2022 17:08:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eL2R+renqhg4; Thu, 24 Feb 2022 17:08:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 056094BB70;
	Thu, 24 Feb 2022 17:08:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4962F4BB6C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 17:08:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bn01tCDL1sRo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 17:08:20 -0500 (EST)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
 [209.85.166.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E86CF4B203
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 17:08:19 -0500 (EST)
Received: by mail-io1-f48.google.com with SMTP id c23so4481580ioi.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 14:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=q6lHX0lCrP+S4449NnzhhP32cPDoqkypHl+1JWHx810=;
 b=Oyx27mKGM0cLDdS6uKQeF76YYj23pbjWxjtjOaICcu2Lj2OhJbxIOs/0I9OzyZJV0W
 t1RLB02NRfU3tPCwCBFVXfw+vkQ/qY/ggCyFpmi7HFJG1EBhgk7qyyw3AGhedTghgREd
 zeIcS1TplAPupP8LeVvdUi3QyaTqyCffpOy9/45C4u3DzHjNlex4beQxwnSuHViqnemg
 2k8tA5CQT8XrGXstm+4g46lZbz65kxZCwCaHEPP3n6aRG1B4YJTs4D4ZE5y2Bvd82yOT
 WKPp18D9wFYpZfHyjr7gCbNbpZhVBcnz8lT9cyAOOLstTeeBJ0S/8tT0q0++vehjVS/n
 0/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=q6lHX0lCrP+S4449NnzhhP32cPDoqkypHl+1JWHx810=;
 b=d99dL0tOWyV/nt9nC+gO0WRVR8MSPNkCERsYEMIAjLc/oYl7Wq9PFWItNKy6J3Mopt
 R7XA0wbwgxCsaJu1d350N1YlLp9h28ATkj8HC0U1faNPgvACOqjeCHgNR3JZ/lg1HlKA
 GPqa7v3F5ENO/8CN58BK8XUnC4QDrEKr6qVA5Ebtf33k0zDp7shurPZ2IzExD+/ogQ0z
 IBwsIRbqCuYqAOb7ZcNEXowV9E/sgTDQS8TMO6ANjviZwCqb1up0EU5BHYhnu/FcJaUL
 oJ/rW3DEhMEfW56WM19TZUM1zVaDm8kT4avsf0Dn0II8GXRWf130OhmSDG/qNQoLR79V
 g3JA==
X-Gm-Message-State: AOAM531V72Z9Lvdcui8VvvdXDQfZuqgg0nW0+/qxECWn9+zDuibgeeF1
 HJU/PmRks4C5rkY3UfUbj475cw==
X-Google-Smtp-Source: ABdhPJwu5tYazKcXYm4627JinNrrsf79YktfSdYDIKLZNIrO/xikidBHRgbS8ggDs+TColwm0EsOnQ==
X-Received: by 2002:a05:6638:22c3:b0:30f:88b:e546 with SMTP id
 j3-20020a05663822c300b0030f088be546mr3649914jat.247.1645740498998; 
 Thu, 24 Feb 2022 14:08:18 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 c8-20020a056e020cc800b002bf717f64e3sm533782ilj.28.2022.02.24.14.08.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Feb 2022 14:08:18 -0800 (PST)
Date: Thu, 24 Feb 2022 22:08:15 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 06/19] KVM: arm64: Track vCPU power state using MP
 state values
Message-ID: <YhgBz1/cgpoS3HuD@google.com>
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-7-oupton@google.com>
 <87y2202y8f.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87y2202y8f.wl-maz@kernel.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Peter Shier <pshier@google.com>,
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Hi Marc,

On Thu, Feb 24, 2022 at 01:25:04PM +0000, Marc Zyngier wrote:

[...]

> > @@ -190,7 +190,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
> >  	 * re-initialized.
> >  	 */
> >  	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> > -		tmp->arch.power_off = true;
> > +		tmp->arch.mp_state = KVM_MP_STATE_STOPPED;
> >  	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> >  
> >  	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> 
> You also may want to initialise the mp_state to RUNNABLE by default in
> kvm_arch_vcpu_create(). We are currently relying on power_off to be
> false thanks to the vcpu struct being zeroed, but we may as well make
> it clearer (RUNNABLE is also 0, so there is no actual bug here).

We unconditionally initialize power_off in
kvm_arch_vcpu_ioctl_vcpu_init(), and do the same in this patch for mp_state,
depending on if KVM_ARM_VCPU_POWER_OFF is set.

Any objections to leaving that as-is? I can move the RUNNABLE case into
kvm_arch_vcpu_create() as you've suggested, too.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
