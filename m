Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25EFC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 09:29:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 703FC4A531;
	Thu, 17 Mar 2022 05:29:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WfgzSi0E3GaM; Thu, 17 Mar 2022 05:28:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 647F44B091;
	Thu, 17 Mar 2022 05:28:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E612C49F21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 05:16:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kqo1In9h9onp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Mar 2022 05:15:59 -0400 (EDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 440A949F18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 05:15:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1647508559; x=1679044559;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=AgYkRzO8ksOYyWWAS/gpvfK0lt7Rzm9dkVzVmq0l0/w=;
 b=bFr1S//xyXqz1idPy74O7MaCjZB/B8E2Yh04iXEmv+TGAHIE3nf+X3bk
 uSxyHpozVvN92vivWvYdxypWhnDjeO9/N+hjNIThzbyYJAqvXeAjjkkNr
 K5OGZDH58NzbwlWPnLpRHiArguT9CD7YwEPrhtxp5z8oN26vrvueGpEev
 9imhDjAEaadc9tm4uSv/Lx9qC1gWRYI7Hab4qBN4g6gzpi/rN9yjEeZo5
 FXALOjwqJ8VuKU4++cZvq3VHV/gJC8o1Ms8QxY5Xx4VCwewSzB7mu7m4X
 g7Vfqm3Rvmd3I6nfmrumHuk1qVY/zS/z2CJnAaU3SgIeozLX61YJ4h1yG A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="244276238"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; d="scan'208";a="244276238"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 17 Mar 2022 02:15:57 -0700
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; d="scan'208";a="557852602"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
 by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 17 Mar 2022 02:15:44 -0700
Date: Thu, 17 Mar 2022 17:15:41 +0800
From: Chao Gao <chao.gao@intel.com>
To: seanjc@google.com, maz@kernel.org, kvm@vger.kernel.org,
 pbonzini@redhat.com, kevin.tian@intel.com, tglx@linutronix.de
Subject: Re: [PATCH v4 0/6] Improve KVM's interaction with CPU hotplug
Message-ID: <20220317091539.GA7257@gao-cwp>
References: <20220216031528.92558-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220216031528.92558-1-chao.gao@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Mailman-Approved-At: Thu, 17 Mar 2022 05:28:50 -0400
Cc: Thomas Richter <tmricht@linux.ibm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Wanpeng Li <wanpengli@tencent.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Jia He <justin.he@arm.com>, Janosch Frank <frankja@linux.ibm.com>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 linux-riscv@lists.infradead.org,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Qi Liu <liuqi115@huawei.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 John Garry <john.garry@huawei.com>, Nicholas Piggin <npiggin@gmail.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Tom Zanussi <tom.zanussi@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
 Paul Walmsley <paul.walmsley@sifive.com>, Atish Patra <atishp@atishpatra.org>,
 Sumanth Korikkar <sumanthk@linux.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Shaokun Zhang <zhangshaokun@hisilicon.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Hector Martin <marcan@marcan.st>, Nick Desaulniers <ndesaulniers@google.com>,
 linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, kvm-riscv@lists.infradead.org,
 Michael Ellerman <mpe@ellerman.id.au>, Vitaly Kuznetsov <vkuznets@redhat.com>,
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

Ping. Anyone can help to review this series (particularly patch 3-5)?

FYI, Sean gave his Reviewed-by to patch 1,2,5 and 6.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
