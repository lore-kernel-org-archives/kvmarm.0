Return-Path: <SRS0=hKGY=6M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D2CC83000
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 16:45:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4B1C2063A
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 16:45:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=openpandora.org header.i=@openpandora.org header.b="pLFyr0wm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4B1C2063A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=openpandora.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A7454B23F;
	Tue, 28 Apr 2020 12:45:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(invalid, public key: not available) header.i=@openpandora.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BNqkIMrKPexv; Tue, 28 Apr 2020 12:44:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E81554B245;
	Tue, 28 Apr 2020 12:44:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F2594B2BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 10:26:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dioAAzEIXZoo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2020 10:26:27 -0400 (EDT)
Received: from rhea.dragonbox.de (rhea.dragonbox.de [95.216.39.121])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7D364B266
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 10:26:27 -0400 (EDT)
Received: from bigevilshop (p4FC9321D.dip0.t-ipconnect.de [79.201.50.29])
 (Authenticated sender: evildragon@openpandora.org)
 by rhea.dragonbox.de (Postfix) with ESMTPSA id AA572780531;
 Tue, 28 Apr 2020 16:26:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=openpandora.org;
 s=2020; t=1588083985;
 bh=Cp1GbbIebWOVj7lHaBObu5tJ0h8gF9t75KwpoxSij4Q=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
 b=pLFyr0wmRBqIDAcf4G7s469wh45tFiC4VymgSYgv6+KCx9fklNhqG845wd/rsorJH
 UL94zxxdnCX0wxw+iKLzw9QzeIk/diWb0RWXIvfufEuE4qcD7+rU/2Fwh22X1Dud6q
 tvuPq7UpvRs/KuCuzzk+gJ/jjks9mXBa6QF8Lr1bppFFHX+JFRmT8qbd6ooTRwWkBS
 t0a/4T3hX8eWFW/OpMXQKKEXj+2pMln4R9/t/1DaTnQIGih73TMdpzaKnpjW46eSmk
 3rcqkczSF3k+wv0UbIP65h1ZEyB22LBi61x3XTrZ/qFBJ0yfosGXIg9xGEcnSCePFg
 qHnHWojPihVrQ==
Message-ID: <9c67a3722611d1ec9fe1e8a1fbe65956b32147c3.camel@openpandora.org>
Subject: Re: Against removing aarch32 kvm host support
From: Michael Mrozek <EvilDragon@openpandora.org>
To: Marc Zyngier <maz@kernel.org>, Lukas Straub <lukasstraub2@web.de>
Date: Tue, 28 Apr 2020 16:26:05 +0200
In-Reply-To: <916b6072a4a2688745a5e3f75c1c8c01@misterjones.org>
References: <20200428143850.4c8cbd2a@luklap>
 <916b6072a4a2688745a5e3f75c1c8c01@misterjones.org>
User-Agent: Evolution 3.36.1 
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 28 Apr 2020 12:44:58 -0400
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel@pyra-handheld.com
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

QW0gRGllbnN0YWcsIGRlbiAyOC4wNC4yMDIwLCAxNDozMCArMDEwMCBzY2hyaWViIE1hcmMgWnlu
Z2llcjoKCkhpLAoKd2VsbCwgdGhlIFBDQnMgYXJlIGN1cnJlbnRseSBpbiBwcm9kdWN0aW9uLCB0
aGUgY2FzZXMgYXJlIGFscmVhZHkgaGVyZSAoY29hdGluZwppcyBjdXJyZW50bHkgYmVpbmcgZGVs
YXllZCBhcyB0aGUgY29tcGFueSBoYXMgY2xvc2VkIGRvd24gZHVlIHRvIENvcm9uYSByaWdodApu
b3cpLCBzbyB0aGUgZmlyc3QgNTAwIHVuaXRzIHdvdWxkIGJlIHJlYWR5IHRvIGJlIHNoaXBwZWQg
aW4gYXJvdW5kIDIgLSAzIG1vbnRocwphdCBsYXRlc3QuCgpUaGUgbm9uLWV4aXN0YW5jZSBwcm9i
bGVtIHdvdWxkIHRoZXJlZm9yZSBiZSBzb2x2ZWQgdGhlbi4KClNvIGZhciwgQUZBSUssIHRoZSBM
ZXR1eCB0ZWFtIGhhcyB0cmllZCB0aGVpciBiZXN0IHRvIGdldCBhcyBjbG9zZSB0byBwb3NzaWJs
ZQp0byBtYWlubGluZSBrZXJuZWwgYW5kIHN1cHBvcnQgYXMgbWFueSBjbGFzc2ljIGRldmljZXMg
KE9NQVAzIGFuZCBPTUFQNCBkZXZpY2VzCmFzIHdlbGwpLCBzbyByZW1vdmluZyAzMmJpdCBzdXBw
b3J0IGZyb20gbWFpbmxpbmUgd291bGQgc3VyZWx5IGJlIGEgc3RlcCBiYWNrCmZvciBhIGxvdCBv
ZiBvbGRlciBkZXZpY2VzIGFzIHdlbGwuCgpJIGtub3cgd2UgaGF2ZSB0byBhY2NlcHQgdGhlIGRl
Y2lzaW9uLCBidXQgc28gZmFyLCBJJ3ZlIGtub3duIExpbnV4IHRvIHN1cHBvcnQKYXMgbWFueSBv
bGRlciBkZXZpY2VzIGFzIHBvc3NpYmxlIGFzIHdlbGwgLSByZW1vdmluZyBLVk0gSG9zdCAzMmJp
dCBzdXBwb3J0CndvdWxkIGJlIGEgc3RlcCBiYWNrIGhlcmUuCgpJcyB0aGVyZSBhIHNwZWNpZmlj
IHJlYXNvbiBmb3IgdGhhdD8KSXMgaXQgdG9vIGNvbXBsZXggdG8gbWFpbnRhaW4gYWxvbmdzaWRl
IHRoZSBhYXJjaDY0IEtWTSBIb3N0PwoKPiBIaSBMdWthcywKPiAKPiBUaGFua3MgZm9yIHlvdXIg
ZW1haWwuCj4gCj4gT24gMjAyMC0wNC0yOCAxMzozOCwgTHVrYXMgU3RyYXViIHdyb3RlOgo+ID4g
SGVsbG8gRXZlcnlvbmUsCj4gPiBBcyBhIHByZW9yZGVyIG9mIHRoZSBQeXJhIGhhbmRoZWxkLCAo
T01BUDUgU29DIHdpdGggMnggY29ydGV4LWExNSBhcm0gCj4gPiBjb3JlcykKPiA+IEknbSBhZ2Fp
bnN0IHJlbW92aW5nIEtWTSBob3N0IHN1cHBvcnQgZm9yIGFhcmNoMzIuIEknbSBwcm9iYWJseSBn
b2luZyAKPiA+IHRvIHVzZQo+ID4gdGhpcyBkZXZpY2UgZm9yIG1vcmUgdGhhbiA1IHllYXJzIGFu
ZCB0aHVzIHRoZSBsYXRlc3QgbHRzLWtlcm5lbCBpcyBubyAKPiA+IG9wdGlvbgo+ID4gZm9yIG1l
Lgo+IAo+IFNvIGxldCBtZSBzcGVsbCBpdCBvdXQuIFlvdSBhcmUgYWdhaW5zdCB0aGUgcmVtb3Zh
bCBvZiBhIGZlYXR1cmUgdGhhdCAKPiB5b3UgZG9uJ3QKPiB1c2UgeWV0LCB0aGF0IHlvdSBtYXkg
b2YgbWF5IG5vdCB1c2Ugb24gYSBkZXZpY2UgdGhhdCBkb2Vzbid0IGV4aXN0IHlldCwgCj4gd2hp
Y2gKPiB5b3UgbWF5IG9yIG1heSBub3Qgc3RpbGwgYmUgdXNpbmcgYnkgdGhlIHRpbWUgNS40LzUu
NiBhcmVuJ3Qgc3VwcG9ydGVkIAo+IGFueW1vcmUuCj4gWW91IGRvbid0IHNlZW0gdG8gaGF2ZSB0
aGUgc3Ryb25nZXN0IGNhc2UsIEknbSBhZnJhaWQuCj4gCj4gQnV0IG5vdGhpbmcgaXMgbG9zdCEg
VGhlIGNvZGUgaXMgc3RpbGwgaW4gdGhlIGdpdCB0cmVlLCBvdSBjYW4gYWx3YXlzIAo+IHJldmVy
dAo+IHRoZSByZW1vdmFsIHBhdGNoZXMgYW5kIHJldml2ZSB0aGUgcG9ydCBpZiB5b3UgYXJlIHNv
IGluY2xpbmVkLiBJdCB3aWxsIAo+IGp1c3QgbmVlZAo+IHRvIGJlIHN0YW5kLWFsb25lLCBhbmQg
bm90IGRlcGVuZCBvbiB0aGUgYXJtNjQgY29kZSwgd2hpY2ggaXMgbm93IAo+IGV2b2x2aW5nIGl0
cyBvd24KPiBzZXBhcmF0ZSB3YXkuCj4gCj4gQ2hlZXJzLAo+IAo+ICAgICAgICAgIE0uCi0tIApN
aXQgZnJldW5kbGljaGVuIEdyw7zDn2VuLAoKTWljaGFlbCBNcm96ZWsKCi0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tCk9wZW5QYW5kb3JhIEdtYkgKR2VzY2jDpGZ0c2bDvGhyZXI6IE1pY2hhZWwgTXJv
emVrCgpTY2jDpGZmYnLDpHVzdHIuIDExCjg1MDQ5IEluZ29sc3RhZHQKRGV1dHNjaGxhbmQKVGVs
LjogMDg0MSAvIDk5MCA1NTQ4Cmh0dHA6Ly93d3cub3BlbnBhbmRvcmEuZGUvCkhSQiA0ODc5LCBB
bXRzZ2VyaWNodCBJbmdvbHN0YWR0Ci0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCmVNYWlsOiBtcm96
ZWtAb3BlbnBhbmRvcmEub3JnCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
