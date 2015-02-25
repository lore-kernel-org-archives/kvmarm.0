From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 0/6] QEMU ARM64 Migration Fixes
Date: Wed, 25 Feb 2015 16:02:32 +0000
Message-ID: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B302D468D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Feb 2015 10:56:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id va6pGNZ5xFt4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Feb 2015 10:56:54 -0500 (EST)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 386E846836
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Feb 2015 10:56:53 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

SW4gY29uanVuY3Rpb24gd2l0aCB0aGUga2VybmVsIHBhdGNoIHNlcmllcyBJJ3ZlIGp1c3Qgc2Vu
dDoKCiAgaHR0cDovL3RocmVhZC5nbWFuZS5vcmcvZ21hbmUuY29tcC5lbXVsYXRvcnMua3ZtLmFy
bS5kZXZlbC8xMDEvZm9jdXM9MTAwCgpUaGVzZSBwYXRjaGVzIGhhdmUgYmVlbiBmYWlybHkgaGVh
dmlseSB0ZXN0ZWQgb24gdGhlIHhnZW5lIHN5c3RlbXMKSSd2ZSBnb3QgYWNjZXNzIHRvIGFuZCBJ
J20gcHJldHR5IGNvbmZpZGVudCB3ZSd2ZSBjYXVnaHQgYWxsIHRoZQpjb3JuZXIgY2FzZXMuCgpG
cm9tIFFFTVUncyBwb2ludCBvZiB2aWV3IHRoZSBmaXhlcyBhcmUgZmFpcmx5IHNpbXBsZS4gV2Ug
bmVlZCB0byB0YWtlCmEgbGl0dGxlIGNhcmUgd2hlbiByZXN0b3JpbmcgdGhlIEdJQyB0aGF0IGNv
bmZpZyB0aGF0IGFmZmVjdHMgdGhlCmxhdGVyIHJlc3RvcmF0aW9uIGlzIHJlc3RvcmVkIGZpcnN0
LiBUaGUgcmVzdCB3YXMgc2ltcGx5IG1pc3NpbmcKc2VyaWFsaXNhdGlvbiBjb2RlIGZvciBTUFNS
IGFuZCBGUCByZWdpc3RlcnMuCgpUaGUgcGwwMTEgcGF0Y2ggd2FzIG1haW5seSB0byByZWR1Y2Ug
bm9pc2Ugb24gcmUtYXNzZXJ0aW5nIGxldmVsCnRyaWdnZXJlZCBpbnRlcnJ1cHQgbGluZXMuIEFu
ZCB0aGUgY3B1LmggZG9jdW1lbnRhdGlvbiB3YXMgZm9yIG15IG93bgpzYW5pdHkuCgpDaGVlcnMs
CgpBbGV4LgoKCkFsZXggQmVubsOpZSAoNSk6CiAgdGFyZ2V0LWFybToga3ZtOiBzYXZlL3Jlc3Rv
cmUgbXAgc3RhdGUKICBhcm1fZ2ljX2t2bS5jOiByZXN0b3JlIGNvbmZpZyBiZWZvcmUgcGVuZGlu
ZyBJUlFzCiAgaHcvY2hhci9wbDAxMTogZG9uJ3Qga2VlcCBzZXR0aW5nIHRoZSBJUlEgaWYgbm90
aGluZyBjaGFuZ2VkCiAgdGFyZ2V0LWFybS9rdm02NC5jOiBzeW5jIEZQIHJlZ2lzdGVyIHN0YXRl
CiAgdGFyZ2V0LWFybS9jcHUuaDogZG9jdW1lbnQgd2h5IGVudi0+c3BzciBleGlzdHMKCkNocmlz
dG9mZmVyIERhbGwgKDEpOgogIHRhcmdldC1hcm0va3ZtNjQ6IGZpeCBzYXZlL3Jlc3RvcmUgb2Yg
U1BTUiByZWdzCgogaHcvY2hhci9wbDAxMS5jICAgICAgIHwgIDEyICsrKystLQogaHcvaW50Yy9h
cm1fZ2ljX2t2bS5jIHwgICA3ICsrKy0KIHRhcmdldC1hcm0vY3B1LmggICAgICB8ICAgNSArKysK
IHRhcmdldC1hcm0va3ZtLmMgICAgICB8ICAgMSArCiB0YXJnZXQtYXJtL2t2bTY0LmMgICAgfCAx
MDQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0KIHRh
cmdldC1hcm0vbWFjaGluZS5jICB8ICAzOCArKysrKysrKysrKysrKysrKysKIDYgZmlsZXMgY2hh
bmdlZCwgMTU2IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQoKLS0gCjIuMy4wCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
