Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06E6C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 16:43:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 699FE4B945;
	Wed,  2 Nov 2022 12:43:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u37lXHrIJFwR; Wed,  2 Nov 2022 12:43:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B9AF4B8FE;
	Wed,  2 Nov 2022 12:43:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 723CD4B8DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:43:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9gCIJ+fkDVZM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 12:43:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A1D04B8D4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:43:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667407401;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=fTFZdSVqI0N+O3i56sH80q79jqwRkWzhFiqZV68haTk=;
 b=WW0qc1gqVkLVWAn/IbW5G2//Uo8t6ol9FvpU8GMj1XRl4Nwd7qCPv9SGtOqctG8RaXHtcp
 JCXP2U0twm6Zr+eoWDbuLIQdDo+E65VaKsMCsDsORMjAbQ0VY65HBZFpJFccRBPBeJ8IbM
 K6pGHKmZFbdWU5vA2B5ti9asumMVVx0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-150-Z97uUr-dPiO5ssPCw7srDA-1; Wed, 02 Nov 2022 12:43:19 -0400
X-MC-Unique: Z97uUr-dPiO5ssPCw7srDA-1
Received: by mail-qt1-f199.google.com with SMTP id
 cp8-20020a05622a420800b003a4f4f7b621so12450071qtb.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 09:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=fTFZdSVqI0N+O3i56sH80q79jqwRkWzhFiqZV68haTk=;
 b=UDOFVhngAMueFS6g2jcBMkQb8L6GfH5NdchGL4lRCCvNitxWwXE1Cxhr3nYOtZkToL
 PydPCtjGFPV8hJGwp17JLr1czGJgKD6VG8C0M3TeFbYcWNyU8B/dLTgNRaHediEL/DHP
 khLyQM1mfnVjPr6dosKdbrp9CYJzvAvzayM9y268Vt/I+qA8SFKZ67ixVS4iMWIk8v/D
 mO550DXolQQtjQUDMCt3VBW25nMsSgijT3ldNL0BjyRd4XSn2rDRSYkk1rADY+GG7DOZ
 AItVO4czCBrgbdZzuuvK6UCRnr/AwwSbz/E9vruGzYZXAF7nDbRpbwT31p03tY/ucpBs
 nAlw==
X-Gm-Message-State: ACrzQf28233Zxyco64I8495cffap6JK/YY0xgqOuwZJhGm1lqb9u+NGm
 ZuTsdeiOuiL+dzjXlLYykZS/lDMBd6esQJE88l/Sx9jDMCsngg1duonecxGAgsXkcq+87JbLIKe
 8dAAAHCKHRVI0eNb8VCnQFGU5
X-Received: by 2002:a37:5586:0:b0:6fa:39c4:2ca9 with SMTP id
 j128-20020a375586000000b006fa39c42ca9mr10011526qkb.247.1667407399321; 
 Wed, 02 Nov 2022 09:43:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4/rvQXdCAyIe0HFz95uUEGgTNvP6HVoipjnQ1WNKjj3y50tjMcIRaYfVVUhCu1DT+83sBt5A==
X-Received: by 2002:a37:5586:0:b0:6fa:39c4:2ca9 with SMTP id
 j128-20020a375586000000b006fa39c42ca9mr10011503qkb.247.1667407399083; 
 Wed, 02 Nov 2022 09:43:19 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 f16-20020ac80690000000b0035ce8965045sm6757917qth.42.2022.11.02.09.43.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Nov 2022 09:43:18 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:43:16 -0400
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2KeJGYUxnOOcXMj@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com> <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org> <Y2KZdDAQN4889W9V@x1n>
 <Y2Kby0yXu0/Zi2P1@google.com>
MIME-Version: 1.0
In-Reply-To: <Y2Kby0yXu0/Zi2P1@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: shuah@kernel.org, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, catalin.marinas@arm.com,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Wed, Nov 02, 2022 at 04:33:15PM +0000, Sean Christopherson wrote:
> On Wed, Nov 02, 2022, Peter Xu wrote:
> > Might be slightly off-topic: I didn't quickly spot how do we guarantee two
> > threads doing KVM_RUN ioctl on the same vcpu fd concurrently.  I know
> > that's insane and could have corrupted things, but I just want to make sure
> > e.g. even a malicious guest app won't be able to trigger host warnings.
> 
> kvm_vcpu_ioctl() takes the vCPU's mutex:
> 
> static long kvm_vcpu_ioctl(struct file *filp,
> 			   unsigned int ioctl, unsigned long arg)
> {
> 	...
> 
> 	/*
> 	 * Some architectures have vcpu ioctls that are asynchronous to vcpu
> 	 * execution; mutex_lock() would break them.
> 	 */
> 	r = kvm_arch_vcpu_async_ioctl(filp, ioctl, arg);
> 	if (r != -ENOIOCTLCMD)
> 		return r;
> 
> 	if (mutex_lock_killable(&vcpu->mutex))
> 		return -EINTR;
> 	switch (ioctl) {
> 	case KVM_RUN: {

Ah, makes sense, thanks!

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
