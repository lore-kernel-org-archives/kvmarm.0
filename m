Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A9DC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Nov 2021 12:19:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 665C94B15C;
	Mon, 22 Nov 2021 07:19:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xbNDav1n05sI; Mon, 22 Nov 2021 07:19:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F5054B154;
	Mon, 22 Nov 2021 07:19:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C9EC4B154
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 07:19:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GJvD51rmJQ+C for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Nov 2021 07:19:14 -0500 (EST)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 872FF4B13E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 07:19:14 -0500 (EST)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.207])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HyR6x0rvDz6H7ML;
 Mon, 22 Nov 2021 20:15:21 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 22 Nov 2021 13:19:12 +0100
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 22 Nov 2021 12:19:05 +0000
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 0/4] kvm/arm: New VMID allocator based on asid
Date: Mon, 22 Nov 2021 12:18:40 +0000
Message-ID: <20211122121844.867-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, maz@kernel.org, linuxarm@huawei.com,
 jonathan.cameron@huawei.com, catalin.marinas@arm.com, will@kernel.org
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

Q2hhbmdlcyBmcm9tIHYzOgotIE1haW4gY2hhbmdlIGlzIGluIHBhdGNoICM0LCB3aGVyZSB0aGUg
Vk1JRCBpcyBub3cgc2V0IHRvIGFuCiAgaW52YWxpZCBvbmUgb24gdkNQVSBzY2hlZHVsZSBvdXQu
IEludHJvZHVjZWQgYW4gCiAgSU5WQUxJRF9BQ1RJVkVfVk1JRCB3aGljaCBpcyBiYXNpY2FsbHkg
YSBWTUlEIDAgd2l0aCBnZW5lcmF0aW9uIDEuCsKgIFNpbmNlIHRoZSBiYXNpYyBhbGxvY2F0b3Ig
YWxnb3JpdGhtIHJlc2VydmVzIHZtaWQgIzAsIGl0IGlzIG5ldmVyCiAgdXNlZCBhcyBhbiBhY3Rp
dmUgVk1JRC4gVGhpcyAoaG9wZWZ1bGx5KSB3aWxsIGZpeCB0aGUgaXNzdWUgb2YKICB1bm5lY2Vz
c2FyaWx5IHJlc2VydmluZyBWTUlEIHNwYWNlIHdpdGggYWN0aXZlX3ZtaWRzIHdoZW4gdGhvc2UK
ICBWTXMgYXJlIG5vIGxvbmdlciBhY3RpdmVbMF0gYW5kIGF0IHRoZSBzYW1lIHRpbWUgYWRkcmVz
cyB0aGUKICBwcm9ibGVtIG5vdGVkIGluIHYzIHdoZXJlaW4gZXZlcnl0aGluZyBlbmRzIHVwIGlu
IHNsb3ctcGF0aFsxXS4KClRlc3Rpbmc6CsKgLVJ1biB3aXRoIFZNSUQgYml0IHNldCB0byA0IGFu
ZCBtYXhjcHVzIHRvIDggb24gRDA2LiBUaGUgdGVzdAogIGludm9sdmVzIHJ1bm5pbmcgY29uY3Vy
cmVudGx5IDUwIGd1ZXN0cyB3aXRoIDQgdkNQVXMuIEVhY2gKICBndWVzdCB3aWxsIHRoZW4gZXhl
Y3V0ZSBoYWNrYmVuY2ggNSB0aW1lcyBiZWZvcmUgZXhpdGluZy4KICBObyBjcmFzaCB3YXMgb2Jz
ZXJ2ZWQgZm9yIGEgNC1kYXkgY29udGludW91cyBydW4uCsKgIFRoZSBsYXRlc3QgYnJhbmNoIGlz
IGhlcmUsCsKgIMKgaHR0cHM6Ly9naXRodWIuY29tL2hpc2lsaWNvbi9rZXJuZWwtZGV2L3RyZWUv
cHJpdmF0ZS12NS4xNi1yYzEtdm1pZC12NAoKwqAtVExBKyBtb2RlbC4gTW9kaWZpZWQgdGhlIGFz
aWRhbGxvYyBtb2RlbCB0byBpbmNvcnBvcmF0ZSB0aGUgbmV3CiAgVk1JRCBhbGdvLiBUaGUgbWFp
biBkaWZmZXJlbmNlcyBhcmUsCsKgIC1mbHVzaF90bGJfYWxsKCkgaW5zdGVhZCBvZiBsb2NhbF90
bGJfZmx1c2hfYWxsKCkgb24gcm9sbG92ZXIuCsKgIC1JbnRyb2R1Y2VkIElOVkFMSURfVk1JRCBh
bmQgdkNQVSBTY2hlZCBPdXQgbG9naWMuCsKgIC1ObyBDblAgKFJlbW92ZWQgVW5pcXVlQVNJREFs
bENQVXMgJiBVbmlxdWVBU0lEQWN0aXZlVGFzayBpbnZhcmlhbnRzKS4KwqAgLVJlbW92ZWQgwqBV
bmlxdWVWTUlEUGVyQ1BVIGludmFyaWFudCBmb3Igbm93IGFzIGl0IGxvb2tzIGxpa2UKICAgYmVj
YXVzZSBvZiB0aGUgc3BlY3VsYXRpdmUgZmV0Y2hpbmcgd2l0aCBmbHVzaF90bGJfYWxsKCkgdGhl
cmUKICAgaXMgYSBzbWFsbCB3aW5kb3cgd2hlcmUgdGhpcyBnZXRzIHRyaWdnZXJlZC4gSWYgSSBj
aGFuZ2UgdGhlCiAgIGxvZ2ljIGJhY2sgdG8gbG9jYWxfZmx1c2hfdGxiX2FsbCgpLCBVbmlxdWVW
TUlEUGVyQ1BVIHNlZW1zIHRvCiAgIGJlIGZpbmUuIFdpdGggbXkgbGltaXRlZCBrbm93bGVkZ2Ug
b24gVExBKyBtb2RlbCwgaXQgaXMgbm90CiAgIGNsZWFyIHRvIG1lIHdoZXRoZXIgdGhpcyBpcyBh
IHByb2JsZW0gd2l0aCB0aGUgYWJvdmUgbG9naWMKICAgb3IgdGhlIFZNSUQgbW9kZWwgaW1wbGVt
ZW50YXRpb24uIFJlYWxseSBhcHByZWNpYXRlIGFueSBoZWxwCiAgIHdpdGggdGhlIG1vZGVsLgog
ICBUaGUgaW5pdGlhbCBWTUlEIFRMQSsgbW9kZWwgaXMgaGVyZSwKICAgaHR0cHM6Ly9naXRodWIu
Y29tL3NoYW1pYWxpMjAwOC9rZXJuZWwtdGxhL3RyZWUvcHJpdmF0ZS12bWlkYWxsb2MtdjEKClBs
ZWFzZSB0YWtlIGEgbG9vayBhbmQgbGV0IG1lIGtub3cuCgpUaGFua3MsClNoYW1lZXIKClswXSBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9rdm1hcm0vMjAyMTA3MjExNjA2MTQuR0MxMTAwM0B3aWxs
aWUtdGhlLXRydWNrLwpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtYXJtLzIwMjEwODAz
MTE0MDM0LkdCMzA4NTNAd2lsbGllLXRoZS10cnVjay8KCkhpc3Rvcnk6Ci0tLS0tLS0tCnYyIC0t
PiB2MwogIC1Ecm9wcGVkIGFkZGluZyBhIG5ldyBzdGF0aWMga2V5IGFuZCBjcHVmZWF0dXJlIGZv
ciByZXRyaWV2aW5nCiAgIHN1cHBvcnRlZCBWTUlEIGJpdHMuIEluc3RlYWQsIHdlIG5vdyBtYWtl
IHVzZSBvZiB0aGUKICAga3ZtX2FybV92bWlkX2JpdHMgdmFyaWFibGUgKHBhdGNoICMyKS4KCiAg
LVNpbmNlIHdlIGV4cGVjdCBsZXNzIGZyZXF1ZW50IHJvbGxvdmVyIGluIHRoZSBjYXNlIG9mIFZN
SURzLAogICB0aGUgVExCIGludmFsaWRhdGlvbiBpcyBub3cgYnJvYWRjYXN0ZWQgb24gcm9sbG92
ZXIgaW5zdGVhZAogICBvZiBrZWVwaW5nIHBlciBDUFUgZmx1c2hfcGVuZGluZyBpbmZvIGFuZCBp
c3N1aW5nIGEgbG9jYWwKICAgY29udGV4dCBmbHVzaC4KCiAgLUNsZWFyIGFjdGl2ZV92bWlkcyBv
biB2Q1BVIHNjaGVkdWxlIG91dCB0byBhdm9pZCB1bm5lY2Vzc2FyaWx5CiAgIHJlc2VydmluZyB0
aGUgVk1JRCBzcGFjZShwYXRjaCAjMykuCgogIC1JIGhhdmUga2VwdCB0aGUgc3RydWN0IGt2bV92
bWlkIGFzIGl0IGlzIGZvciBub3coaW5zdGVhZCBvZiBhCiAgIHR5cGVkZWYgYXMgc3VnZ2VzdGVk
KSwgYXMgd2UgbWF5IHNvb24gYWRkIGFub3RoZXIgdmFyaWFibGUgdG8KICAgaXQgd2hlbiB3ZSBp
bnRyb2R1Y2UgUGlubmVkIEtWTSBWTUlEIHN1cHBvcnQuCgpSRkN2MSAtLT4gdjIKICAgLURyb3Bw
ZWQgInBpbm5lZCBWTUlEIiBzdXBwb3J0IGZvciBub3cuCiAgIC1Ecm9wcGVkIFJGQyB0YWcuClJG
Q3YxCiAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bWFybS8yMDIxMDUwNjE2NTIzMi4xOTY5
LTEtc2hhbWVlcmFsaS5rb2xvdGh1bS50aG9kaUBodWF3ZWkuY29tLwoKSnVsaWVuIEdyYWxsICgx
KToKICBLVk06IGFybTY0OiBBbGlnbiB0aGUgVk1JRCBhbGxvY2F0aW9uIHdpdGggdGhlIGFybTY0
IEFTSUQKClNoYW1lZXIgS29sb3RodW0gKDMpOgogIEtWTTogYXJtNjQ6IEludHJvZHVjZSBhIG5l
dyBWTUlEIGFsbG9jYXRvciBmb3IgS1ZNCiAgS1ZNOiBhcm02NDogTWFrZSBWTUlEIGJpdHMgYWNj
ZXNzaWJsZSBvdXRzaWRlIG9mIGFsbG9jYXRvcgogIEtWTTogYXJtNjQ6IE1ha2UgYWN0aXZlX3Zt
aWRzIGludmFsaWQgb24gdkNQVSBzY2hlZHVsZSBvdXQKCiBhcmNoL2FybTY0L2luY2x1ZGUvYXNt
L2t2bV9ob3N0LmggICAgIHwgIDEwICstCiBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9tbXUu
aCAgICAgIHwgICA0ICstCiBhcmNoL2FybTY0L2tlcm5lbC9pbWFnZS12YXJzLmggICAgICAgIHwg
ICAzICsKIGFyY2gvYXJtNjQva3ZtL01ha2VmaWxlICAgICAgICAgICAgICAgfCAgIDIgKy0KIGFy
Y2gvYXJtNjQva3ZtL2FybS5jICAgICAgICAgICAgICAgICAgfCAxMDYgKysrLS0tLS0tLS0tLS0K
IGFyY2gvYXJtNjQva3ZtL2h5cC9udmhlL21lbV9wcm90ZWN0LmMgfCAgIDMgKy0KIGFyY2gvYXJt
NjQva3ZtL21tdS5jICAgICAgICAgICAgICAgICAgfCAgIDEgLQogYXJjaC9hcm02NC9rdm0vdm1p
ZC5jICAgICAgICAgICAgICAgICB8IDE5NiArKysrKysrKysrKysrKysrKysrKysrKysrKwogOCBm
aWxlcyBjaGFuZ2VkLCAyMjggaW5zZXJ0aW9ucygrKSwgOTcgZGVsZXRpb25zKC0pCiBjcmVhdGUg
bW9kZSAxMDA2NDQgYXJjaC9hcm02NC9rdm0vdm1pZC5jCgotLSAKMi4xNy4xCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
