Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5504EC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:51:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD5354BAEF;
	Thu, 10 Nov 2022 09:51:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8i7EWTKVvMPp; Thu, 10 Nov 2022 09:51:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EEFC4BAD9;
	Thu, 10 Nov 2022 09:51:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 209144B87C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:56:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y9-DRVQQz9YW for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 12:56:51 -0500 (EST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 991B44B868
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:56:51 -0500 (EST)
Received: by mail-wr1-f48.google.com with SMTP id h9so17466717wrt.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 09:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=mime-version:user-agent:message-id:date:references:subject:cc:to
 :from:from:to:cc:subject:date:message-id:reply-to;
 bh=T3PdXGFokMYHAAkilazNlYlaLTfFeBTny4nmc/XZVPA=;
 b=FY+QQ2oVQBn/h5WRmwrQ8ViPJMhpmfdXcqi0vbGJ7WFh3tGoRAQoi/nHcspbWFNR0A
 PKQeyeDw4mXPwCcwGN372L85lrk11rioa5/7ceojMnG1dpg2WETS8oY0bOVEC+QL8Btk
 8XgRFX8mgqa0SZfsdazJwthY1uq1I0IWc0BWZo8HR+ccUnR7VyZTYi2QCM+DCsumhSjT
 vq7Pg3RgICwmwKW1Eb1MQhjC6YrUs/1nJZ5bLbIoh//dnZxm6y9O6YOa7qkseonvz0qg
 vxXBmLH1lXeiLyu0lHLoPf8VGJ3pyoHszBGKLsnqejccRqrdxMV5cVpe6Sxjn91mAW5u
 WvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=mime-version:user-agent:message-id:date:references:subject:cc:to
 :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=T3PdXGFokMYHAAkilazNlYlaLTfFeBTny4nmc/XZVPA=;
 b=ulMrimeQQCpDYlDfRMNUyhNqiKDkz6kgPTELz6BBscPDn0kWvvvUUpqISaRg5ajF+I
 HfNXppHomFw++T7doi+rD+f3SjpRmavLRn2X4hlvWD2JFFcdakp4lbDe8wl1nTlMGR+D
 rs2QB0SV9/8p0FlKNWaJH73yJmqp/97XYizA3LczdQVM8RtN/mStM9tTm2NB4ycvNWVi
 nNpb7OqJ3JKD8vaGBBTzsJopYJJIOGffYpdgH2+dvc4L6C5IBCDTUkVryE/xNIk1W3ie
 izXwh7AyNtFpfX8Rbvu5vO0BqSCGhbBno/WOfXGqWJrPyOJF5ZSsFf0DYh8KAdIhsSzC
 Fn+A==
X-Gm-Message-State: ACrzQf00ohq6XZZsW25J6otE3+ekibWXYu9Vy8gkfIepmgoqrlmxLxOA
 D50KctRIob8Tttf+jPHVoqcuVQ==
X-Google-Smtp-Source: AMsMyM5L4/wnYoqPY7Lfe0ZxjSlXO8kmalMHRqh/UMafMsHtZVAmgq/s4+7IjonnmIgORkq9EHznsg==
X-Received: by 2002:a05:6000:1841:b0:236:70dc:1a6f with SMTP id
 c1-20020a056000184100b0023670dc1a6fmr32784664wri.464.1667843810520; 
 Mon, 07 Nov 2022 09:56:50 -0800 (PST)
Received: from localhost ([95.148.15.66]) by smtp.gmail.com with ESMTPSA id
 v4-20020a5d4a44000000b002365254ea42sm8079706wrs.1.2022.11.07.09.56.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Nov 2022 09:56:49 -0800 (PST)
From: Punit Agrawal <punit.agrawal@bytedance.com>
To: Usama Arif <usama.arif@bytedance.com>
Subject: Re: [v2 1/6] KVM: arm64: Document PV-lock interface
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <20221104062105.4119003-2-usama.arif@bytedance.com>
Date: Mon, 07 Nov 2022 17:56:49 +0000
Message-ID: <87k0463axq.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 fam.zheng@bytedance.com, bagasdotme@gmail.com, maz@kernel.org,
 punit.agrawal@bytedance.com, linux@armlinux.org.uk, liangma@liangbit.com,
 steven.price@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Usama,

Usama Arif <usama.arif@bytedance.com> writes:

> Introduce a paravirtualization interface for KVM/arm64 to obtain whether
> the VCPU is currently running or not.
>
> The PV lock structure of the guest is allocated by user space.
>
> A hypercall interface is provided for the guest to interrogate the
> location of the shared memory structures.
>
> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> ---
>  Documentation/virt/kvm/arm/index.rst    |  1 +
>  Documentation/virt/kvm/arm/pvlock.rst   | 52 +++++++++++++++++++++++++
>  Documentation/virt/kvm/devices/vcpu.rst | 25 ++++++++++++
>  3 files changed, 78 insertions(+)
>  create mode 100644 Documentation/virt/kvm/arm/pvlock.rst
>
> diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> index e84848432158..b8499dc00a6a 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -10,4 +10,5 @@ ARM
>     hyp-abi
>     hypercalls
>     pvtime
> +   pvlock
>     ptp_kvm
> diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
> new file mode 100644
> index 000000000000..d3c391b16d36
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/pvlock.rst
> @@ -0,0 +1,52 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Paravirtualized lock support for arm64
> +======================================
> +
> +KVM/arm64 provides a hypervisor service call for paravirtualized guests to
> +determine whether a VCPU is currently running or not.
> +
> +A new SMCCC compatible hypercall is defined:
> +
> +* ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID:   0xC6000002
> +
> +ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID
> +
> +    ============= ========    ==========================================
> +    Function ID:  (uint32)    0xC6000002
> +    Return value: (int64)     IPA of the pv lock data structure for this
> +                              VCPU. On failure:
> +                              NOT_SUPPORTED (-1)
> +    ============= ========    ==========================================
> +
> +The IPA returned by PV_LOCK_PREEMPTED should be mapped by the guest as normal
> +memory with inner and outer write back caching attributes, in the inner
> +shareable domain.
> +
> +PV_LOCK_PREEMPTED returns the structure for the calling VCPU.
> +
> +PV lock state
> +-------------
> +
> +The structure pointed to by the PV_LOCK_PREEMPTED hypercall is as follows:
> +
> ++-----------+-------------+-------------+---------------------------------+
> +| Field     | Byte Length | Byte Offset | Description                     |
> ++===========+=============+=============+=================================+
> +| preempted |      8      |      0      | Indicate if the VCPU that owns  |
> +|           |             |             | this struct is running or not.  |
> +|           |             |             | Non-zero values mean the VCPU   |
> +|           |             |             | has been preempted. Zero means  |
> +|           |             |             | the VCPU is not preempted.      |
> ++-----------+-------------+-------------+---------------------------------+
> +
> +The preempted field will be updated to 1 by the hypervisor prior to scheduling
> +a VCPU. When the VCPU is scheduled out, the preempted field will be updated
> +to 0 by the hypervisor.

The text above doesn't match the description in the table. Please update
the texts to align them with the code.

[...]

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
