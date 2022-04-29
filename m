Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29727C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 29 Apr 2022 03:42:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 927724B190;
	Thu, 28 Apr 2022 23:42:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2QFmJjpmd1OD; Thu, 28 Apr 2022 23:42:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58E334B1C3;
	Thu, 28 Apr 2022 23:42:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 049834B190
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 23:42:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eRmrchYgqfJY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 23:42:34 -0400 (EDT)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com
 [209.85.166.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E18764B08A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 23:42:33 -0400 (EDT)
Received: by mail-io1-f53.google.com with SMTP id z18so8162295iob.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 20:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=R4JPQup2EYs9JDGRJV40gMfrDAg1pajknYA/JOwy6a0=;
 b=o2ny9/GcrvLgIXJIbeNdVaugvjxib9crpwPekIyQlVLwX9Tj4yU9mA+rmY2QrBjeMy
 iGK4ZD6N+xuLUM12CGNXKgpe17s0aptFQIiGz+be7VN+mJ8kIsC156v/J25IgKhwAcYs
 snWl1PZNGUvJqCbCDCdHARKwVI/fwxRMLo46DpcNVjs5L9aP9NlsYl+K5VCJNIJb7a41
 STDcKB75F9xo6mbz3JeeljcMQAuTJocuLOuofTJxXel8Kg5vNV09RUBLE7IADdXm/gvx
 1l2F7hGGzEhePeZxS83ovSdzYZ6hPg9HLeQFU71ekcj3kCXJVBHuKm0PavfmO0GQdxo2
 IXrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=R4JPQup2EYs9JDGRJV40gMfrDAg1pajknYA/JOwy6a0=;
 b=gB8+VjRyoMD1wmRPbseypgOTYGUiijA3iqEy8slF1tiM37pnw33fhfDlDPJtTCb6jV
 qXKLgHVsxvjqkAftzRlYfukgh7ZOrEzHyphh43Hvrt4zBExAW/2MBihGOk8EXqNLKGoI
 yaorlT/dNr7+Vducfp44mm+Of6S33U0J2KJzovQ2PoeukSo9P9BqbQzzUz1+nl0LiIfO
 EBITPPkVAv3DO5QrPQadLWJajQjaB5EQ5KLclIObXfx0MovDoEc6is0ft1jDrg857bjr
 43tNBJ9/Vt1Xudcya41J/EUXIDo7DIRHjHCvKd4DTzXJ8whSs89yuSpqtPAeEgHOx9U3
 TyaA==
X-Gm-Message-State: AOAM532469FbJBKesI+SN1+DsO+DkVw2HwKJtkvOeeHpW0Tp0Bd+iHUR
 CRDPTtaeobnB7F6AgXLi7x+B/w==
X-Google-Smtp-Source: ABdhPJwWnQdNl48oTXoNwQUBwq9CjglUWwury57PWB4FK6563eKFNWxVLyVdM+5Op/zhn5KEiAyWZA==
X-Received: by 2002:a05:6602:2a42:b0:652:8e2d:e4b7 with SMTP id
 k2-20020a0566022a4200b006528e2de4b7mr14588853iov.142.1651203752971; 
 Thu, 28 Apr 2022 20:42:32 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 h37-20020a022b25000000b0032b3a78178asm249050jaa.78.2022.04.28.20.42.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 28 Apr 2022 20:42:31 -0700 (PDT)
Date: Fri, 29 Apr 2022 03:42:28 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v5 07/13] KVM: arm64: Add support for userspace to
 suspend a vCPU
Message-ID: <YmtepGWYckmUKln+@google.com>
References: <20220409184549.1681189-1-oupton@google.com>
 <20220409184549.1681189-8-oupton@google.com>
 <CAAeT=FzURZmYfsLJnWMXufBiaZ6Wypan+xK4WxOSM=p=kEnYxA@mail.gmail.com>
 <CAOQ_Qsg2oNx8Ke7wGy1sU-5Ruq8uCWMKU5VkvTn=co6oRhhXww@mail.gmail.com>
 <CAAeT=Fx5Nb0EJ+6825fYxAxF9bK5DHOXNmJiSVGP=JVSbWuCrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=Fx5Nb0EJ+6825fYxAxF9bK5DHOXNmJiSVGP=JVSbWuCrQ@mail.gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Thu, Apr 21, 2022 at 11:28:42PM -0700, Reiji Watanabe wrote:

[...]

> > > > +static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
> > > > +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > > > +       kvm_vcpu_kick(vcpu);
> > >
> > > Considering the patch 8 will remove the call to kvm_vcpu_kick()
> > > (BTW, I wonder why you wanted to make that change in the patch-8
> > > instead of the patch-7),
> >
> > Squashed the diff into the wrong patch! Marc pointed out this is of
> > course cargo-culted as I was following the pattern laid down by
> > KVM_REQ_SLEEP :)
> 
> I see. Thanks for the clarification !
> 
> > > it looks like we could use the mp_state
> > > KVM_MP_STATE_SUSPENDED instead of using KVM_REQ_SUSPEND.
> > > What is the reason why you prefer to introduce KVM_REQ_SUSPEND
> > > rather than simply using KVM_MP_STATE_SUSPENDED ?
> >
> > I was trying to avoid any heavy refactoring in adding new
> > functionality here, as we handle KVM_MP_STATE_STOPPED similarly (make
> > a request). ARM is definitely a bit different than x86 in the way that
> > we handle the MP states, as x86 doesn't bounce through vCPU requests
> > to do it and instead directly checks the mp_state value.
> 
> The difference from KVM_MP_STATE_STOPPED is that kvm_arm_vcpu_power_off()
> calls kvm_vcpu_kick(), which made me think having KVM_REQ_SLEEP was
> reasonable (it appears kvm_vcpu_kick() won't be needed there due to
> the same reason as kvm_arm_vcpu_suspend).

Just to finish the thought on this before mailing out what I hope is the
last take on all of this. I'm going to leave the pointless call to
kvm_vcpu_kick() in place, if only to follow the pattern of other MP
states.

That will all get cleaned up later on, as discussed :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
