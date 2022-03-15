Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25D1C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 10:39:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DAB649EBF;
	Tue, 15 Mar 2022 06:39:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RIosuJf9bkA7; Tue, 15 Mar 2022 06:39:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FD7249DF6;
	Tue, 15 Mar 2022 06:39:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E257411C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:39:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 77+dU9uDvJ9f for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 06:39:23 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE95140C0A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 06:39:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647340763;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=kJDd/9JiDZbTHZohyZFbEtBTCygNnRdmmrmfy8MFg0M=;
 b=SNrc0B7LfQET7HJElrLhlhklWn3/m126GaZV1xU2K1WinqUGy2QgUbrj2rYoqtg86TzXjW
 YFjOGiSXRwwpw1YAJS2cdJh79LrXai3wFKUZ3HFlB6KAVbx1lM1MJNPBQTKwnl+GYKVrqK
 rEPPDitgjWmsZbmERBL0Bo1YH+iqWYA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-z233ocm2MoS_28CLB-azJQ-1; Tue, 15 Mar 2022 06:39:22 -0400
X-MC-Unique: z233ocm2MoS_28CLB-azJQ-1
Received: by mail-pj1-f69.google.com with SMTP id
 p15-20020a17090a748f00b001bf3ba2ae95so12248031pjk.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 03:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=kJDd/9JiDZbTHZohyZFbEtBTCygNnRdmmrmfy8MFg0M=;
 b=TNlpS/n4cEsBdF3ebzNCWeN3F4ScbV6+ICysEpxL5xpFglhBaD0N+spbwqEb2XshHT
 OOqKpQP2BC9zenF+QuKRVP2TIH+Euo2RzN3RyffPZghDU8N3u/ei+ccJiiZBGhHgEwG9
 q6kojnH6dsvpic8sZIRYsCgcMY6Q3Uweh1ew3metT1neWTTlikhKPiexcJkIb+gUmcpD
 6mVNj6Kj6wGXXNcwqaru1ffs9RjA9Qrx5b18RBfY5WllnMwe4s4n5fGR3YMOWqDbiGTW
 ujy2CSVCsUeRZ+hSvPEJbKgT/FvlZMs94NVU85YiesmqqRcspO+zgRHPLst/orxg6Fdj
 dgLg==
X-Gm-Message-State: AOAM532xSl34iXZ/NhqIW8DenS79o9yi26VAiNeTT2KHr8SGMU4Ve7jG
 gJyUV0Hn9qW3xHaasLD+/y8LgFSVg1l0/geeiuNNBP65kLoUMPXbGmOtCi1FHFGXn0d5Xz+QyHt
 MnZqp5BrHoev8yJRfCgFGPQEe
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id
 l15-20020a056a00140f00b004e069959c48mr27468850pfu.59.1647340761004; 
 Tue, 15 Mar 2022 03:39:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSfNOcUi9xy2ekJmnOxedBPrTrKX0N/yrTIaL/Gy94SQN4Gb5kFP9OF6Ce9WSip5I+m8Q7zA==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id
 l15-20020a056a00140f00b004e069959c48mr27468818pfu.59.1647340760732; 
 Tue, 15 Mar 2022 03:39:20 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 q2-20020a056a00150200b004f8d80ced3csm4351131pfu.40.2022.03.15.03.39.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 03:39:20 -0700 (PDT)
Date: Tue, 15 Mar 2022 18:39:11 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 15/26] KVM: x86/mmu: Update page stats in __rmap_add()
Message-ID: <YjBsz/V7FLsNkNh3@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-16-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-16-dmatlack@google.com>
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

On Fri, Mar 11, 2022 at 12:25:17AM +0000, David Matlack wrote:
> Update the page stats in __rmap_add() rather than at the call site. This
> will avoid having to manually update page stats when splitting huge
> pages in a subsequent commit.
> 
> No functional change intended.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
