Return-Path: <SRS0=P9fm=2N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF5DC2D0C0
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 14:25:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7068D2073A
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 14:25:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VhXXQ7VW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7068D2073A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5CB44AF23;
	Mon, 23 Dec 2019 09:25:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jt2GsyPLhi7T; Mon, 23 Dec 2019 09:25:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A35174AF3E;
	Mon, 23 Dec 2019 09:25:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0382F4AF23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 09:25:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KPiNsVu9KZ1R for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Dec 2019 09:25:47 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C77DF4AF1F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 09:25:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1577111147;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nTyEDFusLKumYW0h03qshyTMkbaeVnlSIDHnGUWtv+s=;
 b=VhXXQ7VWfTY1g5I5vAvKSVfaf07BwiCpmrL4/vV/o8Kjc6qAkwlVRzG0e/yT9+5m1XruQL
 fPc7h43StF4Urk9HB6TAdYDQ73q0jmQHOPoqizpKxLGY800HzT4+xN8ZlKHOB4++KJGd7x
 rWry44MErpple9KQVrkpA69WXvhPBCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-eooe5S9dObea5djAYhn2sA-1; Mon, 23 Dec 2019 09:25:43 -0500
X-MC-Unique: eooe5S9dObea5djAYhn2sA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D36A11005502;
 Mon, 23 Dec 2019 14:25:41 +0000 (UTC)
Received: from [10.36.116.117] (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 54E7860BF4;
 Mon, 23 Dec 2019 14:25:37 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Handle GICR_PENDBASER.PTZ filed as
 RAZ
From: Auger Eric <eric.auger@redhat.com>
To: Zenghui Yu <yuzenghui@huawei.com>, maz@kernel.org
References: <20191220111833.1422-1-yuzenghui@huawei.com>
 <3a729559-d0eb-e042-d6bd-b69bacb0dd23@huawei.com>
 <fd6ec914-0940-a4bd-fc06-f1c211eba5ee@redhat.com>
Message-ID: <4817b05f-1822-7fc7-99a5-e7d5deae1055@redhat.com>
Date: Mon, 23 Dec 2019 15:25:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <fd6ec914-0940-a4bd-fc06-f1c211eba5ee@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

SGkgWmVuZ2h1aSwgTWFyYywKT24gMTIvMjMvMTkgMzoxOSBQTSwgQXVnZXIgRXJpYyB3cm90ZToK
PiBIaSBaZW5naHVpLAo+IAo+IE9uIDEyLzIzLzE5IDI6NDMgUE0sIFplbmdodWkgWXUgd3JvdGU6
Cj4+IE9uIDIwMTkvMTIvMjAgMTk6MTgsIFplbmdodWkgWXUgd3JvdGU6Cj4+PiBBbHRob3VnaCBn
dWVzdCB3aWxsIGhhcmRseSByZWFkIGFuZCB1c2UgdGhlIFBUWiAoUGVuZGluZyBUYWJsZSBaZXJv
KQo+Pj4gYml0IGluIEdJQ1JfUEVOREJBU0VSLCBsZXQgdXMgZW11bGF0ZSB0aGUgYXJjaGl0ZWN0
dXJlIHN0cmljdGx5Lgo+Pj4gQXMgcGVyIElISSAwMDY5RSA5LjExLjMwLCBQVFogZmllbGQgaXMg
V08sIGFuZCByZWFkcyBhcyAwLgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IFplbmdodWkgWXUgPHl1
emVuZ2h1aUBodWF3ZWkuY29tPgo+Pj4gLS0tCj4+Pgo+Pj4gTm90aWNlZCB3aGVuIGNoZWNraW5n
IGFsbCBmaWVsZHMgb2YgR0lDUl9QRU5EQkFTRVIgcmVnaXN0ZXIuCj4+PiBCdXQgX25vdF8gc3Vy
ZSB3aGV0aGVyIGl0J3Mgd29ydGggYSBmaXgsIGFzIExpbnV4IG5ldmVyIHNldHMKPj4+IHRoZSBQ
VFogYml0IGJlZm9yZSBlbmFibGluZyBMUEkgKHNldCBHSUNSX0NUTFJfRU5BQkxFX0xQSVMpLgo+
Pj4KPj4+IEFuZCBJIHdvbmRlciB1bmRlciB3aGljaCBzY2VuYXJpb3MgY2FuIHRoaXMgYml0IGJl
IHdyaXR0ZW4gYXMgMS4KPj4+IEl0IHNlZW1zIGRpZmZpY3VsdCBmb3Igc29mdHdhcmUgdG8gZGV0
ZXJtaW5lIHdoZXRoZXIgdGhlIHBlbmRpbmcKPj4+IHRhYmxlIGNvbnRhaW5zIGFsbCB6ZXJvcyB3
aGVuIHdyaXRpbmcgdGhpcyBiaXQuCj4+Pgo+Pj4gwqAgdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1t
bWlvLXYzLmMgfCA1ICsrKystCj4+PiDCoCAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pCj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS92Z2ljL3Zn
aWMtbW1pby12My5jCj4+PiBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby12My5jCj4+PiBp
bmRleCA3ZGZkMTVkYmIzMDguLmViYzIxODg0MGZjMiAxMDA2NDQKPj4+IC0tLSBhL3ZpcnQva3Zt
L2FybS92Z2ljL3ZnaWMtbW1pby12My5jCj4+PiArKysgYi92aXJ0L2t2bS9hcm0vdmdpYy92Z2lj
LW1taW8tdjMuYwo+Pj4gQEAgLTQxNCw4ICs0MTQsMTEgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcK
Pj4+IHZnaWNfbW1pb19yZWFkX3BlbmRiYXNlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ3BhX3Qg
YWRkciwgdW5zaWduZWQgaW50IGxlbikKPj4+IMKgIHsKPj4+IMKgwqDCoMKgwqAgc3RydWN0IHZn
aWNfY3B1ICp2Z2ljX2NwdSA9ICZ2Y3B1LT5hcmNoLnZnaWNfY3B1Owo+Pj4gK8KgwqDCoCB1NjQg
dmFsdWUgPSB2Z2ljX2NwdS0+cGVuZGJhc2VyOwo+Pj4gwqAgLcKgwqDCoCByZXR1cm4gZXh0cmFj
dF9ieXRlcyh2Z2ljX2NwdS0+cGVuZGJhc2VyLCBhZGRyICYgNywgbGVuKTsKPj4+ICvCoMKgwqAg
dmFsdWUgJj0gfkdJQ1JfUEVOREJBU0VSX1BUWjsKPj4+ICsKPj4+ICvCoMKgwqAgcmV0dXJuIGV4
dHJhY3RfYnl0ZXModmFsdWUsIGFkZHIgJiA3LCBsZW4pOwo+Pj4gwqAgfQo+Pj4gwqAgwqAgc3Rh
dGljIHZvaWQgdmdpY19tbWlvX3dyaXRlX3BlbmRiYXNlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwK
Pj4+Cj4+Cj4+IEkgbm90aWNlZCB0aGVyZSBpcyBubyB1c2Vyc3BhY2UgYWNjZXNzIGNhbGxiYWNr
cyBmb3IgR0lDUl9QRU5EQkFTRVIsCj4+IHNvIHRoaXMgcGF0Y2ggd2lsbCBtYWtlIHRoZSBQVFog
ZmllbGQgYWxzbyAnUmVhZCBBcyBaZXJvJyBieSB1c2Vyc3BhY2UuCj4+IFNob3VsZCB3ZSBjb25z
aWRlciBhZGRpbmcgYSB1YWNjZXNzX3JlYWQgY2FsbGJhY2sgZm9yIEdJQ1JfUEVOREJBU0VSCj4+
IHdoaWNoIGp1c3QgcmV0dXJucyB0aGUgdW5jaGFuZ2VkIHZnaWNfY3B1LT5wZW5kYmFzZXIgdG8g
dXNlcnNwYWNlPwo+PiAoVGhvdWdoIHRoaXMgaXMgcmVhbGx5IG5vdCBhIGJpZyBkZWFsLiBXZSBu
b3cgYWx3YXlzIGVtdWxhdGUgdGhlIFBUWgo+PiBmaWVsZCB0byBndWVzdCBhcyBSQVouIEFuZCAn
dmdpY19jcHUtPnBlbmRiYXNlciAmIEdJQ1JfUEVOREJBU0VSX1BUWicKPj4gb25seSBpbmRpY2F0
ZXMgd2hldGhlciBLVk0gd2lsbCBvcHRpbWl6ZSB0aGUgTFBJIGVuYWJsaW5nIHByb2Nlc3MsCj4+
IHdoZXJlIFJlYWQgQXMgWmVybyBpbmRpY2F0ZXMgbmV2ZXIgb3B0aW1pemUuLikKPiBZb3UncmUg
cmlnaHQuIElmIHdlIHN0YXJ0IGEgbWlncmF0aW9uIHdoZW4gdGhlIFBUWiBoYXMganVzdCBiZWVu
IHNldCBieQo+IHRoZSBTVywgdGhlbiB3ZSB3aWxsIG1pc3MgaXQgb24gdGhlIGRlc3RpbmF0aW9u
IHNpZGUuCj4gCj4gU28gZm9yIGluc3RhbmNlIGluIHRoZSBsYXN0IEtWTSB1bml0IHRlc3Qgb2Yg
bXkgc2VyaWVzCj4gKGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bWFybS8yMDE5MTIxNjE0MDIz
NS4xMDc1MS0xNy1lcmljLmF1Z2VyQHJlZGhhdC5jb20vKSwKPiBpbiB0ZXN0X2l0c19wZW5kaW5n
X21pZ3JhdGlvbigpLCBpZiB5b3Uga2ljayB0aGUgbWlncmF0aW9uIGJlZm9yZQo+IGVuYWJsaW5n
IExQSSdzIGF0IHJlZGlzdCBsZXZlbCwgeW91IHNob3VsZG4ndCBzZWUgYW55IExQSSBoaXR0aW5n
IG9uIHRoZQo+IHRhcmdldCB3aGljaCBpcyB0aGVvcmV0aWNhbGx5IHdyb25nLiBTbyBpbXBsZW1l
bnRpbmcgYSB1YWNjZXNzX3JlYWQoKQo+IHdvdWxkIGJlIGJldHRlciBJIHRoaW5rLgo+IAo+IFRo
YW5rcwo+IAo+IEVyaWMKPiAKPiArCXB0ciA9IGdpY3YzX2RhdGEucmVkaXN0X2Jhc2VbbnJfY3B1
cyAtIDFdICsgR0lDUl9QRU5EQkFTRVI7Cj4gKwlwZW5kYmFzZXIgPSByZWFkcShwdHIpOwo+ICsJ
d3JpdGVxKHBlbmRiYXNlciAmIH5HSUNSX1BFTkRCQVNFUl9QVFosIHB0cik7Cj4gKwo+ICsJcHRy
ID0gZ2ljdjNfZGF0YS5yZWRpc3RfYmFzZVtucl9jcHVzIC0gMl0gKyBHSUNSX1BFTkRCQVNFUjsK
PiArCXBlbmRiYXNlciA9IHJlYWRxKHB0cik7Cj4gKwl3cml0ZXEocGVuZGJhc2VyICYgfkdJQ1Jf
UEVOREJBU0VSX1BUWiwgcHRyKTsKVGhhdCdzIGEgY2xlYXIgYWN0dWFsbHkuIFNvIE1hcmMgaXMg
cmlnaHQsIGZvcmdldCB3aGF0IEkgaGF2ZSBqdXN0IHNhaWQuClRoaXMgd2lsbCB3b3JrIG9uIGRl
c3RpbmF0aW9uIHNpemUgYXMgd2Ugd2lsbCB3cml0ZSAwLgoKU29ycnkgZm9yIHRoZSBub2lzZQoK
SG9wZWZ1bGx5IENocmlzdG1hcyBicmVhayBpcyBjb21pbmcgOy0pCgpCZXN0IFJlZ2FyZHMKCkVy
aWMKPiAKPiArCXB1dHMoIk5vdyBtaWdyYXRlIHRoZSBWTSwgdGhlbiBwcmVzcyBhIGtleSB0byBj
b250aW51ZS4uLlxuIik7Cj4gKwkodm9pZClnZXRjaGFyKCk7Cj4gKwlyZXBvcnQodHJ1ZSwgIk1p
Z3JhdGlvbiBjb21wbGV0ZSIpOwo+ICsKPiArCWdpY3YzX3JkaXN0X2N0cmxfbHBpKG5yX2NwdXMg
LSAxLCB0cnVlKTsKPiArCWdpY3YzX3JkaXN0X2N0cmxfbHBpKG5yX2NwdXMgLSAyLCB0cnVlKTsK
PiArCj4+Cj4+Cj4+IFRoYW5rcywKPj4gWmVuZ2h1aQo+Pgo+Pgo+PiBfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+PiBsaW51eC1hcm0ta2VybmVsIG1haWxp
bmcgbGlzdAo+PiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKPj4gaHR0cDov
L2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2VybmVsCj4+
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
