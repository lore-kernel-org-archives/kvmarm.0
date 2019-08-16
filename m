Return-Path: <SRS0=WQBf=WM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8053FC3A59C
	for <kvmarm@archiver.kernel.org>; Fri, 16 Aug 2019 15:23:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11E4C206C1
	for <kvmarm@archiver.kernel.org>; Fri, 16 Aug 2019 15:23:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11E4C206C1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F104A586;
	Fri, 16 Aug 2019 11:23:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zajWzLwAY91g; Fri, 16 Aug 2019 11:23:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 603C94A4F6;
	Fri, 16 Aug 2019 11:23:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C112C4A4F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Aug 2019 11:23:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lsVvQBVjK5+H for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Aug 2019 11:23:22 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C1C34A4F5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Aug 2019 11:23:22 -0400 (EDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
 (envelope-from <bigeasy@linutronix.de>)
 id 1hye4U-0003nz-Ii; Fri, 16 Aug 2019 17:23:18 +0200
Date: Fri, 16 Aug 2019 17:23:18 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Julien Grall <julien.grall@arm.com>
Subject: Re: KVM Arm64 and Linux-RT issues
Message-ID: <20190816152317.pbhctfiyurjrepju@linutronix.de>
References: <b9867c43-7fe3-5d64-9939-b1a7ab7f1061@arm.com>
 <cd310858-2c0f-6af1-bf82-ee1e01a2cfb8@arm.com>
 <alpine.DEB.2.21.1907270053360.1791@nanos.tec.linutronix.de>
 <86zhkzn319.wl-maz@kernel.org>
 <960b5ed1-6d0f-3cee-da37-6061b4946c1a@arm.com>
 <20190813125835.5v26s4iuv44lw2xg@linutronix.de>
 <adc0b2e2-3a2e-5685-8eb5-2ce927d2139e@arm.com>
 <865zn1nidx.wl-maz@kernel.org>
 <1f76c277-665a-e962-8cbe-b3c4ecad41b0@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1f76c277-665a-e962-8cbe-b3c4ecad41b0@arm.com>
User-Agent: NeoMutt/20180716
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, anna-maria@linutronix.de,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAxOS0wOC0xNiAxNjoxODoyMCBbKzAxMDBdLCBKdWxpZW4gR3JhbGwgd3JvdGU6Cj4gU2Fk
bHksIEkgbWFuYWdlZCB0byBoaXQgdGhlIHNhbWUgQlVHX09OKCkgdG9kYXkgd2l0aCB0aGlzIHBh
dGNoCj4gYXBwbGllZCBvbiB0b3AgdjUuMi1ydDEtcmViYXNlLiA6LyBBbHRob3VnaCwgaXQgaXMg
bW9yZSBkaWZmaWN1bHQKPiB0byBoaXQgdGhhbiBwcmV2aW91c2x5Lgo+IAo+IFsgIDE1Ny40NDk1
NDVdIDAwMDogQlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZhbGlkIGNvbnRl
eHQgYXQga2VybmVsL2xvY2tpbmcvcnRtdXRleC5jOjk2OAo+IFsgIDE1Ny40NDk1NjldIDAwMDog
aW5fYXRvbWljKCk6IDEsIGlycXNfZGlzYWJsZWQoKTogMCwgcGlkOiA5OTAsIG5hbWU6IGt2bS12
Y3B1LTEKPiBbICAxNTcuNDQ5NTc5XSAwMDA6IDIgbG9ja3MgaGVsZCBieSBrdm0tdmNwdS0xLzk5
MDoKPiBbICAxNTcuNDQ5NTkyXSAwMDA6ICAjMDogMDAwMDAwMDBjMmZjODIxNyAoJnZjcHUtPm11
dGV4KXsrLisufSwgYXQ6IGt2bV92Y3B1X2lvY3RsKzB4NzAvMHhhZTAKPiBbICAxNTcuNDQ5NjM4
XSAwMDA6ICAjMTogMDAwMDAwMDA5Njg2MzgwMSAoJmNwdV9iYXNlLT5zb2Z0aXJxX2V4cGlyeV9s
b2NrKXsrLisufSwgYXQ6IGhydGltZXJfZ3JhYl9leHBpcnlfbG9jaysweDI0LzB4NDAKPiBbICAx
NTcuNDQ5Njc3XSAwMDA6IFByZWVtcHRpb24gZGlzYWJsZWQgYXQ6Cj4gWyAgMTU3LjQ0OTY3OV0g
MDAwOiBbPGZmZmYwMDAwMTExYTQ1Mzg+XSBzY2hlZHVsZSsweDMwLzB4ZDgKPiBbICAxNTcuNDQ5
NzAyXSAwMDA6IENQVTogMCBQSUQ6IDk5MCBDb21tOiBrdm0tdmNwdS0xIFRhaW50ZWQ6IEcgICAg
ICAgIFcgNS4yLjAtcnQxLTAwMDAxLWdkMzY4MTM5ZTg5MmYgIzEwNAo+IFsgIDE1Ny40NDk3MTJd
IDAwMDogSGFyZHdhcmUgbmFtZTogQVJNIExURCBBUk0gSnVubyBEZXZlbG9wbWVudCBQbGF0Zm9y
bS9BUk0gSnVubyBEZXZlbG9wbWVudCBQbGF0Zm9ybSwgQklPUyBFREsgSUkgSmFuIDIzIDIwMTcK
PiBbICAxNTcuNDQ5NzE4XSAwMDA6IENhbGwgdHJhY2U6Cj4gWyAgMTU3LjQ0OTcyMl0gMDAwOiAg
ZHVtcF9iYWNrdHJhY2UrMHgwLzB4MTMwCj4gWyAgMTU3LjQ0OTczMF0gMDAwOiAgc2hvd19zdGFj
aysweDE0LzB4MjAKPiBbICAxNTcuNDQ5NzM4XSAwMDA6ICBkdW1wX3N0YWNrKzB4YmMvMHgxMDQK
PiBbICAxNTcuNDQ5NzQ3XSAwMDA6ICBfX19taWdodF9zbGVlcCsweDE5OC8weDIzOAo+IFsgIDE1
Ny40NDk3NTZdIDAwMDogIHJ0X3NwaW5fbG9jaysweDVjLzB4NzAKPiBbICAxNTcuNDQ5NzY1XSAw
MDA6ICBocnRpbWVyX2dyYWJfZXhwaXJ5X2xvY2srMHgyNC8weDQwCj4gWyAgMTU3LjQ0OTc3M10g
MDAwOiAgaHJ0aW1lcl9jYW5jZWwrMHgxYy8weDM4Cj4gWyAgMTU3LjQ0OTc4MF0gMDAwOiAga3Zt
X3RpbWVyX3ZjcHVfbG9hZCsweDc4LzB4M2UwCgrigKYKPiBJIHdpbGwgZG8gc29tZSBkZWJ1ZyBh
bmQgc2VlIHdoYXQgSSBjYW4gZmluZC4KCndoaWNoIHRpbWVyIGlzIHRoaXM/IElzIHRoZXJlIGFu
b3RoZXIgb25lPwpJbiB0aGUgbWVhbnRpbWUgSSBkbyBhIHJlbGVhc2Ugd2l0aCB0aGF0IHBhdGNo
IGluY2x1ZGVkLgoKPiAKPiBDaGVlcnMsCgpTZWJhc3RpYW4KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
