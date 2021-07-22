Return-Path: <SRS0=vB6B=MO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44FAC6377D
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 15:38:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4264260BD3
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 15:38:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4264260BD3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3E2849E57;
	Thu, 22 Jul 2021 11:38:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pT59hOTvAKUL; Thu, 22 Jul 2021 11:38:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B84334A173;
	Thu, 22 Jul 2021 11:38:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4BFD49E93
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 11:38:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TRsEy29d8yVa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Jul 2021 11:38:21 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E904F49E57
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 11:38:20 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52F186052B;
 Thu, 22 Jul 2021 15:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1626968299;
 bh=8nuwoZzIE9AXZnCM6wlUP00pAGYzYvAAKw+DrOsiFF4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=GsDuiPbntO7mTbUHw/OMga6TpqxPzd1jVux3hSo8uaiVGT/FS1jJae4yyYqKXGFPa
 Tjh6LTF4MnLRwrMll7/BPTadvvds5880xaeoagTdakty199n46NPakMNOgptqU60cB
 P5gGX1qTC+Ri2ieYZ9XnV9h5HL+OIVKQciK2b4R4Mr/rNkCSUGXMt5qHwU6bIPeHqL
 OkhSNafLRHVCfxswugOTMybYqAbgOigkhZPr/eOPPP4Z9PWTsLf2BWWk17ESMh5rQS
 H+JD683PNUSwyaJGSrvqTMkk9WF3ym5GZXT3StPbQ9iWybwgJGZ5DxLDBOFkaC2VZb
 5g3p3JN4p62sg==
Date: Thu, 22 Jul 2021 16:38:15 +0100
From: Will Deacon <will@kernel.org>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 3/3] kvm/arm: Align the VMID allocation with the arm64
 ASID one
Message-ID: <20210722153814.GA12566@willie-the-truck>
References: <20210616155606.2806-1-shameerali.kolothum.thodi@huawei.com>
 <20210616155606.2806-4-shameerali.kolothum.thodi@huawei.com>
 <20210721163138.GD11003@willie-the-truck>
 <f7d708704fb84380af85298a98f7a48c@huawei.com>
 <20210722095010.GA12012@willie-the-truck>
 <43b32e77-52b1-8524-63a1-c99578c2dd1d@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <43b32e77-52b1-8524-63a1-c99578c2dd1d@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 Linuxarm <linuxarm@huawei.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

Hi Vladimir,

On Thu, Jul 22, 2021 at 04:22:26PM +0100, Vladimir Murzin wrote:
> On 7/22/21 10:50 AM, Will Deacon wrote:
> > As an aside: I'm more and more inclined to rip out the CnP stuff given
> > that it doesn't appear to being any benefits, but does have some clear
> > downsides. Perhaps something for next week.
> 
> Can you please clarify what do you mean by "it doesn't appear to being any
> benefits"? IIRC, Cortex-A65 implements CnP hint and I've heard that some
> payloads seen improvement...

Has anybody taped that out? I'd have thought building an SMT design in 2021
is a reasonably courageous thing to do.

The issue I'm getting at is that modern cores seem to advertise CnP even
if they ignore it internally, maybe because of some big/little worries?
That would be fine if it didn't introduce complexity and overhead to the
kernel, but it does and therefore I think we should rip it out (or at
least stick it behind a "default n" config option if there are some niche
users).

There are also open questions as to exactly what CnP does because the
architecture is not clear at all (for example TTBRx_EL1.CnP is permitted
to be cached in a TLB).

CHeers,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
