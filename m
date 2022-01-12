Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF5FC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 17:48:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2934B25F;
	Wed, 12 Jan 2022 12:48:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5c1EPfmjh1kV; Wed, 12 Jan 2022 12:48:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 627D04B259;
	Wed, 12 Jan 2022 12:48:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25CEE4B23D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 12:21:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XbEnTeGFVuz1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 12:21:31 -0500 (EST)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29B6F4B238
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 12:21:31 -0500 (EST)
Received: by mail-pj1-f48.google.com with SMTP id
 a1-20020a17090a688100b001b3fd52338eso5009618pjd.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 09:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=TYHRM7+kADwOp9diBRrPGp4L0N1LoYL1IUvHa0nGaUc=;
 b=UOi9kIvtR/IrJwzo5niwxDtXudsV6IxInf5Xux8zgZWocQk2IEmaYc0XSVBraMOzip
 1p6oktTDeAT0Xo0Y1Hv38DXQkmSLxGT3a21Lcwuzm9HPptZ8CwyjAsbDUolqExCQJBvI
 3/Ilf2Jr3LSRwS8m0x3JSZhofT299fDyux/e4JRm1BTZb8xRszyzcX2IlMX1MSEgYjMT
 4xhdcYSj8HE0lJizFcqyvQ1F0sIsor9GOdwCIFkIY/f5YjDSO/UpiSWU7FnrM6Aap0Ov
 XAwRUtuXNr7yYBD4h8SO2lxl+txc3ZtlyhAeUA7I20RlONuBzpovIUUx1rYk6w6DmC66
 icRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TYHRM7+kADwOp9diBRrPGp4L0N1LoYL1IUvHa0nGaUc=;
 b=rOaVH+W42ZMQ8+RL8T6HvPz4fAdcIQSEBRxs5OHDCojsjUFy5GKcyKY/dS3qKeKftG
 sEVU0PDewxAZ89e1iepxGfQLvqGdI5qY7RDkqA1dqOZqMFyaUHDYD6RAwoSGuoZwuaYk
 FLEuV41iYstmLgu2Z1kOzFn5F8tt2Q9nKZgHo5AmSN2Qr3qX/Cp6k3RjszxpaKnbwFOT
 UwRralwvx4tZYrg+Ut69ik2cAMA1uhjuiv0qakjpExm4FDxk8SiDtnaE37QMN0MX+Ow5
 45gGXh9ZNxiifKhTmrewo4qqk0DbDe/VL5O2zU2C5Hy7ou87/9FHHccChN7wjPIhq2NL
 ArFA==
X-Gm-Message-State: AOAM532G/xJ1mHANYZxG2a3voS+RNHhUozURa2jI4rjIo/nsO7MEftX4
 3Y8qaNMg3GKgKKyA5UwiRLmfkQ==
X-Google-Smtp-Source: ABdhPJzFOOljTybPaAkOSjlPQwykizLUTnzjLoFkEgLqIZkrqe/Ahlwi51dGj1hKKqsANfiIKGdNKw==
X-Received: by 2002:a63:7845:: with SMTP id t66mr576433pgc.103.1642008090029; 
 Wed, 12 Jan 2022 09:21:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id qe10sm7011428pjb.5.2022.01.12.09.21.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 12 Jan 2022 09:21:29 -0800 (PST)
Date: Wed, 12 Jan 2022 17:21:25 +0000
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH 3/6] KVM: Remove opaque from
 kvm_arch_check_processor_compat
Message-ID: <Yd8OFT80exMeCMVA@google.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-4-chao.gao@intel.com>
 <Ydy8BCfE0jhJd5uE@google.com> <20220111031933.GB2175@gao-cwp>
 <Yd8N7PFqZbACzh2r@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yd8N7PFqZbACzh2r@google.com>
X-Mailman-Approved-At: Wed, 12 Jan 2022 12:48:38 -0500
Cc: x86@kernel.org, Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-mips@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, Paul Mackerras <paulus@samba.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Ravi Bangoria <ravi.bangoria@linux.ibm.com>, kevin.tian@intel.com,
 Albert Ou <aou@eecs.berkeley.edu>, Vasily Gorbik <gor@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Borislav Petkov <bp@alien8.de>,
 =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, tglx@linutronix.de,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Fabiano Rosas <farosas@linux.ibm.com>, Anup Patel <anup.patel@wdc.com>,
 linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>,
 kvm-riscv@lists.infradead.org, Michael Ellerman <mpe@ellerman.id.au>,
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

On Wed, Jan 12, 2022, Sean Christopherson wrote:
> On Tue, Jan 11, 2022, Chao Gao wrote:
> > On Mon, Jan 10, 2022 at 11:06:44PM +0000, Sean Christopherson wrote:
> > >On Mon, Dec 27, 2021, Chao Gao wrote:
> > >> No arch implementation uses this opaque now.
> > >
> > >Except for the RISC-V part, this can be a pure revert of commit b99040853738 ("KVM:
> > >Pass kvm_init()'s opaque param to additional arch funcs").  I think it makes sense
> > >to process it as a revert, with a short blurb in the changelog to note that RISC-V
> > >is manually modified as RISC-V support came along in the interim.
> > 
> > commit b99040853738 adds opaque param to kvm_arch_hardware_setup(), which isn't
> > reverted in this patch. I.e., this patch is a partial revert of b99040853738
> > plus manual changes to RISC-V. Given that, "process it as a revert" means
> > clearly say in changelog that this commit contains a partial revert of commit
> > b99040853738 ("KVM: Pass kvm_init()'s opaque param to additional arch funcs").
> > 
> > Right?
> 
> What I meant is literally do
> 
>   git revert -s b99040853738
> 
> and then manually handle RISC-V.

Doh, to be clear, "manually handle RISC-V _in the same commit_".
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
