Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FACC07E9D
	for <kvmarm@archiver.kernel.org>; Fri, 23 Sep 2022 22:46:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A60F411BD;
	Fri, 23 Sep 2022 18:46:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tR4kCCaRUrw6; Fri, 23 Sep 2022 18:46:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE81740E25;
	Fri, 23 Sep 2022 18:46:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7C340BA3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 18:46:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6b2ryHtWl-Xe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2022 18:46:44 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7DD740B91
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 18:46:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663973204;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=TbpJrmGSZ/Fcv2wT55HywsC5o8heQwVobd1UKBeGb7k=;
 b=Jkl3/yo65ghvkfIX/VNCxxFV+ztbk+xiPle2jmk7ao1VZJzXi1ZK+EErwptM+cPKY8umkZ
 sZMIDcTb6SYuUIJzH9D9rGRkQNPecZfELczHd9rFQGL1pMLs7J6IY6IsFKn4Iv2/QZhhed
 VDE636F25U8OI3ea7pUBoqAaApIKTwk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-37-ELjViRh-O3uGtuxk8rFuBQ-1; Fri, 23 Sep 2022 18:46:43 -0400
X-MC-Unique: ELjViRh-O3uGtuxk8rFuBQ-1
Received: by mail-qv1-f72.google.com with SMTP id
 f9-20020ad442c9000000b004ac7f4fde18so804873qvr.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 15:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=TbpJrmGSZ/Fcv2wT55HywsC5o8heQwVobd1UKBeGb7k=;
 b=BTWyVwkqdoi00Js03e5hMZzBuuSMkp98jfk5+2s0tWlBC70AyuxksSpdrQd5qTQcbz
 8hzEaQBGR3C8dYp/4bEDnDKWkMTMP5rsVv/ZmR069JEK89IJ4mz5VizZyBidzEfI92oQ
 WFzrQr+aOMAR7QF+4lyH235YxD3Ixtx1Co8wIUsFv4tYxjTk8SrmJmhOiOTAt7cdFLSK
 6kteFG7LQRrTspRxgoCJy5CAPHLPT8Vbjhfcu1FNnzEh9qa6cRVsmJbguwuBQCD51Q54
 RlRiGWQ9KFURqBFfOXsoCet18Bof1Gklr0IkmUyCU0mPTolHf+ZYOF263qqdrb+ekND3
 ztvg==
X-Gm-Message-State: ACrzQf27qILdufgQk44VqBHC+J6MvOgXAx70kO3nGnH2PzSBvMLGfYqM
 KwxHras+IrVRoTqrjt0idSZw3gY++JYEyCZJqAYDmAlmYySRVdXQgrHdZuThyaFTzz5LVR+Fo70
 Wi3ocQ6SAABIzJwJxusFx8TaK
X-Received: by 2002:a0c:a951:0:b0:4a2:acf0:1554 with SMTP id
 z17-20020a0ca951000000b004a2acf01554mr8702030qva.115.1663973202842; 
 Fri, 23 Sep 2022 15:46:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4knnqsS3j7k/xo7xq7uc5YnqAb2QAyUrPOQPVgzzeIt5MtETEWirytZ1XgcutqajbAvYbzng==
X-Received: by 2002:a0c:a951:0:b0:4a2:acf0:1554 with SMTP id
 z17-20020a0ca951000000b004a2acf01554mr8702015qva.115.1663973202687; 
 Fri, 23 Sep 2022 15:46:42 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 bp30-20020a05620a459e00b006c479acd82fsm7643222qkb.7.2022.09.23.15.46.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 23 Sep 2022 15:46:42 -0700 (PDT)
Date: Fri, 23 Sep 2022 18:46:40 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/6] KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ORDERED
Message-ID: <Yy43UM/+qTxc+/qt@x1n>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-4-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220922170133.2617189-4-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 22, 2022 at 06:01:30PM +0100, Marc Zyngier wrote:
> Since x86 is TSO (give or take), allow it to advertise the new
> ORDERED version of the dirty ring capability. No other change is
> required for it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/x86/kvm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index e3cbd7706136..eb63bc31ed1d 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -29,6 +29,7 @@ config KVM
>  	select HAVE_KVM_PFNCACHE
>  	select HAVE_KVM_IRQFD
>  	select HAVE_KVM_DIRTY_RING
> +	select HAVE_KVM_DIRTY_RING_ORDERED
>  	select IRQ_BYPASS_MANAGER
>  	select HAVE_KVM_IRQ_BYPASS
>  	select HAVE_KVM_IRQ_ROUTING

Before patch 2-3, we only have HAVE_KVM_DIRTY_RING.

After that, we'll have:

HAVE_KVM_DIRTY_LOG
HAVE_KVM_DIRTY_RING
HAVE_KVM_DIRTY_RING_ORDERED

I'm wondering whether we can just keep using the old HAVE_KVM_DIRTY_RING,
but just declare a new KVM_CAP_DIRTY_LOG_RING_ORDERED only after all memory
barrier patches merged (after patch 1).

IIUC it's a matter of whether any of the arch would like to support
!ORDERED version of dirty ring at all, but then IIUC we'll need to have the
memory barriers conditional too or not sure how it'll help.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
