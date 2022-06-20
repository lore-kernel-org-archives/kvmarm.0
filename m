Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7D7C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 07:21:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15CB94B2E4;
	Mon, 20 Jun 2022 03:21:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fpCJpGMYsa5R; Mon, 20 Jun 2022 03:21:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAA034B1E0;
	Mon, 20 Jun 2022 03:21:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B9524B1E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 03:21:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tXNaSzjSB9Rl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 03:21:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C93F41175
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 03:21:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655709679;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=pcsdZGC4Bk5dXgiZa8ep5/wweeqwijr7QCScgIhJ8i8=;
 b=Ey1ceSo7IdSO6WQ0xU+amIqhW/yBDqRiIcUhe3kHfBws3tHdwOx8cH/Z7gH0sSbAH5zwq3
 ffhz5rTPnISHLEuFPDWecYDqnlMEmK40lI4q/ZPvKe06VslD93BpE8x090KM2dOjzTCFTP
 HYZlQTjVuoQzgIdUQw4dBMIn8jpZ5sk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-FbXH9BiJOLGBfqaVtP3Lkg-1; Mon, 20 Jun 2022 03:21:15 -0400
X-MC-Unique: FbXH9BiJOLGBfqaVtP3Lkg-1
Received: by mail-wm1-f69.google.com with SMTP id
 n15-20020a05600c4f8f00b0039c3e76d646so4650438wmq.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 00:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pcsdZGC4Bk5dXgiZa8ep5/wweeqwijr7QCScgIhJ8i8=;
 b=IZsZ840Ig1ORMoYZsOoeweEpLJFRasaCUh4S/RR5Wty82NEb3t5oqahyVNu4UgPlQy
 CaNKHu+vgIRhURKCoNDfcJiO3tOhuz5yplsj3oXpnrS3uZO1XvmxB4i2Ch2QEgq21Ahc
 treXAHtD8Cm/rSnzoQPITJO1RFmiE+rhZbBokfTgAg/2CF0fBB8y8HrBsB/TC10jO4JK
 3/b450esDByUbtftsU96in2j2RM7CjFms3vPDRExT9nLvdjw5I+chfACnkFNeSgfQ08K
 jIUrZUSWYTeM4+yQgUal+YjEOfW3pjW/Q8XSuUJfef8V2fZ90NZp0l0tuul35OKl2Roq
 O9yA==
X-Gm-Message-State: AJIora8WFigN8GdApQeGde9vrhJD5gqgOW8+/WESxcW2cfC9LPu7cxb4
 2c9ktv3+FrZV0187eraua2l0bXQm9ggGbjACdSIG8BYdQmCm7iJRsvZvdT44okMTr8MwY3U6SMo
 0+GT1QSOewKo/8eYcOhDgUi+N
X-Received: by 2002:a5d:5262:0:b0:21b:84a8:8417 with SMTP id
 l2-20020a5d5262000000b0021b84a88417mr11405784wrc.119.1655709674178; 
 Mon, 20 Jun 2022 00:21:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1txOi/SXc3CvYBEGxZ+FPzKw9rbDlha6c/GWUp1Y8R77N6vsUCuRy/AIRSU0CexLa25YUvpjQ==
X-Received: by 2002:a5d:5262:0:b0:21b:84a8:8417 with SMTP id
 l2-20020a5d5262000000b0021b84a88417mr11405759wrc.119.1655709673959; 
 Mon, 20 Jun 2022 00:21:13 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
 by smtp.gmail.com with ESMTPSA id
 p3-20020a1c5443000000b0039c362311d2sm21441591wmi.9.2022.06.20.00.21.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jun 2022 00:21:13 -0700 (PDT)
Date: Mon, 20 Jun 2022 09:21:11 +0200
From: Andrew Jones <drjones@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <20220620072111.ymj2bti6jgw3gsas@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
 <20220616121006.ch6x7du6ycevjo5m@gator>
 <Yqy0ZhmF8NF4Jzpe@google.com> <Yq0Xpzk2Wa6wBXw9@google.com>
MIME-Version: 1.0
In-Reply-To: <Yq0Xpzk2Wa6wBXw9@google.com>
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

On Sat, Jun 18, 2022 at 12:09:11AM +0000, Sean Christopherson wrote:
> On Fri, Jun 17, 2022, Colton Lewis wrote:
> > On Thu, Jun 16, 2022 at 02:10:06PM +0200, Andrew Jones wrote:
> > > We probably want to ensure all architectures are good with this. afaict,
> > > riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
> > > for example.
> > 
> > All architectures use UCALL_MAX_ARGS for that. Are you saying there
> > might be limitations beyond the value of the macro? If so, who should
> > verify whether this is ok?
> 
> I thought there were architectural limitations too, but I believe I was thinking
> of vcpu_args_set(), where the number of params is limited by the function call
> ABI, e.g. the number of registers.
> 
> Unless there's something really, really subtle going on, all architectures pass
> the actual ucall struct purely through memory.  Actually, that code is ripe for
> deduplication, and amazingly it doesn't conflict with Colton's series.  Patches
> incoming...
>

RISC-V uses sbi_ecall() for their implementation of ucall(). CC'ing Anup
for confirmation, but if I understand the SBI spec correctly, then inputs
are limited to registers a0-a5.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
