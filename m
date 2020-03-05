Return-Path: <SRS0=Em7b=4W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7C1C3F2D1
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 19:41:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B0AC20848
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 19:41:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RYXjgbcr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B0AC20848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6EEC4AC07;
	Thu,  5 Mar 2020 14:41:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J4TXK5oA08uw; Thu,  5 Mar 2020 14:41:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77B984ACE9;
	Thu,  5 Mar 2020 14:41:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA7194AC07
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 14:41:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b3atltLgj7uH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2020 14:41:08 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B19D74A94D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 14:41:08 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583437268;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XTwc7utWzKzyAhBWCE6+Bn/zt36VL3m2kIIGjJFea4w=;
 b=RYXjgbcrTNAEfFY/DH3/+6Q/R3BcRGN864uU/eWpZEH9wiw3pS22f4belsN9dOgvoyckAq
 1olrtHp34dVTamTyzXnCr6rp9qsSP+xI/WwjhCUj1aDRni9eYotP5UkgZfO40dmZrGALEI
 t20GoXESSCfAs8FFNxwtMl8TEYyn+pQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-p2KwtOX8PpWqemKazDTNyg-1; Thu, 05 Mar 2020 14:41:04 -0500
X-MC-Unique: p2KwtOX8PpWqemKazDTNyg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80EA98010F2;
 Thu,  5 Mar 2020 19:41:01 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F9938FBE0;
 Thu,  5 Mar 2020 19:40:56 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 06/14] arm/arm64: gicv3: Set the LPI
 config and pending tables
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-7-eric.auger@redhat.com>
 <5e188428-11c9-aad4-3d5e-fca89cc41b7f@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <11ff332b-6634-7d9a-c12e-921e8dc592e9@redhat.com>
Date: Thu, 5 Mar 2020 20:40:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <5e188428-11c9-aad4-3d5e-fca89cc41b7f@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: andre.przywara@arm.com, thuth@redhat.com
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

SGkgWmVuZ2h1aSwKCk9uIDIvNy8yMCAzOjEyIEFNLCBaZW5naHVpIFl1IHdyb3RlOgo+IEhpIEVy
aWMsCj4gCj4gT24gMjAyMC8xLzI4IDE4OjM0LCBFcmljIEF1Z2VyIHdyb3RlOgo+PiBBbGxvY2F0
ZSB0aGUgTFBJIGNvbmZpZ3VyYXRpb24gYW5kIHBlciByZS1kaXN0cmlidXRvciBwZW5kaW5nIHRh
YmxlLgo+PiBTZXQgcmVkaXN0cmlidXRvcidzIFBST1BCQVNFUiBhbmQgUEVOREJBU0VSLiBUaGUg
TFBJcyBhcmUgZW5hYmxlZAo+PiBieSBkZWZhdWx0IGluIHRoZSBjb25maWcgdGFibGUuCj4+Cj4+
IEFsc28gaW50cm9kdWNlIGEgaGVscGVyIHJvdXRpbmUgdGhhdCBhbGxvd3MgdG8gc2V0IHRoZSBw
ZW5kaW5nIHRhYmxlCj4+IGJpdCBmb3IgYSBnaXZlbiBMUEkuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6
IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KPj4KPj4gLS0tCj4+Cj4+IHYyIC0+
IHYzOgo+PiAtIE1vdmUgdGhlIGhlbHBlcnMgaW4gbGliL2FybS9naWMtdjMuYyBhbmQgcHJlZml4
IHRoZW0gd2l0aCAiZ2ljdjNfIgo+PiDCoMKgIGFuZCBhZGQgX2xwaSBwcmVmaXggdG9vCj4+Cj4+
IHYxIC0+IHYyOgo+PiAtIHJlbW92ZSBtZW1vcnkgYXR0cmlidXRlcwo+PiAtLS0KPj4gwqAgbGli
L2FybS9hc20vZ2ljLXYzLmggfCAxNiArKysrKysrKysrKwo+PiDCoCBsaWIvYXJtL2dpYy12My5j
wqDCoMKgwqAgfCA2NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kwo+PiDCoCAyIGZpbGVzIGNoYW5nZWQsIDgwIGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdp
dCBhL2xpYi9hcm0vYXNtL2dpYy12My5oIGIvbGliL2FybS9hc20vZ2ljLXYzLmgKPj4gaW5kZXgg
ZmZiMmUyNi4uZWMyYTZmMCAxMDA2NDQKPj4gLS0tIGEvbGliL2FybS9hc20vZ2ljLXYzLmgKPj4g
KysrIGIvbGliL2FybS9hc20vZ2ljLXYzLmgKPj4gQEAgLTQ4LDYgKzQ4LDE2IEBACj4+IMKgICNk
ZWZpbmUgTVBJRFJfVE9fU0dJX0FGRklOSVRZKGNsdXN0ZXJfaWQsIGxldmVsKSBcCj4+IMKgwqDC
oMKgwqAgKE1QSURSX0FGRklOSVRZX0xFVkVMKGNsdXN0ZXJfaWQsIGxldmVsKSA8PAo+PiBJQ0Nf
U0dJMVJfQUZGSU5JVFlfIyMgbGV2ZWwgIyMgX1NISUZUKQo+PiDCoCArI2RlZmluZSBHSUNSX1BS
T1BCQVNFUl9JREJJVFNfTUFTS8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAoMHgxZikKPiAKPiBUaGlzIGlzIG5vdCBiZWluZyB1c2VkLsKgIFlvdSBjYW4gdXNlIGl0
IHdoZW4gY2FsY3VsYXRpbmcgcHJvcF92YWwKPiBvciBqdXN0IGRyb3AgaXQuCnllcCBkcm9wcGVk
IGl0Lgo+IAo+PiArCj4+ICsjZGVmaW5lIEdJQ1JfUEVOREJBU0VSX1BUWsKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgQklUX1VMTCg2MikK
Pj4gKwo+PiArI2RlZmluZSBMUElfUFJPUF9HUk9VUDHCoMKgwqDCoMKgwqDCoCAoMSA8PCAxKQo+
PiArI2RlZmluZSBMUElfUFJPUF9FTkFCTEVEwqDCoMKgICgxIDw8IDApCj4+ICsjZGVmaW5lIExQ
SV9QUk9QX0RFRkFVTFRfUFJJT8KgwqAgMHhhMAo+PiArI2RlZmluZSBMUElfUFJPUF9ERUZBVUxU
wqDCoMKgIChMUElfUFJPUF9ERUZBVUxUX1BSSU8gfCBMUElfUFJPUF9HUk9VUDEgfCBcCj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBMUElfUFJPUF9FTkFCTEVEKQo+PiArCj4+
IMKgICNpbmNsdWRlIDxhc20vYXJjaF9naWN2My5oPgo+PiDCoCDCoCAjaWZuZGVmIF9fQVNTRU1C
TFlfXwo+PiBAQCAtNjQsNiArNzQsOCBAQCBzdHJ1Y3QgZ2ljdjNfZGF0YSB7Cj4+IMKgwqDCoMKg
wqAgdm9pZCAqZGlzdF9iYXNlOwo+PiDCoMKgwqDCoMKgIHZvaWQgKnJlZGlzdF9iYXNlc1tHSUNW
M19OUl9SRURJU1RTXTsKPj4gwqDCoMKgwqDCoCB2b2lkICpyZWRpc3RfYmFzZVtOUl9DUFVTXTsK
Pj4gK8KgwqDCoCB2b2lkICpscGlfcHJvcDsKPj4gK8KgwqDCoCB2b2lkICpscGlfcGVuZFtOUl9D
UFVTXTsKPj4gwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgaXJxX25yOwo+PiDCoCB9Owo+PiDCoCBl
eHRlcm4gc3RydWN0IGdpY3YzX2RhdGEgZ2ljdjNfZGF0YTsKPj4gQEAgLTgwLDYgKzkyLDEwIEBA
IGV4dGVybiB2b2lkIGdpY3YzX3dyaXRlX2VvaXIodTMyIGlycXN0YXQpOwo+PiDCoCBleHRlcm4g
dm9pZCBnaWN2M19pcGlfc2VuZF9zaW5nbGUoaW50IGlycSwgaW50IGNwdSk7Cj4+IMKgIGV4dGVy
biB2b2lkIGdpY3YzX2lwaV9zZW5kX21hc2soaW50IGlycSwgY29uc3QgY3B1bWFza190ICpkZXN0
KTsKPj4gwqAgZXh0ZXJuIHZvaWQgZ2ljdjNfc2V0X3JlZGlzdF9iYXNlKHNpemVfdCBzdHJpZGUp
Owo+PiArZXh0ZXJuIHZvaWQgZ2ljdjNfbHBpX3NldF9jb25maWcoaW50IG4sIHU4IHZhbCk7Cj4+
ICtleHRlcm4gdTggZ2ljdjNfbHBpX2dldF9jb25maWcoaW50IG4pOwo+PiArZXh0ZXJuIHZvaWQg
Z2ljdjNfbHBpX3NldF9wZW5kaW5nX3RhYmxlX2JpdChpbnQgcmRpc3QsIGludCBuLCBib29sIHNl
dCk7Cj4+ICtleHRlcm4gdm9pZCBnaWN2M19scGlfYWxsb2NfdGFibGVzKHZvaWQpOwo+PiDCoCDC
oCBzdGF0aWMgaW5saW5lIHZvaWQgZ2ljdjNfZG9fd2FpdF9mb3JfcndwKHZvaWQgKmJhc2UpCj4+
IMKgIHsKPj4gZGlmZiAtLWdpdCBhL2xpYi9hcm0vZ2ljLXYzLmMgYi9saWIvYXJtL2dpYy12My5j
Cj4+IGluZGV4IGZlZWNiNWUuLmMzM2Y4ODMgMTAwNjQ0Cj4+IC0tLSBhL2xpYi9hcm0vZ2ljLXYz
LmMKPj4gKysrIGIvbGliL2FybS9naWMtdjMuYwo+PiBAQCAtNSw2ICs1LDcgQEAKPj4gwqDCoCAq
Lwo+PiDCoCAjaW5jbHVkZSA8YXNtL2dpYy5oPgo+PiDCoCAjaW5jbHVkZSA8YXNtL2lvLmg+Cj4+
ICsjaW5jbHVkZSA8YWxsb2NfcGFnZS5oPgo+PiDCoCDCoCB2b2lkIGdpY3YzX3NldF9yZWRpc3Rf
YmFzZShzaXplX3Qgc3RyaWRlKQo+PiDCoCB7Cj4+IEBAIC0xNDcsMyArMTQ4LDY2IEBAIHZvaWQg
Z2ljdjNfaXBpX3NlbmRfc2luZ2xlKGludCBpcnEsIGludCBjcHUpCj4+IMKgwqDCoMKgwqAgY3B1
bWFza19zZXRfY3B1KGNwdSwgJmRlc3QpOwo+PiDCoMKgwqDCoMKgIGdpY3YzX2lwaV9zZW5kX21h
c2soaXJxLCAmZGVzdCk7Cj4+IMKgIH0KPj4gKwo+PiArI2lmIGRlZmluZWQoX19hYXJjaDY0X18p
Cj4+ICsvKiBhbGxvY19scGlfdGFibGVzOiBBbGxvY2F0ZSBMUEkgY29uZmlnIGFuZCBwZW5kaW5n
IHRhYmxlcyAqLwo+PiArdm9pZCBnaWN2M19scGlfYWxsb2NfdGFibGVzKHZvaWQpCj4+ICt7Cj4+
ICvCoMKgwqAgdW5zaWduZWQgbG9uZyBuID0gU1pfNjRLID4+IFBBR0VfU0hJRlQ7Cj4+ICvCoMKg
wqAgdW5zaWduZWQgbG9uZyBvcmRlciA9IGZscyhuKTsKPj4gK8KgwqDCoCB1NjQgcHJvcF92YWw7
Cj4+ICvCoMKgwqAgaW50IGNwdTsKPj4gKwo+PiArwqDCoMKgIGdpY3YzX2RhdGEubHBpX3Byb3Ag
PSAodm9pZCAqKXZpcnRfdG9fcGh5cyhhbGxvY19wYWdlcyhvcmRlcikpOwo+PiArCj4+ICvCoMKg
wqAgLyogSUQgYml0cyA9IDEzLCBpZS4gdXAgdG8gMTRiIExQSSBJTlRJRCAqLwo+PiArwqDCoMKg
IHByb3BfdmFsID0gKHU2NClnaWN2M19kYXRhLmxwaV9wcm9wIHwgMTM7Cj4+ICsKPj4gK8KgwqDC
oCAvKgo+PiArwqDCoMKgwqAgKiBBbGxvY2F0ZSBwZW5kaW5nIHRhYmxlcyBmb3IgZWFjaCByZWRp
c3RyaWJ1dG9yCj4+ICvCoMKgwqDCoCAqIGFuZCBzZXQgUFJPUEJBU0VSIGFuZCBQRU5EQkFTRVIK
Pj4gK8KgwqDCoMKgICovCj4+ICvCoMKgwqAgZm9yX2VhY2hfcHJlc2VudF9jcHUoY3B1KSB7Cj4+
ICvCoMKgwqDCoMKgwqDCoCB1NjQgcGVuZF92YWw7Cj4+ICvCoMKgwqDCoMKgwqDCoCB2b2lkICpw
dHI7Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIHB0ciA9IGdpY3YzX2RhdGEucmVkaXN0X2Jhc2Vb
Y3B1XTsKPj4gKwo+PiArwqDCoMKgwqDCoMKgwqAgd3JpdGVxKHByb3BfdmFsLCBwdHIgKyBHSUNS
X1BST1BCQVNFUik7Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIGdpY3YzX2RhdGEubHBpX3BlbmRb
Y3B1XSA9ICh2b2lkCj4+ICopdmlydF90b19waHlzKGFsbG9jX3BhZ2VzKG9yZGVyKSk7Cj4+ICsK
Pj4gK8KgwqDCoMKgwqDCoMKgIHBlbmRfdmFsID0gKHU2NClnaWN2M19kYXRhLmxwaV9wZW5kW2Nw
dV07Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIHdyaXRlcShwZW5kX3ZhbCwgcHRyICsgR0lDUl9Q
RU5EQkFTRVIpOwo+PiArwqDCoMKgIH0KPj4gK30KPj4gKwo+PiArdm9pZCBnaWN2M19scGlfc2V0
X2NvbmZpZyhpbnQgbiwgdTggdmFsdWUpCj4+ICt7Cj4+ICvCoMKgwqAgdTggKmVudHJ5ID0gKHU4
ICopKGdpY3YzX2RhdGEubHBpX3Byb3AgKyAobiAtIDgxOTIpKTsKPiAKPiBCdXQgdGhpcyBpcyBh
Y3R1YWxseSB0aGUgKnBoeXNpY2FsKiBhZGRyZXNzLCBzaG91bGRuJ3QgaXQgYmUKPiBjb252ZXJ0
ZWQgYnkgcGh5c190b192aXJ0KCkgYmVmb3JlIHJlYWRpbmcvd3JpdGluZyBzb21ldGhpbmc/Cj4g
TGlrZSB3aGF0IHlvdSd2ZSBkb25lIGZvciB0aGUgJ2xwaV9wZW5kW3JkaXN0XScgYmVmb3JlIHdy
aXRpbmcKPiBwZW5kaW5nIGJpdC7CoCBPciBJJ20gbWlzc2luZyBzb21lIHBvaW50cyBoZXJlPwpB
Z3JlZWQhIFRoYW5rcwoKRXJpYwo+IAo+PiArCj4+ICvCoMKgwqAgKmVudHJ5ID0gdmFsdWU7Cj4+
ICt9Cj4+ICsKPj4gK3U4IGdpY3YzX2xwaV9nZXRfY29uZmlnKGludCBuKQo+PiArewo+PiArwqDC
oMKgIHU4ICplbnRyeSA9ICh1OCAqKShnaWN2M19kYXRhLmxwaV9wcm9wICsgKG4gLSA4MTkyKSk7
Cj4gCj4gVGhlIHNhbWUgYXMgYWJvdmUuCj4gCj4gCj4gVGhhbmtzLAo+IFplbmdodWkKPiAKPj4g
Kwo+PiArwqDCoMKgIHJldHVybiAqZW50cnk7Cj4+ICt9Cj4+ICsKPj4gK3ZvaWQgZ2ljdjNfbHBp
X3NldF9wZW5kaW5nX3RhYmxlX2JpdChpbnQgcmRpc3QsIGludCBuLCBib29sIHNldCkKPj4gK3sK
Pj4gK8KgwqDCoCB1OCAqcHRyID0gcGh5c190b192aXJ0KChwaHlzX2FkZHJfdClnaWN2M19kYXRh
LmxwaV9wZW5kW3JkaXN0XSk7Cj4+ICvCoMKgwqAgdTggbWFzayA9IDEgPDwgKG4gJSA4KSwgYnl0
ZTsKPj4gKwo+PiArwqDCoMKgIHB0ciArPSAobiAvIDgpOwo+PiArwqDCoMKgIGJ5dGUgPSAqcHRy
Owo+PiArwqDCoMKgIGlmIChzZXQpCj4+ICvCoMKgwqDCoMKgwqDCoCBieXRlIHw9wqAgbWFzazsK
Pj4gK8KgwqDCoCBlbHNlCj4+ICvCoMKgwqDCoMKgwqDCoCBieXRlICY9IH5tYXNrOwo+PiArwqDC
oMKgICpwdHIgPSBieXRlOwo+PiArfQo+PiArI2VuZGlmIC8qIF9fYWFyY2g2NF9fICovCj4+Cj4g
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
