Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFFC13ADF
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 15:24:32 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-586a6269dbfso15007727b3.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 08:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691162672; x=1691767472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cg+BPfk9QstTM+/p+EMBw3OytkWAvvbhRYFkqlerfdw=;
        b=n8O41gfu0v8W3Eo0JNgpUADRtyfkwSv2JplJqPHR8pfshQ3/lNiyvEHDZ1M2gV+CKd
         AT8V18SmMFs4xeCBD45H10gP850OyNngFsYdk4BCA17OWpQ4Xmjfn+YVLzbudoU5mqPr
         4CLDRP+lgE7NusnuHvbOYP/4/UEagjQKuExHROxxHFQSPiWhAvRoovsslgMeUQhHIZXK
         ylPiGNGzo1v+2NNdTACGEeAOBOyFZRQ7JccOlLZRzsvttedfouepFxueVp5dFacC50Ci
         GZfB6ZYOvJgCH67Mna0H6U+l6IXtZZWoERfhoIKehmTCXBhdfd6gzbIdMd+1vupS1xi3
         BIWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691162672; x=1691767472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cg+BPfk9QstTM+/p+EMBw3OytkWAvvbhRYFkqlerfdw=;
        b=j0GJS58wT8gbwSep5a326JgArl2VYHGl/8P+5DEXbBTJZX+YNZuFEE6TYcQ8LtQm9r
         ujtkV1IjRWW1DXsfhIZoZpbS4sCP6Yf3T93GX6ApwpztjvGLfSFjPm+AZcE+t1igddir
         QHEvAqFcD/w1Bj0NLo6h6gF97+ANBQZoTXsgdemPjiV9RST/DKn8ge/iwqorI8CIv5jq
         xvxBUiXLtMs2NDMJHV6opeiwt4D9lkAdO+KJ2lA4M0CSTm0xmDSO1g1KkWdu+8f3h57F
         lbgE/k1qk0i5gNWO+gjoinM82+rmHjCVRiX3ZXTuHfjS+YatF422MrLiHeYGiqGuiGS3
         j57A==
X-Gm-Message-State: AOJu0YyoY4rV9B2ExUR2aav7VMDatnnSsAl9nbY2iI3MKdaS9EeGOdAA
	alztuCzORO1GUCBkAL2WU5sUVxUgOn0=
X-Google-Smtp-Source: AGHT+IGBENvHbIPWalo9e1vUP6I9SbYdENJwDfmlXtBN8bF3yYa+DFLhCVVTARap930KJujspRp4+arkHrI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:c05:b0:576:e268:903d with SMTP id
 cl5-20020a05690c0c0500b00576e268903dmr79ywb.2.1691162671930; Fri, 04 Aug 2023
 08:24:31 -0700 (PDT)
Date: Fri, 4 Aug 2023 08:24:30 -0700
In-Reply-To: <20230804004226.1984505-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230804004226.1984505-1-seanjc@google.com>
Message-ID: <ZM0YLh1kOXY7OwTc@google.com>
Subject: Re: [PATCH 0/4] KVM: selftests: ioctl() macro cleanups
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

+KVM (good job me)

On Thu, Aug 03, 2023, Sean Christopherson wrote:
> Do some minor housekeeping on the ioctl() macros, and then teach them
> to detect and report when an ioctl() unexpectedly fails because KVM has
> killed and/or bugged the VM.
> 
> Note, I'm 50/50 on whether or not the ARM patch is worthwhile, though I
> spent a stupid amount of time on it (don't ask), so darn it I'm at least
> posting it.
> 
> Oh, and the To: will probably show up funky, but I'd like to take this
> through kvm-x86/selftests, not the ARM tree.
> 
> Thanks!
> 
> Sean Christopherson (4):
>   KVM: selftests: Drop the single-underscore ioctl() helpers
>   KVM: selftests: Add helper macros for ioctl()s that return file
>     descriptors
>   KVM: selftests: Use asserting kvm_ioctl() macros when getting ARM page
>     sizes
>   KVM: selftests: Add logic to detect if ioctl() failed because VM was
>     killed
> 
>  .../selftests/kvm/include/kvm_util_base.h     | 101 ++++++++++++------
>  .../selftests/kvm/lib/aarch64/processor.c     |  18 ++--
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +--
>  3 files changed, 84 insertions(+), 52 deletions(-)
> 
> 
> base-commit: 240f736891887939571854bd6d734b6c9291f22e
> -- 
> 2.41.0.585.gd2178a4bd4-goog
> 
