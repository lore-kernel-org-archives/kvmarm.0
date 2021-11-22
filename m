Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DC6C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 10:11:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1FE74B0BE;
	Tue, 23 Nov 2021 05:11:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6GBVC8FW9jGk; Tue, 23 Nov 2021 05:11:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7422C4B0D0;
	Tue, 23 Nov 2021 05:11:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E18A4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 15:41:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u10BTGuimkCd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Nov 2021 15:40:59 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 568A44B0E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 15:40:59 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637613659;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WRqDdF850L0C93VLFXSpRulH8UU6sU0ROB6ecfELzDs=;
 b=ip+AEJetyIiEqpE1M7I2WoQzpw5qUfCZx13S8cjCCzkQXGcGUDqYN5pwNNyul+gnh1seni
 b1vkXKvziXpHX+svk0SJZYRQs/PvmyFkj/M551UHkhFcErmlk8xMDjX7OZg+7ht+XHh2fu
 ihY8aYvYGRCqu0AmqCy5aHxIPxX99c8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-lPbQdL_tPei_fROJGKi2eg-1; Mon, 22 Nov 2021 15:40:55 -0500
X-MC-Unique: lPbQdL_tPei_fROJGKi2eg-1
Received: by mail-wm1-f70.google.com with SMTP id
 205-20020a1c00d6000000b003335d1384f1so142188wma.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 12:40:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
 :references:user-agent:mime-version:content-transfer-encoding;
 bh=WRqDdF850L0C93VLFXSpRulH8UU6sU0ROB6ecfELzDs=;
 b=jSOdDaDnfO2eNQDx2LnRI35MOgp0Ulip7lMsEAVdnG5C8QGx6M9wBYLnHvf9d1YL2x
 ejMJ8jPoRKYS4AzoUl7WOoyX9An35sfBgVWJIvxQmwoT6FG+SzMpSMYlLofK/7Ts0KVM
 CCnOt40NL8J1pfZJYJGcde8g/hby9ktEkwai2SpG5m+/AtVt+Md2l9z3GpxY7+Zzz72i
 9KWo8kprx6XNvXkp7PJHdI9DdAeVVoxGAEFTX0DAiczJOYvmt3A0AoKFpNuqfSmDkGiU
 HloQ6+VmC55j/HeXD3KtO4UD9DiNsKpleCP2pGw51pDiEfEWesFLJIxIZuvMJAH2mvpY
 8UuQ==
X-Gm-Message-State: AOAM532K3oAsn0dRukmfNVcGKvW/OnI3Re1AYQZjO+yGJ8zZAJFEuBNP
 ojEby6UWGyd86LWGAEqoInpM9C1946leVhR+8PDOD4bVCn7behXqwZe3mU/WK1lX5pjIFRjAjGZ
 pFWMxI1jyB6WXuqrBV3eVlbOu
X-Received: by 2002:a05:600c:b43:: with SMTP id
 k3mr33145721wmr.159.1637613654411; 
 Mon, 22 Nov 2021 12:40:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEBNm2G6Vn2RWskud4VMr0M2tZtX7miMSSkO0U/YK7/s72UGaytBV8OE+JlhmPzUPOrKU4+A==
X-Received: by 2002:a05:600c:b43:: with SMTP id
 k3mr33145679wmr.159.1637613654177; 
 Mon, 22 Nov 2021 12:40:54 -0800 (PST)
Received: from ?IPv6:2a0c:5a80:3c10:3400:3c70:6643:6e71:7eae?
 ([2a0c:5a80:3c10:3400:3c70:6643:6e71:7eae])
 by smtp.gmail.com with ESMTPSA id z5sm27398883wmp.26.2021.11.22.12.40.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 22 Nov 2021 12:40:53 -0800 (PST)
Message-ID: <0e948a211bd8d63ba05594fb8c03bf3a77a227a0.camel@redhat.com>
Subject: Re: [RFC PATCH 2/2] KVM: arm64: export cntvoff in debugfs
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Date: Mon, 22 Nov 2021 21:40:52 +0100
In-Reply-To: <87fsrs732b.wl-maz@kernel.org>
References: <20211119102117.22304-1-nsaenzju@redhat.com>
 <20211119102117.22304-3-nsaenzju@redhat.com> <87fsrs732b.wl-maz@kernel.org>
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35)
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nsaenzju@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Tue, 23 Nov 2021 05:11:53 -0500
Cc: will@kernel.org, catalin.marinas@arm.com, mtosatti@redhat.com,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
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

SGkgTWFyYywgdGhhbmtzIGZvciB0aGUgcmV2aWV3LgoKT24gRnJpLCAyMDIxLTExLTE5IGF0IDEy
OjE3ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gRnJpLCAxOSBOb3YgMjAyMSAxMDoy
MToxOCArMDAwMCwKPiBOaWNvbGFzIFNhZW56IEp1bGllbm5lIDxuc2FlbnpqdUByZWRoYXQuY29t
PiB3cm90ZToKPiA+IAo+ID4gV2hpbGUgdXNpbmcgY250dmN0IGFzIHRoZSByYXcgY2xvY2sgZm9y
IHRyYWNpbmcsIGl0J3MgcG9zc2libGUgdG8KPiA+IHN5bmNocm9uaXplIGhvc3QvZ3Vlc3QgdHJh
Y2VzIGp1c3QgYnkga25vd2luZyB0aGUgdmlydHVhbCBvZmZzZXQgYXBwbGllZAo+ID4gdG8gdGhl
IGd1ZXN0J3MgdmlydHVhbCBjb3VudGVyLgo+ID4gCj4gPiBUaGlzIGlzIGFsc28gdGhlIGNhc2Ug
b24geDg2IHdoZW4gVFNDIGlzIGF2YWlsYWJsZS4gVGhlIG9mZnNldCBpcwo+ID4gZXhwb3NlZCBp
biBkZWJ1Z2ZzIGFzICd0c2Mtb2Zmc2V0JyBvbiBhIHBlciB2Y3B1IGJhc2lzLiBTbyBsZXQncwo+
ID4gaW1wbGVtZW50IHRoZSBzYW1lIGZvciBhcm02NC4KPiAKPiBIb3cgZG9lcyB0aGlzIHdvcmsg
d2l0aCBOViwgd2hlcmUgdGhlIGd1ZXN0IGh5cGVydmlzb3IgaXMgaW4gY29udHJvbAo+IG9mIHRo
ZSB2aXJ0dWFsIG9mZnNldD8gCgpUQkggSSBoYW5kbid0IHRob3VnaHQgYWJvdXQgTlYuIExvb2tp
bmcgYXQgaXQgZnJvbSB0aGF0IGFuZ2xlLCBJIG5vdyBzZWUgbXkKYXBwcm9hY2ggZG9lc24ndCB3
b3JrIG9uIGhvc3RzIHRoYXQgdXNlIENOVFZDVCAocmVnYXJkbGVzcyBvZiBOVikuIFVwb24KZW50
ZXJpbmcgaW50byBhIGd1ZXN0LCB3ZSBjaGFuZ2UgQ05UVk9GRiBiZWZvcmUgdGhlIGhvc3QgaXMg
ZG9uZSB3aXRoIHRyYWNpbmcsCnNvIHRyYWNlcyBsaWtlICdrdm1fZW50cnknIHdpbGwgaGF2ZSB3
ZWlyZCB0aW1lc3RhbXBzLiBJIHdhcyBqdXN0IGx1Y2t5IHRoYXQKdGhlIGhvc3RzIEkgd2FzIHRl
c3Rpbmcgd2l0aCB1c2UgQ05UUENULgoKSSBiZWxpZXZlIHRoZSBzb2x1dGlvbiB3b3VsZCBiZSB0
byBiZSBhYmxlIHRvIGZvcmNlIGEgMCBvZmZzZXQgYmV0d2VlbgpndWVzdC9ob3N0LiBXaXRoIHRo
YXQgaW4gbWluZCwgaXMgdGhlcmUgYSByZWFzb24gd2h5IGt2bV90aW1lcl92Y3B1X2luaXQoKQpp
bXBvc2VzIGEgbm9uLXplcm8gb25lIGJ5IGRlZmF1bHQ/IEkgY2hlY2tlZCBvdXQgdGhlIGNvbW1p
dHMgdGhhdCBpbnRyb2R1Y2VkCnRoYXQgY29kZSwgYnV0IGNvdWxkbid0IGZpbmQgYSBjb21wZWxs
aW5nIHJlYXNvbi4gVk1NcyBjYW4gYWx3YXlzIGNoYW5nZSBpdAp0aHJvdWdoIEtWTV9SRUdfQVJN
X1RJTUVSX0NOVCBhZnRlcndhcmRzLgoKPiBJIGFsc28gd29uZGVyIHdoeSB3ZSBuZWVkIHRoaXMg
d2hlbiB1c2Vyc3BhY2UgYWxyZWFkeSBoYXMgZGlyZWN0IGFjY2VzcyB0bwo+IHRoYXQgaW5mb3Jt
YXRpb24gd2l0aG91dCBhbnkgZXh0cmEga2VybmVsIHN1cHBvcnQgKHJlYWQgdGhlIENOVFZDVCB2
aWV3IG9mCj4gdGhlIHZjcHUgdXNpbmcgdGhlIE9ORVJFRyBBUEksIHN1YnRyYWN0IGl0IGZyb20g
dGhlIGhvc3QgdmlldyBvZiB0aGUgY291bnRlciwKPiBqb2IgZG9uZSkuCgpXZWxsIElJVUMsIHlv
dSdyZSBhdCB0aGUgbWVyY3kgb2YgaG93IGxvbmcgaXQgdGFrZXMgdG8gcmV0dXJuIGZyb20gdGhl
IE9ORVJFRwppb2N0bC4gVGhlIHJlc3VsdHMgd2lsbCBiZSBza2V3ZWQuIEZvciBzb21lIHdvcmts
b2Fkcywgd2hlcmUgbG93IGxhdGVuY3kgaXMKa2V5LCB3ZSByZWFsbHkgbmVlZCBoaWdoIHByZWNp
c2lvbiB0cmFjZXMgaW4gdGhlIG9yZGVyIG9mIHNpbmdsZSBkaWdpdCB1cyBvcgpldmVuIDEwMHMg
b2YgbnMuIEknbSBub3Qgc3VyZSB5b3UnbGwgYmUgYWJsZSB0byBnZXQgdGhlcmUgd2l0aCB0aGF0
IGFwcHJvYWNoLgoKWy4uLl0KCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vZGVidWdm
cy5jIGIvYXJjaC9hcm02NC9rdm0vZGVidWdmcy5jCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NAo+
ID4gaW5kZXggMDAwMDAwMDAwMDAwLi5mMGY1MDgzZWE4ZDQKPiA+IC0tLSAvZGV2L251bGwKPiA+
ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2RlYnVnZnMuYwo+ID4gQEAgLTAsMCArMSwyNSBAQAo+ID4g
Ky8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKPiA+ICsvKgo+ID4gKyAq
IENvcHlyaWdodCAoQykgMjAyMSBSZWQgSGF0IEluYy4KPiA+ICsgKi8KPiA+ICsKPiA+ICsjaW5j
bHVkZSA8bGludXgva3ZtX2hvc3QuaD4KPiA+ICsjaW5jbHVkZSA8bGludXgvZGVidWdmcy5oPgo+
ID4gKwo+ID4gKyNpbmNsdWRlIDxrdm0vYXJtX2FyY2hfdGltZXIuaD4KPiA+ICsKPiA+ICtzdGF0
aWMgaW50IHZjcHVfZ2V0X2NudHZfb2Zmc2V0KHZvaWQgKmRhdGEsIHU2NCAqdmFsKQo+ID4gK3sK
PiA+ICsJc3RydWN0IGt2bV92Y3B1ICp2Y3B1ID0gKHN0cnVjdCBrdm1fdmNwdSAqKWRhdGE7Cj4g
PiArCj4gPiArCSp2YWwgPSB0aW1lcl9nZXRfb2Zmc2V0KHZjcHVfdnRpbWVyKHZjcHUpKTsKPiA+
ICsKPiA+ICsJcmV0dXJuIDA7Cj4gPiArfQo+ID4gKwo+ID4gK0RFRklORV9TSU1QTEVfQVRUUklC
VVRFKHZjcHVfY250dm9mZl9mb3BzLCB2Y3B1X2dldF9jbnR2X29mZnNldCwgTlVMTCwgIiVsbGRc
biIpOwo+ID4gKwo+ID4gK3ZvaWQga3ZtX2FyY2hfY3JlYXRlX3ZjcHVfZGVidWdmcyhzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBkZW50cnkgKmRlYnVnZnNfZGVudHJ5KQo+ID4gK3sKPiA+
ICsJZGVidWdmc19jcmVhdGVfZmlsZSgiY250dm9mZiIsIDA0NDQsIGRlYnVnZnNfZGVudHJ5LCB2
Y3B1LCAmdmNwdV9jbnR2b2ZmX2ZvcHMpOwo+ID4gK30KPiAKPiBUaGlzIHNob3VsZCBiZSBsZWZ0
IGluIGFyY2hfdGltZXIuYyB1bnRpbCB3ZSBhY3R1YWxseSBuZWVkIGl0IGZvcgo+IG11bHRpcGxl
IHN1YnN5c3RlbXMuIFdoZW4gKGFuZCBpZikgdGhhdCBoYXBwZW5zLCB3ZSB3aWxsIGV4cG9zZQo+
IHBlci1zdWJzeXN0ZW0gZGVidWdmcyBpbml0aWFsaXNlcnMgaW5zdGVhZCBvZiBleHBvc2luZyB0
aGUgZ3V0cyBvZiB0aGUKPiB0aW1lciBjb2RlLgoKTm90ZWQuCgotLSAKTmljb2zDoXMgU8OhZW56
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
