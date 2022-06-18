Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BDBC43334
	for <kvmarm@archiver.kernel.org>; Sat, 18 Jun 2022 00:09:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73F8F4B335;
	Fri, 17 Jun 2022 20:09:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wsOzbAN8AYge; Fri, 17 Jun 2022 20:09:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D7384B389;
	Fri, 17 Jun 2022 20:09:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87E434B33D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 20:09:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dQkHi8Al2zpG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 20:09:16 -0400 (EDT)
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com
 [209.85.210.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C4DA4B335
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 20:09:16 -0400 (EDT)
Received: by mail-pf1-f178.google.com with SMTP id z17so5410206pff.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 17:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rmREuzW95waiA3DDpOBKbzOCl6/bO3/zBUhkj2WSq9I=;
 b=YCP800zP22Elf3Ylaojub23i9i+c4DqKeQkNx5RkzWlB2guxY5lWBKf48hfbmaVQ/N
 eYGU19hBcx/GbITum/oZ8SXf9PmopWlcqw6oN1dmbAxSd/hhTpZFCC15vFDIIj3BGP/0
 qvM1b6rK1d4jcutPEYVdVKRsphQhA0gcmF88AOdPZTKbsVXqN/63OoO/vXbqjvmxClro
 ddQiy7dpqMjtCcF0gkWPyZPF/Y64THzretyJqrXrL6lsiQzDYFKUdgoah4WnyM8iFglV
 VQAodr3sNg5DnUEiK0RF52Xp9/hR8JzLLs9y9rC6Rq2DBo+iYF+YA0KEL/65OkfsoXHs
 zwlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rmREuzW95waiA3DDpOBKbzOCl6/bO3/zBUhkj2WSq9I=;
 b=WIy3XWbroeIsYJSJLfJduVKAok/iSaWNrS2Efd7lGVbWcGP4E8lvESznN5RqmvATeW
 kVrUsZrW9FGqmjA6c8VW7IY2rkNfTr4ybGsAglqYWkgKkHRtyIgiLU/PDUSK6Fn7UBjf
 l4gS1E5AqIqOEGqYhr9bPMsAYnMmoio0VZBImMUbrF8GkBkI6iDgtSn7+Y46p2fCH03k
 7FBi3SdLzemdERpeMw0uATW2ZsUznrHiCWIZsjuRo5NAIfbRxt5av+eVJ8OGwwButCLN
 6kHKElLXAr+aDg2brT+kSydGCIpzC66aI6w07EcWZGwUbwLo22QVpTPvsjUf6C0Iqf/V
 iWHQ==
X-Gm-Message-State: AJIora8giFUZq260YI5DZ3jLTsu7PzWdn+UdQPsT4EjVs7G8YQUNh4re
 ORlJhAxxfAf5gvOK5j1+V1K8WQ==
X-Google-Smtp-Source: AGRyM1ssehBTb8JKASbU9EaanhSrDN7Ob2S/Adon1xUDXwjcTBHM88tI85Trf31af1LqByg1k8MpIg==
X-Received: by 2002:a05:6a00:450d:b0:524:d95b:d51d with SMTP id
 cw13-20020a056a00450d00b00524d95bd51dmr6985967pfb.29.1655510955383; 
 Fri, 17 Jun 2022 17:09:15 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 iw13-20020a170903044d00b0015f4b7a012bsm565537plb.251.2022.06.17.17.09.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 17:09:15 -0700 (PDT)
Date: Sat, 18 Jun 2022 00:09:11 +0000
From: Sean Christopherson <seanjc@google.com>
To: Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <Yq0Xpzk2Wa6wBXw9@google.com>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
 <20220616121006.ch6x7du6ycevjo5m@gator>
 <Yqy0ZhmF8NF4Jzpe@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yqy0ZhmF8NF4Jzpe@google.com>
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Fri, Jun 17, 2022, Colton Lewis wrote:
> On Thu, Jun 16, 2022 at 02:10:06PM +0200, Andrew Jones wrote:
> > We probably want to ensure all architectures are good with this. afaict,
> > riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
> > for example.
> 
> All architectures use UCALL_MAX_ARGS for that. Are you saying there
> might be limitations beyond the value of the macro? If so, who should
> verify whether this is ok?

I thought there were architectural limitations too, but I believe I was thinking
of vcpu_args_set(), where the number of params is limited by the function call
ABI, e.g. the number of registers.

Unless there's something really, really subtle going on, all architectures pass
the actual ucall struct purely through memory.  Actually, that code is ripe for
deduplication, and amazingly it doesn't conflict with Colton's series.  Patches
incoming...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
