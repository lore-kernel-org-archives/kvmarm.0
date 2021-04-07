Return-Path: <SRS0=nct1=JE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A13C433B4
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 20:57:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A71961205
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 20:57:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A71961205
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9B904B847;
	Wed,  7 Apr 2021 16:57:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ylVebirAd61l; Wed,  7 Apr 2021 16:57:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 116FA4B89F;
	Wed,  7 Apr 2021 16:57:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6DA44B89F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 16:57:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nLVjTFgQIPcE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Apr 2021 16:57:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78AF14B895
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 16:57:10 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2258661131;
 Wed,  7 Apr 2021 20:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1617829027;
 bh=1Q2oOXUjRJwdCV+qOUNBymw/y9FGIdzI1jb6hvbjuZc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=jJg/YWZzVoLd0kBX/rSjkyXLycEWYmylXQ1cHt7V/whjGUBXNxjAc3sv9P5XuEiwm
 ZBGB2LMPwY8/fh4rqU6SuG8gck+wGF6mabpwZ38fKlVyQp6aZTL5+u4uSQwjP3m4l/
 GJaJFuEWSt6jJcXQtwFv45OT1478G3MES4y6mB1C6tdYBH3NJAUaO82M89AFI6yZ4u
 KkMH3yVUQqvV3vNWuYg3SzLN4uu0ISzfxEzctlSDWUjwA/Y+htRSGkeKoEkdxRTN5R
 SqLk3D1uLeLFmRwDIXyZMtCEL0h3U2jv3OZT9cGnMFG+YNR2kqWcP5Pw4Jw4szZKes
 WmJiDe4QKNKqg==
Date: Wed, 7 Apr 2021 21:57:02 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [RFC PATCH v3 1/2] KVM: arm64: Move CMOs from user_mem_abort to
 the fault handlers
Message-ID: <20210407205701.GA16198@willie-the-truck>
References: <20210326031654.3716-1-wangyanan55@huawei.com>
 <20210326031654.3716-2-wangyanan55@huawei.com>
 <cd6c8a86-b7b2-3d3e-121a-c9d1cb23c4b3@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cd6c8a86-b7b2-3d3e-121a-c9d1cb23c4b3@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Apr 07, 2021 at 04:31:31PM +0100, Alexandru Elisei wrote:
> On 3/26/21 3:16 AM, Yanan Wang wrote:
> > We currently uniformly permorm CMOs of D-cache and I-cache in function
> > user_mem_abort before calling the fault handlers. If we get concurrent
> > guest faults(e.g. translation faults, permission faults) or some really
> > unnecessary guest faults caused by BBM, CMOs for the first vcpu are
> 
> I can't figure out what BBM means.

Oh, I know that one! BBM means "Break Before Make". Not to be confused with
DBM (Dirty Bit Management) or BFM (Bit Field Move).

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
