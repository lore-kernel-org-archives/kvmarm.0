Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E3FC00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 23:57:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D080F4DDF5;
	Wed, 10 Aug 2022 19:57:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QPIeWMLrPv6O; Wed, 10 Aug 2022 19:57:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3A7D4DDF0;
	Wed, 10 Aug 2022 19:57:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32B044DDEE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 19:57:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HP2LZGsnh5WD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 19:57:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AF9D4DDED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 19:57:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660175870;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YkaDvS1GtXz21uszXexDjRybO4QCX+ccRTITPMo9eXE=;
 b=fHa+aBJwW/oihUz0cP73nxXbqgq+b03Czf7HUICU4R/OyRmQbBFGvi3XP0fXXJXxeWqQn9
 Jb9E8dWdqDstSCvFFQu9jzcRIRpfG+jdpYcO1FkRKN/osv3Fdn+OmFaPK9hQ9LOe3WXcoo
 yO2Qo+OdhuMwU/kmYuP4Glxw1srLtIU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-e1rY7k2YO5CQOlhqspYqBw-1; Wed, 10 Aug 2022 19:57:40 -0400
X-MC-Unique: e1rY7k2YO5CQOlhqspYqBw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0D8F18A64F7;
 Wed, 10 Aug 2022 23:57:39 +0000 (UTC)
Received: from [10.64.54.77] (vpn2-54-77.bne.redhat.com [10.64.54.77])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BDA0C15BA3;
 Wed, 10 Aug 2022 23:57:35 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] KVM: selftests: Make rseq compatible with
 glibc-2.35
To: Paolo Bonzini <pbonzini@redhat.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20220810104114.6838-1-gshan@redhat.com>
 <20220810104114.6838-2-gshan@redhat.com>
 <876568572.367.1660134156963.JavaMail.zimbra@efficios.com>
 <1e41a634-0419-e0a8-364c-2e30ed2dbe4d@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <234b81a0-d7eb-ee92-3ed3-ce2abf566b63@redhat.com>
Date: Thu, 11 Aug 2022 09:57:32 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1e41a634-0419-e0a8-364c-2e30ed2dbe4d@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 KVM list <kvm@vger.kernel.org>, maz <maz@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 andrew jones <andrew.jones@linux.dev>, yihyu <yihyu@redhat.com>,
 linux-kselftest <linux-kselftest@vger.kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

T24gOC8xMC8yMiAxMDoyOSBQTSwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBPbiA4LzEwLzIyIDE0
OjIyLCBNYXRoaWV1IERlc25veWVycyB3cm90ZToKPj4+Cj4+PiDCoMKgwqDCoC8qCj4+PiDCoMKg
wqDCoCAqIENyZWF0ZSBhbmQgcnVuIGEgZHVtbXkgVk0gdGhhdCBpbW1lZGlhdGVseSBleGl0cyB0
byB1c2Vyc3BhY2UgdmlhCj4+PiBAQCAtMjU2LDcgKzI0NCw3IEBAIGludCBtYWluKGludCBhcmdj
LCBjaGFyICphcmd2W10pCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPj4+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgc21wX3JtYigpOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBj
cHUgPSBzY2hlZF9nZXRjcHUoKTsKPj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJzZXFfY3B1
ID0gUkVBRF9PTkNFKF9fcnNlcS5jcHVfaWQpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cnNlcV9jcHUgPSBSRUFEX09OQ0UoX19yc2VxLT5jcHVfaWQpOwo+PiAjaW5jbHVkZSA8cnNlcS5o
Pgo+Pgo+PiBhbmQgdXNlCj4+Cj4+IHJzZXFfY3VycmVudF9jcHVfcmF3KCkuCj4gCj4gVGhhbmtz
LCBJIHNxdWFzaGVkIGl0IGFuZCBxdWV1ZWQgaXQgZm9yIC1yYzEgKHRlc3RlZCBvbiBib3RoCj4g
Z2xpYmMgMi4zNCBhbmQgMi4zNSkuCj4gCgpQYW9sbywgVGhhbmtzIGZvciB0aGUgbWFrZXVwLCB3
aGljaCBsb29rcyBnb29kIHRvIG1lIDopCgo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9rdm0vcnNlcV90ZXN0LmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vcnNl
cV90ZXN0LmMKPiBpbmRleCA4NGU4NDI1ZWRjMmMuLjk4N2E3NjY3NGY0ZiAxMDA2NDQKPiAtLS0g
YS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vcnNlcV90ZXN0LmMKPiArKysgYi90b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vcnNlcV90ZXN0LmMKPiBAQCAtMjksNyArMjksNiBAQAo+ICDC
oCNkZWZpbmUgTlJfVEFTS19NSUdSQVRJT05TIDEwMDAwMAo+IAo+ICDCoHN0YXRpYyBwdGhyZWFk
X3QgbWlncmF0aW9uX3RocmVhZDsKPiAtc3RhdGljIHN0cnVjdCByc2VxX2FiaSAqX19yc2VxOwo+
ICDCoHN0YXRpYyBjcHVfc2V0X3QgcG9zc2libGVfbWFzazsKPiAgwqBzdGF0aWMgaW50IG1pbl9j
cHUsIG1heF9jcHU7Cj4gIMKgc3RhdGljIGJvb2wgZG9uZTsKPiBAQCAtMjE4LDcgKzIxNyw2IEBA
IGludCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10pCj4gIMKgwqDCoMKgIHIgPSByc2VxX3Jl
Z2lzdGVyX2N1cnJlbnRfdGhyZWFkKCk7Cj4gIMKgwqDCoMKgIFRFU1RfQVNTRVJUKCFyLCAicnNl
cV9yZWdpc3Rlcl9jdXJyZW50X3RocmVhZCBmYWlsZWQsIGVycm5vID0gJWQgKCVzKSIsCj4gIMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlcnJubywgc3RyZXJyb3IoZXJybm8pKTsKPiAtwqDCoMKg
IF9fcnNlcSA9IHJzZXFfZ2V0X2FiaSgpOwo+IAo+ICDCoMKgwqDCoCAvKgo+ICDCoMKgwqDCoMKg
ICogQ3JlYXRlIGFuZCBydW4gYSBkdW1teSBWTSB0aGF0IGltbWVkaWF0ZWx5IGV4aXRzIHRvIHVz
ZXJzcGFjZSB2aWEKPiBAQCAtMjU2LDcgKzI1NCw3IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFy
ICphcmd2W10pCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBzbXBfcm1iKCk7Cj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjcHUg
PSBzY2hlZF9nZXRjcHUoKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByc2VxX2NwdSA9IFJF
QURfT05DRShfX3JzZXEtPmNwdV9pZCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcnNlcV9j
cHUgPSByc2VxX2N1cnJlbnRfY3B1X3JhdygpOwo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
c21wX3JtYigpOwo+ICDCoMKgwqDCoMKgwqDCoMKgIH0gd2hpbGUgKHNuYXBzaG90ICE9IGF0b21p
Y19yZWFkKCZzZXFfY250KSk7Cj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
