Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A248CC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 12:05:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06E5C49F18;
	Thu, 10 Feb 2022 07:05:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6MZQGyjQzCEj; Thu, 10 Feb 2022 07:05:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9CE449E42;
	Thu, 10 Feb 2022 07:05:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DB9340FAA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Feb 2022 14:52:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k3lt71vTnKJj for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Feb 2022 14:52:49 -0500 (EST)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11D1A4045D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Feb 2022 14:52:49 -0500 (EST)
Received: by mail-pf1-f171.google.com with SMTP id x15so3700456pfr.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Feb 2022 11:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=nFEbKA8UOj2F0aYmafhYdx9MoDnLhZL6FzGdA3foG6Y=;
 b=kMS+/VC4xCdhdLklBPMZrl1DDgsPdemkNlQ+9xJdsF7MXhYOau3XWTVe4FOrwEqNCE
 AtJl33LpEFo6tfuoyyjy0zXo24YUgl2rkRpZDMF8C8XU1aeb1hng1SUX4zjzRKukMAQ9
 27hgmz8ku+LmTHBmD6JLUcxGm2ViDLqKuaJNEonZsgpd0HlXbksTP9GkQqwkK3nofxzk
 9N3WOhuOj7Zmr/5Cp7EeaMz/pprsSKTROefT+5wZO27PB8CVnklUVAkPBIVMBiLCrHCw
 jl9lkCtgzT6We8ITi8RRxUdBU2p3bPtKzg04MIXkdCVNZOh+d/Fln2r4rSPfvBbdqxfm
 cNnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=nFEbKA8UOj2F0aYmafhYdx9MoDnLhZL6FzGdA3foG6Y=;
 b=EzfBCxfKvkEVPyAmkS1VmFo8QbAyZCObTdU5gU4YEVDksXNV3kPH0phE3vdq82TzVf
 hkqrAq3G1HbHyZMpH0cJL8cijjoP6S0Fl5XdRBd0u1Ojj70svNums0KzPig7TlgcfZRx
 nvw96IPBA79RlahbQKasIJxN7sDFHycXCkeaPOF530n2g4ZnnPHegPbeVnOhsQAOjMpZ
 nPdcCefTAfaIeLUdhqfJqirguTLOiDveehe/z/uJ3R9Vqzml86hMP7U4YHGzRrBclh9S
 TqVrRYevSUpUMZFdj0N2hejugecmRCqqeoPJvMCCW8dAJ1Tpsmo3bF+vuYzesY6xdy6j
 hfpA==
X-Gm-Message-State: AOAM533HwujFbzt8SpVDJtYt67EIqBKRto0vu7HiIhB5IE7kt7h9nTlp
 fovuCkBj/NGAfxeiKxoYq9kTCg==
X-Google-Smtp-Source: ABdhPJxEijFR2ADtO2dJpv7+eOnsj3GAeQVvJQZsu/Pn1kY2yGlTgcOn0LgYSwuqCOLhd8P+Pi4JPg==
X-Received: by 2002:a05:6a00:23d0:: with SMTP id
 g16mr3889078pfc.19.1644436367723; 
 Wed, 09 Feb 2022 11:52:47 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id pi9sm7744343pjb.46.2022.02.09.11.52.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 09 Feb 2022 11:52:47 -0800 (PST)
Date: Wed, 9 Feb 2022 19:52:43 +0000
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v3 2/5] Partially revert "KVM: Pass kvm_init()'s opaque
 param to additional arch funcs"
Message-ID: <YgQbi1VcxA5OTo77@google.com>
References: <20220209074109.453116-1-chao.gao@intel.com>
 <20220209074109.453116-3-chao.gao@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220209074109.453116-3-chao.gao@intel.com>
X-Mailman-Approved-At: Thu, 10 Feb 2022 07:05:30 -0500
Cc: x86@kernel.org, Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
 "H. Peter Anvin" <hpa@zytor.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Dave Hansen <dave.hansen@linux.intel.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Ravi Bangoria <ravi.bangoria@linux.ibm.com>, kevin.tian@intel.com,
 Albert Ou <aou@eecs.berkeley.edu>, Vasily Gorbik <gor@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Borislav Petkov <bp@alien8.de>,
 Atish Patra <atishp@atishpatra.org>, tglx@linutronix.de,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Fabiano Rosas <farosas@linux.ibm.com>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Bharata B Rao <bharata@linux.ibm.com>, kvm-riscv@lists.infradead.org,
 pbonzini@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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

On Wed, Feb 09, 2022, Chao Gao wrote:
> This partially reverts commit b99040853738 ("KVM: Pass kvm_init()'s opaque
> param to additional arch funcs") remove opaque from
> kvm_arch_check_processor_compat because no one uses this opaque now.
> Address conflicts for ARM (due to file movement) and manually handle RISC-V
> which comes after the commit.
> 
> And changes about kvm_arch_hardware_setup() in original commit are still
> needed so they are not reverted.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
