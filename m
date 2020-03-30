Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEEAC2D0EB
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 09:58:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0ED720774
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 09:58:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YWo9WW3A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0ED720774
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7787C4B204;
	Mon, 30 Mar 2020 05:58:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BdHYg5F9+Ime; Mon, 30 Mar 2020 05:58:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5423F4B1D6;
	Mon, 30 Mar 2020 05:58:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7A6B4B1D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 05:58:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0L2-rcD1sLtu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 05:58:05 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD57A4B1D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 05:58:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585562285;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QMWF8QuFs4FdQnn5PR+iMqYMNcjozcoCRuj7TDfrrJM=;
 b=YWo9WW3AjeZ8jG+6Btc5tdAbvMU2Eu3EypPnHuEjwHJJQ4d6e9AXCxidulYjQkditwlE35
 6qdecnbqlEWnAS9Cwz01l45mXfgQKXBWmMDlILsaJDtkjVe/i1tdO3zXWCns0u8e/YTaoz
 AntdXNBPy66FVPWj1oes4seoQJpT0HY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-a80OJPh6OOmn0-tzar3j5w-1; Mon, 30 Mar 2020 05:58:02 -0400
X-MC-Unique: a80OJPh6OOmn0-tzar3j5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72A47800D50;
 Mon, 30 Mar 2020 09:58:00 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CFC05C1B5;
 Mon, 30 Mar 2020 09:57:57 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 09/13] arm/arm64: ITS: Commands
To: Zenghui Yu <yuzenghui@huawei.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-10-eric.auger@redhat.com>
 <84493416-7b0d-df3e-df56-cedcbdd72010@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <885f656f-08a4-7e7b-f2b8-0e3921a58bb9@redhat.com>
Date: Mon, 30 Mar 2020 11:57:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <84493416-7b0d-df3e-df56-cedcbdd72010@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

SGkgWmVuZ2h1aSwKCk9uIDMvMzAvMjAgMTE6MjIgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
RXJpYywKPiAKPiBPbiAyMDIwLzMvMjAgMTc6MjQsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+IEltcGxl
bWVudCBtYWluIElUUyBjb21tYW5kcy4gVGhlIGNvZGUgaXMgbGFyZ2VseSBpbmhlcml0ZWQgZnJv
bQo+PiB0aGUgSVRTIGRyaXZlci4KPj4KPj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJp
Yy5hdWdlckByZWRoYXQuY29tPgo+IAo+IFsuLi5dCj4gCj4+ICsvKiBJVFMgQ09NTUFORFMgKi8K
Pj4gKwo+PiArc3RhdGljIHZvaWQgaXRzX2VuY29kZV9jbWQoc3RydWN0IGl0c19jbWRfYmxvY2sg
KmNtZCwgdTggY21kX25yKQo+PiArewo+PiArwqDCoMKgIGNtZC0+cmF3X2NtZFswXSAmPSB+MHhm
ZlVMOwo+PiArwqDCoMKgIGNtZC0+cmF3X2NtZFswXSB8PSBjbWRfbnI7Cj4+ICt9Cj4+ICsKPj4g
K3N0YXRpYyB2b2lkIGl0c19lbmNvZGVfZGV2aWQoc3RydWN0IGl0c19jbWRfYmxvY2sgKmNtZCwg
dTMyIGRldmlkKQo+PiArewo+PiArwqDCoMKgIGNtZC0+cmF3X2NtZFswXSAmPSBCSVRfVUxMKDMy
KSAtIDE7Cj4+ICvCoMKgwqAgY21kLT5yYXdfY21kWzBdIHw9ICgodTY0KWRldmlkKSA8PCAzMjsK
Pj4gK30KPj4gKwo+PiArc3RhdGljIHZvaWQgaXRzX2VuY29kZV9ldmVudF9pZChzdHJ1Y3QgaXRz
X2NtZF9ibG9jayAqY21kLCB1MzIgaWQpCj4+ICt7Cj4+ICvCoMKgwqAgY21kLT5yYXdfY21kWzFd
ICY9IH4weGZmZmZmZmZmVUw7Cj4+ICvCoMKgwqAgY21kLT5yYXdfY21kWzFdIHw9IGlkOwo+PiAr
fQo+PiArCj4+ICtzdGF0aWMgdm9pZCBpdHNfZW5jb2RlX3BoeXNfaWQoc3RydWN0IGl0c19jbWRf
YmxvY2sgKmNtZCwgdTMyIHBoeXNfaWQpCj4+ICt7Cj4+ICvCoMKgwqAgY21kLT5yYXdfY21kWzFd
ICY9IDB4ZmZmZmZmZmZVTDsKPj4gK8KgwqDCoCBjbWQtPnJhd19jbWRbMV0gfD0gKCh1NjQpcGh5
c19pZCkgPDwgMzI7Cj4+ICt9Cj4+ICsKPj4gK3N0YXRpYyB2b2lkIGl0c19lbmNvZGVfc2l6ZShz
dHJ1Y3QgaXRzX2NtZF9ibG9jayAqY21kLCB1OCBzaXplKQo+PiArewo+PiArwqDCoMKgIGNtZC0+
cmF3X2NtZFsxXSAmPSB+MHgxZlVMOwo+PiArwqDCoMKgIGNtZC0+cmF3X2NtZFsxXSB8PSBzaXpl
ICYgMHgxZjsKPj4gK30KPj4gKwo+PiArc3RhdGljIHZvaWQgaXRzX2VuY29kZV9pdHQoc3RydWN0
IGl0c19jbWRfYmxvY2sgKmNtZCwgdTY0IGl0dF9hZGRyKQo+PiArewo+PiArwqDCoMKgIGNtZC0+
cmF3X2NtZFsyXSAmPSB+MHhmZmZmZmZmZmZmZmZVTDsKPj4gK8KgwqDCoCBjbWQtPnJhd19jbWRb
Ml0gfD0gaXR0X2FkZHIgJiAweGZmZmZmZmZmZmYwMFVMOwo+PiArfQo+PiArCj4+ICtzdGF0aWMg
dm9pZCBpdHNfZW5jb2RlX3ZhbGlkKHN0cnVjdCBpdHNfY21kX2Jsb2NrICpjbWQsIGludCB2YWxp
ZCkKPj4gK3sKPj4gK8KgwqDCoCBjbWQtPnJhd19jbWRbMl0gJj0gfigxVUwgPDwgNjMpOwo+PiAr
wqDCoMKgIGNtZC0+cmF3X2NtZFsyXSB8PSAoKHU2NCkhIXZhbGlkKSA8PCA2MzsKPj4gK30KPj4g
Kwo+PiArc3RhdGljIHZvaWQgaXRzX2VuY29kZV90YXJnZXQoc3RydWN0IGl0c19jbWRfYmxvY2sg
KmNtZCwgdTY0Cj4+IHRhcmdldF9hZGRyKQo+PiArewo+PiArwqDCoMKgIGNtZC0+cmF3X2NtZFsy
XSAmPSB+KDB4ZmZmZmZmZmZmVUwgPDwgMTYpOwo+PiArwqDCoMKgIGNtZC0+cmF3X2NtZFsyXSB8
PSAodGFyZ2V0X2FkZHIgJiAoMHhmZmZmZmZmZlVMIDw8IDE2KSk7Cj4+ICt9Cj4+ICsKPj4gK3N0
YXRpYyB2b2lkIGl0c19lbmNvZGVfY29sbGVjdGlvbihzdHJ1Y3QgaXRzX2NtZF9ibG9jayAqY21k
LCB1MTYgY29sKQo+PiArewo+PiArwqDCoMKgIGNtZC0+cmF3X2NtZFsyXSAmPSB+MHhmZmZmVUw7
Cj4+ICvCoMKgwqAgY21kLT5yYXdfY21kWzJdIHw9IGNvbDsKPj4gK30KPiAKPiBUaGUgY29tbWFu
ZCBlbmNvZGluZyBjYW4gYmUgcmVmYWN0b3JlZCBsaWtlOgo+IAo+IGh0dHBzOi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQv
P2lkPTRkMzZmMTM2ZDU3YWVhNmY2NDQwODg2MTA2ZTI0NmJiN2U1OTE4ZDgKPiAKPiAKPiB3aGlj
aCB3aWxsIGxvb2sgbXVjaCBjbGVhcmVyLgpPSwo+IAo+IFsuLi5dCj4gCj4+ICtzdGF0aWMgdm9p
ZCBpdHNfc2VuZF9zaW5nbGVfY29tbWFuZChpdHNfY21kX2J1aWxkZXJfdCBidWlsZGVyLAo+PiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGl0c19jbWRfZGVz
YyAqZGVzYykKPj4gK3sKPj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2NtZF9ibG9jayAqY21kLCAqbmV4
dF9jbWQ7Cj4+ICsKPj4gK8KgwqDCoCBjbWQgPSBpdHNfYWxsb2NhdGVfZW50cnkoKTsKPj4gK8Kg
wqDCoCBidWlsZGVyKGNtZCwgZGVzYyk7Cj4+ICvCoMKgwqAgbmV4dF9jbWQgPSBpdHNfcG9zdF9j
b21tYW5kcygpOwo+PiArCj4+ICvCoMKgwqAgaXRzX3dhaXRfZm9yX3JhbmdlX2NvbXBsZXRpb24o
Y21kLCBuZXh0X2NtZCk7Cj4+ICt9Cj4+ICsKPj4gKwo+IAo+IGV4dHJhIGxpbmUuCk9LCj4gCj4+
ICtzdGF0aWMgdm9pZCBpdHNfYnVpbGRfbWFwZF9jbWQoc3RydWN0IGl0c19jbWRfYmxvY2sgKmNt
ZCwKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgaXRzX2Nt
ZF9kZXNjICpkZXNjKQo+PiArewo+PiArwqDCoMKgIHVuc2lnbmVkIGxvbmcgaXR0X2FkZHI7Cj4+
ICvCoMKgwqAgdTggc2l6ZSA9IDEyOyAvKiA0MDk2IGV2ZW50aWRzICovCj4gCj4gTWF5YmUgdXNl
IGRlc2MtPml0c19tYXBkX2NtZC5kZXYtPm5yX2l0ZXMgaW5zdGVhZCBhcyB3ZSBhbHJlYWR5IGhh
dmUgaXQ/Ck9LCj4gCj4+ICsKPj4gK8KgwqDCoCBpdHRfYWRkciA9ICh1bnNpZ25lZAo+PiBsb25n
KSh2aXJ0X3RvX3BoeXMoZGVzYy0+aXRzX21hcGRfY21kLmRldi0+aXR0KSk7Cj4+ICvCoMKgwqAg
aXR0X2FkZHIgPSBBTElHTihpdHRfYWRkciwgSVRTX0lUVF9BTElHTik7Cj4+ICsKPj4gK8KgwqDC
oCBpdHNfZW5jb2RlX2NtZChjbWQsIEdJVFNfQ01EX01BUEQpOwo+PiArwqDCoMKgIGl0c19lbmNv
ZGVfZGV2aWQoY21kLCBkZXNjLT5pdHNfbWFwZF9jbWQuZGV2LT5kZXZpY2VfaWQpOwo+PiArwqDC
oMKgIGl0c19lbmNvZGVfc2l6ZShjbWQsIHNpemUgLSAxKTsKPj4gK8KgwqDCoCBpdHNfZW5jb2Rl
X2l0dChjbWQsIGl0dF9hZGRyKTsKPj4gK8KgwqDCoCBpdHNfZW5jb2RlX3ZhbGlkKGNtZCwgZGVz
Yy0+aXRzX21hcGRfY21kLnZhbGlkKTsKPj4gK8KgwqDCoCBpdHNfZml4dXBfY21kKGNtZCk7Cj4+
ICvCoMKgwqAgaWYgKGRlc2MtPnZlcmJvc2UpCj4+ICvCoMKgwqDCoMKgwqDCoCBwcmludGYoIklU
UzogTUFQRCBkZXZpZD0lZCBzaXplID0gMHgleCBpdHQ9MHglbHggdmFsaWQ9JWRcbiIsCj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRlc2MtPml0c19tYXBkX2NtZC5kZXYtPmRldmljZV9pZCwK
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZSwgaXR0X2FkZHIsIGRlc2MtPml0c19tYXBk
X2NtZC52YWxpZCk7Cj4+ICsKPiAKPiBleHRyYSBsaW5lLgo+IAo+IEFsbCBvZiB0aGVzZSBhcmUg
dHJpdmlhbCB0aGluZ3MgYW5kIGZlZWwgZnJlZSB0byBpZ25vcmUgdGhlbSwKPiBSZXZpZXdlZC1i
eTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+CnRoYW5rcyEKCkVyaWMKPiAKPiAK
PiBUaGFua3MKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
