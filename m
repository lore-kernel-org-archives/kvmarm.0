Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2895EC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 22:24:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 862924B1F2;
	Fri,  8 Apr 2022 18:24:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rnGagH+bioKd; Fri,  8 Apr 2022 18:24:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 719734B0ED;
	Fri,  8 Apr 2022 18:24:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77D6A4B188
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 18:24:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hoGmBu9z-VYO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 18:24:46 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73FDF4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 18:24:46 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id n18so9085735plg.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 15:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=/0FksbS1i7ulxMgGYnF6XiHnLWr7ePceIKuisSyo3Ak=;
 b=OEoUPnC5gNQ3dhRmcc481lEfIBc3oIHx3BTjx1mF0xUd4isjeAeBuO3yysBDUBMrK8
 dTvP/x7d6j/DoOPUazsnvnDi+PwCdZuGldjDFA+eU979RSibIgLLG3iTfKcOD58cc0It
 3af+Z4MPDsw58f45GNHtcALgC/iQGujdGSnJx/ladRiDrgpuQMaQWsEH7F7OOjo2Weoh
 1UYqX4zwgUnwR81X+fQpnPnTCvih90oBVeXXqSMfSAogPwl5PRW7czLmhc2VeSv8w8J5
 J1rxN75Dh8UCbkyLODBrUAFVFABUgTW7DSX56Ea8uPnLfRL7rK1QX4IpYaPLVRfkeCAc
 ruAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/0FksbS1i7ulxMgGYnF6XiHnLWr7ePceIKuisSyo3Ak=;
 b=0pkxAzsgDNivB3SPhWYtzfWEuVJmEGy+VOg4FSEYhUZ98p/vbS5JcQJyQFUL3Y3h1s
 mDzeSDf8/l8Bj1HU/pLiYzpMp9Y6emgkQcizqOdRQUl3Ei9Z/xXCzW0YgLukiCYD4SSs
 xZQCMUnJcx4aSyLc1+Ro+nFpkH04tOxr9xBzAluomB3FWAYHD5vRnpgP/oJo2jgh7bkf
 YAHG9Txt6DytOCUtf1SOZaGimUEPFB/PDyCUlwGNrA2CCl2fAsFYAQsYsnU1oVhG+gqv
 gqtjZrAm7MIQfL+JUYIhSuMj4sWwkwBIU57c4B9ceBe21V45rCcTrTP0Ynda8jxbKhug
 VAYA==
X-Gm-Message-State: AOAM530iC4MwGuVu0MGjssrbjgaB4zghZBJ2lJNwx3feI4wknByxXXvN
 ngw+9gjSAh8jKbx4XhsjnMXFaw==
X-Google-Smtp-Source: ABdhPJwZBIW4lzlXQsJiyPSV2mQuxg0MIyAyU81/+QDN4UuufbXwKD6BQfMpbFASsMasdDZht/coCA==
X-Received: by 2002:a17:90b:17ca:b0:1c7:3010:5901 with SMTP id
 me10-20020a17090b17ca00b001c730105901mr24593680pjb.22.1649456685288; 
 Fri, 08 Apr 2022 15:24:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 f6-20020a056a00238600b004fae79a3cbfsm28710274pfc.100.2022.04.08.15.24.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 08 Apr 2022 15:24:44 -0700 (PDT)
Date: Fri, 8 Apr 2022 22:24:40 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 02/23] KVM: x86/mmu: Use a bool for direct
Message-ID: <YlC2KMSltDRxCi06@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <20220401175554.1931568-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220401175554.1931568-3-dmatlack@google.com>
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

On Fri, Apr 01, 2022, David Matlack wrote:
> The parameter "direct" can either be true or false, and all of the
> callers pass in a bool variable or true/false literal, so just use the
> type bool.
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
