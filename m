Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B2FC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 16:41:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C60961213
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 16:41:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3C60961213
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB91140642;
	Thu,  4 Nov 2021 12:41:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tqQT71FHMDiZ; Thu,  4 Nov 2021 12:41:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D44BD4A19F;
	Thu,  4 Nov 2021 12:41:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F283B406E7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 12:41:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eD9gbf3gJujt for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Nov 2021 12:41:03 -0400 (EDT)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
 [209.85.166.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1F6840642
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 12:41:03 -0400 (EDT)
Received: by mail-io1-f41.google.com with SMTP id v65so7622194ioe.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 09:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=n89uubugbDSS31fmjZBPGlZmDbloGpPz8qHQD795FjI=;
 b=KNVu5VlvLHC8LhEZJ1GeRcJxuhRBVKjlxW5S2JjtSy5YETOQgBq1h80cs+LZg6Jrqq
 66dkdvi1vERwy7tSwNjJJVnGC2YPONc/uMbJ8F9Wt//VhGN6Bgfy8P2/BCYZxXwZk3R1
 7jjndXad3DE+ZzFuwchi2YDL6NCF1UmgjvK3EPTDCGF0KzmaGIJ/cw9u2JnrLEGcIgDg
 cihXdT1LQ2nQkR3V/olZ2iTMpBSX9YF6CSg3qCUxleBhwC0c3O7A8Lxw++Oo16bEWP0T
 uWk4JRKXYmVcJKvDWra+KeLtBtGZVMafA4/kDPlmmu698FI0WE5rTmE9w86bcHEGsQeS
 mO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=n89uubugbDSS31fmjZBPGlZmDbloGpPz8qHQD795FjI=;
 b=J0Bz/+jCkuPjdjXDcHgDCRhX/Zluaq45YydHWbcgZ22U1QhPX56sq/DxAR/uCR0AhG
 z6HxWCf+rLs2y/Z2PHI+pfsgB+gCD4oCs9jU9PDNfs+RFl944dzrj8CPcWp5QJZIvPDg
 w6NCU+qvGAR9V3/GNXwy4kVG4B/+EPfB8lMKc1YfsJvQ/MVAXBJ5nW/DUj9hvEkkHY/J
 cZzwRtLqgHjtzsrbdEcoET2QOJht+PTczePSeR7aN3PF+xYc450n3EAOfpjal/Vin0U1
 Tzwj09K8UmfNaC6m0K0r168IYTHGvrxulpl/LZGqFzSsI+lO1FI15j4Tzz+ckb4ELP8l
 m+YA==
X-Gm-Message-State: AOAM532i6Ymk/JrLnj4xm6sXmKALTr+yMTCLiuao3+cZawmI4fN6m+tO
 F657FSgIUrbwJfIzZhgede81JA==
X-Google-Smtp-Source: ABdhPJzhfKc56+AGehB6rwlydFBdwcHeviUbHIFnDTRU6KIyTbtZIkuuDhw1XuIj5pRTYfxo6B4M8Q==
X-Received: by 2002:a5e:8c05:: with SMTP id n5mr6480970ioj.0.1636044062919;
 Thu, 04 Nov 2021 09:41:02 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id u12sm1074124iop.52.2021.11.04.09.41.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Nov 2021 09:41:02 -0700 (PDT)
Date: Thu, 4 Nov 2021 16:40:58 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v2 18/28] KVM: arm64: Introduce
 KVM_CAP_ARM_ID_REG_WRITABLE capability
Message-ID: <YYQNGqpy1NiUEXYD@google.com>
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-19-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211103062520.1445832-19-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
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

On Tue, Nov 02, 2021 at 11:25:10PM -0700, Reiji Watanabe wrote:
> Introduce a new capability KVM_CAP_ARM_ID_REG_WRITABLE to indicate
> that ID registers are writable by userspace.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 8 ++++++++
>  arch/arm64/kvm/arm.c           | 1 +
>  include/uapi/linux/kvm.h       | 1 +
>  3 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a6729c8cf063..f7dfb5127310 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7265,3 +7265,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
>  of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
>  the hypercalls whose corresponding bit is in the argument, and return
>  ENOSYS for the others.
> +
> +8.35 KVM_CAP_ARM_ID_REG_WRITABLE
> +--------------------------------

ID registers are technically already writable, KVM just rejects any
value other than what it derives from sanitising the host ID registers.
I agree that the nuance being added warrants a KVM_CAP, as it informs
userspace it can deliberately configure ID registers with a more limited
value than what KVM returns.

KVM_CAP_ARM_ID_REG_CONFIGURABLE maybe? Naming is hard :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
