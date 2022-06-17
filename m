Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33EBC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 07:28:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 480C04B2A1;
	Fri, 17 Jun 2022 03:28:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id odCJ4MTJO1NN; Fri, 17 Jun 2022 03:28:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E94F14B229;
	Fri, 17 Jun 2022 03:28:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C309E4B21C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 03:28:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GTy0OnjGte9J for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 03:28:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 912524B1EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 03:28:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655450886;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=TfwWmf6pndQ83NMYFfQo/NU9rMgkJupydsAN7k3Ml00=;
 b=LSiar8CXu2oYHQrnojZ7hcehYBDGk3HYjz71o2T13N5OKPR3Xj874agjSLdNISQYIZspBe
 XYdJmOVbG1u7GQlNk23SQPHmfn7AUSg7ugdkujX9mBZMPcLpPuB86OYKCJWNIMS3ToLH1J
 xh8fmJfxuQU1tTeqUY4nzY/FvzH9eoY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-gwOElsPFMmm5Pvw0cidFRw-1; Fri, 17 Jun 2022 03:28:04 -0400
X-MC-Unique: gwOElsPFMmm5Pvw0cidFRw-1
Received: by mail-ed1-f71.google.com with SMTP id
 v7-20020a056402348700b004351fb80abaso2729015edc.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 00:28:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TfwWmf6pndQ83NMYFfQo/NU9rMgkJupydsAN7k3Ml00=;
 b=TK5CT7LTrsW5PYAWOO0y5OXHsf13YGGGOjebWWnFuPX+3HeUatId41ZAoYPMKdX+tt
 VzhQONn5Qq61DxnItnTtGPhBRDDlnL8Bq6f6at2UOfBQE++xPhlvg8MoX/zqOve3qBSD
 EQPlxwR0ivh+walIAAQUfjb2PADXiI4HTuXdLHHNPqBPk4Zo2hM34tetvq6XuNJlPTMi
 G0gZyvpYlJ6pDuN9u53mWWlmNv7KOXIVP21ghuWrE4fVVNq9i9RNR+aD6A6IMnxQ0wGH
 SpeVPjEO3GXpPBiX79Kq5OIL6eYud+/V9JLDbJBF14Euw2HRBlIGEWGyKk5IfEOpwhoy
 KJkg==
X-Gm-Message-State: AJIora/ekP5ZC2Oo61FEkWCA6CAkHza6cqBd22sr0x25/ZuhLrjw20Fb
 LKN12QecZ9O5uTG9hufqH+ucc1y0IL6yhI3PPQL2fO82IzB85KCuwhTbrUyix3kXigDoRpHTxNM
 cMxlHlyreMM0do1l2NWkul6a/
X-Received: by 2002:aa7:c744:0:b0:42d:f68f:13de with SMTP id
 c4-20020aa7c744000000b0042df68f13demr10725902eds.294.1655450883309; 
 Fri, 17 Jun 2022 00:28:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tKxJhbjxu1gQEDYzXe7aBUKjZhwikhFKlF31X4MiTyfLwkpvElCJYDyCHPMnrvEcQLcQ8oEA==
X-Received: by 2002:aa7:c744:0:b0:42d:f68f:13de with SMTP id
 c4-20020aa7c744000000b0042df68f13demr10725866eds.294.1655450883047; 
 Fri, 17 Jun 2022 00:28:03 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
 by smtp.gmail.com with ESMTPSA id
 7-20020a170906328700b006f3ef214db7sm1810644ejw.29.2022.06.17.00.28.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 00:28:02 -0700 (PDT)
Date: Fri, 17 Jun 2022 09:28:00 +0200
From: Andrew Jones <drjones@redhat.com>
To: David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH] selftests: KVM: Handle compiler optimizations in ucall
Message-ID: <20220617072800.cvqb4wmafxdi3knq@gator>
References: <3e73cb07968d4c92b797781b037c2d45@AcuMS.aculab.com>
 <20220615185706.1099208-1-rananta@google.com>
 <20220616120232.ctkekviusrozqpru@gator>
 <33ca91aeb5254831a88e187ff8d9a2c2@AcuMS.aculab.com>
 <20220616162557.55bopzfa6glusuh5@gator>
 <7b1040c48bc9b2986798322c336660ab@linux.dev>
 <2ec9ecbfb13d422ab6cda355ff011c9f@AcuMS.aculab.com>
MIME-Version: 1.0
In-Reply-To: <2ec9ecbfb13d422ab6cda355ff011c9f@AcuMS.aculab.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Colton Lewis <coltonlewis@google.com>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Thu, Jun 16, 2022 at 09:54:16PM +0000, David Laight wrote:
> From: oliver.upton@linux.dev
> > Sent: 16 June 2022 19:45
> 
> > 
> > June 16, 2022 11:48 AM, "David Laight" <David.Laight@aculab.com> wrote:
> > > No wonder I was confused.
> > > It's not surprising the compiler optimises it all away.
> > >
> > > It doesn't seem right to be 'abusing' WRITE_ONCE() here.
> > > Just adding barrier() should be enough and much more descriptive.
> > 
> > I had the same thought, although I do not believe barrier() is sufficient
> > on its own. barrier_data() with a pointer to uc passed through
> > is required to keep clang from eliminating the dead store.
> 
> A barrier() (full memory clobber) ought to be stronger than
> the partial one than barrier_data() generates.
> 
> I can't quite decide whether you need a barrier() both sides
> of the 'magic write'.
> Plausibly the compiler could discard the on-stack data
> after the barrier() and before the 'magic write'.
> 
> Certainly putting the 'magic write' inside a asm block
> that has a memory clobber is a more correct solution.

Indeed, since the magic write is actually a guest MMIO write, then
it should be using writeq().

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
