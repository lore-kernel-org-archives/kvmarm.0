Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA07CC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 17:48:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E3B4B266;
	Wed, 12 Jan 2022 12:48:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NkJSQeDxf361; Wed, 12 Jan 2022 12:48:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FD8A4B249;
	Wed, 12 Jan 2022 12:48:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 410AA4B23D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 12:20:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g75uAD4G6ECS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 12:20:50 -0500 (EST)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4311C4B238
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 12:20:50 -0500 (EST)
Received: by mail-pj1-f51.google.com with SMTP id o3so6340539pjs.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 09:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=QRCI1RlLdVZvt5lKUzeK60PXJ4E91izm9CxbrCuYWiw=;
 b=iD4ax0W/ZQejkpiTV+wC/BTGkgvydCG1+oy9k4x41xcYsxdOIrYBD3Jg5pNLFotLn3
 4lS1DP/A5h5rWv9t8jIgjAfIWRHyWSXlvlM7IaIgxX7hDAUmIgxXIoU5b+8CgT0R9dt0
 iCbsvCcrQj4kpbl/NpitUUKIbg7rTypIFxqdxfB2feMrGc8niiEgwy4Jncc/4d2meNQg
 hKQ5yFTrProqxoFW6AG+GqRq3CQHFwiDeSswlB6x17ayzfA94e4NsXmAcxNN0/DUQR5b
 DQXQiXIgM3bNMe/5PUo8aj95UIBHAUjKy79FkjU/HbhRpV61hkglUgnEV5dHn1QxLypF
 YTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QRCI1RlLdVZvt5lKUzeK60PXJ4E91izm9CxbrCuYWiw=;
 b=t+MM7mjJ14cvfPZ4APUrEDgG3RITY/tXaPBgxVlHvM9kqaD64zz3fQOVOKfORyji1e
 tGQPNllmDFxstF0Hfvj0jflAav2OE3n2iUkFqOpXm11eHXeqEQLv6cto9blvybsQ3B8R
 yLd3rLS/f2fQvMNdJWSea0BTuVvlzAxtk79WAiub8+7NFBCvEdEtElwlkZjr1BwPWkrZ
 LGJHAKZ1rKG0x6ffrCYOglKHXQglq9elgAl+VV7y2+0UvSiV+NqgvlmlN0/6+ruvZHKy
 xiwFQwfnbWTnuBkBAv0Yhe+PGobfwIrn1pZ0kZltX2+AXDwClQaRULQaKz+AbCuJ06jv
 pCCA==
X-Gm-Message-State: AOAM530kxA36a6t9+ljf/y7W0V7BfbvBMNzGmahYc1h0dfkaWEs4tSDU
 +kFESKTcj97ZvT+jcRnxQ8ZQTA==
X-Google-Smtp-Source: ABdhPJzSQE5HuAs9ufGKv8GVZpWcgq8Jooiv84LWQSj+pdxhdpdaB4H7DHBA1IqNFc1FS00InVj1vA==
X-Received: by 2002:a05:6a00:2442:b0:4bc:e7ac:b5aa with SMTP id
 d2-20020a056a00244200b004bce7acb5aamr553091pfj.56.1642008049112; 
 Wed, 12 Jan 2022 09:20:49 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id kb1sm266614pjb.45.2022.01.12.09.20.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 12 Jan 2022 09:20:48 -0800 (PST)
Date: Wed, 12 Jan 2022 17:20:44 +0000
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH 3/6] KVM: Remove opaque from
 kvm_arch_check_processor_compat
Message-ID: <Yd8N7PFqZbACzh2r@google.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-4-chao.gao@intel.com>
 <Ydy8BCfE0jhJd5uE@google.com> <20220111031933.GB2175@gao-cwp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220111031933.GB2175@gao-cwp>
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

On Tue, Jan 11, 2022, Chao Gao wrote:
> On Mon, Jan 10, 2022 at 11:06:44PM +0000, Sean Christopherson wrote:
> >On Mon, Dec 27, 2021, Chao Gao wrote:
> >> No arch implementation uses this opaque now.
> >
> >Except for the RISC-V part, this can be a pure revert of commit b99040853738 ("KVM:
> >Pass kvm_init()'s opaque param to additional arch funcs").  I think it makes sense
> >to process it as a revert, with a short blurb in the changelog to note that RISC-V
> >is manually modified as RISC-V support came along in the interim.
> 
> commit b99040853738 adds opaque param to kvm_arch_hardware_setup(), which isn't
> reverted in this patch. I.e., this patch is a partial revert of b99040853738
> plus manual changes to RISC-V. Given that, "process it as a revert" means
> clearly say in changelog that this commit contains a partial revert of commit
> b99040853738 ("KVM: Pass kvm_init()'s opaque param to additional arch funcs").
> 
> Right?

What I meant is literally do

  git revert -s b99040853738

and then manually handle RISC-V.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
