Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC23C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 16 Mar 2022 08:54:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDE0749DF6;
	Wed, 16 Mar 2022 04:54:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uq-PwL0kT68h; Wed, 16 Mar 2022 04:54:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0E3349EC4;
	Wed, 16 Mar 2022 04:54:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 879BE49DF6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 04:54:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 36ShkswSnp5J for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 04:54:00 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3117B40B78
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 04:54:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647420839;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=JP3Ykjoa4mUmb5BGwhHBlaqhkdFz67EQLDFR5ioKGxU=;
 b=KCNWv5xdIczLIyOd6kvJwiT4cStigFlgsVNX6NKF+tz/Dmyisz0ePtbaaGoZML4GohbAuy
 yj3XSk6J91JubLbUocHYbSyIdyG/P2rEz9UThgoEFiVAexZ4o5C/pITOSysfE7PTrMOkfz
 ru/h3/HBsmgIIl6uRwMeUUBcDtk1clk=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-jHXoU0TOOMifMW5E9BKgRQ-1; Wed, 16 Mar 2022 04:53:58 -0400
X-MC-Unique: jHXoU0TOOMifMW5E9BKgRQ-1
Received: by mail-pf1-f199.google.com with SMTP id
 t134-20020a62788c000000b004e1367caccaso1443698pfc.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 01:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JP3Ykjoa4mUmb5BGwhHBlaqhkdFz67EQLDFR5ioKGxU=;
 b=OxRGX+3WfAkWTLr/YfvEphrTnzEbr2m08/CdwBxSpwBmb1CfNnwUeUB5yuyexTeIvk
 7GH/WE1kocMRXGAT4TIUCeBqZPs299SEvuENSWLz0Bme/ip1nqNAzSNg7YF7nSVATBZe
 hXa0kyY/UMsav/nbqwvGVAikDYzl4T86PHrXS3C4V+1dkE1yYyTO0zEY7Oe50mUgZg6m
 I2tqyWqPrp+gX3xylNVTT2nL4uOaZkQdOqzHYDdtoa5IBH/MSb4P6tNrJua8ZUV7qiGT
 l+OBzJyVxUagTinywGcEdCqBLZr1toP0GYLQs16f3N5z2tlSNXQfQs8yvlaY8XKF1+Qe
 8JSQ==
X-Gm-Message-State: AOAM532arwCGQvC/caL0ciBIsY+vZjylTeKKzVTPC15gd5ou2GjpaZ5w
 h34+Lx/juiqyviL+NeBxFfAVZKrM3XvDPDOqPdrnaPisBs941kXJG/GcylrqDJ3sX1hNoPeS1i4
 6Uxu2Zm1JnfvrxZpsbNERa7n9
X-Received: by 2002:a05:6a00:23c5:b0:4f7:878:850f with SMTP id
 g5-20020a056a0023c500b004f70878850fmr32541387pfc.80.1647420837607; 
 Wed, 16 Mar 2022 01:53:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxg+2QPvorb661B5qQOPrFyWOnG5+8eT2vD44dyAewSHPUWuWYJt2MRoEccIaejd2wV4N8cBQ==
X-Received: by 2002:a05:6a00:23c5:b0:4f7:878:850f with SMTP id
 g5-20020a056a0023c500b004f70878850fmr32541378pfc.80.1647420837364; 
 Wed, 16 Mar 2022 01:53:57 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.128])
 by smtp.gmail.com with ESMTPSA id
 q11-20020a056a00084b00b004f73e6c26b8sm2072273pfk.25.2022.03.16.01.53.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Mar 2022 01:53:56 -0700 (PDT)
Date: Wed, 16 Mar 2022 16:53:48 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 19/26] KVM: x86/mmu: Refactor drop_large_spte()
Message-ID: <YjGlnDJeSX/wBH6D@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-20-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-20-dmatlack@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=peterx@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Fri, Mar 11, 2022 at 12:25:21AM +0000, David Matlack wrote:
> drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
> Its helper function, __drop_large_spte(), does the drop without the
> flush.
> 
> In preparation for eager page splitting, which will need to sometimes
> flush when dropping large SPTEs (and sometimes not), push the flushing
> logic down into __drop_large_spte() and add a bool parameter to control
> it.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

The new helpers looks much better indeed..

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
