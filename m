Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717AEC2BA2B
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 07:45:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8C6520771
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 07:45:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TvuWJ5T3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8C6520771
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50CDC4B167;
	Thu, 16 Apr 2020 03:45:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VCEIzxDBGtgi; Thu, 16 Apr 2020 03:45:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 220854B1D9;
	Thu, 16 Apr 2020 03:45:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 048824B16C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 03:45:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZKSGrtHBI+Ue for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 03:45:41 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF4194B15D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 03:45:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587023140;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xtMw61WExPfRdJ7k/9e2uGO0mShWA0MWE6V5DxSJKqU=;
 b=TvuWJ5T3z+X4Cx3ICLvNe2RK0US6Nhp+jcWIhAFtXCGepzL+E0vwDzVyiNxoUv8Sfxuyho
 fxc8VtJCjZKCfhemxptLg3SU8K8ascJW3mqtNPtjNR62uuyKni4zQ+lwSL6xQfV1Q7iQyO
 cUx0iXoHldLmwYSBJuNEiHnBlipp5yg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-UyxvZ--jPOSsOW2DrZQkxw-1; Thu, 16 Apr 2020 03:45:35 -0400
X-MC-Unique: UyxvZ--jPOSsOW2DrZQkxw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7354A8017F5;
 Thu, 16 Apr 2020 07:45:32 +0000 (UTC)
Received: from [10.36.115.53] (ovpn-115-53.ams2.redhat.com [10.36.115.53])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 943CE60BE0;
 Thu, 16 Apr 2020 07:45:25 +0000 (UTC)
Subject: Re: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To: Zhangfei Gao <zhangfei.gao@linaro.org>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
References: <20200414150607.28488-1-eric.auger@redhat.com>
 <eb27f625-ad7a-fcb5-2185-5471e4666f09@linaro.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <06fe02f7-2556-8986-2f1e-dcdf59773b8c@redhat.com>
Date: Thu, 16 Apr 2020 09:45:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <eb27f625-ad7a-fcb5-2185-5471e4666f09@linaro.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 alex.williamson@redhat.com, yi.l.liu@intel.com, bbhushan2@marvell.com
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

SGkgWmhhbmdmZWksCgpPbiA0LzE2LzIwIDY6MjUgQU0sIFpoYW5nZmVpIEdhbyB3cm90ZToKPiAK
PiAKPiBPbiAyMDIwLzQvMTQg5LiL5Y2IMTE6MDUsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+IFRoaXMg
dmVyc2lvbiBmaXhlcyBhbiBpc3N1ZSBvYnNlcnZlZCBieSBTaGFtZWVyIG9uIGFuIFNNTVUgMy4y
LAo+PiB3aGVuIG1vdmluZyBmcm9tIGR1YWwgc3RhZ2UgY29uZmlnIHRvIHN0YWdlIDEgb25seSBj
b25maWcuCj4+IFRoZSAyIGhpZ2ggNjRiIG9mIHRoZSBTVEUgbm93IGdldCByZXNldC4gT3RoZXJ3
aXNlLCBsZWF2aW5nIHRoZQo+PiBTMlRUQiBzZXQgbWF5IGNhdXNlIGEgQ19CQURfU1RFIGVycm9y
Lgo+Pgo+PiBUaGlzIHNlcmllcyBjYW4gYmUgZm91bmQgYXQ6Cj4+IGh0dHBzOi8vZ2l0aHViLmNv
bS9lYXVnZXIvbGludXgvdHJlZS92NS42LTJzdGFnZS12MTFfMTAuMQo+PiAoaW5jbHVkaW5nIHRo
ZSBWRklPIHBhcnQpCj4+IFRoZSBRRU1VIGZlbGxvdyBzZXJpZXMgc3RpbGwgY2FuIGJlIGZvdW5k
IGF0Ogo+PiBodHRwczovL2dpdGh1Yi5jb20vZWF1Z2VyL3FlbXUvdHJlZS92NC4yLjAtMnN0YWdl
LXJmY3Y2Cj4+Cj4+IFVzZXJzIGhhdmUgZXhwcmVzc2VkIGludGVyZXN0IGluIHRoYXQgd29yayBh
bmQgdGVzdGVkIHY5L3YxMDoKPj4gLSBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL2NvdmVy
LzExMDM5OTk1LyMyMzAxMjM4MQo+PiAtIGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvY292
ZXIvMTEwMzk5OTUvIzIzMTk3MjM1Cj4+Cj4+IEJhY2tncm91bmQ6Cj4+Cj4+IFRoaXMgc2VyaWVz
IGJyaW5ncyB0aGUgSU9NTVUgcGFydCBvZiBIVyBuZXN0ZWQgcGFnaW5nIHN1cHBvcnQKPj4gaW4g
dGhlIFNNTVV2My4gVGhlIFZGSU8gcGFydCBpcyBzdWJtaXR0ZWQgc2VwYXJhdGVseS4KPj4KPj4g
VGhlIElPTU1VIEFQSSBpcyBleHRlbmRlZCB0byBzdXBwb3J0IDIgbmV3IEFQSSBmdW5jdGlvbmFs
aXRpZXM6Cj4+IDEpIHBhc3MgdGhlIGd1ZXN0IHN0YWdlIDEgY29uZmlndXJhdGlvbgo+PiAyKSBw
YXNzIHN0YWdlIDEgTVNJIGJpbmRpbmdzCj4+Cj4+IFRoZW4gdGhvc2UgY2FwYWJpbGl0aWVzIGdl
dHMgaW1wbGVtZW50ZWQgaW4gdGhlIFNNTVV2MyBkcml2ZXIuCj4+Cj4+IFRoZSB2aXJ0dWFsaXpl
ciBwYXNzZXMgaW5mb3JtYXRpb24gdGhyb3VnaCB0aGUgVkZJTyB1c2VyIEFQSQo+PiB3aGljaCBj
YXNjYWRlcyB0aGVtIHRvIHRoZSBpb21tdSBzdWJzeXN0ZW0uIFRoaXMgYWxsb3dzIHRoZSBndWVz
dAo+PiB0byBvd24gc3RhZ2UgMSB0YWJsZXMgYW5kIGNvbnRleHQgZGVzY3JpcHRvcnMgKHNvLWNh
bGxlZCBQQVNJRAo+PiB0YWJsZSkgd2hpbGUgdGhlIGhvc3Qgb3ducyBzdGFnZSAyIHRhYmxlcyBh
bmQgbWFpbiBjb25maWd1cmF0aW9uCj4+IHN0cnVjdHVyZXMgKFNURSkuCj4+Cj4+Cj4gCj4gVGhh
bmtzIEVyaWMKPiAKPiBUZXN0ZWQgdjExIG9uIEhpc2lsaWNvbiBrdW5wZW5nOTIwIGJvYXJkIHZp
YSBoYXJkd2FyZSB6aXAgYWNjZWxlcmF0b3IuCj4gMS4gbm8tc3ZhIHdvcmtzLCB3aGVyZSBndWVz
dCBhcHAgZGlyZWN0bHkgdXNlIHBoeXNpY2FsIGFkZHJlc3MgdmlhIGlvY3RsLgpUaGFuayB5b3Ug
Zm9yIHRoZSB0ZXN0aW5nLiBHbGFkIGl0IHdvcmtzIGZvciB5b3UuCj4gMi4gdlNWQSBzdGlsbCBu
b3Qgd29yaywgc2FtZSBhcyB2MTAsClllcyB0aGF0J3Mgbm9ybWFsIHRoaXMgc2VyaWVzIGlzIG5v
dCBtZWFudCB0byBzdXBwb3J0IHZTVk0gYXQgdGhpcyBzdGFnZS4KCkkgaW50ZW5kIHRvIGFkZCB0
aGUgbWlzc2luZyBwaWVjZXMgZHVyaW5nIHRoZSBuZXh0IHdlZWtzLgoKVGhhbmtzCgpFcmljCj4g
My7CoCB0aGUgdjEwIGlzc3VlIHJlcG9ydGVkIGJ5IFNoYW1lZXIgaGFzIGJlZW4gc29sdmVkLMKg
IGZpcnN0IHN0YXJ0IHFlbXUKPiB3aXRowqAgaW9tbXU9c21tdXYzLCB0aGVuIHN0YXJ0IHFlbXUg
d2l0aG91dMKgIGlvbW11PXNtbXV2Mwo+IDQuIG5vLXN2YSBhbHNvIHdvcmtzIHdpdGhvdXTCoCBp
b21tdT1zbW11djMKPiAKPiBUZXN0IGRldGFpbHMgaW4gaHR0cHM6Ly9kb2NzLnFxLmNvbS9kb2Mv
RFJVNW9SMU50VUVSc2VGTkwKPiAKPiBUaGFua3MKPiAKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
