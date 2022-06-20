Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC354C43334
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 07:34:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 332444B399;
	Mon, 20 Jun 2022 03:34:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HiAOecGPZX9f; Mon, 20 Jun 2022 03:34:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 549D54B396;
	Mon, 20 Jun 2022 03:34:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FE144B38B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 03:34:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uh1Z2iHquiZ7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 03:34:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC0EA4B35E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 03:34:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655710446;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=9O0CIqeEaoJn03vVtSYdv9IsNbaraVCXGcehJj6LilQ=;
 b=TIZZSuksme2W8GZWjGj+sGv2Gu0N+T25x9lc4YbUNywwmN3QyMpXQ9mc6sPMp6TUDPytNs
 5GUKpneTUCkbo9XbFYDi54TC7CBwAZXW8aazaCSyHFpRx1zqlNT+iwxohPiWOVfhgnzogh
 HHk/Q0dOSl7L6Y2nNAFnSaTHQvMKNe0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-7ufGnfp7OJ-Chcu-T0bn9A-1; Mon, 20 Jun 2022 03:34:00 -0400
X-MC-Unique: 7ufGnfp7OJ-Chcu-T0bn9A-1
Received: by mail-wm1-f72.google.com with SMTP id
 o3-20020a05600c510300b0039743540ac7so3064981wms.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 00:34:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9O0CIqeEaoJn03vVtSYdv9IsNbaraVCXGcehJj6LilQ=;
 b=0xgQerZEACICu0H+F0tZ5qQdGRmdkUtmCaVDWyQfQkRLPpcKKtDvJwl1morVtfePVM
 QLm8WbXpyDC+kCgXcTJV+lfPAYvA3RMTliAdu62NbKSPozTfyqhqDl4YpCxycQlXa818
 ZwaIpG0u1TDbjcCVC6z0tudGH7k78lAltmjgCZQK7U6OFHehD8b7Yf+rg8zmRyxUUjMf
 iZ8fB0sOfYU0XbBXyEl0MPPrkmHrcXTgcrUm2az7LzD1z6pvjl9go4+1OEWs4z977xJJ
 b8YZ4QytqRk3YuoOo/OkRppM8yU90jnUe18fV1+f/K8hEhPn2bfr56/TrF0J7fKHRSmw
 G6Pw==
X-Gm-Message-State: AJIora+dPgFLgzL0BDttULEeBAsCzjAJyxcUm69zBZqEev6OcvqmsqBU
 JZjKxq0Fiq80frzN+OgU5HF0cEKuCxJ/P7xIwladWFr2ga0+sTHp2TDO5sOuq6SagX8PUda4XDG
 QQhV/PIXXxOK9r5BWneZaLjeH
X-Received: by 2002:a5d:59ac:0:b0:218:5b7e:1c1c with SMTP id
 p12-20020a5d59ac000000b002185b7e1c1cmr21891431wrr.621.1655710439339; 
 Mon, 20 Jun 2022 00:33:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vkewhJzwIOJ9l+/yqE7pUpzblIRdbrwtFQigT8P4KR1GnlkLPaHlZsigHVgHZi02aADaZXLg==
X-Received: by 2002:a5d:59ac:0:b0:218:5b7e:1c1c with SMTP id
 p12-20020a5d59ac000000b002185b7e1c1cmr21891397wrr.621.1655710439119; 
 Mon, 20 Jun 2022 00:33:59 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
 by smtp.gmail.com with ESMTPSA id
 l9-20020a1c7909000000b0039c96b97359sm14054471wme.37.2022.06.20.00.33.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jun 2022 00:33:58 -0700 (PDT)
Date: Mon, 20 Jun 2022 09:33:56 +0200
From: Andrew Jones <drjones@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 0/3] KVM: selftests: Consolidate ucall code
Message-ID: <20220620073356.fmtsa4ub74igm7me@gator>
References: <20220618001618.1840806-1-seanjc@google.com>
MIME-Version: 1.0
In-Reply-To: <20220618001618.1840806-1-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Atish Patra <atishp@atishpatra.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Colton Lewis <coltonlewis@google.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 kvm-riscv@lists.infradead.org, Paul Walmsley <paul.walmsley@sifive.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-riscv@lists.infradead.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Sat, Jun 18, 2022 at 12:16:15AM +0000, Sean Christopherson wrote:
> Consolidate the code for making and getting ucalls.  All architectures pass
> the ucall struct via memory, so filling and copying the struct is 100%
> generic.  The only per-arch code is sending and receiving the address of
> said struct.
> 
> Tested on x86 and arm, compile tested on s390 and RISC-V.

For the series

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
