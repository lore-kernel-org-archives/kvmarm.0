Return-Path: <SRS0=68gc=DW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9D8C433E7
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 11:26:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 75D342080A
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 11:26:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="w7jKyu4O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75D342080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA524B6E7;
	Thu, 15 Oct 2020 07:26:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xTRSzJXZQ--b; Thu, 15 Oct 2020 07:26:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C1B44B562;
	Thu, 15 Oct 2020 07:26:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8BA94B6E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 07:26:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CzLDAgAFzQsE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2020 07:26:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E0E14B562
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 07:26:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 11D1720878;
 Thu, 15 Oct 2020 11:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1602761173;
 bh=jlvWDzncWzjj0CkQc8YBItJ3auhIS7cMPtALYoadg/U=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=w7jKyu4OD9gTPtmS0kFMmNIa1X+o7PA7ue8sVMq8tNWG3UK0+EWd1jFYsMxflmSfj
 Igx7UK7H8hYd9DaSNIK+A5LRvXDQz4MmXJrSvnUXPoPARkcehg6FbziOGywgGGaJ4l
 RqTycU353H/kbM4UdMDPf/lJ27JqKl7hIBkmKfpI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kT1Od-001Mt3-0U; Thu, 15 Oct 2020 12:26:11 +0100
MIME-Version: 1.0
Date: Thu, 15 Oct 2020 12:26:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: xu910121@sina.com
Subject: Re: Kernel patch cases qemu live migration failed.
In-Reply-To: <20201015040639.70C6D414009F@webmail.sinamail.sina.com.cn>
References: <20201015040639.70C6D414009F@webmail.sinamail.sina.com.cn>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7fecfc67da4caab1d677a8b4cd5386b3@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: xu910121@sina.com, dave.martin@arm.com,
 kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: qemu-devel <qemu-devel@nongnu.org>, "Dave.Martin" <dave.martin@arm.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkKClBsZWFzZSBkb24ndCB1c2UgbXkgYXJtLmNvbSBhZGRyZXNzIGFueW1vcmUsIG5vYm9keSBy
ZWFkcyBpdC4uLgoKT24gMjAyMC0xMC0xNSAwNTowNiwg5byg5Lic5petIHdyb3RlOgo+IEknbSBz
byBzb3JyeSBmb3IgZGlzdHVyYmluZyB5b3UuCj4gCj4gV2hlbiBJIGFwcGx5IHRoaXMga2VybmVs
IHBhdGNo77yaS1ZNOiBhcm02NC9zdmU6IFN5c3RlbSByZWdpc3Rlcgo+IGNvbnRleHQgc3dpdGNo
IGFuZCBhY2Nlc3Mgc3VwcG9ydAo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQvYXJjaC9hcm02NC9rdm0vc3lz
X3JlZ3MuYz9pZD03MzQzMzc2MmZjYWViOWQ1OWU4NGQyOTkwMjFjNmIxNTQ2NmM5NmRkCgpUaGlz
IHBhdGNoIHdhcyBvbmx5IGludHJvZHVjZWQgaW4gNS4yLCBhbmQgd2Fzbid0IHN1cHBvc2VkIHRv
IGJlCmJhY2twb3J0ZWQgdG8gYW55dGhpbmcgZWxzZS4KCj4gcWVtdSBsaXZlIG1pZ3JhdGlvbiB3
aWxsIGZhaWxlZCB3aXRoIG1lc3NhZ2Vz77yaCj4gICAgICAgICAgICAgICDigItxZW11LWt2bTog
SW52YWxpZCB2YWx1ZSAyMzMgZXhwZWN0aW5nIHBvc2l0aXZlIHZhbHVlCj4gPD0gMjMyCj4gICAg
ICAgICAgICAgICBxZW11LWt2bTogRmFpbGVkIHRvIGxvYWQgY3B1OmNwcmVnX3Ztc3RhdGVfYXJy
YXlfbGVuCj4gTmV3IHZlcnNpb24ga2VybmVsICBleGNsdWRlIElEX0FBNjRaRlIwX0VMMSByZWdp
c3RlciB3aGVuIGhvc3Qgbm90Cj4gc3VwcG9ydCBTVkUgZmVhdHVyZSwKPiBzbyBxZW11IGlvY3Rs
IGt2bShLVk1fR0VUX1JFR19MSVNUKSB3aWxsIG5vdCBjb250YWluIElEX0FBNjRaRlIwX0VMMQo+
IHJlZ2lzdGVyLgo+IAo+IEknbSB1c2luZyBDZW50T1MgTGludXgga2VybmVsLCBvbGQga2VybmVs
IHZlcnNpb27vvJo0LjE4LjAtODAuMTEuZWw4Cj4gKG1pZ3JhdGlvbiBzb3VyY2UpCj4gICAgICAg
bmV3IGtlcm5lbCB2ZXJzaW9u77yaNC4xOC4wLTE0Ny41LmVsOCAobWlncmF0aW9uIGRlc3RpbmF0
aW9uKQo+IAo+IENlbnRPUyBsaW51eCBrZXJuZWwgdmVyc2lvbiA0LjE4LjAtMTExLmVsOCBhcHBs
aWVkIHRoaXMgcGF0Y2guIFNvCj4gNC4xOC4wLTE0Ny41LmVsOCBhbHNvIGFwcGxpZWQgdGhpcyBw
YXRjaC4KPiAKPiBNaWdyYXRpb24gc291cmNlIGFuZCBkZXN0aW5hdGlvbiBob3N0cyBoYXZlIHRo
ZSBzYW1lIGhhcmR3YXJlLCBqdXN0Cj4ga2VybmVsIHZlcnNpb24gaXMgZGlmZmVyZW50LAo+IGFu
ZCB0aGUgaGFyZHdhcmUgb24gZWl0aGVyIHNpZGUgb2YgdGhlIG1pZ3JhdGlvbiBub3Qgc3VwcG9y
dCBTVkUuCj4gCj4gSXMgdGhlcmUgc29tZSBnb29kIHN1Z2dlc3Rpb25z77yMd2hpY2ggY2FuIG1h
a2Ugc3VyZSBvbGQgdmVyc2lvbgo+IGtlcm5lbCBsaXZlIG1pZ3JhdGlvbiB0byBuZXcgdmVyc2lv
biBrZXJuZWwgd2l0aCBxZW11PwoKSVsnbSBhZnJhaWQgeW91IHNob3VsZCB0YWtlIHRoaXMgd2l0
aCB5b3VyIGRpc3RyaWJ1dGlvbiBvZgpjaG9pY2UsIHVubGVzcyB5b3UgY2FuIHJlcHJvZHVjZSB0
aGUgcHJvYmxlbSB3aXRoIG1haW5saW5lIGtlcm5lbHMuCgpUaGFua3MsCgogICAgICAgICBNLgot
LSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdApr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1
L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
