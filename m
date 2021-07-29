Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A825C432BE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 10:43:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1279260EFF
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 10:43:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1279260EFF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F2034B0A1;
	Thu, 29 Jul 2021 06:43:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Js1YldXkGlz; Thu, 29 Jul 2021 06:43:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61BC34B08E;
	Thu, 29 Jul 2021 06:43:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6B144B08A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:43:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 08b91F9PxRt1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 06:43:34 -0400 (EDT)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60D324A1B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:43:34 -0400 (EDT)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.207])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gb6F30FB3z6GDSW;
 Thu, 29 Jul 2021 18:28:23 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 12:43:31 +0200
Received: from A2006125610.china.huawei.com (10.47.90.183) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 11:43:24 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/4] kvm/arm: New VMID allocator based on asid
Date: Thu, 29 Jul 2021 11:40:05 +0100
Message-ID: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.47.90.183]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, maz@kernel.org, linuxarm@huawei.com,
 catalin.marinas@arm.com, will@kernel.org
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

SGksCgpNYWpvciBjaGFuZ2VzIHNpbmNlIHYyIChCYXNlZCBvbiBXaWxsJ3MgZmVlZGJhY2spCiAg
LURyb3BwZWQgYWRkaW5nIGEgbmV3IHN0YXRpYyBrZXkgYW5kIGNwdWZlYXR1cmUgZm9yIHJldHJp
ZXZpbmcKICAgc3VwcG9ydGVkIFZNSUQgYml0cy4gSW5zdGVhZCwgd2Ugbm93IG1ha2UgdXNlIG9m
IHRoZSAKICAga3ZtX2FybV92bWlkX2JpdHMgdmFyaWFibGUgKHBhdGNoICMyKS4KCiAgLVNpbmNl
IHdlIGV4cGVjdCBsZXNzIGZyZXF1ZW50IHJvbGxvdmVyIGluIHRoZSBjYXNlIG9mIFZNSURzLAog
ICB0aGUgVExCIGludmFsaWRhdGlvbiBpcyBub3cgYnJvYWRjYXN0ZWQgb24gcm9sbG92ZXIgaW5z
dGVhZAogICBvZiBrZWVwaW5nIHBlciBDUFUgZmx1c2hfcGVuZGluZyBpbmZvwqBhbmQgaXNzdWlu
ZyBhIGxvY2FsCiAgIGNvbnRleHQgZmx1c2guIMKgCgogLUNsZWFyIGFjdGl2ZV92bWlkcyBvbiB2
Q1BVIHNjaGVkdWxlIG91dCB0byBhdm9pZCB1bm5lY2Vzc2FyaWx5CiAgcmVzZXJ2aW5nIHRoZSBW
TUlEIHNwYWNlKHBhdGNoICMzKS4gCgogLUkgaGF2ZSBrZXB0IHRoZSBzdHJ1Y3Qga3ZtX3ZtaWQg
YXMgaXQgaXMgZm9yIG5vdyhpbnN0ZWFkIG9mIGEKICB0eXBlZGVmIGFzIHN1Z2dlc3RlZCksIGFz
wqB3ZSBtYXkgc29vbiBhZGQgYW5vdGhlciB2YXJpYWJsZSB0bwogIGl0IHdoZW4gd2UgaW50cm9k
dWNlIFBpbm5lZCBLVk0gVk1JRCBzdXBwb3J0LgoKU2FuaXR5IHRlc3RlZCBvbiBIaVNpbGljb24g
RDA2IGJvYXJkLgoKVGhhbmtzLApTaGFtZWVyCgoKUkZDdjEgLS0+IHYyCiAgIC0gRHJvcHBlZCAi
cGlubmVkIFZNSUQiIHN1cHBvcnQgZm9yIG5vdy4KICAgLSBEcm9wcGVkIFJGQyB0YWcuCgpIaXN0
b3J5KGZyb20gUkZDIHYxKToKLS0tLS0tLS0tLS0tLS0tLS0tLQoKUGxlYXNlIGZpbmQgdGhlIFJG
QyBzZXJpZXMgaGVyZSwKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtYXJtLzIwMjEwNTA2MTY1
MjMyLjE5NjktMS1zaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20vCgpUaGlzIGlz
IGJhc2VkIG9uIGEgc3VnZ2VzdGlvbiBmcm9tIFdpbGwgWzBdIHRvIHRyeSBvdXQgdGhlIGFzaWQK
YmFzZWQga3ZtIHZtaWQgc29sdXRpb24gYXMgYSBzZXBhcmF0ZSBWTUlEIGFsbG9jYXRvciBpbnN0
ZWFkIG9mCnRoZSBzaGFyZWQgbGliIGFwcHJvYWNoIGF0dGVtcHRlZCBpbiB2NFsxXS4KClRoZSBp
ZGVhIGlzIHRvIGNvbXBhcmUgYm90aCB0aGUgYXBwcm9hY2hlcyBhbmQgc2VlIHdoZXRoZXIgdGhl
CnNoYXJlZCBsaWIgc29sdXRpb27CoHdpdGjCoGNhbGxiYWNrcyBtYWtlIHNlbnNlIG9yIG5vdC7C
oAoKVGhvdWdoIHdlIGFyZSBub3QgeWV0IHVzaW5nIHRoZSBwaW5uZWTCoHZtaWRzIHlldCwgcGF0
Y2ggIzIgaGFzCmNvZGUgZm9yIHBpbm5lZCB2bWlkIHN1cHBvcnQuIFRoaXMgaXMganVzdCB0b8Kg
aGVscCB0aGUgY29tcGFyaXNvbi4KClRlc3QgU2V0dXAvUmVzdWx0cwotLS0tLS0tLS0tLS0tLS0t
ClRoZSBtZWFzdXJlbWVudCB3YXMgbWFkZSB3aXRoIG1heGNwdXMgc2V0IHRvIDggYW5kIHdpdGgg
dGhlCm51bWJlciBvZiBWTUlEIGxpbWl0ZWQgdG8gNC1iaXQuIFRoZSB0ZXN0IGludm9sdmVzIHJ1
bm5pbmcKY29uY3VycmVudGx5IDQwIGd1ZXN0cyB3aXRoIDIgdkNQVXMuIEVhY2ggZ3Vlc3Qgd2ls
bCB0aGVuCmV4ZWN1dGUgaGFja2JlbmNoIDUgdGltZXMgYmVmb3JlIGV4aXRpbmcuCgpUaGUgcGVy
Zm9ybWFuY2UgZGlmZmVyZW5jZSBiZXR3ZWVuIHRoZSBjdXJyZW50IGFsZ28gYW5kIHRoZQpuZXcg
b25lIGFyZShhdmcuIG9mIDEwIHJ1bnMpOgrCoCDCoCAtIDEuOSUgbGVzcyBlbnRyeS9leGl0IGZy
b20gdGhlIGd1ZXN0CsKgIMKgIC0gMC41JSBmYXN0ZXIKClRoaXMgaXMgbW9yZSBvciBsZXNzIGNv
bXBhcmFibGUgdG8gdjQgbnVtYmVycy4KCkZvciB0aGUgY29tcGxldGUgc2VyaWVzLCBwbGVhc2Ug
c2VlLApodHRwczovL2dpdGh1Yi5jb20vaGlzaWxpY29uL2tlcm5lbC1kZXYvdHJlZS9wcml2YXRl
LXY1LjEyLXJjNy12bWlkLTJuZC1yZmMKCmFuZCBmb3IgdGhlIHNoYXJlZCBhc2lkIGxpYiB2NCBz
b2x1dGlvbiwKaHR0cHM6Ly9naXRodWIuY29tL2hpc2lsaWNvbi9rZXJuZWwtZGV2L3RyZWUvcHJp
dmF0ZS12NS4xMi1yYzctYXNpZC12NAoKQXMgeW91IGNhbiBzZWUgdGhlcmUgYXJlIG9mY291cnNl
IGNvZGUgZHVwbGljYXRpb24gd2l0aCB0aGlzCmFwcHJvYWNoIGJ1dCBtYXkgYmUgaXQgaXMgbW9y
ZSBlYXN5IHRvIG1haW50YWluIGNvbnNpZGVyaW5nCnRoZSBjb21wbGV4aXR5IGludm9sdmVkLgoK
UGxlYXNlIHRha2UgYSBsb29rIGFuZCBsZXQgbWUga25vdyB5b3VyIGZlZWRiYWNrLgoKVGhhbmtz
LApTaGFtZWVyCgpKdWxpZW4gR3JhbGwgKDEpOgogIEtWTTogYXJtNjQ6IEFsaWduIHRoZSBWTUlE
IGFsbG9jYXRpb24gd2l0aCB0aGUgYXJtNjQgQVNJRCBvbmUKClNoYW1lZXIgS29sb3RodW0gKDMp
OgogIEtWTTogYXJtNjQ6IEludHJvZHVjZSBhIG5ldyBWTUlEIGFsbG9jYXRvciBmb3IgS1ZNCiAg
S1ZNOiBhcm02NDogTWFrZSBWTUlEIGJpdHMgYWNjZXNzaWJsZSBvdXRzaWRlIG9mIGFsbG9jYXRv
cgogIEtWTTogYXJtNjQ6IENsZWFyIGFjdGl2ZV92bWlkcyBvbiB2Q1BVIHNjaGVkdWxlIG91dAoK
IGFyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCAgICAgfCAgMTAgKy0KIGFyY2gvYXJt
NjQvaW5jbHVkZS9hc20va3ZtX21tdS5oICAgICAgfCAgIDQgKy0KIGFyY2gvYXJtNjQva2VybmVs
L2ltYWdlLXZhcnMuaCAgICAgICAgfCAgIDMgKwogYXJjaC9hcm02NC9rdm0vTWFrZWZpbGUgICAg
ICAgICAgICAgICB8ICAgMiArLQogYXJjaC9hcm02NC9rdm0vYXJtLmMgICAgICAgICAgICAgICAg
ICB8IDEyMiArKysrKy0tLS0tLS0tLS0tLQogYXJjaC9hcm02NC9rdm0vaHlwL252aGUvbWVtX3By
b3RlY3QuYyB8ICAgMyArLQogYXJjaC9hcm02NC9rdm0vbW11LmMgICAgICAgICAgICAgICAgICB8
ICAgMSAtCiBhcmNoL2FybTY0L2t2bS92bWlkLmMgICAgICAgICAgICAgICAgIHwgMTgyICsrKysr
KysrKysrKysrKysrKysrKysrKysrCiA4IGZpbGVzIGNoYW5nZWQsIDIyOCBpbnNlcnRpb25zKCsp
LCA5OSBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybTY0L2t2bS92bWlk
LmMKCi0tIAoyLjE3LjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
