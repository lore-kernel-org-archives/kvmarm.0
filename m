Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CC6C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 20 Dec 2022 00:07:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31EDC4B835;
	Mon, 19 Dec 2022 19:07:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2lpgoGbklZLY; Mon, 19 Dec 2022 19:06:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 620344B825;
	Mon, 19 Dec 2022 19:06:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 262D24B81E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 19:06:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5ruezwX3cAYq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 19:06:56 -0500 (EST)
Received: from out-13.mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E67EB4B84B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 19:06:55 -0500 (EST)
Date: Tue, 20 Dec 2022 00:06:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1671494814;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=foi+cM9gEI1JlVJgipQwf5m4Su0pKjKEMr5jntc/8X4=;
 b=FEA5Zx40ThQP3Y+aileQBqtWae2jAdWjSK9yyTnmOMbwatS5Kprq0K0HMUDAPCinU4n1qd
 dMWsHrxEbTE/SD3HHfKK9dsdzUwrPFsaEj/4Fnc4/Zj+TXLgmqu0wcwLDEkwYmYnx64cIO
 3cvJSQ3d0B/XcfXFOPWRY7eBF6GsT08=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v1 10/12] KVM: arm64: Rework logic to en/decode
 VTCR_EL2.{SL0, SL2} fields
Message-ID: <Y6D8mYpSY0K8EGO4@google.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
 <20221206135930.3277585-11-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221206135930.3277585-11-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT
Cc: Marc Zyngier <maz@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

Hi Ryan,

On Tue, Dec 06, 2022 at 01:59:28PM +0000, Ryan Roberts wrote:
> In order to support 5 level translation, FEAT_LPA2 introduces the 1-bit
> SL2 field within VTCR_EL2 to extend the existing 2-bit SL0 field. The
> SL2[0]:SL0[1:0] encodings have no simple algorithmic relationship to the
> start levels they represent (that I can find, at least), so replace the
> existing macros with functions that do lookups to encode and decode the
> values. These new functions no longer make hardcoded assumptions about
> the maximum level and instead rely on KVM_PGTABLE_FIRST_LEVEL and
> KVM_PGTABLE_LAST_LEVEL.
> 
> This is preparatory work for enabling 52-bit IPA for 4KB and 16KB pages
> with FEAT_LPA2.
> 
> No functional change intended.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

Why do we need to support 5-level paging at stage-2?

A configuration of start_level = 0, T0SZ = 12 with 4K paging would
result in 16 concatenated tables at level 0, avoiding the level -1
lookup altogether.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
