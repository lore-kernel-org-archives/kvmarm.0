Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6AA43B6D0
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 10:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784110411; cv=none; b=bwM7zYLBlt+g2vTNrQspKqYDfbaB1JmCbhppMsNewhn3/l3hUm0Fiofv7ADQC+F371zuTEeNvJWsqcAn3jfwDp9LRnDZr07Ou5obRQcw+E2C0xjZEFOg1I+2D1/Bf2GYU4Vm8MHvP8VDhlydv9wNB+RU9vSMlFVE30pqDsSAbmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784110411; c=relaxed/simple;
	bh=X9RYK8R01XKRF0/cCXIAYcZZgAv5Pzqa1jQEbwt5vfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j97dGTs7CvV9Ffo2TNwdPnZZVYmsLn0pYebC+H50f++0VomO79GGS1AUfFLOZ0eFi+R43FvksyIE1SI5ioVuY37H8VeHSGIlo3zuaXvz3+A+Gt9pKG+Pq8Mt5S/0WGuP/78N79TmIR6i8f9sh6aa1lRfeLBI2P5AkwznfIDfZAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hj7dkjlv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hj7dkjlv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784110408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1jZxb/DyGzc2Aox27RZLCNs8CB48ahE7uYx1FJS8/x4=;
	b=hj7dkjlv5bdNkWdyRsV65x4lVyx0NjIrINp9FtjW0CV3XlTiHtcCP//b0DF7wlm5mbAOx5
	ScefjWiJGtLA/g9YCP+TS4b56OoArN1FJCopoaAURGz5CI2+40+kfJgOkCi84fZ3VXWd0p
	NkGFbV+oC1H/F8dVmfOGWrXnp48OzYA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-rSZRYvZOOB6GkLoGfge5xw-1; Wed, 15 Jul 2026 06:13:27 -0400
X-MC-Unique: rSZRYvZOOB6GkLoGfge5xw-1
X-Mimecast-MFC-AGG-ID: rSZRYvZOOB6GkLoGfge5xw_1784110406
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-493c20d0468so21903315e9.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 03:13:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784110406; x=1784715206;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1jZxb/DyGzc2Aox27RZLCNs8CB48ahE7uYx1FJS8/x4=;
        b=E1VTMV4O7fLELz1WI0TCXyjdZ5wWtNOEOgqRMEwSC1GbpRq9XxGFNRJeXyAcBFLzUk
         mL03iuJ8PiCSzJOl69WIyrPaD7J6XYCrPDtsuf0nxDoX+UW31gPIzizqfoW5uVG2KFtH
         qa2muU2rQvEHcWkvqX5GIDublJ1pxRsRcrnw0HkbxZ34vEj4o2TnnTP3/RNLuMG6liB0
         4zdaxLq7YF8DZ86Ud4Fk2ks9DD7+0UYlzdfdTKOk/axKkyHY/i3g8N7UpA6knkZJED2f
         7Qf6FxKjcnPeNJ9ssgYeHKetUwDz44buNof4I4bRGamlQr0KFjU4wPo9g4VHUPw3SmS1
         K9vA==
X-Forwarded-Encrypted: i=1; AHgh+Rqc8C6lDUcAveOT5hLC02Ox15grMJKWYK0rwWeymTU+ErSE3mvM19W2fOQiCG8x7/NIfs7YkxE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyeC58VSu3Q5ux2x0nL5pLCcaOL/FEvN/n8Tr9POPPln+sFaZS9
	M7TnTqGhib/JWhSR5IFu/oHwguL0Xz2DDWZvkNkxurzobR+pCaWz0wNA/2C3ESdY2Iw04rkQYnd
	rRGVM4aY8s1rWHXXu0s1ZSbD7fPZ2DDgEu+VRxm5k1/5YU7pBPiqCIM0/7iNs6U4XVn+Bx6finq
	kyVFD0oHa/JrKLC+tsu7xtDuAWf/fffbT+
X-Gm-Gg: AfdE7clKusw1doyF7nateJ8s3cCCb9dqK48D2EzE472/gOvBkXG7AF8FayaUUq4h3JX
	qaY63Jw+vygy3Fm8OkjvWdZoxqDSVKyndjRZWADXL390IxRshH0F7tQcjP5lW7t8Dlum2asKWNG
	1OZzBItRwmZ6G5SmWAbTIZbLuB0lp2hzwFJY00WYiuGmOiFAwYOVzV+sh2+I7EiIvWhhO8bjML1
	ng0Kuxu+WIhynrDVc/IFnqVLeoszF2Hk8lqcfzy3oGbuO5B7RmJZogHITo60pY0mIuN3Q==
X-Received: by 2002:a05:600c:4e50:b0:495:3f48:5df2 with SMTP id 5b1f17b1804b1-4953f48693emr7640345e9.29.1784110406263;
        Wed, 15 Jul 2026 03:13:26 -0700 (PDT)
X-Received: by 2002:a05:600c:4e50:b0:495:3f48:5df2 with SMTP id
 5b1f17b1804b1-4953f48693emr7639785e9.29.1784110405766; Wed, 15 Jul 2026
 03:13:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260626133526.817232-1-maz@kernel.org>
In-Reply-To: <20260626133526.817232-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 15 Jul 2026 12:13:10 +0200
X-Gm-Features: AUfX_mxVOlhzpUoKqPqzo5NYFwSGnaFmiBzLMOnOOVrVLohEJlEsW4snDDbir2w
Message-ID: <CABgObfY=eyZ6=hLsJ2mH8=ojthafiOzo5OCrae6W48JD4SxSjQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.2, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Bradley Morgan <include@grrlz.net>, Fuad Tabba <tabba@google.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	Oliver Upton <oupton@kernel.org>, Weiming Shi <bestswngs@gmail.com>, Will Deacon <will@kernel.org>, 
	Xuanqing Shi <shixuanqing.11@bytedance.com>, Zhong Wang <wangzhong.c0ss4ck@bytedance.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0QEFxTIRaxnnWGQzase9Kva928VvLbjTFEzCuPjKjdU_1784110406
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26, 2026 at 3:35=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> As predicted, here's another largeish set of fixes for KVM/arm64. A
> bunch of them are fairly benign (the PSTATE.IL stuff), but some are
> pretty annoying (vgic, MOPS) and are stable material.
>
> On the bright side, Fuad has volunteered to be an official reviewer.
> We really need people to engage with the reviewing process instead of
> simply dumping patches on us, as me and Oliver really can't be
> stretched much further. So many thanks Fuad for offering to help.

Indeed, thanks very much!

> I expect to be back next week with a similar delivery, as my Inbox
> keeps filling with this stuff...

Pulled, thanks. Sorry for the delay (though it was known in advance).

Paolo

> Please pull,
>
>         M.
>
> The following changes since commit 1ee27dacbe5dc4def481794d899d67b0d45700=
94:
>
>   Merge branch kvm-arm64/nv-mmu-7.2 into kvmarm-master/next (2026-06-12 0=
9:29:34 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.2-1
>
> for you to fetch changes up to d098bb75d14fde2f12155f1a95ec0168160867ce:
>
>   KVM: arm64: account pKVM reclaim against the VM mm (2026-06-22 10:48:08=
 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.2, take #1
>
> - Fix an accounting buglet when reclaiming pages from a protected
>   guest
>
> - Fix a bunch of architectural compliance issues when injecting a
>   synthesised exception, most of which were missing the PSTATE.IL bit
>   indicating a 32bit-wide instruction
>
> - Another set of fixes addressing issues with translation of VNCR_EL2,
>   including corner cases where the guest point that register at a RO
>   page...
>
> - Don't warn when trapping accesses to ZCR_EL2 from an L2 guest, as
>   that's not unexpected at all
>
> - Address a bunch of races with LPI migration vs LPIs being disabled
>
> - Fix a total howler of a bug combining FEAT_MOPS and NV, resulting in
>   exception returning in the wrong place...
>
> - Coerce Fuad Tabba into a reviewer role, and may his Inbox catch
>   fire!
>
> ----------------------------------------------------------------
> Bradley Morgan (1):
>       KVM: arm64: account pKVM reclaim against the VM mm
>
> Fuad Tabba (11):
>       KVM: arm64: nv: Write ESR_EL2 for injected nested SError exceptions
>       KVM: arm64: Sync SPSR_EL1 when injecting an exception into a pVM
>       KVM: arm64: nv: Fix PSTATE construction on illegal exception return
>       KVM: arm64: Add Fuad Tabba as a reviewer
>       KVM: arm64: Set ESR_ELx.IL for injected undefined exceptions at EL2
>       KVM: arm64: Unconditionally set IL for injected undefined exception=
s
>       KVM: arm64: Unconditionally set IL for injected abort exceptions
>       KVM: arm64: Set IL for injected FPAC exceptions during ERET emulati=
on
>       KVM: arm64: Set IL for emulated SError injection
>       KVM: arm64: Set IL for nested SError injection
>       KVM: arm64: Set IL in fake ESR for pKVM memory sharing exit
>
> Hyunwoo Kim (1):
>       KVM: arm64: vgic: Check the interrupt is still ours before migratin=
g it
>
> Marc Zyngier (1):
>       KVM: arm64: vgic: Handle race between interrupt affinity change and=
 LPI disabling
>
> Oliver Upton (6):
>       KVM: arm64: nv: Drop bogus WARN for write to ZCR_EL2
>       KVM: arm64: nv: Respect read-only PFN when mapping L1 VNCR
>       KVM: arm64: nv: Inject SEA if kvm_translate_vncr() can't resolve PF=
N
>       KVM: arm64: nv: Re-translate VNCR before injecting abort
>       KVM: arm64: nv: Inject SEA if guest VNCR isn't normal memory
>       KVM: arm64: nv: Mark VM as bugged for unexpected VNCR abort
>
> Weiming Shi (1):
>       KVM: arm64: nv: Fix SPSR_EL2 restore in kvm_hyp_handle_mops()
>
>  MAINTAINERS                             |   1 +
>  arch/arm64/include/asm/kvm_nested.h     |   8 ++
>  arch/arm64/kvm/at.c                     |   8 --
>  arch/arm64/kvm/emulate-nested.c         |  37 +++++--
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  11 ++-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c          |   3 +-
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c      |   3 +-
>  arch/arm64/kvm/inject_fault.c           |  18 +---
>  arch/arm64/kvm/nested.c                 | 164 ++++++++++++++++----------=
------
>  arch/arm64/kvm/pkvm.c                   |   2 +-
>  arch/arm64/kvm/vgic/vgic.c              |  20 ++--
>  11 files changed, 149 insertions(+), 126 deletions(-)
>

