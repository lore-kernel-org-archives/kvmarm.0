Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8F3C43460
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 07:51:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B44E1613B6
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 07:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B44E1613B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C6724B2CB;
	Mon, 10 May 2021 03:51:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PGWavxyaZgrx; Mon, 10 May 2021 03:51:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB8D84B39B;
	Mon, 10 May 2021 03:51:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 129E54B373
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 May 2021 23:00:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tarQbYKiSIqL for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 May 2021 23:00:53 -0400 (EDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 746214B320
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 May 2021 23:00:53 -0400 (EDT)
IronPort-SDR: DS0OdAMyH+gsd59NlCSiEhwohBL+EX/GchzYtWJNj4p437GV+WWICg5HCWEki1dWAw9uNMkmIn
 sTjdRxVi8L1w==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="199149204"
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; d="scan'208";a="199149204"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 09 May 2021 20:00:51 -0700
IronPort-SDR: uhZUQngbuGEQq0E1Bk7Pmkzto28JvYBFdcwQNt85aUpzZFrDhbnyklFDUPSNkQ4wyJETH7Xnd5
 t9ejrt3/uhrg==
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; d="scan'208";a="435941124"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.212.136])
 ([10.254.212.136])
 by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 09 May 2021 20:00:49 -0700
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com, maz@kernel.org,
 alex.williamson@redhat.com
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
From: "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <a659fc6f-2c7a-23d2-9c34-0044d5a31861@intel.com>
Date: Mon, 10 May 2021 11:00:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <b309c02d-9570-6400-9a0c-63030aed7ff7@redhat.com>
Content-Language: en-US
X-Mailman-Approved-At: Mon, 10 May 2021 03:51:13 -0400
Cc: stable@vger.kernel.org, cohuck@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
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

CgpPbiA1LzEwLzIwMjEgMTA6NDMgQU0sIEphc29uIFdhbmcgd3JvdGU6Cj4KPiDlnKggMjAyMS81
Lzgg5LiL5Y2IMzoxMSwgWmh1IExpbmdzaGFuIOWGmemBkzoKPj4gVGhpcyByZXZlcnRzIGNvbW1p
dCBhOTc5YTZhYTAwOWYzYzk5Njg5NDMyZTBjZGI1NDAyYTQ0NjNmYjg4Lgo+Pgo+PiBUaGUgcmV2
ZXJ0ZWQgY29tbWl0IG1heSBjYXVzZSBWTSBmcmVlemUgb24gYXJtNjQgcGxhdGZvcm0uCj4+IEJl
Y2F1c2Ugb24gYXJtNjQgcGxhdGZvcm0sIHN0b3AgYSBjb25zdW1lciB3aWxsIHN1c3BlbmQgdGhl
IFZNLAo+PiB0aGUgVk0gd2lsbCBmcmVlemUgd2l0aG91dCBhIHN0YXJ0IGNvbnN1bWVyCj4+Cj4+
IFNpZ25lZC1vZmYtYnk6IFpodSBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4KPgo+
Cj4gQWNrZWQtYnk6IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+Cj4KPiBQbGVhc2Ug
cmVzdWJtaXQgd2l0aCB0aGUgZm9ybWFsIHByb2Nlc3Mgb2Ygc3RhYmxlIAo+IChzdGFibGUta2Vy
bmVsLXJ1bGVzLnJzdCkuCnN1cmUsIEkgd2lsbCByZS1zdWJtaXQgaXQgdG8gc3RhYmxlIGtlcm5l
bCBvbmNlIGl0IGlzIG1lcmdlZCBpbnRvIExpbnVzIAp0cmVlLgoKVGhhbmtzCj4KPiBUaGFua3MK
Pgo+Cj4+IC0tLQo+PiDCoCB2aXJ0L2xpYi9pcnFieXBhc3MuYyB8IDE2ICsrKysrKy0tLS0tLS0t
LS0KPj4gwqAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0p
Cj4+Cj4+IGRpZmYgLS1naXQgYS92aXJ0L2xpYi9pcnFieXBhc3MuYyBiL3ZpcnQvbGliL2lycWJ5
cGFzcy5jCj4+IGluZGV4IGM5YmIzOTU3ZjU4YS4uMjhmZGE0MmU0NzFiIDEwMDY0NAo+PiAtLS0g
YS92aXJ0L2xpYi9pcnFieXBhc3MuYwo+PiArKysgYi92aXJ0L2xpYi9pcnFieXBhc3MuYwo+PiBA
QCAtNDAsMjEgKzQwLDE3IEBAIHN0YXRpYyBpbnQgX19jb25uZWN0KHN0cnVjdCBpcnFfYnlwYXNz
X3Byb2R1Y2VyIAo+PiAqcHJvZCwKPj4gwqDCoMKgwqDCoCBpZiAocHJvZC0+YWRkX2NvbnN1bWVy
KQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0gcHJvZC0+YWRkX2NvbnN1bWVyKHByb2QsIGNv
bnMpOwo+PiDCoCAtwqDCoMKgIGlmIChyZXQpCj4+IC3CoMKgwqDCoMKgwqDCoCBnb3RvIGVycl9h
ZGRfY29uc3VtZXI7Cj4+IC0KPj4gLcKgwqDCoCByZXQgPSBjb25zLT5hZGRfcHJvZHVjZXIoY29u
cywgcHJvZCk7Cj4+IC3CoMKgwqAgaWYgKHJldCkKPj4gLcKgwqDCoMKgwqDCoMKgIGdvdG8gZXJy
X2FkZF9wcm9kdWNlcjsKPj4gK8KgwqDCoCBpZiAoIXJldCkgewo+PiArwqDCoMKgwqDCoMKgwqAg
cmV0ID0gY29ucy0+YWRkX3Byb2R1Y2VyKGNvbnMsIHByb2QpOwo+PiArwqDCoMKgwqDCoMKgwqAg
aWYgKHJldCAmJiBwcm9kLT5kZWxfY29uc3VtZXIpCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHByb2QtPmRlbF9jb25zdW1lcihwcm9kLCBjb25zKTsKPj4gK8KgwqDCoCB9Cj4+IMKgIMKgwqDC
oMKgwqAgaWYgKGNvbnMtPnN0YXJ0KQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgY29ucy0+c3RhcnQo
Y29ucyk7Cj4+IMKgwqDCoMKgwqAgaWYgKHByb2QtPnN0YXJ0KQo+PiDCoMKgwqDCoMKgwqDCoMKg
wqAgcHJvZC0+c3RhcnQocHJvZCk7Cj4+IC1lcnJfYWRkX3Byb2R1Y2VyOgo+PiAtwqDCoMKgIGlm
IChwcm9kLT5kZWxfY29uc3VtZXIpCj4+IC3CoMKgwqDCoMKgwqDCoCBwcm9kLT5kZWxfY29uc3Vt
ZXIocHJvZCwgY29ucyk7Cj4+IC1lcnJfYWRkX2NvbnN1bWVyOgo+PiArCj4+IMKgwqDCoMKgwqAg
cmV0dXJuIHJldDsKPj4gwqAgfQo+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
