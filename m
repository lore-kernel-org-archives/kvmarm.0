From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 0/6] QEMU ARM64 Migration Fixes
Date: Wed,  4 Mar 2015 14:35:47 +0000
Message-ID: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A817C47A9F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:30:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0h5LArG-OEUY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 09:30:03 -0500 (EST)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13D3F47A7B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:30:03 -0500 (EST)
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

VGhpcyBpcyBhbiB1cGRhdGUgdG8gdGhlIHNlcmllcyBJIHBvc3RlZCBsYXN0IHdlZWsgYWRkcmVz
c2luZyBzb21lIG9mCnRoZSBjb21tZW50cyBzbyBmYXIuCgpUaGUgbWFpbiBjaGFuZ2VzIHRvIHRo
aXMgc2VyaWVzIGFyZToKCnYyCgogIC0gU2F2ZS9SZXN0b3JlIE1QIFNUQVRFCiAgICAtIG5vIGxv
bmdlciBuZWVkcyBDQVBfTVBfU1RBVEUgYXQgc3RhcnQKICAgIC0gcmUtdXNlcyBjcHUtPnBvd2Vy
ZWRfb2ZmIGZvciBzdG9yaW5nIHN0YXRlIChubyBzdHJlYW0gQUJJIGNoYW5nZSkKICAgIC0ga3Zt
X2VuYWJsZWQoKSBydW50aW1lIGNoZWNrIChhbHRob3VnaCBpb2N0bCBzdGlsbCBpbiAjaWYgZGVm
aW5lZCkKICAtIFNhdmUvUmVzdG9yZSBTUFNSCiAgICAtIHVzZSB0aGUgY29ycmVjdCBiYW5rX251
bWJlciBmb3IgYWFyY2gzMgogICAgLSBvbmx5IHR3ZWFrIFNQU1IgZm9yIGVsZXZhdGVkIGV4Y2Vw
dGlvbiBsZXZlbHMKICAtIGFybV9naXZfa3ZtCiAgICAtIGFkZCBDaHJpc3RvZmZlcidzIEFja2Vk
LWJ5OgoKVGhlIG9ubHkgcXVlc3Rpb24gdXAgaW4gdGhlIGFpciBhdCB0aGUgbW9tZW50IGlzIGRl
ZmluaW5nIGEgbmV3CmNvbnN0YW50IGZvciB0aGUgTVBfU1RBVEUgdG8gcmVwcmVzZW50IHBvd2Vy
ZWQgb2ZmIHdoaWNoIEknbSBnb2luZyB0bwpsb29rIGF0IHdoZW4gSSByZS1zcGluIHRoZSBrZXJu
ZWwgc2VyaWVzLgoKQnJhbmNoOiBodHRwczovL2dpdGh1Yi5jb20vc3RzcXVhZC9xZW11L3RyZWUv
bWlncmF0aW9uL2ZpeGVzLXYzCgpBbGV4IEJlbm7DqWUgKDUpOgogIHRhcmdldC1hcm06IGt2bTog
c2F2ZS9yZXN0b3JlIG1wIHN0YXRlCiAgaHcvaW50YzogYXJtX2dpY19rdm0uYyByZXN0b3JlIGNv
bmZpZyBmaXJzdAogIGh3L2NoYXI6IHBsMDExIGRvbid0IGtlZXAgc2V0dGluZyB0aGUgSVJRIGlm
IG5vdGhpbmcgY2hhbmdlZAogIHRhcmdldC1hcm06IGt2bTY0IHN5bmMgRlAgcmVnaXN0ZXIgc3Rh
dGUKICB0YXJnZXQtYXJtOiBjcHUuaCBkb2N1bWVudCB3aHkgZW52LT5zcHNyIGV4aXN0cwoKQ2hy
aXN0b2ZmZXIgRGFsbCAoMSk6CiAgdGFyZ2V0LWFybToga3ZtNjQgZml4IHNhdmUvcmVzdG9yZSBv
ZiBTUFNSIHJlZ3MKCiBody9jaGFyL3BsMDExLmMgICAgICAgfCAgMTIgKysrKy0tCiBody9pbnRj
L2FybV9naWNfa3ZtLmMgfCAgIDcgKysrLQogdGFyZ2V0LWFybS9jcHUuaCAgICAgIHwgICA1ICsr
KwogdGFyZ2V0LWFybS9rdm02NC5jICAgIHwgMTA5ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLS0tCiB0YXJnZXQtYXJtL21hY2hpbmUuYyAgfCAgMjkgKysr
KysrKysrKysrKysKIDUgZmlsZXMgY2hhbmdlZCwgMTUxIGluc2VydGlvbnMoKyksIDExIGRlbGV0
aW9ucygtKQoKLS0gCjIuMy4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
