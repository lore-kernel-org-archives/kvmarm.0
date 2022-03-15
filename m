Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E182C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 07:40:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 069E149EF4;
	Tue, 15 Mar 2022 03:40:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xwcO6jghd8qQ; Tue, 15 Mar 2022 03:40:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAB2C49EF6;
	Tue, 15 Mar 2022 03:40:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FCEB49EE9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 03:40:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sKNwCZH6rzHS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 03:40:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 677C549EBD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 03:40:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647330019;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=uq0Z2NOXqlkVrEm1qJusGexqNZk1tmem0xILqLvczWc=;
 b=bEc5y5E3aits1uieVz6uBakFChAcX2aHgN2XgeLadoGRePmOZq55IdTaScaPu7gzgtPvm8
 GER/JeWNpeQc3B5sJOu1mysFBRylz2tZRQfNqtsJBA+PlamlGRfGOjF7Qfk1AFXx9Xofdx
 ii7mtp8sxNr28udGFzJUAU2MUZt/DXs=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-VKAjldnnOR2Tj2JzXAlR5g-1; Tue, 15 Mar 2022 03:40:15 -0400
X-MC-Unique: VKAjldnnOR2Tj2JzXAlR5g-1
Received: by mail-pj1-f70.google.com with SMTP id
 mt1-20020a17090b230100b001beef010919so1423413pjb.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 00:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uq0Z2NOXqlkVrEm1qJusGexqNZk1tmem0xILqLvczWc=;
 b=ZRXae0/VraYjRQuG8KYr5H61Av93Jl/uPJFmomZiCkqOUV9AWmFRg+ujVlqZrUCUY9
 3uDTnV9YhkaGGzi8VpvHqL1eu6IwgZNG6LKmMwnfdhYDzGzM6AgwCoKTrUJsLTAhY8S2
 KarjC5LpcVnu1Ss+WYgThm81as6d06TH1zHEy6jgmfpYHiJGu5LmHnP6lGQVR3dziuQU
 yf88gQpBVlIaF4UWZCy9vddUGJ6BTgN5I8zF6DSYEJUsBs6tsujZ0QaA1nwOCL5bFrhE
 d4p4a26hsfP/PGd8Z6M8zvJX8+VOFECeicmSP1t1m2EW+W2hGny7uHQbeCV2ggGIIkzb
 gELA==
X-Gm-Message-State: AOAM533pWT/e8BZhbwKIypW2dCiy/JbvmB1Bjr76oaX3Ue21pTatWsYW
 mrrnrMUg9/JDLsQQRl/EyQKaVqN0Vt5MdVcwH4ndJbLsrMbj0BQ33EVQyCGYksY7ANfXu9jMMo+
 p2zOI5Zh4aWGClmkb9P6ghvzt
X-Received: by 2002:a63:4543:0:b0:374:87b6:c9f5 with SMTP id
 u3-20020a634543000000b0037487b6c9f5mr23348164pgk.302.1647330014628; 
 Tue, 15 Mar 2022 00:40:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztMHMNYKIpNAuJc8FteBiELgu/J7bC35KETwQh5TE/MrV9Kwi39pAoHxQ4fUsa/R32a5KHkg==
X-Received: by 2002:a63:4543:0:b0:374:87b6:c9f5 with SMTP id
 u3-20020a634543000000b0037487b6c9f5mr23348131pgk.302.1647330014348; 
 Tue, 15 Mar 2022 00:40:14 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 c7-20020aa78e07000000b004f6e4d8ccc8sm22380450pfr.163.2022.03.15.00.40.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 00:40:14 -0700 (PDT)
Date: Tue, 15 Mar 2022 15:40:05 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 01/26] KVM: x86/mmu: Optimize MMU page cache lookup
 for all direct SPs
Message-ID: <YjBC1ZLio2iPkZ0V@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-2-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-2-dmatlack@google.com>
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

On Fri, Mar 11, 2022 at 12:25:03AM +0000, David Matlack wrote:
> Commit fb58a9c345f6 ("KVM: x86/mmu: Optimize MMU page cache lookup for
> fully direct MMUs") skipped the unsync checks and write flood clearing
> for full direct MMUs. We can extend this further and skip the checks for
> all direct shadow pages. Direct shadow pages are never marked unsynced
> or have a non-zero write-flooding count.

Nit: IMHO it's better to spell out the exact functional change, IIUC those
are the direct mapped SPs where guest uses huge pages but host uses only
small pages for the shadowing?

> 
> Checking sp->role.direct alos generates better code than checking
> direct_map because, due to register pressure, direct_map has to get
> shoved onto the stack and then pulled back off.
> 
> No functional change intended.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
