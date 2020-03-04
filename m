Return-Path: <SRS0=Ladk=4V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F6DC3F2D7
	for <kvmarm@archiver.kernel.org>; Wed,  4 Mar 2020 14:26:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B6B9E20848
	for <kvmarm@archiver.kernel.org>; Wed,  4 Mar 2020 14:26:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dYOBD7VV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6B9E20848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F02D64AF62;
	Wed,  4 Mar 2020 09:26:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 50WZYRI18xiV; Wed,  4 Mar 2020 09:26:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD2E44AF6B;
	Wed,  4 Mar 2020 09:26:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 397604AF62
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2020 09:26:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EgtMY+woNU+5 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2020 09:26:42 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AADC4AF58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2020 09:26:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583332002;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=qvGdvyoYicE65N8jrEMq9T3OVl/eWTUOTcqawK3mVp4=;
 b=dYOBD7VVi4W2KHb9V7BWh26XVzoltRdKjtA5T3u2Pq9C6XcLdxXsTxCOmv5vHo0lVNSGhI
 /v8hM/EYzZkJgFvilqJy20tJegGKG2D9nCpZ82rBsCuamCaWwjMY5lb02L/uR6RDWxyKwO
 ykZ0rFxYbtxVcI6GQfTxfkd69Ienj/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-6WHthEjRNrONjgC-NvHxrw-1; Wed, 04 Mar 2020 09:26:40 -0500
X-MC-Unique: 6WHthEjRNrONjgC-NvHxrw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7F8C107ACCA;
 Wed,  4 Mar 2020 14:26:37 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C6E6010013A1;
 Wed,  4 Mar 2020 14:26:33 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 08/14] arm/arm64: ITS:
 its_enable_defaults
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-9-eric.auger@redhat.com>
 <10d0630f-1464-b12a-5ad5-ee617eaa5cca@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <a49227ce-355a-be35-c006-441e2adca8e1@redhat.com>
Date: Wed, 4 Mar 2020 15:26:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <10d0630f-1464-b12a-5ad5-ee617eaa5cca@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

SGkgWmVuZ2h1aSwKT24gMi83LzIwIDQ6MjAgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkgRXJp
YywKPiAKPiBPbiAyMDIwLzEvMjggMTg6MzQsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+IGl0c19lbmFi
bGVfZGVmYXVsdHMoKSBpcyB0aGUgdG9wIGluaXQgZnVuY3Rpb24gdGhhdCBhbGxvY2F0ZXMgdGhl
Cj4+IGNvbW1hbmQgcXVldWUgYW5kIGFsbCB0aGUgcmVxdWVzdGVkIHRhYmxlcyAoZGV2aWNlLCBj
b2xsZWN0aW9uLAo+PiBscGkgY29uZmlnIGFuZCBwZW5kaW5nIHRhYmxlcyksIGVuYWJsZSBMUElz
IGF0IGRpc3RyaWJ1dG9yIGxldmVsCj4+IGFuZCBJVFMgbGV2ZWwuCj4+Cj4+IGdpY3YzX2VuYWJs
ZV9kZWZhdWx0cyBtdXN0IGJlIGNhbGxlZCBiZWZvcmUuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEVy
aWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KPj4KPj4gLS0tCj4+Cj4+IHYyIC0+IHYz
Ogo+PiAtIGludHJvZHVjZSBpdHNfc2V0dXBfYmFzZXIgaW4gdGhpcyBwYXRjaAo+PiAtIHNxdWFz
aCAiYXJtL2FybTY0OiBJVFM6IEluaXQgdGhlIGNvbW1hbmQgcXVldWUiIGluIHRoaXMgcGF0Y2gu
Cj4+IC0tLQo+PiDCoCBsaWIvYXJtL2FzbS9naWMtdjMtaXRzLmggfMKgIDggKysrKwo+PiDCoCBs
aWIvYXJtL2dpYy12My1pdHMuY8KgwqDCoMKgIHwgODkgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKwo+PiDCoCAyIGZpbGVzIGNoYW5nZWQsIDk3IGluc2VydGlvbnMoKykK
Pj4KPj4gZGlmZiAtLWdpdCBhL2xpYi9hcm0vYXNtL2dpYy12My1pdHMuaCBiL2xpYi9hcm0vYXNt
L2dpYy12My1pdHMuaAo+PiBpbmRleCA4MTVjNTE1Li5mZTczYzA0IDEwMDY0NAo+PiAtLS0gYS9s
aWIvYXJtL2FzbS9naWMtdjMtaXRzLmgKPj4gKysrIGIvbGliL2FybS9hc20vZ2ljLXYzLWl0cy5o
Cj4+IEBAIC0zNiw2ICszNiw4IEBAIHN0cnVjdCBpdHNfZGF0YSB7Cj4+IMKgwqDCoMKgwqAgdm9p
ZCAqYmFzZTsKPj4gwqDCoMKgwqDCoCBzdHJ1Y3QgaXRzX3R5cGVyIHR5cGVyOwo+PiDCoMKgwqDC
oMKgIHN0cnVjdCBpdHNfYmFzZXIgYmFzZXJbR0lUU19CQVNFUl9OUl9SRUdTXTsKPj4gK8KgwqDC
oCBzdHJ1Y3QgaXRzX2NtZF9ibG9jayAqY21kX2Jhc2U7Cj4+ICvCoMKgwqAgc3RydWN0IGl0c19j
bWRfYmxvY2sgKmNtZF93cml0ZTsKPj4gwqAgfTsKPj4gwqAgwqAgZXh0ZXJuIHN0cnVjdCBpdHNf
ZGF0YSBpdHNfZGF0YTsKPj4gQEAgLTg4LDEwICs5MCwxNiBAQCBleHRlcm4gc3RydWN0IGl0c19k
YXRhIGl0c19kYXRhOwo+PiDCoCAjZGVmaW5lIEdJVFNfQkFTRVJfVFlQRV9ERVZJQ0XCoMKgwqDC
oMKgwqDCoCAxCj4+IMKgICNkZWZpbmUgR0lUU19CQVNFUl9UWVBFX0NPTExFQ1RJT07CoMKgwqAg
NAo+PiDCoCArCj4+ICtzdHJ1Y3QgaXRzX2NtZF9ibG9jayB7Cj4+ICvCoMKgwqAgdTY0IHJhd19j
bWRbNF07Cj4+ICt9Owo+PiArCj4+IMKgIGV4dGVybiB2b2lkIGl0c19wYXJzZV90eXBlcih2b2lk
KTsKPj4gwqAgZXh0ZXJuIHZvaWQgaXRzX2luaXQodm9pZCk7Cj4+IMKgIGV4dGVybiBpbnQgaXRz
X3BhcnNlX2Jhc2VyKGludCBpLCBzdHJ1Y3QgaXRzX2Jhc2VyICpiYXNlcik7Cj4+IMKgIGV4dGVy
biBzdHJ1Y3QgaXRzX2Jhc2VyICppdHNfbG9va3VwX2Jhc2VyKGludCB0eXBlKTsKPj4gK2V4dGVy
biB2b2lkIGl0c19lbmFibGVfZGVmYXVsdHModm9pZCk7Cj4+IMKgIMKgICNlbHNlIC8qIF9fYXJt
X18gKi8KPj4gwqAgZGlmZiAtLWdpdCBhL2xpYi9hcm0vZ2ljLXYzLWl0cy5jIGIvbGliL2FybS9n
aWMtdjMtaXRzLmMKPj4gaW5kZXggMmMwY2UxMy4uZDFlN2U1MiAxMDA2NDQKPj4gLS0tIGEvbGli
L2FybS9naWMtdjMtaXRzLmMKPj4gKysrIGIvbGliL2FybS9naWMtdjMtaXRzLmMKPj4gQEAgLTg2
LDMgKzg2LDkyIEBAIHZvaWQgaXRzX2luaXQodm9pZCkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGl0
c19wYXJzZV9iYXNlcihpLCAmaXRzX2RhdGEuYmFzZXJbaV0pOwo+PiDCoCB9Cj4+IMKgICtzdGF0
aWMgdm9pZCBpdHNfc2V0dXBfYmFzZXIoaW50IGksIHN0cnVjdCBpdHNfYmFzZXIgKmJhc2VyKQo+
PiArewo+PiArwqDCoMKgIHVuc2lnbmVkIGxvbmcgbiA9IChiYXNlci0+bnJfcGFnZXMgKiBiYXNl
ci0+cHN6KSA+PiBQQUdFX1NISUZUOwo+PiArwqDCoMKgIHVuc2lnbmVkIGxvbmcgb3JkZXIgPSBp
c19wb3dlcl9vZl8yKG4pID8gZmxzKG4pIDogZmxzKG4pICsgMTsKPj4gK8KgwqDCoCB1NjQgdmFs
Owo+PiArCj4+ICvCoMKgwqAgYmFzZXItPnRhYmxlX2FkZHIgPSAodTY0KXZpcnRfdG9fcGh5cyhh
bGxvY19wYWdlcyhvcmRlcikpOwo+PiArCj4+ICvCoMKgwqAgdmFsID0gKCh1NjQpYmFzZXItPnRh
YmxlX2FkZHLCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8Cj4+ICvCoMKg
wqDCoMKgwqDCoCAoKHU2NCliYXNlci0+dHlwZcKgwqDCoCA8PCBHSVRTX0JBU0VSX1RZUEVfU0hJ
RlQpwqDCoMKgIHwKPj4gK8KgwqDCoMKgwqDCoMKgICgodTY0KShiYXNlci0+ZXN6IC0gMSnCoMKg
wqAgPDwgR0lUU19CQVNFUl9FTlRSWV9TSVpFX1NISUZUKcKgwqDCoCB8Cj4+ICvCoMKgwqDCoMKg
wqDCoCAoKGJhc2VyLT5ucl9wYWdlcyAtIDEpwqDCoMKgIDw8IEdJVFNfQkFTRVJfUEFHRVNfU0hJ
RlQpwqDCoMKgIHwKPj4gK8KgwqDCoMKgwqDCoMKgICh1NjQpYmFzZXItPmluZGlyZWN0wqDCoMKg
IDw8IDYywqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwKPiAKPiBJIGhhdmVuJ3Qgc2Vl
biB0aGUgJ25yX3BhZ2VzJyBhbmQgJ2luZGlyZWN0JyBhcmUgcHJvZ3JhbW1lZCBhbnl3aGVyZQo+
IGV4Y2VwdCBpbiBpdHNfcGFyc2VfYmFzZXIoKS4gSXQgbG9va3MgbGlrZSB0aGV5J3JlIHRyZWF0
ZWQgYXMgUk8gKGJ1dAo+IHRoZXkgc2hvdWxkbid0KSBhbmQgSSBub3cgZG9uJ3QgdGhpbmsgaXQg
bWFrZXMgc2Vuc2UgdG8gcGFyc2UgdGhlbSBpbgo+IGl0c19wYXJzZV9iYXNlcigpLCBpbiBwYXRj
aCM1LgoKRmlyc3Qgb2YgYWxsIHBsZWFzZSBmb3JnaXZlIG1lIGZvciB0aGUgZGVsYXkuCgpJIGFn
cmVlIHdpdGggeW91IG9uIG5yX3BhZ2VzLiBIb3dldmVyIGluZGlyZWN0IGFsc28gaW5kaWNhdGVz
IHRoZSBCQVNFUgpjYXBhYmlsaXR5IHRvIHN1cHBvcnQgb3Igbm90IDIgbGV2ZWwgdGFibGVzLiBT
byBJIHRoaW5rIGl0IG1ha2VzIHNlbnNlCnRvIHJlYWQgaXQgb24gaW5pdC4KPiAKPj4gK8KgwqDC
oMKgwqDCoMKgICh1NjQpYmFzZXItPnZhbGlkwqDCoMKgIDw8IDYzKTsKPj4gKwo+PiArwqDCoMKg
IHN3aXRjaCAoYmFzZXItPnBzeikgewo+PiArwqDCoMKgIGNhc2UgU1pfNEs6Cj4+ICvCoMKgwqDC
oMKgwqDCoCB2YWwgfD0gR0lUU19CQVNFUl9QQUdFX1NJWkVfNEs7Cj4+ICvCoMKgwqDCoMKgwqDC
oCBicmVhazsKPj4gK8KgwqDCoCBjYXNlIFNaXzE2SzoKPj4gK8KgwqDCoMKgwqDCoMKgIHZhbCB8
PSBHSVRTX0JBU0VSX1BBR0VfU0laRV8xNks7Cj4+ICvCoMKgwqDCoMKgwqDCoCBicmVhazsKPj4g
K8KgwqDCoCBjYXNlIFNaXzY0SzoKPj4gK8KgwqDCoMKgwqDCoMKgIHZhbCB8PSBHSVRTX0JBU0VS
X1BBR0VfU0laRV82NEs7Cj4+ICvCoMKgwqDCoMKgwqDCoCBicmVhazsKPj4gK8KgwqDCoCB9Cj4+
ICsKPj4gK8KgwqDCoCB3cml0ZXEodmFsLCBnaWN2M19pdHNfYmFzZSgpICsgR0lUU19CQVNFUiAr
IGkgKiA4KTsKPj4gK30KPj4gKwo+PiArLyoqCj4+ICsgKiBpbml0X2NtZF9xdWV1ZTogQWxsb2Nh
dGUgdGhlIGNvbW1hbmQgcXVldWUgYW5kIGluaXRpYWxpemUKPj4gKyAqIENCQVNFUiwgQ1JFQURS
LCBDV1JJVEVSCj4gCj4gbm8gJ0NSRUFEUicuCk9LCgpUaGFua3MKCkVyaWMKPiAKPiAKPiBUaGFu
a3MsCj4gWmVuZ2h1aQo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
