Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA327C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jan 2022 07:22:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DBBD49EF9;
	Thu, 13 Jan 2022 02:22:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Tuf3X63tmoS; Thu, 13 Jan 2022 02:22:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEBBD49ED3;
	Thu, 13 Jan 2022 02:22:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2F8449ED3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 02:21:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8BUvqwPe-agu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jan 2022 02:21:58 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D664349EC2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 02:21:58 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1642058518;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=8nRNr5aU4a8XQrLe04v5XgMtz6JohugAgXgShhheXBE=;
 b=Ktz8MH3QGW+dlSUCeKTV6f8N9wxr/1NVuNrq3fCCAjqa2+/eNXvC15P2h6lrKlt8YETZCr
 tUgNZHHn4CA4ABcTPDPYtuwfP9Uo5+Jch8cAs0liIgI1m9L+zR5BmZidpX92hOuMGuKmPy
 uxO7HApkw1GSa6My1nlUYughfY+OZpI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-fMeBDy2WOpahrl775iFFDw-1; Thu, 13 Jan 2022 02:21:36 -0500
X-MC-Unique: fMeBDy2WOpahrl775iFFDw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DFD0189DF41;
 Thu, 13 Jan 2022 07:21:35 +0000 (UTC)
Received: from [10.72.13.202] (ovpn-13-202.pek2.redhat.com [10.72.13.202])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 644CB1059104;
 Thu, 13 Jan 2022 07:21:28 +0000 (UTC)
Subject: Re: [PATCH v4 01/15] KVM: async_pf: Move struct kvm_async_pf around
To: Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-2-gshan@redhat.com>
 <f05db974-1145-b83e-a8ba-e73dbf4bc880@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <b42a6ade-db3b-3d42-b385-3ad8483b1f49@redhat.com>
Date: Thu, 13 Jan 2022 15:21:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <f05db974-1145-b83e-a8ba-e73dbf4bc880@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

SGkgRXJpYywKCk9uIDExLzEwLzIxIDExOjM3IFBNLCBFcmljIEF1Z2VyIHdyb3RlOgo+IE9uIDgv
MTUvMjEgMjo1OSBBTSwgR2F2aW4gU2hhbiB3cm90ZToKPj4gVGhpcyBtb3ZlcyB0aGUgZGVmaW5p
dGlvbiBvZiAic3RydWN0IGt2bV9hc3luY19wZiIgYW5kIHRoZSByZWxhdGVkCj4+IGZ1bmN0aW9u
cyBhZnRlciAic3RydWN0IGt2bV92Y3B1IiBzbyB0aGF0IG5ld2x5IGFkZGVkIGlubGluZSBmdW5j
dGlvbnMKPj4gaW4gdGhlIHN1YnNlcXVlbnQgcGF0Y2hlcyBjYW4gZGVyZWZlcmVuY2UgInN0cnVj
dCBrdm1fdmNwdSIgcHJvcGVybHkuCj4+IE90aGVyd2lzZSwgdGhlIHVuZXhwZWN0ZWQgYnVpbGQg
ZXJyb3Igd2lsbCBiZSByYWlzZWQ6Cj4+Cj4+ICAgICBlcnJvcjogZGVyZWZlcmVuY2luZyBwb2lu
dGVyIHRvIGluY29tcGxldGUgdHlwZSDigJhzdHJ1Y3Qga3ZtX3ZjcHXigJkKPj4gICAgIHJldHVy
biAhbGlzdF9lbXB0eV9jYXJlZnVsKCZ2Y3B1LT5hc3luY19wZi5kb25lKTsKPj4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXn4KPj4gU2luY2Ugd2UncmUgaGVyZSwgdGhlIHNl
cGF0b3IgYmV0d2VlbiB0eXBlIGFuZCBmaWVsZCBpbiAic3RydWN0IGt2bV92Y3B1Igo+IHNlcGFy
YXRvcgoKVGhhbmtzLCBJdCB3aWxsIGJlIGZpeGVkIGluIG5leHQgcmVzcGluLgoKPj4gaXMgcmVw
bGFjZWQgYnkgdGFiLiBUaGUgZW1wdHkgc3R1YiBrdm1fY2hlY2tfYXN5bmNfcGZfY29tcGxldGlv
bigpIGlzIGFsc28KPj4gYWRkZWQgb24gIUNPTkZJR19LVk1fQVNZTkNfUEYsIHdoaWNoIGlzIG5l
ZWRlZCBieSBzdWJzZXF1ZW50IHBhdGNoZXMgdG8KPj4gc3VwcG9ydCBhc3luY2hyb25vdXMgcGFn
ZSBmYXVsdCBvbiBBUk02NC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogR2F2aW4gU2hhbiA8Z3NoYW5A
cmVkaGF0LmNvbT4KPj4gLS0tCj4+ICAgaW5jbHVkZS9saW51eC9rdm1faG9zdC5oIHwgNDQgKysr
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLQo+PiAgIDEgZmlsZSBjaGFuZ2Vk
LCAyMyBpbnNlcnRpb25zKCspLCAyMSBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbGludXgva3ZtX2hvc3QuaCBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaAo+PiBpbmRl
eCBhZTc3MzViNDkwYjQuLjg1YjYxYTQ1NmYxYyAxMDA2NDQKPj4gLS0tIGEvaW5jbHVkZS9saW51
eC9rdm1faG9zdC5oCj4+ICsrKyBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaAo+PiBAQCAtMTk5
LDI3ICsxOTksNiBAQCBpbnQga3ZtX2lvX2J1c191bnJlZ2lzdGVyX2RldihzdHJ1Y3Qga3ZtICpr
dm0sIGVudW0ga3ZtX2J1cyBidXNfaWR4LAo+PiAgIHN0cnVjdCBrdm1faW9fZGV2aWNlICprdm1f
aW9fYnVzX2dldF9kZXYoc3RydWN0IGt2bSAqa3ZtLCBlbnVtIGt2bV9idXMgYnVzX2lkeCwKPj4g
ICAJCQkJCSBncGFfdCBhZGRyKTsKPj4gICAKPj4gLSNpZmRlZiBDT05GSUdfS1ZNX0FTWU5DX1BG
Cj4+IC1zdHJ1Y3Qga3ZtX2FzeW5jX3BmIHsKPj4gLQlzdHJ1Y3Qgd29ya19zdHJ1Y3Qgd29yazsK
Pj4gLQlzdHJ1Y3QgbGlzdF9oZWFkIGxpbms7Cj4+IC0Jc3RydWN0IGxpc3RfaGVhZCBxdWV1ZTsK
Pj4gLQlzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHU7Cj4+IC0Jc3RydWN0IG1tX3N0cnVjdCAqbW07Cj4+
IC0JZ3BhX3QgY3IyX29yX2dwYTsKPj4gLQl1bnNpZ25lZCBsb25nIGFkZHI7Cj4+IC0Jc3RydWN0
IGt2bV9hcmNoX2FzeW5jX3BmIGFyY2g7Cj4+IC0JYm9vbCAgIHdha2V1cF9hbGw7Cj4+IC0JYm9v
bCBub3RwcmVzZW50X2luamVjdGVkOwo+PiAtfTsKPj4gLQo+PiAtdm9pZCBrdm1fY2xlYXJfYXN5
bmNfcGZfY29tcGxldGlvbl9xdWV1ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwo+PiAtdm9pZCBr
dm1fY2hlY2tfYXN5bmNfcGZfY29tcGxldGlvbihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwo+PiAt
Ym9vbCBrdm1fc2V0dXBfYXN5bmNfcGYoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBncGFfdCBjcjJf
b3JfZ3BhLAo+PiAtCQkJdW5zaWduZWQgbG9uZyBodmEsIHN0cnVjdCBrdm1fYXJjaF9hc3luY19w
ZiAqYXJjaCk7Cj4+IC1pbnQga3ZtX2FzeW5jX3BmX3dha2V1cF9hbGwoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KTsKPj4gLSNlbmRpZgo+PiAtCj4+ICAgI2lmZGVmIEtWTV9BUkNIX1dBTlRfTU1VX05P
VElGSUVSCj4+ICAgc3RydWN0IGt2bV9nZm5fcmFuZ2Ugewo+PiAgIAlzdHJ1Y3Qga3ZtX21lbW9y
eV9zbG90ICpzbG90Owo+PiBAQCAtMzQ2LDYgKzMyNSwyOSBAQCBzdHJ1Y3Qga3ZtX3ZjcHUgewo+
PiAgIAlzdHJ1Y3Qga3ZtX2RpcnR5X3JpbmcgZGlydHlfcmluZzsKPj4gICB9Owo+PiAgIAo+PiAr
I2lmZGVmIENPTkZJR19LVk1fQVNZTkNfUEYKPj4gK3N0cnVjdCBrdm1fYXN5bmNfcGYgewo+PiAr
CXN0cnVjdCB3b3JrX3N0cnVjdAkJd29yazsKPj4gKwlzdHJ1Y3QgbGlzdF9oZWFkCQlsaW5rOwo+
PiArCXN0cnVjdCBsaXN0X2hlYWQJCXF1ZXVlOwo+PiArCXN0cnVjdCBrdm1fdmNwdQkJCSp2Y3B1
Owo+PiArCXN0cnVjdCBtbV9zdHJ1Y3QJCSptbTsKPj4gKwlncGFfdAkJCQljcjJfb3JfZ3BhOwo+
PiArCXVuc2lnbmVkIGxvbmcJCQlhZGRyOwo+PiArCXN0cnVjdCBrdm1fYXJjaF9hc3luY19wZglh
cmNoOwo+PiArCWJvb2wJCQkJd2FrZXVwX2FsbDsKPj4gKwlib29sCQkJCW5vdHByZXNlbnRfaW5q
ZWN0ZWQ7Cj4+ICt9Owo+PiArCj4+ICt2b2lkIGt2bV9jbGVhcl9hc3luY19wZl9jb21wbGV0aW9u
X3F1ZXVlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Cj4+ICt2b2lkIGt2bV9jaGVja19hc3luY19w
Zl9jb21wbGV0aW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Cj4+ICtib29sIGt2bV9zZXR1cF9h
c3luY19wZihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdwYV90IGNyMl9vcl9ncGEsCj4+ICsJCQl1
bnNpZ25lZCBsb25nIGh2YSwgc3RydWN0IGt2bV9hcmNoX2FzeW5jX3BmICphcmNoKTsKPj4gK2lu
dCBrdm1fYXN5bmNfcGZfd2FrZXVwX2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwo+PiArI2Vs
c2UKPj4gK3N0YXRpYyBpbmxpbmUgdm9pZCBrdm1fY2hlY2tfYXN5bmNfcGZfY29tcGxldGlvbihz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHsgfQo+IHdoeSBpcyB0aGF0IHN0dWIgbmVlZGVkIG9uIEFS
TTY0IGFuZCBub3Qgb24gdGhlIG90aGVyIGFyY2hzPwo+IAoKV2UgdXNlIHRoZSBmb2xsb3dpbmcg
cGF0dGVybiwgc3VnZ2VzdGVkIGJ5IEphbWVzIE1vcnNlLgoKaW50IGt2bV92bV9pb2N0bF9jaGVj
a19leHRlbnNpb24oc3RydWN0IGt2bSAqa3ZtLCBsb25nIGV4dCkKewogICAgICAgICBpbnQgcjsK
ICAgICAgICAgc3dpdGNoIChleHQpIHsKICAgICAgICAgICA6CiAgICAgICAgICAgICAgICAgY2Fz
ZSBLVk1fQ0FQX0FTWU5DX1BGOgogICAgICAgICBjYXNlIEtWTV9DQVBfQVNZTkNfUEZfSU5UOgog
ICAgICAgICAgICAgICAgIHIgPSBJU19FTkFCTEVEKENPTkZJR19LVk1fQVNZTkNfUEYpID8gMSA6
IDA7CiAgICAgICAgICAgICAgICAgYnJlYWs7CiAgICAgICAgIGRlZmF1bHQ6CiAgICAgICAgICAg
ICAgICAgciA9IDA7CiAgICAgICAgIH0KCiAgICAgICAgIHJldHVybiByOwp9CgpUaGFua3MsCkdh
dmluCgo+PiArI2VuZGlmCj4+ICsKPj4gICAvKiBtdXN0IGJlIGNhbGxlZCB3aXRoIGlycXMgZGlz
YWJsZWQgKi8KPj4gICBzdGF0aWMgX19hbHdheXNfaW5saW5lIHZvaWQgZ3Vlc3RfZW50ZXJfaXJx
b2ZmKHZvaWQpCj4+ICAgewo+Pgo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
