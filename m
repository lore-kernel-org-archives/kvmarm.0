Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62673C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 16:33:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4B674B975;
	Wed,  2 Nov 2022 12:33:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cn9m0NmQTAC5; Wed,  2 Nov 2022 12:33:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5E1F4B89A;
	Wed,  2 Nov 2022 12:33:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A9B4B75E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:33:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xhA-3VU57zSk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 12:33:21 -0400 (EDT)
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com
 [209.85.210.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0359D4B731
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:33:20 -0400 (EDT)
Received: by mail-pf1-f178.google.com with SMTP id b29so16846511pfp.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 09:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=bSpvtaO5+biFCdXjgWOU/VG7HbNWLZ5uq+eRXSvuuCM=;
 b=QFzFFdsD02xgwNnv6w/5D3h0dWbBgJ42EmoGbAgWbOReIP7ibvMB1sHHN5oEGVDyK2
 bk3kncpJvgSara7MPPqv92ajq9XrSKjcvnywOsb4pV2qvmxneWfV7ARhIkMOGJwlrz8R
 1Wwd/25n0QydVBeAVmeDEjCCXnRkwe9F3P5rzk+d4bD1ddvkvul8tu19r92ToFUVyoGx
 nlwWSse6N6Jrp3BrkQdIfBw3LZGgL0c72+hR7wt3XtF30HeXkl7FuQ+WbQd2KaROGHaG
 irDvrqhCVigzw0R9bF16EmQWLdUFa8qhbnJy8fQMwqr8Dq2eNuzsKxKGR7dvUWm40Zes
 M5Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=bSpvtaO5+biFCdXjgWOU/VG7HbNWLZ5uq+eRXSvuuCM=;
 b=Cui9iICwm8JtyFkIQ+nO9liS+AQnAuU5WawucoHnsyhYosTE7nx+sObvD/MRve7Yrf
 4yu76HHlJJi9FqoRH0uPdo3bi3S6hfQiLYgvnw3CC6jOEsiAfheK3hb6i0E2Yw/73lJN
 Y/JN+x8+NIc7uUeHu5F8jZs4n7lP6J8dpPljApoheBjyoQd4nx+IEAWmape/VPQEwGVq
 e7ayioPwbrk/oAVXQV56ktDHg/ND0cakZzAj9WAbHTlWrHQqWm5D5z9eu2KCFNo+Oz9K
 d+GZ4XjQp74f2Ddr27VHkyvbUSL6iIqp5QlVRbQzL9uQNw2Dp7RUjm8Vb43C+J6C/Vt3
 7QNQ==
X-Gm-Message-State: ACrzQf1jc2Cadu/4bI7oSwSS0AsAHS+GIbO8oO5DcMB+APdLqn1pOPoE
 V8oruv8A78voX/V68wUqfwXB5g==
X-Google-Smtp-Source: AMsMyM7/IFIrAzLF68OTsZpwvpWxXuJLq80r9JuhA6FJpKg68htFc94IYvOx1OmW0dUzBtPQISiKSQ==
X-Received: by 2002:a63:fc12:0:b0:45f:a6e3:7559 with SMTP id
 j18-20020a63fc12000000b0045fa6e37559mr22400123pgi.237.1667406799666; 
 Wed, 02 Nov 2022 09:33:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 m1-20020a170902db0100b00186a2274382sm8586776plx.76.2022.11.02.09.33.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Nov 2022 09:33:19 -0700 (PDT)
Date: Wed, 2 Nov 2022 16:33:15 +0000
From: Sean Christopherson <seanjc@google.com>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2Kby0yXu0/Zi2P1@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com> <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org> <Y2KZdDAQN4889W9V@x1n>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y2KZdDAQN4889W9V@x1n>
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

On Wed, Nov 02, 2022, Peter Xu wrote:
> Might be slightly off-topic: I didn't quickly spot how do we guarantee two
> threads doing KVM_RUN ioctl on the same vcpu fd concurrently.  I know
> that's insane and could have corrupted things, but I just want to make sure
> e.g. even a malicious guest app won't be able to trigger host warnings.

kvm_vcpu_ioctl() takes the vCPU's mutex:

static long kvm_vcpu_ioctl(struct file *filp,
			   unsigned int ioctl, unsigned long arg)
{
	...

	/*
	 * Some architectures have vcpu ioctls that are asynchronous to vcpu
	 * execution; mutex_lock() would break them.
	 */
	r = kvm_arch_vcpu_async_ioctl(filp, ioctl, arg);
	if (r != -ENOIOCTLCMD)
		return r;

	if (mutex_lock_killable(&vcpu->mutex))
		return -EINTR;
	switch (ioctl) {
	case KVM_RUN: {
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
