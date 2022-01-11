Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABF1C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 09:00:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 485A64B252;
	Tue, 11 Jan 2022 04:00:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8G3v3s04T5It; Tue, 11 Jan 2022 04:00:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8396D4B266;
	Tue, 11 Jan 2022 04:00:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBB784ACC9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 22:08:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5x8YB0O-6DEG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 22:08:52 -0500 (EST)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AD3D4A11C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 22:08:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1641870532; x=1673406532;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=RMI1RbSj7Nf4sUd+ZkqJlzpz1NnGp0vcp4SZw2pUIQ4=;
 b=jeuitBawiYhZ9ZJ21NDKqFOTUdZrgxrOiPQgt9HtwXbyEsLRqSTJHjG2
 5RlbCU5zSibEcoPBXqd9n3CZqUlYdhDF5lwoEwWXT5vv9w6NqlTHejqsv
 a7YdPO4SXNzqW3gZaAjjYUOqKvJXiyfdfAF4xy1RlN2ZlGUQXJlVCfiEj
 WzFW+uKPOKp6Abrc6ap3ihL/TJNOXf5LCO3jdTG8X6HSdCUkkjom7Cuoe
 XDRaEEtTwrkHemYu7LRjMyHPPaGgFto215c4LPz0fbrlYjGu3nlIe5lrD
 1HWWcE4RJZxQ3tLdhbVkeSGumwtH1UwElL7uJuM20zJAv7RYR132k23Jh A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="224085786"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; d="scan'208";a="224085786"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 10 Jan 2022 19:08:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; d="scan'208";a="622907157"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
 by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 10 Jan 2022 19:08:40 -0800
Date: Tue, 11 Jan 2022 11:19:34 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 3/6] KVM: Remove opaque from
 kvm_arch_check_processor_compat
Message-ID: <20220111031933.GB2175@gao-cwp>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-4-chao.gao@intel.com>
 <Ydy8BCfE0jhJd5uE@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Ydy8BCfE0jhJd5uE@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
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

On Mon, Jan 10, 2022 at 11:06:44PM +0000, Sean Christopherson wrote:
>On Mon, Dec 27, 2021, Chao Gao wrote:
>> No arch implementation uses this opaque now.
>
>Except for the RISC-V part, this can be a pure revert of commit b99040853738 ("KVM:
>Pass kvm_init()'s opaque param to additional arch funcs").  I think it makes sense
>to process it as a revert, with a short blurb in the changelog to note that RISC-V
>is manually modified as RISC-V support came along in the interim.

commit b99040853738 adds opaque param to kvm_arch_hardware_setup(), which isn't
reverted in this patch. I.e., this patch is a partial revert of b99040853738
plus manual changes to RISC-V. Given that, "process it as a revert" means
clearly say in changelog that this commit contains a partial revert of commit
b99040853738 ("KVM: Pass kvm_init()'s opaque param to additional arch funcs").

Right?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
