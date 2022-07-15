Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E518FC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 13:15:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BF524BF06;
	Fri, 15 Jul 2022 09:15:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xYOXk-MuCPzM; Fri, 15 Jul 2022 09:15:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A6ED4BEF0;
	Fri, 15 Jul 2022 09:15:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D00E4BEF0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:15:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id avkmBMl6PfgD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 09:15:38 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0CD844BEEC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:15:37 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 53CDA62396;
 Fri, 15 Jul 2022 13:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EC0C34115;
 Fri, 15 Jul 2022 13:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657890936;
 bh=M5GYxJjy7rrq9T7n0kWM5WjfRQ1b9HVPT9OhYK98IPY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=d9WDYpLlCRcG9U25vMQ1HlH5P8DWUAkOKqGoEK9wUV5lZXBIfvVaLysBkQUnyttwv
 UcwBJyYC2W4JWlSe08mAqUszqrVIl5IJrOV53+0wUXlHc/oNvjYbLRuKKnmIHtZGw+
 9GTNWDThaSpJ03AQr63hBpW1mr3EEifFKw60crffwfF2PSx2KhXdnscxQ16R4RiwYX
 zoBnsTlv/1HGvCFhBJY2p9WY6tD3PufCZEvexR7HQl0oOCHQP/aTlNK3fQe/F8TC9f
 89WVHt/LgUR/icaHQ2MmS/HSOYAcw+41W6SyDmQHsKE9PF+QVz5jEDoMX7LsPwu+dF
 2PNPaM1lGAYKw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oCLAM-007gdq-EE;
 Fri, 15 Jul 2022 14:15:34 +0100
MIME-Version: 1.0
Date: Fri, 15 Jul 2022 14:15:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: Stephan Tobies <Stephan.Tobies@synopsys.com>
Subject: Re: How to re-inject a debug exception correctly?
In-Reply-To: <DM4PR12MB5264D795F72137498EF87971B18B9@DM4PR12MB5264.namprd12.prod.outlook.com>
References: <DM4PR12MB5264D795F72137498EF87971B18B9@DM4PR12MB5264.namprd12.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <fa5d5144a5299698cb9042abb1581d66@misterjones.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Stephan.Tobies@synopsys.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu
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

T24gMjAyMi0wNy0xNSAwOTo1MywgU3RlcGhhbiBUb2JpZXMgd3JvdGU6Cj4gSGVsbG8hCj4gCj4g
VGhlIGNvbW1lbnQgZm9yIGt2bV9oYW5kbGVfZ3Vlc3RfZGVidWcgc3RhdGVzIHRoYXQgaXQgaXMg
dXAgdG8gdGhlCj4gdXNlcnNwYWNlIHRvIHJlLWluamVjdCBkZWJ1ZyBleGNlcHRpb25zIGZvciB0
aGUgZ3Vlc3Qgd2hlbiB0aGV5IGFyZQo+IG5vdCDigJx1c2Vk4oCdIGJ5IHVzZXJzcGFjZS4KPiAK
PiBPbiB4ODYsIHRoaXMgaXMgYSBmYWlybHkgc2ltcGxlIHByb2Nlc3MgdGhhdCB1c2VzIEtWTV9T
RVRfVkNQVV9FVkVOVFMuCj4gRG9lcyB0aGlzIHdvcmsgc2ltaWxhcmx5IG9uIEFSTT8KCk5vdCBy
ZWFsbHkuIEtWTV9TRVRfVkNQVV9FVkVOVCBpcyBvbmx5IHVzZWQgdG8gaW5qZWN0IGV4Y2VwdGlv
bnMKc3VjaCBhcyBhbiBleHRlcm5hbCBkYXRhIGFib3J0LCBvciBhbiBTRXJyb3IgaW50ZXJydXB0
LgoKPiBJcyB0aGVyZSBzb21lIHNhbXBsZSBjb2RlIG9yCj4gZGVzY3JpcHRpb24gd2hpY2ggc3Rl
cHMgYXJlIG5lY2Vzc2FyeSBmb3IgdGhhdCByZS1pbmplY3Rpb24/IFFFTVUgdXNlcwo+IGl0cyBn
ZW5lcmljIGludGVycnVwdCBtYWNoaW5lcnksIHdoaWNoIG1ha2VzIGl0IGhhcmQgdG8gZGV0ZXJt
aW5lIHdoYXQKPiBhcmUgdGhlIG5lY2Vzc2FyeSBzdGVwcyB0byByZS1pbmplY3QgdGhlIGV4Y2Vw
dGlvbiBpbnRvIHRoZSBndWVzdC4KCllvdSBuZWVkIHRvIGRvIHdoYXRldmVyIHRoZSBhcmNoaXRl
Y3R1cmUgcmVxdWlyZXMgeW91IHRvIHBlcmZvcm06Ci0gcG9wdWxhdGUgRVNSLCBGQVIKLSBJbmpl
Y3QgdGhlIGV4Y2VwdGlvbiBpdHNlbGYgKHVwZGF0ZSBTUFNSLCBFTFIsIFBTVEFURSwgUEMpCiAg
IGZvciBhIHN5bmNocm9ub3VzIGV4Y2VwdGlvbi4KCkVmZmVjdGl2ZWx5LCB1c2Vyc3BhY2UgaGFz
IHRvIGltcGxlbWVudCBwYXJ0IG9mIHRoZSBleGNlcHRpb24KZGVsaXZlcnkgdGhhdCB3b3VsZCBu
b3JtYWxseSBiZSBkb25lIGJ5IHRoZSBDUFUgaXRzZWxmIGlmCnVzZXJzcGFjZSB3YXNuJ3QgaW4g
dGhlIHdheS4KCkZvciB0aGUgZGV0YWlscywgcGxlYXNlIGxvb2sgYXQgdGhlIEFBcmNoNjQuQWJv
cnQoKSBwc2V1ZG9jb2RlCmluIHRoZSBBUk0gQVJNIChEREkgMDQ4N0cuYiwgSjEuMS4yICJhYXJj
aDY0L2V4Y2VwdGlvbnMiKSwgd2hpY2gKaXMgdGhlIHJlZmVyZW5jZS4KCkhUSCwKCiAgICAgICAg
IE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
