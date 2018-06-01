From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/33] arm64: Use update{,_tsk}_thread_flag()
Date: Fri,  1 Jun 2018 16:27:18 +0100
Message-ID: <20180601152747.23613-5-marc.zyngier@arm.com>
References: <20180601152747.23613-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 306404A151
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:17:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IdZugaszD5Vv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jun 2018 11:17:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 100E54A118
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:17:16 -0400 (EDT)
In-Reply-To: <20180601152747.23613-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+CgpUaGlzIHBhdGNoIHVzZXMg
dGhlIG5ldyB1cGRhdGVfdGhyZWFkX2ZsYWcoKSBoZWxwZXJzIHRvIHNpbXBsaWZ5IGEKY291cGxl
IG9mIGlmICgpIHNldDsgZWxzZSBjbGVhcjsgY29uc3RydWN0cy4KCk5vIGZ1bmN0aW9uYWwgY2hh
bmdlLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+ClJl
dmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+CkFja2VkLWJ5
OiBNYXJjIFp5bmdpZXIgPG1hcmMuenluZ2llckBhcm0uY29tPgpBY2tlZC1ieTogQ2F0YWxpbiBN
YXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJtLmNvbT4KQ2M6IFdpbGwgRGVhY29uIDx3aWxsLmRl
YWNvbkBhcm0uY29tPgpTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hcmMuenluZ2llckBh
cm0uY29tPgotLS0KIGFyY2gvYXJtNjQva2VybmVsL2Zwc2ltZC5jIHwgMTggKysrKysrKystLS0t
LS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQuYyBiL2FyY2gvYXJtNjQva2Vy
bmVsL2Zwc2ltZC5jCmluZGV4IDEyZTFjOTY3YzdiNS4uOWQ4NTM3MzJmOWY0IDEwMDY0NAotLS0g
YS9hcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQuYworKysgYi9hcmNoL2FybTY0L2tlcm5lbC9mcHNp
bWQuYwpAQCAtNjE4LDEwICs2MTgsOCBAQCBpbnQgc3ZlX3NldF92ZWN0b3JfbGVuZ3RoKHN0cnVj
dCB0YXNrX3N0cnVjdCAqdGFzaywKIAl0YXNrLT50aHJlYWQuc3ZlX3ZsID0gdmw7CiAKIG91dDoK
LQlpZiAoZmxhZ3MgJiBQUl9TVkVfVkxfSU5IRVJJVCkKLQkJc2V0X3Rza190aHJlYWRfZmxhZyh0
YXNrLCBUSUZfU1ZFX1ZMX0lOSEVSSVQpOwotCWVsc2UKLQkJY2xlYXJfdHNrX3RocmVhZF9mbGFn
KHRhc2ssIFRJRl9TVkVfVkxfSU5IRVJJVCk7CisJdXBkYXRlX3Rza190aHJlYWRfZmxhZyh0YXNr
LCBUSUZfU1ZFX1ZMX0lOSEVSSVQsCisJCQkgICAgICAgZmxhZ3MgJiBQUl9TVkVfVkxfSU5IRVJJ
VCk7CiAKIAlyZXR1cm4gMDsKIH0KQEAgLTkxMCwxMiArOTA4LDEyIEBAIHZvaWQgZnBzaW1kX3Ro
cmVhZF9zd2l0Y2goc3RydWN0IHRhc2tfc3RydWN0ICpuZXh0KQogCQkgKiB0aGUgVElGX0ZPUkVJ
R05fRlBTVEFURSBmbGFnIHNvIHRoZSBzdGF0ZSB3aWxsIGJlIGxvYWRlZAogCQkgKiB1cG9uIHRo
ZSBuZXh0IHJldHVybiB0byB1c2VybGFuZC4KIAkJICovCi0JCWlmIChfX3RoaXNfY3B1X3JlYWQo
ZnBzaW1kX2xhc3Rfc3RhdGUuc3QpID09Ci0JCQkmbmV4dC0+dGhyZWFkLnV3LmZwc2ltZF9zdGF0
ZQotCQkgICAgJiYgbmV4dC0+dGhyZWFkLmZwc2ltZF9jcHUgPT0gc21wX3Byb2Nlc3Nvcl9pZCgp
KQotCQkJY2xlYXJfdHNrX3RocmVhZF9mbGFnKG5leHQsIFRJRl9GT1JFSUdOX0ZQU1RBVEUpOwot
CQllbHNlCi0JCQlzZXRfdHNrX3RocmVhZF9mbGFnKG5leHQsIFRJRl9GT1JFSUdOX0ZQU1RBVEUp
OworCQlib29sIHdyb25nX3Rhc2sgPSBfX3RoaXNfY3B1X3JlYWQoZnBzaW1kX2xhc3Rfc3RhdGUu
c3QpICE9CisJCQkJCSZuZXh0LT50aHJlYWQudXcuZnBzaW1kX3N0YXRlOworCQlib29sIHdyb25n
X2NwdSA9IG5leHQtPnRocmVhZC5mcHNpbWRfY3B1ICE9IHNtcF9wcm9jZXNzb3JfaWQoKTsKKwor
CQl1cGRhdGVfdHNrX3RocmVhZF9mbGFnKG5leHQsIFRJRl9GT1JFSUdOX0ZQU1RBVEUsCisJCQkJ
ICAgICAgIHdyb25nX3Rhc2sgfHwgd3JvbmdfY3B1KTsKIAl9CiB9CiAKLS0gCjIuMTcuMQoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
