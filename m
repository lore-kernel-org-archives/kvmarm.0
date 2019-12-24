Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A00FC2D0C3
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 04:45:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 953D7206CB
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 04:45:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IODJAb5Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 953D7206CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0762A4AF31;
	Mon, 23 Dec 2019 23:45:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TMcOxj0IIJZ1; Mon, 23 Dec 2019 23:45:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26DFF4AF25;
	Mon, 23 Dec 2019 23:45:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E53D4AF25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 23:45:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TdzncZQyf1EW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Dec 2019 23:45:36 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7836A4AF23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 23:45:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1577162736;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0QvQOGSsD6BCQ/KZZeRtn8Sn6aNp+vhwPhxNJ2ctz9g=;
 b=IODJAb5YkV0f/9y3hJkAi4RdgBm3yBq2CGIGecVmP9qsSYVFQbDe7hOVw0H4GRr7NRRmNP
 XP7bFgEtc46+ZIjfx+LDaVtnwxC6S7+3RVnATbERivPoOyo9waq3Jfl7Z3QWOdBNldpvms
 RFMtGxi8gSq+yfkShllvsInz9rJURe4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-Hoek3P4zOCSlBGu07fty_A-1; Mon, 23 Dec 2019 23:45:32 -0500
X-MC-Unique: Hoek3P4zOCSlBGu07fty_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAEBB184B461;
 Tue, 24 Dec 2019 04:45:30 +0000 (UTC)
Received: from [10.36.116.117] (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 141505DA60;
 Tue, 24 Dec 2019 04:45:20 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Handle GICR_PENDBASER.PTZ filed as
 RAZ
To: Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
References: <20191220111833.1422-1-yuzenghui@huawei.com>
 <3a729559-d0eb-e042-d6bd-b69bacb0dd23@huawei.com>
 <c084aa29c029f97cdfb1b5dc9e6b29ac@www.loen.fr>
 <1225d839-3cf7-d513-778e-698e12e94875@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <12a1e25b-617d-6b04-6a5a-4c67a39565a5@redhat.com>
Date: Tue, 24 Dec 2019 05:45:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1225d839-3cf7-d513-778e-698e12e94875@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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

SGkgWmVuZ2h1aSwKCk9uIDEyLzI0LzE5IDM6NTIgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
TWFyYywgRXJpYywKPiAKPiBPbiAyMDE5LzEyLzIzIDIyOjA3LCBNYXJjIFp5bmdpZXIgd3JvdGU6
Cj4+IEhpIFplbmdodWksCj4+Cj4+IE9uIDIwMTktMTItMjMgMTM6NDMsIFplbmdodWkgWXUgd3Jv
dGU6Cj4+PiBPbiAyMDE5LzEyLzIwIDE5OjE4LCBaZW5naHVpIFl1IHdyb3RlOgo+Pj4+IEFsdGhv
dWdoIGd1ZXN0IHdpbGwgaGFyZGx5IHJlYWQgYW5kIHVzZSB0aGUgUFRaIChQZW5kaW5nIFRhYmxl
IFplcm8pCj4+Pj4gYml0IGluIEdJQ1JfUEVOREJBU0VSLCBsZXQgdXMgZW11bGF0ZSB0aGUgYXJj
aGl0ZWN0dXJlIHN0cmljdGx5Lgo+Pj4+IEFzIHBlciBJSEkgMDA2OUUgOS4xMS4zMCwgUFRaIGZp
ZWxkIGlzIFdPLCBhbmQgcmVhZHMgYXMgMC4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBaZW5naHVpIFl1
IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPj4+PiAtLS0KPj4+PiBOb3RpY2VkIHdoZW4gY2hlY2tp
bmcgYWxsIGZpZWxkcyBvZiBHSUNSX1BFTkRCQVNFUiByZWdpc3Rlci4KPj4+PiBCdXQgX25vdF8g
c3VyZSB3aGV0aGVyIGl0J3Mgd29ydGggYSBmaXgsIGFzIExpbnV4IG5ldmVyIHNldHMKPj4+PiB0
aGUgUFRaIGJpdCBiZWZvcmUgZW5hYmxpbmcgTFBJIChzZXQgR0lDUl9DVExSX0VOQUJMRV9MUElT
KS4KPj4+PiBBbmQgSSB3b25kZXIgdW5kZXIgd2hpY2ggc2NlbmFyaW9zIGNhbiB0aGlzIGJpdCBi
ZSB3cml0dGVuIGFzIDEuCj4+Pj4gSXQgc2VlbXMgZGlmZmljdWx0IGZvciBzb2Z0d2FyZSB0byBk
ZXRlcm1pbmUgd2hldGhlciB0aGUgcGVuZGluZwo+Pj4+IHRhYmxlIGNvbnRhaW5zIGFsbCB6ZXJv
cyB3aGVuIHdyaXRpbmcgdGhpcyBiaXQuCj4+Pj4gdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlv
LXYzLmMgfCA1ICsrKystCj4+Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQo+Pj4+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1t
aW8tdjMuYwo+Pj4+IGIvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLXYzLmMKPj4+PiBpbmRl
eCA3ZGZkMTVkYmIzMDguLmViYzIxODg0MGZjMiAxMDA2NDQKPj4+PiAtLS0gYS92aXJ0L2t2bS9h
cm0vdmdpYy92Z2ljLW1taW8tdjMuYwo+Pj4+ICsrKyBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMt
bW1pby12My5jCj4+Pj4gQEAgLTQxNCw4ICs0MTQsMTEgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcK
Pj4+PiB2Z2ljX21taW9fcmVhZF9wZW5kYmFzZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBncGFf
dCBhZGRyLCB1bnNpZ25lZCBpbnQgbGVuKQo+Pj4+IMKgIHsKPj4+PiDCoMKgwqDCoMKgIHN0cnVj
dCB2Z2ljX2NwdSAqdmdpY19jcHUgPSAmdmNwdS0+YXJjaC52Z2ljX2NwdTsKPj4+PiArwqDCoMKg
IHU2NCB2YWx1ZSA9IHZnaWNfY3B1LT5wZW5kYmFzZXI7Cj4+Pj4gwqAgLcKgwqDCoCByZXR1cm4g
ZXh0cmFjdF9ieXRlcyh2Z2ljX2NwdS0+cGVuZGJhc2VyLCBhZGRyICYgNywgbGVuKTsKPj4+PiAr
wqDCoMKgIHZhbHVlICY9IH5HSUNSX1BFTkRCQVNFUl9QVFo7Cj4+Pj4gKwo+Pj4+ICvCoMKgwqAg
cmV0dXJuIGV4dHJhY3RfYnl0ZXModmFsdWUsIGFkZHIgJiA3LCBsZW4pOwo+Pj4+IMKgIH0KPj4+
PiDCoCBzdGF0aWMgdm9pZCB2Z2ljX21taW9fd3JpdGVfcGVuZGJhc2Uoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1LAo+Pj4+Cj4+Pgo+Pj4gSSBub3RpY2VkIHRoZXJlIGlzIG5vIHVzZXJzcGFjZSBhY2Nl
c3MgY2FsbGJhY2tzIGZvciBHSUNSX1BFTkRCQVNFUiwKPj4+IHNvIHRoaXMgcGF0Y2ggd2lsbCBt
YWtlIHRoZSBQVFogZmllbGQgYWxzbyAnUmVhZCBBcyBaZXJvJyBieSB1c2Vyc3BhY2UuCj4+PiBT
aG91bGQgd2UgY29uc2lkZXIgYWRkaW5nIGEgdWFjY2Vzc19yZWFkIGNhbGxiYWNrIGZvciBHSUNS
X1BFTkRCQVNFUgo+Pj4gd2hpY2gganVzdCByZXR1cm5zIHRoZSB1bmNoYW5nZWQgdmdpY19jcHUt
PnBlbmRiYXNlciB0byB1c2Vyc3BhY2U/Cj4+PiAoVGhvdWdoIHRoaXMgaXMgcmVhbGx5IG5vdCBh
IGJpZyBkZWFsLiBXZSBub3cgYWx3YXlzIGVtdWxhdGUgdGhlIFBUWgo+Pj4gZmllbGQgdG8gZ3Vl
c3QgYXMgUkFaLiBBbmQgJ3ZnaWNfY3B1LT5wZW5kYmFzZXIgJiBHSUNSX1BFTkRCQVNFUl9QVFon
Cj4+PiBvbmx5IGluZGljYXRlcyB3aGV0aGVyIEtWTSB3aWxsIG9wdGltaXplIHRoZSBMUEkgZW5h
YmxpbmcgcHJvY2VzcywKPj4+IHdoZXJlIFJlYWQgQXMgWmVybyBpbmRpY2F0ZXMgbmV2ZXIgb3B0
aW1pemUuLikKPj4KPj4gSSBkb24ndCB0aGluayBhZGRpbmcgYSB1c2Vyc3BhY2UgYWNjZXNzb3Ig
d291bGQgaGVscCBtdWNoLiBBbGwgdGhpcwo+PiBiaXQgdGVsbHMgdXNlcnNwYWNlIGlzIHRoYXQg
dGhlIGd1ZXN0IGhhcyBwcm9ncmFtbWVkIGEgemVybyBmaWxsZWQKPj4gdGFibGUuIE9uIHJlc3Rv
cmUsIHdlJ2QgYXZvaWQgYSByZXNjYW4gb2YgdGhlIHRhYmxlIGlmIHRoZXJlIHdhcwo+PiBubyBM
UEkgbWFwcGVkLgo+IAo+IFllcywgSSBhZ3JlZS4KPiAKPj4gQW5kIHRoaW5raW5nIG9mIGl0LCB0
aGlzIGZpeGVzIGEgYnVnIGZvciBub24tTGludXggZ3Vlc3RzOiBJZiB5b3Ugd3JpdGUKPj4gUFRa
PTEsIHdlIG5ldmVyIGNsZWFyIGl0LiBXaGljaCBtZWFucyB0aGF0IGlmIHVzZXJzcGFjZSBzYXZl
cyBhbmQKPj4gcmVzdG9yZXMKPj4gUEVOREJBU0VSIHdpdGggUFRaIHNldCwgd2UnbGwgbmV2ZXIg
cmVzdG9yZSB0aGUgcGVuZGluZyBiaXRzLCB3aGljaCBpcwo+PiBwcmV0dHkgYmFkIChzZWUgdmdp
Y19lbmFibGVfbHBpcygpKS4KPiAKPiBCdXQgSSdtIGFmcmFpZCBJIGNhbid0IGZvbGxvdyB0aGlz
IHBvaW50LiBBZnRlciByZWFkaW5nIHRoZSBjb2RlICh3aXRoCj4gUWVtdSkgYSBiaXQgZnVydGhl
ciwgdGhlIFJlZGlzdHJpYnV0b3JzIGFyZSByZXN0b3JlZCBiZWZvcmUgdGhlIElUUy4KClRoaXMg
aXMgYWxzbyBwYXJ0IG9mIHRoZSBrZXJuZWwgZG9jdW1lbnRhdGlvbjoKRG9jdW1lbnRhdGlvbi92
aXJ0L2t2bS9kZXZpY2VzL2FybS12Z2ljLWl0cy50eHQgKElUUyByZXN0b3JlIHNlcXVlbmNlKQog
U28KPiB0aGVyZSBzaG91bGQgYmUgX25vXyBMUEkgaGFzIGJlZW4gbWFwcGVkIHdoZW4gd2UncmUg
cmVzdG9yaW5nIEdJQ1JfQ1RMUgo+IGFuZCBlbmFibGluZyBMUEksIHdoaWNoIHNheXMgd2Ugd2ls
bCBub3Qgc2NhbiB0aGUgd2hvbGUgcGVuZGluZyB0YWJsZQo+IGFuZCByZXN0b3JlIHBlbmRpbmcg
YnkgdmdpY19lbmFibGVfbHBpcygpL2l0c19zeW5jX2xwaV9wZW5kaW5nX3RhYmxlKCksCj4gcmVn
YXJkbGVzcyBvZiB3aGF0IHRoZSBQVFogaXMuCj4gCj4gSW5zdGVhZCwgdmdpY19pdHNfcmVzdG9y
ZV9pdGUoKS92Z2ljX3YzX2xwaV9zeW5jX3BlbmRpbmdfc3RhdHVzKCkgaXMKPiB3aGVyZSB3ZSBh
Y3R1YWxseSByZWFkIHRoZSBndWVzdCBSQU0gYW5kIHJlc3RvcmUgdGhlIExQSSBwZW5kaW5nIHN0
YXRlLgp5ZXMgdGhlIHBlbmRpbmcgc3RhdGUgaXMgcmVzdG9yZWQgZnJvbQp2Z2ljX2l0c19yZXN0
b3JlX2l0ZS92Z2ljX2FkZF9scGkvdmdpY192M19scGlfc3luY19wZW5kaW5nX3N0YXR1cyBhbmQK
dGhpcyBwYXRoIGlnbm9yZXMgdGhlIFBUWi4KClRoYW5rcwoKRXJpYwo+IFdoaWNoIG1lYW5zIHdl
IHdpbGwgc3RpbGwgZG8gdGhlIHJpZ2h0IHRoaW5nIGV2ZW4gZm9yIG5vbi1MaW51eCBndWVzdHMu
Cj4gTm90IHN1cmUgaWYgSSd2ZSBnb3QgdGhpbmdzIGNvcnJlY3RseSBoZXJlLgo+IAo+IEluIHRo
ZSBlbmQsIGxldCdzIGtlZXAgdGhlIHBhdGNoIGFzIGl0IGlzLgo+IAo+Pgo+PiBUaGlzIHBhdGNo
IG9uIGl0cyBvd24gZml4ZXMgbW9yZSB0aGFuIG9uZSBidWchCj4+Cj4gCj4gSWYgc28sIGp1c3Qg
YnkgbHVjayA7LSkKPiAKPiAKPiBUaGFua3MsCj4gWmVuZ2h1aQo+IAo+IAo+IF9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4gbGludXgtYXJtLWtlcm5lbCBt
YWlsaW5nIGxpc3QKPiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKPiBodHRw
Oi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LWFybS1rZXJuZWwK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
