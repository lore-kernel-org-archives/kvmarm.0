Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B97CCA479
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 13:21:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 795DC401AF;
	Mon, 20 Jun 2022 09:21:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RaFmfQOUKBXN; Mon, 20 Jun 2022 09:20:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 573854B4C8;
	Mon, 20 Jun 2022 09:20:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAF194B4A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 09:20:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mHQO2TpRRcMx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 09:20:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A1B4B4A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 09:20:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655731256;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=NzIQ07jP7Ucf0c+44ASJDe761bf0uW4WoGXyOYmuq/Y=;
 b=O82dgzMBpJTpv/iVl/DBIhqGvqss20a8jd56dJDQ+iLwbKA6wJGnMTqDtoBTY8DcLfQgIp
 eo8terVjGa+n74Rxqa3if2MQVCQZXyB6XBMEJGm5dsHIiu/jhoAR2D1PcUdU7F3QxYVJb3
 QNvTT+ZppnXcqpY6vcfqrS4J41+GaNM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-1s67SVNwO0KvmgOhK455hg-1; Mon, 20 Jun 2022 09:20:52 -0400
X-MC-Unique: 1s67SVNwO0KvmgOhK455hg-1
Received: by mail-wm1-f72.google.com with SMTP id
 i188-20020a1c3bc5000000b0039db971c6d9so5607040wma.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 06:20:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NzIQ07jP7Ucf0c+44ASJDe761bf0uW4WoGXyOYmuq/Y=;
 b=peRh/WpF4lAkj1UJtwk5h8ZdZQnhZxSk80Q7umUORLNTfu+OGHDqwp5lnYwZUf8mTE
 ZhW53KPzXf/oUysWTXNmbQzcZ2+CgycOXqms4dbe4ZsRFPfHV7OKdj44ZYoZNC6kXK/D
 L6lvjczE56XZ0CEWPqAG9JWIja2W4KYTJ54RY/ORCjhIjeBq5YDAsElHPyMcS0t3vHmB
 lreMVkyhytKZ62EPo0rDx8dZDhGzDVyqIMO/6IRwxLEvkJq9Y09GKJbBSK6VY1Z5ZXFl
 W5NjCF4DLUNY50e9WlwUM7ARUyZzKosVLziut6GnW0fpD4BmUaRA1wDwUZZs5xjrLbs5
 XPhw==
X-Gm-Message-State: AJIora8UP2Bk9cpy67YBTjiVX6nmItjiFQ08kea7bdCCRILaY8uXlEoj
 49lXEGHw9crInLDAWWYhixe+iLiLUX9IVnG1G4NokTmSjX5IyBg2fpXsbqY0/WGv/ckbstnAA7o
 oUqXvddYjt4O7UOK9M/y4dasQ
X-Received: by 2002:a05:6000:1887:b0:218:5d15:9a95 with SMTP id
 a7-20020a056000188700b002185d159a95mr23018016wri.1.1655731251620; 
 Mon, 20 Jun 2022 06:20:51 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v6YrcUzZO8F2Fmbea+YPgX0T97b5fSHtTGMMCEGdCHdfnbcGRcWGr1IQ5E9v6jUl3rX0Y8uw==
X-Received: by 2002:a05:6000:1887:b0:218:5d15:9a95 with SMTP id
 a7-20020a056000188700b002185d159a95mr23017989wri.1.1655731251385; 
 Mon, 20 Jun 2022 06:20:51 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
 by smtp.gmail.com with ESMTPSA id
 d5-20020a5d4f85000000b0021b862ad439sm9067735wru.9.2022.06.20.06.20.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jun 2022 06:20:50 -0700 (PDT)
Date: Mon, 20 Jun 2022 15:20:48 +0200
From: Andrew Jones <drjones@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <20220620132048.jey6rjbbw7skbupb@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
 <20220616121006.ch6x7du6ycevjo5m@gator>
 <Yqy0ZhmF8NF4Jzpe@google.com> <Yq0Xpzk2Wa6wBXw9@google.com>
 <20220620072111.ymj2bti6jgw3gsas@gator>
MIME-Version: 1.0
In-Reply-To: <20220620072111.ymj2bti6jgw3gsas@gator>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 Colton Lewis <coltonlewis@google.com>, pbonzini@redhat.com,
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

On Mon, Jun 20, 2022 at 09:21:11AM +0200, Andrew Jones wrote:
> On Sat, Jun 18, 2022 at 12:09:11AM +0000, Sean Christopherson wrote:
> > On Fri, Jun 17, 2022, Colton Lewis wrote:
> > > On Thu, Jun 16, 2022 at 02:10:06PM +0200, Andrew Jones wrote:
> > > > We probably want to ensure all architectures are good with this. afaict,
> > > > riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
> > > > for example.
> > > 
> > > All architectures use UCALL_MAX_ARGS for that. Are you saying there
> > > might be limitations beyond the value of the macro? If so, who should
> > > verify whether this is ok?
> > 
> > I thought there were architectural limitations too, but I believe I was thinking
> > of vcpu_args_set(), where the number of params is limited by the function call
> > ABI, e.g. the number of registers.
> > 
> > Unless there's something really, really subtle going on, all architectures pass
> > the actual ucall struct purely through memory.  Actually, that code is ripe for
> > deduplication, and amazingly it doesn't conflict with Colton's series.  Patches
> > incoming...
> >
> 
> RISC-V uses sbi_ecall() for their implementation of ucall(). CC'ing Anup
> for confirmation, but if I understand the SBI spec correctly, then inputs
> are limited to registers a0-a5.

Ah, never mind... I see SBI is limited to 6 registers, but of course it
only needs one register to pass the uc address... We can make
UCALL_MAX_ARGS whatever we want.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
