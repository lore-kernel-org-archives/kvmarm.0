Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06890C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 17 Oct 2022 22:19:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76C674B77B;
	Mon, 17 Oct 2022 18:19:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LHXFVpfQKMRl; Mon, 17 Oct 2022 18:19:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 382B94B75C;
	Mon, 17 Oct 2022 18:19:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4913B4B731
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 18:19:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rm4UMSkfswco for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 18:19:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9E224B632
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 18:19:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666045159;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=J22Buvx1QUdA1KfjsZHS/HHBKp3etxDqB4gvS2Hya9U=;
 b=HDV6SDWrVFTxyWMVeiNCwXRnb+H4BZHMbt9X9WrWSlbTiwyLDtFc0kZn5ncWViH2iajw5T
 vi8QVRUPdTymVM6BmckxE/3SW8PFvvIfxj8i8KgiD+7TJ11GgiorWbgRjBtUeicfPoRjCH
 XwOi0CqHIgUEZhZv+fB8t9qHUzLwZMo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-6odBANwtM_CYot3N0g1dxg-1; Mon, 17 Oct 2022 18:19:18 -0400
X-MC-Unique: 6odBANwtM_CYot3N0g1dxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11E3A1C1436E;
 Mon, 17 Oct 2022 22:19:02 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C7C2640C206B;
 Mon, 17 Oct 2022 22:18:41 +0000 (UTC)
Subject: Re: [PATCH 3/6] KVM: selftests: memslot_perf_test: Probe memory slots
 for once
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-4-gshan@redhat.com>
 <fb3926da-a683-2811-71a4-31fe36a9cb50@maciej.szmigiero.name>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <b720dbad-4b8b-a617-f782-7f95bcdb3d54@redhat.com>
Date: Tue, 18 Oct 2022 06:18:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <fb3926da-a683-2811-71a4-31fe36a9cb50@maciej.szmigiero.name>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

T24gMTAvMTgvMjIgMTozNCBBTSwgTWFjaWVqIFMuIFN6bWlnaWVybyB3cm90ZToKPiBPbiAxNC4x
MC4yMDIyIDA5OjE5LCBHYXZpbiBTaGFuIHdyb3RlOgo+PiBwcmVwYXJlX3ZtKCkgaXMgY2FsbGVk
IGluIGV2ZXJ5IGl0ZXJhdGlvbiBhbmQgcnVuLiBUaGUgYWxsb3dlZCBtZW1vcnkKPj4gc2xvdHMg
KEtWTV9DQVBfTlJfTUVNU0xPVFMpIGFyZSBwcm9iZWQgZm9yIG11bHRpcGxlIHRpbWVzLiBJdCdz
IG5vdAo+PiBmcmVlIGFuZCB1bm5lY2Vzc2FyeS4KPj4KPj4gTW92ZSB0aGUgcHJvYmluZyBsb2dp
YyBmb3IgdGhlIGFsbG93ZWQgbWVtb3J5IHNsb3RzIHRvIHBhcnNlX2FyZ3MoKQo+PiBmb3Igb25j
ZSwgd2hpY2ggaXMgdXBwZXIgbGF5ZXIgb2YgcHJlcGFyZV92bSgpLgo+Pgo+PiBObyBmdW5jdGlv
bmFsIGNoYW5nZSBpbnRlbmRlZC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogR2F2aW4gU2hhbiA8Z3No
YW5AcmVkaGF0LmNvbT4KPj4gLS0tCj4+IMKgIC4uLi90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbWVt
c2xvdF9wZXJmX3Rlc3QuYyB8IDI5ICsrKysrKysrKystLS0tLS0tLS0KPj4gwqAgMSBmaWxlIGNo
YW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQo+Pgo+PiBkaWZmIC0tZ2l0
IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL21lbXNsb3RfcGVyZl90ZXN0LmMgYi90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbWVtc2xvdF9wZXJmX3Rlc3QuYwo+PiBpbmRleCBkY2I0
OTJiM2YyN2IuLmQ1YWE5MTQ4Zjk2ZiAxMDA2NDQKPj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMva3ZtL21lbXNsb3RfcGVyZl90ZXN0LmMKPj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMva3ZtL21lbXNsb3RfcGVyZl90ZXN0LmMKPj4gQEAgLTI0NSwyNyArMjQ1LDE3IEBAIHN0
YXRpYyBib29sIHByZXBhcmVfdm0oc3RydWN0IHZtX2RhdGEgKmRhdGEsIGludCBuc2xvdHMsIHVp
bnQ2NF90ICptYXhzbG90cywKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdm9p
ZCAqZ3Vlc3RfY29kZSwgdWludDY0X3QgbWVtcGFnZXMsCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHN0cnVjdCB0aW1lc3BlYyAqc2xvdF9ydW50aW1lKQo+PiDCoCB7Cj4+IC3C
oMKgwqAgdWludDMyX3QgbWF4X21lbV9zbG90czsKPj4gwqDCoMKgwqDCoCB1aW50NjRfdCByZW1w
YWdlczsKPj4gwqDCoMKgwqDCoCB1aW50NjRfdCBndWVzdF9hZGRyOwo+PiDCoMKgwqDCoMKgIHVp
bnQzMl90IHNsb3Q7Cj4+IMKgwqDCoMKgwqAgc3RydWN0IHRpbWVzcGVjIHRzdGFydDsKPj4gwqDC
oMKgwqDCoCBzdHJ1Y3Qgc3luY19hcmVhICpzeW5jOwo+PiAtwqDCoMKgIG1heF9tZW1fc2xvdHMg
PSBrdm1fY2hlY2tfY2FwKEtWTV9DQVBfTlJfTUVNU0xPVFMpOwo+PiAtwqDCoMKgIFRFU1RfQVNT
RVJUKG1heF9tZW1fc2xvdHMgPiAxLAo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiS1ZNX0NB
UF9OUl9NRU1TTE9UUyBzaG91bGQgYmUgZ3JlYXRlciB0aGFuIDEiKTsKPj4gLcKgwqDCoCBURVNU
X0FTU0VSVChuc2xvdHMgPiAxIHx8IG5zbG90cyA9PSAtMSwKPj4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgIlNsb3QgY291bnQgY2FwIHNob3VsZCBiZSBncmVhdGVyIHRoYW4gMSIpOwo+PiAtwqDC
oMKgIGlmIChuc2xvdHMgIT0gLTEpCj4+IC3CoMKgwqDCoMKgwqDCoCBtYXhfbWVtX3Nsb3RzID0g
bWluKG1heF9tZW1fc2xvdHMsICh1aW50MzJfdCluc2xvdHMpOwo+PiAtwqDCoMKgIHByX2luZm9f
digiQWxsb3dlZCBudW1iZXIgb2YgbWVtb3J5IHNsb3RzOiAlIlBSSXUzMiJcbiIsIG1heF9tZW1f
c2xvdHMpOwo+PiAtCj4+IMKgwqDCoMKgwqAgVEVTVF9BU1NFUlQobWVtcGFnZXMgPiAxLAo+PiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiQ2FuJ3QgdGVzdCB3aXRob3V0IGFueSBtZW1vcnki
KTsKPj4gwqDCoMKgwqDCoCBkYXRhLT5ucGFnZXMgPSBtZW1wYWdlczsKPj4gLcKgwqDCoCBkYXRh
LT5uc2xvdHMgPSBtYXhfbWVtX3Nsb3RzIC0gMTsKPj4gK8KgwqDCoCBkYXRhLT5uc2xvdHMgPSBu
c2xvdHM7Cj4+IMKgwqDCoMKgwqAgZGF0YS0+cGFnZXNfcGVyX3Nsb3QgPSBtZW1wYWdlcyAvIGRh
dGEtPm5zbG90czsKPj4gwqDCoMKgwqDCoCBpZiAoIWRhdGEtPnBhZ2VzX3Blcl9zbG90KSB7Cj4+
IMKgwqDCoMKgwqDCoMKgwqDCoCAqbWF4c2xvdHMgPSBtZW1wYWdlcyArIDE7Cj4+IEBAIC04ODUs
OCArODc1LDggQEAgc3RhdGljIGJvb2wgcGFyc2VfYXJncyhpbnQgYXJnYywgY2hhciAqYXJndltd
LAo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPj4gwqDCoMKgwqDCoMKgwqDC
oMKgIGNhc2UgJ3MnOgo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0YXJncy0+bnNsb3Rz
ID0gYXRvaShvcHRhcmcpOwo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAodGFyZ3MtPm5z
bG90cyA8PSAwICYmIHRhcmdzLT5uc2xvdHMgIT0gLTEpIHsKPj4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBwcl9pbmZvKCJTbG90IGNvdW50IGNhcCBoYXMgdG8gYmUgcG9zaXRpdmUg
b3IgLTEgZm9yIG5vIGNhcFxuIik7Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICh0YXJn
cy0+bnNsb3RzIDw9IDEgJiYgdGFyZ3MtPm5zbG90cyAhPSAtMSkgewo+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHByX2luZm8oIlNsb3QgY291bnQgY2FwIG11c3QgYmUgbGFyZ2Vy
IHRoYW4gMSBvciAtMSBmb3Igbm8gY2FwXG4iKTsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCByZXR1cm4gZmFsc2U7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0K
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+IEBAIC05MzIsNiArOTIyLDE5
IEBAIHN0YXRpYyBib29sIHBhcnNlX2FyZ3MoaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSwKPj4gwqDC
oMKgwqDCoMKgwqDCoMKgIHJldHVybiBmYWxzZTsKPj4gwqDCoMKgwqDCoCB9Cj4+ICvCoMKgwqAg
LyogTWVtb3J5IHNsb3QgMCBpcyByZXNlcnZlZCAqLwo+PiArwqDCoMKgIGlmICh0YXJncy0+bnNs
b3RzID09IC0xKSB7Cj4+ICvCoMKgwqDCoMKgwqDCoCB0YXJncy0+bnNsb3RzID0ga3ZtX2NoZWNr
X2NhcChLVk1fQ0FQX05SX01FTVNMT1RTKSAtIDE7Cj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAodGFy
Z3MtPm5zbG90cyA8IDEpIHsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJfaW5mbygiS1ZN
X0NBUF9OUl9NRU1TTE9UUyBzaG91bGQgYmUgZ3JlYXRlciB0aGFuIDFcbiIpOwo+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gZmFsc2U7Cj4+ICvCoMKgwqDCoMKgwqDCoCB9Cj4+ICvC
oMKgwqAgfSBlbHNlIHsKPj4gK8KgwqDCoMKgwqDCoMKgIHRhcmdzLT5uc2xvdHMtLTsKPj4gK8Kg
wqDCoCB9Cj4+ICsKPj4gK8KgwqDCoCBwcl9pbmZvX3YoIk51bWJlciBvZiBtZW1vcnkgc2xvdHM6
ICVkXG4iLCB0YXJncy0+bnNsb3RzKTsKPj4gKwo+IAo+IENhbid0IHNlZSBhbnkgY2FwcGluZyBv
ZiB0aGUgY29tbWFuZCBsaW5lIHByb3ZpZGVkIHNsb3QgY291bnQgdG8KPiBLVk1fQ0FQX05SX01F
TVNMT1RTIHZhbHVlLCBsaWtlIHRoZSBvbGQgY29kZSBkaWQuCj4gCgpJbmRlZWQuIEkgd2FudGVk
IHRvIGF2b2lkIGV4dHJhIHZhcmlhYmxlIEBtYXhfbWVtX3Nsb3RzIGFuZCB0aGUKY2FwcGluZyBp
cyBtaXNzZWQuIEkgd2lsbCBmaXggaXQgdXAgaW4gbmV4dCByZXZpc2lvbi4KCj4+IMKgwqDCoMKg
wqAgcmV0dXJuIHRydWU7Cj4+IMKgIH0KClRoYW5rcywKR2F2aW4KCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
