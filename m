Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20910C2D0DB
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 13:30:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95ADD21835
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 13:30:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SZKGZ4tF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95ADD21835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F5DB4AC6C;
	Mon, 20 Jan 2020 08:30:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IvCMaAV715Wi; Mon, 20 Jan 2020 08:30:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 304294AF25;
	Mon, 20 Jan 2020 08:30:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A361B4AECF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 08:30:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0hfUB8LOQYne for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 08:30:29 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93E0E4AC6C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 08:30:29 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579527029;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=TahDzpx2FwVLwxvnjEhWFO8fvu/DLphSie6ZIG78wig=;
 b=SZKGZ4tFKTQuXPVUBU6AFyQODU2vaDRz0FITjYFKseu/uk+AwkvFtO1FkZ9cZKGYrnVEs2
 SVuyK3SFtzTy3+fDJ0uFW8NIOmhvvc7pOe5SpeQMbnhnED0HfFXNjie65vS0iC/3TPjKSL
 lEVRvfFPqgOs45+S/g8alAeyO7gyhas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-vo7-Jc-tPgOWVGMX5t687w-1; Mon, 20 Jan 2020 08:30:26 -0500
X-MC-Unique: vo7-Jc-tPgOWVGMX5t687w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8A018010C4;
 Mon, 20 Jan 2020 13:30:23 +0000 (UTC)
Received: from [10.36.117.108] (ovpn-117-108.ams2.redhat.com [10.36.117.108])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CA2284790;
 Mon, 20 Jan 2020 13:30:18 +0000 (UTC)
Subject: Re: [RFC 2/3] KVM: arm64: pmu: Fix chained SW_INCR counters
To: Marc Zyngier <maz@kernel.org>
References: <20191204204426.9628-1-eric.auger@redhat.com>
 <20191204204426.9628-3-eric.auger@redhat.com>
 <561ac6df385e977cc51d51a8ab28ee49@www.loen.fr>
 <2b30c1ca-3bc0-9f73-4bea-ee42bb74cbac@redhat.com>
 <15507faca89a980056df7119e105e82a@www.loen.fr>
 <145cdd1c-266c-6252-9688-e9e4c6809dfd@redhat.com>
 <20200119175851.2104d86f@why>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <2a989f57-c6ff-652f-4c0d-50881639024d@redhat.com>
Date: Mon, 20 Jan 2020 14:30:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200119175851.2104d86f@why>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

SGkgTWFyYywKT24gMS8xOS8yMCA2OjU4IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gVGh1
LCA1IERlYyAyMDE5IDIwOjAxOjQyICswMTAwCj4gQXVnZXIgRXJpYyA8ZXJpYy5hdWdlckByZWRo
YXQuY29tPiB3cm90ZToKPiAKPiBIaSBFcmljLAo+IAo+PiBIaSBNYXJjLAo+Pgo+PiBPbiAxMi81
LzE5IDM6NTIgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IE9uIDIwMTktMTItMDUgMTQ6MDYs
IEF1Z2VyIEVyaWMgd3JvdGU6ICAKPj4+PiBIaSBNYXJjLAo+Pj4+Cj4+Pj4gT24gMTIvNS8xOSAx
MDo0MyBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOiAgCj4+Pj4+IEhpIEVyaWMsCj4+Pj4+Cj4+Pj4+
IE9uIDIwMTktMTItMDQgMjA6NDQsIEVyaWMgQXVnZXIgd3JvdGU6ICAKPj4+Pj4+IEF0IHRoZSBt
b21lbnQgYSBTV19JTkNSIGNvdW50ZXIgYWx3YXlzIG92ZXJmbG93cyBvbiAzMi1iaXQKPj4+Pj4+
IGJvdW5kYXJ5LCBpbmRlcGVuZGVudGx5IG9uIHdoZXRoZXIgdGhlIG4rMXRoIGNvdW50ZXIgaXMK
Pj4+Pj4+IHByb2dyYW1tZWQgYXMgQ0hBSU4uCj4+Pj4+Pgo+Pj4+Pj4gQ2hlY2sgd2hldGhlciB0
aGUgU1dfSU5DUiBjb3VudGVyIGlzIGEgNjRiIGNvdW50ZXIgYW5kIGlmIHNvLAo+Pj4+Pj4gaW1w
bGVtZW50IHRoZSA2NGIgbG9naWMuCj4+Pj4+Pgo+Pj4+Pj4gRml4ZXM6IDgwZjM5M2EyM2JlNiAo
IktWTTogYXJtL2FybTY0OiBTdXBwb3J0IGNoYWluZWQgUE1VIGNvdW50ZXJzIikKPj4+Pj4+IFNp
Z25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KPj4+Pj4+IC0t
LQo+Pj4+Pj4gwqB2aXJ0L2t2bS9hcm0vcG11LmMgfCAxNiArKysrKysrKysrKysrKystCj4+Pj4+
PiDCoDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+Pj4+
Pgo+Pj4+Pj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS9wbXUuYyBiL3ZpcnQva3ZtL2FybS9w
bXUuYwo+Pj4+Pj4gaW5kZXggYzNmOGIwNTk4ODFlLi43YWI0NzdkYjJmNzUgMTAwNjQ0Cj4+Pj4+
PiAtLS0gYS92aXJ0L2t2bS9hcm0vcG11LmMKPj4+Pj4+ICsrKyBiL3ZpcnQva3ZtL2FybS9wbXUu
Ywo+Pj4+Pj4gQEAgLTQ5MSw2ICs0OTEsOCBAQCB2b2lkIGt2bV9wbXVfc29mdHdhcmVfaW5jcmVt
ZW50KHN0cnVjdCBrdm1fdmNwdQo+Pj4+Pj4gKnZjcHUsIHU2NCB2YWwpCj4+Pj4+Pgo+Pj4+Pj4g
wqDCoMKgwqAgZW5hYmxlID0gX192Y3B1X3N5c19yZWcodmNwdSwgUE1DTlRFTlNFVF9FTDApOwo+
Pj4+Pj4gwqDCoMKgwqAgZm9yIChpID0gMDsgaSA8IEFSTVY4X1BNVV9DWUNMRV9JRFg7IGkrKykg
ewo+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGJvb2wgY2hhaW5lZCA9IHRlc3RfYml0KGkgPj4gMSwg
dmNwdS0+YXJjaC5wbXUuY2hhaW5lZCk7Cj4+Pj4+PiArICAKPj4+Pj4KPj4+Pj4gSSdkIHJhdGhl
ciB5b3UgdXNlIGt2bV9wbXVfcG1jX2lzX2NoYWluZWQoKSByYXRoZXIgdGhhbiBvcGVuLWNvZGlu
Zwo+Pj4+PiB0aGlzLiBCdXQgc2VlIGJlbG93Ogo+Pj4+PiAgCj4+Pj4+PiDCoMKgwqDCoMKgwqDC
oMKgIGlmICghKHZhbCAmIEJJVChpKSkpCj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Y29udGludWU7Cj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgIHR5cGUgPSBfX3ZjcHVfc3lzX3JlZyh2
Y3B1LCBQTUVWVFlQRVIwX0VMMCArIGkpCj4+Pj4+PiBAQCAtNTAwLDggKzUwMiwyMCBAQCB2b2lk
IGt2bV9wbXVfc29mdHdhcmVfaW5jcmVtZW50KHN0cnVjdCBrdm1fdmNwdQo+Pj4+Pj4gKnZjcHUs
IHU2NCB2YWwpCj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVnID0gX192Y3B1X3N5
c19yZWcodmNwdSwgUE1FVkNOVFIwX0VMMCArIGkpICsgMTsKPj4+Pj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCByZWcgPSBsb3dlcl8zMl9iaXRzKHJlZyk7Cj4+Pj4+PiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgX192Y3B1X3N5c19yZWcodmNwdSwgUE1FVkNOVFIwX0VMMCArIGkpID0gcmVn
Owo+Pj4+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFyZWcpCj4+Pj4+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBpZiAocmVnKSAvKiBubyBvdmVyZmxvdyAqLwo+Pj4+Pj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsKPj4+Pj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGlmIChjaGFpbmVkKSB7Cj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJlZyA9IF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNRVZDTlRSMF9FTDAgKyBpICsgMSkg
KyAxOwo+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZWcgPSBsb3dlcl8z
Ml9iaXRzKHJlZyk7Cj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fdmNw
dV9zeXNfcmVnKHZjcHUsIFBNRVZDTlRSMF9FTDAgKyBpICsgMSkgPSByZWc7Cj4+Pj4+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChyZWcpCj4+Pj4+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29udGludWU7Cj4+Pj4+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIC8qIG1hcmsgYW4gb3ZlcmZsb3cgb24gaGlnaCBjb3VudGVyICov
Cj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fdmNwdV9zeXNfcmVnKHZj
cHUsIFBNT1ZTU0VUX0VMMCkgfD0gQklUKGkgKyAxKTsKPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIH0gZWxzZSB7Cj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8q
IG1hcmsgYW4gb3ZlcmZsb3cgKi8KPj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNT1ZTU0VUX0VMMCkgfD0gQklUKGkpOwo+Pj4+Pj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+Pj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCB9Cj4+Pj4+
PiDCoMKgwqDCoCB9Cj4+Pj4+PiDCoH0gIAo+Pj4+Pgo+Pj4+PiBJIHRoaW5rIHRoZSB3aG9sZSBm
dW5jdGlvbiBpcyBhIGJpdCBvZiBhIG1lc3MsIGFuZCBjb3VsZCBiZSBiZXR0ZXIKPj4+Pj4gc3Ry
dWN0dXJlZCB0byB0cmVhdCA2NGJpdCBjb3VudGVycyBhcyBhIGZpcnN0IGNsYXNzIGNpdGl6ZW4u
Cj4+Pj4+Cj4+Pj4+IEknbSBzdWdnZXN0aW5nIHNvbWV0aGluZyBhbG9uZyB0aG9zZSBsaW5lcywg
d2hpY2ggdHJpZXMgdG8KPj4+Pj4gc3RyZWFtbGluZSB0aGluZ3MgYSBiaXQgYW5kIGtlZXAgdGhl
IGZsb3cgdW5pZm9ybSBiZXR3ZWVuIHRoZQo+Pj4+PiB0d28gd29yZCBzaXplcy4gSU1ITywgaXQg
aGVscHMgcmVhc29ubmluZyBhYm91dCBpdCBhbmQgZ2l2ZXMKPj4+Pj4gc2NvcGUgdG8gdGhlIEFS
TXY4LjUgZnVsbCA2NGJpdCBjb3VudGVycy4uLiBJdCBpcyBvZiBjb3Vyc2UKPj4+Pj4gY29tcGxl
dGVseSB1bnRlc3RlZC4gIAo+Pj4+Cj4+Pj4gTG9va3MgT0sgdG8gbWUgYXMgd2VsbC4gT25lIHJl
bWFyayB0aG91Z2gsIGRvbid0IHdlIG5lZWQgdG8gdGVzdCBpZiB0aGUKPj4+PiBuKzF0aCByZWcg
aXMgZW5hYmxlZCBiZWZvcmUgaW5jcmVtZW50aW5nIGl0PyAgCj4+Pgo+Pj4gSG1tbS4gSSdtIG5v
dCBzdXJlLiBJIHRoaW5rIHdlIHNob3VsZCBtYWtlIHN1cmUgdGhhdCB3ZSBkb24ndCBmbGFnCj4+
PiBhIGNvdW50ZXIgYXMgYmVpbmcgY2hhaW5lZCBpZiB0aGUgb2RkIGNvdW50ZXIgaXMgZGlzYWJs
ZWQsIHJhdGhlcgo+Pj4gdGhhbiBjaGVja2luZyBpdCBoZXJlLiBBcyBsb25nIGFzIHRoZSBvZGQg
Y291bnRlciBpcyBub3QgY2hhaW5lZAo+Pj4gKmFuZCogZW5hYmxlZCwgd2Ugc2hvdWxkbid0IHRv
dWNoIGl0Lj4KPj4+IEFnYWluLCB1bnRlc3RlZDoKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvdmlydC9r
dm0vYXJtL3BtdS5jIGIvdmlydC9rdm0vYXJtL3BtdS5jCj4+PiBpbmRleCBjZjM3MWY2NDNhZGUu
LjQ3MzY2ODE3Y2QyYSAxMDA2NDQKPj4+IC0tLSBhL3ZpcnQva3ZtL2FybS9wbXUuYwo+Pj4gKysr
IGIvdmlydC9rdm0vYXJtL3BtdS5jCj4+PiBAQCAtMTUsNiArMTUsNyBAQAo+Pj4gwqAjaW5jbHVk
ZSA8a3ZtL2FybV92Z2ljLmg+Cj4+Pgo+Pj4gwqBzdGF0aWMgdm9pZCBrdm1fcG11X2NyZWF0ZV9w
ZXJmX2V2ZW50KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0Cj4+PiBzZWxlY3RfaWR4KTsKPj4+
ICtzdGF0aWMgdm9pZCBrdm1fcG11X3VwZGF0ZV9wbWNfY2hhaW5lZChzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIHU2NAo+Pj4gc2VsZWN0X2lkeCk7Cj4+Pgo+Pj4gwqAjZGVmaW5lIFBFUkZfQVRUUl9D
RkcxX0tWTV9QTVVfQ0hBSU5FRCAweDEKPj4+Cj4+PiBAQCAtMjk4LDYgKzI5OSw3IEBAIHZvaWQg
a3ZtX3BtdV9lbmFibGVfY291bnRlcl9tYXNrKHN0cnVjdCBrdm1fdmNwdQo+Pj4gKnZjcHUsIHU2
NCB2YWwpCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgKiBGb3IgaGlnaCBjb3VudGVycyBvZiBjaGFp
bmVkIGV2ZW50cyB3ZSBtdXN0IHJlY3JlYXRlIHRoZQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgICog
cGVyZiBldmVudCB3aXRoIHRoZSBsb25nICg2NGJpdCkgYXR0cmlidXRlIHNldC4KPj4+IMKgwqDC
oMKgwqDCoMKgwqDCoCAqLwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGt2bV9wbXVfdXBkYXRlX3BtY19j
aGFpbmVkKHZjcHUsIGkpOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoCBpZiAoa3ZtX3BtdV9wbWNfaXNf
Y2hhaW5lZChwbWMpICYmCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX3BtdV9pZHhf
aXNfaGlnaF9jb3VudGVyKGkpKSB7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX3Bt
dV9jcmVhdGVfcGVyZl9ldmVudCh2Y3B1LCBpKTsKPj4+IEBAIC02NDUsNyArNjQ3LDggQEAgc3Rh
dGljIHZvaWQga3ZtX3BtdV91cGRhdGVfcG1jX2NoYWluZWQoc3RydWN0Cj4+PiBrdm1fdmNwdSAq
dmNwdSwgdTY0IHNlbGVjdF9pZHgpCj4+PiDCoMKgwqDCoCBzdHJ1Y3Qga3ZtX3BtdSAqcG11ID0g
JnZjcHUtPmFyY2gucG11Owo+Pj4gwqDCoMKgwqAgc3RydWN0IGt2bV9wbWMgKnBtYyA9ICZwbXUt
PnBtY1tzZWxlY3RfaWR4XTsKPj4+Cj4+PiAtwqDCoMKgIGlmIChrdm1fcG11X2lkeF9oYXNfY2hh
aW5fZXZ0eXBlKHZjcHUsIHBtYy0+aWR4KSkgewo+Pj4gK8KgwqDCoCBpZiAoa3ZtX3BtdV9pZHhf
aGFzX2NoYWluX2V2dHlwZSh2Y3B1LCBwbWMtPmlkeCkgJiYKPj4+ICvCoMKgwqDCoMKgwqDCoCBr
dm1fcG11X2NvdW50ZXJfaXNfZW5hYmxlZCh2Y3B1LCBwbWMtPmlkeCkpIHsgIAo+Pgo+PiBJbiBj
cmVhdGVfcGVyZl9ldmVudCgpLCBoYXNfY2hhaW5fZXZ0eXBlKCkgaXMgdXNlZCBhbmQgYSA2NGIg
c2FtcGxlCj4+IHBlcmlvZCB3b3VsZCBiZSBjaG9zZW4gZXZlbiBpZiB0aGUgY291bnRlcnMgYXJl
IGRpc2pvaW5lZCAoc2luY2UgdGhlIG9kZAo+PiBpcyBkaXNhYmxlZCkuIFdlIHdvdWxkIG5lZWQg
dG8gdXNlIHBtY19pc19jaGFpbmVkKCkgaW5zdGVhZC4KPj4KPj4gV2l0aCBwZXJmX2V2ZW50cywg
dGhlIGNoZWNrIG9mIHdoZXRoZXIgdGhlIG9kZCByZWdpc3RlciBpcyBlbmFibGVkIGlzCj4+IHBy
b3Blcmx5IGRvbmUgKGNyZWF0ZV9wZXJmX2V2ZW50KS4gVGhlbiBJIHVuZGVyc3RhbmQgd2hlbmV2
ZXIgdGhlcmUgaXMgYQo+PiBjaGFuZ2UgaW4gZW5hYmxlIHN0YXRlIG9yIHR5cGUgd2UgZGVsZXRl
IHRoZSBwcmV2aW91cyBwZXJmIGV2ZW50IGFuZAo+PiByZS1jcmVhdGUgYSBuZXcgb25lLiBFbmFi
bGUgc3RhdGUgY2hlY2sganVzdCBpcyBtaXNzaW5nIGZvciBTV19JTkNSLgo+IAo+IENhbiB5b3Ug
cGxlYXNlIHJlc3BpbiB0aGlzPyBJJ2QgbGlrZSB0byBoYXZlIGl0IHF1ZXVlZCBxdWlja2x5LCBp
ZiBhdAo+IGFsbCBwb3NzaWJsZS4KClllcyBJIGFtIGdvaW5nIHRvIHJlc3BpbiBxdWlja2x5LgoK
VGhhbmtzCgpFcmljCj4gCj4+Cj4+IFNvbWUgb3RoZXIgcXVlc3Rpb25zOgo+PiAtIGRvIHdlIG5l
ZWQgYSBwZXJmIGV2ZW50IHRvIGJlIGNyZWF0ZWQgZXZlbiBpZiB0aGUgY291bnRlciBpcyBub3QK
Pj4gZW5hYmxlZD8gRm9yIGluc3RhbmNlIG9uIGNvdW50ZXIgcmVzZXRzLCBjcmVhdGVfcGVyZl9l
dmVudHMgZ2V0IGNhbGxlZC4KPiAKPiBJdCBzaG91bGRuJ3QgYmUgbmVjZXNzYXJ5Lgo+IAo+PiAt
IGFsc28gYWN0aW9ucyBhcmUgbWFkZSBmb3IgY291bnRlcnMgd2hpY2ggYXJlIG5vdCBpbXBsZW1l
bnRlZC4gbG9vcAo+PiB1bnRpbCBBUk1WOF9QTVVfTUFYX0NPVU5URVJTLiBEbyB5b3UgdGhpbmsg
aXQgaXMgdmFsdWFibGUgdG8gaGF2ZSBhCj4+IGJpdG1hc2sgb2Ygc3VwcG9ydGVkIGNvdW50ZXJz
IHN0b3JlZCBiZWZvcmUgcG11IHJlYWRpbmVzcz8KPj4gSSBjYW4gcHJvcG9zZSBzdWNoIGNoYW5n
ZXMgaWYgeW91IHRoaW5rIHRoZXkgYXJlIHZhbHVhYmxlLgo+IAo+IFRoYXQgd291bGQgY2VydGFp
bmx5IGJlIGEgcGVyZm9ybWFuY2Ugb3B0aW1pemF0aW9uLgo+IAo+IFRoYW5rcywKPiAKPiAJTS4K
PiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
