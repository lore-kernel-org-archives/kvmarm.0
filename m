Return-Path: <SRS0=UwAz=HY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11117C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 15:54:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 510E464EDB
	for <kvmarm@archiver.kernel.org>; Mon, 22 Feb 2021 15:54:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 510E464EDB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C83894B153;
	Mon, 22 Feb 2021 10:54:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AnyYy0oVKzGv; Mon, 22 Feb 2021 10:54:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9919A4B164;
	Mon, 22 Feb 2021 10:54:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C5AF4B153
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 10:54:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CJVLTZNC4kOJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Feb 2021 10:54:25 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 793A34B103
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2021 10:54:24 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Dkmsp3LKRz7mcv;
 Mon, 22 Feb 2021 23:52:46 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.88.147) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Feb 2021 23:54:14 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>,
 <iommu@lists.linux-foundation.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [RFC PATCH 0/5] KVM/ARM64 Add support for pinned VMIDs
Date: Mon, 22 Feb 2021 15:53:33 +0000
Message-ID: <20210222155338.26132-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.47.88.147]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, maz@kernel.org, linuxarm@openeuler.org,
 alex.williamson@redhat.com, prime.zeng@hisilicon.com,
 jonathan.cameron@huawei.com, zhangfei.gao@linaro.org
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

T24gYW4gQVJNNjQgc3lzdGVtIHdpdGggYSBTTU1VdjPCoGltcGxlbWVudGF0aW9uIHRoYXQgZnVs
bHkgc3VwcG9ydHMKQnJvYWRjYXN0IFRMQiBNYWludGVuYW5jZShCVE0pIGZlYXR1cmXCoGFzwqBw
YXJ0IG9mIHRoZSBEaXN0cmlidXRlZApWaXJ0dWFsIE1lbW9yeShEVk0pIHByb3RvY29sLCB0aGUg
Q1BVIFRMQiBpbnZhbGlkYXRlIGluc3RydWN0aW9ucyBhcmUKcmVjZWl2ZWTCoGJ5IFNNTVV2My4g
VGhpcyBpc8KgdmVyecKgdXNlZnVsIHdoZW4gdGhlwqBTTU1VdjMgc2hhcmVzwqB0aGUKcGFnZSB0
YWJsZXMgd2l0aCB0aGUgQ1BVKGVnOiBHdWVzdCBTVkEgdXNlIGNhc2UpLiBGb3IgdGhpcyB0byB3
b3JrLAp0aGUgU01NVSBtdXN0IHVzZSB0aGUgc2FtZSBWTUlEIHRoYXQgaXMgYWxsb2NhdGVkIGJ5
IEtWTSB0byBjb25maWd1cmUKdGhlIHN0YWdlIDIgdHJhbnNsYXRpb25zLiBBdCBwcmVzZW50wqBL
Vk0gVk1JRCBhbGxvY2F0aW9ucyBhcmUgcmVjeWNsZWQKb24gcm9sbG92ZXIgYW5kIG1heSBjaGFu
Z2UgYXMgYSByZXN1bHQuIFRoaXMgd2lsbCBjcmVhdGUgaXNzdWVzIGlmIHdlCmhhdmXCoHRvIHNo
YXJlIHRoZSBLVk0gVk1JRCB3aXRoIFNNTVUuCsKgClBsZWFzZSBzZWUgdGhlIGRpc2N1c3Npb24g
aGVyZSwKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtaW9tbXUvMjAyMDA1MjIxMDE3NTUu
R0EzNDUzOTQ1QG15cmljYS8KClRoaXMgc2VyaWVzIHByb3Bvc2VzIGEgd2F5IHRvIHNoYXJlIHRo
ZSBWTUlEIGJldHdlZW4gS1ZNIGFuZCBJT01NVQpkcml2ZXIgYnksCgoxLiBTcGxpdHRpbmcgdGhl
IEtWTSBWTUlEIHNwYWNlIGludG8gdHdvIGVxdWFsIGhhbHZlcyBiYXNlZCBvbiB0aGUKIMKgIGNv
bW1hbmQgbGluZSBvcHRpb27CoCJrdm0tYXJtLnBpbm5lZF92bWlkX2VuYWJsZSIuCjIuIEZpcnN0
IGhhbGYgb2YgdGhlIFZNSUQgc3BhY2UgZm9sbG93cyB0aGUgbm9ybWFsIHJlY3ljbGUgb24gcm9s
bG92ZXIKwqAgwqBwb2xpY3kuCjMuIFNlY29uZCBoYWxmIG9mIHRoZSBWTUlEIHNwYWNlIGRvZXNu
J3Qgcm9sbCBvdmVyIGFuZCBpcyB1c2VkIHRvCsKgIMKgYWxsb2NhdGXCoHBpbm5lZCBWTUlEcy4K
NC4gUHJvdmlkZXMgaGVscGVyIGZ1bmN0aW9uIHRvIHJldHJpZXZlIHRoZcKgS1ZNIGluc3RhbmNl
wqBhc3NvY2lhdGVkCiAgwqB3aXRoIGEgZGV2aWNlKGlmIGl0IGlzIHBhcnQgb2YgYSB2ZmlvIGdy
b3VwKS4KNS4gSW50cm9kdWNlcyBnZW5lcmljIGludGVyZmFjZXMgdG8gZ2V0L3B1dCBwaW5uZWQg
S1ZNIFZNSURzLgoKT3BlbiBJdGVtczoKMS4gSSBjb3VsZG4ndMKgZmlndXJlIG91dCBhIHdheSB0
byBkZXRlcm1pbmUgd2hldGhlciBhIHBsYXRmb3JtwqBhY3R1YWxseQogIMKgZnVsbHkgc3VwcG9y
dHMgRFZNL0JUTSBvciBub3QuIE5vdCBzdXJlIHdlIGNhbiB0YWtlIGEgY2FsbCBiYXNlZCBvbgog
ICBTTU1VdjMgQlRNIGZlYXR1cmUgYml0IGFsb25lLiBQcm9iYWJseSB3ZSBjYW7CoGdldCBpdCBm
cm9tIGZpcm13YXJlCiAgIHZpYSBJT1JUPwoyLiBUaGUgY3VycmVudCBzcGxpdHRpbmcgb2YgVk1J
RCBzcGFjZSBpcyBvbmx5IG9uZSB3YXkgdG8gZG8gdGhpcyBhbmQKICAgcHJvYmFibHkgbm90IHRo
ZSBiZXN0LsKgTWF5YmUgd2UgY2FuIGZvbGxvdyB0aGUgcGlubmVkIEFTSUQgbWV0aG9kIHVzZWQK
ICAgaW4gU1ZBIGNvZGUuIFN1Z2dlc3Rpb25zwqB3ZWxjb21lwqBoZXJlLgozLiBUaGUgZGV0YWNo
X3Bhc2lkX3RhYmxlKCkgaW50ZXJmYWNlIGlzIG5vdCB2ZXJ5IGNsZWFyIHRvIG1lIGFzIHRoZSBj
dXJyZW50CiAgIFFlbXUgcHJvdG90eXBlIGlzwqBub3TCoCB1c2luZyB0aGF0LiBUaGlzIHJlcXVp
cmVzIGZpeGluZyBmcm9tIG15IHNpZGUuCsKgClRoaXMgaXMgYmFzZWQgb24gSmVhbi1QaGlsaXBw
ZSdzIFNWQSBzZXJpZXNbMV0gYW5kIEVyaWMncyBTTU1VdjMgZHVhbC1zdGFnZQpzdXBwb3J0IHNl
cmllc1syXS4KClRoZSBicmFuY2ggd2l0aCB0aGUgd2hvbGUgdlNWQSArIEJUTSBzb2x1dGlvbiBp
cyBoZXJlLApodHRwczovL2dpdGh1Yi5jb20vaGlzaWxpY29uL2tlcm5lbC1kZXYvdHJlZS81LjEw
LXJjNC0yc3RhZ2UtdjEzLXZzdmEtYnRtLXJmYwoKVGhpcyBpcyBsaWdodGx5IHRlc3RlZCBvbiBh
IEhpU2lsaWNvbiBEMDYgcGxhdGZvcm0gd2l0aCB1YWNjZS96aXAgZGV2IHRlc3QgdG9vbCwKLi96
aXBfc3ZhX3BlciAtayB0bGIKClRoYW5rcywKU2hhbWVlcgoKMS7CoGh0dHBzOi8vZ2l0aHViLmNv
bS9MaW5hcm8vbGludXgta2VybmVsLXVhZGsvY29tbWl0cy91YWNjZS1kZXZlbC01LjEwCjIuwqBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1pb21tdS8yMDIwMTExODExMjE1MS4yNTQxMi0x
LWVyaWMuYXVnZXJAcmVkaGF0LmNvbS9ULwoKU2hhbWVlciBLb2xvdGh1bSAoNSk6CiAgdmZpbzog
QWRkIGEgaGVscGVyIHRvIHJldHJpZXZlIGt2bSBpbnN0YW5jZSBmcm9tIGEgZGV2CiAgS1ZNOiBB
ZGQgZ2VuZXJpYyBpbmZyYXN0cnVjdHVyZSB0byBzdXBwb3J0IHBpbm5lZCBWTUlEcwogIEtWTTog
QVJNNjQ6IEFkZCBzdXBwb3J0IGZvciBwaW5uZWQgVk1JRHMKICBpb21tdS9hcm0tc21tdS12Mzog
VXNlIHBpbm5lZCBWTUlEIGZvciBORVNURUQgc3RhZ2Ugd2l0aCBCVE0KICBLVk06IGFybTY0OiBN
YWtlIHN1cmUgcGlubmVkIHZtaWQgaXMgcmVsZWFzZWQgb24gVk0gZXhpdAoKIGFyY2gvYXJtNjQv
aW5jbHVkZS9hc20va3ZtX2hvc3QuaCAgICAgICAgICAgfCAgIDIgKwogYXJjaC9hcm02NC9rdm0v
S2NvbmZpZyAgICAgICAgICAgICAgICAgICAgICB8ICAgMSArCiBhcmNoL2FybTY0L2t2bS9hcm0u
YyAgICAgICAgICAgICAgICAgICAgICAgIHwgMTE2ICsrKysrKysrKysrKysrKysrKystCiBkcml2
ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5jIHwgIDQ5ICsrKysrKysrLQog
ZHJpdmVycy92ZmlvL3ZmaW8uYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICAxMiArKwogaW5j
bHVkZS9saW51eC9rdm1faG9zdC5oICAgICAgICAgICAgICAgICAgICB8ICAxNyArKysKIGluY2x1
ZGUvbGludXgvdmZpby5oICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDEgKwogdmlydC9rdm0v
S2NvbmZpZyAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArCiB2aXJ0L2t2bS9rdm1f
bWFpbi5jICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDI1ICsrKysrCiA5IGZpbGVzIGNoYW5n
ZWQsIDIyMCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKLS0gCjIuMTcuMQoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcg
bGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1i
aWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
