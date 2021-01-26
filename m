Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034D4C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 12:45:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A59DC2311D
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 12:45:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A59DC2311D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 575D34B28A;
	Tue, 26 Jan 2021 07:45:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nyk11P8b2X-6; Tue, 26 Jan 2021 07:45:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1231E4B224;
	Tue, 26 Jan 2021 07:45:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7484B28A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 07:45:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5ZxuA3i21kTH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 07:45:28 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3629B4B29A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 07:45:26 -0500 (EST)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQ5yR2C4WzjDdv;
 Tue, 26 Jan 2021 20:43:59 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 20:45:01 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: [RFC PATCH 0/7] kvm: arm64: Implement SW/HW combined dirty log
Date: Tue, 26 Jan 2021 20:44:37 +0800
Message-ID: <20210126124444.27136-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: yubihong@huawei.com, Cornelia Huck <cohuck@redhat.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, zhengchuan@huawei.com,
 Alex Williamson <alex.williamson@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>
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

VGhlIGludGVudGlvbjoKCk9uIGFybTY0IHBsYXRmb3JtLCB3ZSB0cmFja2luZyBkaXJ0eSBsb2cg
b2YgdkNQVSB0aHJvdWdoIGd1ZXN0IG1lbW9yeSBhYm9ydC4KS1ZNIG9jY3VweXMgc29tZSB2Q1BV
IHRpbWUgb2YgZ3Vlc3QgdG8gY2hhbmdlIHN0YWdlMiBtYXBwaW5nIGFuZCBtYXJrIGRpcnR5LgpU
aGlzIGxlYWRzIHRvIGhlYXZ5IHNpZGUgZWZmZWN0IG9uIFZNLCBlc3BlY2lhbGx5IHdoZW4gbXVs
dGkgdkNQVSByYWNlIGFuZApzb21lIG9mIHRoZW0gYmxvY2sgb24ga3ZtIG1tdV9sb2NrLgoKREJN
IGlzIGEgSFcgYXV4aWxpYXJ5IGFwcHJvYWNoIHRvIGxvZyBkaXJ0eS4gTU1VIGNoYWdlcyBQVEUg
dG8gYmUgd3JpdGFibGUgaWYKaXRzIERCTSBiaXQgaXMgc2V0LiBUaGVuIEtWTSBkb2Vzbid0IG9j
Y3VweSB2Q1BVIHRpbWUgdG8gbG9nIGRpcnR5LgoKQWJvdXQgdGhpcyBwYXRjaCBzZXJpZXM6CgpU
aGUgYmlnZ2VzdCBwcm9ibGVtIG9mIGFwcGx5IERCTSBmb3Igc3RhZ2UyIGlzIHRoYXQgc29mdHdh
cmUgbXVzdCBzY2FuIFBUcyB0bwpjb2xsZWN0IGRpcnR5IHN0YXRlLCB3aGljaCBtYXkgY29zdCBt
dWNoIHRpbWUgYW5kIGFmZmVjdCBkb3dudGltZSBvZiBtaWdyYXRpb24uCgpUaGlzIHNlcmllcyBy
ZWFsaXplIGEgU1cvSFcgY29tYmluZWQgZGlydHkgbG9nIHRoYXQgY2FuIGVmZmVjdGl2ZWx5IHNv
bHZlIHRoaXMKcHJvYmxlbSAoVGhlIHNtbXUgc2lkZSBjYW4gYWxzbyB1c2UgdGhpcyBhcHByb2Fj
aCB0byBzb2x2ZSBkbWEgZGlydHkgbG9nIHRyYWNraW5nKS4KClRoZSBjb3JlIGlkZWEgaXMgdGhh
dCB3ZSBkbyBub3QgZW5hYmxlIGhhcmR3YXJlIGRpcnR5IGF0IHN0YXJ0IChkbyBub3QgYWRkIERC
TSBiaXQpLgpXaGVuIGEgYXJiaXRyYXJ5IFBUIG9jY3VycyBmYXVsdCwgd2UgZXhlY3V0ZSBzb2Z0
IHRyYWNraW5nIGZvciB0aGlzIFBUIGFuZCBlbmFibGUKaGFyZHdhcmUgdHJhY2tpbmcgZm9yIGl0
cyAqbmVhcmJ5KiBQVHMgKGUuZy4gQWRkIERCTSBiaXQgZm9yIG5lYXJieSAxNlBUcykuIFRoZW4g
d2hlbgpzeW5jIGRpcnR5IGxvZywgd2UgaGF2ZSBrbm93biBhbGwgUFRzIHdpdGggaGFyZHdhcmUg
ZGlydHkgZW5hYmxlZCwgc28gd2UgZG8gbm90IG5lZWQKdG8gc2NhbiBhbGwgUFRzLgoKICAgICAg
ICBtZW0gYWJvcnQgcG9pbnQgICAgICAgICAgICAgbWVtIGFib3J0IHBvaW50CiAgICAgICAgICAg
ICAg4oaTICAgICAgICAgICAgICAgICAgICAgICAgICAgIOKGkwotLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KICAgICAgICB8Kioq
KioqKip8ICAgICAgICB8ICAgICAgICB8KioqKioqKip8ICAgICAgICB8ICAgICAgICB8Ci0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQogICAgICAgICAgICAg4oaRICAgICAgICAgICAgICAgICAgICAgICAgICAgIOKGkQogICAgICAg
IHNldCBEQk0gYml0IG9mICAgICAgICAgICAgICAgc2V0IERCTSBiaXQgb2YKICAgICB0aGlzIFBU
IHNlY3Rpb24gKDY0UFRFcykgICAgICB0aGlzIFBUIHNlY3Rpb24gKDY0UFRFcykKCldlIG1heSB3
b3JyeSB0aGF0IHdoZW4gZGlydHkgcmF0ZSBpcyBvdmVyLWhpZ2ggd2Ugc3RpbGwgbmVlZCB0byBz
Y2FuIHRvbyBtdWNoIFBUcy4KV2UgbWFpbmx5IGNvbmNlcm4gdGhlIFZNIHN0b3AgdGltZS4gV2l0
aCBRZW11IGRpcnR5IHJhdGUgdGhyb3R0bGluZywgdGhlIGRpcnR5IG1lbW9yeQppcyBjbG9zaW5n
IHRvIHRoZSBWTSBzdG9wIHRocmVzaG9sZCwgc28gdGhlcmUgaXMgYSBsaXR0bGUgUFRzIHRvIHNj
YW4gYWZ0ZXIgVk0gc3RvcC4KCkl0IGhhcyB0aGUgYWR2YW50YWdlcyBvZiBoYXJkd2FyZSB0cmFj
a2luZyB0aGF0IG1pbmltaXplcyBzaWRlIGVmZmVjdCBvbiB2Q1BVLAphbmQgYWxzbyBoYXMgdGhl
IGFkdmFudGFnZXMgb2Ygc29mdHdhcmUgdHJhY2tpbmcgdGhhdCBjb250cm9scyB2Q1BVIGRpcnR5
IHJhdGUuCk1vcmVvdmVyLCBzb2Z0d2FyZSB0cmFja2luZyBoZWxwcyB1cyB0byBzY2FuIFBUcyBh
dCBzb21lIGZpeGVkIHBvaW50cywgd2hpY2gKZ3JlYXRseSByZWR1Y2VzIHNjYW5uaW5nIHRpbWUu
IEFuZCB0aGUgYmlnZ2VzdCBiZW5lZml0IGlzIHRoYXQgd2UgY2FuIGFwcGx5IHRoaXMKc29sdXRp
b24gZm9yIGRtYSBkaXJ0eSB0cmFja2luZy4KClRlc3Q6CgpIb3N0OiBLdW5wZW5nIDkyMCB3aXRo
IDEyOCBDUFUgNTEyRyBSQU0uIERpc2FibGUgVHJhbnNwYXJlbnQgSHVnZXBhZ2UgKEVuc3VyZSB0
ZXN0IHJlc3VsdAogICAgICBpcyBub3QgZWZmZWN0ZWQgYnkgZGlzc29sdmUgb2YgYmxvY2sgcGFn
ZSB0YWJsZSBhdCB0aGUgZWFybHkgc3RhZ2Ugb2YgbWlncmF0aW9uKS4KVk06ICAgMTYgQ1BVIDE2
R0IgUkFNLiBSdW4gNCBwYWlyIG9mIChyZWRpc19iZW5jaG1hcmsrcmVkaXNfc2VydmVyKS4KCkVh
Y2ggcnVuIDUgdGltZXMgZm9yIHNvZnR3YXJlIGRpcnR5IGxvZyBhbmQgU1cvSFcgY29uYmluZWQg
ZGlydHkgbG9nLiAKClRlc3QgcmVzdWx0OgoKR2FpbiA1JX43JSBpbXByb3ZlbWVudCBvZiByZWRp
cyBRUFMgZHVyaW5nIFZNIG1pZ3JhdGlvbi4KVk0gZG93bnRpbWUgaXMgbm90IGFmZmVjdGVkIGZ1
bmRhbWVudGFsbHkuCkFib3V0IDU2LjclIG9mIERCTSBpcyBlZmZlY3RpdmVseSB1c2VkLgoKS2Vx
aWFuIFpodSAoNyk6CiAgYXJtNjQ6IGNwdWZlYXR1cmU6IEFkZCBBUEkgdG8gcmVwb3J0IHN5c3Rl
bSBzdXBwb3J0IG9mIEhXREJNCiAga3ZtOiBhcm02NDogVXNlIGF0b21pYyBvcGVyYXRpb24gd2hl
biB1cGRhdGUgUFRFCiAga3ZtOiBhcm02NDogQWRkIGxldmVsX2FwcGx5IHBhcmFtZXRlciBmb3Ig
c3RhZ2UyX2F0dHJfd2Fsa2VyCiAga3ZtOiBhcm02NDogQWRkIHNvbWUgSFdfREJNIHJlbGF0ZWQg
cGd0YWJsZSBpbnRlcmZhY2VzCiAga3ZtOiBhcm02NDogQWRkIHNvbWUgSFdfREJNIHJlbGF0ZWQg
bW11IGludGVyZmFjZXMKICBrdm06IGFybTY0OiBPbmx5IHdyaXRlIHByb3RlY3Qgc2VsZWN0ZWQg
UFRFCiAga3ZtOiBhcm02NDogU3RhcnQgdXAgU1cvSFcgY29tYmluZWQgZGlydHkgbG9nCgogYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlLmggIHwgIDEyICsrKwogYXJjaC9hcm02NC9p
bmNsdWRlL2FzbS9rdm1faG9zdC5oICAgIHwgICA2ICsrCiBhcmNoL2FybTY0L2luY2x1ZGUvYXNt
L2t2bV9tbXUuaCAgICAgfCAgIDcgKysKIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX3BndGFi
bGUuaCB8ICA0NSArKysrKysrKysrCiBhcmNoL2FybTY0L2t2bS9hcm0uYyAgICAgICAgICAgICAg
ICAgfCAxMjUgKysrKysrKysrKysrKysrKysrKysrKysrKysKIGFyY2gvYXJtNjQva3ZtL2h5cC9w
Z3RhYmxlLmMgICAgICAgICB8IDEzMCArKysrKysrKysrKysrKysrKysrKysrLS0tLS0KIGFyY2gv
YXJtNjQva3ZtL21tdS5jICAgICAgICAgICAgICAgICB8ICA0NyArKysrKysrKystCiBhcmNoL2Fy
bTY0L2t2bS9yZXNldC5jICAgICAgICAgICAgICAgfCAgIDggKy0KIDggZmlsZXMgY2hhbmdlZCwg
MzUxIGluc2VydGlvbnMoKyksIDI5IGRlbGV0aW9ucygtKQoKLS0gCjIuMTkuMQoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
