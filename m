Return-Path: <SRS0=hKGY=6M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E8DC83000
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 16:39:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ADE48208E0
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 16:39:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3O5HAnG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADE48208E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4093D4B1E5;
	Tue, 28 Apr 2020 12:39:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iXBIgnMS6KV1; Tue, 28 Apr 2020 12:39:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B56194B21B;
	Tue, 28 Apr 2020 12:39:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A9034B215
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 12:39:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xuk5PovVJxhp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2020 12:39:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1986A4B1E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 12:39:27 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id F2E12206D6;
 Tue, 28 Apr 2020 16:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588091966;
 bh=8RpWHwtl4RZqT1ZbuFdwUYbYF9iOnIhy5wLRan7Ele0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=C3O5HAnG/zI1EGbjpMSLFe4PPxjQXabbbGgb9/ZXUha0QkwEz2h9CJvqtGWWD//7q
 UqNTUwFQ9bNLrNTP5PiiThvSwqZxl2lJG1893SB4WE+ax/9unkmYml66+Suxe/7MgL
 n0o8XYwfyFRJMUv5hbxlnekwyonUpKdOGUuo1o2c=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jTTGW-007QwJ-AY; Tue, 28 Apr 2020 17:39:24 +0100
MIME-Version: 1.0
Date: Tue, 28 Apr 2020 17:39:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: Michael Mrozek <EvilDragon@openpandora.org>
Subject: Re: Against removing aarch32 kvm host support
In-Reply-To: <9c67a3722611d1ec9fe1e8a1fbe65956b32147c3.camel@openpandora.org>
References: <20200428143850.4c8cbd2a@luklap>
 <916b6072a4a2688745a5e3f75c1c8c01@misterjones.org>
 <9c67a3722611d1ec9fe1e8a1fbe65956b32147c3.camel@openpandora.org>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <f5c18fe4ca1d0cc3de5723b82ca4dafc@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: EvilDragon@openpandora.org, lukasstraub2@web.de,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel@pyra-handheld.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lukas Straub <lukasstraub2@web.de>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel@pyra-handheld.com
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

TWljaGFlbCwKCk9uIDIwMjAtMDQtMjggMTU6MjYsIE1pY2hhZWwgTXJvemVrIHdyb3RlOgo+IEFt
IERpZW5zdGFnLCBkZW4gMjguMDQuMjAyMCwgMTQ6MzAgKzAxMDAgc2NocmllYiBNYXJjIFp5bmdp
ZXI6Cj4gCj4gSGksCj4gCj4gd2VsbCwgdGhlIFBDQnMgYXJlIGN1cnJlbnRseSBpbiBwcm9kdWN0
aW9uLCB0aGUgY2FzZXMgYXJlIGFscmVhZHkgaGVyZSAKPiAoY29hdGluZwo+IGlzIGN1cnJlbnRs
eSBiZWluZyBkZWxheWVkIGFzIHRoZSBjb21wYW55IGhhcyBjbG9zZWQgZG93biBkdWUgdG8gQ29y
b25hIAo+IHJpZ2h0Cj4gbm93KSwgc28gdGhlIGZpcnN0IDUwMCB1bml0cyB3b3VsZCBiZSByZWFk
eSB0byBiZSBzaGlwcGVkIGluIGFyb3VuZCAyIC0gCj4gMyBtb250aHMKPiBhdCBsYXRlc3QuCj4g
Cj4gVGhlIG5vbi1leGlzdGFuY2UgcHJvYmxlbSB3b3VsZCB0aGVyZWZvcmUgYmUgc29sdmVkIHRo
ZW4uCgpBbmQgdGhlbj8gQXJlIHRoZXNlIDUwMCBtYWNoaW5lcyBnb2luZyB0byBiZSBpbnN0YW50
bHkgdHVybmVkIGludG8gCnByb2R1Y3Rpb24gS1ZNCmhvc3RzPyBPdmVyIDcgeWVhcnMsIHdlIGhh
dmUgaWRlbnRpZmllZCBhdCBtb3N0ICpmb3VyKiB1c2Vycy4gRm91ciB1c2VycyAKb3ZlciBhCmZl
dyBiaWxsaW9uIDMyYml0IEFSTSBkZXZpY2VzIHJ1bm5pbmcgTGludXguIFdoYXQgYXJlIHRoZSBv
ZGRzIHRoYXQgeW91IAp3aWxsCmFjdHVhbGx5IHVzZSBLVk0gaW4gYW55IHNpZ25pZmljYW50IHdh
eT8gTm9uZSB3aGF0c29ldmVyLgoKPiBTbyBmYXIsIEFGQUlLLCB0aGUgTGV0dXggdGVhbSBoYXMg
dHJpZWQgdGhlaXIgYmVzdCB0byBnZXQgYXMgY2xvc2UgdG8gCj4gcG9zc2libGUKPiB0byBtYWlu
bGluZSBrZXJuZWwgYW5kIHN1cHBvcnQgYXMgbWFueSBjbGFzc2ljIGRldmljZXMgKE9NQVAzIGFu
ZCBPTUFQNCAKPiBkZXZpY2VzCj4gYXMgd2VsbCksIHNvIHJlbW92aW5nIDMyYml0IHN1cHBvcnQg
ZnJvbSBtYWlubGluZSB3b3VsZCBzdXJlbHkgYmUgYSAKPiBzdGVwIGJhY2sKPiBmb3IgYSBsb3Qg
b2Ygb2xkZXIgZGV2aWNlcyBhcyB3ZWxsLgoKUmVhZCB0aGUgYWJvdmUuIE5vIHVzZXJzLiBXaGlj
aCBtZWFucyB0aGF0IEtWTS9hcm0gaXMgdW50ZXN0ZWQgYW5kIGlzIApqdXN0CmJpdC1yb3R0aW5n
LiBJdCBpcyBhbHNvIGluY29tcGxldGUgYW5kIG5vYm9keSBpcyBpbnRlcmVzdGVkIGluIHB1dHRp
bmcgCnRoZQpyZXF1aXJlZCBlZmZvcnQgdG8gaGVscCBpdCBtb3ZpbmcgZm9yd2FyZC4gSGVsbCwg
dGhlIHdob2xlIEFSTSBwb3J0IGlzIApub3cKb24gbGlmZSBzdXBwb3J0LCBhbmQgeW91IHdvcnJ5
IGFib3V0IEtWTT8KCj4gSSBrbm93IHdlIGhhdmUgdG8gYWNjZXB0IHRoZSBkZWNpc2lvbiwgYnV0
IHNvIGZhciwgSSd2ZSBrbm93biBMaW51eCB0byAKPiBzdXBwb3J0Cj4gYXMgbWFueSBvbGRlciBk
ZXZpY2VzIGFzIHBvc3NpYmxlIGFzIHdlbGwgLSByZW1vdmluZyBLVk0gSG9zdCAzMmJpdCAKPiBz
dXBwb3J0Cj4gd291bGQgYmUgYSBzdGVwIGJhY2sgaGVyZS4KCkxpbnV4IGlzIGtub3duIHRvIHN1
cHBvcnQgYXMgbWFueSAqdXNlZnVsKiBkZXZpY2VzIGFuZCBmZWF0dXJlcyBhcyAKcG9zc2libGUu
CktWTSBpc24ndCBvbmUgb2YgdGhlbS4KCj4gSXMgdGhlcmUgYSBzcGVjaWZpYyByZWFzb24gZm9y
IHRoYXQ/CgpQbGVhc2UgcmVhZCB0aGUgdGhyZWFkcyBvbiB0aGUgc3ViamVjdC4KCj4gSXMgaXQg
dG9vIGNvbXBsZXggdG8gbWFpbnRhaW4gYWxvbmdzaWRlIHRoZSBhYXJjaDY0IEtWTSBIb3N0PwoK
SXQgY2VydGFpbmx5IGdldHMgaW4gdGhlIHdheSBvZiBtYWtpbmcgc2lnbmlmaWNhbnQgY2hhbmdl
cyB0byB0aGUgYXJtNjQgCnBvcnQuCgpBbmQgYXMgSSBzYWlkLCBmZWVsIGZyZWUgdG8gcmV2aXZl
IHRoZSBwb3J0IGFueXRpbWUuIFRoZSBjb2RlIGlzIHN0aWxsIAp0aGVyZSwKdGhlIGRvY3VtZW50
YXRpb24gYXZhaWxhYmxlLCBhbmQgeW91J3JlIGx1Y2t5IGVub3VnaCB0byBoYXZlIG9uZSBvZiB0
aGUgCmZldwptYWNoaW5lcyBjYXBhYmxlIG9mIHZpcnR1YWxpemF0aW9uLiBJZiBhbGwgb2YgYSBz
dWRkZW4geW91IGVuZC11cCAKZmluZGluZwp0aGUga2lsbGVyIHVzZSBjYXNlIGZvciBLVk0vYXJt
LCBJJ2xsIGFwcGxhdWQgaXRzIHJldHVybi4gSW4gdGhlIAptZWFudGltZSwKdGhlIGFybTY0IHdp
bGwgYmUgYWJsZSB0byBtb3ZlIGF0IGEgbXVjaCBmYXN0ZXIgcGFjZS4gQXMgaXQgdHVybnMgb3V0
LAppdCBoYXMgYWN0dWFsIHVzZXJzLgoKVGhhbmtzLAoKICAgICAgIE0uCgo+IAo+PiBIaSBMdWth
cywKPj4gCj4+IFRoYW5rcyBmb3IgeW91ciBlbWFpbC4KPj4gCj4+IE9uIDIwMjAtMDQtMjggMTM6
MzgsIEx1a2FzIFN0cmF1YiB3cm90ZToKPj4gPiBIZWxsbyBFdmVyeW9uZSwKPj4gPiBBcyBhIHBy
ZW9yZGVyIG9mIHRoZSBQeXJhIGhhbmRoZWxkLCAoT01BUDUgU29DIHdpdGggMnggY29ydGV4LWEx
NSBhcm0KPj4gPiBjb3JlcykKPj4gPiBJJ20gYWdhaW5zdCByZW1vdmluZyBLVk0gaG9zdCBzdXBw
b3J0IGZvciBhYXJjaDMyLiBJJ20gcHJvYmFibHkgZ29pbmcKPj4gPiB0byB1c2UKPj4gPiB0aGlz
IGRldmljZSBmb3IgbW9yZSB0aGFuIDUgeWVhcnMgYW5kIHRodXMgdGhlIGxhdGVzdCBsdHMta2Vy
bmVsIGlzIG5vCj4+ID4gb3B0aW9uCj4+ID4gZm9yIG1lLgo+PiAKPj4gU28gbGV0IG1lIHNwZWxs
IGl0IG91dC4gWW91IGFyZSBhZ2FpbnN0IHRoZSByZW1vdmFsIG9mIGEgZmVhdHVyZSB0aGF0Cj4+
IHlvdSBkb24ndAo+PiB1c2UgeWV0LCB0aGF0IHlvdSBtYXkgb2YgbWF5IG5vdCB1c2Ugb24gYSBk
ZXZpY2UgdGhhdCBkb2Vzbid0IGV4aXN0IAo+PiB5ZXQsCj4+IHdoaWNoCj4+IHlvdSBtYXkgb3Ig
bWF5IG5vdCBzdGlsbCBiZSB1c2luZyBieSB0aGUgdGltZSA1LjQvNS42IGFyZW4ndCBzdXBwb3J0
ZWQKPj4gYW55bW9yZS4KPj4gWW91IGRvbid0IHNlZW0gdG8gaGF2ZSB0aGUgc3Ryb25nZXN0IGNh
c2UsIEknbSBhZnJhaWQuCj4+IAo+PiBCdXQgbm90aGluZyBpcyBsb3N0ISBUaGUgY29kZSBpcyBz
dGlsbCBpbiB0aGUgZ2l0IHRyZWUsIG91IGNhbiBhbHdheXMKPj4gcmV2ZXJ0Cj4+IHRoZSByZW1v
dmFsIHBhdGNoZXMgYW5kIHJldml2ZSB0aGUgcG9ydCBpZiB5b3UgYXJlIHNvIGluY2xpbmVkLiBJ
dCAKPj4gd2lsbAo+PiBqdXN0IG5lZWQKPj4gdG8gYmUgc3RhbmQtYWxvbmUsIGFuZCBub3QgZGVw
ZW5kIG9uIHRoZSBhcm02NCBjb2RlLCB3aGljaCBpcyBub3cKPj4gZXZvbHZpbmcgaXRzIG93bgo+
PiBzZXBhcmF0ZSB3YXkuCj4+IAo+PiBDaGVlcnMsCj4+IAo+PiAgICAgICAgICBNLgo+IC0tCj4g
TWl0IGZyZXVuZGxpY2hlbiBHcsO8w59lbiwKPiAKPiBNaWNoYWVsIE1yb3plawo+IAo+IC0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tCj4gT3BlblBhbmRvcmEgR21iSAo+IEdlc2Now6RmdHNmw7xocmVy
OiBNaWNoYWVsIE1yb3plawo+IAo+IFNjaMOkZmZicsOkdXN0ci4gMTEKPiA4NTA0OSBJbmdvbHN0
YWR0Cj4gRGV1dHNjaGxhbmQKPiBUZWwuOiAwODQxIC8gOTkwIDU1NDgKPiBodHRwOi8vd3d3Lm9w
ZW5wYW5kb3JhLmRlLwo+IEhSQiA0ODc5LCBBbXRzZ2VyaWNodCBJbmdvbHN0YWR0Cj4gLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0KPiBlTWFpbDogbXJvemVrQG9wZW5wYW5kb3JhLm9yZwoKLS0gCkph
enogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
