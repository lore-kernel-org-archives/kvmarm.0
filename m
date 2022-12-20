Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBB3C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 20 Dec 2022 18:09:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC17E4B5F6;
	Tue, 20 Dec 2022 13:09:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9O5dpjS5wnE5; Tue, 20 Dec 2022 13:09:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6330B4B3D0;
	Tue, 20 Dec 2022 13:09:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB9854B3D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2022 13:09:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fHZE-DMC0d1c for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Dec 2022 13:09:04 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96F5D4B1AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2022 13:09:04 -0500 (EST)
Date: Tue, 20 Dec 2022 18:08:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1671559743;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Atj54Nw9bdWqUwG1TnYWRTZQTU38JBhfofXGnTj7ibY=;
 b=r8r81FTlPNo/cpEYCCYaNZyC+G8XV7irW+K2mlLN2c1ohpajq5S40p4xmnC5iDZ8ItbhwG
 2V6cyYaNgkf8ctXrjcUCwh65OLuBVWCmq/jBUTfZDDQYI/7RTQcgP4vu/h1xeN8UUfXeuu
 ND45bkO70kb1g9pCycRBzBhuFdrVxTc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v1 10/12] KVM: arm64: Rework logic to en/decode
 VTCR_EL2.{SL0, SL2} fields
Message-ID: <Y6H6OlQotzguqdLJ@google.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
 <20221206135930.3277585-11-ryan.roberts@arm.com>
 <Y6D8mYpSY0K8EGO4@google.com>
 <94981e1e-4e88-caa1-222a-7ba336bcd156@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <94981e1e-4e88-caa1-222a-7ba336bcd156@arm.com>
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

On Tue, Dec 20, 2022 at 09:01:19AM +0000, Ryan Roberts wrote:
> On 20/12/2022 00:06, Oliver Upton wrote:
> > Hi Ryan,
> > 
> > On Tue, Dec 06, 2022 at 01:59:28PM +0000, Ryan Roberts wrote:
> >> In order to support 5 level translation, FEAT_LPA2 introduces the 1-bit
> >> SL2 field within VTCR_EL2 to extend the existing 2-bit SL0 field. The
> >> SL2[0]:SL0[1:0] encodings have no simple algorithmic relationship to the
> >> start levels they represent (that I can find, at least), so replace the
> >> existing macros with functions that do lookups to encode and decode the
> >> values. These new functions no longer make hardcoded assumptions about
> >> the maximum level and instead rely on KVM_PGTABLE_FIRST_LEVEL and
> >> KVM_PGTABLE_LAST_LEVEL.
> >>
> >> This is preparatory work for enabling 52-bit IPA for 4KB and 16KB pages
> >> with FEAT_LPA2.
> >>
> >> No functional change intended.
> >>
> >> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> > 
> > Why do we need to support 5-level paging at stage-2?
> > 
> > A configuration of start_level = 0, T0SZ = 12 with 4K paging would
> > result in 16 concatenated tables at level 0, avoiding the level -1
> > lookup altogether.
> 
> Yes, agreed. And that's exactly what the code does. So we could remove this
> patch from the series and everything would continue to function correctly. But I
> was trying to make things more consistent and maintainable (this now works in
> terms of KVM_PGTABLE_FIRST_LEVEL and KVM_PGTABLE_LAST_LEVEL for example).

My largest concern was the plumbing that was added for setting a start
level of -1 that is effectively dead code. I worry about it because it
can be confusing for newcomers and can be an open invitation to mess
things up later down the line.

> So happy to remove this and replace with a comment describing the limitations if
> that's your preference?

Marc, feel free to put me in line here if I'm not thinking about this
right, but adding support for an unused feature is likely less
maintainable. So, I'd prefer we drop the patch.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
