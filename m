Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C9CC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 18:47:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B15D4B10B;
	Thu, 16 Jun 2022 14:47:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9kGjiA4tlves; Thu, 16 Jun 2022 14:47:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F26ED4B121;
	Thu, 16 Jun 2022 14:47:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 582054B105
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 14:47:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uvK366ZsgWNN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 14:47:16 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D99E4B103
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 14:47:16 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id
 v11-20020a17090a4ecb00b001e2c5b837ccso2577348pjl.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 11:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uBB/J8bQS3jOMS4YDFQ1IMHL6GxPjjT1BgnhKdTawwA=;
 b=FAFNRwAXbqbs5kPP9MqWhm2jwLweXrkjXqm+QlkTQJ2uCUEcNluny0v21VXymHvoY9
 rqjC6bElkKMBNJY/JsTwEd4qcNvDdRtkC879eelmXJHmH2eKgd492mqxLy13i79gDImW
 DOqBjXdY4Se0V0Sq1AtX+VfzuEtBir5fJ22FJTWtjnzzQpzyEXTxyZ9YXZzrcAInIWbi
 FrxXKOl74i6O13QWYX99Uu+qHZpHdbzInW9krOeJksYSUzEz1tGq+Gxo6jP7dQ/pC155
 tZzAWhFKf1Ioj2w6JE+sro4Ml5Ps0nOdpLOntXF9hpPv4dv1mV57qdM4esraWNZv66up
 8tIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uBB/J8bQS3jOMS4YDFQ1IMHL6GxPjjT1BgnhKdTawwA=;
 b=ldb6m8/hLF+oZ/0746a1B+vICWT/TgLKP8f8sIQauUzCjDEhkLROsWDEI1Y6v1UgY0
 uA95YCqT1f3kaxg56ULnJCuXz5xa1eIPVmN3jDpsvm2q+midNdQgE50D+cEBDpnfmmd7
 AsiHq6ERROICmintaldIywYrq//qjVhCoJi0V3slEM//KL+Am1IuJUMbMgJEwBQqWFBU
 C4rxzMbpLO+Aa4REDrREagcf6QwzOI1Qk/qeWoP/MgiV1Z4rYYFc7VAEnDp2MVjL0Q+M
 6qwokTZlc74VHzp/YNQ33BkujctwWfAtBhAnp/VWTo6IEDapr/V3zVIzN42/zS/iVIuq
 ewpQ==
X-Gm-Message-State: AJIora8TH0dPPUv56JxpAWw0t887vEVr6+Hk+T0ovAPhwxgRnxXklenL
 o/OcrsTGsOHOc3mfpNHDxTFFAg==
X-Google-Smtp-Source: AGRyM1uCJJ2F+oFOq0FLGO6wjzLEHVI9CHwNDtvXiwEJg0G+cL23BDN1LursbHbBFAUeKgpuST6/CA==
X-Received: by 2002:a17:903:11d2:b0:167:8a0f:8d33 with SMTP id
 q18-20020a17090311d200b001678a0f8d33mr5744330plh.95.1655405235081; 
 Thu, 16 Jun 2022 11:47:15 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 v1-20020a62c301000000b0051ba8b742e4sm2117495pfg.69.2022.06.16.11.47.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 11:47:12 -0700 (PDT)
Date: Thu, 16 Jun 2022 18:47:08 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 03/22] KVM: x86/mmu: Stop passing @direct to
 mmu_alloc_root()
Message-ID: <Yqt6rBPMxfwAPjp1@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-4-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
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

On Mon, May 16, 2022, David Matlack wrote:
> The argument @direct is vcpu->arch.mmu->root_role.direct, so just use
> that.

It's worth calling out that, unlike non-root page tables, it's impossible to have
a direct root in an indirect MMU.  I.e. provide a hint as to why there's a need to
pass @direct in the first place.

> Suggested-by: Lai Jiangshan <jiangshanlai@gmail.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
