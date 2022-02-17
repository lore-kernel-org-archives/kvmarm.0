Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6203C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 04:59:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 405A3410AD;
	Wed, 16 Feb 2022 23:59:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cx-kZL5Hl9J4; Wed, 16 Feb 2022 23:59:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 043C4411D2;
	Wed, 16 Feb 2022 23:59:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B586C410AD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 23:59:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1y6knjFNyaul for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Feb 2022 23:59:48 -0500 (EST)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com
 [209.85.166.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A78F0407EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 23:59:48 -0500 (EST)
Received: by mail-io1-f53.google.com with SMTP id h16so2306707iol.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Feb 2022 20:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=F7h05wJLlkd5cKPCrzT5cmv+Gs51c7pMwjtMHfEasy8=;
 b=JeRwhXto1AsObhVRUTqwhjiMHOtxzAZCvjPiDir8xsxC01QcimY1dXl70Z5Wao8BVy
 NIaFrKXr6LoAR8WwPkaseSWuc0MTYkFRvLt6jqD7jLAG5wjWFKHaHJZvSqYEXXX4TN/X
 wLstHHhAZIb41vrH4vf4MioIctOJQvHjp8JkOvT6UhVEVUhoTcBhskhQsCmR1gpEXkP6
 JGFDDh115Bov9D32ORFPDVhqfVJdbcaF5U8ptNt2RneMpFE7y4a5egZfR/eepqECcGTK
 tYjMcmuaTg0TkM3iqvWtY6+j9AK3TTbtYnh4EuyLjRt8RcRxXTgBBYW0U168NMCbM0eu
 1ktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=F7h05wJLlkd5cKPCrzT5cmv+Gs51c7pMwjtMHfEasy8=;
 b=dS/FlLXJ9DaQB4M8qZ3h+ATXTOpQIeDQhvlfyW+6FJZ8TroivJYYHR5DRtCmfunF/l
 sF8FtJnHZe7+29n8sEIc5W/lg9FatjHoXx2PJDhjAnnhGpEGRFfvgBUQoS6a0Ig23KnP
 g5ZuGl25AW7nuldHHdXiigesj4FKQP94SkO+vh4OrMmIKoyriyDUFH4vgaT4Dofdfe58
 LkymoDDslUr3cntIJbcO/VAiDWzDfgUeJfz3iSCNH0cXI7N8ZjN+kv8el2fhH8UUp5kl
 OecKL1Atj3l0pOBR0+IsKHtSrVDV43hjAD5WbQxlr+XAl31LWmbnLx0Rr88QZmLJydrd
 u4jw==
X-Gm-Message-State: AOAM532D8Swb77rsN2Fl+vB20YjJEm1ZwJPVxU4dj2LMFSCqLvyKhLFx
 e0U4QK0kSjsjPc4BtZ0gn51e7w==
X-Google-Smtp-Source: ABdhPJx2e0ngpL2dFp+kkfoL+F8ZeH+ZJbcUKIqGmyMNbZeBoGfK83hrgWHAGj8Qc1/3NWtu4Ct5Wg==
X-Received: by 2002:a05:6638:1315:b0:314:85c1:f99b with SMTP id
 r21-20020a056638131500b0031485c1f99bmr760926jad.269.1645073987780; 
 Wed, 16 Feb 2022 20:59:47 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id k2sm1418207iow.7.2022.02.16.20.59.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Feb 2022 20:59:47 -0800 (PST)
Date: Thu, 17 Feb 2022 04:59:43 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v5 10/27] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
Message-ID: <Yg3WP5HR9OJJMLj7@google.com>
References: <20220214065746.1230608-1-reijiw@google.com>
 <20220214065746.1230608-11-reijiw@google.com>
 <Ygv3q/+arejIWnzs@google.com>
 <CAAeT=Fxvsniq4NW92LESqJ1ie6e+N1J793JrX0UBf2mq9B35dg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=Fxvsniq4NW92LESqJ1ie6e+N1J793JrX0UBf2mq9B35dg@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Tue, Feb 15, 2022 at 06:52:27PM -0800, Reiji Watanabe wrote:
> Hi Oliver,
> 
> Thank you for the review!
> 
> On Tue, Feb 15, 2022 at 10:57 AM Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Sun, Feb 13, 2022 at 10:57:29PM -0800, Reiji Watanabe wrote:
> > > When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> > > means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> > > expose the value for the guest as it is.  Since KVM doesn't support
> > > IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> > > expose 0x0 (PMU is not implemented) instead.
> > >
> > > Change cpuid_feature_cap_perfmon_field() to update the field value
> > > to 0x0 when it is 0xf.
> >
> > Definitely agree with the change in this patch. Do we need to tolerate
> > writes of 0xf for ABI compatibility (even if it is nonsensical)?
> > Otherwise a guest with IMP_DEF PMU cannot be migrated to a newer kernel.
> 
> Hmm, yes, I think KVM should tolerate writes of 0xf so that we can
> avoid the migration failure.  I will make this change in v6.
> 
> Since ID registers are immutable with the current KVM, I think a live
> migration failure to a newer kernel happens when the newer kernel/KVM
> supports more CPU features (or when an ID register field is newly
> masked or capped by KVM, etc).  So, I would assume such migration
> breakage on KVM/ARM has been introduced from time to time though.
>

Indeed it has, but IMO migration breakage should really be avoided at
all costs. End of the day, its ABI breakage.

Unless folks feel otherwise, I would be in favor of just ignoring the
IMP_DEF write and setting the field value to NI instead. Allows VMs to
migrate onto newer kernels and fixes the KVM bug at the same time.

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
