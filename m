Return-Path: <SRS0=5IFU=44=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3C4C10F27
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 09:29:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 276C120828
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 09:29:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ID3LIYB1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 276C120828
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FB9F4A4CD;
	Wed, 11 Mar 2020 05:29:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rgWfJoGj+HEv; Wed, 11 Mar 2020 05:29:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BA604A523;
	Wed, 11 Mar 2020 05:29:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 435694A4AA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 05:29:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x-e9LtIrveFl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 05:29:50 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 731824A2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 05:29:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583918990;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ix9LwiKc2VbnbLgLL58Tn9BHzYsE3/SmD8MGOyWV27c=;
 b=ID3LIYB1/By6Iv/cwPtVWV4wPQv5hIW3Ziy6Zul6WO74IdOIrQNvWqFwXm5g5xFkraWAk1
 3dBPmfXGKLJPAjukq0HUEQNR5/p3x/rIOrVTbEEzidZJmLBG3vb7aF+Q5qmPy38cfnOgU8
 TVGXNRYp9MXzg7jsjG8D3FWCYkrb0TI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-1aNQM2RzMpOmBJtH5jZ7oQ-1; Wed, 11 Mar 2020 05:29:46 -0400
X-MC-Unique: 1aNQM2RzMpOmBJtH5jZ7oQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5543A19057A2;
 Wed, 11 Mar 2020 09:29:44 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 61EAD91844;
 Wed, 11 Mar 2020 09:29:38 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 06/13] arm/arm64: ITS: Introspection
 tests
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-7-eric.auger@redhat.com>
 <83ffda30-e0dc-7fbf-1775-bc45a308acb4@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <7fc207fe-b761-6d24-0c14-896154023420@redhat.com>
Date: Wed, 11 Mar 2020 10:29:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <83ffda30-e0dc-7fbf-1775-bc45a308acb4@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: andre.przywara@arm.com, thuth@redhat.com
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

SGkgWmVuZ2h1aSwKCk9uIDMvMTEvMjAgOTozNyBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBF
cmljLAo+IAo+IE9uIDIwMjAvMy8xMCAyMjo1NCwgRXJpYyBBdWdlciB3cm90ZToKPj4gKyNkZWZp
bmUgR0lUU19UWVBFUl9QTFBJU8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBCSVQoMCkK
Pj4gKyNkZWZpbmUgR0lUU19UWVBFUl9WTFBJU8KgwqDCoMKgwqDCoMKgIEJJVCgxKQo+PiArI2Rl
ZmluZSBHSVRTX1RZUEVSX0lUVF9FTlRSWV9TSVpFwqDCoMKgIEdFTk1BU0tfVUxMKDcsIDQpCj4+
ICsjZGVmaW5lIEdJVFNfVFlQRVJfSVRUX0VOVFJZX1NJWkVfU0hJRlTCoMKgwqAgNAo+PiArI2Rl
ZmluZSBHSVRTX1RZUEVSX0lEQklUU8KgwqDCoMKgwqDCoMKgIEdFTk1BU0tfVUxMKDgsIDEyKQo+
IAo+IE5vdGUgdGhhdCB0aGlzIHNob3VsZCBiZSBHRU5NQVNLX1VMTCgxMiwgOCkuCmRlZmluaXRp
dmVseQoKRXJpYwo+IAo+PiArI2RlZmluZSBHSVRTX1RZUEVSX0lEQklUU19TSElGVMKgwqDCoMKg
wqDCoMKgwqAgOAo+PiArI2RlZmluZSBHSVRTX1RZUEVSX0RFVkJJVFPCoMKgwqDCoMKgwqDCoCBH
RU5NQVNLX1VMTCgxMywgMTcpCj4gCj4gKDE3LCAxMykKPiAKPj4gKyNkZWZpbmUgR0lUU19UWVBF
Ul9ERVZCSVRTX1NISUZUwqDCoMKgwqDCoMKgwqAgMTMKPj4gKyNkZWZpbmUgR0lUU19UWVBFUl9Q
VEHCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEJJVCgxOSkKPj4gKyNkZWZpbmUg
R0lUU19UWVBFUl9DSURCSVRTwqDCoMKgwqDCoMKgwqAgR0VOTUFTS19VTEwoMzIsIDM1KQo+IAo+
ICgzNSwgMzIpCj4gCj4+ICsjZGVmaW5lIEdJVFNfVFlQRVJfQ0lEQklUU19TSElGVMKgwqDCoCAz
Mgo+PiArI2RlZmluZSBHSVRTX1RZUEVSX0NJTMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgQklUKDM2
KQo+IAo+IEFuZCBwbGVhc2UgdXNlIHRhYiBmb3IgYWxsIG9mIHRoZW0uCj4gCj4gCj4gVGhhbmtz
LAo+IFplbmdodWkKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
