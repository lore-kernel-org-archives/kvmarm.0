Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A6AC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  8 Jan 2022 05:40:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18D934B2E4;
	Sat,  8 Jan 2022 00:40:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H2WoHDTvtzQ1; Sat,  8 Jan 2022 00:40:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F06264B165;
	Sat,  8 Jan 2022 00:40:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CA444B165
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Jan 2022 00:40:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UTI66xCtZtFG for <kvmarm@lists.cs.columbia.edu>;
 Sat,  8 Jan 2022 00:40:31 -0500 (EST)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BFB24B164
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Jan 2022 00:40:31 -0500 (EST)
Received: by mail-pj1-f52.google.com with SMTP id
 rj2-20020a17090b3e8200b001b1944bad25so8826358pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Jan 2022 21:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=vJGRReZsely/8omZ1Cspk9Kwrszz0O8ZKezfcROunTY=;
 b=jfIypL6kon4NpoXquOIEiUAQ5GvGVBebhTdvi+HtoQMlxRX/HgIUTklFUprfOVJ8rl
 fTn4KAxnr7iy56uqs6vMefiorygA2Af6KvzanccF++ZbClvc8c/iREpj5bzoU8pibKgY
 EWVPV3bVQGsyHkRfYoQlUOwHM37IQySaWCnDuMNZtgymuGpIL8M15d4MWEt4ziP8uKhv
 J4Ee06355x701dKcP/jb7BwEI+qn1aQZFmRvZQXHGE1E7Czkt5h7YZzuuFUb0m4VSi7p
 sSmInW+KEZ1baHhP5HNXPZ1Ucn7F5YPQy0S3bk1sNqlYNasvm2+6a/8lm/nImHkOM0MY
 5buQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=vJGRReZsely/8omZ1Cspk9Kwrszz0O8ZKezfcROunTY=;
 b=5GfiXy4W04hmmOplbESGC/ISP1KQnWHs3o0Hj02Oz60O+EJTk5fbd8352CU8skKSd4
 oD7yOb/uyVUs6jJvVCOlbEt5IBehja741tun3t1kFwNDvlCXgX7PudA/6lDiIXJrTb8z
 E5jIvrgIlCLuxhDj2t+aKYrKVA0/PqYJEdtRkYZr4Qf8TsmlqBa8Dh+DV2raJH9xeQL2
 X3IRacpmsJ4Yh955hzzlWUUy7OpGNUxEicLubtzHZEynD48BFxelMWO3+znRqEb3ZRTd
 Ni1whsF7qh4dsjV7HSopzW9wRFJsdf1jvAmnVD53QkAtkL/KiooHxCwAiF4xuxayuY6B
 U6Rg==
X-Gm-Message-State: AOAM530m9ARjHKrlCK8RT/iVxnjKUu9joq//cRqTL9yAUCw7rHNsWZkD
 vnMHzfNnuvESh5sb+36bX90l5+qZ5nDnEZRIq1JXCA==
X-Google-Smtp-Source: ABdhPJwsnQF5jMBswjsnV13um4yHGQ74rkeXISFQukMgOjL9wb1avu8wU0g8cenUjnhbK6t0WyOy6jf3BIBex/1xpyk=
X-Received: by 2002:a17:90b:3b49:: with SMTP id
 ot9mr19372117pjb.110.1641620430125; 
 Fri, 07 Jan 2022 21:40:30 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-4-rananta@google.com>
In-Reply-To: <20220104194918.373612-4-rananta@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 7 Jan 2022 21:40:14 -0800
Message-ID: <CAAeT=FxCCD+H1z8+gfyBZNeibfAUqUenZZe56Vj_3fCghJjy=Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/11] KVM: Introduce KVM_CAP_ARM_HVC_FW_REG_BMAP
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

Hi Raghu,

On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Introduce the KVM ARM64 capability, KVM_CAP_ARM_HVC_FW_REG_BMAP,
> to indicate the support for psuedo-firmware bitmap extension.
> Each of these registers holds a feature-set exposed to the guest
> in the form of a bitmap. If supported, a simple 'read' of the
> capability should return the number of psuedo-firmware registers
> supported. User-space can utilize this to discover the registers.
> It can further explore or modify the features using the classical
> GET/SET_ONE_REG interface.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 21 +++++++++++++++++++++
>  include/uapi/linux/kvm.h       |  1 +
>  2 files changed, 22 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index aeeb071c7688..646176537f2c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6925,6 +6925,27 @@ indicated by the fd to the VM this is called on.
>  This is intended to support intra-host migration of VMs between userspace VMMs,
>  upgrading the VMM process without interrupting the guest.
>
> +7.30 KVM_CAP_ARM_HVC_FW_REG_BMAP

IMHO, instead of including its format of the register in the name,
including its purpose/function in the name might be better.
e.g. KVM_CAP_ARM_HVC_FEATURE_REG ?
(Feature fields don't necessarily have to be in a bitmap format
 if they don't fit well although I'm not sure if we have such fields.)

> +--------------------------------
> +
> +:Architectures: arm64
> +:Parameters: None
> +:Returns: Number of psuedo-firmware registers supported

Looking at patch-4, the return value of this would be the number of
pseudo-firmware *bitmap* registers supported.
BTW, "4.68 KVM_SET_ONE_REG" in the doc uses the word "arm64 firmware
pseudo-registers".  It would be nicer to use the same term.

> +
> +This capability indicates that KVM for arm64 supports the psuedo-firmware
> +register bitmap extension. Each of these registers represent the features
> +supported by a particular type in the form of a bitmap. By default, these
> +registers are set with the upper limit of the features that are supported.
> +
> +The registers can be accessed via the standard SET_ONE_REG and KVM_GET_ONE_REG
> +interfaces. The user-space is expected to read the number of these registers
> +available by reading KVM_CAP_ARM_HVC_FW_REG_BMAP, read the current bitmap
> +configuration via GET_ONE_REG for each register, and then write back the
> +desired bitmap of features that it wishes the guest to see via SET_ONE_REG.
> +
> +Note that KVM doesn't allow the user-space to modify these registers after
> +the VM (any of the vCPUs) has started running.

Since even if KVM_RUN fails, and the VM hasn't started yet,
it will get immutable. So, "after any of the vCPUs run KVM_RUN."
might be more clear ?

Thanks,
Reiji



> +
>  8. Other capabilities.
>  ======================
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 1daa45268de2..209b43dbbc3c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>  #define KVM_CAP_ARM_MTE 205
>  #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
> +#define KVM_CAP_ARM_HVC_FW_REG_BMAP 207
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> --
> 2.34.1.448.ga2b2bfdf31-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
