Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6123C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 15:38:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35CFE6121F
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 15:38:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 35CFE6121F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C24704B0A3;
	Wed, 10 Nov 2021 10:38:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HnMiCsjsfpZ7; Wed, 10 Nov 2021 10:37:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85BB84B0C0;
	Wed, 10 Nov 2021 10:37:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DBE44B0A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 10:37:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DbjLS9g8gvEv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 10:37:57 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03F204A98B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 10:37:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636558676;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=30tz3JHxuBBH6OKoTYVZ1/oahiy3zylMfJnsAgakHOQ=;
 b=LdgC19zYVq5EHY6Ar74Y/G+HgyGhIlJPWcGzEXez9ecqT599HwSZcnOwPfT2KBNJ7azEx6
 dIvqO17iVsJuQ/MfL4ehiVKnlX2ovCvvx3hbh0CQ70YhpFE9W/nEYZG46CzN9sMZeDP3Vt
 7GyKhXiTt6pg1xfeWsXEFrnfsO7FXeE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-M_EeR-mEMLu8I1EG6PMtJA-1; Wed, 10 Nov 2021 10:37:54 -0500
X-MC-Unique: M_EeR-mEMLu8I1EG6PMtJA-1
Received: by mail-wm1-f71.google.com with SMTP id
 o22-20020a1c7516000000b0030d6f9c7f5fso1297236wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 07:37:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=30tz3JHxuBBH6OKoTYVZ1/oahiy3zylMfJnsAgakHOQ=;
 b=nXyNKGiVELxBKDU5p+200YRcWbqC3zMHu31WMpYgUV79uNBDtq5wVZ9Uvs7odAWAVl
 BS5iBx94wp1Uk+hHeSrQa7LFjIIMEh/oyyR6jJ02v2ke6rw+kEwt8hdxjBEf7rydtlCY
 G7BIqg1eaNIWJoDS+JpkCh8zAg8nXFbONeu4lruv4/8EDJ9dyiVdjuMjW/+O/uDJcwaU
 p+bnnoxzarboJlgH6bpKBCoJTNHYqSZou7HSAuYz0TIa1XqNS4DR6Jaxf5+zxvkNVNIZ
 X+U2QU7NyYRZrpUdBXa30WOY+vMaU0nuMiDJFYJUgf4R62WBWjcB/BT7IZmpFOzqCuMR
 umFg==
X-Gm-Message-State: AOAM530qH7v9NJi9T2gH+j2TY5PPEtApLV2tT+P/vMU2DzQB93OTrQxx
 lbm7vsJ/mPTuVH9H00Uz97tE12NgNpeEG/mcWWpdBAeAfBbaO56inDJ43/9mS0ihUWKyiqHzuTX
 bhse8cGgshCJDT548pFA2Q3TC
X-Received: by 2002:a05:600c:2e42:: with SMTP id
 q2mr15933wmf.161.1636558673478; 
 Wed, 10 Nov 2021 07:37:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxW/VFDXDiiODjm7LlcaoGlETxK4RENu+QyMKWkyGXEAqSrOjFV0sT/j9ePtuz8jicQgs0upA==
X-Received: by 2002:a05:600c:2e42:: with SMTP id
 q2mr15911wmf.161.1636558673273; 
 Wed, 10 Nov 2021 07:37:53 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id q84sm7204196wme.3.2021.11.10.07.37.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 07:37:52 -0800 (PST)
Subject: Re: [PATCH v4 01/15] KVM: async_pf: Move struct kvm_async_pf around
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-2-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <f05db974-1145-b83e-a8ba-e73dbf4bc880@redhat.com>
Date: Wed, 10 Nov 2021 16:37:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815005947.83699-2-gshan@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

SGkgR2F2aW4sCgpPbiA4LzE1LzIxIDI6NTkgQU0sIEdhdmluIFNoYW4gd3JvdGU6Cj4gVGhpcyBt
b3ZlcyB0aGUgZGVmaW5pdGlvbiBvZiAic3RydWN0IGt2bV9hc3luY19wZiIgYW5kIHRoZSByZWxh
dGVkCj4gZnVuY3Rpb25zIGFmdGVyICJzdHJ1Y3Qga3ZtX3ZjcHUiIHNvIHRoYXQgbmV3bHkgYWRk
ZWQgaW5saW5lIGZ1bmN0aW9ucwo+IGluIHRoZSBzdWJzZXF1ZW50IHBhdGNoZXMgY2FuIGRlcmVm
ZXJlbmNlICJzdHJ1Y3Qga3ZtX3ZjcHUiIHByb3Blcmx5Lgo+IE90aGVyd2lzZSwgdGhlIHVuZXhw
ZWN0ZWQgYnVpbGQgZXJyb3Igd2lsbCBiZSByYWlzZWQ6Cj4gCj4gICAgZXJyb3I6IGRlcmVmZXJl
bmNpbmcgcG9pbnRlciB0byBpbmNvbXBsZXRlIHR5cGUg4oCYc3RydWN0IGt2bV92Y3B14oCZCj4g
ICAgcmV0dXJuICFsaXN0X2VtcHR5X2NhcmVmdWwoJnZjcHUtPmFzeW5jX3BmLmRvbmUpOwo+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn4KPiBTaW5jZSB3ZSdyZSBoZXJlLCB0
aGUgc2VwYXRvciBiZXR3ZWVuIHR5cGUgYW5kIGZpZWxkIGluICJzdHJ1Y3Qga3ZtX3ZjcHUiCnNl
cGFyYXRvcgo+IGlzIHJlcGxhY2VkIGJ5IHRhYi4gVGhlIGVtcHR5IHN0dWIga3ZtX2NoZWNrX2Fz
eW5jX3BmX2NvbXBsZXRpb24oKSBpcyBhbHNvCj4gYWRkZWQgb24gIUNPTkZJR19LVk1fQVNZTkNf
UEYsIHdoaWNoIGlzIG5lZWRlZCBieSBzdWJzZXF1ZW50IHBhdGNoZXMgdG8KPiBzdXBwb3J0IGFz
eW5jaHJvbm91cyBwYWdlIGZhdWx0IG9uIEFSTTY0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IEdhdmlu
IFNoYW4gPGdzaGFuQHJlZGhhdC5jb20+Cj4gLS0tCj4gIGluY2x1ZGUvbGludXgva3ZtX2hvc3Qu
aCB8IDQ0ICsrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0KPiAgMSBmaWxl
IGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDIxIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1n
aXQgYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgK
PiBpbmRleCBhZTc3MzViNDkwYjQuLjg1YjYxYTQ1NmYxYyAxMDA2NDQKPiAtLS0gYS9pbmNsdWRl
L2xpbnV4L2t2bV9ob3N0LmgKPiArKysgYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKPiBAQCAt
MTk5LDI3ICsxOTksNiBAQCBpbnQga3ZtX2lvX2J1c191bnJlZ2lzdGVyX2RldihzdHJ1Y3Qga3Zt
ICprdm0sIGVudW0ga3ZtX2J1cyBidXNfaWR4LAo+ICBzdHJ1Y3Qga3ZtX2lvX2RldmljZSAqa3Zt
X2lvX2J1c19nZXRfZGV2KHN0cnVjdCBrdm0gKmt2bSwgZW51bSBrdm1fYnVzIGJ1c19pZHgsCj4g
IAkJCQkJIGdwYV90IGFkZHIpOwo+ICAKPiAtI2lmZGVmIENPTkZJR19LVk1fQVNZTkNfUEYKPiAt
c3RydWN0IGt2bV9hc3luY19wZiB7Cj4gLQlzdHJ1Y3Qgd29ya19zdHJ1Y3Qgd29yazsKPiAtCXN0
cnVjdCBsaXN0X2hlYWQgbGluazsKPiAtCXN0cnVjdCBsaXN0X2hlYWQgcXVldWU7Cj4gLQlzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHU7Cj4gLQlzdHJ1Y3QgbW1fc3RydWN0ICptbTsKPiAtCWdwYV90IGNy
Ml9vcl9ncGE7Cj4gLQl1bnNpZ25lZCBsb25nIGFkZHI7Cj4gLQlzdHJ1Y3Qga3ZtX2FyY2hfYXN5
bmNfcGYgYXJjaDsKPiAtCWJvb2wgICB3YWtldXBfYWxsOwo+IC0JYm9vbCBub3RwcmVzZW50X2lu
amVjdGVkOwo+IC19Owo+IC0KPiAtdm9pZCBrdm1fY2xlYXJfYXN5bmNfcGZfY29tcGxldGlvbl9x
dWV1ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwo+IC12b2lkIGt2bV9jaGVja19hc3luY19wZl9j
b21wbGV0aW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Cj4gLWJvb2wga3ZtX3NldHVwX2FzeW5j
X3BmKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgZ3BhX3QgY3IyX29yX2dwYSwKPiAtCQkJdW5zaWdu
ZWQgbG9uZyBodmEsIHN0cnVjdCBrdm1fYXJjaF9hc3luY19wZiAqYXJjaCk7Cj4gLWludCBrdm1f
YXN5bmNfcGZfd2FrZXVwX2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwo+IC0jZW5kaWYKPiAt
Cj4gICNpZmRlZiBLVk1fQVJDSF9XQU5UX01NVV9OT1RJRklFUgo+ICBzdHJ1Y3Qga3ZtX2dmbl9y
YW5nZSB7Cj4gIAlzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICpzbG90Owo+IEBAIC0zNDYsNiArMzI1
LDI5IEBAIHN0cnVjdCBrdm1fdmNwdSB7Cj4gIAlzdHJ1Y3Qga3ZtX2RpcnR5X3JpbmcgZGlydHlf
cmluZzsKPiAgfTsKPiAgCj4gKyNpZmRlZiBDT05GSUdfS1ZNX0FTWU5DX1BGCj4gK3N0cnVjdCBr
dm1fYXN5bmNfcGYgewo+ICsJc3RydWN0IHdvcmtfc3RydWN0CQl3b3JrOwo+ICsJc3RydWN0IGxp
c3RfaGVhZAkJbGluazsKPiArCXN0cnVjdCBsaXN0X2hlYWQJCXF1ZXVlOwo+ICsJc3RydWN0IGt2
bV92Y3B1CQkJKnZjcHU7Cj4gKwlzdHJ1Y3QgbW1fc3RydWN0CQkqbW07Cj4gKwlncGFfdAkJCQlj
cjJfb3JfZ3BhOwo+ICsJdW5zaWduZWQgbG9uZwkJCWFkZHI7Cj4gKwlzdHJ1Y3Qga3ZtX2FyY2hf
YXN5bmNfcGYJYXJjaDsKPiArCWJvb2wJCQkJd2FrZXVwX2FsbDsKPiArCWJvb2wJCQkJbm90cHJl
c2VudF9pbmplY3RlZDsKPiArfTsKPiArCj4gK3ZvaWQga3ZtX2NsZWFyX2FzeW5jX3BmX2NvbXBs
ZXRpb25fcXVldWUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsKPiArdm9pZCBrdm1fY2hlY2tfYXN5
bmNfcGZfY29tcGxldGlvbihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwo+ICtib29sIGt2bV9zZXR1
cF9hc3luY19wZihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdwYV90IGNyMl9vcl9ncGEsCj4gKwkJ
CXVuc2lnbmVkIGxvbmcgaHZhLCBzdHJ1Y3Qga3ZtX2FyY2hfYXN5bmNfcGYgKmFyY2gpOwo+ICtp
bnQga3ZtX2FzeW5jX3BmX3dha2V1cF9hbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsKPiArI2Vs
c2UKPiArc3RhdGljIGlubGluZSB2b2lkIGt2bV9jaGVja19hc3luY19wZl9jb21wbGV0aW9uKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSkgeyB9CndoeSBpcyB0aGF0IHN0dWIgbmVlZGVkIG9uIEFSTTY0
IGFuZCBub3Qgb24gdGhlIG90aGVyIGFyY2hzPwoKRXJpYwo+ICsjZW5kaWYKPiArCj4gIC8qIG11
c3QgYmUgY2FsbGVkIHdpdGggaXJxcyBkaXNhYmxlZCAqLwo+ICBzdGF0aWMgX19hbHdheXNfaW5s
aW5lIHZvaWQgZ3Vlc3RfZW50ZXJfaXJxb2ZmKHZvaWQpCj4gIHsKPiAKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
