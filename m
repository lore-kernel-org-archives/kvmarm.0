Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CB0C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 16:40:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 316454B37F;
	Fri, 17 Jun 2022 12:40:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bBKClX2ZHzAf; Fri, 17 Jun 2022 12:40:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F5AE4B2B1;
	Fri, 17 Jun 2022 12:40:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B94654B2A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 12:40:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cicllvNihIYj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 12:40:19 -0400 (EDT)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6C234B1CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 12:40:19 -0400 (EDT)
Received: by mail-pf1-f171.google.com with SMTP id w21so4647789pfc.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 09:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=eG0CUva5Aq4SOJEaRyyUrYQ3pgRfX3tijfJSsmDkrlo=;
 b=oql6iRN5/gsSfty7rLXaF9XMuzqGGVuYoACTvV+VTUpudAPb8cZsJrRZQOeEIE8n3B
 qQPvIY0a/b5OEPVGOHKYQL3vtMzHhYLNXOPDZjcRqgZzQnvBpfIgIZ/BtglNaRKE+CWj
 cRDO3Xdi35/Hu9QW1BoxHcIXhiWBJvgRmf1fDxQ0GHX94C2a9Ryti64UwgoQjugmu/Uh
 hmxSmuyIaTYUZuKWz5E6SsIeUcLynKcxq59V2r9IIUYYHkQFegz14jt6ABrsACO16H/O
 Az4ZJHSIMxPutm+fa28G8gV7xCut2++vxVuZO9229EUe8uknNCZeJvpUHYrW9xNM/fGV
 1REQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=eG0CUva5Aq4SOJEaRyyUrYQ3pgRfX3tijfJSsmDkrlo=;
 b=4L32Mi5PnPNvSF1MZchvZsJlfASFvRpw23wqontEPmk0ovwvUnhGEWFpY4Gs9rOE4+
 VJVINAq0+0PMUI6pURWJoG2ZJ+d3SIuxCgbNtSvQIWMUyiVq0FGFGK3WJigm8n6hVoDH
 qWd0Z+fs3xxx48o0EiKH6+ev2R4ALEQGcsePR3d+0f3dm14hn9Yod9EYh3G4uUAz54Bj
 aAd1++4d7fb3LSB4HLwMuCBbgN6j2xkK52O4lDe7APuB9eCKQVBFYt1EI+5Jhf/r4i+i
 8UVCiQT1bkfmnTR6JyPm7Dfg/BwTNKnfE6t5HTTHTF25Id8kREDdtWzc6krzdVLOklvc
 VN7w==
X-Gm-Message-State: AJIora96fvIAYvqb5n0yiv+akBtTohMZVB8ejQvwTsdjvmuB0thhRSX+
 76gw7A3EmA0Khg1u29CBYT6tQg==
X-Google-Smtp-Source: AGRyM1vkErVIo60E1+xRn2pCYtk39EnT3UcKBOjotLOLSMAz1iO59Xe+kUiU++BGXT85af7uxf+tVw==
X-Received: by 2002:a63:7d42:0:b0:40c:570d:f736 with SMTP id
 m2-20020a637d42000000b0040c570df736mr2986595pgn.306.1655484018570; 
 Fri, 17 Jun 2022 09:40:18 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 e10-20020a17090301ca00b0016796cdd802sm3948290plh.19.2022.06.17.09.40.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 09:40:18 -0700 (PDT)
Date: Fri, 17 Jun 2022 16:40:14 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 16/22] KVM: x86/mmu: Update page stats in __rmap_add()
Message-ID: <YqyubojzB7zeHag6@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-17-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-17-dmatlack@google.com>
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
> Update the page stats in __rmap_add() rather than at the call site. This
> will avoid having to manually update page stats when splitting huge
> pages in a subsequent commit.
> 
> No functional change intended.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
