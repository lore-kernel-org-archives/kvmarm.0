Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B0BC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  8 Oct 2022 03:15:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0829649F38;
	Fri,  7 Oct 2022 23:15:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0v+073cnwx0E; Fri,  7 Oct 2022 23:15:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9570049F41;
	Fri,  7 Oct 2022 23:15:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA90040E06
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 23:15:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p+rihnbX5mpw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Oct 2022 23:15:06 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7685940CDE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 23:15:06 -0400 (EDT)
Date: Sat, 8 Oct 2022 03:14:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1665198905;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=w536VtiSPZviNhRM1LzNsJqAcdtnkz72j6ZSuWSYzrk=;
 b=L8qFzW5Ns/GH849lEiEkf/QN0w9JqKt0EwPU4KaxnMXbRws9GU90wGetKZXLch5MbHudHm
 oULU3HiXt3869EBTLOBwIVor8Xmbh9hbgo+Q/wWoI1PPKzS1ppNcN6q0yJom5/uaWz6K4x
 06txuOFNTNzRmomT8lTxCloo7LkmlM8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 15/15] KVM: arm64: Handle stage-2 faults in parallel
Message-ID: <Y0DrMx0oEzXQRNqT@google.com>
References: <20221007233253.460257-1-oliver.upton@linux.dev>
 <202210081008.A9PLyQx2-lkp@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <202210081008.A9PLyQx2-lkp@intel.com>
X-Migadu-Flow: FLOW_OUT
Cc: kbuild-all@lists.01.org, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
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

On Sat, Oct 08, 2022 at 11:01:44AM +0800, kernel test robot wrote:

[...]

> All warnings (new ones prefixed by >>):
> 
>    arch/arm64/kvm/hyp/nvhe/mem_protect.c: In function '__host_stage2_idmap':
> >> arch/arm64/kvm/hyp/nvhe/mem_protect.c:260:60: warning: implicit conversion from 'enum <anonymous>' to 'enum kvm_pgtable_walk_flags' [-Wenum-conversion]
>      260 |                                       prot, &host_s2_pool, false);
>          |                                                            ^~~~~
> 

Woops, this one fell through the cracks of the flagification.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
