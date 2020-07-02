Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CCFC433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 09:17:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F130020748
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 09:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="mS7Kx7xY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F130020748
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95FE84B5DF;
	Thu,  2 Jul 2020 05:17:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sUaDY7N1m6Ov; Thu,  2 Jul 2020 05:17:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 934114B5BA;
	Thu,  2 Jul 2020 05:17:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB11E4B5BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 05:17:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Soma1w9H8nYM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 05:17:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC1BF4B5AC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 05:17:54 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9682A20702;
 Thu,  2 Jul 2020 09:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593681473;
 bh=riJbnj3lW3s52zzCoIpgx8rEdxBveXjj8C/8uqF6YXA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=mS7Kx7xYu+bjeniGuvdTqxDXvaGhLAfh6dHUKqojLyPj+YnkZTflqYGw3OX9HzrGD
 Ycbo5dO99JLrgJFCqQFaHhTZl218E1kvwpL41NITMDrC54GRgfV/COebsqB+sSI+Fo
 +8yCWS16sszLfyai63yMS9HBlW9Q1vmMRZc1cKTw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jqvLs-008L2R-4Q; Thu, 02 Jul 2020 10:17:52 +0100
MIME-Version: 1.0
Date: Thu, 02 Jul 2020 10:17:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: Jingyi Wang <wangjingyi11@huawei.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
In-Reply-To: <a570c59c-965f-8832-b0c3-4cfc342f18fe@huawei.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <fe9699e3ee2131fe800911aea1425af4@kernel.org>
 <a570c59c-965f-8832-b0c3-4cfc342f18fe@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <10c3562dc019a3440d82dd507918faef@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangjingyi11@huawei.com, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

T24gMjAyMC0wNy0wMiAxMDowMiwgSmluZ3lpIFdhbmcgd3JvdGU6Cj4gSGkgTWFyYywKPiAKPiBP
biA3LzIvMjAyMCA0OjIyIFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IE9uIDIwMjAtMDctMDIg
MDQ6MDEsIEppbmd5aSBXYW5nIHdyb3RlOgo+Pj4gSWYgZ2ljdjQuMShzZ2kgaGFyZHdhcmUgaW5q
ZWN0aW9uKSBzdXBwb3J0ZWQsIHdlIHRlc3QgaXBpIGluamVjdGlvbgo+Pj4gdmlhIGh3L3N3IHdh
eSBzZXBhcmF0ZWx5Lgo+PiAKPj4gbml0OiBhY3RpdmUtbGVzcyBTR0lzIGFyZSBub3Qgc3RyaWN0
bHkgYSBmZWF0dXJlIG9mIEdJQ3Y0LjEgKHlvdSBjb3VsZAo+PiBpbWFnaW5lIGEgR0lDIGVtdWxh
dGlvbiBvZmZlcmluZyB0aGUgc2FtZSB0aGluZykuIEZ1cnRoZXJtb3JlLCBHSUN2NC4xCj4+IGlz
bid0IGFzIHN1Y2ggdmlzaWJsZSB0byB0aGUgZ3Vlc3QgaXRzZWxmIChpdCBvbmx5IHNlZXMgYSBH
SUN2MykuCj4+IAo+PiBUaGFua3MsCj4+IAo+PiAgwqDCoMKgwqDCoMKgwqAgTS4KPiAKPiBZZXMs
IGJ1dCB0byBtZWFzdXJlIHRoZSBwZXJmb3JtYW5jZSBkaWZmZXJlbmNlIG9mIGh3L3N3IFNHSSBp
bmplY3Rpb24sCj4gZG8geW91IHRoaW5rIGl0IGlzIGFjY2VwdGFibGUgdG8gbWFrZSBpdCB2aXNp
YmxlIHRvIGd1ZXN0IGFuZCBsZXQgaXQKPiBzd2l0Y2ggU0dJIGluamVjdGlvbiBtb2RlPwoKSXQg
aXMgb2YgY291cnNlIGFjY2VwdGFibGUuIEkgc2ltcGx5IG9iamVjdCB0byB0aGUgIkdJQ3Y0LjEi
IApkZXNjcmlwdGlvbi4KCiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0
IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
