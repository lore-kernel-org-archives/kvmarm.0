Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF1DC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 10:18:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A160C4291D;
	Tue, 15 Mar 2022 06:18:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pdx8yIe1YhrR; Tue, 15 Mar 2022 06:18:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51A0D49EFC;
	Tue, 15 Mar 2022 06:18:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C1A24291D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:18:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5DlyiuMEoNKu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 06:18:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1057340C2B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:18:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647339489;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=8aKmgpWQOn5fy2pFZJV3AASa7qkUAzElx68DLyF1Rv8=;
 b=Lq8k79MTF2uZ86Ebz0XuG1CLRjf3gDwxvAv9nQWA9h6+0DMJljbStHqf/39kxvUwIYaiZt
 53uyk2VQlNV2T9U0QsTjuKqe1RxhOJ8g+Kn4VUMLlT49JFeiKTadDPsmAE/FWcbDzVJZa3
 c2a6Z6RyE/hvOzIS+H+cmMV8vh1z7VA=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-cQ_a0xELOE217CJchaUu4Q-1; Tue, 15 Mar 2022 06:18:06 -0400
X-MC-Unique: cQ_a0xELOE217CJchaUu4Q-1
Received: by mail-pf1-f197.google.com with SMTP id
 67-20020a621446000000b004f739ef52f1so11582168pfu.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 03:18:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8aKmgpWQOn5fy2pFZJV3AASa7qkUAzElx68DLyF1Rv8=;
 b=kfcPDfUanNIY0SMOA3eAOQvTj571pKQRPeN/8YP4xNc5BD0NO1erHrXX/D5hSTCYdr
 +K5vZUvbqLcdi4p9nvPGx6I6PvAhVj3XC4JK4hw/uOsBk8ncL1sGAsTspTGpzwU2u1wO
 gsf3SD6XmBxZ6AdJpHJMbQQMU7tH3eiBKoDmZGbCJG/FTbEVR2eq9nBt4egQGMLbnzHM
 zmjAkKubCTix32k6mkcVVJTo+uBWHIWJyRT+cRkXw/KK4dxa2qbQCbAwD0JrBSaaQM+C
 bO44J57KwNAmeVY2YqEIeywM0QE6XdIgEZNZF3D2mX4F7+x4+PwX/+nNzXCfgCBpbWXd
 DGjQ==
X-Gm-Message-State: AOAM532vz9YzUjrgSB4sEzkySuiPkqYXomPAHIv/yZ75XckSOe4Y3VC8
 ljELv2mWLMqA+yfmfwX5/nXakfpP7ZZD9Gebs5UT2UdXalXUE+Ii5UKxYj2+7f8OZ/YswDEFTu+
 jb/cpczuv8LgtV0Z0AABqKqB3
X-Received: by 2002:a62:7b55:0:b0:4f6:adc7:c306 with SMTP id
 w82-20020a627b55000000b004f6adc7c306mr27924613pfc.29.1647339485568; 
 Tue, 15 Mar 2022 03:18:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+jS23UzOASPRoyKYjAv3PS8/jYIxosAR15TYCR7wHvt7VgBXKlwPyxZv5RL8fbxTjQ3li9A==
X-Received: by 2002:a62:7b55:0:b0:4f6:adc7:c306 with SMTP id
 w82-20020a627b55000000b004f6adc7c306mr27924572pfc.29.1647339485245; 
 Tue, 15 Mar 2022 03:18:05 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 u5-20020a056a00158500b004f745148736sm25052836pfk.179.2022.03.15.03.17.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 03:18:04 -0700 (PDT)
Date: Tue, 15 Mar 2022 18:17:55 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 09/26] KVM: x86/mmu: Move huge page split sp
 allocation code to mmu.c
Message-ID: <YjBn0w54kLk1eDT/@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-10-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-10-dmatlack@google.com>
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

On Fri, Mar 11, 2022 at 12:25:11AM +0000, David Matlack wrote:
> Move the code that allocates a new shadow page for splitting huge pages
> into mmu.c. Currently this code is only used by the TDP MMU but it will
> be reused in subsequent commits to also split huge pages mapped by the
> shadow MMU.
> 
> While here, also shove the GFP complexity down into the allocation
> function so that it does not have to be duplicated when the shadow MMU
> needs to start allocating SPs for splitting.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
