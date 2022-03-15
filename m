Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D67C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 08:52:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BE0F49F2C;
	Tue, 15 Mar 2022 04:52:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FjJ8K5HCuAkA; Tue, 15 Mar 2022 04:52:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08FFA49F1E;
	Tue, 15 Mar 2022 04:52:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B77949F19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 04:52:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4zlVgC3jWLhU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 04:52:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 865A449F18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 04:52:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647334338;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=b6x8zrCGUIJGuBD8tXlGdkrTNIYPGin6keX7CqjOiKA=;
 b=hHH/REBz3bN3r6ZMf7fWpnDyYDm5wXx/45N97MHMGzYZazWTbNyIt+fW1dU00DzVFrQnez
 SVP7GMspU7sIa2E9u33dOD3AU5PhdK6rrtiI4LX4jWOT+tOJYSLXCNPGyAC6/D/l7Ago7q
 G5B4Cs4A/3O1Z8yYOwyGOz+ZCpn3UqM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-t49FysWjPtG10VTkboHhew-1; Tue, 15 Mar 2022 04:52:17 -0400
X-MC-Unique: t49FysWjPtG10VTkboHhew-1
Received: by mail-pj1-f72.google.com with SMTP id
 s20-20020a17090ad49400b001bf481fae01so1046546pju.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 01:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=b6x8zrCGUIJGuBD8tXlGdkrTNIYPGin6keX7CqjOiKA=;
 b=mir223K2eCmuTVS651jHcpOrV2CmMFxYDUFvtcO+HREbTN5FvhRx8p1XsmT6atltC1
 5zgz5+K0mJjP8tpRZ44aqWdzu+LnLtamavI69qdIe8faWWonwqCBjUGOl74Mb/cN4BLK
 Yz9WMOeR6S/9+YeAItmn2cSgxbbApezVoaH7fPM5BFjIdZzlbpNaFVcwhVmNnVDslD0h
 jYU5AFGhJ9LUngObLqEyR8qqKUFbHd0J9Mzg/PygCPpsI72Gm5ZVtoxgMa1bwqyecLQ8
 Vsl5zrgSEFvGpfx7bNSVBwq9IMUBw3W7cu4wQwa0e0GIM8/1oAZ8fdgTCt4ovjWmpEMK
 bTiQ==
X-Gm-Message-State: AOAM530o5lZPpPSK8ywo6tOlgrQ5QLaqiGyvHRxzTEz2UN90uFFkm+4c
 QSjXuD3+67Z21bWyNQ2CoWy0xro39lQ9TpRpSKipIgHBcdTKclDqdRgBpJJe8inEKzymHoVClX6
 b2otGkwlkhKB+QPxo5IGr/75z
X-Received: by 2002:a17:90a:a78d:b0:1bc:d11c:ad40 with SMTP id
 f13-20020a17090aa78d00b001bcd11cad40mr3371744pjq.246.1647334336026; 
 Tue, 15 Mar 2022 01:52:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwV18cFMANWpzVlWVPkfvaEbny00jVIEsyxFA/M+p96D3QfDqHts4Eg0Baq2ixkgpFIwtCYvw==
X-Received: by 2002:a17:90a:a78d:b0:1bc:d11c:ad40 with SMTP id
 f13-20020a17090aa78d00b001bcd11cad40mr3371713pjq.246.1647334335782; 
 Tue, 15 Mar 2022 01:52:15 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 m125-20020a628c83000000b004f7baad5c20sm9382162pfd.144.2022.03.15.01.52.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 01:52:15 -0700 (PDT)
Date: Tue, 15 Mar 2022 16:52:07 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 05/26] KVM: x86/mmu: Rename shadow MMU functions that
 deal with shadow pages
Message-ID: <YjBTtz6wo/zQEHCv@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-6-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-6-dmatlack@google.com>
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

On Fri, Mar 11, 2022 at 12:25:07AM +0000, David Matlack wrote:
> Rename 3 functions:
> 
>   kvm_mmu_get_page()   -> kvm_mmu_get_shadow_page()
>   kvm_mmu_alloc_page() -> kvm_mmu_alloc_shadow_page()
>   kvm_mmu_free_page()  -> kvm_mmu_free_shadow_page()
> 
> This change makes it clear that these functions deal with shadow pages
> rather than struct pages. Prefer "shadow_page" over the shorter "sp"
> since these are core routines.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
