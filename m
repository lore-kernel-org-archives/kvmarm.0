Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8EFC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jan 2022 07:09:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59D314A4BE;
	Thu, 13 Jan 2022 02:09:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BGlKUJL85LtX; Thu, 13 Jan 2022 02:09:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FF214B0BD;
	Thu, 13 Jan 2022 02:09:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0127B4AC78
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 02:09:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lOYj4zprcvPD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jan 2022 02:09:49 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15F7D4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 02:09:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1642057788;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7V9fKZCDVzeOOG8kZLX9cFIbWO+ukoGgMFPdyggLbxc=;
 b=ImYma3jTdZqTcQRGyg2hAgTqTSsQnIoNJ4I0XeRDXnyTReT9Y3cK5xB8TygSB2Il9sZrt3
 GVJf6R5aR2xQZMy+pGEV7eyw3Cob1COECfC8bPBzywM3X4di6keEnG5Q+LvHJVXDi5upd+
 DS7DnbTw43d4uBZ7eQ7xz5b9tOVCo3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-qG4GOHG_MrWKoSBuXCn5Mg-1; Thu, 13 Jan 2022 02:09:43 -0500
X-MC-Unique: qG4GOHG_MrWKoSBuXCn5Mg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA4221006AA4;
 Thu, 13 Jan 2022 07:09:41 +0000 (UTC)
Received: from [10.72.13.202] (ovpn-13-202.pek2.redhat.com [10.72.13.202])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 528C278DE9;
 Thu, 13 Jan 2022 07:09:37 +0000 (UTC)
Subject: Re: [PATCH v4 02/21] KVM: arm64: Add SDEI virtualization
 infrastructure
To: Shannon Zhao <shannon.zhaosl@gmail.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-3-gshan@redhat.com>
 <89165079-d2a6-fad8-3a9c-dcb46a8acdc7@gmail.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <41ccffa1-4094-7e71-246f-ac11023f741a@redhat.com>
Date: Thu, 13 Jan 2022 15:09:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <89165079-d2a6-fad8-3a9c-dcb46a8acdc7@gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: maz@kernel.org, pbonzini@redhat.com, will@kernel.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com
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

SGkgU2hhbm5vbiwKCk9uIDEvMTEvMjIgNTo0MCBQTSwgU2hhbm5vbiBaaGFvIHdyb3RlOgo+IE9u
IDIwMjEvOC8xNSA4OjEzLCBHYXZpbiBTaGFuIHdyb3RlOgo+PiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9rdm0vYXJtLmMgYi9hcmNoL2FybTY0L2t2bS9hcm0uYwo+PiBpbmRleCBlOWEyYjhmMjc3
OTIuLjJmMDIxYWE0MTYzMiAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vYXJtLmMKPj4g
KysrIGIvYXJjaC9hcm02NC9rdm0vYXJtLmMKPj4gQEAgLTE1MCw2ICsxNTAsOCBAQCBpbnQga3Zt
X2FyY2hfaW5pdF92bShzdHJ1Y3Qga3ZtICprdm0sIHVuc2lnbmVkIGxvbmcgdHlwZSkKPj4gwqDC
oMKgwqDCoCBrdm1fdmdpY19lYXJseV9pbml0KGt2bSk7Cj4+ICvCoMKgwqAga3ZtX3NkZWlfaW5p
dF92bShrdm0pOwo+PiArCj4+IMKgwqDCoMKgwqAgLyogVGhlIG1heGltdW0gbnVtYmVyIG9mIFZD
UFVzIGlzIGxpbWl0ZWQgYnkgdGhlIGhvc3QncyBHSUMgbW9kZWwgKi8KPj4gwqDCoMKgwqDCoCBr
dm0tPmFyY2gubWF4X3ZjcHVzID0ga3ZtX2FybV9kZWZhdWx0X21heF92Y3B1cygpOwo+IEhpLCBJ
cyBpdCBwb3NzaWJsZSB0byBsZXQgdXNlciBzcGFjZSB0byBjaG9vc2Ugd2hldGhlciBlbmFibGlu
ZyBTRURJIG9yIG5vdCByYXRoZXIgdGhhbiBlbmFibGUgaXQgYnkgZGVmYXVsdD8KPiAKCkl0J3Mg
cG9zc2libGUsIGJ1dCB3aGF0J3MgdGhlIGJlbmVmaXQgdG8gZG8gc28uIEkgdGhpbmsgYWJvdXQg
aXQgZm9yCmEgd2hpbGUgYW5kIEkgZG9uJ3QgdGhpbmsgaXQncyBub3QgbmVjZXNzYXJ5LCBhdCBs
ZWFzdCBmb3Igbm93LiBGaXJzdApvZiBhbGwsIHRoZSBTREVJIGV2ZW50IGlzIGluamVjdGVkIGZy
b20gaW5kaXZpZHVhbCBtb2R1bGVzIGluIHVzZXJzcGFjZQooUUVNVSkgb3IgaG9zdCBrZXJuZWwg
KEFzeW5jIFBGKS4gSWYgd2UgcmVhbGx5IHdhbnQgdGhlIGZ1bmN0aW9uIHRvIGJlCmRpc2FibGVk
LCB0aGUgaW5kaXZpZHVhbCBtb2R1bGVzIGNhbiBhY2NlcHQgcGFyYW1ldGVyLCB1c2VkIHRvIGlu
ZGljYXRlCnRoZSBTREVJIGV2ZW50IGluamVjdGlvbiBpcyBhbGxvd2VkIG9yIG5vdC4gSW4gdGhp
cyBjYXNlLCBTREVJIGlzIGVuYWJsZWQKYnkgZGVmYXVsdCwgYnV0IHRoZSBpbmRpdmlkdWFsIG1v
ZHVsZXMgY2FuIGNob29zZSBub3QgdG8gdXNlIGl0IDopCgpUaGFua3MsCkdhdmluCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
