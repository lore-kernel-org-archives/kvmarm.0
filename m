Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC606C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 11:12:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54C8461547
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 11:12:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 54C8461547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB8DB4B160;
	Fri, 19 Nov 2021 06:12:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6WdVRSWMmAxC; Fri, 19 Nov 2021 06:12:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7374B4B12E;
	Fri, 19 Nov 2021 06:12:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D092F4B0ED
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 06:12:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BWL6UQqFJmCX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 06:12:20 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1954B0EC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 06:12:20 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637320340;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=v9aM8Q9WTgCdAcq1DwTYBIbHacVjNPNyPuk3SIn5Ogo=;
 b=Y5u6o/SITIEFx5iirPJSj+jPcybr0slOyA6o9OAX1eCoan5Jgl85LhJepk6yRcKOxTtlGo
 16m9/QQiwKj16adr9NibvoAy9wKpKIPo/oEUfVhQMQHU9KDUo8cxpquZcTL4LSv4kBiZNh
 BAMWKGrDE8RogwAOyBwpqU+vDD3VRx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-q9Xl1pdfPpq0qtRHegRmsg-1; Fri, 19 Nov 2021 06:12:19 -0500
X-MC-Unique: q9Xl1pdfPpq0qtRHegRmsg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E1B81006AA0;
 Fri, 19 Nov 2021 11:12:17 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B6196060F;
 Fri, 19 Nov 2021 11:12:11 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
 id C39744172ED4; Fri, 19 Nov 2021 08:11:50 -0300 (-03)
Date: Fri, 19 Nov 2021 08:11:50 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: Re: [RFC PATCH 2/2] KVM: arm64: export cntvoff in debugfs
Message-ID: <20211119111150.GA43513@fuller.cnet>
References: <20211119102117.22304-1-nsaenzju@redhat.com>
 <20211119102117.22304-3-nsaenzju@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211119102117.22304-3-nsaenzju@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: will@kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 rostedt@goodmis.org, mingo@redhat.com, catalin.marinas@arm.com,
 nilal@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

T24gRnJpLCBOb3YgMTksIDIwMjEgYXQgMTE6MjE6MThBTSArMDEwMCwgTmljb2xhcyBTYWVueiBK
dWxpZW5uZSB3cm90ZToKPiBXaGlsZSB1c2luZyBjbnR2Y3QgYXMgdGhlIHJhdyBjbG9jayBmb3Ig
dHJhY2luZywgaXQncyBwb3NzaWJsZSB0bwo+IHN5bmNocm9uaXplIGhvc3QvZ3Vlc3QgdHJhY2Vz
IGp1c3QgYnkga25vd2luZyB0aGUgdmlydHVhbCBvZmZzZXQgYXBwbGllZAo+IHRvIHRoZSBndWVz
dCdzIHZpcnR1YWwgY291bnRlci4KPiAKPiBUaGlzIGlzIGFsc28gdGhlIGNhc2Ugb24geDg2IHdo
ZW4gVFNDIGlzIGF2YWlsYWJsZS4gVGhlIG9mZnNldCBpcwo+IGV4cG9zZWQgaW4gZGVidWdmcyBh
cyAndHNjLW9mZnNldCcgb24gYSBwZXIgdmNwdSBiYXNpcy4gU28gbGV0J3MKPiBpbXBsZW1lbnQg
dGhlIHNhbWUgZm9yIGFybTY0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgU2FlbnogSnVs
aWVubmUgPG5zYWVuemp1QHJlZGhhdC5jb20+CgpIaSBOaWNvbGFzLAoKQVJNOgoKQ05UVkNUU1Nf
RUwwLCBDb3VudGVyLXRpbWVyIFNlbGYtU3luY2hyb25pemVkIFZpcnR1YWwgQ291bnQgcmVnaXN0
ZXIKVGhlIENOVFZDVFNTX0VMMCBjaGFyYWN0ZXJpc3RpY3MgYXJlOgoKUHVycG9zZQpIb2xkcyB0
aGUgNjQtYml0IHZpcnR1YWwgY291bnQgdmFsdWUuIFRoZSB2aXJ0dWFsIGNvdW50IHZhbHVlIGlz
IGVxdWFsIHRvIHRoZSAKcGh5c2ljYWwgY291bnQgdmFsdWUgdmlzaWJsZSBpbiBDTlRQQ1RfRUww
IG1pbnVzIHRoZSB2aXJ0dWFsIG9mZnNldCB2aXNpYmxlIGluIENOVFZPRkZfRUwyLgoJCQkJCSAg
IF5eXl5eCgp4ODY6CgoyNC42LjUgVGltZS1TdGFtcCBDb3VudGVyIE9mZnNldCBhbmQgTXVsdGlw
bGllcgpUaGUgVk0tZXhlY3V0aW9uIGNvbnRyb2wgZmllbGRzIGluY2x1ZGUgYSA2NC1iaXQgVFND
LW9mZnNldCBmaWVsZC4gSWYgdGhlIOKAnFJEVFNDIGV4aXRpbmfigJ0gY29udHJvbCBpcyAwIGFu
ZCB0aGUg4oCcdXNlClRTQyBvZmZzZXR0aW5n4oCdIGNvbnRyb2wgaXMgMSwgdGhpcyBmaWVsZCBj
b250cm9scyBleGVjdXRpb25zIG9mIHRoZSBSRFRTQyBhbmQgUkRUU0NQIGluc3RydWN0aW9ucy4g
SXQgYWxzbyBjb250cm9scwpleGVjdXRpb25zIG9mIHRoZSBSRE1TUiBpbnN0cnVjdGlvbiB0aGF0
IHJlYWQgZnJvbSB0aGUgSUEzMl9USU1FX1NUQU1QX0NPVU5URVIgTVNSLiBGb3IgYWxsIG9mIHRo
ZXNlLCB0aGUKdmFsdWUgb2YgdGhlIFRTQyBvZmZzZXQgaXMgYWRkZWQgdG8gdGhlIHZhbHVlIG9m
IHRoZSB0aW1lLXN0YW1wIGNvdW50ZXIsIGFuZCB0aGUgc3VtIGlzIHJldHVybmVkIHRvIGd1ZXN0
IHNvZnR3YXJlCgkJCSAgIF5eXl5eCmluIEVEWDpFQVguCgpTbyBpdCB3b3VsZCBiZSBuaWNlIHRv
IGtlZXAgdGhlIGZvcm11bGEgY29uc2lzdGVudCBmb3IgdXNlcnNwYWNlOgoKR1VFU1RfQ0xPQ0tf
VkFMID0gSE9TVF9DTE9DS19WQUwgKyBDTE9DS19PRkZTRVQKClNvIHdvdWxkIGhhdmUgdG8gYWRk
IGEgbmVnYXRpdmUgc2lnbiB0byB0aGUgdmFsdWUgdG8gdXNlcnNwYWNlLgoKT3RoZXIgdGhhbiB0
aGF0LCBib3RoIHRoZSBjbG9jayB2YWx1ZSAoVkNOVFBDVF9FTDApIGFuZCB0aGUgb2Zmc2V0CihD
TlRWT0ZGX0VMMikgYXJlIG5vdCBtb2RpZmllZCBkdXJpbmcgZ3Vlc3QgZXhlY3V0aW9uPyBUaGF0
IGlzLCBDTlRWT0ZGX0VMMiBpcwp3cml0dGVuIG9uY2UgZHVyaW5nIGd1ZXN0IGluaXRpYWxpemF0
aW9uLgoKCj4gLS0tCj4gIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8ICAxICsK
PiAgYXJjaC9hcm02NC9rdm0vTWFrZWZpbGUgICAgICAgICAgIHwgIDIgKy0KPiAgYXJjaC9hcm02
NC9rdm0vYXJjaF90aW1lci5jICAgICAgIHwgIDIgKy0KPiAgYXJjaC9hcm02NC9rdm0vZGVidWdm
cy5jICAgICAgICAgIHwgMjUgKysrKysrKysrKysrKysrKysrKysrKysrKwo+ICBpbmNsdWRlL2t2
bS9hcm1fYXJjaF90aW1lci5oICAgICAgfCAgMyArKysKPiAgNSBmaWxlcyBjaGFuZ2VkLCAzMSBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC9h
cm02NC9rdm0vZGVidWdmcy5jCj4gCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20va3ZtX2hvc3QuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+IGluZGV4
IDJhNWY3ZjM4MDA2Zi4uMTMwNTM0YzkwNzllIDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJtNjQvaW5j
bHVkZS9hc20va3ZtX2hvc3QuaAo+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hv
c3QuaAo+IEBAIC0yOSw2ICsyOSw3IEBACj4gICNpbmNsdWRlIDxhc20vdGhyZWFkX2luZm8uaD4K
PiAgCj4gICNkZWZpbmUgX19LVk1fSEFWRV9BUkNIX0lOVENfSU5JVElBTElaRUQKPiArI2RlZmlu
ZSBfX0tWTV9IQVZFX0FSQ0hfVkNQVV9ERUJVR0ZTCj4gIAo+ICAjZGVmaW5lIEtWTV9IQUxUX1BP
TExfTlNfREVGQVVMVCA1MDAwMDAKPiAgCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL01h
a2VmaWxlIGIvYXJjaC9hcm02NC9rdm0vTWFrZWZpbGUKPiBpbmRleCA5ODliYjVkYWQyYzguLjE3
YmU3Y2Y3NzBmMiAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9NYWtlZmlsZQo+ICsrKyBi
L2FyY2gvYXJtNjQva3ZtL01ha2VmaWxlCj4gQEAgLTE0LDcgKzE0LDcgQEAga3ZtLXkgOj0gJChL
Vk0pL2t2bV9tYWluLm8gJChLVk0pL2NvYWxlc2NlZF9tbWlvLm8gJChLVk0pL2V2ZW50ZmQubyBc
Cj4gIAkgJChLVk0pL3ZmaW8ubyAkKEtWTSkvaXJxY2hpcC5vICQoS1ZNKS9iaW5hcnlfc3RhdHMu
byBcCj4gIAkgYXJtLm8gbW11Lm8gbW1pby5vIHBzY2kubyBwZXJmLm8gaHlwZXJjYWxscy5vIHB2
dGltZS5vIFwKPiAgCSBpbmplY3RfZmF1bHQubyB2YV9sYXlvdXQubyBoYW5kbGVfZXhpdC5vIFwK
PiAtCSBndWVzdC5vIGRlYnVnLm8gcmVzZXQubyBzeXNfcmVncy5vIFwKPiArCSBndWVzdC5vIGRl
YnVnLm8gZGVidWdmcy5vIHJlc2V0Lm8gc3lzX3JlZ3MubyBcCj4gIAkgdmdpYy1zeXMtcmVnLXYz
Lm8gZnBzaW1kLm8gcG11Lm8gXAo+ICAJIGFyY2hfdGltZXIubyB0cm5nLm9cCj4gIAkgdmdpYy92
Z2ljLm8gdmdpYy92Z2ljLWluaXQubyBcCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2Fy
Y2hfdGltZXIuYyBiL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYwo+IGluZGV4IDNkZjY3YzEy
NzQ4OS4uZWU2OTM4N2Y3ZmI2IDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGlt
ZXIuYwo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYwo+IEBAIC04Miw3ICs4Miw3
IEBAIHU2NCB0aW1lcl9nZXRfY3ZhbChzdHJ1Y3QgYXJjaF90aW1lcl9jb250ZXh0ICpjdHh0KQo+
ICAJfQo+ICB9Cj4gIAo+IC1zdGF0aWMgdTY0IHRpbWVyX2dldF9vZmZzZXQoc3RydWN0IGFyY2hf
dGltZXJfY29udGV4dCAqY3R4dCkKPiArdTY0IHRpbWVyX2dldF9vZmZzZXQoc3RydWN0IGFyY2hf
dGltZXJfY29udGV4dCAqY3R4dCkKPiAgewo+ICAJc3RydWN0IGt2bV92Y3B1ICp2Y3B1ID0gY3R4
dC0+dmNwdTsKPiAgCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2RlYnVnZnMuYyBiL2Fy
Y2gvYXJtNjQva3ZtL2RlYnVnZnMuYwo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0Cj4gaW5kZXggMDAw
MDAwMDAwMDAwLi5mMGY1MDgzZWE4ZDQKPiAtLS0gL2Rldi9udWxsCj4gKysrIGIvYXJjaC9hcm02
NC9rdm0vZGVidWdmcy5jCj4gQEAgLTAsMCArMSwyNSBAQAo+ICsvLyBTUERYLUxpY2Vuc2UtSWRl
bnRpZmllcjogR1BMLTIuMC1vbmx5Cj4gKy8qCj4gKyAqIENvcHlyaWdodCAoQykgMjAyMSBSZWQg
SGF0IEluYy4KPiArICovCj4gKwo+ICsjaW5jbHVkZSA8bGludXgva3ZtX2hvc3QuaD4KPiArI2lu
Y2x1ZGUgPGxpbnV4L2RlYnVnZnMuaD4KPiArCj4gKyNpbmNsdWRlIDxrdm0vYXJtX2FyY2hfdGlt
ZXIuaD4KPiArCj4gK3N0YXRpYyBpbnQgdmNwdV9nZXRfY250dl9vZmZzZXQodm9pZCAqZGF0YSwg
dTY0ICp2YWwpCj4gK3sKPiArCXN0cnVjdCBrdm1fdmNwdSAqdmNwdSA9IChzdHJ1Y3Qga3ZtX3Zj
cHUgKilkYXRhOwo+ICsKPiArCSp2YWwgPSB0aW1lcl9nZXRfb2Zmc2V0KHZjcHVfdnRpbWVyKHZj
cHUpKTsKPiArCj4gKwlyZXR1cm4gMDsKPiArfQo+ICsKPiArREVGSU5FX1NJTVBMRV9BVFRSSUJV
VEUodmNwdV9jbnR2b2ZmX2ZvcHMsIHZjcHVfZ2V0X2NudHZfb2Zmc2V0LCBOVUxMLCAiJWxsZFxu
Iik7Cj4gKwo+ICt2b2lkIGt2bV9hcmNoX2NyZWF0ZV92Y3B1X2RlYnVnZnMoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1LCBzdHJ1Y3QgZGVudHJ5ICpkZWJ1Z2ZzX2RlbnRyeSkKPiArewo+ICsJZGVidWdm
c19jcmVhdGVfZmlsZSgiY250dm9mZiIsIDA0NDQsIGRlYnVnZnNfZGVudHJ5LCB2Y3B1LCAmdmNw
dV9jbnR2b2ZmX2ZvcHMpOwo+ICt9Cj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUva3ZtL2FybV9hcmNo
X3RpbWVyLmggYi9pbmNsdWRlL2t2bS9hcm1fYXJjaF90aW1lci5oCj4gaW5kZXggNTFjMTkzODEx
MDhjLi5kZTBjZDliZTgyNWMgMTAwNjQ0Cj4gLS0tIGEvaW5jbHVkZS9rdm0vYXJtX2FyY2hfdGlt
ZXIuaAo+ICsrKyBiL2luY2x1ZGUva3ZtL2FybV9hcmNoX3RpbWVyLmgKPiBAQCAtMTA2LDQgKzEw
Niw3IEBAIHZvaWQga3ZtX2FybV90aW1lcl93cml0ZV9zeXNyZWcoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LAo+ICB1MzIgdGltZXJfZ2V0X2N0bChzdHJ1Y3QgYXJjaF90aW1lcl9jb250ZXh0ICpjdHh0
KTsKPiAgdTY0IHRpbWVyX2dldF9jdmFsKHN0cnVjdCBhcmNoX3RpbWVyX2NvbnRleHQgKmN0eHQp
Owo+ICAKPiArLyogTmVkZGVkIGZvciBkZWJ1Z2ZzICovCj4gK3U2NCB0aW1lcl9nZXRfb2Zmc2V0
KHN0cnVjdCBhcmNoX3RpbWVyX2NvbnRleHQgKmN0eHQpOwo+ICsKPiAgI2VuZGlmCj4gLS0gCj4g
Mi4zMy4xCj4gCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
