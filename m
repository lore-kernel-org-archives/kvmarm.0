Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC48C54EE9
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 21:48:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF3034B5FE;
	Thu, 22 Sep 2022 17:48:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Szqg7m9sUEc; Thu, 22 Sep 2022 17:48:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64C9C40D05;
	Thu, 22 Sep 2022 17:48:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AD7C40D05
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 17:48:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 947i-r43DYXe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 17:48:23 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 816AE40C94
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 17:48:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663883303;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=eClHEiaGY+V73ww0FsJUa6mh3+Y82NAzO9R+KDs/BPU=;
 b=fVfc/v+Npkll3fvesXY5If9pePJ+2xO8V3ABHt+lx6SoNisqOvLU09toHPsjVwR8/CWGs0
 Je9J61BSLaRmZt1yRXfMvehhyAryqmYcKPBu3kf8i8td3djLsH04wEjWHkK84l7LErdGqf
 rWXKwPe0GrngQc4KJiGY3eiK0vblZbY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-Q1OLN6_gPMme1qliKUkpNg-1; Thu, 22 Sep 2022 17:48:22 -0400
X-MC-Unique: Q1OLN6_gPMme1qliKUkpNg-1
Received: by mail-qk1-f198.google.com with SMTP id
 r14-20020a05620a298e00b006be796b6164so7593846qkp.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 14:48:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=eClHEiaGY+V73ww0FsJUa6mh3+Y82NAzO9R+KDs/BPU=;
 b=mEfJuRuEztf/pVqcKCvxr72AhgsguOO6AoI7ZqO1ccq0Gpv86vkhTffVAs6iXW34zp
 /h/cCY1jNYSAAtpY+A2R/K9MDTfumYvH1A3Blmd24Bmq25ua5HV9N86LrNxat3NKE/9w
 up6rTfgJ3Ca2voXpExj/M7IS7yndws3WQfBrdyWGkYE+1k6UK/Jj7rLbWgqImYKryjdK
 Rc+BKbny1q2CLg0JFhVjCb/D6KUL0SzgjYYxdWVmzVwcJj0Msncgl0qIR2eKNyRzWj5V
 wXjCwHe9kd/cTzSjZuF/UmIfikj5p5Xsn17hIMA64YZtJuzx5/k5ipEuV/nC2CVpBAva
 /dXw==
X-Gm-Message-State: ACrzQf3osv9qfjt3RPr/VJ9WpXgBGH7z1f85ipvKadPT9AqofTspYsoq
 iJCcSDfga7D1zDNXtAHsZTLwFwbJGDghJr8JZH/iuj3K0vzTTbCCh16iYpLrhiN2253XcNkEflF
 0FnENE45sFzb/qpwu6e3BMP0l
X-Received: by 2002:a05:620a:4e3:b0:6cf:427b:c20b with SMTP id
 b3-20020a05620a04e300b006cf427bc20bmr3680512qkh.164.1663883301758; 
 Thu, 22 Sep 2022 14:48:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6JiazJoJ7P1B2iQiBzeghsaJe7Quv/mrNWuNPqUxoRHJU/QK2FCPX/n64KpWw2fHGBa9Wv3w==
X-Received: by 2002:a05:620a:4e3:b0:6cf:427b:c20b with SMTP id
 b3-20020a05620a04e300b006cf427bc20bmr3680488qkh.164.1663883301544; 
 Thu, 22 Sep 2022 14:48:21 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
 by smtp.gmail.com with ESMTPSA id
 r13-20020ac8794d000000b003438a8e842fsm4137374qtt.44.2022.09.22.14.48.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Sep 2022 14:48:21 -0700 (PDT)
Date: Thu, 22 Sep 2022 17:48:19 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
Message-ID: <YyzYI/bvp/JnbcxS@xz-m1.local>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-3-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220922170133.2617189-3-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 22, 2022 at 06:01:29PM +0100, Marc Zyngier wrote:
> In order to differenciate between architectures that require no extra
> synchronisation when accessing the dirty ring and those who do,
> add a new capability (KVM_CAP_DIRTY_LOG_RING_ORDERED) that identify
> the latter sort. TSO architectures can obviously advertise both, while
> relaxed architectures most only advertise the ORDERED version.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/linux/kvm_dirty_ring.h |  6 +++---
>  include/uapi/linux/kvm.h       |  1 +
>  virt/kvm/Kconfig               | 14 ++++++++++++++
>  virt/kvm/Makefile.kvm          |  2 +-
>  virt/kvm/kvm_main.c            | 11 +++++++++--
>  5 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> index 906f899813dc..7a0c90ae9a3f 100644
> --- a/include/linux/kvm_dirty_ring.h
> +++ b/include/linux/kvm_dirty_ring.h
> @@ -27,7 +27,7 @@ struct kvm_dirty_ring {
>  	int index;
>  };
>  
> -#ifndef CONFIG_HAVE_KVM_DIRTY_RING
> +#ifndef CONFIG_HAVE_KVM_DIRTY_LOG

s/LOG/LOG_RING/ according to the commit message? Or the name seems too
generic.

Pure question to ask: is it required to have a new cap just for the
ordering?  IIUC if x86 was the only supported anyway before, it means all
released old kvm binaries are always safe even without the strict
orderings.  As long as we rework all the memory ordering bits before
declaring support of yet another arch, we're good.  Or am I wrong?

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
