Return-Path: <SRS0=Em7b=4W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D5AC3F2D1
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 19:42:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 807732073B
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 19:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCZRFwfA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 807732073B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04A624AEBB;
	Thu,  5 Mar 2020 14:42:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QcmgAZWcg2gb; Thu,  5 Mar 2020 14:42:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCB1B4AEB1;
	Thu,  5 Mar 2020 14:42:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C9D14AEB1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 14:42:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b4x0tFpqkcRM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2020 14:42:30 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E5434AEAF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 14:42:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583437350;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=o2QOFnMMcZZ+uHhgLltxx0kXPKpZY9J5vvEiymhKIFA=;
 b=FCZRFwfAQIG7MCMIN8Vxo7Hmn6wJZMYNQjR/qLCRhN99HGaUVtoOhICpCEWmQn2XI4nXPu
 szkLmMQSQus6q3LqT9VIvgVgABGhixBcwrdZPTx8JxUBExN2O6C3sDhzDja8a7UQfc+TXZ
 FGzxeTZrMrh845gDQ6jeLpRP0cLTq/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-bSZWOfNyOa-fM50ncwp2lg-1; Thu, 05 Mar 2020 14:42:28 -0500
X-MC-Unique: bSZWOfNyOa-fM50ncwp2lg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D738107ACC4;
 Thu,  5 Mar 2020 19:42:26 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ABF460BF1;
 Thu,  5 Mar 2020 19:42:23 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 09/14] arm/arm64: ITS: Device and
 collection Initialization
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-10-eric.auger@redhat.com>
 <42a8964a-af3d-0117-bfac-5db6b7b832dd@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <aac8e67f-1733-9f8e-f7bf-6870af4605c0@redhat.com>
Date: Thu, 5 Mar 2020 20:42:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <42a8964a-af3d-0117-bfac-5db6b7b832dd@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

SGkgWmVuZ2h1aSwKCk9uIDIvNy8yMCA2OjQxIEFNLCBaZW5naHVpIFl1IHdyb3RlOgo+IEhpIEVy
aWMsCj4gCj4gT24gMjAyMC8xLzI4IDE4OjM0LCBFcmljIEF1Z2VyIHdyb3RlOgo+PiBJbnRyb2R1
Y2UgYW4gaGVscGVyIGZ1bmN0aW9ucyB0byByZWdpc3Rlcgo+PiAtIGEgbmV3IGRldmljZSwgY2hh
cmFjdGVyaXplZCBieSBpdHMgZGV2aWNlIGlkIGFuZCB0aGUKPj4gwqDCoCBtYXggbnVtYmVyIG9m
IGV2ZW50IElEcyB0aGF0IGRpbWVuc2lvbiBpdHMgSVRUIChJbnRlcnJ1cHQKPj4gwqDCoCBUcmFu
c2xhdGlvbiBUYWJsZSkuwqAgVGhlIGZ1bmN0aW9uIGFsbG9jYXRlcyB0aGUgSVRULgo+Pgo+PiAt
IGEgbmV3IGNvbGxlY3Rpb24sIGNoYXJhY3Rlcml6ZWQgYnkgaXRzIElEIGFuZCB0aGUKPj4gwqDC
oCB0YXJnZXQgcHJvY2Vzc2luZyBlbmdpbmUgKFBFKS4KPj4KPj4gU2lnbmVkLW9mZi1ieTogRXJp
YyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+Pgo+PiAtLS0KPj4KPj4gdjIgLT4gdjM6
Cj4+IC0gcy9yZXBvcnRfYWJvcnQvYXNzZXJ0Cj4+Cj4+IHYxIC0+IHYyOgo+PiAtIHMvbmJfL25y
Xwo+PiAtLS0KPj4gwqAgbGliL2FybS9hc20vZ2ljLXYzLWl0cy5oIHwgMjAgKysrKysrKysrKysr
KysrKystCj4+IMKgIGxpYi9hcm0vZ2ljLXYzLWl0cy5jwqDCoMKgwqAgfCA0NCArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4+IMKgIDIgZmlsZXMgY2hhbmdlZCwgNjMg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvbGliL2FybS9h
c20vZ2ljLXYzLWl0cy5oIGIvbGliL2FybS9hc20vZ2ljLXYzLWl0cy5oCj4+IGluZGV4IGZlNzNj
MDQuLmFjZDk3YTkgMTAwNjQ0Cj4+IC0tLSBhL2xpYi9hcm0vYXNtL2dpYy12My1pdHMuaAo+PiAr
KysgYi9saWIvYXJtL2FzbS9naWMtdjMtaXRzLmgKPj4gQEAgLTMxLDYgKzMxLDE5IEBAIHN0cnVj
dCBpdHNfYmFzZXIgewo+PiDCoCB9Owo+PiDCoCDCoCAjZGVmaW5lIEdJVFNfQkFTRVJfTlJfUkVH
U8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDgKPj4gKyNkZWZpbmUgR0lUU19NQVhfREVWSUNF
U8KgwqDCoMKgwqDCoMKgIDgKPj4gKyNkZWZpbmUgR0lUU19NQVhfQ09MTEVDVElPTlPCoMKgwqDC
oMKgwqDCoCA4Cj4+ICsKPj4gK3N0cnVjdCBpdHNfZGV2aWNlIHsKPj4gK8KgwqDCoCB1MzIgZGV2
aWNlX2lkO8KgwqDCoCAvKiBkZXZpY2UgSUQgKi8KPj4gK8KgwqDCoCB1MzIgbnJfaXRlczvCoMKg
wqAgLyogTWF4IEludGVycnVwdCBUcmFuc2xhdGlvbiBFbnRyaWVzICovCj4+ICvCoMKgwqAgdm9p
ZCAqaXR0O8KgwqDCoCAvKiBJbnRlcnJ1cHQgVHJhbnNsYXRpb24gVGFibGUgR1BBICovCj4+ICt9
Owo+PiArCj4+ICtzdHJ1Y3QgaXRzX2NvbGxlY3Rpb24gewo+PiArwqDCoMKgIHU2NCB0YXJnZXRf
YWRkcmVzczsKPj4gK8KgwqDCoCB1MTYgY29sX2lkOwo+PiArfTsKPj4gwqAgwqAgc3RydWN0IGl0
c19kYXRhIHsKPj4gwqDCoMKgwqDCoCB2b2lkICpiYXNlOwo+PiBAQCAtMzgsNiArNTEsMTAgQEAg
c3RydWN0IGl0c19kYXRhIHsKPj4gwqDCoMKgwqDCoCBzdHJ1Y3QgaXRzX2Jhc2VyIGJhc2VyW0dJ
VFNfQkFTRVJfTlJfUkVHU107Cj4+IMKgwqDCoMKgwqAgc3RydWN0IGl0c19jbWRfYmxvY2sgKmNt
ZF9iYXNlOwo+PiDCoMKgwqDCoMKgIHN0cnVjdCBpdHNfY21kX2Jsb2NrICpjbWRfd3JpdGU7Cj4+
ICvCoMKgwqAgc3RydWN0IGl0c19kZXZpY2UgZGV2aWNlc1tHSVRTX01BWF9ERVZJQ0VTXTsKPj4g
K8KgwqDCoCB1MzIgbnJfZGV2aWNlczvCoMKgwqDCoMKgwqDCoCAvKiBBbGxvY2F0ZWQgRGV2aWNl
cyAqLwo+PiArwqDCoMKgIHN0cnVjdCBpdHNfY29sbGVjdGlvbiBjb2xsZWN0aW9uc1tHSVRTX01B
WF9DT0xMRUNUSU9OU107Cj4+ICvCoMKgwqAgdTMyIG5yX2NvbGxlY3Rpb25zO8KgwqDCoCAvKiBB
bGxvY2F0ZWQgQ29sbGVjdGlvbnMgKi8KPj4gwqAgfTsKPj4gwqAgwqAgZXh0ZXJuIHN0cnVjdCBp
dHNfZGF0YSBpdHNfZGF0YTsKPj4gQEAgLTkwLDcgKzEwNyw2IEBAIGV4dGVybiBzdHJ1Y3QgaXRz
X2RhdGEgaXRzX2RhdGE7Cj4+IMKgICNkZWZpbmUgR0lUU19CQVNFUl9UWVBFX0RFVklDRcKgwqDC
oMKgwqDCoMKgIDEKPj4gwqAgI2RlZmluZSBHSVRTX0JBU0VSX1RZUEVfQ09MTEVDVElPTsKgwqDC
oCA0Cj4+IMKgIC0KPj4gwqAgc3RydWN0IGl0c19jbWRfYmxvY2sgewo+PiDCoMKgwqDCoMKgIHU2
NCByYXdfY21kWzRdOwo+PiDCoCB9Owo+PiBAQCAtMTAwLDYgKzExNiw4IEBAIGV4dGVybiB2b2lk
IGl0c19pbml0KHZvaWQpOwo+PiDCoCBleHRlcm4gaW50IGl0c19wYXJzZV9iYXNlcihpbnQgaSwg
c3RydWN0IGl0c19iYXNlciAqYmFzZXIpOwo+PiDCoCBleHRlcm4gc3RydWN0IGl0c19iYXNlciAq
aXRzX2xvb2t1cF9iYXNlcihpbnQgdHlwZSk7Cj4+IMKgIGV4dGVybiB2b2lkIGl0c19lbmFibGVf
ZGVmYXVsdHModm9pZCk7Cj4+ICtleHRlcm4gc3RydWN0IGl0c19kZXZpY2UgKml0c19jcmVhdGVf
ZGV2aWNlKHUzMiBkZXZfaWQsIGludCBucl9pdGVzKTsKPj4gK2V4dGVybiBzdHJ1Y3QgaXRzX2Nv
bGxlY3Rpb24gKml0c19jcmVhdGVfY29sbGVjdGlvbih1MzIgY29sX2lkLCB1MzIKPj4gdGFyZ2V0
X3BlKTsKPj4gwqAgwqAgI2Vsc2UgLyogX19hcm1fXyAqLwo+PiDCoCBkaWZmIC0tZ2l0IGEvbGli
L2FybS9naWMtdjMtaXRzLmMgYi9saWIvYXJtL2dpYy12My1pdHMuYwo+PiBpbmRleCBkMWU3ZTUy
Li5jMmRjZDAxIDEwMDY0NAo+PiAtLS0gYS9saWIvYXJtL2dpYy12My1pdHMuYwo+PiArKysgYi9s
aWIvYXJtL2dpYy12My1pdHMuYwo+PiBAQCAtMTc1LDMgKzE3NSw0NyBAQCB2b2lkIGl0c19lbmFi
bGVfZGVmYXVsdHModm9pZCkKPj4gwqAgwqDCoMKgwqDCoCB3cml0ZWwoR0lUU19DVExSX0VOQUJM
RSwgaXRzX2RhdGEuYmFzZSArIEdJVFNfQ1RMUik7Cj4+IMKgIH0KPj4gKwo+PiArc3RydWN0IGl0
c19kZXZpY2UgKml0c19jcmVhdGVfZGV2aWNlKHUzMiBkZXZpY2VfaWQsIGludCBucl9pdGVzKQo+
PiArewo+PiArwqDCoMKgIHN0cnVjdCBpdHNfYmFzZXIgKmJhc2VyOwo+PiArwqDCoMKgIHN0cnVj
dCBpdHNfZGV2aWNlICpuZXc7Cj4+ICvCoMKgwqAgdW5zaWduZWQgbG9uZyBuLCBvcmRlcjsKPj4g
Kwo+PiArwqDCoMKgIGFzc2VydChpdHNfZGF0YS5ucl9kZXZpY2VzIDwgR0lUU19NQVhfREVWSUNF
Uyk7Cj4+ICsKPiAKPiAKPj4gK8KgwqDCoCBiYXNlciA9IGl0c19sb29rdXBfYmFzZXIoR0lUU19C
QVNFUl9UWVBFX0RFVklDRSk7Cj4+ICvCoMKgwqAgaWYgKCFiYXNlcikKPj4gK8KgwqDCoMKgwqDC
oMKgIHJldHVybiBOVUxMOwo+IAo+IEkgdGhpbmsgdGhlcmUncyBubyBuZWVkIHRvIGxvb2t1cCB0
aGUgZGV2aWNlIGJhc2VyIGhlcmUuIEFzIHRoZQo+IGRldmljZSBiYXNlciBzaG91bGQgaGF2ZSBh
bHJlYWR5IGJlZW4gc2V0dXAgYXQgaW5pdGlhbGl6YXRpb24KPiB0aW1lIChpLmUuIGluIGl0c19l
bmFibGVfZGVmYXVsdHMpLiBBbmQgYW55d2F5LCAnYmFzZXInIGlzIG5vdAo+IGJlaW5nIHVzZWQg
aW4gdGhpcyBmdW5jdGlvbi4KSSBmdWxseSBhZ3JlZS4gSSBSZW1vdmVkIHRoYXQuCgpUaGFua3Mh
CgpFcmljCj4gCj4gCj4gVGhhbmtzLAo+IFplbmdodWkKPiAKPj4gKwo+PiArwqDCoMKgIG5ldyA9
ICZpdHNfZGF0YS5kZXZpY2VzW2l0c19kYXRhLm5yX2RldmljZXNdOwo+PiArCj4+ICvCoMKgwqAg
bmV3LT5kZXZpY2VfaWQgPSBkZXZpY2VfaWQ7Cj4+ICvCoMKgwqAgbmV3LT5ucl9pdGVzID0gbnJf
aXRlczsKPj4gKwo+PiArwqDCoMKgIG4gPSAoaXRzX2RhdGEudHlwZXIuaXRlX3NpemUgKiBucl9p
dGVzKSA+PiBQQUdFX1NISUZUOwo+PiArwqDCoMKgIG9yZGVyID0gaXNfcG93ZXJfb2ZfMihuKSA/
IGZscyhuKSA6IGZscyhuKSArIDE7Cj4+ICvCoMKgwqAgbmV3LT5pdHQgPSAodm9pZCAqKXZpcnRf
dG9fcGh5cyhhbGxvY19wYWdlcyhvcmRlcikpOwo+PiArCj4+ICvCoMKgwqAgaXRzX2RhdGEubnJf
ZGV2aWNlcysrOwo+PiArwqDCoMKgIHJldHVybiBuZXc7Cj4+ICt9Cj4+ICsKPj4gK3N0cnVjdCBp
dHNfY29sbGVjdGlvbiAqaXRzX2NyZWF0ZV9jb2xsZWN0aW9uKHUzMiBjb2xfaWQsIHUzMiBwZSkK
Pj4gK3sKPj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2NvbGxlY3Rpb24gKm5ldzsKPj4gKwo+PiArwqDC
oMKgIGFzc2VydChpdHNfZGF0YS5ucl9jb2xsZWN0aW9ucyA8IEdJVFNfTUFYX0NPTExFQ1RJT05T
KTsKPj4gKwo+PiArwqDCoMKgIG5ldyA9ICZpdHNfZGF0YS5jb2xsZWN0aW9uc1tpdHNfZGF0YS5u
cl9jb2xsZWN0aW9uc107Cj4+ICsKPj4gK8KgwqDCoCBuZXctPmNvbF9pZCA9IGNvbF9pZDsKPj4g
Kwo+PiArwqDCoMKgIGlmIChpdHNfZGF0YS50eXBlci5wdGEpCj4+ICvCoMKgwqDCoMKgwqDCoCBu
ZXctPnRhcmdldF9hZGRyZXNzID0gKHU2NClnaWN2M19kYXRhLnJlZGlzdF9iYXNlW3BlXTsKPj4g
K8KgwqDCoCBlbHNlCj4+ICvCoMKgwqDCoMKgwqDCoCBuZXctPnRhcmdldF9hZGRyZXNzID0gcGUg
PDwgMTY7Cj4+ICsKPj4gK8KgwqDCoCBpdHNfZGF0YS5ucl9jb2xsZWN0aW9ucysrOwo+PiArwqDC
oMKgIHJldHVybiBuZXc7Cj4+ICt9Cj4+Cj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
