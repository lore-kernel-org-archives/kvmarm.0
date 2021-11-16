Return-Path: <SRS0=+NXu=QD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42B6C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 14:22:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2162561C12
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 14:22:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2162561C12
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BBF64B0DF;
	Tue, 16 Nov 2021 09:22:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DLATRYTeeFLQ; Tue, 16 Nov 2021 09:22:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 595D54B0EF;
	Tue, 16 Nov 2021 09:22:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E99714B0EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 09:22:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Htc4klW5hh0u for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Nov 2021 09:22:03 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46F504A534
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 09:22:03 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637072523;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7lWWPWi0Wsw1vOClqmw0uD7Kp+n7bnIBYYv23z0XPl4=;
 b=E4vZa0wQWjtoAxQmnaiPBWoYpG7sJVUeA5OmN28/mBxryAUuMpGTEbD57Nv8qVbJTPtfgr
 DhP6jXntKdjcAlWuU+qJtsbFcKT+vZtGILddSoErsJq9v05/DS/OczMDUa/allcguWTkHv
 peqmNd1fCCmTZcerLMz1K9YNijrQHJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-rGoQUqOlPDaEPcwErS8TUQ-1; Tue, 16 Nov 2021 09:22:01 -0500
X-MC-Unique: rGoQUqOlPDaEPcwErS8TUQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18284BBEEF;
 Tue, 16 Nov 2021 14:21:59 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 4179B1F429;
 Tue, 16 Nov 2021 14:21:40 +0000 (UTC)
Message-ID: <d0f41b9f-9307-3694-59c8-5a009a2f06a2@redhat.com>
Date: Tue, 16 Nov 2021 15:21:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/5] KVM: Turn the vcpu array into an xarray
Content-Language: en-US
To: Juergen Gross <jgross@suse.com>, Marc Zyngier <maz@kernel.org>,
 kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org
References: <20211105192101.3862492-1-maz@kernel.org>
 <6232cbcb-b2e2-e79f-a520-43d552f35243@suse.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <6232cbcb-b2e2-e79f-a520-43d552f35243@suse.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: Huacai Chen <chenhuacai@kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Anup Patel <anup.patel@wdc.com>, David Hildenbrand <david@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Atish Patra <atish.patra@wdc.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
 kernel-team@android.com, Claudio Imbrenda <imbrenda@linux.ibm.com>
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMTEvMTYvMjEgMTU6MTMsIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6Cj4gT24gMDUuMTEuMjEgMjA6
MjAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gVGhlIGt2bSBzdHJ1Y3R1cmUgaXMgcHJldHR5IGxh
cmdlLiBBIGxhcmdlIHBvcnRpb24gb2YgaXQgaXMgdGhlIHZjcHUKPj4gYXJyYXksIHdoaWNoIGlz
IDRrQiBvbiB4ODZfNjQgYW5kIGFybTY0IGFzIHRoZXkgZGVhbCB3aXRoIDUxMiB2Y3B1Cj4+IFZN
cy4gT2YgY291cnNlLCBoYXJkbHkgYW55b25lIHJ1bnMgVk1zIHRoaXMgYmlnLCBzbyB0aGlzIGlz
IG9mdGVuIGEKPj4gbmV0IHdhc3RlIG9mIG1lbW9yeSBhbmQgY2FjaGUgbG9jYWxpdHkuCj4+Cj4+
IEEgcG9zc2libGUgYXBwcm9hY2ggaXMgdG8gdHVybiB0aGUgZml4ZWQtc2l6ZSBhcnJheSBpbnRv
IGFuIHhhcnJheSwKPj4gd2hpY2ggcmVzdWx0cyBpbiBhIG5ldCBjb2RlIGRlbGV0aW9uIGFmdGVy
IGEgYml0IG9mIGNsZWFudXAuCj4+Cj4+IFRoaXMgc2VyaWVzIGlzIG9uIHRvcCBvZiB0aGUgY3Vy
cmVudCBsaW51eC9tYXN0ZXIgYXMgaXQgdG91Y2hlcyB0aGUKPj4gUklTQy1WIGltcGxlbWVudGF0
aW9uLiBPbmx5IHRlc3RlZCBvbiBhcm02NC4KPj4KPj4gTWFyYyBaeW5naWVyICg1KToKPj4gwqDC
oCBLVk06IE1vdmUgd2lwaW5nIG9mIHRoZSBrdm0tPnZjcHVzIGFycmF5IHRvIGNvbW1vbiBjb2Rl
Cj4+IMKgwqAgS1ZNOiBtaXBzOiBVc2Uga3ZtX2dldF92Y3B1KCkgaW5zdGVhZCBvZiBvcGVuLWNv
ZGVkIGFjY2Vzcwo+PiDCoMKgIEtWTTogczM5MDogVXNlIGt2bV9nZXRfdmNwdSgpIGluc3RlYWQg
b2Ygb3Blbi1jb2RlZCBhY2Nlc3MKPj4gwqDCoCBLVk06IHg4NjogVXNlIGt2bV9nZXRfdmNwdSgp
IGluc3RlYWQgb2Ygb3Blbi1jb2RlZCBhY2Nlc3MKPj4gwqDCoCBLVk06IENvbnZlcnQgdGhlIGt2
bS0+dmNwdXMgYXJyYXkgdG8gYSB4YXJyYXkKPj4KPj4gwqAgYXJjaC9hcm02NC9rdm0vYXJtLmPC
oMKgwqDCoMKgwqDCoMKgwqDCoCB8IDEwICstLS0tLS0tLS0KPj4gwqAgYXJjaC9taXBzL2t2bS9s
b29uZ3Nvbl9pcGkuY8KgwqAgfMKgIDQgKystLQo+PiDCoCBhcmNoL21pcHMva3ZtL21pcHMuY8Kg
wqDCoMKgwqDCoMKgwqDCoMKgIHwgMjMgKystLS0tLS0tLS0tLS0tLS0tLS0tLS0KPj4gwqAgYXJj
aC9wb3dlcnBjL2t2bS9wb3dlcnBjLmPCoMKgwqDCoCB8IDEwICstLS0tLS0tLS0KPj4gwqAgYXJj
aC9yaXNjdi9rdm0vdm0uY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAxMCArLS0tLS0tLS0tCj4+
IMKgIGFyY2gvczM5MC9rdm0va3ZtLXMzOTAuY8KgwqDCoMKgwqDCoCB8IDI2ICsrKysrKy0tLS0t
LS0tLS0tLS0tLS0tLS0tCj4+IMKgIGFyY2gveDg2L2t2bS92bXgvcG9zdGVkX2ludHIuYyB8wqAg
MiArLQo+PiDCoCBhcmNoL3g4Ni9rdm0veDg2LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKg
IDkgKy0tLS0tLS0tCj4+IMKgIGluY2x1ZGUvbGludXgva3ZtX2hvc3QuaMKgwqDCoMKgwqDCoCB8
wqAgNyArKysrLS0tCj4+IMKgIHZpcnQva3ZtL2t2bV9tYWluLmPCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHwgMzMgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tCj4+IMKgIDEwIGZpbGVz
IGNoYW5nZWQsIDQ1IGluc2VydGlvbnMoKyksIDg5IGRlbGV0aW9ucygtKQo+Pgo+IAo+IEZvciB4
ODYgeW91IGNhbiBhZGQgbXk6Cj4gCj4gVGVzdGVkLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NA
c3VzZS5jb20+CgpIZWgsIHVuZm9ydHVuYXRlbHkgeDg2IGlzIHRoZSBvbmx5IG9uZSB0aGF0IG5l
ZWRzIGEgY2hhbmdlIGluIHBhdGNoIDQuIApJJ2xsIENjIHlvdSBvbiBteSB2ZXJzaW9uLgoKUGFv
bG8KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
