From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 2/6] arm_gic_kvm.c: restore config before pending IRQs
Date: Wed, 25 Feb 2015 16:02:34 +0000
Message-ID: <1424880159-29348-3-git-send-email-alex.bennee@linaro.org>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D501468D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Feb 2015 10:57:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4QEyr7a6ewYy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Feb 2015 10:56:59 -0500 (EST)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F341468E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Feb 2015 10:56:59 -0500 (EST)
In-Reply-To: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
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

QXMgdGhlcmUgaXMgbG9naWMgdG8gZGVhbCB3aXRoIHRoZSBkaWZmZXJlbmNlIGJldHdlZW4gZWRn
ZSBhbmQgbGV2ZWwKdHJpZ2dlcmVkIGludGVycnVwdHMgaW4gdGhlIGtlcm5lbCB3ZSBtdXN0IGVu
c3VyZSBpdCBrbm93cyB0aGUKY29uZmlndXJhdGlvbiBvZiB0aGUgSVJRcyBiZWZvcmUgd2UgcmVz
dG9yZSB0aGUgcGVuZGluZyBzdGF0ZS4KClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxl
eC5iZW5uZWVAbGluYXJvLm9yZz4KCmRpZmYgLS1naXQgYS9ody9pbnRjL2FybV9naWNfa3ZtLmMg
Yi9ody9pbnRjL2FybV9naWNfa3ZtLmMKaW5kZXggMWFkM2ViMC4uMmYyMWFlNyAxMDA2NDQKLS0t
IGEvaHcvaW50Yy9hcm1fZ2ljX2t2bS5jCisrKyBiL2h3L2ludGMvYXJtX2dpY19rdm0uYwpAQCAt
MzcwLDYgKzM3MCwxMSBAQCBzdGF0aWMgdm9pZCBrdm1fYXJtX2dpY19wdXQoR0lDU3RhdGUgKnMp
CiAgICAgICogdGhlIGFwcHJvcHJpYXRlIENQVSBpbnRlcmZhY2VzIGluIHRoZSBrZXJuZWwpICov
CiAgICAga3ZtX2Rpc3RfcHV0KHMsIDB4ODAwLCA4LCBzLT5udW1faXJxLCB0cmFuc2xhdGVfdGFy
Z2V0cyk7CiAKKyAgICAvKiBpcnFfc3RhdGVbbl0udHJpZ2dlciAtPiBHSUNEX0lDRkdSbgorICAg
ICAqIChyZXN0b3JlIHRhcmdldHMgYmVmb3JlIHBlbmRpbmcgSVJRcyBzbyB3ZSB0cmVhdCBsZXZl
bC9lZGdlCisgICAgICogY29ycmVjdGx5ICovCisgICAga3ZtX2Rpc3RfcHV0KHMsIDB4YzAwLCAy
LCBzLT5udW1faXJxLCB0cmFuc2xhdGVfdHJpZ2dlcik7CisKICAgICAvKiBpcnFfc3RhdGVbbl0u
cGVuZGluZyArIGlycV9zdGF0ZVtuXS5sZXZlbCAtPiBHSUNEX0lTUEVORFJuICovCiAgICAga3Zt
X2Rpc3RfcHV0KHMsIDB4MjgwLCAxLCBzLT5udW1faXJxLCB0cmFuc2xhdGVfY2xlYXIpOwogICAg
IGt2bV9kaXN0X3B1dChzLCAweDIwMCwgMSwgcy0+bnVtX2lycSwgdHJhbnNsYXRlX3BlbmRpbmcp
OwpAQCAtMzc4LDggKzM4Myw2IEBAIHN0YXRpYyB2b2lkIGt2bV9hcm1fZ2ljX3B1dChHSUNTdGF0
ZSAqcykKICAgICBrdm1fZGlzdF9wdXQocywgMHgzODAsIDEsIHMtPm51bV9pcnEsIHRyYW5zbGF0
ZV9jbGVhcik7CiAgICAga3ZtX2Rpc3RfcHV0KHMsIDB4MzAwLCAxLCBzLT5udW1faXJxLCB0cmFu
c2xhdGVfYWN0aXZlKTsKIAotICAgIC8qIGlycV9zdGF0ZVtuXS50cmlnZ2VyIC0+IEdJQ0RfSUNG
Um4gKi8KLSAgICBrdm1fZGlzdF9wdXQocywgMHhjMDAsIDIsIHMtPm51bV9pcnEsIHRyYW5zbGF0
ZV90cmlnZ2VyKTsKIAogICAgIC8qIHMtPnByaW9yaXR5WFtpcnFdIC0+IElDRF9JUFJJT1JJVFlS
biAqLwogICAgIGt2bV9kaXN0X3B1dChzLCAweDQwMCwgOCwgcy0+bnVtX2lycSwgdHJhbnNsYXRl
X3ByaW9yaXR5KTsKLS0gCjIuMy4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
