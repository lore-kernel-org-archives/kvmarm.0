Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6C3C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 18:03:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C633C40BC0;
	Mon, 14 Mar 2022 14:02:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tQHp5MtlV6PO; Mon, 14 Mar 2022 14:02:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE2F0410F7;
	Mon, 14 Mar 2022 14:02:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70A0240BC0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 14:02:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NubfeyvzWHk4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 14:02:56 -0400 (EDT)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com
 [209.85.166.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 779F040B6C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 14:02:56 -0400 (EDT)
Received: by mail-il1-f173.google.com with SMTP id d3so11596556ilr.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 11:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8536zTCC0nz+jAiN1Qoj3oXH4YMV4n9ZnMmaeo4Xicg=;
 b=WtLSR3KJ8u9JQkI9+QSWyYPtWKcjlMAKFvYeejWljSWKsJQGM59y9i1IdxqS3+2+pg
 w7Ji25CC9oXxA5xeRbkm6/QQUdvkOssJAgNQ9l/KXY2CjLMYMuqTjnl+ox+Ia37oNvYN
 G6eJ7DAuBLnjB2YBIomjBNXkB68JMFnpv2puOs9pWJFixYXHMRAphvT0lR6lN9huIha4
 CykHm8Z0nm3EpY24SvluveXCt3nTtLVrOvqQ4Ffvv3ZO9ZZ+ggXhI9ElbUuudaRFOvcI
 DPQx65e2r0DDfqlmJxws/Vxl+IvEBJvpzEoYeuKEyzG2C9EWwNi0OvTomBJaENH5rULI
 LQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8536zTCC0nz+jAiN1Qoj3oXH4YMV4n9ZnMmaeo4Xicg=;
 b=3igaPzI6ufbuSgawUjUJ9UnZPH0QBE5bkKf6QP0PVhyidwqTypIFFtXtQ7+Kqgozu6
 rohpibsGmVqL6d3EQyaKWOUAnMkLjf09sab5nrcUn5WiyHNQ9N3DBmjms1B7Pdx6nfLl
 dYRYK4b63yoEWrAcFQ5KP/jrrslD44FQ3iuZ9z9M/AMfctetPruIBbitnmmkdechIMJP
 20PLVq9oXm4bwTN9kKEUeTgmaM3aUxaIrcxhyLLHR12hkiWyZLr/wnSinsBKC2y7CGJN
 30CUnJuYKaXxIVBaP91kQpsx5MRSpJ5IN4TFJEHUWZi/eKM5j7md/ItKt3bwwaDkvt/5
 D1zA==
X-Gm-Message-State: AOAM533FUY42oAqKLshKiRcDG2ZNDdE/jbbWgqH4mZdXk/BGtU9wzYB6
 /AnvWG38b/YuR2NVkjIsZwnxmQ==
X-Google-Smtp-Source: ABdhPJyudojN0tne3cl946mlYkSIDAiVPxLHDvbjzXb1BXUOPQ05BUW/BUAvbjwMoHoqH4g/6ZzqbA==
X-Received: by 2002:a92:8e06:0:b0:2c7:a8f8:3c5d with SMTP id
 c6-20020a928e06000000b002c7a8f83c5dmr3107778ild.107.1647280975428; 
 Mon, 14 Mar 2022 11:02:55 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 e8-20020a056602158800b0064683f99191sm8050365iow.39.2022.03.14.11.02.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Mar 2022 11:02:54 -0700 (PDT)
Date: Mon, 14 Mar 2022 18:02:51 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 04/13] KVM: arm64: Capture VM's first run
Message-ID: <Yi+DS/BUPMiB+B0a@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-5-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220224172559.4170192-5-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

Hi Raghavendra,

On Thu, Feb 24, 2022 at 05:25:50PM +0000, Raghavendra Rao Ananta wrote:
> Capture the first run of the KVM VM, which is basically the
> first KVM_RUN issued for any vCPU. This state of the VM is
> helpful in the upcoming patches to prevent user-space from
> configuring certain VM features, such as the feature bitmap
> exposed by the psuedo-firmware registers, after the VM has
> started running.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

I believe this patch is superseded by commit:

  5177fe91e4cf ("KVM: arm64: Do not change the PMU event filter after a VCPU has run")

on kvmarm/next.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
