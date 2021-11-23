Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF84CC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 14:25:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44BBC4B0C0;
	Tue, 23 Nov 2021 09:25:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1+L3RkuqVOBh; Tue, 23 Nov 2021 09:25:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73D0C4B1D5;
	Tue, 23 Nov 2021 09:25:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 841F14B0E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 09:25:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m-Qk-pK+rrLS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 09:25:31 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A9474B0C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 09:25:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637677531;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ZDtecHcGG6uREO+dPTK7MwZPpOOPbHKRsEx76V4VSQc=;
 b=JO6llYJ3JEWqABuFFnEbIhTJ7WdglsAWFbwsFWgNOv9uQGfEvaEFjBrsBK0CAdPvdJJpz4
 L7nF1fEYwOpgWZfEUu0yUqegMs3ejoA1fNUt0TYBzUoO4SikhZmHjY/PEI8WmKYPgGxEkd
 IYcd4J2GJ2D5eWAltp66KB9QepmnwyQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-xu4MXyb6O86WQEHi3XPS4w-1; Tue, 23 Nov 2021 09:25:29 -0500
X-MC-Unique: xu4MXyb6O86WQEHi3XPS4w-1
Received: by mail-ed1-f70.google.com with SMTP id
 b15-20020aa7c6cf000000b003e7cf0f73daso17860502eds.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 06:25:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ZDtecHcGG6uREO+dPTK7MwZPpOOPbHKRsEx76V4VSQc=;
 b=MGSkqC404mLNqCfOpCTFghY0ia+Jm1ViTLjwFyxctCdjsg8pRWCXvOnHz+CBtWKrVE
 XpV/H1rKYmjGAWYh3aimfiNhOMUUGyu87fitqIct+PzMWZtRi1cDRkMYv157Kwhj8AYW
 53s28r+O60OSM7UIc5vYT/pedydDotu7wzMLIhiozff/CJhJcMXBq38wwDKG6bH0uvmh
 KNmY27KB0xi83mnm/AhBmFgiPqfoR+zRtaz2OqIBx1g05EcZZQAhLmhF/wjYyNXFw//N
 +S4JRcsRdmWnVnYB6Y+ylBzv8bY1P3s7sNPVNgX+a++/15bHg9ruCazut0JqRb64ZuzS
 lQfA==
X-Gm-Message-State: AOAM5320SgPi9A3RCazcphP/T/VCFCP9KsgBP//54eywIwYbzxkH50x7
 t0OlV4KzVNuMFwLRzsUCN3U0ICL1It3qfjYdwqiDadf78PPHDTdejyG0WcWtym9NT0OwkjPSGb2
 PClHAYIi61+MkZZ6W8kV0jRrJ
X-Received: by 2002:a17:906:eda3:: with SMTP id
 sa3mr8124100ejb.51.1637677528070; 
 Tue, 23 Nov 2021 06:25:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnoKfeX34OruxvnqgnkqOqBxkHRu62ZfO1tJVHZ2NuSw6a7j/qkRRSUXAc0Sqgyw1mXMoOrw==
X-Received: by 2002:a17:906:eda3:: with SMTP id
 sa3mr8123947ejb.51.1637677527157; 
 Tue, 23 Nov 2021 06:25:27 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id k16sm5822213edq.77.2021.11.23.06.25.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 Nov 2021 06:25:26 -0800 (PST)
Date: Tue, 23 Nov 2021 15:25:24 +0100
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 00/17] KVM: selftests: aarch64: Test userspace IRQ
 injection
Message-ID: <20211123142524.4bjhdvw5pkx3g5ct@gator.home>
References: <20211109023906.1091208-1-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Mon, Nov 08, 2021 at 06:38:49PM -0800, Ricardo Koller wrote:
> This series adds a new test, aarch64/vgic-irq, that validates the injection of
> different types of IRQs from userspace using various methods and configurations
> (when applicable):
> 
>     Intid        Method     |       |          Configuration
>                             |       |
>                IRQ_LINE     |       |
>     SGI        LEVEL_INFO   |       |
>     PPI    x   IRQFD        |   x   | level-sensitive  x  EOIR + DIR
>     SPI        ISPENDR      |       | edge-triggered      EOIR only
>     bogus      ISACTIVER    |       |
>                             |       |
> 
> vgic-irq is implemented by having a single vcpu started in any of the 4 (2x2)
> configurations above.  The guest then "asks" userspace to inject all intids of
> a given IRQ type using each applicable method via a GUEST_SYNC call.  The
> applicable methods and intids for a given configuration are specified in tables
> like this one:
> 
>     /* edge-triggered */
>     static struct kvm_inject_desc inject_edge_fns[] = {
>             /*                            sgi    ppi    spi */
>             { KVM_IRQ_LINE,               false, false, true },
>             { IRQFD,                      false, false, true },
>             { ISPENDR,                    true,  false, true },
>     };
> 
> Based on the (example) table above, a guest running in an edge-triggered
> configuration will try injecting SGIs and SPIs.  The specific methods are also
> given in the table, e.g.: SGIs are injected from userspace by writing into the
> ISPENDR register.
> 
> This test also adds some extra edge tests like: IRQ preemption, restoring
> active IRQs, trying to inject bogus intid's (e.g., above the configured KVM
> nr_irqs).
> 
> Note that vgic-irq is currently limited to a single vcpu, GICv3, and does not
> test the vITS (no MSIs).
> 
> - Commits 1-3 add some GICv3 library functions on the guest side, e.g.: set the
>   priority of an IRQ.
> - Commits 4-5 add some vGICv3 library functions on the userspace side, e.g.: a
>   wrapper for KVM_IRQ_LINE.
> - Commit 6 adds the basic version of this test: inject an SPI using
>   KVM_IRQ_LINE.
> - Commits 7-17 add other IRQs types, methods and configurations.
>

Hi Ricardo,

I didn't review this in detail, but it looks good and quite thorough. Out
of curiosity did thoroughness come from attempting to get coverage on KVM
code? I.e were you running some sort of code coverage tool on KVM with
these tests?

Unfortunately I probably won't have a chance to look much closer than the
scan I just did, so FWIW

For the series

Acked-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
