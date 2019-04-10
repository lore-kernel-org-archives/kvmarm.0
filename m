Return-Path: <SRS0=4kLF=SM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5A1C10F11
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 13:02:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 157472083E
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 13:02:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 157472083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AA0A4A475;
	Wed, 10 Apr 2019 09:02:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bZOti+wwtI83; Wed, 10 Apr 2019 09:02:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D5804A472;
	Wed, 10 Apr 2019 09:02:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57AA54A433
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 09:02:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IVgFhDD2a9t3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Apr 2019 09:02:39 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F1F94A380
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 09:02:39 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 3AF973D3A;
 Wed, 10 Apr 2019 13:02:38 +0000 (UTC)
Received: from [10.36.117.161] (ovpn-117-161.ams2.redhat.com [10.36.117.161])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D05FF619A2;
 Wed, 10 Apr 2019 13:02:26 +0000 (UTC)
Subject: Re: [PATCH v6 09/22] vfio: VFIO_IOMMU_BIND/UNBIND_MSI
To: =?UTF-8?Q?Vincent_Stehl=c3=a9?= <vincent.stehle@arm.com>
References: <20190317172232.1068-1-eric.auger@redhat.com>
 <20190317172232.1068-10-eric.auger@redhat.com>
 <20190321170159.38358f38@x1.home>
 <16931d58-9c88-8cfb-a392-408ea7afdf16@redhat.com>
 <20190322160947.3f8dacdb@x1.home>
 <b47128de-88d0-1971-1fbc-86e43439c7ee@redhat.com>
 <20190403113800.51503693@x1.home>
 <4b27b707-4917-2c3e-a13c-3b978e850d09@redhat.com>
 <20190410123531.GA19023@debian>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <2cdd4142-98e5-14de-2f34-264244f24d01@redhat.com>
Date: Wed, 10 Apr 2019 15:02:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190410123531.GA19023@debian>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.29]); Wed, 10 Apr 2019 13:02:38 +0000 (UTC)
Cc: yi.l.liu@linux.intel.com, kevin.tian@intel.com,
 jacob.jun.pan@linux.intel.com, ashok.raj@intel.com, kvm@vger.kernel.org,
 joro@8bytes.org, will.deacon@arm.com, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org, marc.zyngier@arm.com,
 Alex Williamson <alex.williamson@redhat.com>, robin.murphy@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190410130223.L9Kt8pXb-cUaha-lLvHbAvh6uoBB77-HBiKUew8uXdA@z>

SGkgVmluY2VudCwKCk9uIDQvMTAvMTkgMjozNSBQTSwgVmluY2VudCBTdGVobMOpIHdyb3RlOgo+
IE9uIFRodSwgQXByIDA0LCAyMDE5IGF0IDA4OjU1OjI1QU0gKzAyMDAsIEF1Z2VyIEVyaWMgd3Jv
dGU6Cj4+IEhpIE1hcmMsIFJvYmluLCBBbGV4LAo+ICguLikKPj4gRG8geW91IHRoaW5rIHRoaXMg
aXMgYSByZWFzb25hYmxlIGFzc3VtcHRpb24gdG8gY29uc2lkZXIgZGV2aWNlcyB3aXRoaW4KPj4g
dGhlIHNhbWUgaG9zdCBpb21tdSBncm91cCBzaGFyZSB0aGUgc2FtZSBNU0kgZG9vcmJlbGw/Cj4g
Cj4gSGkgRXJpYywKPiAKPiBJIGFtIG5vdCBzdXJlIHRoaXMgYXNzdW1wdGlvbiBhbHdheXMgaG9s
ZC4KPiAKPiBNYXJjLCBSb2JpbiBhbmQgQWxleCBjYW4gY29ycmVjdCBtZSwgYnV0IGZvciBleGFt
cGxlIEkgdGhpbmsgdGhlIGZvbGxvd2luZwo+IHRvcG9sb2d5IGlzIHZhbGlkIGZvciBBcm0gc3lz
dGVtczoKPiAKPiAgKy0tLS0tLS0tLS0tLSsgICstLS0tLS0tLS0tLS0rCj4gIHwgRW5kcG9pbnQg
QSB8ICB8IEVuZHBvaW50IEIgfAo+ICArLS0tLS0tLS0tLS0tKyAgKy0tLS0tLS0tLS0tLSsKPiAg
ICAgICAgICAgICB2ICAgICB2Cj4gICAgICAgICAgIC8tLS0tLS0tLS1cCj4gICAgICAgICAgfCAg
Tm9uLUFDUyAgfAo+ICAgICAgICAgIHwgIFN3aXRjaCAgIHwKPiAgICAgICAgICAgXC0tLS0tLS0t
LS8KPiAgICAgICAgICAgICAgICB2Cj4gICAgICAgICstLS0tLS0tLS0tLS0tLS0rCj4gICAgICAg
IHwgICAgIFBDSWUgICAgICB8Cj4gICAgICAgIHwgUm9vdCBDb21wbGV4ICB8Cj4gICAgICAgICst
LS0tLS0tLS0tLS0tLS0rCj4gICAgICAgICAgICAgICAgdgo+ICAgICAgICAgICstLS0tLS0tLS0t
LSsKPiAgICAgICAgICB8ICAgU01NVSAgICB8Cj4gICAgICAgICAgKy0tLS0tLS0tLS0tKwo+ICAg
ICAgICAgICAgICAgIHYKPiAgICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsKPiAgIHwgICBT
eXN0ZW0gaW50ZXJjb25uZWN0ICAgIHwKPiAgICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsK
PiAgICAgICAgIHYgICAgICAgICAgICAgIHYKPiAgICstLS0tLS0tLS0tLSsgICstLS0tLS0tLS0t
LSsKPiAgIHwgICBJVFMgQSAgIHwgIHwgICBJVFMgQiAgIHwKPiAgICstLS0tLS0tLS0tLSsgICst
LS0tLS0tLS0tLSsKPiAKPiBBbGwgUENJZSBFbmRwb2ludHMgYW5kIElUUyBjb3VsZCBiZSBpbiB0
aGUgc2FtZSBJVFMgR3JvdXAgMCwgbWVhbmluZwo+IGRldmljZXMgY291bGQgc2VuZCB0aGVpciBN
U0kgYXQgYW55IElUUyBpbiBoYXJkd2FyZS4KPiAKPiBGb3IgTGludXggdGhlIHR3byBQQ0llIEVu
ZHBvaW50cyB3b3VsZCBiZSBpbiB0aGUgc2FtZSBpb21tdSBncm91cCwgYmVjYXVzZQo+IHRoZSBz
d2l0Y2ggaW4gdGhpcyBleGFtcGxlIGRvZXMgbm90IHN1cHBvcnQgQUNTLgo+IAo+IEkgdGhpbmsg
dGhlIGRldmljZXRyZWUgbXNpLW1hcCBwcm9wZXJ0eSBjb3VsZCBiZSB1c2VkIHRvICJtYXAiIHRo
ZSBSSUQgb2YKPiBFbmRwb2ludCBBIHRvIElUUyBBIGFuZCB0aGUgUklEIG9mIEVuZHBvaW50IEIg
dG8gSVRTIEIsIHdoaWNoIHdvdWxkIHZpb2xhdGUKPiB0aGUgYXNzdW1wdGlvbi4KPiAKPiBTZWUg
dGhlIG1vbm9saXRoaWMgZXhhbXBsZSBpbiBbMV0sIHRoZSBleGFtcGxlIHN5c3RlbSBpbiBbMl0s
IGFwcGVuZGljZXMKPiBELCBFIGFuZCBGIGluIFszXSBhbmQgdGhlIG1zaS1tYXAgcHJvcGVydHkg
aW4gWzRdLgoKVGhhbmsgeW91IGZvciB0aGUgcmV2aWV3ICYgbGlua3MuCgpJIHVuZGVyc3RhbmQg
dGhlIGFib3ZlIHRvcG9sb2d5IGlzIHBlcmZlY3RseSB2YWxpZC4gTm93IHRoZSBxdWVzdGlvbiBp
czoKaXMgaXQgc3VmZmljaWVudGx5IGNvbW1vbiB0byBjYXJlIGFib3V0IGl0PwoKQXQgdGhlIG1v
bWVudCBWRklPL3ZJT01NVSBhc3NpZ25tZW50IG9mIGRldmljZXMgYmVsb25naW5nIHRvIHRoZSBz
YW1lCmdyb3VwIGlzbid0IHVwc3RyZWFtIHlldC4gV29yayBpcyBvbmdvaW5nIGJ5IEFsZXggdG8g
c3VwcG9ydCBpdC4gSXQgdXNlcwphIFBDSWUtdG8tUENJIGJyaWRnZSBvbiBndWVzdCBzaWRlIGFu
ZCBpdCBsb29rcyB0aGlzIHRvcG9sb2d5IGlzIG5vdApzdXBwb3J0ZWQgYnkgdGhlIFNNTVV2MyBk
cml2ZXIuIFRoZW4gY29tZXMgdGhlIHRyb3VibGUgb2YgdXNpbmcgc2V2ZXJhbApJVFMgaW4gbmVz
dGVkIG1vZGUuCgpJZiB0aGlzIHRvcG9sb2d5IGlzIHN1ZmZpY2llbnRseSByYXJlIEkgcHJvcG9z
ZSB3ZSB0byBkbyBub3Qgc3VwcG9ydCBpdAppbiB0aGlzIFZGSU8vdklPTU1VIHVzZSBjYXNlLiBp
biB2NyBJIGludHJvZHVjZWQgYSBjaGVjayB0aGF0IGFpbXMgdG8KdmVyaWZ5IGRldmljZXMgYXR0
YWNoZWQgdG8gdGhlIHNhbWUgbmVzdGVkIGlvbW11X2RvbWFpbiBzaGFyZSB0aGUgc2FtZQptc2lf
ZG9tYWluLgoKVGhhbmtzCgpFcmljCj4gCj4gQmVzdCByZWdhcmRzLAo+IFZpbmNlbnQuCj4gCj4g
WzFdIGh0dHBzOi8vc3RhdGljLmRvY3MuYXJtLmNvbS8xMDAzMzYvMDEwMi9jb3JlbGlua19naWM2
MDBfZ2VuZXJpY19pbnRlcnJ1cHRfY29udHJvbGxlcl90ZWNobmljYWxfcmVmZXJlbmNlX21hbnVh
bF8xMDAzMzZfMDEwMl8wMF9lbi5wZGYKPiBbMl0gaHR0cDovL2luZm9jZW50ZXIuYXJtLmNvbS9o
ZWxwL3RvcGljL2NvbS5hcm0uZG9jLmRlbjAwNDlkL0RFTjAwNDlEX0lPX1JlbWFwcGluZ19UYWJs
ZS5wZGYKPiBbM10gaHR0cHM6Ly9zdGF0aWMuZG9jcy5hcm0uY29tL2RlbjAwMjkvNTAvUTEtREVO
MDAyOUJfU0JTQV81LjAucGRmCj4gWzRdIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL0RvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9wY2kvcGNpLW1zaS50eHQKPiAKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
