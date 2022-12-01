Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F37CC4321E
	for <kvmarm@archiver.kernel.org>; Thu,  1 Dec 2022 01:34:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 891D34B282;
	Wed, 30 Nov 2022 20:34:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pdlNh2mlTM1r; Wed, 30 Nov 2022 20:34:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 608AA43479;
	Wed, 30 Nov 2022 20:34:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C6B440135
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 20:34:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W-957V+g+ID0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 20:34:52 -0500 (EST)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9C5E407BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 20:34:51 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1669858491; x=1701394491;
 h=message-id:subject:from:to:cc:date:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=YopNAk0o4R/Gm+eGMQdhkQKi75mYgT2RAg4YlRHu29c=;
 b=bpOijAC9/nN+0QvL8R9oSxAj3J0jCxQfrlRlqh2OPCAkRn/Bw/TpgyHp
 YyAxBuyMA6nvbKgsiNfuhfSReS2wFSAktO7kled0IayUPFiejOx4x//BO
 XXtfopSO5z581B0dQzbKaV91xtOp9qiBRcZyrPvGqmDAXiwiaG+zM0EjX
 12+A2jmHFc1lmoBqXClZ0fL2DQ2S/Lvb/rpvGmXmhoedHnqjXKkbtCtMM
 xLtOASCxIALXp0N5Q3nAyXRxC97SrEfL5dTw7BGKKHgJ2KArX1ygd5NNs
 y493+4wh7b1IP9V1nDtS4EcTamQhuGi0nM8L8tkvCRu1bSFIZi3gHTYtc g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313186487"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; d="scan'208";a="313186487"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 30 Nov 2022 17:34:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="707875700"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; d="scan'208";a="707875700"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org)
 ([10.239.48.212])
 by fmsmga008.fm.intel.com with ESMTP; 30 Nov 2022 17:34:38 -0800
Message-ID: <ceb3bb1e98a3933c3bf34641d731c69b67d761b4.camel@linux.intel.com>
Subject: Re: [PATCH 32/44] KVM: x86: Unify pr_fmt to use module name for all
 KVM modules
From: Robert Hoo <robert.hu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Date: Thu, 01 Dec 2022 09:34:37 +0800
In-Reply-To: <Y4fg+MO2DusqMSZO@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-33-seanjc@google.com>
 <ff0e8701d02ee161d064f92c8b742c2cc061bce0.camel@linux.intel.com>
 <Y20r2NR9MaBbOGLn@google.com> <Y4fg+MO2DusqMSZO@google.com>
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
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

On Wed, 2022-11-30 at 23:02 +0000, Sean Christopherson wrote:
> On Thu, Nov 10, 2022, Sean Christopherson wrote:
> > On Thu, Nov 10, 2022, Robert Hoo wrote:
> > > After this patch set, still find some printk()s left in
> > > arch/x86/kvm/*,
> > > consider clean all of them up?
> > 
> > Hmm, yeah, I suppose at this point it makes sense to tack on a
> > patch to clean
> > them up.
> 
> Actually, I'm going to pass on this for now.  The series is already
> too big.  I'll
> add this to my todo list for the future.

That's all right, thanks for update.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
