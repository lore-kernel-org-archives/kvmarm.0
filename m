Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DF4C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 07:48:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C129B40658;
	Thu, 24 Mar 2022 03:48:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9dkOU13R5pms; Thu, 24 Mar 2022 03:48:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98E9F4A104;
	Thu, 24 Mar 2022 03:48:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C27F4A104
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 03:48:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZZFeIHNS+1o8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 03:48:24 -0400 (EDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1ED64A100
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 03:48:24 -0400 (EDT)
Received: by mail-io1-f47.google.com with SMTP id e22so4444229ioe.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 00:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=/EWBr8VYndoFsZhwJYu5ltpIZZxYhiAYyqvf85+j+KE=;
 b=fFhWdVH5C9Vw1EGBgAZ6wFnCnGosqlFZGd/EdTvCOwkrAbuqvdWpShET5c9NZCXNAR
 /vbfQ9cn7vlKkv8Dpcda8sSphUfip1fu9Lvkn9sCM6IzEP0DmVpRGz1vt8Ug8pHP/zeI
 UhIIkk3Yff54n19h5QoOHY7lIICCcv8w8Sj6b6+6pqN4cDclGanbyLgPlQaqgAMj0c3X
 mwejRrXCPWQKAv0BXCKN1kEWoMrlRBveg0Zs3aHik9ver62z0NXERrJm9CLurqltS3ur
 otrK5EOR5bBrOhWcZQkIK1MxIW2/3sty6YtRsxfHOFbo6eL/B+xzh/CSmSraZjKWXkrv
 E33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/EWBr8VYndoFsZhwJYu5ltpIZZxYhiAYyqvf85+j+KE=;
 b=zCpYoWxxJzeLF9wj34hMe0yVGBYOr01bgcni+fD/A3WMTR/CeNAUmhSp3qjDNcljh/
 rTvxkBzMWT4OVHBHYu6r8pGObUbwHdnWmjZZXWe93ViD+jm66ynoIYx4rixPiND7UvyF
 A2bUasSWGsOWCUrfvdLxx5TAnR4IBa4B079YskDy+mHSBZ+ornUTsolA/L6AhL6fo5ao
 7aROnsDApU59wJl+Hb7mwSpv05GU5AabNSDY07Qr9a/1bKMa9zi5b+UpRJI76eGU1rLJ
 LeYvvNLFNrgXFETc0MmifKE3xD+4t4xcT8EmcCWX9sT5uLXYq1jE+zPfvPVEjTRdi3I6
 6iQw==
X-Gm-Message-State: AOAM532OJC2ZACIuv+EFpHn+6t4DvEqx+FhV/z7Xpd82LyKIlqRXAt22
 iMkdA8CbcCsdKkdrck/BYMmXVA==
X-Google-Smtp-Source: ABdhPJzT3s0Q3Xy1K5FeCDl/XBsNPYGaSwsf+FL7i6ImBHxLK/KqWW2Ix3kivnQC0FiksAdgqL3i6w==
X-Received: by 2002:a05:6638:3e13:b0:321:446d:2977 with SMTP id
 co19-20020a0566383e1300b00321446d2977mr2275141jab.178.1648108103680; 
 Thu, 24 Mar 2022 00:48:23 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 p66-20020a6bbf45000000b006499925f1f1sm1230513iof.19.2022.03.24.00.48.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 00:48:22 -0700 (PDT)
Date: Thu, 24 Mar 2022 07:48:19 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 03/22] KVM: arm64: Support SDEI_VERSION hypercall
Message-ID: <YjwiQ10CE5AtoM4Y@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-4-gshan@redhat.com>
 <YjoPxLAMIPobBzS0@google.com>
 <d8e151e5-080b-dc87-b7e0-9031a7928853@redhat.com>
 <YjtLVqBbL0jyFFZy@google.com>
 <6f217836-45fb-8833-7bb1-5dc822826f56@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6f217836-45fb-8833-7bb1-5dc822826f56@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Thu, Mar 24, 2022 at 12:07:34PM +0800, Gavin Shan wrote:

[...]

> > > Yeah, I was sticky to the pattern of "KVM". However, I think it's good
> > > to reuse the existing one. Lets use ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2
> > > if you agree. Its first two characters are "VM" at least.
> > 
> > Sounds fine to me. The only other nit I'd say is we should define a
> > macro for it too, something like:
> > 
> >    #define KVM_SDEI_VENDOR	ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2
> > 
> 
> Agreed, and the macro will be put into arch/arm64/include/asm/kvm_sdei.h.
> arch/arm64/include/uapi/asm/kvm_sdei_state.h isn't the right place because
> the dependent macro ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2 isn't exposed by
> ABI.

The argument could definitely be made that our vendor ID should be
promoted to UAPI. Even though linux is the only known user of our
vendor-specific hypercalls, nothing is stopping other software from
using them. Beyond that, these values should really never change anyway.

It isn't a big deal if you add it to internal headers, either, as the
only known consumer will be the kernel.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
