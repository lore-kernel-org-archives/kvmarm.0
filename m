Return-Path: <SRS0=UwAz=HY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BB4C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 09:47:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E7AD64E5F
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 09:47:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E7AD64E5F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBD404B164;
	Mon, 22 Feb 2021 04:47:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XWvR1O4oYLGP; Mon, 22 Feb 2021 04:47:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD4674B16E;
	Mon, 22 Feb 2021 04:47:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97FB54B164
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 04:47:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UCq9vD6mYjm9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Feb 2021 04:47:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DAD24B144
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 04:47:10 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 910C564E2F;
 Mon, 22 Feb 2021 09:47:08 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lE7o2-00FI1i-EN; Mon, 22 Feb 2021 09:47:06 +0000
MIME-Version: 1.0
Date: Mon, 22 Feb 2021 09:47:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.ne@posteo.net>
Subject: Re: [PATCH v7 23/23] [DO NOT MERGE] arm64: Cope with CPUs stuck in
 VHE mode
In-Reply-To: <YDN6BtDhzmF5OtBO@latitude>
References: <20210208095732.3267263-1-maz@kernel.org>
 <20210208095732.3267263-24-maz@kernel.org> <YDN6BtDhzmF5OtBO@latitude>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <4d4e9a5cff65dbd8861f829089f570e5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: j.ne@posteo.net, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 psodagud@codeaurora.org, sramana@codeaurora.org, catalin.marinas@arm.com,
 marcan@marcan.st, pajay@qti.qualcomm.com, kernel-team@android.com,
 will@kernel.org, ardb@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Hector Martin <marcan@marcan.st>,
 linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Will Deacon <will@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 Prasad Sodagudi <psodagud@codeaurora.org>, kernel-team@android.com,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgSm9uYXRoYW4sCgpPbiAyMDIxLTAyLTIyIDA5OjM1LCBKb25hdGhhbiBOZXVzY2jDpGZlciB3
cm90ZToKPiBIaSwKPiAKPiBPbiBNb24sIEZlYiAwOCwgMjAyMSBhdCAwOTo1NzozMkFNICswMDAw
LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IEl0IHNlZW1zIHRoYXQgdGhlIENQVSBrbm93biBhcyBB
cHBsZSBNMSBoYXMgdGhlIHRlcnJpYmxlIGhhYml0Cj4+IG9mIGJlaW5nIHN0dWNrIHdpdGggSENS
X0VMMi5FMkg9PTEsIGluIHZpb2xhdGlvbiBvZiB0aGUgYXJjaGl0ZWN0dXJlLgo+IAo+IE1pbm9y
IG5pdHBpY2sgZnJvbSB0aGUgc2lkZWxpbmU6IFRoZSBNMSBTb0MgaGFzIHR3byBraW5kcyBvZiBD
UFUgaW4gaXQKPiAoSWNlc3Rvcm0gYW5kIEZpcmVzdG9ybSksIHdoaWNoIG1ha2VzICJDUFUga25v
d24gYXMgQXBwbGUgTTEiIGEgYml0Cj4gaW1wcmVjaXNlLgoKRmFpciBlbm91Z2guIEhvdyBhYm91
dCBzb21ldGhpbmcgYWxvbmcgdGhlIGxpbmVzIG9mOgoiQXQgbGVhc3Qgc29tZSBvZiB0aGUgQ1BV
cyBpbnRlZ3JhdGVkIGluIHRoZSBBcHBsZSBNMSBTb0MgaGF2ZQogIHRoZSB0ZXJyaWJsZSBoYWJp
dC4uLiIKCj4gSW4gcHJhY3RpY2FsaXR5IGl0IHNlZW1zIHVubGlrZWx5IHRob3VnaCwgdGhhdCBJ
Y2VzdG9ybSBhbmQgRmlyZXN0b3JtCj4gYWN0IGRpZmZlcmVudGx5IHdpdGggcmVnYXJkcyB0byB0
aGUgY29kZSBpbiB0aGlzIHBhdGNoLgoKVGhpcyBpcyBteSBodW5jaCBhcyB3ZWxsLiBBbmQgaWYg
dGhleSBkaWQsIGl0IHNob3VsZG4ndCBiZSBhIGJpZyBkZWFsOgp0aGUgImFyY2hpdGVjdHVyZSBj
b21wbGlhbnQiIENQVXMgd291bGQgc2ltcGx5IHRyYW5zaXRpb24gdmlhIEVMMQphcyBleHBlY3Rl
ZCwgYW5kIGpvaW4gdGhlaXIgYnVnZ3kgZnJpZW5kcyBydW5uaW5nIGF0IEVMMiBzbGlnaHRseSBs
YXRlci4KClRoYW5rcywKCiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0
IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
