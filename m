Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77669C43334
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 16:26:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC5A949DE3;
	Thu, 16 Jun 2022 12:26:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wbo-hYK0wWqu; Thu, 16 Jun 2022 12:26:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77FD849E37;
	Thu, 16 Jun 2022 12:26:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B26CC49E36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 12:26:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jmJT4jNPj-JY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 12:26:03 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FCC749DE3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 12:26:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655396763;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=cq3EZTL12suGQBdO/AxiYch3x1bNx+94IHDi7h+Rhok=;
 b=d9gXLvdu00EYqZtFdIzNu/qXjl6xZT6JlP4rqiShGKxiddvtP/QVT0+v1T1q8Buvq9uK5G
 sK4WgMTViLwlZQrDXxdNMDwDwVgYZikzxwsRbFof5fIBzf6nxdq8al+D7J9nj3xbpGLxDy
 Qn80C5sX+zP2NipfP+HMcoIyv7UpURs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-fXO9EgfYOt6sZOA8-al0kw-1; Thu, 16 Jun 2022 12:26:02 -0400
X-MC-Unique: fXO9EgfYOt6sZOA8-al0kw-1
Received: by mail-ej1-f71.google.com with SMTP id
 z7-20020a170906434700b007108b59c212so824478ejm.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 09:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cq3EZTL12suGQBdO/AxiYch3x1bNx+94IHDi7h+Rhok=;
 b=DdjbXBbQyxrKUxEmefQFXRnCA0/asSzMLwcySWNQoAaw+gNzlzNke3RiHUit6MCpL4
 9ey0ieES/FNxUTo7o2HH9xS/+6mL/LXbSoL9D8FweZMB+CK6KGHnXbREXt9oUo8R7yLk
 gkmL+rmmYxCmKsn2SFChTar+9p8I4IxxIwNGlg9+gkk3s8FKsceRLju/F9Bf47md1kvx
 EQTqtHMa6r0qCZsPGNgrMDaA2wqcPWF1rctQrv1T8nGKBzUuf5MzXuWiZ9d9Agpa5lfI
 C5gTrANx/sHE9omHR5G1NyAqZ/600OP8w7VbBFSUWvwJQdNZ6o6pnu1Y/Hq0iJ9v/K09
 Jy+A==
X-Gm-Message-State: AJIora8iimnxFu8XYP/JToSE6N8hqtdSpW2k0J+vh2wbr8Om1gVcLmym
 Wiyy15lFYRJogxCp8nWr4jUSjja1pz6qAhddYUuojs6YaHZiLurz6b9o3pgXbfyidVwNfWz7ACc
 JpYnjjr4bycVHp72/lnYiOBi3
X-Received: by 2002:a17:906:ff18:b0:711:d197:b942 with SMTP id
 zn24-20020a170906ff1800b00711d197b942mr5233795ejb.357.1655396760940; 
 Thu, 16 Jun 2022 09:26:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1snrckDTTS90UbXkNnXz7wC/j3NwBRdfiiLHQ55Yf08Jlwcihk2BkICbCcSqD0NukcTombHSw==
X-Received: by 2002:a17:906:ff18:b0:711:d197:b942 with SMTP id
 zn24-20020a170906ff1800b00711d197b942mr5233761ejb.357.1655396760732; 
 Thu, 16 Jun 2022 09:26:00 -0700 (PDT)
Received: from gator ([194.213.204.253]) by smtp.gmail.com with ESMTPSA id
 ep14-20020a1709069b4e00b006febc86b8besm936606ejc.117.2022.06.16.09.25.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 09:26:00 -0700 (PDT)
Date: Thu, 16 Jun 2022 18:25:57 +0200
From: Andrew Jones <drjones@redhat.com>
To: David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH] selftests: KVM: Handle compiler optimizations in ucall
Message-ID: <20220616162557.55bopzfa6glusuh5@gator>
References: <20220615185706.1099208-1-rananta@google.com>
 <20220616120232.ctkekviusrozqpru@gator>
 <33ca91aeb5254831a88e187ff8d9a2c2@AcuMS.aculab.com>
MIME-Version: 1.0
In-Reply-To: <33ca91aeb5254831a88e187ff8d9a2c2@AcuMS.aculab.com>
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

On Thu, Jun 16, 2022 at 03:58:52PM +0000, David Laight wrote:
> From: Andrew Jones
> > Sent: 16 June 2022 13:03
> > 
> > On Wed, Jun 15, 2022 at 06:57:06PM +0000, Raghavendra Rao Ananta wrote:
> > > The selftests, when built with newer versions of clang, is found
> > > to have over optimized guests' ucall() function, and eliminating
> > > the stores for uc.cmd (perhaps due to no immediate readers). This
> > > resulted in the userspace side always reading a value of '0', and
> > > causing multiple test failures.
> > >
> > > As a result, prevent the compiler from optimizing the stores in
> > > ucall() with WRITE_ONCE().
> > >
> > > Suggested-by: Ricardo Koller <ricarkol@google.com>
> > > Suggested-by: Reiji Watanabe <reijiw@google.com>
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/lib/aarch64/ucall.c | 9 ++++-----
> > >  1 file changed, 4 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > > index e0b0164e9af8..be1d9728c4ce 100644
> > > --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > > +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > > @@ -73,20 +73,19 @@ void ucall_uninit(struct kvm_vm *vm)
> > >
> > >  void ucall(uint64_t cmd, int nargs, ...)
> > >  {
> > > -	struct ucall uc = {
> > > -		.cmd = cmd,
> > > -	};
> > > +	struct ucall uc = {};
> > >  	va_list va;
> > >  	int i;
> > >
> > > +	WRITE_ONCE(uc.cmd, cmd);
> > >  	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
> > >
> > >  	va_start(va, nargs);
> > >  	for (i = 0; i < nargs; ++i)
> > > -		uc.args[i] = va_arg(va, uint64_t);
> > > +		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
> > >  	va_end(va);
> > >
> > > -	*ucall_exit_mmio_addr = (vm_vaddr_t)&uc;
> > > +	WRITE_ONCE(*ucall_exit_mmio_addr, (vm_vaddr_t)&uc);
> > >  }
> 
> Am I misreading things again?
> That function looks like it writes the address of an on-stack
> item into global data.

The write to the address that the global points at causes a switch
from guest to host context. The guest's stack remains intact while
executing host code and the host can access the uc stack variable
directly by its address. Take a look at lib/aarch64/ucall.c to see
all the details.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
