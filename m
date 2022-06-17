Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18B5C43334
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 16:56:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E1904B335;
	Fri, 17 Jun 2022 12:56:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JzHKQTrD2XuL; Fri, 17 Jun 2022 12:56:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01F4C49E44;
	Fri, 17 Jun 2022 12:56:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0980949E39
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 12:56:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YTpc6K3azLs2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 12:56:16 -0400 (EDT)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
 [209.85.215.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93B8D49E08
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 12:56:16 -0400 (EDT)
Received: by mail-pg1-f176.google.com with SMTP id g186so4536205pgc.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 09:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=EArAgQNHoiHIS8I/ZApL03IuPB6zV8pnr3Tul9Qb4MA=;
 b=b05d1gKW6mYhXbruL2fyLtjmEA1GqVi1lTwTxPVkPVLuTfSdqq5m9T6gsUerOispOz
 GncQw5oSnE33n7yZ9QdMGjb2zBcmU5qp4sqQGYqEyrArd+dm12PIp9tNBw+pY11Bpsho
 VRmYa4FU94LtWTzGBUd/U1q4SvyhZ4VWiiGsORsiaolgKg34GXKRfBNZjiHHFnVq+zBr
 L3v4eiOGcP5LMru62F+f9fycIx+VXfh9t3Rp2HTfrLLgH8WmDRzgqspCo0KZMRTHS1h3
 QxZOOOz58CWG8UNyOazZDWZOUViiQPoOF7HnyBzDtgvtWAIeo8EufclXiIelAwlueBNS
 17fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=EArAgQNHoiHIS8I/ZApL03IuPB6zV8pnr3Tul9Qb4MA=;
 b=C8yG0UziLGg6Vj/Pcwb5AzH4xs45mXRSqUkSjEPRUUTX6qT9YHqg6VqUReSpRg6Ksf
 /qO4jy9QziXN1bcUiw/8uLngohUJ8BaNJh4agQ98mNHPEiYK1RGzLM4ErBmNJfh/dTaW
 fNAv7FZ1F2xdh2atzHvEkrI4sWp2fo+5oSlaOtM0eXwehegD5TQN0GMcixkHte/LY3g1
 UIlZVRXFpk0M71JXgRrFJg/UFC+lSn60O5BOZO63n5V1mdjs505mforKCjCs7Zmu/fU7
 DAU8ekuCgjAItToXzNCO+oBPOHRtyyYO9HQAP2gl8RzAtjnK31ffKmHli7DavrQAFKeS
 v6cw==
X-Gm-Message-State: AJIora9qeQyq78zepERDBXzYUvF+B6aX2mpJpujOW/bXLACJn0TvpFu6
 Gkt9LMmS5HTh9/YEjh2q4Lh/PQ==
X-Google-Smtp-Source: AGRyM1szxMq8pcE45URHtBmbN5333qjIc6FM+zGUcOUachog0Av+tjeuGo1MIwJ5XrnGY8xO/l76lg==
X-Received: by 2002:a63:89c1:0:b0:3fc:6001:e871 with SMTP id
 v184-20020a6389c1000000b003fc6001e871mr10020666pgd.14.1655484975342; 
 Fri, 17 Jun 2022 09:56:15 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 b14-20020a17090a8c8e00b001eab4b8383csm5776963pjo.5.2022.06.17.09.56.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 09:56:14 -0700 (PDT)
Date: Fri, 17 Jun 2022 16:56:11 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 18/22] KVM: x86/mmu: Extend
 make_huge_page_split_spte() for the shadow MMU
Message-ID: <YqyyK5C1PaByJur2@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-19-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-19-dmatlack@google.com>
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
> Currently make_huge_page_split_spte() assumes execute permissions can be
> granted to any 4K SPTE when splitting huge pages. This is true for the
> TDP MMU but is not necessarily true for the shadow MMU, since KVM may be
> shadowing a non-executable huge page.
> 
> To fix this, pass in the role of the child shadow page where the huge
> page will be split and derive the execution permission from that.  This
> is correct because huge pages are always split with direct shadow page
> and thus the shadow page role contains the correct access permissions.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
