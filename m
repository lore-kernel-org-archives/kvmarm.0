Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4559AC43334
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 15:30:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAEB44B249;
	Fri, 17 Jun 2022 11:30:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F1ZG7H3aARLr; Fri, 17 Jun 2022 11:30:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA1C4B338;
	Fri, 17 Jun 2022 11:30:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEA9C4B26D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 11:30:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gCG8-5vbW4yj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 11:30:50 -0400 (EDT)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9E404B249
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 11:30:50 -0400 (EDT)
Received: by mail-pl1-f180.google.com with SMTP id o6so4177867plg.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 08:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=JX9xGdiptLoNDTC4kLICm3LWkZE4wnBomWiv9D2Jt+A=;
 b=FroTbfKQXF4oe57u8/z01s4H2lPuFDNHQSRgJovvAXDxEMhjV6urKT0B8sHR2d8L3n
 ae5hlfF9DTvZ3c4JoenCBYAcFC4Cg8LCcOK2JrDuN6oUMXhIoi9o/mdMIV451aYKFaHM
 hsdOfB+Hs+/CcS7myUfGVKpDlXbB3fjN6geQn+KJQKA17rR8Sm9IHtsMFgdomwiKqeEC
 T71kaL/J/sl8yWloLQdFRdTBTWZOAvcg6ooTQr6dWni9zBgS6eSDRk96BL8uwMhSgZPi
 PQtlmqwUfOUCyJu9V8Rp++e8ZGmSuy0PGyvVrA380adh0l3CDL5Obk4WtrHI/VRK72em
 XaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JX9xGdiptLoNDTC4kLICm3LWkZE4wnBomWiv9D2Jt+A=;
 b=O5SRK6kkBaMjOys87ZxZWdI+6U8LGmaLqKfkdJxLfSYcOVDikG2zjJ2mRctk1bkpE8
 ppeJSIiKAO6wlbKl3nVAtvOeKbmpNiKSxoJtrQTfTo0egQUAjDNna6DpPWOeyEoTp9bQ
 gZfRKqJF+Rk5B13qZrD+FPi17P6G7y8lx2GKpxUdor3HDMGuSeYbnZ+as4M9T8tV4zUL
 1VPGqdpvzakLLU0j4cah/4+BSMGWZDdWqQggFTtfJO+61kkZogzIDQgYZRSLQWW5WFVl
 ov7kAsd5l0mdyjG5F/XGXLaMggYU21PtV91U1GwJBany8Xl9RKKYT1B/3r6CSXAPOVyP
 xMgg==
X-Gm-Message-State: AJIora8N2x9AS/WlnKsDXj8t8VpBNSTXfK1BtrRw4/KEp+xxuq1Xi7qZ
 bJqoaqOGge5aUQbcXFnnj73wwQ==
X-Google-Smtp-Source: AGRyM1sShni0HcA+wwvElgEG+uhqDvpiuI/Mbz6fR5xrdxpUTVbxDXYkPyaLGZqxKkWHjKOvWmjOaA==
X-Received: by 2002:a17:903:2ca:b0:156:f1cc:7cb6 with SMTP id
 s10-20020a17090302ca00b00156f1cc7cb6mr10651437plk.174.1655479849528; 
 Fri, 17 Jun 2022 08:30:49 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 o4-20020a1709026b0400b00163de9e9342sm3758558plk.17.2022.06.17.08.30.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 08:30:48 -0700 (PDT)
Date: Fri, 17 Jun 2022 15:30:44 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 14/22] KVM: x86/mmu: Pass const memslot to rmap_add()
Message-ID: <YqyeJKMcqkO5zynw@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-15-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-15-dmatlack@google.com>
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

Please restate the shortlog in the changelog, it doesn't require much more typing
and means readers don't have to mentally preserve context across "paragraphs".

  Constify rmap_add()'s @slot parameter, the is just passed on to
  gfn_to_rmap(), which takes a const memslot.

> rmap_add() only uses the slot to call gfn_to_rmap() which takes a const
> memslot.
> 
> No functional change intended.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
