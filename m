Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036D7C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jan 2022 07:02:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 583804B0DE;
	Thu, 13 Jan 2022 02:02:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HecvAPNK4243; Thu, 13 Jan 2022 02:02:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 371374A417;
	Thu, 13 Jan 2022 02:02:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C77EC4A19A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 02:02:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hAOMg2G2tpWV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jan 2022 02:02:41 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEEFE49EBB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 02:02:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1642057361;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wa1b8MmKgX3tm872f9qab+x44K+GoLAvtcl9qdRW4BA=;
 b=DcIX1a4g46TBzFYiGgzHM7IEZqh8OzEViTQdVdZgtQQVYKgUcBnvDZhQzDFcis2jNXyvc/
 wARAxIp6Fk8sndl5gDYlPLnq4QUvgZYQ5LM360e1pciE7FtwrB8kMZO1wxYnxGnuD0raLS
 VNWv0naQG9TC47CfdoS5Xjt06/RdK4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-ODlie5dgMVCGAC5FglCJow-1; Thu, 13 Jan 2022 02:02:38 -0500
X-MC-Unique: ODlie5dgMVCGAC5FglCJow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06D7C8042DB;
 Thu, 13 Jan 2022 07:02:37 +0000 (UTC)
Received: from [10.72.13.202] (ovpn-13-202.pek2.redhat.com [10.72.13.202])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F3656784A;
 Thu, 13 Jan 2022 07:02:21 +0000 (UTC)
Subject: Re: [PATCH v4 06/21] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
To: Shannon Zhao <shannon.zhaosl@gmail.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-7-gshan@redhat.com>
 <40d818a2-0c91-e06e-6ce8-ac8123b8d1d4@gmail.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <798ecbb0-f369-f3e7-ad50-78acfd902d1d@redhat.com>
Date: Thu, 13 Jan 2022 15:02:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <40d818a2-0c91-e06e-6ce8-ac8123b8d1d4@gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

SGkgU2hhbm5vbiwKCk9uIDEvMTEvMjIgNTo0MyBQTSwgU2hhbm5vbiBaaGFvIHdyb3RlOgo+IE9u
IDIwMjEvOC8xNSA4OjEzLCBHYXZpbiBTaGFuIHdyb3RlOgo+PiArc3RhdGljIHVuc2lnbmVkIGxv
bmcga3ZtX3NkZWlfaHlwZXJjYWxsX2NvbnRleHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+PiAr
ewo+PiArwqDCoMKgIHN0cnVjdCBrdm0gKmt2bSA9IHZjcHUtPmt2bTsKPj4gK8KgwqDCoCBzdHJ1
Y3Qga3ZtX3NkZWlfa3ZtICprc2RlaSA9IGt2bS0+YXJjaC5zZGVpOwo+PiArwqDCoMKgIHN0cnVj
dCBrdm1fc2RlaV92Y3B1ICp2c2RlaSA9IHZjcHUtPmFyY2guc2RlaTsKPj4gK8KgwqDCoCBzdHJ1
Y3Qga3ZtX3NkZWlfdmNwdV9yZWdzICpyZWdzOwo+PiArwqDCoMKgIHVuc2lnbmVkIGxvbmcgaW5k
ZXggPSBzbWNjY19nZXRfYXJnMSh2Y3B1KTsKPj4gK8KgwqDCoCB1bnNpZ25lZCBsb25nIHJldCA9
IFNERUlfU1VDQ0VTUzsKPj4gKwo+PiArwqDCoMKgIC8qIFNhbml0eSBjaGVjayAqLwo+PiArwqDC
oMKgIGlmICghKGtzZGVpICYmIHZzZGVpKSkgewo+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gU0RF
SV9OT1RfU1VQUE9SVEVEOwo+PiArwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+ICvCoMKgwqAg
fQo+IE1heWJlIHdlIGNvdWxkIG1vdmUgdGhlc2UgY29tbW9uIHNhbml0eSBjaGVjayBjb2RlcyB0
byBrdm1fc2RlaV9oeXBlcmNhbGwgdG8gc2F2ZSBzb21lIGxpbmVzLgo+IAoKTm90IGFsbCBoeXBl
cmNhbGxzIG5lZWQgdGhpcyBjaGVjay4gRm9yIGV4YW1wbGUsIENPTVBMRVRFL0NPTVBMRVRFX1JF
U1VNRS9DT05URVhUIGRvbid0CmhhdmUgU0RFSSBldmVudCBudW1iZXIgYXMgdGhlIGFyZ3VtZW50
LiBJZiB3ZSByZWFsbHkgd2FudCBtb3ZlIHRoaXMgY2hlY2sgaW50byBmdW5jdGlvbgprdm1fc2Rl
aV9oeXBlcmNhbGwoKSwgd2Ugd291bGQgaGF2ZSBjb2RlIGxpa2UgYmVsb3cuIFRvbyBtdWNoIGR1
cGxpY2F0ZWQgc25pcHBldHMgd2lsbApiZSBzZWVuLiBJIGRvbid0IHRoaW5rIGl0J3MgYmV0dGVy
IHRoYW4gd2hhdCB3ZSBoYXZlIGlmIEkgZnVsbHkgdW5kZXJzdGFuZCB5b3VyIGNvbW1lbnRzLgoK
ICAgICAgIHN3aXRjaCAoLi4uKSB7CiAgICAgICBjYXNlIFJFR0lTVEVSOgogICAgICAgICAgICBp
ZiAoIShrc2RlaSAmJiB2c2RlaSkpIHsKICAgICAgICAgICAgICAgIHJldCA9IFNERUlfTk9UX1NV
UFBPUlRFRDsKICAgICAgICAgICAgICAgIGJyZWFrOwogICAgICAgICAgICB9CgogICAgICAgICAg
ICByZXQgPSBrdm1fc2RlaV9oeXBlcmNhbGxfcmVnaXN0ZXIodmNwdSk7CiAgICAgICAgICAgIGJy
ZWFrOwogICAgICAgY2FzZSBVTlJFR0lTVEVSOgogICAgICAgICAgICBpZiAoIShrc2RlaSAmJiB2
c2RlaSkpIHsKICAgICAgICAgICAgICAgIHJldCA9IFNERUlfTk9UX1NVUFBPUlRFRDsKICAgICAg
ICAgICAgICAgIGJyZWFrOwogICAgICAgICAgICB9CgogICAgICAgICAgICByZXQgPSBrdm1fc2Rl
aV9oeXBlcmNhbGxfdW5yZWdpc3Rlcih2Y3B1KTsKICAgICAgICAgICAgYnJlYWs7CiAgICAgIGNh
c2UgQ09OVEVYVDoKICAgICAgICAgICAgcmV0ID0ga3ZtX3NkZWlfaHlwZXJjYWxsX2NvbnRleHQo
dmNwdSk7CiAgICAgICAgICAgIGJyZWFrOwogICAgICAgIDoKICAgICB9CgpUaGFua3MsCkdhdmlu
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
