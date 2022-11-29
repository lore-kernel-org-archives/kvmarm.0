Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B51C46467
	for <kvmarm@archiver.kernel.org>; Tue, 29 Nov 2022 21:15:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E3414B3D1;
	Tue, 29 Nov 2022 16:15:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f0Cm9YzFtPa3; Tue, 29 Nov 2022 16:15:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D678940F30;
	Tue, 29 Nov 2022 16:15:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9DC640AFA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 16:15:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LvyFMpCeJ0LN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2022 16:15:26 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3C6040F30
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 16:15:26 -0500 (EST)
Date: Tue, 29 Nov 2022 21:15:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1669756525;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=FtYFpXu5/fa0TaYiI4P0+GO9iWhqJmCXUsHphTqwjGw=;
 b=oE86JcLcGxsicJ5+/muPqhDr7FrTiNs6WD8LcTD34Qo6fvG4ULczduWra99AnJWXD8Xtg0
 garTf7J0LX7RmBFNAhjKicG/NVDNgHM7JNlVsJIgPMT0ZyHg3SMpR3SR8h5DHbZkmS+wfD
 UYYEx/SftPydGa+lK+iguxXp2/OPh14=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4Z2aWVEnluy+d3+@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
 <Y4Zw/J3srTsZ57P7@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y4Zw/J3srTsZ57P7@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Ricardo,

Thanks for having a look.

On Tue, Nov 29, 2022 at 12:52:12PM -0800, Ricardo Koller wrote:
> On Tue, Nov 29, 2022 at 07:19:44PM +0000, Oliver Upton wrote:

[...]

> > +	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> > +				       &pte, NULL, 0);
> > +	if (!ret)
> > +		dsb(ishst);
> 
> At the moment, the only reason for stage2_update_leaf_attrs() to not
> update the PTE is if it's not valid:
> 
> 	if (!kvm_pte_valid(pte))
> 			return 0;
> 
> I guess you could check that as well:
> 
> +	if (!ret || kvm_pte_valid(pte))
> +		dsb(ishst);

Thanks for catching this.

Instead of pivoting on the returned PTE value, how about we return
-EAGAIN from the early return in stage2_attr_walker()? It would better
match the pattern used elsewhere in the pgtable code.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
