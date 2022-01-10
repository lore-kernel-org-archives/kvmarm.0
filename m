Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91AEC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 09:00:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ABCF4B207;
	Tue, 11 Jan 2022 04:00:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QXubXYPkO7oD; Tue, 11 Jan 2022 04:00:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C4EF4B245;
	Tue, 11 Jan 2022 04:00:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9014D4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 18:06:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VEWw3LrjwGA9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 18:06:50 -0500 (EST)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A8F04A0FF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 18:06:50 -0500 (EST)
Received: by mail-pj1-f48.google.com with SMTP id
 59-20020a17090a09c100b001b34a13745eso1357854pjo.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 15:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=y+VBsHBfwIdG2OzWHPdI/WIqfhyYeKNFkPIFzGKgGjs=;
 b=X/BYePGBzH1Y0U06VN7h0LTAx5XkiSMJkjX4bzEruFI1kwOUOCZ/UQD5Hz1I4ruAQl
 PKrgHenyxeASQaRZZvzIOgMnuzQdonH1VvyAbdvdjbchbZ2+uMZc22CuQapKF6//7uez
 U7SEtzQCYOhll5kuSGrRuD3424eXtMM1K2q20cLcgofjiBKZpwYAGGu/G+SgPu+Ah0Ai
 cMXFe7zrtF2HSeLvPaMRp85OO6XQzOWT5yW68a8WQ+brErvfPeLpyOXHT8jSayE1ssES
 B/xCP4larnCmFQsqFp3LTl28pqvPRHXZOcO2unNP2YugKO4xbE5RD1x5r36xyKuMboWr
 viJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=y+VBsHBfwIdG2OzWHPdI/WIqfhyYeKNFkPIFzGKgGjs=;
 b=kFGn5LB0hbTzvO5hIAy45ppa3fwde4AsEbPHWt50Wg+xX4euw64FafyD9uhc0nyYhm
 SkYbl7tcnbStkc1JGrXl4rb8S/OB6JJlmVvUIJIAv63su9cU4sTuiaAyVcqrggDfkWuF
 s+sQ+UT+EXuLsz8A5nE7jnENCSZzwHBqQN8iPnVQhRFNzsdgHECqzC9LUX86kyLMiO4Z
 Y/POcNXX28yvokXlSIhqI1tcuxwIqUI6VSuOlWSHkfQy0N16ejZ/Zgu2AqzPVRjhQa51
 jyOd1x6RH7cARiq2NHEC4cEd0IjELeUurs11xZVjui+0x0qfs/6i/H/QyOVEkaFcATFC
 7hfw==
X-Gm-Message-State: AOAM531mrZJB3+imn6FKYVLo8y5xSgXXJM4Y3oLehJb6zYjp9zcP/oDD
 cblUPoYsHNdcFO0vr3VjdFQ1xg==
X-Google-Smtp-Source: ABdhPJwuqul2WTZrr6xhkm1p+58Y11+q37mOxYmOZK51ca5s/4q/F/MIfrRIm+VTh9ySZMN7V9F+qQ==
X-Received: by 2002:a17:90a:d90b:: with SMTP id
 c11mr37450pjv.211.1641856009160; 
 Mon, 10 Jan 2022 15:06:49 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id d1sm4554170pgd.66.2022.01.10.15.06.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 10 Jan 2022 15:06:48 -0800 (PST)
Date: Mon, 10 Jan 2022 23:06:44 +0000
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH 3/6] KVM: Remove opaque from
 kvm_arch_check_processor_compat
Message-ID: <Ydy8BCfE0jhJd5uE@google.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-4-chao.gao@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211227081515.2088920-4-chao.gao@intel.com>
X-Mailman-Approved-At: Tue, 11 Jan 2022 04:00:43 -0500
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

On Mon, Dec 27, 2021, Chao Gao wrote:
> No arch implementation uses this opaque now.

Except for the RISC-V part, this can be a pure revert of commit b99040853738 ("KVM:
Pass kvm_init()'s opaque param to additional arch funcs").  I think it makes sense
to process it as a revert, with a short blurb in the changelog to note that RISC-V
is manually modified as RISC-V support came along in the interim.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
